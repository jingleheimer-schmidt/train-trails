
local color_util = require("util/color")
local get_trail_color = color_util.get_trail_color

local abs = math.abs
local max = math.max
local draw_light = rendering.draw_light
local draw_sprite = rendering.draw_sprite

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
    local distance_counters = global.distance_counters or {}
    local tiles_since_last_trail = (distance_counters[train_id] or 0) + abs(speed * mod_settings.balance)

    if tiles_since_last_trail >= 1 then
        draw_trail_segment(event_tick, mod_settings, train_data, speed)
        tiles_since_last_trail = 0
    end

    global.distance_counters[train_id] = tiles_since_last_trail
end

return {
    draw_trail_segment = draw_trail_segment,
    draw_normalized_trail_segment = draw_normalized_trail_segment
}