
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
  global.settings["train-trails-passengers-only"] = settings["train-trails-passengers-only"].value
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

local function draw_trails(settings, stock, sprite, light, event_tick, train_id)
  local length = tonumber(settings["train-trails-length"])
  local scale = tonumber(settings["train-trails-scale"])
  local color = stock.color
  if settings["train-trails-color-type"] == "rainbow" then
    color = "rainbow"
  end
  if color or settings["train-trails-passengers-only"] then
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
      if ((color == "rainbow") or ((not color) and settings["train-trails-passengers-only"])) then
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
      if ((color == "rainbow") or ((not color) and settings["train-trails-passengers-only"])) then
        color = make_rainbow(event_tick, train_id, settings)
      end
      rendering.set_color(light, color)
    end
  end
end

local function make_trails(settings, event)
  -- first we create or get our settings
  local sprite = settings["train-trails-color"]
  local light = settings["train-trails-glow"]
  -- then we make any new lights or sprites as needed
  if sprite or light then
    for every, surface in pairs(game.surfaces) do
      local trains = surface.get_trains()
      for each, train in pairs(trains) do
        local passengers = false
        if settings["train-trails-passengers-only"] then
          if train.passengers[1] then
            passengers = true
          end
        end
        if passengers or (not settings["train-trails-passengers-only"]) then
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
              if not global.trains then
                global.trains = {}
              end
              speed = (speed * 60 * 60 * 60) / 1000
              local speed_less_than_200 = ((speed < 200) and (speed > 0)) or ((speed > -200) and (speed < 0))
              local speed_less_than_150 = ((speed < 150) and (speed > 0)) or ((speed > -150) and (speed < 0))
              local speed_less_than_105 = ((speed < 105) and (speed > 0)) or ((speed > -105) and (speed < 0))
              local speed_less_than_65 = ((speed < 65) and (speed > 0)) or ((speed > -65) and (speed < 0))
              local speed_less_than_40 = ((speed < 40) and (speed > 0)) or ((speed > -40) and (speed < 0))
              local speed_less_than_25 = ((speed < 25) and (speed > 0)) or ((speed > -25) and (speed < 0))
              local speed_less_than_15 = ((speed < 15) and (speed > 0)) or ((speed > -15) and (speed < 0))
              local speed_less_than_10 = ((speed < 10) and (speed > 0)) or ((speed > -10) and (speed < 0))
              local speed_less_than_05 = ((speed < 05) and (speed > 0)) or ((speed > -05) and (speed < 0))
              if not global.trains[train_id] then
                global.trains[train_id] = 0
              end
              global.trains[train_id] = global.trains[train_id] + 1
              local delay_counter = global.trains[train_id]
              -- if speed_less_than_05 and (delay_counter >= 9) then
              --   draw_trails(settings, stock, sprite, light, event_tick, train_id)
              --   global.trains[train_id] = 0
              --   -- game.print("speed less than 5")
              -- elseif (not speed_less_than_05) and speed_less_than_10 and (delay_counter >= 8) then
              --   draw_trails(settings, stock, sprite, light, event_tick, train_id)
              --   global.trains[train_id] = 0
              --   -- game.print("speed less than 10")
              if speed_less_than_10 and (delay_counter >= 8) then
                draw_trails(settings, stock, sprite, light, event_tick, train_id)
                global.trains[train_id] = 0
                -- game.print("speed less than 10")
              elseif (not speed_less_than_10) and speed_less_than_15 and (delay_counter >= 7) then
                draw_trails(settings, stock, sprite, light, event_tick, train_id)
                global.trains[train_id] = 0
                -- game.print("speed less than 15")
              elseif (not speed_less_than_15) and speed_less_than_25 and (delay_counter >= 6) then
                draw_trails(settings, stock, sprite, light, event_tick, train_id)
                global.trains[train_id] = 0
                -- game.print("speed less than 25")
              elseif (not speed_less_than_25) and speed_less_than_40 and (delay_counter >= 5) then
                draw_trails(settings, stock, sprite, light, event_tick, train_id)
                global.trains[train_id] = 0
                -- game.print("speed less than 40")
              elseif (not speed_less_than_40) and speed_less_than_65 and (delay_counter >= 4) then
                draw_trails(settings, stock, sprite, light, event_tick, train_id)
                global.trains[train_id] = 0
                -- game.print("speed less than 65")
              elseif (not speed_less_than_65) and speed_less_than_105 and (delay_counter >= 3) then
                draw_trails(settings, stock, sprite, light, event_tick, train_id)
                global.trains[train_id] = 0
                -- game.print("speed less than 105")
              elseif (not speed_less_than_105) and speed_less_than_150 and (delay_counter >= 2) then
                draw_trails(settings, stock, sprite, light, event_tick, train_id)
                global.trains[train_id] = 0
                -- game.print("speed less than 150")
              elseif (not speed_less_than_150) and speed_less_than_200 and (delay_counter >= 1) then
                draw_trails(settings, stock, sprite, light, event_tick, train_id)
                global.trains[train_id] = 0
                -- game.print("speed less than 150")
              elseif not speed_less_than_200 then
                draw_trails(settings, stock, sprite, light, event_tick, train_id)
                global.trains[train_id] = false
                -- game.print("speed greater than 170")
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
