
--[[
Train Trails control script © 2023 by asher_sky is licensed under Attribution-NonCommercial-ShareAlike 4.0 International. See LICENSE.txt for additional information
--]]

local constants = require("util.constants")
local speeds = constants.speeds
local original_palettes = constants.original_palettes
local animation_palettes = constants.animation_palettes
local default_chat_colors = constants.default_chat_colors
local balance_to_ticks = constants.balance_to_ticks
local trail_types = constants.trail_types
local active_states = constants.active_states

local train_data_util = require("util.train_data")
local add_active_train = train_data_util.add_active_train
local remove_active_train = train_data_util.remove_active_train
local reset_active_trains = train_data_util.reset_active_trains

local drawing_util = require("util.drawing")
local draw_normalized_trail_segment = drawing_util.draw_normalized_trail_segment

local color_util = require("util.color")
local register_rollingstock_colors = color_util.register_rollingstock_colors

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

---@param event EventData.on_entity_color_changed
local function on_entity_color_changed(event)
  local entity = event.entity
  local type = entity.type
  if type == "locomotive" or type == "cargo-wagon" or type == "fluid-wagon" or type == "artillery-wagon" then
    local train = entity.train
    if train then
      register_rollingstock_colors(train)
    end
  end
end
script.on_event(defines.events.on_entity_color_changed, on_entity_color_changed)

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

local function initialize_and_reset()
  initialize_settings()
  reset_active_trains()
end

script.on_event(defines.events.on_runtime_mod_setting_changed, initialize_and_reset)
script.on_configuration_changed(initialize_and_reset)
script.on_init(initialize_and_reset)

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
