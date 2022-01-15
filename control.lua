
--[[
Trian Trails control script © 2022 by asher_sky is licensed under Attribution-NonCommercial-ShareAlike 4.0 International. See LICENSE.txt for additional information
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

local sin = math.sin
local pi_div_3 = math.pi / 3

function make_rainbow(created_tick, train_id, settings)
  local frequency = speeds[settings["train-trails-speed"]]
  local modifier = train_id + created_tick
  local palette_key = settings["train-trails-palette"]
  local amplitude = palette[palette_key].amplitude
  local center = palette[palette_key].center
  return {
    r = sin(frequency*(modifier)+(0*pi_div_3))*amplitude+center,
    g = sin(frequency*(modifier)+(2*pi_div_3))*amplitude+center,
    b = sin(frequency*(modifier)+(4*pi_div_3))*amplitude+center,
    a = 255,
  }
end

local function initialize_settings()
  if not global.settings then
    global.settings = {}
  end
  local settings = settings.global
  global.settings = {}
  global.settings["train-trails-color"] = settings["train-trails-color"].value
  global.settings["train-trails-glow"] = settings["train-trails-glow"].value
  global.settings["train-trails-length"] = settings["train-trails-length"].value
  global.settings["train-trails-scale"] = settings["train-trails-scale"].value
  global.settings["train-trails-color-type"] = settings["train-trails-color-type"].value
  global.settings["train-trails-speed"] = settings["train-trails-speed"].value
  global.settings["train-trails-palette"] = settings["train-trails-palette"].value
  global.settings["train-trails-balance"] = settings["train-trails-balance"].value
end

script.on_event(defines.events.on_runtime_mod_setting_changed, function()
  initialize_settings()
end)

script.on_configuration_changed(function()
  initialize_settings()
end)

script.on_init(function()
  initialize_settings()
end)

local function make_trails(settings, event)
  -- first we create or get our settings
  local sprite = settings["train-trails-color"]
  local light = settings["train-trails-glow"]
  -- then we make any new lights or sprites as needed
  if sprite or light then
    for every, surface in pairs(game.surfaces) do
      local trains = surface.get_trains()
      for each, train in pairs(trains) do
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
            local length = tonumber(settings["train-trails-length"])
            local scale = tonumber(settings["train-trails-scale"])
            local color = stock.color
            if settings["train-trails-color-type"] == "rainbow" then
              color = "rainbow"
            end
            if color then
              if sprite then
                sprite = rendering.draw_sprite{
                  sprite = "train-trail",
                  target = stock.position,
                  surface = stock.surface,
                  x_scale = scale,
                  y_scale = scale,
                  render_layer = "radius-visualization",
                  time_to_live = length,
                }
                if color == "rainbow" then
                  color = make_rainbow(event_tick, train_id, settings)
                end
                rendering.set_color(sprite, color)
              end
              if light then
                light = rendering.draw_light{
                  sprite = "train-trail",
                  target = stock.position,
                  surface = stock.surface,
                  intensity = .175,
                  scale = scale * 2,
                  render_layer = "light-effect",
                  time_to_live = length,
                }
                if color == "rainbow" then
                  color = make_rainbow(event_tick, train_id, settings)
                end
                rendering.set_color(light, color)
              end
            end
          end
        end
      end
    end
  end
end

script.on_event(defines.events.on_tick, function(event)
  if not global.settings then
    initialize_settings()
  end
  local settings = global.settings
  if settings["train-trails-balance"] == "super-pretty" then
    make_trails(settings, event)
  end
end)

script.on_nth_tick(2, function(event)
  local settings = global.settings
  if settings["train-trails-balance"] == "pretty" then
    make_trails(settings, event)
  end
end)

script.on_nth_tick(3, function(event)
  local settings = global.settings
  if settings["train-trails-balance"] == "balanced" then
    make_trails(settings, event)
  end
end)

script.on_nth_tick(4, function(event)
  local settings = global.settings
  if settings["train-trails-balance"] == "performance" then
    make_trails(settings, event)
  end
end)
--
-- script.on_nth_tick(6, function(event)
--   local settings = global.settings
--   if settings["train-trails-balance"] == "super-performance" then
--     make_trails(settings, event)
--   end
-- end)
