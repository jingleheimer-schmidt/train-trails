
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

-- ontick uses this to lookup which on_nth_tick version of the mod to run, based on mod settings
local balance_to_ticks = {
  ["super-pretty"] = 1,
  ["pretty"] = 2,
  ["balanced"] = 3,
  ["performance"] = 4
}

local speed_thresholds = {
  { threshold = 60, delay = 0 },
  { threshold = 30, delay = 1 },
  { threshold = 15, delay = 2 },
  { threshold = 7, delay = 3},
  { threshold = 3, delay = 4 },
  { threshold = 1, delay = 5 },
  { threshold = 0.25, delay = 6 },
  { threshold = 0.125, delay = 7 },
  { threshold = 0.0625, delay = 8 }
}

-- save all these things as local vars so that we don't have to calculate and/or ask the game for them every single time
local sin = math.sin
local abs = math.abs
local max = math.max
local pi_0 = 0 * math.pi / 3
local pi_2 = 2 * math.pi / 3
local pi_4 = 4 * math.pi / 3
local draw_light = rendering.draw_light
local draw_sprite = rendering.draw_sprite

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
  global.train_lengths = {}
  for _, surface in pairs(game.surfaces) do
    for _, train in pairs(surface.get_trains()) do
      global.lua_trains[train.id] = train
      global.train_lengths[train.id] = #train.carriages
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
  local train = event.train
  global.lua_trains = global.lua_trains or {}
  global.lua_trains[train.id] = train
  global.train_lengths = global.train_lengths or {}
  global.train_lengths[train.id] = #train.carriages
end

script.on_event(defines.events.on_train_created, on_train_created)

---@param event_tick uint
---@param mod_settings mod_settings
---@param train_id uint
---@param stock LuaEntity
---@param length uint
---@param scale float
local function draw_trails(event_tick, mod_settings, train_id, stock, length, scale)
  local color = stock.color -- when 1.1.85 becomes stable, this can be replaced with a lookup table that gets updated on_entity_color_changed
  -- since default color locomotives technically have "nil" color, we need to assign those ones some color. so we pick a color, based on mod settings, using the chat colors. this mod default is for "rainbow", so then the next couple lines read that and create the rainbow effect
  if ((not color) and (mod_settings.default_color ~= "nil")) then
    color = default_chat_colors[mod_settings.default_color] --[[@as Color]] -- the mod setting for default loco color
  end
  if ((mod_settings.color_type == "rainbow") or (color == "rainbow") or ((not color) and mod_settings.passengers_only)) then
    color = make_rainbow(event_tick, train_id, mod_settings.frequency, mod_settings.amplitude, mod_settings.center)
  end
  if not color then return end
  local position = stock.position
  local surface = stock.surface
  if mod_settings.sprite then
    draw_sprite {
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
    draw_light {
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

-- this one tries to reduce the weird ballooning and frying that happens when trains go really slowly, by making slower trains draw trails less frequently than faster ones
---@param event_tick uint
---@param mod_settings mod_settings
---@param train LuaTrain
---@param train_id uint
local function draw_trails_based_on_speed(event_tick, mod_settings, train, train_id)
  local speed = train.speed
  if speed == 0 then return end
  local stock = speed < 0 and train.back_stock or train.front_stock
  if not stock then return end
  speed = abs(speed * 216)  -- 216 is the conversion factor between tiles per tick and kilometers per hour

  local delay_counters = global.delay_counters or {}
  local delay_counter = delay_counters[train_id] and delay_counters[train_id] + 1 or 0
  local train_length = global.train_lengths[train_id]
  local length = mod_settings.length + ((train_length - 1) * 15)
  local scale = max(mod_settings.scale * (speed / 216), mod_settings.scale / 1.75)

  for _, threshold in ipairs(speed_thresholds) do
    if abs(speed) >= threshold.threshold and delay_counter >= threshold.delay then
      draw_trails(event_tick, mod_settings, train_id, stock, length, scale)
      delay_counter = 0
      break
    end
  end

  global.delay_counters[train_id] = delay_counter
end

---@param event_tick uint
---@param mod_settings mod_settings
local function make_trails(event_tick, mod_settings)
  local sprite = mod_settings.sprite
  local light = mod_settings.light
  if not (sprite or light) then return end
  global.delay_counters = global.delay_counters or {}
  if mod_settings.passengers_only then -- if passenger mode is on, loop through the players and find their trains instead of looping through the trains to find the players, since there are almost always going to be less players than trains
    for _, player in pairs(game.connected_players) do
      local train = player.vehicle and player.vehicle.train
      if train then
        draw_trails_based_on_speed(event_tick, mod_settings, train, train.id)
      end
    end
  else -- passenger mode is not on. look through all the trains and then start drawing trails
    local trains = global.lua_trains
    if not trains then return end
    for id, train in pairs(trains) do
      if train.valid then
        draw_trails_based_on_speed(event_tick, mod_settings, train, id)
      else
        global.lua_trains[id] = nil
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

---@class mod_settings
---@field sprite boolean
---@field light boolean
---@field length uint 15|30|60|90|120|180|210|300|600
---@field scale float 1|2|3|4|5|6|8|11|20
---@field color_type "train"|"rainbow"
---@field balance uint 1|2|3|4
---@field passengers_only boolean
---@field default_color Color|"rainbow"|"train"
---@field frequency float 0.010|0.025|0.050|0.100|0.200
---@field amplitude float 127.5|15|25|50|55
---@field center float 100|127.5|200|240|50
