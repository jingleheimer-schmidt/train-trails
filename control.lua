
--[[
Train Trails control script © 2023 by asher_sky is licensed under Attribution-NonCommercial-ShareAlike 4.0 International. See LICENSE.txt for additional information
--]]

local constants = require("constants")
local speeds = constants.speeds
local original_themes = constants.original_themes
local animation_themes = constants.animation_themes
local default_chat_colors = constants.default_chat_colors
local balance_to_ticks = constants.balance_to_ticks
local trail_types = constants.trail_types
local active_states = constants.active_states
local random_theme_names = {
    ["random all"] = constants.animation_names,
    ["random pride"] = constants.pride_flag_names,
    ["random country"] = constants.national_flag_names,
    ["random seasonal"] = constants.seasonal_color_names,
    ["random natural"] = constants.natural_theme_names,
    ["random railway"] = constants.railway_theme_names
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

commands.add_command("reset-train-colors", { "command-help.reset-train-colors" }, function()
    for _, force in pairs(game.forces) do
        for _, train in pairs(game.train_manager.get_trains { force = force }) do
            for _, stock in pairs(train.carriages) do
                stock.color = nil
            end
        end
    end
end)
commands.add_command("reset-station-colors", { "command-help.reset-station-colors" }, function()
    for _, force in pairs(game.forces) do
        for _, station in pairs(game.train_manager.get_train_stops { force = force }) do
            station.color = nil
        end
    end
end)
commands.add_command("reset-destination-color-sync", { "command-help.reset-destination-color-sync" }, function(param)
    local sync = param.parameter == "true" and true or param.parameter == "false" and false
    if sync == true or sync == false then
        for _, force in pairs(game.forces) do
            for _, train in pairs(game.train_manager.get_trains { force = force }) do
                for _, stock in pairs(train.carriages) do
                    stock.copy_color_from_train_stop = sync
                end
            end
        end
    end
end)

-- gets a random color theme within mod setting restrictions
---@return Color?
local function get_random_theme()
    local mod_settings = storage.settings
    local theme_name = mod_settings.theme
    local random_theme_name = random_theme_names[theme_name] and random_theme_names[theme_name][random(#random_theme_names[theme_name])] or nil
    local random_theme = random_theme_name and animation_themes[random_theme_name] or nil
    return random_theme
end

-- add static data to the active_trains table to reduce lookup time
---@param train LuaTrain
local function add_active_train(train)
    local random_theme = get_random_theme()
    storage.active_trains[train.id] = {
        surface_index = train.carriages[1].surface_index,
        train = train,
        id = train.id,
        front_stock = train.front_stock,
        back_stock = train.back_stock,
        random_animation_colors = random_theme,
        random_animation_colors_count = random_theme and #random_theme,
        adjusted_length = storage.settings.length + ((#train.carriages - 1) * 30)
    }
end

---@param train LuaTrain
local function remove_active_train(train)
    storage.active_trains[train.id] = nil
    storage.distance_counters[train.id] = nil
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

-- convert a hex color to a factorio color
-- copy-pasted from Automatic_Train_Painter, licensed under MIT
---@param hex string
---@return Color
local function hex_to_color(hex)
    local color
    local name
    local r, g, b, c1, c2, c3
    if string.len(hex) ~= 6 and string.len(hex) ~= 3 and string.len(hex) ~= 0 then
        game.print({ "error-message.color-length-error", name, string.len(hex) })
        return { r = 1, g = 1, b = 1, a = 1 }
    end

    if string.len(hex) == 6 then
        c1, c2, c3 = hex:match('(..)(..)(..)')
        r = tonumber(c1, 16)
        g = tonumber(c2, 16)
        b = tonumber(c3, 16)
        color = { ['r'] = r, ['g'] = g, ['b'] = b, ['a'] = 127 }
    end

    if string.len(hex) == 3 then
        c1, c2, c3 = hex:match('(.)(.)(.)')
        r = tonumber(c1 .. c1, 16)
        g = tonumber(c2 .. c2, 16)
        b = tonumber(c3 .. c3, 16)
        color = { ['r'] = r, ['g'] = g, ['b'] = b, ['a'] = 127 }
    end
    if color then
        color['r'] = color['r'] / 255
        color['g'] = color['g'] / 255
        color['b'] = color['b'] / 255
        color['a'] = color['a'] / 255
    end

    return color
end

-- save mod settings to global to reduce lookup time
local function initialize_settings()
    ---@type table<uint, train_data>
    storage.active_trains = storage.active_trains or {}
    ---@type table<uint, number>
    storage.distance_counters = storage.distance_counters or {}
    local mod_settings = settings.global
    local theme_name = mod_settings["train-trails-theme"].value --[[@as string]]
    local default_u_loco_color_hex = script.active_mods["Automatic_Train_Painter"] and mod_settings["u-loco"].value --[[@as string?]]
    ---@type mod_settings
    storage.settings = {
        sprite = trail_types.sprite[ mod_settings["train-trails-color-and-glow"].value --[[@as string]] ],
        light = trail_types.light[ mod_settings["train-trails-color-and-glow"].value --[[@as string]] ],
        length = tonumber(mod_settings["train-trails-length"].value) --[[@as 15|30|60|90|120|180|210|300|600]],
        scale = tonumber(mod_settings["train-trails-scale"].value) --[[@as 1|2|3|4|5|6|8|11|20]],
        color_type = mod_settings["train-trails-color-type"].value --[[@as string]],
        balance = balance_to_ticks[ mod_settings["train-trails-balance"].value --[[@as string]] ],
        passengers_only = mod_settings["train-trails-passengers-only"].value --[[@as boolean]],
        default_color = default_chat_colors[ mod_settings["train-trails-default-color"].value --[[@as string]] ],
        frequency = speeds[ mod_settings["train-trails-speed"].value --[[@as string]] ],
        amplitude = original_themes[theme_name] and original_themes[theme_name].amplitude,
        center = original_themes[theme_name] and original_themes[theme_name].center,
        animation_colors = animation_themes[theme_name],
        animation_color_count = animation_themes[theme_name] and #animation_themes[theme_name],
        theme = theme_name,
        default_u_loco_color = default_u_loco_color_hex and hex_to_color(default_u_loco_color_hex)
    }
end

local function reset_active_trains()
    local trains = game.train_manager.get_trains { is_moving = true }
    for _, train in pairs(trains) do
        add_active_train(train)
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
        -- Handle stepwise themes
        local sharpness = 0.8
        local count = #animation_colors
        if count == 0 then
            return { 1, 1, 1 } -- Default to white if the theme is empty
        end

        -- Determine the current base and next indices
        local base_index = floor(modifier % count) + 1
        local next_index = (base_index % count) + 1

        -- Time within the current step (0 to 1)
        local step_time = modifier % 1

        -- Adjust interpolation timing based on sharpness
        local t
        if step_time < sharpness then
            t = 0 -- Hold the base color
        else
            t = (step_time - sharpness) / (1 - sharpness) -- Smoothly interpolate at the end
        end

        -- Base and next colors
        local base_color = animation_colors[base_index]
        local next_color = animation_colors[next_index]

        -- Interpolate only when transitioning
        return {
            r = base_color.r * (1 - t) + next_color.r * t,
            g = base_color.g * (1 - t) + next_color.g * t,
            b = base_color.b * (1 - t) + next_color.b * t,
        }
    else
        return { 1, 1, 1 }
    end
end

---@param color1 Color
---@param color2 Color
---@return boolean
local function compare_colors(color1, color2)
    local r1 = math.floor((color1.r or color1[1]) * 255)
    local g1 = math.floor((color1.g or color1[2]) * 255)
    local b1 = math.floor((color1.b or color1[3]) * 255)
    local r2 = math.floor((color2.r or color2[1]) * 255)
    local g2 = math.floor((color2.g or color2[2]) * 255)
    local b2 = math.floor((color2.b or color2[3]) * 255)
    return r1 == r2 and g1 == g2 and b1 == b2
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
        local u_loco_color = mod_settings.default_u_loco_color
        if color and u_loco_color and compare_colors(color, u_loco_color) then
            color = nil
        end

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
    local scale = mod_settings.scale * max(abs(speed), 0.75)

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
            intensity = .125,
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
    local distance_counters = storage.distance_counters
    local tiles_since_last_trail = (distance_counters[train_id] or 0) + abs(speed * mod_settings.balance)

    if tiles_since_last_trail >= 0.75 then
        draw_trail_segment(event_tick, mod_settings, train_data, speed)
        tiles_since_last_trail = 0
    end

    storage.distance_counters[train_id] = tiles_since_last_trail
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

    local active_train_datas = storage.active_trains
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
            storage.active_trains[train_id] = nil
            storage.distance_counters[train_id] = nil
        end
    end
end

---@param event EventData.on_tick
local function on_tick(event)
    local mod_settings = storage.settings
    local event_tick = event.tick
    if event_tick % mod_settings.balance == 0 then
        draw_trails(event_tick, mod_settings)
    end
end

script.on_event(defines.events.on_tick, on_tick)

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
---@field theme string
---@field default_u_loco_color Color?

---@alias train_data {surface_index: uint, train: LuaTrain, id: uint, front_stock: LuaEntity?, back_stock: LuaEntity?, random_animation_colors: Color[]?, random_animation_colors_count: integer?, adjusted_length: uint}
