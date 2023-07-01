
--[[
Train Trails control script © 2023 by asher_sky is licensed under Attribution-NonCommercial-ShareAlike 4.0 International. See LICENSE.txt for additional information
--]]

local constants = require("constants")
local speeds = constants.speeds
local original_palettes = constants.original_palettes
local animation_palettes = constants.animation_palettes
local animation_names = constants.animation_names
local pride_flag_names = constants.pride_flag_names
local national_flag_names = constants.national_flag_names
local seasonal_color_names = constants.seasonal_color_names
local natural_palette_names = constants.natural_palette_names
local railway_palette_names = constants.railway_palette_names
local default_chat_colors = constants.default_chat_colors
local balance_to_ticks = constants.balance_to_ticks
local trail_types = constants.trail_types
local active_states = constants.active_states
local random_palette_names = {
  ["random all"] = animation_names,
  ["random pride"] = pride_flag_names,
  ["random country"] = national_flag_names,
  ["random seasonal"] = seasonal_color_names,
  ["random natural"] = natural_palette_names,
  ["random railway"] = railway_palette_names
}

local sin = math.sin
local abs = math.abs
local max = math.max
local floor = math.floor
local random = math.random
local pi_0 = 0 * math.pi / 3
local pi_2 = 2 * math.pi / 3
local pi_4 = 4 * math.pi / 3
local draw_light = rendering.draw_light
local draw_sprite = rendering.draw_sprite

