
--[[
Trian Trails control script © 2023 by asher_sky is licensed under Attribution-NonCommercial-ShareAlike 4.0 International. See LICENSE.txt for additional information
--]]

local speeds = {
  ["veryslow"] = 0.010,
  ["slow"] = 0.025,
  ["default"] = 0.050,
  ["fast"] = 0.100,
  ["veryfast"] = 0.200,
}

local palette = {
  ["light"] = {amplitude = 15, center = 240},
  ["pastel"] = {amplitude = 55, center = 200},
  ["default"] = {amplitude = 127.5, center = 127.5},
  ["vibrant"] = {amplitude = 50, center = 100},
  ["deep"] = {amplitude = 25, center = 50},
}

local default_chat_colors = {
  ["red"] = { r = 1.000, g = 0.166, b = 0.141 } --[[@type Color]],
  ["orange"] = { r = 1.000, g = 0.630, b = 0.259 } --[[@type Color]],
  ["yellow"] = { r = 1.000, g = 0.828, b = 0.231 } --[[@type Color]],
  ["green"] = { r = 0.173, g = 0.824, b = 0.250 } --[[@type Color]],
  ["blue"] = { r = 0.343, g = 0.683, b = 1.000 } --[[@type Color]],
  ["purple"] = { r = 0.821, g = 0.440, b = 0.998 } --[[@type Color]],
  ["black"] = { r = 0.1, g = 0.1, b = 0.1 } --[[@type Color]],
  ["white"] = { r = 0.9, g = 0.9, b = 0.9 } --[[@type Color]],
  ["pink"] = { r = 1.000, g = 0.520, b = 0.633 } --[[@type Color]],
  ["gray"] = { r = 0.7, g = 0.7, b = 0.7 } --[[@type Color]],
  ["cyan"] = { r = 0.335, g = 0.918, b = 0.866 } --[[@type Color]],
  ["brown"] = { r = 0.757, g = 0.522, b = 0.371 } --[[@type Color]],
  ["acid"] = { r = 0.708, g = 0.996, b = 0.134 } --[[@type Color]],
  ["rainbow"] = "rainbow",
  ["nil"] = "nil",
}

local balance_to_ticks = {
  -- ontick uses this to lookup which on_nth_tick version of the mod to run, based on mod settings
  ["super-pretty"] = 1,
  ["pretty"] = 2,
  ["balanced"] = 3,
  ["performance"] = 4
}

-- save all these things as local vars so that we don't have to calculate and/or ask the game for them every single time
local sin = math.sin
local pi_0 = 0 * math.pi / 3
local pi_2 = 2 * math.pi / 3
local pi_4 = 4 * math.pi / 3

---@param created_tick number
---@param train_id number
---@param frequency number
---@param amplitude number
---@param center number
---@return Color
local function make_rainbow(created_tick, train_id, frequency, amplitude, center)
  local modifier = (train_id + created_tick) * frequency
  return {
    r = sin(modifier + pi_0) * amplitude + center,
    g = sin(modifier + pi_2) * amplitude + center,
    b = sin(modifier + pi_4) * amplitude + center,
    a = 255,
  }
end

-- save mod settings to global so we don't have to ask the game for them all the time
local function initialize_settings()
  local settings = settings.global
  global.settings = {
    sprite = settings["train-trails-color"].value --[[@as boolean]],
    light = settings["train-trails-glow"].value --[[@as boolean]],
    length = tonumber(settings["train-trails-length"].value) --[[@as 15|30|60|90|120|180|210|300|600]],
    scale = tonumber(settings["train-trails-scale"].value) --[[@as 1|2|3|4|5|6|8|11|20]],
    color_type = settings["train-trails-color-type"].value --[[@as "rainbow"|"train"]],
    balance = balance_to_ticks[settings["train-trails-balance"].value --[[@as string]]],
    passengers_only = settings["train-trails-passengers-only"].value --[[@as boolean]],
    default_color = default_chat_colors[settings["train-trails-default-color"].value --[[@as string]]],
    frequency = speeds[settings["train-trails-speed"].value --[[@as string]]],
    amplitude = palette[settings["train-trails-palette"].value --[[@as string]]].amplitude,
    center = palette[settings["train-trails-palette"].value --[[@as string]]].center,
  }
end

local function reset_trains_global()
  ---@type table<uint, LuaTrain>
  global.lua_trains = {}
  for _, surface in pairs(game.surfaces) do
    for _, train in pairs(surface.get_trains()) do
      global.lua_trains[train.id] = train
    end
  end
end

local function initialize_and_reset()
  initialize_settings()
  reset_trains_global()
end

script.on_event(defines.events.on_runtime_mod_setting_changed, initialize_settings)
script.on_configuration_changed(initialize_and_reset)
script.on_init(initialize_and_reset)

---@param event EventData.on_train_created
local function on_train_created(event)
  global.lua_trains = global.lua_trains or {}
  global.lua_trains[event.train.id] = event.train
end

script.on_event(defines.events.on_train_created, on_train_created)

