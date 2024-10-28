
local constants = require("constants")
local themes = constants.original_themes
local pride_flag_themes = constants.pride_flag_themes
local national_flag_themes = constants.national_flag_themes
local seasonal_color_themes = constants.seasonal_color_themes
local natural_themes = constants.natural_themes
local railway_company_themes = constants.railway_company_themes

local function capitalize_each_word(setting_name)
    local result = ""
    for word in string.gmatch(setting_name, "%S+") do
        result = result .. word:sub(1, 1):upper() .. word:sub(2) .. " "
    end
    return result:sub(1, -2)
end

local function colorize(inputString, colorize_theme)
    local result = ""
    local themeSize = #colorize_theme
    local inputLength = #inputString

    for i = 1, inputLength do
        local character = inputString:sub(i, i)
        local color = colorize_theme[math.ceil((i / inputLength) * themeSize)]

        if color then
            result = result .. string.format("[color=%f,%f,%f]%s[/color]", color.r, color.g, color.b, character)
        else
            result = result .. character
        end
    end

    return result
end

local setting_name = "train-trails-theme"
local allowed_values = data.raw["string-setting"][setting_name].allowed_values
local allowed_value_locales = {}

for _, setting_value in pairs(allowed_values) do
    local pride_flag = pride_flag_themes[setting_value]
    local country_flag = national_flag_themes[setting_value]
    local seasonal = seasonal_color_themes[setting_value]
    local natural = natural_themes[setting_value]
    local railway = railway_company_themes[setting_value]

    local canvas = "|||||||||||||||"
    local colors = pride_flag or country_flag or seasonal or natural or railway
    local colorized_canvas = colors and colorize(canvas, colors) or canvas
    local capitalized_name = capitalize_each_word(setting_value)
    local type = pride_flag and "Pride" or country_flag and "Country" or seasonal and "Seasonal" or natural and "Natural" or railway and "Railway" or ""

    local locale = setting_name .. "-" .. setting_value .. "=" .. type .. ": " .. colorized_canvas .. " " .. capitalized_name

    if colors then
        table.insert(allowed_value_locales, locale)
    end
end

log(table.concat(allowed_value_locales, "\n"))