-- gets a random color palette within mod setting restrictions
---@return Color.0|Color.1[]?
local function get_random_palette()
  local mod_settings = global.settings
  local palette_name = mod_settings.palette
  local random_palette_name = random_palette_names[palette_name] and random(#random_palette_names[palette_name]) or nil
  local random_palette = random_palette_name and animation_palettes[random_palette_name] or nil
  return random_palette
end

-- add static data to the active_trains table to reduce lookup time
---@param train LuaTrain
local function add_active_train(train)
  local random_palette = get_random_palette()
  global.active_trains[train.id] = {
    surface_index = train.carriages[1].surface_index,
    train = train,
    id = train.id,
    front_stock = train.front_stock,
    back_stock = train.back_stock,
    random_animation_colors = random_palette,
    random_animation_colors_count = random_palette and #random_palette,
    adjusted_length = global.settings.length + ((#train.carriages - 1) * 30)
  }
end

---@param train LuaTrain
local function remove_active_train(train)
  global.active_trains[train.id] = nil
end

-- add new trains to the active_trains table when they are created
---@param event EventData.on_train_created
local function on_train_created(event)
  local train = event.train
  if active_states[train.state] then
    add_active_train(train)
  end
end

-- add or remove trains from the active_trains table when their state changes
---@param event EventData.on_train_changed_state
local function on_train_changed_state(event)
  local train = event.train
  local is_active = active_states[train.state]
  local was_active = active_states[event.old_state]
  if is_active and not was_active then
    add_active_train(train)
  elseif not is_active then
    remove_active_train(train)
  end
end

script.on_event(defines.events.on_train_created, on_train_created)
script.on_event(defines.events.on_train_changed_state, on_train_changed_state)

-- save mod settings to global to reduce lookup time
local function initialize_settings()
  global.active_trains = global.active_trains or {} ---@type table<uint, train_data>
  global.distance_counters = global.distance_counters or {} ---@type table<uint, number>
  local settings = settings.global
  local palette_name = settings["train-trails-palette"].value --[[@as string]]
  ---@type mod_settings
  global.settings = {
    sprite = trail_types.sprite[ settings["train-trails-color-and-glow"].value --[[@as string]] ],
    light = trail_types.light[ settings["train-trails-color-and-glow"].value --[[@as string]] ],
    length = tonumber(settings["train-trails-length"].value) --[[@as 15|30|60|90|120|180|210|300|600]],
    scale = tonumber(settings["train-trails-scale"].value) --[[@as 1|2|3|4|5|6|8|11|20]],
    color_type = settings["train-trails-color-type"].value --[[@as string]],
    balance = balance_to_ticks[ settings["train-trails-balance"].value --[[@as string]] ],
    passengers_only = settings["train-trails-passengers-only"].value --[[@as boolean]],
    default_color = default_chat_colors[ settings["train-trails-default-color"].value --[[@as string]] ],
    frequency = speeds[ settings["train-trails-speed"].value --[[@as string]] ],
    amplitude = original_palettes[palette_name] and original_palettes[palette_name].amplitude,
    center = original_palettes[palette_name] and original_palettes[palette_name].center,
    animation_colors = animation_palettes[palette_name],
    animation_color_count = animation_palettes[palette_name] and #animation_palettes[palette_name],
    palette = palette_name,
  }
end

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

script.on_event(defines.events.on_runtime_mod_setting_changed, initialize_and_reset)
script.on_configuration_changed(initialize_and_reset)
script.on_init(initialize_and_reset)

---@param created_tick number
---@param mod_settings mod_settings
---@param train_data train_data
---@return Color
local function get_rainbow_color(created_tick, mod_settings, train_data)
  local modifier = (train_data.id + created_tick) * mod_settings.frequency
  local amplitude = mod_settings.amplitude
  local center = mod_settings.center
  local animation_colors = train_data.random_animation_colors or mod_settings.animation_colors
  if amplitude and center then
    return {
      r = sin(modifier + pi_0) * amplitude + center,
      g = sin(modifier + pi_2) * amplitude + center,
      b = sin(modifier + pi_4) * amplitude + center,
      a = 255,
    }
  elseif animation_colors then
    local index = floor(modifier % (mod_settings.animation_color_count or train_data.random_animation_colors_count)) + 1
    return animation_colors[index]
  else
    return { 1, 1, 1 }
  end
end

-- get the color for a given trail
---@param event_tick uint
---@param mod_settings mod_settings
---@param train_data train_data
---@param stock LuaEntity
---@return Color?
local function get_trail_color(event_tick, mod_settings, train_data, stock)
  local default_color = default_chat_colors[mod_settings.default_color]
  local color_type = mod_settings.color_type

  if color_type == "rainbow" then
    return get_rainbow_color(event_tick, mod_settings, train_data)
  elseif color_type == "train" then
    local color = stock.color

    if color then
      return color
    elseif default_color == "rainbow" then
      return get_rainbow_color(event_tick, mod_settings, train_data)
    elseif type(default_color) == "table" then
      return default_color
    end
  end
end

-- draw a trail segment for a given train
---@param event_tick uint
---@param mod_settings mod_settings
---@param train_data train_data
---@param speed number
local function draw_trail_segment(event_tick, mod_settings, train_data, speed)
  local stock = speed > 0 and train_data.front_stock or train_data.back_stock
  if not stock then return end

  local color = get_trail_color(event_tick, mod_settings, train_data, stock)
  if not color then return end

  local position = stock.position
  local surface = train_data.surface_index
  local length = train_data.adjusted_length
  local scale = mod_settings.scale * max(abs(speed), 0.66)

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

-- normalize the number of trails drawn per tile to make trails look consistent at all speeds
---@param event_tick uint
---@param mod_settings mod_settings
---@param train_data train_data
local function draw_normalized_trail_segment(event_tick, mod_settings, train_data)
  local speed = train_data.train.speed -- tiles per tick
  if speed == 0 then return end

  local train_id = train_data.id
  local distance_counters = global.distance_counters
  local tiles_since_last_trail = (distance_counters[train_id] or 0) + abs(speed * mod_settings.balance)

  if tiles_since_last_trail >= 1 / 3 then
    draw_trail_segment(event_tick, mod_settings, train_data, speed)
    tiles_since_last_trail = 0
  end

  global.distance_counters[train_id] = tiles_since_last_trail
end

-- create a lookup table of surfaces that players can see
---@return table<uint, boolean>
local function get_visible_surfaces()
  local visible_surfaces = {}
  for _, player in pairs(game.connected_players) do
    visible_surfaces[player.surface_index] = true
  end
  return visible_surfaces
end

-- draw trail segments for any visible active trains
---@param event_tick uint
---@param mod_settings mod_settings
local function draw_trails(event_tick, mod_settings)
  local sprite = mod_settings.sprite
  local light = mod_settings.light
  if not (sprite or light) then return end

  local active_train_datas = global.active_trains
  if not active_train_datas then return end

  if mod_settings.passengers_only then
    for _, player in pairs(game.connected_players) do
      local train_data = player.vehicle and player.vehicle.train and active_train_datas[player.vehicle.train.id]
      if train_data then
        draw_normalized_trail_segment(event_tick, mod_settings, train_data)
      end
    end
    return
  end
  local visible_surfaces = get_visible_surfaces()
  for train_id, train_data in pairs(active_train_datas) do
    if train_data.train.valid then
      if visible_surfaces[train_data.surface_index] then
        draw_normalized_trail_segment(event_tick, mod_settings, train_data)
      end
    else
      global.active_trains[train_id] = nil
    end
  end
end

---@param event EventData.on_tick
local function on_tick(event)
  local mod_settings = global.settings
  local event_tick = event.tick
  if event_tick % mod_settings.balance == 0 then
    draw_trails(event_tick, mod_settings)
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
---@field color_type string "train"|"rainbow"
---@field balance integer 1|2|3|4
---@field passengers_only boolean
---@field default_color Color|string Color|"nil"|"rainbow"
---@field frequency float 0.010|0.025|0.050|0.100|0.200
---@field amplitude float?
---@field center float?
---@field animation_colors Color[]?
---@field animation_color_count integer?
---@field palette string

---@alias train_data {surface_index: uint, train: LuaTrain, id: uint, front_stock: LuaEntity?, back_stock: LuaEntity?, random_animation_colors: Color[]?, random_animation_colors_count: integer?, adjusted_length: uint}
