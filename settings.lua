
local train_trails_color = {
    type = "bool-setting",
    name = "train-trails-color",
    setting_type = "runtime-global",
    order = "a",
    default_value = true
}

local train_trails_glow = {
    type = "bool-setting",
    name = "train-trails-glow",
    setting_type = "runtime-global",
    order = "b",
    default_value = true
}

local train_trails_passengers_only = {
    type = "bool-setting",
    name = "train-trails-passengers-only",
    setting_type = "runtime-global",
    order = "a - bools",
    default_value = false
}

local train_trails_color_and_glow = {
    type = "string-setting",
    name = "train-trails-color-and-glow",
    setting_type = "runtime-global",
    order = "b - basics - 1",
    default_value = "color-and-glow",
    allowed_values = {
        "color-and-glow",
        "color-only",
        "glow-only",
        "none"
    }
}

local train_trails_scale = {
    type = "string-setting",
    name = "train-trails-scale",
    setting_type = "runtime-global",
    order = "b - basics - 2",
    default_value = "5",
    allowed_values = {
        "1",
        "2",
        "3",
        "4",
        "5",
        "6",
        "8",
        "11",
        "20",
    }
}

local train_trails_length = {
    type = "string-setting",
    name = "train-trails-length",
    setting_type = "runtime-global",
    order = "b - basics - 1",
    default_value = "120",
    allowed_values = {
        "15",
        "30",
        "60",
        "90",
        "120",
        "180",
        "210",
        "300",
        "600"
    }
}

local train_trails_color_sync = {
    type = "string-setting",
    name = "train-trails-color-type",
    setting_type = "runtime-global",
    order = "c - color - 1",
    default_value = "train",
    allowed_values = {
        "train",
        "rainbow",
    }
}

local train_trails_default_trail_color = {
    type = "string-setting",
    name = "train-trails-default-color",
    setting_type = "runtime-global",
    order = "c - color - 2",
    default_value = "rainbow",
    allowed_values = {
        "nil",
        "rainbow",
        "red",
        "orange",
        "yellow",
        "green",
        "blue",
        "purple",
        "black",
        "white",
        "pink",
        "gray",
        "cyan",
        "brown",
        "acid"
    }
}

local train_trails_theme = {
    type = "string-setting",
    name = "train-trails-theme",
    setting_type = "runtime-global",
    order = "c - color - 3",
    default_value = "default",
    allowed_values = {
        "random all",
        -- original:
        "light",
        "pastel",
        "default",
        "vibrant",
        "deep",
        -- pride flags:
        "random pride",
        "lesbian",
        "gay",
        "bi",
        "trans",
        "pan",
        "ace",
        "nonbinary",
        "agender",
        "progress",
        -- seasonal:
        "random seasonal",
        "fresh spring",
        "blossoming spring",
        "vibrant summer",
        "lively summer",
        "golden autumn",
        "crisp autumn",
        "cozy winter",
        "serene winter",
        -- railways:
        "random railway",
        "deutsche bahn",
        "SNCF",
        "union pacific",
        "BNSF",
        "CSX",
        "CN",
        "trenitalia",
        "amtrak",
        -- natural:
        "random natural",
        "water",
        "earth",
        "fire",
        "air",
        "ice",
        "sunlight",
        "moonlight",
        "stars",
        "sunrise",
        "sunset",
        "fog",
        "rain",
        "snow",
        "forest",
        "meadow",
        "ocean",
        "desert",
        "mountain",
        "rainforest",
        "coral reef",
        "volcano",
        "waterfall",
        "cave",
        "canyon",
        -- country flags:
        "random country",
        "united nations",
        "china",
        "india",
        "united states",
        "indonesia",
        "pakistan",
        "nigeria",
        "brazil",
        "bangladesh",
        "russia",
        "mexico",
        "japan",
        "philippines",
        "ethiopia",
        "egypt",
        "vietnam",
        "democratic republic of the congo",
        "turkey",
        "iran",
        "germany",
        "thailand",
        "france",
        "united kingdom",
        "tanzania",
        "south africa",
        "italy",
        "ukraine",
        "australia",
        "netherlands",
        "belgium",
        "cuba",
        "czech republic",
        "greece",
        "sweden",
    }
}

local train_trails_speed = {
    type = "string-setting",
    name = "train-trails-speed",
    setting_type = "runtime-global",
    order = "c - color - 4",
    default_value = "default",
    allowed_values = {
        "veryslow",
        "slow",
        "default",
        "fast",
        "veryfast"
    }
}

local train_trails_balance = {
    type = "string-setting",
    name = "train-trails-balance",
    setting_type = "runtime-global",
    order = "d - balance - 1",
    default_value = "super-pretty",
    allowed_values = {
        -- "super-performance",
        "performance",
        "balanced",
        "pretty",
        "super-pretty"
    }
}

data:extend({
    -- train_trails_color,
    -- train_trails_glow,
    train_trails_color_and_glow,
    train_trails_passengers_only,
    train_trails_scale,
    train_trails_length,
    train_trails_color_sync,
    train_trails_theme,
    train_trails_speed,
    train_trails_balance,
    train_trails_default_trail_color
})
