
--[[
Trian Trails control script © 2023 by asher_sky is licensed under Attribution-NonCommercial-ShareAlike 4.0 International. See LICENSE.txt for additional information
--]]

---@type table<string, number>
local speeds = {
  veryslow = 0.010,
  slow = 0.025,
  default = 0.050,
  fast = 0.100,
  veryfast = 0.200,
}

---@type table<string, table<string, number>>
local palette = {
  light = {amplitude = 15, center = 240},           -- light
  pastel = {amplitude = 55, center = 200},          -- pastel <3
  default = {amplitude = 127.5, center = 127.5},    -- default (nyan)
  vibrant = {amplitude = 50, center = 100},         -- muted
  deep = {amplitude = 25, center = 50},             -- dark
}

---@type table<string, Color|string>
local default_chat_colors = {
  red = { r = 1.000, g = 0.166, b = 0.141 },
  orange = { r = 1.000, g = 0.630, b = 0.259 },
  yellow = { r = 1.000, g = 0.828, b = 0.231 },
  green = { r = 0.173, g = 0.824, b = 0.250 },
  blue = { r = 0.343, g = 0.683, b = 1.000 },
  purple = { r = 0.821, g = 0.440, b = 0.998 },
  black = { r = 0.1  , g = 0.1  , b = 0.1   },
  white = { r = 0.9  , g = 0.9  , b = 0.9   },
  pink = { r = 1.000, g = 0.520, b = 0.633 },
  gray = { r = 0.7  , g = 0.7  , b = 0.7   },
  cyan = { r = 0.335, g = 0.918, b = 0.866 },
  brown = { r = 0.757, g = 0.522, b = 0.371 },
  acid = { r = 0.708, g = 0.996, b = 0.134 },
  rainbow = "rainbow",
}

---@type table<string, number>
local balance_to_ticks = {
  -- ontick uses this to lookup which on_nth_tick version of the mod to run, based on mod settings
  ['super-pretty'] = 1,
  ['pretty'] = 2,
  ['balanced'] = 3,
  ['performance'] = 4
}

-- save all these things as local vars so that we don't have to calculate and/or ask the game for them every single time
-- local mod_settings
-- local lua_trains
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
  global.settings = {}
  global.settings["train-trails-color"] = settings["train-trails-color"].value --[[@as boolean]]
  global.settings["train-trails-glow"] = settings["train-trails-glow"].value --[[@as boolean]]
  global.settings["train-trails-length"] = settings["train-trails-length"].value --[[@as string]]
  global.settings["train-trails-scale"] = settings["train-trails-scale"].value --[[@as string]]
  global.settings["train-trails-color-type"] = settings["train-trails-color-type"].value --[[@as string]]
  global.settings["train-trails-speed"] = settings["train-trails-speed"].value --[[@as string]]
  global.settings["train-trails-palette"] = settings["train-trails-palette"].value --[[@as string]]
  global.settings["train-trails-balance"] = balance_to_ticks[settings["train-trails-balance"].value] --[[@as string]]
  global.settings["train-trails-passengers-only"] = settings["train-trails-passengers-only"].value --[[@as boolean]]
  global.settings["train-trails-default-color"] = settings["train-trails-default-color"].value --[[@as string]]
  -- mod_settings = global.settings
end

local function reset_trains_global()
  ---@type table<uint, LuaTrain>
  global.lua_trains = {}
  for _, surface in pairs(game.surfaces) do
    for _, train in pairs(surface.get_trains()) do
      global.lua_trains[train.id] = train
    end
  end
  -- lua_trains = global.lua_trains
end

local function initialize_and_reset()
  initialize_settings()
  reset_trains_global()
end

-- local function on_load()
--   mod_settings = global.settings
--   lua_trains = global.lua_trains
-- end

script.on_event(defines.events.on_runtime_mod_setting_changed, initialize_settings)
script.on_configuration_changed(initialize_and_reset)
script.on_init(initialize_and_reset)
-- script.on_load(on_load)

---@param event EventData.on_train_created
local function on_train_created(event)
  global.lua_trains = global.lua_trains or {}
  global.lua_trains[event.train.id] = event.train
  -- lua_trains = global.lua_trains
end

script.on_event(defines.events.on_train_created, on_train_created)

---@param stock LuaEntity
---@param sprite boolean
---@param light boolean
---@param event_tick number
---@param train_id number
---@param passengers_only boolean
---@param color_override string
---@param length uint
---@param scale float
---@param color_type string
---@param frequency number
---@param amplitude number
---@param center number
local function draw_trails(stock, sprite, light, event_tick, train_id, passengers_only, color_override, length, scale, color_type, frequency, amplitude, center)
  local color = stock.color
  -- since default color locomotives technically have "nil" color, we need to assign those ones some color. so we pick a color, based on mod settings, using the chat colors. this mod default is for "rainbow", so then the next couple lines read that and create the rainbow effect
  if ((not color) and (color_override ~= "nil")) then
    color = default_chat_colors[color_override] -- color_override is just the mod setting for default loco color
  end
  if ((color_type == "rainbow") or (color == "rainbow") or ((not color) and passengers_only)) then
    color = make_rainbow(event_tick, train_id, frequency, amplitude, center)
  end
  if color then
    local position = stock.position
    local surface = stock.surface
    if sprite then
      sprite = rendering.draw_sprite{
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
    if light then
      light = rendering.draw_light{
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
---@param event EventData.on_tick
---@param train LuaTrain
---@param sprite boolean
---@param light boolean
---@param color_override string
---@param length number
---@param scale float
---@param color_type string
---@param frequency number
---@param amplitude number
---@param center number
---@param passengers_only boolean
local function draw_trails_based_on_speed(event, train, sprite, light, color_override, length, scale, color_type, frequency, amplitude, center, passengers_only)
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

      if not global.delay_counter then
        global.delay_counter = {}
      end

      if not global.delay_counter[train_id] then
        global.delay_counter[train_id] = 0
      end

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

---@param settings table
---@param event EventData.on_tick
local function make_trails(settings, event)
  -- first we create or get our settings
  local sprite = settings["train-trails-color"]
  local light = settings["train-trails-glow"]
  -- then we make any new lights or sprites as needed
  if sprite or light then
    local passengers_only = settings["train-trails-passengers-only"]
    local color_override = settings["train-trails-default-color"]
    local length = tonumber(settings["train-trails-length"])
    local scale = tonumber(settings["train-trails-scale"])
    local color_type = settings["train-trails-color-type"]
    local frequency = speeds[settings["train-trails-speed"]]
    local palette_key = settings["train-trails-palette"]
    local amplitude = palette[palette_key].amplitude
    local center = palette[palette_key].center
    --[[ if passenger mode is on, loop through the players and find their trains instead of looping through the trains to find the players, since there are almost always going to be less players than trains --]]
    if passengers_only then
      for _, player in pairs(game.connected_players) do
        if player.vehicle and player.vehicle.train then
          local train = player.vehicle.train
          draw_trails_based_on_speed(event, train, sprite, light, color_override, length, scale, color_type, frequency, amplitude, center, passengers_only)
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
          draw_trails_based_on_speed(event, train, sprite, light, color_override, length, scale, color_type, frequency, amplitude, center, passengers_only)
        end
      end
    end
  end
end

---@param event EventData.on_tick
local function on_tick(event)
  local mod_settings = global.settings
  if event.tick % mod_settings["train-trails-balance"] == 0 then
    make_trails(mod_settings, event)
  end
end

if not script.active_mods["trains-rights"] then
  script.on_event(defines.events.on_tick, on_tick)
end
