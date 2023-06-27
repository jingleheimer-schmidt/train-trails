
---@type {string: float}
local speeds = {
    ["veryslow"] = 0.010,
    ["slow"] = 0.025,
    ["default"] = 0.050,
    ["fast"] = 0.100,
    ["veryfast"] = 0.200,
}

---@type {string: {amplitude: float, center: float}}
local palettes = {
    ["light"] = { amplitude = 15, center = 240 },
    ["pastel"] = { amplitude = 55, center = 200 },
    ["default"] = { amplitude = 127.5, center = 127.5 },
    ["vibrant"] = { amplitude = 50, center = 100 },
    ["deep"] = { amplitude = 25, center = 50 },
}

require("util")
---@type {string: Color[]}
local pride_flag_palettes = {
    ["trans"] = {            -- trans pride
        util.color("#5BCEFA"), -- light blue
        util.color("#F5A9B8"), -- light pink
        util.color("#FFFFFF"), -- white
        util.color("#F5A9B8"), -- light pink
        -- util.color("#5BCEFA"), -- light blue
    },
    ["lesbian"] = {          -- lesbian pride
        util.color("#D52D00"), -- dark orange
        util.color("#EF7627"), -- mid orange
        util.color("#FF9A56"), -- light orange
        util.color("#FFFFFF"), -- white
        util.color("#D162A4"), -- light pink
        util.color("#B55690"), -- mid pink
        util.color("#A30262"), -- dark pink
    },
    ["bi"] = {               -- bi pride
        util.color("#D60270"), -- pink
        util.color("#D60270"), -- pink
        util.color("#9B4F96"), -- purple
        util.color("#0038A8"), -- blue
        util.color("#0038A8"), -- blue
    },
    ["nonbinary"] = {        -- nonbinary pride
        util.color("#FCF434"), -- yellow
        util.color("#FFFFFF"), -- white
        util.color("#9C59D1"), -- purple
        util.color("#000000"), -- black
    },
    ["pan"] = {              -- pan pride
        util.color("#FF218C"), -- pink
        util.color("#FFD800"), -- yellow
        util.color("#21B1FF"), -- blue
    },
    ["ace"] = {              -- ace pride
        util.color("#000000"), -- black
        util.color("#A3A3A3"), -- grey
        util.color("#FFFFFF"), -- white
        util.color("#800080"), -- purple
    },
    ["progress"] = {         -- progress pride
        util.color("#E40303"), -- red
        util.color("#FF8C00"), -- orange
        util.color("#FFED00"), -- yellow
        util.color("#008026"), -- green
        util.color("#24408E"), -- blue
        util.color("#732982"), -- purple
        util.color("#FFFFFF"), -- white
        util.color("#FFAFC8"), -- pink
        util.color("#74D7EE"), -- light blue
        util.color("#613915"), -- brown
        util.color("#000000"), -- black
    },
    ["agender"] = {          -- agender pride
        util.color("#000000"), -- black
        util.color("#BCC4C7"), -- grey
        util.color("#FFFFFF"), -- white
        util.color("#B7F684"), -- green
        util.color("#FFFFFF"), -- white
        util.color("#BCC4C7"), -- grey
        -- util.color("#000000"), -- black
    },
    ["gay"] = {              -- gay pride
        util.color("#078D70"), -- dark green
        util.color("#26CEAA"), -- medium green
        util.color("#98E8C1"), -- light green
        util.color("#FFFFFF"), -- white
        util.color("#7BADE2"), -- light blue
        util.color("#5049CC"), -- indigo
        util.color("#3D1A78"), -- dark blue
    }
}

---@type {string: Color[]}
local national_flag_palettes = {
    ["china"] = {
        util.color("#EE1C25"), -- red
        util.color("#FFFF00"), -- yellow
    },
    ["india"] = {
        util.color("#FF9933"), -- saffron
        util.color("#FFFFFF"), -- white
        util.color("#138808"), -- green
        util.color("#000080"), -- navy blue
    },
    ["united states"] = {
        util.color("#B31942"), -- red
        util.color("#FFFFFF"), -- white
        util.color("#0A3161"), -- blue
    },
    ["brazil"] = {
        util.color("#009739"), -- green
        util.color("#FEDD00"), -- yellow
        util.color("#FFFFFF"), -- white
        util.color("#012169"), -- blue
    },
    ["russia"] = {
        util.color("#FFFFFF"), -- white
        util.color("#1C3578"), -- blue
        util.color("#E4181C"), -- red
    },
    ["mexico"] = {
        util.color("#006341"), -- dark green
        util.color("#FFFFFF"), -- white
        util.color("#C8102E"), -- red
    },
    ["japan"] = {
        util.color("#BC002D"), -- red
        util.color("#FFFFFF"), -- white
    },
    ["germany"] = {
        util.color("#000000"), -- schwarz
        util.color("#DD0000"), -- rot
        util.color("#FFCE00"), -- gold
    },
    ["united kingdom"] = {
        util.color("#FFFFFF"), -- white
        util.color("#C8102E"), -- red
        util.color("#012169"), -- blue
    },
    ["ukraine"] = {
        util.color("#0057B7"), -- blue
        util.color("#FFDD00"), -- yellow
    },
    ["czech republic"] = {
        util.color("#11457E"), -- blue
        util.color("#FFFFFF"), -- white
        util.color("#D7141A"), -- red
    },
    ["sweden"] = {
        util.color("#006AA7"), -- blue
        util.color("#FECC02"), -- yellow
    }
}

