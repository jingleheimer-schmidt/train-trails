
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
  order = "c",
  default_value = false
}

local trainTrailsScale = {
  type = "string-setting",
  name = "train-trails-scale",
  setting_type = "runtime-global",
  order = "d",
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
  order = "e",
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
  order = "f",
  default_value = "train",
  allowed_values = {
    "train",
    "rainbow",
  }
}

local trainTrailsPalette = {
  type = "string-setting",
  name = "train-trails-palette",
  setting_type = "runtime-global",
  order = "g",
  default_value = "default",
  allowed_values = {
    "light",
    "pastel",
    "default",
    "vibrant",
    "deep"
  }
}

local trainTrailsSpeed = {
  type = "string-setting",
  name = "train-trails-speed",
  setting_type = "runtime-global",
  order = "h",
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
  order = "i",
  default_value = "pretty",
  allowed_values = {
    -- "super-performance",
    "performance",
    "balanced",
    "pretty",
    "super-pretty"
  }
}

local trainTrailsDefaultTrailColor = {
  type = "string-setting",
  name = "train-trails-default-color",
  setting_type = "runtime-global",
  order = "j",
  default_value = "nil",
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

data:extend({
  trainTrailsColor,
  trainTrailsGlow,
  trainTrailsPassengersOnly,
  trainTrailsScale,
  trainTrailsLength,
  trainTrailsColorSync,
  trainTrailsPalette,
  trainTrailsSpeed,
  trainTrailsBalance,
  trainTrailsDefaultTrailColor
})
