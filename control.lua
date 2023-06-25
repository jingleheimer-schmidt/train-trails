
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
  ["light"] = { amplitude = 15, center = 240 },
  ["pastel"] = { amplitude = 55, center = 200 },
  ["default"] = { amplitude = 127.5, center = 127.5 },
  ["vibrant"] = { amplitude = 50, center = 100 },
  ["deep"] = { amplitude = 25, center = 50 },
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

local active_states = {
  [defines.train_state.arrive_signal] = true,
  [defines.train_state.arrive_station] = true,
  [defines.train_state.destination_full] = false,
  [defines.train_state.manual_control] = true,
  [defines.train_state.manual_control_stop] = true,
  [defines.train_state.no_path] = false,
  [defines.train_state.no_schedule] = false,
  [defines.train_state.on_the_path] = true,
  [defines.train_state.path_lost] = true,
  [defines.train_state.wait_signal] = false,
  [defines.train_state.wait_station] = false,
}

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
    balance = balance_to_ticks[ settings["train-trails-balance"].value --[[@as string]] ],
    passengers_only = settings["train-trails-passengers-only"].value --[[@as boolean]],
    default_color = default_chat_colors[ settings["train-trails-default-color"].value --[[@as string]] ],
    frequency = speeds[ settings["train-trails-speed"].value --[[@as string]] ],
    amplitude = palette[ settings["train-trails-palette"].value --[[@as string]] ].amplitude,
    center = palette[ settings["train-trails-palette"].value --[[@as string]] ].center,
  }
end

---@param train LuaTrain
local function add_active_train(train)
  local train_id = train.id
  global.active_trains = global.active_trains or {} ---@type table<uint, train_data>
  global.active_trains[train_id] = {
    length = #train.carriages,
    surface_index = train.carriages[1].surface_index,
    train = train,
    id = train.id,
    front_stock = train.front_stock,
    back_stock = train.back_stock,
  }
end

---@param train LuaTrain
local function remove_active_train(train)
  global.active_trains = global.active_trains or {}
  global.active_trains[train.id] = nil
end

---@param event EventData.on_train_changed_state
local function on_train_changed_state(event)
  local train = event.train
  if active_states[train.state] then
    add_active_train(train)
  else
    remove_active_train(train)
  end
end

script.on_event(defines.events.on_train_changed_state, on_train_changed_state)

local function reset_active_trains()
  for _, surface in pairs(game.surfaces) do
    for _, train in pairs(surface.get_trains()) do
      if active_states[train.state] then
        add_active_train(train)
      end
    end
  end
end

local function initialize_and_reset()
  initialize_settings()
  reset_active_trains()
end

script.on_event(defines.events.on_runtime_mod_setting_changed, initialize_settings)
script.on_configuration_changed(initialize_and_reset)
script.on_init(initialize_and_reset)

---@param event EventData.on_train_created
local function on_train_created(event)
  local train = event.train
  if active_states[train.state] then
    add_active_train(train)
  end
end

script.on_event(defines.events.on_train_created, on_train_created)

---@param event_tick uint
---@param mod_settings mod_settings
---@param train_data train_data
---@param stock LuaEntity
---@param length uint
---@param scale float
local function draw_trails(event_tick, mod_settings, train_data, stock, length, scale)
  local color = stock.color -- when 1.1.85 becomes stable, replace with a lookup table updated on_entity_color_changed
  -- since default color locomotives have "nil" color, we need to pick a color
  if ((not color) and (mod_settings.default_color ~= "nil")) then
    color = default_chat_colors[mod_settings.default_color] --[[@as Color]] -- the mod setting for default loco color
  end
  if ((mod_settings.color_type == "rainbow") or (color == "rainbow") or ((not color) and mod_settings.passengers_only)) then
    color = make_rainbow(event_tick, train_data.id, mod_settings.frequency, mod_settings.amplitude, mod_settings.center)
  end
  if not color then return end
  local position = stock.position
  local surface = train_data.surface_index
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
---@param train_data train_data
local function draw_normalized_trails(event_tick, mod_settings, train_data)
  local train = train_data.train
  local speed = train.speed
  if speed == 0 then return end
  local stock = speed > 0 and train.front_stock or train.back_stock
  if not stock then return end
  speed = abs(speed)

  local train_id = train_data.id
  local delay_counters = global.delay_counters or {}
  local tiles_since_last_trail = delay_counters[train_id] and delay_counters[train_id] + speed or speed
  local tiles_per_trail = 1/3
  local length = mod_settings.length + ((train_data.length - 1) * 60)
  local scale = max(mod_settings.scale * speed, mod_settings.scale * 0.5)

  if tiles_since_last_trail >= tiles_per_trail then
    draw_trails(event_tick, mod_settings, train_data, stock, length, scale)
    tiles_since_last_trail = 0
  end

  global.delay_counters[train_id] = tiles_since_last_trail
end

---@return table<uint, boolean>
local function get_visible_surfaces()
  local visible_surfaces = {}
  for _, player in pairs(game.connected_players) do
    visible_surfaces[player.surface_index] = true
  end
  return visible_surfaces
end

---@param event_tick uint
---@param mod_settings mod_settings
local function make_trails(event_tick, mod_settings)
  local sprite = mod_settings.sprite
  local light = mod_settings.light
  if not (sprite or light) then return end
  local active_train_datas = global.active_trains
  if not active_train_datas then return end
  global.delay_counters = global.delay_counters or {}
  if mod_settings.passengers_only then
    for _, player in pairs(game.connected_players) do
      local train = player.vehicle and player.vehicle.train
      local train_data = train and active_train_datas and active_train_datas[train.id]
      if train_data then
        draw_normalized_trails(event_tick, mod_settings, train_data)
      end
    end
  else
    local visible_surfaces = get_visible_surfaces()
    for train_id, train_data in pairs(active_train_datas) do
      if train_data.train.valid then
        if not visible_surfaces[train_data.surface_index] then break end
        draw_normalized_trails(event_tick, mod_settings, train_data)
      else
        global.active_trains[train_id] = nil
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

---@alias train_data {length: int, surface_index: uint, train: LuaTrain, id: uint, front_stock: LuaEntity?, back_stock: LuaEntity?}
