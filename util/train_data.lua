
local constants = require("util.constants")
local active_states = constants.active_states

local color_util = require("util.color")
local get_random_palette = color_util.get_random_palette

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

local function reset_active_trains()
    for _, surface in pairs(game.surfaces) do
        for _, train in pairs(surface.get_trains()) do
            if active_states[train.state] then
                add_active_train(train)
            end
        end
    end
end

-- add static data to the active_trains table to reduce lookup time
---@param mod_settings mod_settings
---@param train LuaTrain
---@return train_data
local function create_train_data(mod_settings, train)
    local random_palette = get_random_palette(mod_settings)
    return {
        surface_index = train.carriages[1].surface_index,
        train = train,
        id = train.id,
        front_stock = train.front_stock,
        back_stock = train.back_stock,
        random_animation_colors = random_palette,
        random_animation_colors_count = random_palette and #random_palette,
        adjusted_length = mod_settings.length + ((#train.carriages - 1) * 30)
    }
end

return {
    add_active_train = add_active_train,
    remove_active_train = remove_active_train,
    reset_active_trains = reset_active_trains,
    create_train_data = create_train_data
}
