
--[[
Trian Trails control script © 2023 by asher_sky is licensed under Attribution-NonCommercial-ShareAlike 4.0 International. See LICENSE.txt for additional information
--]]

local speeds = {
  veryslow = 0.010,
  slow = 0.025,
  default = 0.050,
  fast = 0.100,
  veryfast = 0.200,
}

local palette = {
  light = {amplitude = 15, center = 240},           -- light
  pastel = {amplitude = 55, center = 200},          -- pastel <3
  default = {amplitude = 127.5, center = 127.5},    -- default (nyan)
  vibrant = {amplitude = 50, center = 100},         -- muted
  deep = {amplitude = 25, center = 50},             -- dark
}

local default_player_colors = {
  red = { r = 0.815, g = 0.024, b = 0.0  , a = 0.5 },
  orange = { r = 0.869, g = 0.5  , b = 0.130, a = 0.5 },
  yellow = { r = 0.835, g = 0.666, b = 0.077, a = 0.5 },
  green = { r = 0.093, g = 0.768, b = 0.172, a = 0.5 },
  blue = { r = 0.155, g = 0.540, b = 0.898, a = 0.5 },
  purple = { r = 0.485, g = 0.111, b = 0.659, a = 0.5 },
  black = { r = 0.1  , g = 0.1  , b = 0.1,   a = 0.5 },
  white = { r = 0.8  , g = 0.8  , b = 0.8  , a = 0.5 },
  pink = { r = 0.929, g = 0.386, b = 0.514, a = 0.5 },
  gray = { r = 0.4  , g = 0.4  , b = 0.4,   a = 0.5 },
  cyan = { r = 0.275, g = 0.755, b = 0.712, a = 0.5 },
  brown = { r = 0.300, g = 0.117, b = 0.0,   a = 0.5 },
  acid = { r = 0.559, g = 0.761, b = 0.157, a = 0.5 },
  rainbow = "rainbow",
}

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

local balance_to_ticks = {
  -- ontick uses this to lookup which on_nth_tick version of the mod to run, based on mod settings
  ['super-pretty'] = 1,
  ['pretty'] = 2,
  ['balanced'] = 3,
  ['performance'] = 4
}

-- save all these things as local vars so that we don't have to calculate and/or ask the game for them every single time
local mod_settings
local lua_trains
local sin = math.sin
local pi_0 = 0 * math.pi / 3
local pi_2 = 2 * math.pi / 3
local pi_4 = 4 * math.pi / 3

---@param created_tick number
---@param train_id number
---@param settings table<string, ModSetting>
---@param frequency number
---@param amplitude number
---@param center number
---@return Color
local function make_rainbow(created_tick, train_id, settings, frequency, amplitude, center)
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
  mod_settings = global.settings
end

local function reset_trains_global()
  ---@type table<uint, LuaTrain>
  global.lua_trains = {}
  for _, surface in pairs(game.surfaces) do
    for _, train in pairs(surface.get_trains()) do
      global.lua_trains[train.id] = train
    end
  end
  lua_trains = global.lua_trains
end
--
-- local function trains_rights()
--   -- turn off the main script if the trans trails mod is active so that this one doesn't crash and cause problems, trans trails mod will handle everything :)
--   if game.active_mods["trains-rights"] then
--     script.on_event(defines.events.on_tick, nil)
--   end
-- end

script.on_event(defines.events.on_runtime_mod_setting_changed, function()
  initialize_settings()
end)

script.on_configuration_changed(function()
  initialize_settings()
  reset_trains_global()
  -- trains_rights()
end)

script.on_init(function()
  initialize_settings()
  reset_trains_global()
  -- trains_rights()
end)

script.on_load(function()
  mod_settings = global.settings
  lua_trains = global.lua_trains
end)

script.on_event(defines.events.on_train_created, function(event)
  if not global.lua_trains then
    global.lua_trains = {}
  end
  global.lua_trains[event.train.id] = event.train
  if event.old_train_id_1 then
    global.lua_trains[event.old_train_id_1] = nil
  end
  if event.old_train_id_2 then
    global.lua_trains[event.old_train_id_2] = nil
  end
  lua_trains = global.lua_trains
end)

