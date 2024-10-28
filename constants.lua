
---@type {string: float}
local speeds = {
    ["veryslow"] = 0.010,
    ["slow"] = 0.025,
    ["default"] = 0.050,
    ["fast"] = 0.100,
    ["veryfast"] = 0.200,
}

---@type {string: {amplitude: float, center: float}}
local original_themes = {
    ["light"] = { amplitude = 15, center = 240 },
    ["pastel"] = { amplitude = 55, center = 200 },
    ["default"] = { amplitude = 127.5, center = 127.5 },
    ["vibrant"] = { amplitude = 50, center = 100 },
    ["deep"] = { amplitude = 25, center = 50 },
}

require("util")
---@type {string: Color[]}
local pride_flag_themes = {
    ["trans"] = {        -- trans pride
        util.color("#5BCEFA"), -- light blue
        util.color("#F5A9B8"), -- light pink
        util.color("#FFFFFF"), -- white
        util.color("#F5A9B8"), -- light pink
        -- util.color("#5BCEFA"), -- light blue
    },
    ["lesbian"] = {      -- lesbian pride
        util.color("#D52D00"), -- dark orange
        util.color("#EF7627"), -- mid orange
        util.color("#FF9A56"), -- light orange
        util.color("#FFFFFF"), -- white
        util.color("#D162A4"), -- light pink
        util.color("#B55690"), -- mid pink
        util.color("#A30262"), -- dark pink
    },
    ["bi"] = {           -- bi pride
        util.color("#D60270"), -- pink
        util.color("#D60270"), -- pink
        util.color("#9B4F96"), -- purple
        util.color("#0038A8"), -- blue
        util.color("#0038A8"), -- blue
    },
    ["nonbinary"] = {    -- nonbinary pride
        util.color("#FCF434"), -- yellow
        util.color("#FFFFFF"), -- white
        util.color("#9C59D1"), -- purple
        util.color("#000000"), -- black
    },
    ["pan"] = {          -- pan pride
        util.color("#FF218C"), -- pink
        util.color("#FFD800"), -- yellow
        util.color("#21B1FF"), -- blue
    },
    ["ace"] = {          -- ace pride
        util.color("#000000"), -- black
        util.color("#A3A3A3"), -- grey
        util.color("#FFFFFF"), -- white
        util.color("#800080"), -- purple
    },
    ["progress"] = {     -- progress pride
        util.color("#FFFFFF"), -- white
        util.color("#FFAFC8"), -- pink
        util.color("#74D7EE"), -- light blue
        util.color("#613915"), -- brown
        util.color("#000000"), -- black
        util.color("#E40303"), -- red
        util.color("#FF8C00"), -- orange
        util.color("#FFED00"), -- yellow
        util.color("#008026"), -- green
        util.color("#24408E"), -- blue
        util.color("#732982"), -- purple
    },
    ["agender"] = {      -- agender pride
        util.color("#000000"), -- black
        util.color("#BCC4C7"), -- grey
        util.color("#FFFFFF"), -- white
        util.color("#B7F684"), -- green
        util.color("#FFFFFF"), -- white
        util.color("#BCC4C7"), -- grey
        -- util.color("#000000"), -- black
    },
    ["gay"] = {          -- gay pride
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
local national_flag_themes = {
    ["united nations"] = { -- population 7.4 billion, rank 0
        util.color("#019EDB"), -- blue
        util.color("#019EDB"), -- blue
        util.color("#019EDB"), -- blue
        util.color("#FFFFFF"), -- white
        util.color("#019EDB"), -- blue
        util.color("#019EDB"), -- blue
        util.color("#019EDB"), -- blue
    },
    ["china"] = {        -- population 1.4 billion, rank 1
        util.color("#EE1C25"), -- red
        util.color("#FFFF00"), -- yellow
    },
    ["india"] = {        -- population 1.3 billion, rank 2
        util.color("#FF9933"), -- saffron
        util.color("#FFFFFF"), -- white
        util.color("#138808"), -- green
        -- util.color("#000080"), -- navy blue
    },
    ["united states"] = { -- population 335 million, rank 3
        util.color("#B31942"), -- red
        util.color("#FFFFFF"), -- white
        util.color("#0A3161"), -- blue
    },
    ["indonesia"] = {    -- population 277 million, rank 4
        util.color("#ED1C24"), -- red
        util.color("#FFFFFF"), -- white
    },
    ["pakistan"] = {     -- population 220 million, rank 5
        util.color("#FFFFFF"), -- white
        util.color("#00401A"), -- dark green
        util.color("#00401A"), -- dark green
    },
    ["nigeria"] = {      -- population 216 million, rank 6
        util.color("#008753"), -- green
        util.color("#FFFFFF"), -- white
        util.color("#008753"), -- green
    },
    ["brazil"] = {       -- population 203 million, rank 7
        util.color("#009739"), -- green
        util.color("#FEDD00"), -- yellow
        util.color("#FFFFFF"), -- white
        util.color("#012169"), -- blue
    },
    ["bangladesh"] = {   -- population 162 million, rank 8
        util.color("#006a4e"), -- green
        util.color("#f42a41"), -- red
        util.color("#006A4E"), -- green
    },
    ["russia"] = {       -- population 146 million, rank 9
        util.color("#FFFFFF"), -- white
        util.color("#1C3578"), -- blue
        util.color("#E4181C"), -- red
    },
    ["mexico"] = {       -- population 129 million, rank 10
        util.color("#006341"), -- dark green
        util.color("#FFFFFF"), -- white
        util.color("#C8102E"), -- red
    },
    ["japan"] = {        -- population 124 million, rank 11
        util.color("#BC002D"), -- red
        util.color("#FFFFFF"), -- white
    },
    ["philippines"] = {  -- population 110 million, rank 12
        util.color("#0038A8"), -- blue
        util.color("#CE1126"), -- red
        util.color("#FFFFFF"), -- white
        -- util.color("#FCD116"), -- gold
    },
    ["ethiopia"] = {                      -- population 105 million, rank 13
        util.color("#098930"),            -- yellow
        util.color("#FCDD0C"),            -- yellow
        util.color("#DA131B"),            -- yellow
    },
    ["egypt"] = {                         -- population 102 million, rank 14
        util.color("#CE1126"),            -- red
        util.color("#FFFFFF"),            -- white
        util.color("#000000"),            -- black
    },
    ["vietnam"] = {                       -- population 97 million, rank 15
        util.color("#DA251D"),            -- red
        util.color("#FFFF00"),            -- yellow
    },
    ["democratic republic of the congo"] = { -- population 89 million, rank 16
        util.color("#007FFF"),            -- blue
        util.color("#CE1021"),            -- red
        util.color("#F7D618"),            -- yellow
    },
    ["turkey"] = {                        -- population 84 million, rank 17
        util.color("#E30A17"),            -- red
        util.color("#FFFFFF"),            -- white
    },
    ["iran"] = {                          -- population 84 million, rank 18
        util.color("#239f40"),            -- green
        util.color("#FFFFFF"),            -- white
        util.color("#DA0000"),            -- red
    },
    ["germany"] = {                       -- population 84 million, rank 19
        util.color("#000000"),            -- schwarz
        util.color("#DD0000"),            -- rot
        util.color("#FFCE00"),            -- gold
    },
    ["thailand"] = {                      -- population 68 million, rank 20
        util.color("#A51931"),            -- red
        util.color("#F4F5F8"),            -- white
        util.color("#2D2A4A"),            -- blue
        util.color("#2D2A4A"),            -- blue
        util.color("#F4F5F8"),            -- white
        util.color("#A51931"),            -- red
    },
    ["france"] = {                        -- population 68 million, rank 21
        util.color("#0055A4"),            -- blue
        util.color("#FFFFFF"),            -- white
        util.color("#EF4135"),            -- red
    },
    ["united kingdom"] = {                -- population 67 million, rank 22
        util.color("#FFFFFF"),            -- white
        util.color("#C8102E"),            -- red
        util.color("#012169"),            -- blue
    },
    ["tanzania"] = {                      -- population 61 million, rank 23
        util.color("#1FB53A"),            -- green
        util.color("#1FB53A"),            -- green
        util.color("#FCD116"),            -- yellow
        util.color("#000000"),            -- black
        util.color("#000000"),            -- black
        util.color("#FCD116"),            -- yellow
        util.color("#01A2DD"),            -- blue
        util.color("#01A2DD"),            -- blue
    },
    ["south africa"] = {                  -- population 60 million, rank 24
        util.color("#000000"),            -- black
        util.color("#FFB612"),            -- gold
        util.color("#007A4D"),            -- green
        util.color("#FFFFFF"),            -- white
        util.color("#DE3831"),            -- red
        util.color("#007A4D"),            -- green
        util.color("#FFFFFF"),            -- white
        util.color("#002395"),            -- blue
    },
    ["italy"] = {                         -- population 58 million, rank 25
        util.color("#008C45"),            -- green
        util.color("#F4F5F0"),            -- white
        util.color("#CD212A"),            -- red
    },
    ["ukraine"] = {                       -- population 41 million, rank 36
        util.color("#0057B7"),            -- blue
        util.color("#FFDD00"),            -- yellow
    },
    ["australia"] = {                     -- population 26 million, rank 53
        util.color("#00008B"),            -- blue
        util.color("#FFFFFF"),            -- white
        util.color("#FF0000"),            -- red
    },
    ["netherlands"] = {                   -- population 17 million, rank 67
        util.color("#AD1D25"),            -- red
        util.color("#FFFFFF"),            -- white
        util.color("#1E4785"),            -- blue
    },
    ["belgium"] = {                       -- population 11 million, rank 82
        util.color("#000000"),            -- black
        util.color("#FDDA24"),            -- yellow
        util.color("#EF3340"),            -- red
    },
    ["cuba"] = {                          -- population 11 million, rank 85
        util.color("#D21034"),            -- red
        util.color("#002590"),            -- blue
        util.color("#FFFFFF"),            -- white
    },
    ["czech republic"] = {                -- population 10 million, rank 86
        util.color("#11457E"),            -- blue
        util.color("#FFFFFF"),            -- white
        util.color("#D7141A"),            -- red
    },
    ["greece"] = {                        -- population 10 million, rank 89
        util.color("#004C98"),            -- blue
        util.color("#FFFFFF"),            -- white
    },
    ["sweden"] = {                        -- population 10 million, rank 87
        util.color("#006AA7"),            -- blue
        util.color("#FECC02"),            -- yellow
    }
}

---@type {string: Color[]}
local seasonal_color_themes = {
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

---@type {string: Color[]}
local natural_themes = {
    ["water"] = {
        util.color("#71A8D2"),
        util.color("#3C7FB1"),
        util.color("#4D8EB6"),
        util.color("#2A6A9C"),
        util.color("#0F2D40"),
        util.color("#1A3F5A"),
        util.color("#336E94"),
        util.color("#1F4B6E"),
        util.color("#173C52"),
        util.color("#0F2D40"),
        util.color("#234E6E"),
        util.color("#1A3F5A"),
        util.color("#091E2D")
    },
    ["earth"] = {
        util.color("#B78E5C"),
        util.color("#E0B87C"),
        util.color("#6B4629"),
        util.color("#A67C52"),
        util.color("#9E7749"),
        util.color("#7C5A3D"),
        util.color("#3A1C10"),
        util.color("#5A3D2A"),
        util.color("#835C38"),
        util.color("#4D2E1C"),
        util.color("#52311C"),
        util.color("#6B4629"),
        util.color("#261007")
    },
    ["fire"] = {
        util.color("#FF6900"),
        util.color("#FF8519"),
        util.color("#FFC766"),
        util.color("#FFDF80"),
        util.color("#FF8519"),
        util.color("#FF4D00"),
        util.color("#FF9C33"),
        util.color("#FFB14D"),
        util.color("#FF4D00"),
        util.color("#FF8519"),
        util.color("#FFB14D"),
        util.color("#FFDF80"),
        util.color("#FFDF80")
    },
    ["air"] = {
        util.color("#E6F7FF"),
        util.color("#CCEAFF"),
        util.color("#99D9FF"),
        util.color("#66C4FF"),
        util.color("#B3E3FF"),
        util.color("#80CFFF"),
        util.color("#4DBAFF")
    },
    ["ice"] = {
        util.color("#3692E6"),
        util.color("#C3E6FF"),
        util.color("#8ACBFF"),
        util.color("#6EBDFF"),
        util.color("#A6D9FF"),
        util.color("#52B0FF"),
        util.color("#1A74CC")
    },
    ["sunlight"] = {
        util.color("#FFC266"),
        util.color("#FFFAE5"),
        util.color("#FFDF80"),
        util.color("#FFEAB3"),
        util.color("#FFD999"),
        util.color("#FFD080"),
        util.color("#FFF2CC"),
        util.color("#FFD080"),
        util.color("#FFBA4D")
    },
    ["moonlight"] = {
        util.color("#6666FF"),
        util.color("#E5E5FF"),
        util.color("#B3B3FF"),
        util.color("#8080FF"),
        util.color("#9999FF"),
        util.color("#B3B3FF"),
        util.color("#4D4DFF"),
        util.color("#CCCCFF"),
        util.color("#E5E5FF"),
        util.color("#9999FF"),
        util.color("#CCCCFF"),
        util.color("#4D4DFF")
    },
    ["stars"] = {
        util.color("#FFF5E5"),
        util.color("#FFC266"),
        util.color("#FFD999"),
        util.color("#52B0FF"),
        util.color("#FFBA4D"),
        util.color("#CCCCFF"),
        util.color("#FFE0B3"),
        util.color("#FFF5F0"),
        util.color("#FFD080"),
        util.color("#B3B3FF"),
        util.color("#FFB84D")
    },
    ["sunrise"] = {
        util.color("#FF9F6E"),
        util.color("#FFB488"),
        util.color("#FFCFA2"),
        util.color("#FFDDBC"),
        util.color("#FFECD6"),
        util.color("#FFF5F0"),
        util.color("#FFFBFA")
    },
    ["sunset"] = {
        util.color("#FF6F69"),
        util.color("#FF867D"),
        util.color("#FF9D91"),
        util.color("#FFB3A5"),
        util.color("#FFCAB9"),
        util.color("#FFD1C6"),
        util.color("#FFE8DC")
    },
    ["fog"] = {
        util.color("#D9D9D9"),
        util.color("#BFBFBF"),
        util.color("#595959"),
        util.color("#737373"),
        util.color("#C0C0C0"),
        util.color("#A6A6A6"),
        util.color("#737373"),
        util.color("#404040"),
        util.color("#737373"),
        util.color("#8C8C8C"),
        util.color("#737373"),
        util.color("#8C8C8C"),
        util.color("#404040")
    },
    ["rain"] = {
        util.color("#5CC8FF"),
        util.color("#4DBAFF"),
        util.color("#127CFF"),
        util.color("#0F69FF"),
        util.color("#49B5FF"),
        util.color("#1A8CFF"),
        util.color("#248FFF"),
        util.color("#0F69FF"),
        util.color("#37A2FF"),
        util.color("#248FFF"),
        util.color("#0069FF"),
        util.color("#0F69FF"),
        util.color("#0056E6")
    },
    ["snow"] = {
        util.color("#BFBFBF"),
        util.color("#FFFFFF"),
        util.color("#E5E5E5"),
        util.color("#CCCCCC"),
        util.color("#FFFFFF"),
        util.color("#E5E5E5"),
        util.color("#F2F2F2"),
        util.color("#CCCCCC"),
        util.color("#D8D8D8"),
        util.color("#E5E5E5"),
        util.color("#CCCCCC"),
        util.color("#E5E5E5"),
        util.color("#B3B3B3")
    },
    ["forest"] = {
        util.color("#6B8E23"),
        util.color("#008000"),
        util.color("#32CD32"),
        util.color("#3CB371"),
        util.color("#006400"),
        util.color("#228B22"),
        util.color("#96884B"),
        util.color("#2E8B57"),
        util.color("#008000"),
        util.color("#808000")
    },
    ["meadow"] = {
        util.color("#7CFC00"),
        util.color("#228B22"),
        util.color("#32CD32"),
        util.color("#ADFF2F"),
        util.color("#9ACD32"),
        util.color("#008000"),
        util.color("#006400")
    },
    ["ocean"] = {
        util.color("#98CCEC"),
        util.color("#5BAED3"),
        util.color("#3E9CBF"),
        util.color("#1F8EAA"),
        util.color("#79BDDF"),
        util.color("#B6DBF9"),
        util.color("#D5EBFF")
    },
    ["desert"] = {
        util.color("#D2B48C"),
        util.color("#C8AD81"),
        util.color("#A08F56"),
        util.color("#BEA476"),
        util.color("#AA9761"),
        util.color("#B49E6B"),
        util.color("#96884B")
    },
    ["mountain"] = {
        util.color("#5D5349"),
        util.color("#736B61"),
        util.color("#D18FBF"),
        util.color("#B895A6"),
        util.color("#A19A8F"),
        util.color("#8A8378"),
        util.color("#B895A6"),
        util.color("#8A8378"),
        util.color("#736B61"),
        util.color("#EB8ADA"),
        util.color("#B895A6"),
        util.color("#8A8378")
    },
    ["rainforest"] = {
        util.color("#008B45"),
        util.color("#00C3A0"),
        util.color("#00A157"),
        util.color("#00B786"),
        util.color("#00AD6E"),
        util.color("#00D0BA"),
        util.color("#00DDD4")
    },
    ["coral reef"] = {
        util.color("#FFCCA0"),
        util.color("#FF6C40"),
        util.color("#FFB986"),
        util.color("#FF9360"),
        util.color("#FF7F50"),
        util.color("#FFA673"),
        util.color("#FFE0B9")
    },
    ["volcano"] = {
        util.color("#AA2400"),
        util.color("#8E0C00"),
        util.color("#9C1800"),
        util.color("#B83000"),
        util.color("#800000"),
        util.color("#C63C00"),
        util.color("#D44800")
    },
    ["waterfall"] = {
        util.color("#8EC3FF"),
        util.color("#5A81FF"),
        util.color("#74A8FF"),
        util.color("#4D74FF"),
        util.color("#81B5FF"),
        util.color("#678EFF"),
        util.color("#9BD0FF")
    },
    ["cave"] = {
        util.color("#808080"),
        util.color("#595959"),
        util.color("#4D4D4D"),
        util.color("#737576"),
        util.color("#666666"),
        util.color("#8C8C8C"),
        util.color("#737373"),
        util.color("#999999"),
        util.color("#595959"),
        util.color("#666666"),
        util.color("#8C8C8C"),
        util.color("#737373"),
        util.color("#999999")
    },
    ["canyon"] = {
        util.color("#AB4E20"),
        util.color("#8C3B0C"),
        util.color("#D16826"),
        util.color("#E07E3C"),
        util.color("#EE822C"),
        util.color("#F28E3A"),
        util.color("#BF5B23"),
        util.color("#F59E4C"),
        util.color("#FA8F2F"),
        util.color("#F9A03F"),
        util.color("#E07529"),
        util.color("#F9B55A"),
        util.color("#FF9C32")
    }
}

---@type {string: Color[]}
local railway_company_themes = {
    ["deutsche bahn"] = {
        -- https://logos-world.net/deutsche-bahn-logo
        util.color("#EC1B2D"),
    },
    ["SNCF"] = {
        -- color pick from company logo https://www.sncf.com/fr/groupe/marques/sncf/identite
        util.color("#7E2270"),
        util.color("#98177A"),
        util.color("#A51475"),
        util.color("#B11864"),
        util.color("#BB1952"),
        util.color("#C61B40"),
        util.color("#D91C24"),
        util.color("#DA1E26"),
    },
    ["union pacific"] = {
        -- https://utahrails.net/up/up-paint-html.php
        util.color("#635F56"),
        util.color("#D10000"),
        util.color("#FEBD00"),
        util.color("#FEBD00"),
        util.color("#FEBD00"),
        util.color("#D10000"),
        util.color("#635F56"),
    },
    ["BNSF"] = {
        -- https://www.bnsf.com/brand2k5/pdf/bnsf-brand-quick-reference-guide.pdf
        util.color("#f85d13"),
        util.color("#2B2926"),
    },
    ["CSX"] = {
        -- https://www.csx.com/index.cfm/library/files/customers/style-test/
        util.color("#00467F"),
        util.color("#FFC939"),
        util.color("#4D4F53"),
        util.color("#000000"),
    },
    ["CN"] = {
        -- https://www.cn.ca/-/media/Files/Media/Media-Image-Centre/FIN-1BasicElement.pdf
        util.color("#ED1A2D"),
    },
    ["trenitalia"] = {
        -- color pick from company logo https://www.trenitalia.com
        util.color("#006C68"),
        util.color("#FFFFFF"),
        util.color("#E31837"),
    },
    ["amtrak"] = {
        -- https://history.amtrak.com/archives/amtrak-livery-and-logo-guide-2018/@@download/item/Amtrak%20Livery%20and%20Logo%20Guide%202-8-19.pdf
        util.color("#00537D"),
        util.color("#00537D"),
        util.color("#FFFFFF"),
        util.color("#EF3823"),
        util.color("#FFFFFF"),
        util.color("#00537D"),
        util.color("#00537D"),
    }
}
-- util.color("#"),

---@type {string: Color[]}
local animation_themes = {}
for name, colors in pairs(pride_flag_themes) do
    animation_themes[name] = colors
end
for name, colors in pairs(national_flag_themes) do
    animation_themes[name] = colors
end
for name, colors in pairs(seasonal_color_themes) do
    animation_themes[name] = colors
end
for name, colors in pairs(natural_themes) do
    animation_themes[name] = colors
end
for name, colors in pairs(railway_company_themes) do
    animation_themes[name] = colors
end

---@type string[]
local animation_names = {}
for name, _ in pairs(animation_themes) do
    table.insert(animation_names, name)
end

---@type string[]
local pride_flag_names = {}
for name, _ in pairs(pride_flag_themes) do
    table.insert(pride_flag_names, name)
end

---@type string[]
local national_flag_names = {}
for name, _ in pairs(national_flag_themes) do
    table.insert(national_flag_names, name)
end

---@type string[]
local seasonal_color_names = {}
for name, _ in pairs(seasonal_color_themes) do
    table.insert(seasonal_color_names, name)
end

---@type string[]
local natural_theme_names = {}
for name, _ in pairs(natural_themes) do
    table.insert(natural_theme_names, name)
end

---@type string[]
local railway_theme_names = {}
for name, _ in pairs(railway_company_themes) do
    table.insert(railway_theme_names, name)
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
    -- [defines.train_state.path_lost] = true,
    [defines.train_state.wait_signal] = false,
    [defines.train_state.wait_station] = false,
}

return {
    speeds = speeds,
    original_themes = original_themes,
    pride_flag_themes = pride_flag_themes,
    national_flag_themes = national_flag_themes,
    seasonal_color_themes = seasonal_color_themes,
    railway_company_themes = railway_company_themes,
    natural_themes = natural_themes,
    animation_themes = animation_themes,
    animation_names = animation_names,
    pride_flag_names = pride_flag_names,
    national_flag_names = national_flag_names,
    seasonal_color_names = seasonal_color_names,
    railway_theme_names = railway_theme_names,
    natural_theme_names = natural_theme_names,
    default_chat_colors = default_chat_colors,
    balance_to_ticks = balance_to_ticks,
    trail_types = trail_types,
    active_states = active_states
}