---@type {string: Color[]}
local seasonal_color_palettes = {
    ["fresh spring"] = {
        util.color("#BBE7C6"),
        util.color("#A4DEAB"),
        util.color("#D7E8BA"),
        util.color("#FAF3DD"),
        util.color("#F3D250")
    },
    ["blossoming spring"] = {
        util.color("#F9C1BB"),
        util.color("#FDD6BD"),
        util.color("#FFF3D4"),
        util.color("#BCD8BF"),
        util.color("#93C4AE")
    },
    ["vibrant summer"] = {
        util.color("#FF6F69"),
        util.color("#FFCC5C"),
        util.color("#88D8B0"),
        util.color("#5A9E6E"),
        util.color("#49796B")
    },
    ["lively summer"] = {
        util.color("#F3D250"),
        util.color("#FFEE8A"),
        util.color("#FFCB74"),
        util.color("#FF9F6E"),
        util.color("#FF677D")
    },
    ["golden autumn"] = {
        util.color("#E8A87C"),
        util.color("#C38D9E"),
        util.color("#A6A5B5"),
        util.color("#98C1D9"),
        util.color("#FFD28F")
    },
    ["crisp autumn"] = {
        util.color("#FF8666"),
        util.color("#FFB383"),
        util.color("#FFD9A5"),
        util.color("#F7F0B3"),
        util.color("#BFD5AA")
    },
    ["cozy winter"] = {
        util.color("#FFE6E8"),
        util.color("#F2EFFD"),
        util.color("#D9E4F5"),
        util.color("#A1C4F2"),
        util.color("#7FB8F5")
    },
    ["serene winter"] = {
        util.color("#D1E3FF"),
        util.color("#D8D7F8"),
        util.color("#F0D6FF"),
        util.color("#FFE1F0"),
        util.color("#E9F0FF")
    }
}
-- util.color("#"),

---@type {string: Color[]}
local animation_palettes = {}
for name, colors in pairs(pride_flag_palettes) do
    animation_palettes[name] = colors
end
for name, colors in pairs(national_flag_palettes) do
    animation_palettes[name] = colors
end
for name, colors in pairs(seasonal_color_palettes) do
    animation_palettes[name] = colors
end

---@type string[]
local animation_names = {}
for name, _ in pairs(animation_palettes) do
    table.insert(animation_names, name)
end

---@type string[]
local pride_flag_names = {}
for name, _ in pairs(pride_flag_palettes) do
    table.insert(pride_flag_names, name)
end

---@type string[]
local national_flag_names = {}
for name, _ in pairs(national_flag_palettes) do
    table.insert(national_flag_names, name)
end

---@type string[]
local seasonal_color_names = {}
for name, _ in pairs(seasonal_color_palettes) do
    table.insert(seasonal_color_names, name)
end

--- @type {string: Color|string}
local default_chat_colors = {
    ["red"] = { r = 1.000, g = 0.166, b = 0.141 } --[[@type Color]],
    ["orange"] = { r = 1.000, g = 0.630, b = 0.259 } --[[@type Color]],
    ["yellow"] = { r = 1.000, g = 0.828, b = 0.231 } --[[@type Color]],
    ["green"] = { r = 0.173, g = 0.824, b = 0.250 } --[[@type Color]],
    ["blue"] = { r = 0.343, g = 0.683, b = 1.000 } --[[@type Color]],
    ["purple"] = { r = 0.821, g = 0.440, b = 0.998 } --[[@type Color]],
    ["black"] = { r = 0.1, g = 0.1, b = 0.1 } --[[@type Color]],
    ["white"] = { r = 0.9, g = 0.9, b = 0.9 } --[[@type Color]],
    ["pink"] = { r = 1.000, g = 0.520, b = 0.633 } --[[@type Color]],
    ["gray"] = { r = 0.7, g = 0.7, b = 0.7 } --[[@type Color]],
    ["cyan"] = { r = 0.335, g = 0.918, b = 0.866 } --[[@type Color]],
    ["brown"] = { r = 0.757, g = 0.522, b = 0.371 } --[[@type Color]],
    ["acid"] = { r = 0.708, g = 0.996, b = 0.134 } --[[@type Color]],
    ["rainbow"] = "rainbow",
    ["nil"] = "nil",
}

--- @type {string: integer}
local balance_to_ticks = {
    ["super-pretty"] = 1,
    ["pretty"] = 2,
    ["balanced"] = 3,
    ["performance"] = 4
}

---@type {sprite: {string: boolean}, light: {string: boolean}}
local trail_types = {
    sprite = {
        ["color-only"] = true,
        ["color-and-glow"] = true
    },
    light = {
        ["glow-only"] = true,
        ["color-and-glow"] = true
    }
}

---@type {defines.train_state: boolean}
local active_states = {
    [defines.train_state.arrive_signal] = true,
    [defines.train_state.arrive_station] = true,
    [defines.train_state.destination_full] = false,
    [defines.train_state.manual_control] = true,
    [defines.train_state.manual_control_stop] = true,
    [defines.train_state.no_path] = false,
    [defines.train_state.no_schedule] = false,
    [defines.train_state.on_the_path] = true,
    [defines.train_state.path_lost] = true,
    [defines.train_state.wait_signal] = false,
    [defines.train_state.wait_station] = false,
}

return {
    speeds = speeds,
    original_palettes = palettes,
    pride_flag_palettes = pride_flag_palettes,
    national_flag_palettes = national_flag_palettes,
    seasonal_color_palettes = seasonal_color_palettes,
    animation_palettes = animation_palettes,
    animation_names = animation_names,
    pride_flag_names = pride_flag_names,
    national_flag_names = national_flag_names,
    seasonal_color_names = seasonal_color_names,
    default_chat_colors = default_chat_colors,
    balance_to_ticks = balance_to_ticks,
    trail_types = trail_types,
    active_states = active_states
}
