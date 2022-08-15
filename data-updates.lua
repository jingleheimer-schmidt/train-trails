
-- let's try to add our script to all the main menu simulations

local simulation_script =
[[

  local speeds = {
    veryslow = 0.010,
    slow = 0.025,
    default = 0.050,
    fast = 0.100,
    veryfast = 0.200,
  }

  local palette = {
    light = {amplitude = 15, center = 240},
    pastel = {amplitude = 55, center = 200},
    default = {amplitude = 127.5, center = 127.5},
    vibrant = {amplitude = 50, center = 100},
    deep = {amplitude = 25, center = 50},
    trans = {amplitude = 55, center = 200},
  }

  local default_chat_colors = {
    red = { r = 1.000, g = 0.166, b = 0.141 },
    orange = { r = 1.000, g = 0.630, b = 0.259 },
    yellow = { r = 1.000, g = 0.828, b = 0.231 },
    green = { r = 0.173, g = 0.824, b = 0.250 },
    blue = { r = 0.343, g = 0.683, b = 1.000 },
    purple = { r = 0.821, g = 0.440, b = 0.998 },
    black = { r = 0.1  , g = 0.1  , b = 0.1   },
    white = { r = 0.9  , g = 0.9  , b = 0.9   },
    pink = { r = 1.000, g = 0.520, b = 0.633 },
    gray = { r = 0.7  , g = 0.7  , b = 0.7   },
    cyan = { r = 0.335, g = 0.918, b = 0.866 },
    brown = { r = 0.757, g = 0.522, b = 0.371 },
    acid = { r = 0.708, g = 0.996, b = 0.134 },
    rainbow = "rainbow",
  }

  local balance_to_ticks = {
    ['super-pretty'] = 1,
    ['pretty'] = 2,
    ['balanced'] = 3,
    ['performance'] = 4
  }

  local sin = math.sin
  local pi_0 = 0 * math.pi / 3
  local pi_2 = 2 * math.pi / 3
  local pi_4 = 4 * math.pi / 3

  function make_rainbow(created_tick, train_id, settings, frequency, amplitude, center)
    local freq_mod = (train_id + created_tick) * frequency
    return {
      r = sin(freq_mod+pi_0)*amplitude+center,
      g = sin(freq_mod+pi_2)*amplitude+center,
      b = sin(freq_mod+pi_4)*amplitude+center,
      a = 255,
    }
  end

  local function draw_trails(settings, stock, sprite, light, event_tick, train_id, passengers_only, color_override, length, scale, color_type, frequency, amplitude, center)
    local color = stock.color
    -- since default color locomotives technically have "nil" color, we need to assign those ones some color. so we pick a color, based on mod settings, using the chat colors. this mod default is for "rainbow", so then the next couple lines read that and create the rainbow effect
    if ((not color) and (color_override ~= "nil")) then
      color = default_chat_colors[color_override] -- color_override is just the mod setting for default loco color
    end
    if ((color_type == "rainbow") or (color == "rainbow") or ((not color) and passengers_only)) then
      color = make_rainbow(event_tick, train_id, settings, frequency, amplitude, center)
    end
    if color then
      local position = stock.position
      local surface = stock.surface
      if sprite then
        sprite = rendering.draw_sprite{
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
      if light then
        light = rendering.draw_light{
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
  end

  local function draw_trails_based_on_speed(event_tick, train, settings, sprite, light, color_override, length, scale, color_type, frequency, amplitude, center, passengers_only)
    local speed = train.speed
    if not (speed == 0) then
      local stock = false
      if speed < 0 then
        stock = train.back_stock
      elseif speed > 0 then
        stock = train.front_stock
      end
      if stock then
        local train_id = train.id
        speed = speed * 216
        local speed_less_than_105 = ((speed < 105) and (speed > 0)) or ((speed > -105) and (speed < 0))
        local speed_less_than_65 = ((speed < 65) and (speed > 0)) or ((speed > -65) and (speed < 0))
        local speed_less_than_40 = ((speed < 40) and (speed > 0)) or ((speed > -40) and (speed < 0))
        local speed_less_than_25 = ((speed < 25) and (speed > 0)) or ((speed > -25) and (speed < 0))
        local speed_less_than_15 = ((speed < 15) and (speed > 0)) or ((speed > -15) and (speed < 0))
        local speed_less_than_10 = ((speed < 10) and (speed > 0)) or ((speed > -10) and (speed < 0))
        local speed_less_than_05 = ((speed < 05) and (speed > 0)) or ((speed > -05) and (speed < 0))
        if not global.delay_counter then
          global.delay_counter = {}
        end
        if not global.delay_counter[train_id] then
          global.delay_counter[train_id] = 0
        end
        local delay_counter = global.delay_counter[train_id] + 1
        local light_delay_counter = delay_counter
        local sprite_delay_counter = delay_counter
        local train_length = #train.carriages
        length = length + ((train_length - 1) * 15)
        if sprite then
          local light_override = false
          if (not speed_less_than_105) then
            draw_trails(settings, stock, sprite, light_override, event_tick, train_id, passengers_only, color_override, length, scale, color_type, frequency, amplitude, center)
            sprite_delay_counter = 0
          elseif (not speed_less_than_65) and speed_less_than_105 and (delay_counter >= 1) then
            draw_trails(settings, stock, sprite, light_override, event_tick, train_id, passengers_only, color_override, length, scale, color_type, frequency, amplitude, center)
            sprite_delay_counter = 0
          elseif (not speed_less_than_40) and speed_less_than_65 and (delay_counter >= 2) then
            draw_trails(settings, stock, sprite, light_override, event_tick, train_id, passengers_only, color_override, length, scale, color_type, frequency, amplitude, center)
            sprite_delay_counter = 0
          elseif (not speed_less_than_25) and speed_less_than_40 and (delay_counter >= 2) then
            draw_trails(settings, stock, sprite, light_override, event_tick, train_id, passengers_only, color_override, length, scale, color_type, frequency, amplitude, center)
            sprite_delay_counter = 0
          elseif (not speed_less_than_15) and speed_less_than_25 and (delay_counter >= 3) then
            draw_trails(settings, stock, sprite, light_override, event_tick, train_id, passengers_only, color_override, length, scale, color_type, frequency, amplitude, center)
            sprite_delay_counter = 0
          elseif (not speed_less_than_10) and speed_less_than_15 and (delay_counter >= 3) then
            draw_trails(settings, stock, sprite, light_override, event_tick, train_id, passengers_only, color_override, length, scale, color_type, frequency, amplitude, center)
            sprite_delay_counter = 0
          elseif (not speed_less_than_05) and speed_less_than_10 and (delay_counter >= 4) then
            draw_trails(settings, stock, sprite, light_override, event_tick, train_id, passengers_only, color_override, length, scale, color_type, frequency, amplitude, center)
            sprite_delay_counter = 0
          elseif speed_less_than_05 and (delay_counter >= 4) then
            draw_trails(settings, stock, sprite, light_override, event_tick, train_id, passengers_only, color_override, length, scale, color_type, frequency, amplitude, center)
            sprite_delay_counter = 0
          end
        end
        if light then
          local sprite_override = false
          if (not speed_less_than_105) then
            draw_trails(settings, stock, sprite_override, light, event_tick, train_id, passengers_only, color_override, length, scale, color_type, frequency, amplitude, center)
            light_delay_counter = 0
          elseif (not speed_less_than_65) and speed_less_than_105 and (delay_counter >= 1) then
            draw_trails(settings, stock, sprite_override, light, event_tick, train_id, passengers_only, color_override, length, scale, color_type, frequency, amplitude, center)
            light_delay_counter = 0
          elseif (not speed_less_than_40) and speed_less_than_65 and (delay_counter >= 2) then
            draw_trails(settings, stock, sprite_override, light, event_tick, train_id, passengers_only, color_override, length, scale, color_type, frequency, amplitude, center)
            light_delay_counter = 0
          elseif (not speed_less_than_25) and speed_less_than_40 and (delay_counter >= 2) then
            draw_trails(settings, stock, sprite_override, light, event_tick, train_id, passengers_only, color_override, length, scale, color_type, frequency, amplitude, center)
            light_delay_counter = 0
          elseif (not speed_less_than_15) and speed_less_than_25 and (delay_counter >= 3) then
            draw_trails(settings, stock, sprite_override, light, event_tick, train_id, passengers_only, color_override, length, scale, color_type, frequency, amplitude, center)
            light_delay_counter = 0
          elseif (not speed_less_than_10) and speed_less_than_15 and (delay_counter >= 3) then
            draw_trails(settings, stock, sprite_override, light, event_tick, train_id, passengers_only, color_override, length, scale, color_type, frequency, amplitude, center)
            light_delay_counter = 0
          elseif (not speed_less_than_05) and speed_less_than_10 and (delay_counter >= 4) then
            draw_trails(settings, stock, sprite_override, light, event_tick, train_id, passengers_only, color_override, length, scale, color_type, frequency, amplitude, center)
            light_delay_counter = 0
          elseif speed_less_than_05 and (delay_counter >= 4) then
            draw_trails(settings, stock, sprite_override, light, event_tick, train_id, passengers_only, color_override, length, scale, color_type, frequency, amplitude, center)
            light_delay_counter = 0
          end
        end
        if sprite and light then
          delay_counter = sprite_delay_counter
        elseif sprite then
          delay_counter = sprite_delay_counter
        elseif light then
          delay_counter = light_delay_counter
        end
        global.delay_counter[train_id] = delay_counter
      end
    end
  end

  local mod_settings = {}
  local settings = settings.global
  global.settings = {}
  global.settings["train-trails-color"] = settings["train-trails-color"].value
  global.settings["train-trails-glow"] = settings["train-trails-glow"].value
  global.settings["train-trails-length"] = settings["train-trails-length"].value
  global.settings["train-trails-scale"] = settings["train-trails-scale"].value
  global.settings["train-trails-color-type"] = settings["train-trails-color-type"].value
  global.settings["train-trails-speed"] = settings["train-trails-speed"].value
  global.settings["train-trails-palette"] = settings["train-trails-palette"].value
  global.settings["train-trails-balance"] = balance_to_ticks[settings["train-trails-balance"].value]
  global.settings["train-trails-passengers-only"] = settings["train-trails-passengers-only"].value
  global.settings["train-trails-default-color"] = settings["train-trails-default-color"].value
  mod_settings = global.settings

  script.on_event(defines.events.on_tick, function(event)
    if event.tick % mod_settings["train-trails-balance"] == 0 then
      for _, surface in pairs(game.surfaces) do
        for _, train in pairs(surface.get_trains()) do
          if train then
            local sprite = mod_settings["train-trails-color"]
            local light = mod_settings["train-trails-glow"]
            if sprite or light then
              local passengers_only = mod_settings["train-trails-passengers-only"]
              local color_override = mod_settings["train-trails-default-color"]
              local length = tonumber(mod_settings["train-trails-length"])
              local scale = tonumber(mod_settings["train-trails-scale"])
              local color_type = mod_settings["train-trails-color-type"]
              local frequency = speeds[mod_settings["train-trails-speed"] ]
              local palette_key = mod_settings["train-trails-palette"]
              local amplitude = palette[palette_key].amplitude
              local center = palette[palette_key].center
              draw_trails_based_on_speed(game.tick, train, mod_settings, sprite, light, color_override, length, scale, color_type, frequency, amplitude, center, passengers_only)
            end
          end
        end
      end
    end
  end)
]]

for _, main_menu_simulation in pairs(data.raw["utility-constants"]["default"].main_menu_simulations) do
  if main_menu_simulation then
    if main_menu_simulation.init then
      main_menu_simulation.init = main_menu_simulation.init .. simulation_script
    else
      main_menu_simulation.init = simulation_script
    end
  end
end
