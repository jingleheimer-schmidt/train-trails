
local constants = require("util.constants")
local default_chat_colors = constants.default_chat_colors
local animation_palettes = constants.animation_palettes
local random_palette_names = constants.random_palette_names

local sin = math.sin
local floor = math.floor
local random = math.random
local pi_0 = 0 * math.pi / 3
local pi_2 = 2 * math.pi / 3
local pi_4 = 4 * math.pi / 3

-- gets a random color palette within mod setting restrictions
---@param mod_settings mod_settings?
---@return Color.0|Color.1[]?
local function get_random_palette(mod_settings)
    mod_settings = mod_settings or global.settings
    local palette_name = mod_settings.palette
    local random_palette_name = random_palette_names[palette_name] and random_palette_names[palette_name][random(#random_palette_names[palette_name])] or nil
    local random_palette = random_palette_name and animation_palettes[random_palette_name] or nil
    return random_palette
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
        local index = floor(modifier % (mod_settings.animation_color_count or train_data.random_animation_colors_count)) +
        1
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
        global.rollingstock_colors = global.rollingstock_colors or {}
        local color = global.rollingstock_colors[stock.unit_number]

        if color then
            return color
        elseif default_color == "rainbow" then
            return get_rainbow_color(event_tick, mod_settings, train_data)
        elseif type(default_color) == "table" then
            return default_color
        end
    end
end

-- register the colors of a given train's stock
---@param train LuaTrain
local function register_rollingstock_colors(train)
    global.rollingstock_colors = global.rollingstock_colors or {}
    for _, stock in pairs(train.carriages) do
        if stock.color then
            global.rollingstock_colors[stock.unit_number] = stock.color
        end
    end
end

-- unregisters the colors of a given train's stock
---@param train LuaTrain
local function unregister_rollingstock_colors(train)
    global.rollingstock_colors = global.rollingstock_colors or {}
    for _, stock in pairs(train.carriages) do
        global.rollingstock_colors[stock.unit_number] = nil
    end
end

return {
    get_random_palette = get_random_palette,
    get_rainbow_color = get_rainbow_color,
    get_trail_color = get_trail_color,
    register_rollingstock_colors = register_rollingstock_colors,
    unregister_rollingstock_colors = unregister_rollingstock_colors,
}