---@param settings table<string, ModSetting>
---@param stock LuaEntity
---@param sprite boolean
---@param light boolean
---@param event_tick number
---@param train_id number
---@param passengers_only boolean
---@param color_override any
---@param length any
---@param scale any
---@param color_type any
---@param frequency any
---@param amplitude any
---@param center any
local function draw_trails(settings, stock, sprite, light, event_tick, train_id, passengers_only, color_override, length, scale, color_type, frequency, amplitude, center)
  local color = stock.color
  -- since default color locomotives technically have "nil" color, we need to assign those ones some color. so we pick a color, based on mod settings, using the chat colors. this mod default is for "rainbow", so then the next couple lines read that and create the rainbow effect
  if ((not color) and (color_override ~= "nil")) then
    color = default_chat_colors[color_override] -- color_override is just the mod setting for default loco color
  end
  if ((color_type == "rainbow") or (color == "rainbow") or ((not color) and passengers_only)) then
    color = make_rainbow(event_tick, train_id, settings, frequency, amplitude, center)
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
---@param settings table<string, ModSetting>
---@param sprite boolean
---@param light boolean
---@param color_override any
---@param length any
---@param scale any
---@param color_type any
---@param frequency any
---@param amplitude any
---@param center any
---@param passengers_only any
local function draw_trails_based_on_speed(event, train, settings, sprite, light, color_override, length, scale, color_type, frequency, amplitude, center, passengers_only)
  local speed = train.speed
  if not (speed == 0) then
    local stock = false
    if speed < 0 then
      stock = train.back_stock
    elseif speed > 0 then
      stock = train.front_stock
    end
    if stock then
      local event_tick = event.tick
      local train_id = train.id
      speed = speed * 216
      --[[
      216 is the conversion factor between tiles per tick and kilometers per hour; 60 * 3600 / 1000
      --]]

      -- local speed_less_than_200 = ((speed < 200) and (speed > 0)) or ((speed > -200) and (speed < 0))
      -- local speed_less_than_150 = ((speed < 150) and (speed > 0)) or ((speed > -150) and (speed < 0))
      local speed_less_than_105 = ((speed < 105) and (speed > 0)) or ((speed > -105) and (speed < 0))
      local speed_less_than_65 = ((speed < 65) and (speed > 0)) or ((speed > -65) and (speed < 0))
      local speed_less_than_40 = ((speed < 40) and (speed > 0)) or ((speed > -40) and (speed < 0))
      local speed_less_than_25 = ((speed < 25) and (speed > 0)) or ((speed > -25) and (speed < 0))
      local speed_less_than_15 = ((speed < 15) and (speed > 0)) or ((speed > -15) and (speed < 0))
      local speed_less_than_10 = ((speed < 10) and (speed > 0)) or ((speed > -10) and (speed < 0))
      local speed_less_than_05 = ((speed < 05) and (speed > 0)) or ((speed > -05) and (speed < 0))
      -- game.print(speed)
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
      -- global.delay_counter[train_id] = delay_counter
      if sprite then
        local light_override = false
        -- draw_trails(settings, stock, sprite, light_override, event_tick, train_id, passengers_only, color_override, length, scale, color_type, frequency, amplitude, center)
        if (not speed_less_than_105) then
          draw_trails(settings, stock, sprite, light_override, event_tick, train_id, passengers_only, color_override, length, scale, color_type, frequency, amplitude, center)
          -- game.print(game.tick.." speed > 105")
          -- game.print(game.tick.." delay counter: "..delay_counter)
          sprite_delay_counter = 0
        elseif (not speed_less_than_65) and speed_less_than_105 and (delay_counter >= 1) then
          draw_trails(settings, stock, sprite, light_override, event_tick, train_id, passengers_only, color_override, length, scale, color_type, frequency, amplitude, center)
          -- game.print(game.tick.." speed between 65 and 105")
          -- game.print(game.tick.." delay counter: "..delay_counter)
          sprite_delay_counter = 0
        elseif (not speed_less_than_40) and speed_less_than_65 and (delay_counter >= 2) then
          draw_trails(settings, stock, sprite, light_override, event_tick, train_id, passengers_only, color_override, length, scale, color_type, frequency, amplitude, center)
          -- game.print(game.tick.." speed between 40 and 65")
          -- game.print(game.tick.." delay counter: "..delay_counter)
          sprite_delay_counter = 0
        elseif (not speed_less_than_25) and speed_less_than_40 and (delay_counter >= 2) then
          draw_trails(settings, stock, sprite, light_override, event_tick, train_id, passengers_only, color_override, length, scale, color_type, frequency, amplitude, center)
          -- game.print(game.tick.." speed between 25 and 40")
          -- game.print(game.tick.." delay counter: "..delay_counter)
          sprite_delay_counter = 0
        elseif (not speed_less_than_15) and speed_less_than_25 and (delay_counter >= 3) then
          draw_trails(settings, stock, sprite, light_override, event_tick, train_id, passengers_only, color_override, length, scale, color_type, frequency, amplitude, center)
          -- game.print(game.tick.." speed between 15 and 25")
          -- game.print(game.tick.." delay counter: "..delay_counter)
          sprite_delay_counter = 0
        elseif (not speed_less_than_10) and speed_less_than_15 and (delay_counter >= 3) then
          draw_trails(settings, stock, sprite, light_override, event_tick, train_id, passengers_only, color_override, length, scale, color_type, frequency, amplitude, center)
          -- game.print(game.tick.." speed between 10 and 15")
          -- game.print(game.tick.." delay counter: "..delay_counter)
          sprite_delay_counter = 0
        elseif (not speed_less_than_05) and speed_less_than_10 and (delay_counter >= 4) then
          draw_trails(settings, stock, sprite, light_override, event_tick, train_id, passengers_only, color_override, length, scale, color_type, frequency, amplitude, center)
          -- game.print(game.tick.." speed less than 10")
          -- game.print(game.tick.." delay counter: "..delay_counter)
          sprite_delay_counter = 0
        elseif speed_less_than_05 and (delay_counter >= 4) then
          draw_trails(settings, stock, sprite, light_override, event_tick, train_id, passengers_only, color_override, length, scale, color_type, frequency, amplitude, center)
          -- game.print(game.tick.." speed less than 05")
          -- game.print(game.tick.." delay counter: "..delay_counter)
          sprite_delay_counter = 0
        end
      end
      if light then
        local sprite_override = false
        if (not speed_less_than_105) then
          draw_trails(settings, stock, sprite_override, light, event_tick, train_id, passengers_only, color_override, length, scale, color_type, frequency, amplitude, center)
          light_delay_counter = 0
        elseif (not speed_less_than_65) and speed_less_than_105 and (delay_counter >= 1) then
          draw_trails(settings, stock, sprite_override, light, event_tick, train_id, passengers_only, color_override, length, scale, color_type, frequency, amplitude, center)
          light_delay_counter = 0
        elseif (not speed_less_than_40) and speed_less_than_65 and (delay_counter >= 2) then
          draw_trails(settings, stock, sprite_override, light, event_tick, train_id, passengers_only, color_override, length, scale, color_type, frequency, amplitude, center)
          light_delay_counter = 0
        elseif (not speed_less_than_25) and speed_less_than_40 and (delay_counter >= 2) then
          draw_trails(settings, stock, sprite_override, light, event_tick, train_id, passengers_only, color_override, length, scale, color_type, frequency, amplitude, center)
          light_delay_counter = 0
        elseif (not speed_less_than_15) and speed_less_than_25 and (delay_counter >= 3) then
          draw_trails(settings, stock, sprite_override, light, event_tick, train_id, passengers_only, color_override, length, scale, color_type, frequency, amplitude, center)
          light_delay_counter = 0
        elseif (not speed_less_than_10) and speed_less_than_15 and (delay_counter >= 3) then
          draw_trails(settings, stock, sprite_override, light, event_tick, train_id, passengers_only, color_override, length, scale, color_type, frequency, amplitude, center)
          light_delay_counter = 0
        elseif (not speed_less_than_05) and speed_less_than_10 and (delay_counter >= 4) then
          draw_trails(settings, stock, sprite_override, light, event_tick, train_id, passengers_only, color_override, length, scale, color_type, frequency, amplitude, center)
          light_delay_counter = 0
        elseif speed_less_than_05 and (delay_counter >= 4) then
          draw_trails(settings, stock, sprite_override, light, event_tick, train_id, passengers_only, color_override, length, scale, color_type, frequency, amplitude, center)
          light_delay_counter = 0
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
          draw_trails_based_on_speed(event, train, settings, sprite, light, color_override, length, scale, color_type, frequency, amplitude, center, passengers_only)
        end
      end
    --[[ passenger mode is not on. look through all the trains and then start drawing trails --]]
    else
      -- local trains = global.lua_trains
      local trains = lua_trains -- unsure if this is necessary...
      if not trains then return end
      for id, train in pairs(trains) do
        if not train.valid then
          global.lua_trains[id] = nil
        else
          draw_trails_based_on_speed(event, train, settings, sprite, light, color_override, length, scale, color_type, frequency, amplitude, center, passengers_only)
        end
      end
    end
  end
end

if not script.active_mods["trains-rights"] then
  script.on_event(defines.events.on_tick, function(event)
    if event.tick % mod_settings["train-trails-balance"] == 0 then
      make_trails(mod_settings, event)
    end
  end)
end