---@param event_tick uint
---@param mod_settings mod_settings
---@param stock LuaEntity
---@param train_id uint
---@param length uint
local function draw_trails(event_tick, mod_settings, stock, train_id, length)
  local color = stock.color
  -- since default color locomotives technically have "nil" color, we need to assign those ones some color. so we pick a color, based on mod settings, using the chat colors. this mod default is for "rainbow", so then the next couple lines read that and create the rainbow effect
  if ((not color) and (mod_settings.default_color ~= "nil")) then
    color = default_chat_colors[mod_settings.default_color] --[[@as Color]] -- the mod setting for default loco color
  end
  if ((mod_settings.color_type == "rainbow") or (color == "rainbow") or ((not color) and mod_settings.passengers_only)) then
    color = make_rainbow(event_tick, train_id, mod_settings.frequency, mod_settings.amplitude, mod_settings.center)
  end
  if not color then return end
  if mod_settings.sprite then
    local position = stock.position
    local surface = stock.surface
    local scale = mod_settings.scale
    if mod_settings.sprite then
      rendering.draw_sprite{
        sprite = "train-trail",
        target = position,
        surface = surface,
        tint = color,
        x_scale = scale,
        y_scale = scale,
        render_layer = "radius-visualization",
        time_to_live = length,
      }
    end
    if mod_settings.light then
      rendering.draw_light{
        sprite = "train-trail",
        target = position,
        surface = surface,
        color = color,
        intensity = .175,
        scale = scale * 1.75,
        render_layer = "light-effect",
        time_to_live = length,
      }
    end
  end
end

-- this one tries to reduce the weird ballooning and frying that happens when trains go really slowly, by making slower trains draw trails less frequently than faster ones
---@param event_tick uint
---@param mod_settings mod_settings
---@param train LuaTrain
local function draw_trails_based_on_speed(event_tick, mod_settings, train)
  local speed = train.speed
  if speed ~= 0 then
    local stock = speed < 0 and train.back_stock or train.front_stock
    if stock then
      local event_tick = event.tick
      local train_id = train.id
      speed = speed * 216  -- Conversion factor between tiles per tick and kilometers per hour

      local speed_thresholds = {
        { threshold = 105, delay = 0 },
        { threshold = 65, delay = 1 },
        { threshold = 40, delay = 2 },
        { threshold = 25, delay = 2 },
        { threshold = 15, delay = 3 },
        { threshold = 10, delay = 3 },
        { threshold = 5, delay = 4 },
      }

      global.delay_counter = global.delay_counter or {}
      global.delay_counter[train_id] = global.delay_counter[train_id] or 0

      local delay_counter = global.delay_counter[train_id] + 1
      local light_delay_counter = delay_counter
      local sprite_delay_counter = delay_counter
      local train_length = #train.carriages
      length = length + ((train_length - 1) * 15)

      if sprite then
        local light_override = false

        for _, threshold in ipairs(speed_thresholds) do
          if math.abs(speed) >= threshold.threshold and delay_counter >= threshold.delay then
            draw_trails(stock, sprite, light_override, event_tick, train_id, passengers_only, color_override, length, scale, color_type, frequency, amplitude, center)
            sprite_delay_counter = 0
            break
          end
        end
      end

      if light then
        local sprite_override = false

        for _, threshold in ipairs(speed_thresholds) do
          if math.abs(speed) >= threshold.threshold and delay_counter >= threshold.delay then
            draw_trails(stock, sprite_override, light, event_tick, train_id, passengers_only, color_override, length, scale, color_type, frequency, amplitude, center)
            light_delay_counter = 0
            break
          end
        end
      end

      if sprite and light then
        delay_counter = sprite_delay_counter
      elseif sprite then
        delay_counter = sprite_delay_counter
      elseif light then
        delay_counter = light_delay_counter
      end

      global.delay_counter[train_id] = delay_counter
    end
  end
end

---@param event_tick uint
---@param mod_settings mod_settings
local function make_trails(event_tick, mod_settings)
  -- first we create or get our settings
  local sprite = mod_settings.sprite
  local light = mod_settings.light
  -- then we make any new lights or sprites as needed
  if sprite or light then
    -- local palette_key = mod_settings.palette
    -- local passengers_only = mod_settings.passengers_only
    -- local processed_settings_data = { ---@type processed_settings_data
    --   sprite = sprite,
    --   light = light,
    --   passengers_only = passengers_only,
    --   color_override = mod_settings.default_color,
    --   length = tonumber(mod_settings.length),
    --   scale = tonumber(mod_settings.scale),
    --   color_type = mod_settings.color_type,
    --   frequency = speeds[mod_settings.speed],
    --   amplitude = palette[palette_key].amplitude,
    --   center = palette[palette_key].center,
    -- }
    --[[ if passenger mode is on, loop through the players and find their trains instead of looping through the trains to find the players, since there are almost always going to be less players than trains --]]
    if mod_settings.passengers_only then
      for _, player in pairs(game.connected_players) do
        local train = player.vehicle and player.vehicle.train
        if train then
          draw_trails_based_on_speed(event_tick, mod_settings, train)
        end
      end
    --[[ passenger mode is not on. look through all the trains and then start drawing trails --]]
    else
      local trains = global.lua_trains
      if not trains then return end
      for id, train in pairs(trains) do
        if not train.valid then
          global.lua_trains[id] = nil
        else
          draw_trails_based_on_speed(event_tick, mod_settings, train)
        end
      end
    end
  end
end

---@param event EventData.on_tick
local function on_tick(event)
  local mod_settings = global.settings
  local event_tick = event.tick
  if event_tick % mod_settings.balance == 0 then
    make_trails(event_tick, mod_settings)
  end
end

if not script.active_mods["trains-rights"] then
  script.on_event(defines.events.on_tick, on_tick)
end

---@class train_trails_settings
  ---@field color boolean
  ---@field glow boolean
  ---@field length string
  ---@field scale string
  ---@field color_type string
  ---@field speed string
  ---@field palette string
  ---@field balance uint
  ---@field passengers_only boolean
  ---@field default_color string
