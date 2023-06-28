
local trainTrailsColor = {
  type = "bool-setting",
  name = "train-trails-color",
  setting_type = "runtime-global",
  order = "a",
  default_value = true
}

local trainTrailsGlow = {
  type = "bool-setting",
  name = "train-trails-glow",
  setting_type = "runtime-global",
  order = "b",
  default_value = true
}

local trainTrailsPassengersOnly = {
  type = "bool-setting",
  name = "train-trails-passengers-only",
  setting_type = "runtime-global",
  order = "a - bools",
  default_value = false
}

local trainTrailsColorAndGLow = {
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

local trainTrailsScale = {
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

local trainTrailsLength = {
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

local trainTrailsColorSync = {
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

local trainTrailsDefaultTrailColor = {
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

local trainTrailsPalette = {
  type = "string-setting",
  name = "train-trails-palette",
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
    "china",
    "india",
    "united states",
    "brazil",
    "russia",
    "mexico",
    "japan",
    "germany",
    "united kingdom",
    "ukraine",
    "czech republic",
    "sweden"
  }
}

local trainTrailsSpeed = {
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

local trainTrailsBalance = {
  type = "string-setting",
  name = "train-trails-balance",
  setting_type = "runtime-global",
  order = "d - balance - 1",
  default_value = "pretty",
  allowed_values = {
    -- "super-performance",
    "performance",
    "balanced",
    "pretty",
    "super-pretty"
  }
}

data:extend({
  -- trainTrailsColor,
  -- trainTrailsGlow,
  trainTrailsColorAndGLow,
  trainTrailsPassengersOnly,
  trainTrailsScale,
  trainTrailsLength,
  trainTrailsColorSync,
  trainTrailsPalette,
  trainTrailsSpeed,
  trainTrailsBalance,
  trainTrailsDefaultTrailColor
})

require("colorize_locale")
