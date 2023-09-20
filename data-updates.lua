
local func_capture = require("__simhelper__.funccapture")

local constants = require("util.constants")
local speeds = constants.speeds
local original_palettes = constants.original_palettes
local animation_palettes = constants.animation_palettes
local default_chat_colors = constants.default_chat_colors
local balance_to_ticks = constants.balance_to_ticks
local trail_types = constants.trail_types
local active_states = constants.active_states

local drawing_util = require("util.drawing")
local draw_normalized_trail_segment = drawing_util.draw_normalized_trail_segment

local train_data_util = require("util.train_data")
local create_train_data = train_data_util.create_train_data

local function hex_to_rgb(hex)
  hex = hex:gsub("#", "")
  return {
    r = tonumber("0x" .. hex:sub(1, 2)) / 255,
    g = tonumber("0x" .. hex:sub(3, 4)) / 255,
    b = tonumber("0x" .. hex:sub(5, 6)) / 255,
  }
end

-- save mod settings to global to reduce lookup time
---@return mod_settings
local function get_mod_settings()
  global.settings = global.settings or _ENV.settings.global
  local settings = global.settings
  local palette_name = settings["train-trails-palette"].value
  ---@type mod_settings
  return {
    sprite = trail_types.sprite[settings["train-trails-color-and-glow"].value],
    light = trail_types.light[settings["train-trails-color-and-glow"].value],
    length = tonumber(settings["train-trails-length"].value),
    scale = tonumber(settings["train-trails-scale"].value),
    color_type = settings["train-trails-color-type"].value,
    balance = balance_to_ticks[settings["train-trails-balance"].value],
    passengers_only = settings["train-trails-passengers-only"].value,
    default_color = default_chat_colors[settings["train-trails-default-color"].value],
    frequency = speeds[settings["train-trails-speed"].value],
    amplitude = original_palettes[palette_name] and original_palettes[palette_name].amplitude,
    center = original_palettes[palette_name] and original_palettes[palette_name].center,
    animation_colors = animation_palettes[palette_name],
    animation_color_count = animation_palettes[palette_name] and #animation_palettes[palette_name],
    palette = palette_name,
  }
end

---@param mod_settings mod_settings
---@return {uint: train_data}
local function get_active_trains(mod_settings)
  local active_trains
  for _, surface in pairs(game.surfaces) do
    for _, train in pairs(surface.get_trains()) do
      if active_states[train.state] then
        local data = create_train_data(mod_settings, train)
        active_trains = active_trains or {}
        active_trains[train.id] = data
      end
    end
  end
  return active_trains
end

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

-- draw trail segments for any visible active trains
---@param event_tick uint
---@param mod_settings mod_settings
local function draw_trails(event_tick, mod_settings)
  local sprite = mod_settings.sprite
  local light = mod_settings.light
  if not (sprite or light) then return end

  global.active_train_datas = global.active_train_datas or get_active_trains(mod_settings)
  local active_train_datas = global.active_train_datas
  if not active_train_datas then return end

  global.distance_counters = global.distance_counters or {}

  for train_id, train_data in pairs(active_train_datas) do
    if train_data.train.valid then
      draw_normalized_trail_segment(event_tick, mod_settings, train_data)
    else
      global.active_trains[train_id] = nil
    end
  end
end

local function on_tick()
  if script.active_mods["trains-rights"] then goto end_of_train_trails_script end
  local mod_settings = get_mod_settings()
  local event_tick = game.tick
  -- if event_tick % mod_settings.balance == 0 then
    draw_trails(event_tick, mod_settings)
  -- end
  ::end_of_train_trails_script::
end

local restore_upvalues = { -- a list of restorers
  {
    upvalue_name = "random",
    restore_as_global = { "math", "random" },
  },
  {
    upvalue_name = "settings",
    restore_as_global = { "settings" },
  }
}

local update_script = func_capture.capture(on_tick, restore_upvalues)

for _, main_menu_simulation in pairs(data.raw["utility-constants"]["default"].main_menu_simulations) do
  if main_menu_simulation then
    if main_menu_simulation.update then
      main_menu_simulation.update = main_menu_simulation.update .. simulation_script
    else
      main_menu_simulation.update = simulation_script
    end
  end
end
