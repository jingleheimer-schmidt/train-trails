
local constants = require("constants")
local palette = constants.palette
local pride_flags = constants.pride_flags

script.on_event(defines.events.on_console_chat, function(event)
    if not event.message and event.message == "colorize mod settings" then return end
    local function colorizeString(inputString, colorize_palette)
        local result = ""
        local paletteSize = #colorize_palette
        local inputLength = #inputString
        local colorIndex = 1

        for i = 1, inputLength do
            local character = inputString:sub(i, i)
            local color = colorize_palette[math.ceil((i / inputLength) * paletteSize)]

            if color then
                result = result .. string.format("[color=%f,%f,%f]%s[/color]", color.r, color.g, color.b, character)
            else
                result = result .. character
            end
        end

        return result
    end
    -- local function colorizeString(inputString, colorize_palette)
    -- local result = ""
    -- local paletteSize = #colorize_palette
    -- local inputLength = #inputString
    -- local colorIndex = 1

    -- for i = 1, paletteSize do
    --     local character = "•"
    --     local color = colorize_palette[i]

    --     if color then
    --     result = result .. string.format("[color=%f,%f,%f]%s[/color]", color.r, color.g, color.b, character)
    --     else
    --     result = result .. character
    --     end
    -- end

    -- return result
    -- end
    local setting_name = "train-trails-palette"
    for _, setting_value in pairs(game.mod_setting_prototypes[setting_name].allowed_values) do
        local amp = palette[setting_value].amplitude
        local flag_colors = pride_flags[amp]
        if pride_flags[palette[setting_value].amplitude] then
            local locale_name = (setting_value:sub(1, 1):upper() .. setting_value:sub(2)) .. " flag"
            local locale = ">>" .. setting_name .. "-" ..
            setting_value .. "=" .. colorizeString("|||||||||||||||", flag_colors) .. " " .. locale_name
            log(locale)
        end
    end
end)
