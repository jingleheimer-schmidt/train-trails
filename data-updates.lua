
local func_capture = require("__simhelper__.funccapture")


  if game.active_mods["train-trails"] then
local func_capture = require("__simhelper__.funccapture")

    ---@type {string: float}
    local speeds = {
      ["veryslow"] = 0.010,
      ["slow"] = 0.025,
      ["default"] = 0.050,
      ["fast"] = 0.100,
      ["veryfast"] = 0.200,
    }

    ---@type {string: {amplitude: float, center: float}}
    local original_palettes = {
      ["light"] = { amplitude = 15, center = 240 },
      ["pastel"] = { amplitude = 55, center = 200 },
      ["default"] = { amplitude = 127.5, center = 127.5 },
      ["vibrant"] = { amplitude = 50, center = 100 },
      ["deep"] = { amplitude = 25, center = 50 },
    }

    local function hex_to_rgb(hex)
      hex = hex:gsub("#","")
      return {
        r = tonumber("0x"..hex:sub(1,2)) / 255,
        g = tonumber("0x"..hex:sub(3,4)) / 255,
        b = tonumber("0x"..hex:sub(5,6)) / 255,
      }
local constants = require("util/constants")
local speeds = constants.speeds
local original_palettes = constants.original_palettes
local hex_to_rgb = constants.hex_to_rgb
local pride_flag_palettes = constants.pride_flag_palettes
local national_flag_palettes = constants.national_flag_palettes
local seasonal_color_palettes = constants.seasonal_color_palettes
local natural_palettes = constants.natural_palettes
local railway_company_palettes = constants.railway_company_palettes
local animation_palettes = constants.animation_palettes
local animation_names = constants.animation_names
local trail_types = constants.trail_types
local balance_to_ticks = constants.balance_to_ticks
local default_chat_colors = constants.default_chat_colors
local active_states = constants.active_states
local random_palette_names = constants.random_palette_names

local train_data_util = require("util/train_data")
local create_train_data = train_data_util.create_train_data
    end

    ---@type {string: Color[]}
    local pride_flag_palettes = {
      ["trans"] = {              -- trans pride
          hex_to_rgb("#5BCEFA"), -- light blue
          hex_to_rgb("#F5A9B8"), -- light pink
          hex_to_rgb("#FFFFFF"), -- white
          hex_to_rgb("#F5A9B8"), -- light pink
          -- hex_to_rgb("#5BCEFA"), -- light blue
      },
      ["lesbian"] = {            -- lesbian pride
          hex_to_rgb("#D52D00"), -- dark orange
          hex_to_rgb("#EF7627"), -- mid orange
          hex_to_rgb("#FF9A56"), -- light orange
          hex_to_rgb("#FFFFFF"), -- white
          hex_to_rgb("#D162A4"), -- light pink
          hex_to_rgb("#B55690"), -- mid pink
          hex_to_rgb("#A30262"), -- dark pink
      },
      ["bi"] = {                 -- bi pride
          hex_to_rgb("#D60270"), -- pink
          hex_to_rgb("#D60270"), -- pink
          hex_to_rgb("#9B4F96"), -- purple
          hex_to_rgb("#0038A8"), -- blue
          hex_to_rgb("#0038A8"), -- blue
      },
      ["nonbinary"] = {          -- nonbinary pride
          hex_to_rgb("#FCF434"), -- yellow
          hex_to_rgb("#FFFFFF"), -- white
          hex_to_rgb("#9C59D1"), -- purple
          hex_to_rgb("#000000"), -- black
      },
      ["pan"] = {                -- pan pride
          hex_to_rgb("#FF218C"), -- pink
          hex_to_rgb("#FFD800"), -- yellow
          hex_to_rgb("#21B1FF"), -- blue
      },
      ["ace"] = {                -- ace pride
          hex_to_rgb("#000000"), -- black
          hex_to_rgb("#A3A3A3"), -- grey
          hex_to_rgb("#FFFFFF"), -- white
          hex_to_rgb("#800080"), -- purple
      },
      ["progress"] = {           -- progress pride
          hex_to_rgb("#FFFFFF"), -- white
          hex_to_rgb("#FFAFC8"), -- pink
          hex_to_rgb("#74D7EE"), -- light blue
          hex_to_rgb("#613915"), -- brown
          hex_to_rgb("#000000"), -- black
          hex_to_rgb("#E40303"), -- red
          hex_to_rgb("#FF8C00"), -- orange
          hex_to_rgb("#FFED00"), -- yellow
          hex_to_rgb("#008026"), -- green
          hex_to_rgb("#24408E"), -- blue
          hex_to_rgb("#732982"), -- purple
      },
      ["agender"] = {            -- agender pride
          hex_to_rgb("#000000"), -- black
          hex_to_rgb("#BCC4C7"), -- grey
          hex_to_rgb("#FFFFFF"), -- white
          hex_to_rgb("#B7F684"), -- green
          hex_to_rgb("#FFFFFF"), -- white
          hex_to_rgb("#BCC4C7"), -- grey
          -- hex_to_rgb("#000000"), -- black
      },
      ["gay"] = {                -- gay pride
          hex_to_rgb("#078D70"), -- dark green
          hex_to_rgb("#26CEAA"), -- medium green
          hex_to_rgb("#98E8C1"), -- light green
          hex_to_rgb("#FFFFFF"), -- white
          hex_to_rgb("#7BADE2"), -- light blue
          hex_to_rgb("#5049CC"), -- indigo
          hex_to_rgb("#3D1A78"), -- dark blue
      }
    }

    ---@type {string: Color[]}
    local national_flag_palettes = {
      ["united nations"] = { -- population 7.4 billion, rank 0
        hex_to_rgb("#019EDB"), -- blue
        hex_to_rgb("#019EDB"), -- blue
        hex_to_rgb("#019EDB"), -- blue
        hex_to_rgb("#FFFFFF"), -- white
        hex_to_rgb("#019EDB"), -- blue
        hex_to_rgb("#019EDB"), -- blue
        hex_to_rgb("#019EDB"), -- blue
      },
      ["china"] = { -- population 1.4 billion, rank 1
        hex_to_rgb("#EE1C25"), -- red
        hex_to_rgb("#FFFF00"), -- yellow
      },
      ["india"] = { -- population 1.3 billion, rank 2
        hex_to_rgb("#FF9933"), -- saffron
        hex_to_rgb("#FFFFFF"), -- white
        hex_to_rgb("#138808"), -- green
        -- hex_to_rgb("#000080"), -- navy blue
      },
      ["united states"] = { -- population 335 million, rank 3
        hex_to_rgb("#B31942"), -- red
        hex_to_rgb("#FFFFFF"), -- white
        hex_to_rgb("#0A3161"), -- blue
      },
      ["indonesia"] = { -- population 277 million, rank 4
        hex_to_rgb("#ED1C24"), -- red
        hex_to_rgb("#FFFFFF"), -- white
      },
      ["pakistan"] = { -- population 220 million, rank 5
        hex_to_rgb("#FFFFFF"), -- white
        hex_to_rgb("#00401A"), -- dark green
        hex_to_rgb("#00401A"), -- dark green
      },
      ["nigeria"] = { -- population 216 million, rank 6
        hex_to_rgb("#008753"), -- green
        hex_to_rgb("#FFFFFF"), -- white
        hex_to_rgb("#008753"), -- green
      },
      ["brazil"] = { -- population 203 million, rank 7
        hex_to_rgb("#009739"), -- green
        hex_to_rgb("#FEDD00"), -- yellow
        hex_to_rgb("#FFFFFF"), -- white
        hex_to_rgb("#012169"), -- blue
      },
      ["bangladesh"] = { -- population 162 million, rank 8
        hex_to_rgb("#006a4e"), -- green
        hex_to_rgb("#f42a41"), -- red
        hex_to_rgb("#006A4E"), -- green
      },
      ["russia"] = { -- population 146 million, rank 9
        hex_to_rgb("#FFFFFF"), -- white
        hex_to_rgb("#1C3578"), -- blue
        hex_to_rgb("#E4181C"), -- red
      },
      ["mexico"] = { -- population 129 million, rank 10
        hex_to_rgb("#006341"), -- dark green
        hex_to_rgb("#FFFFFF"), -- white
        hex_to_rgb("#C8102E"), -- red
      },
      ["japan"] = { -- population 124 million, rank 11
        hex_to_rgb("#BC002D"), -- red
        hex_to_rgb("#FFFFFF"), -- white
      },
      ["philippines"] = { -- population 110 million, rank 12
        hex_to_rgb("#0038A8"), -- blue
        hex_to_rgb("#CE1126"), -- red
        hex_to_rgb("#FFFFFF"), -- white
        -- hex_to_rgb("#FCD116"), -- gold
      },
      ["ethiopia"] = { -- population 105 million, rank 13
        hex_to_rgb("#098930"), -- yellow
        hex_to_rgb("#FCDD0C"), -- yellow
        hex_to_rgb("#DA131B"), -- yellow
      },
      ["egypt"] = { -- population 102 million, rank 14
        hex_to_rgb("#CE1126"), -- red
        hex_to_rgb("#FFFFFF"), -- white
        hex_to_rgb("#000000"), -- black
      },
      ["vietnam"] = { -- population 97 million, rank 15
        hex_to_rgb("#DA251D"), -- red
        hex_to_rgb("#FFFF00"), -- yellow
      },
      ["democratic republic of the congo"] = { -- population 89 million, rank 16
        hex_to_rgb("#007FFF"), -- blue
        hex_to_rgb("#CE1021"), -- red
        hex_to_rgb("#F7D618"), -- yellow
      },
      ["turkey"] = { -- population 84 million, rank 17
        hex_to_rgb("#E30A17"), -- red
        hex_to_rgb("#FFFFFF"), -- white
      },
      ["iran"] = { -- population 84 million, rank 18
        hex_to_rgb("#239f40"), -- green
        hex_to_rgb("#FFFFFF"), -- white
        hex_to_rgb("#DA0000"), -- red
      },
      ["germany"] = { -- population 84 million, rank 19
        hex_to_rgb("#000000"), -- schwarz
        hex_to_rgb("#DD0000"), -- rot
        hex_to_rgb("#FFCE00"), -- gold
      },
      ["thailand"] = { -- population 68 million, rank 20
        hex_to_rgb("#A51931"), -- red
        hex_to_rgb("#F4F5F8"), -- white
        hex_to_rgb("#2D2A4A"), -- blue
        hex_to_rgb("#2D2A4A"), -- blue
        hex_to_rgb("#F4F5F8"), -- white
        hex_to_rgb("#A51931"), -- red
      },
      ["france"] = { -- population 68 million, rank 21
        hex_to_rgb("#0055A4"), -- blue
        hex_to_rgb("#FFFFFF"), -- white
        hex_to_rgb("#EF4135"), -- red
      },
      ["united kingdom"] = { -- population 67 million, rank 22
        hex_to_rgb("#FFFFFF"), -- white
        hex_to_rgb("#C8102E"), -- red
        hex_to_rgb("#012169"), -- blue
      },
      ["tanzania"] = { -- population 61 million, rank 23
        hex_to_rgb("#1FB53A"), -- green
        hex_to_rgb("#1FB53A"), -- green
        hex_to_rgb("#FCD116"), -- yellow
        hex_to_rgb("#000000"), -- black
        hex_to_rgb("#000000"), -- black
        hex_to_rgb("#FCD116"), -- yellow
        hex_to_rgb("#01A2DD"), -- blue
        hex_to_rgb("#01A2DD"), -- blue
      },
      ["south africa"] = { -- population 60 million, rank 24
        hex_to_rgb("#000000"), -- black
        hex_to_rgb("#FFB612"), -- gold
        hex_to_rgb("#007A4D"), -- green
        hex_to_rgb("#FFFFFF"), -- white
        hex_to_rgb("#DE3831"), -- red
        hex_to_rgb("#007A4D"), -- green
        hex_to_rgb("#FFFFFF"), -- white
        hex_to_rgb("#002395"), -- blue
      },
      ["italy"] = { -- population 58 million, rank 25
        hex_to_rgb("#008C45"), -- green
        hex_to_rgb("#F4F5F0"), -- white
        hex_to_rgb("#CD212A"), -- red
      },
      ["ukraine"] = { -- population 41 million, rank 36
        hex_to_rgb("#0057B7"), -- blue
        hex_to_rgb("#FFDD00"), -- yellow
      },
      ["australia"] = { -- population 26 million, rank 53
        hex_to_rgb("#00008B"), -- blue
        hex_to_rgb("#FFFFFF"), -- white
        hex_to_rgb("#FF0000"), -- red
      },
      ["netherlands"] = { -- population 17 million, rank 67
        hex_to_rgb("#AD1D25"), -- red
        hex_to_rgb("#FFFFFF"), -- white
        hex_to_rgb("#1E4785"), -- blue
      },
      ["belgium"] = { -- population 11 million, rank 82
        hex_to_rgb("#000000"), -- black
        hex_to_rgb("#FDDA24"), -- yellow
        hex_to_rgb("#EF3340"), -- red
      },
      ["cuba"] = { -- population 11 million, rank 85
        hex_to_rgb("#D21034"), -- red
        hex_to_rgb("#002590"), -- blue
        hex_to_rgb("#FFFFFF"), -- white
      },
      ["czech republic"] = { -- population 10 million, rank 86
        hex_to_rgb("#11457E"), -- blue
        hex_to_rgb("#FFFFFF"), -- white
        hex_to_rgb("#D7141A"), -- red
      },
      ["greece"] = { -- population 10 million, rank 89
        hex_to_rgb("#004C98"), -- blue
        hex_to_rgb("#FFFFFF"), -- white
      },
      ["sweden"] = { -- population 10 million, rank 87
        hex_to_rgb("#006AA7"), -- blue
        hex_to_rgb("#FECC02"), -- yellow
      }
    }

    ---@type {string: Color[]}
    local seasonal_color_palettes = {
      ["fresh spring"] = {
          hex_to_rgb("#BBE7C6"),
          hex_to_rgb("#A4DEAB"),
          hex_to_rgb("#D7E8BA"),
          hex_to_rgb("#FAF3DD"),
          hex_to_rgb("#F3D250")
      },
      ["blossoming spring"] = {
          hex_to_rgb("#F9C1BB"),
          hex_to_rgb("#FDD6BD"),
          hex_to_rgb("#FFF3D4"),
          hex_to_rgb("#BCD8BF"),
          hex_to_rgb("#93C4AE")
      },
      ["vibrant summer"] = {
          hex_to_rgb("#FF6F69"),
          hex_to_rgb("#FFCC5C"),
          hex_to_rgb("#88D8B0"),
          hex_to_rgb("#5A9E6E"),
          hex_to_rgb("#49796B")
      },
      ["lively summer"] = {
          hex_to_rgb("#F3D250"),
          hex_to_rgb("#FFEE8A"),
          hex_to_rgb("#FFCB74"),
          hex_to_rgb("#FF9F6E"),
          hex_to_rgb("#FF677D")
      },
      ["golden autumn"] = {
          hex_to_rgb("#E8A87C"),
          hex_to_rgb("#C38D9E"),
          hex_to_rgb("#A6A5B5"),
          hex_to_rgb("#98C1D9"),
          hex_to_rgb("#FFD28F")
      },
      ["crisp autumn"] = {
          hex_to_rgb("#FF8666"),
          hex_to_rgb("#FFB383"),
          hex_to_rgb("#FFD9A5"),
          hex_to_rgb("#F7F0B3"),
          hex_to_rgb("#BFD5AA")
      },
      ["cozy winter"] = {
          hex_to_rgb("#FFE6E8"),
          hex_to_rgb("#F2EFFD"),
          hex_to_rgb("#D9E4F5"),
          hex_to_rgb("#A1C4F2"),
          hex_to_rgb("#7FB8F5")
      },
      ["serene winter"] = {
          hex_to_rgb("#D1E3FF"),
          hex_to_rgb("#D8D7F8"),
          hex_to_rgb("#F0D6FF"),
          hex_to_rgb("#FFE1F0"),
          hex_to_rgb("#E9F0FF")
      }
    }

    ---@type {string: Color[]}
    local natural_palettes = {
      ["water"] = {
        hex_to_rgb("#71A8D2"),
        hex_to_rgb("#4D8EB6"),
        hex_to_rgb("#0F2D40"),
        hex_to_rgb("#336E94"),
        hex_to_rgb("#173C52"),
        hex_to_rgb("#234E6E"),
        hex_to_rgb("#091E2D")
      },
      ["earth"] = {
        hex_to_rgb("#B78E5C"),
        hex_to_rgb("#6B4629"),
        hex_to_rgb("#9E7749"),
        hex_to_rgb("#3A1C10"),
        hex_to_rgb("#835C38"),
        hex_to_rgb("#52311C"),
        hex_to_rgb("#261007")
      },
      ["fire"] = {
        hex_to_rgb("#FF6900"),
        hex_to_rgb("#FFC766"),
        hex_to_rgb("#FF8519"),
        hex_to_rgb("#FF9C33"),
        hex_to_rgb("#FF4D00"),
        hex_to_rgb("#FFB14D"),
        hex_to_rgb("#FFDF80")
      },
      ["air"] = {
        hex_to_rgb("#E6F7FF"),
        hex_to_rgb("#CCEAFF"),
        hex_to_rgb("#99D9FF"),
        hex_to_rgb("#66C4FF"),
        hex_to_rgb("#B3E3FF"),
        hex_to_rgb("#80CFFF"),
        hex_to_rgb("#4DBAFF")
      },
      ["ice"] = {
        hex_to_rgb("#3692E6"),
        hex_to_rgb("#C3E6FF"),
        hex_to_rgb("#8ACBFF"),
        hex_to_rgb("#6EBDFF"),
        hex_to_rgb("#A6D9FF"),
        hex_to_rgb("#52B0FF"),
        hex_to_rgb("#1A74CC")
      },
      ["sunlight"] = {
        hex_to_rgb("#FFC266"),
        hex_to_rgb("#FFFAE5"),
        hex_to_rgb("#FFEAB3"),
        hex_to_rgb("#FFD999"),
        hex_to_rgb("#FFF2CC"),
        hex_to_rgb("#FFD080"),
        hex_to_rgb("#FFBA4D")
      },
      ["moonlight"] = {
        hex_to_rgb("#6666FF"),
        hex_to_rgb("#E5E5FF"),
        hex_to_rgb("#8080FF"),
        hex_to_rgb("#B3B3FF"),
        hex_to_rgb("#CCCCFF"),
        hex_to_rgb("#9999FF"),
        hex_to_rgb("#4D4DFF")
      },
      ["stars"] = {
        hex_to_rgb("#FFF5E5"),
        hex_to_rgb("#FFC266"),
        hex_to_rgb("#52B0FF"),
        hex_to_rgb("#FFE0B3"),
        hex_to_rgb("#FFF5F0"),
        hex_to_rgb("#B3B3FF"),
        hex_to_rgb("#FFB84D")
      },
      ["sunrise"] = {
        hex_to_rgb("#FF9F6E"),
        hex_to_rgb("#FFB488"),
        hex_to_rgb("#FFCFA2"),
        hex_to_rgb("#FFDDBC"),
        hex_to_rgb("#FFECD6"),
        hex_to_rgb("#FFF5F0"),
        hex_to_rgb("#FFFBFA")
      },
      ["sunset"] = {
        hex_to_rgb("#FF6F69"),
        hex_to_rgb("#FF867D"),
        hex_to_rgb("#FF9D91"),
        hex_to_rgb("#FFB3A5"),
        hex_to_rgb("#FFCAB9"),
        hex_to_rgb("#FFD1C6"),
        hex_to_rgb("#FFE8DC")
      },
      ["fog"] = {
        hex_to_rgb("#D9D9D9"),
        hex_to_rgb("#595959"),
        hex_to_rgb("#C0C0C0"),
        hex_to_rgb("#737373"),
        hex_to_rgb("#A6A6A6"),
        hex_to_rgb("#8C8C8C"),
        hex_to_rgb("#404040")
      },
      ["rain"] = {
        hex_to_rgb("#5CC8FF"),
        hex_to_rgb("#127CFF"),
        hex_to_rgb("#49B5FF"),
        hex_to_rgb("#248FFF"),
        hex_to_rgb("#37A2FF"),
        hex_to_rgb("#0069FF"),
        hex_to_rgb("#0056E6")
      },
      ["snow"] = {
        hex_to_rgb("#BFBFBF"),
        hex_to_rgb("#E5E5E5"),
        hex_to_rgb("#FFFFFF"),
        hex_to_rgb("#F2F2F2"),
        hex_to_rgb("#D8D8D8"),
        hex_to_rgb("#CCCCCC"),
        hex_to_rgb("#B3B3B3")
      },
      ["forest"] = {
        hex_to_rgb("#6B8E23"),
        hex_to_rgb("#008000"),
        hex_to_rgb("#3CB371"),
        hex_to_rgb("#006400"),
        hex_to_rgb("#228B22"),
        hex_to_rgb("#2E8B57"),
        hex_to_rgb("#808000")
      },
      ["meadow"] = {
        hex_to_rgb("#7CFC00"),
        hex_to_rgb("#228B22"),
        hex_to_rgb("#32CD32"),
        hex_to_rgb("#ADFF2F"),
        hex_to_rgb("#9ACD32"),
        hex_to_rgb("#008000"),
        hex_to_rgb("#006400")
      },
      ["ocean"] = {
        hex_to_rgb("#98CCEC"),
        hex_to_rgb("#5BAED3"),
        hex_to_rgb("#3E9CBF"),
        hex_to_rgb("#1F8EAA"),
        hex_to_rgb("#79BDDF"),
        hex_to_rgb("#B6DBF9"),
        hex_to_rgb("#D5EBFF")
      },
      ["desert"] = {
        hex_to_rgb("#D2B48C"),
        hex_to_rgb("#C8AD81"),
        hex_to_rgb("#A08F56"),
        hex_to_rgb("#BEA476"),
        hex_to_rgb("#AA9761"),
        hex_to_rgb("#B49E6B"),
        hex_to_rgb("#96884B")
      },
      ["mountain"] = {
        hex_to_rgb("#5D5349"),
        hex_to_rgb("#736B61"),
        hex_to_rgb("#D18FBF"),
        hex_to_rgb("#A19A8F"),
        hex_to_rgb("#B895A6"),
        hex_to_rgb("#8A8378"),
        hex_to_rgb("#EB8ADA")
      },
      ["rainforest"] = {
        hex_to_rgb("#008B45"),
        hex_to_rgb("#00C3A0"),
        hex_to_rgb("#00A157"),
        hex_to_rgb("#00B786"),
        hex_to_rgb("#00AD6E"),
        hex_to_rgb("#00D0BA"),
        hex_to_rgb("#00DDD4")
      },
      ["coral reef"] = {
        hex_to_rgb("#FFCCA0"),
        hex_to_rgb("#FF6C40"),
        hex_to_rgb("#FFB986"),
        hex_to_rgb("#FF9360"),
        hex_to_rgb("#FF7F50"),
        hex_to_rgb("#FFA673"),
        hex_to_rgb("#FFE0B9")
      },
      ["volcano"] = {
        hex_to_rgb("#AA2400"),
        hex_to_rgb("#8E0C00"),
        hex_to_rgb("#9C1800"),
        hex_to_rgb("#B83000"),
        hex_to_rgb("#800000"),
        hex_to_rgb("#C63C00"),
        hex_to_rgb("#D44800")
      },
      ["waterfall"] = {
        hex_to_rgb("#8EC3FF"),
        hex_to_rgb("#5A81FF"),
        hex_to_rgb("#74A8FF"),
        hex_to_rgb("#4D74FF"),
        hex_to_rgb("#81B5FF"),
        hex_to_rgb("#678EFF"),
        hex_to_rgb("#9BD0FF")
      },
      ["cave"] = {
        hex_to_rgb("#808080"),
        hex_to_rgb("#4D4D4D"),
        hex_to_rgb("#666666"),
        hex_to_rgb("#737373"),
        hex_to_rgb("#595959"),
        hex_to_rgb("#8C8C8C"),
        hex_to_rgb("#999999")
      },
      ["canyon"] = {
        hex_to_rgb("#AB4E20"),
        hex_to_rgb("#D16826"),
        hex_to_rgb("#EE822C"),
        hex_to_rgb("#BF5B23"),
        hex_to_rgb("#FA8F2F"),
        hex_to_rgb("#E07529"),
        hex_to_rgb("#FF9C32")
      }
    }

    ---@type {string: Color[]}
    local railway_company_palettes = {
      ["deutsche bahn"] = { -- https://logos-world.net/deutsche-bahn-logo
          hex_to_rgb("#EC1B2D"),
      },
      ["SNCF"] = { -- color pick from company logo https://www.sncf.com/fr/groupe/marques/sncf/identite
          hex_to_rgb("#7E2270"),
          hex_to_rgb("#98177A"),
          hex_to_rgb("#A51475"),
          hex_to_rgb("#B11864"),
          hex_to_rgb("#BB1952"),
          hex_to_rgb("#C61B40"),
          hex_to_rgb("#D91C24"),
          hex_to_rgb("#DA1E26"),
      },
      ["union pacific"] = { -- https://utahrails.net/up/up-paint-html.php
          hex_to_rgb("#635F56"),
          hex_to_rgb("#D10000"),
          hex_to_rgb("#FEBD00"),
          hex_to_rgb("#FEBD00"),
          hex_to_rgb("#FEBD00"),
          hex_to_rgb("#D10000"),
          hex_to_rgb("#635F56"),
      },
      ["BNSF"] = { -- https://www.bnsf.com/brand2k5/pdf/bnsf-brand-quick-reference-guide.pdf
          hex_to_rgb("#f85d13"),
          hex_to_rgb("#2B2926"),
      },
      ["CSX"] = { -- https://www.csx.com/index.cfm/library/files/customers/style-test/
          hex_to_rgb("#00467F"),
          hex_to_rgb("#FFC939"),
          hex_to_rgb("#4D4F53"),
          hex_to_rgb("#000000"),
      },
      ["CN"] = { -- https://www.cn.ca/-/media/Files/Media/Media-Image-Centre/FIN-1BasicElement.pdf
          hex_to_rgb("#ED1A2D"),
      },
      ["trenitalia"] = { -- color pick from company logo https://www.trenitalia.com
          hex_to_rgb("#006C68"),
          hex_to_rgb("#FFFFFF"),
          hex_to_rgb("#E31837"),
      },
      ["amtrak"] = { -- https://history.amtrak.com/archives/amtrak-livery-and-logo-guide-2018/@@download/item/Amtrak%20Livery%20and%20Logo%20Guide%202-8-19.pdf
          hex_to_rgb("#00537D"),
          hex_to_rgb("#00537D"),
          hex_to_rgb("#FFFFFF"),
          hex_to_rgb("#EF3823"),
          hex_to_rgb("#FFFFFF"),
          hex_to_rgb("#00537D"),
          hex_to_rgb("#00537D"),
      }
    }
    -- hex_to_rgb("#"),

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
    for name, colors in pairs(natural_palettes) do
      animation_palettes[name] = colors
    end
    for name, colors in pairs(railway_company_palettes) do
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

    ---@type string[]
    local natural_palette_names = {}
    for name, _ in pairs(natural_palettes) do
      table.insert(natural_palette_names, name)
    end

    ---@type string[]
    local railway_palette_names = {}
    for name, _ in pairs(railway_company_palettes) do
      table.insert(railway_palette_names, name)
    end

    --- @type {string: Color|string}
    local default_chat_colors = {
      ["red"] = { r = 1.000, g = 0.166, b = 0.141 } ,
      ["orange"] = { r = 1.000, g = 0.630, b = 0.259 } ,
      ["yellow"] = { r = 1.000, g = 0.828, b = 0.231 } ,
      ["green"] = { r = 0.173, g = 0.824, b = 0.250 } ,
      ["blue"] = { r = 0.343, g = 0.683, b = 1.000 } ,
      ["purple"] = { r = 0.821, g = 0.440, b = 0.998 } ,
      ["black"] = { r = 0.1, g = 0.1, b = 0.1 } ,
      ["white"] = { r = 0.9, g = 0.9, b = 0.9 } ,
      ["pink"] = { r = 1.000, g = 0.520, b = 0.633 } ,
      ["gray"] = { r = 0.7, g = 0.7, b = 0.7 } ,
      ["cyan"] = { r = 0.335, g = 0.918, b = 0.866 } ,
      ["brown"] = { r = 0.757, g = 0.522, b = 0.371 } ,
      ["acid"] = { r = 0.708, g = 0.996, b = 0.134 } ,
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

    local random_palette_names = {
      ["random all"] = animation_names,
      ["random pride"] = pride_flag_names,
      ["random country"] = national_flag_names,
      ["random seasonal"] = seasonal_color_names,
      ["random natural"] = natural_palette_names,
      ["random railway"] = railway_palette_names
    }

    local sin = math.sin
    local abs = math.abs
    local max = math.max
    local floor = math.floor
    local random = math.random
    local pi_0 = 0 * math.pi / 3
    local pi_2 = 2 * math.pi / 3
    local pi_4 = 4 * math.pi / 3
    local draw_light = rendering.draw_light
    local draw_sprite = rendering.draw_sprite

    -- gets a random color palette within mod setting restrictions
    ---@param mod_settings mod_settings
    ---@return Color.0|Color.1[]?
    local function get_random_palette(mod_settings)
      local palette_name = mod_settings.palette
      local random_palette_name = random_palette_names[palette_name] and random_palette_names[palette_name][random(#random_palette_names[palette_name])] or nil
      local random_palette = random_palette_name and animation_palettes[random_palette_name] or nil
      return random_palette
    end

    -- add static data to the active_trains table to reduce lookup time
    ---@param mod_settings mod_settings
    ---@param train LuaTrain
    ---@return train_data
    local function create_train_data(mod_settings, train)
      local random_palette = get_random_palette(mod_settings)
      return {
        surface_index = train.carriages[1].surface_index,
        train = train,
        id = train.id,
        front_stock = train.front_stock,
        back_stock = train.back_stock,
        random_animation_colors = random_palette,
        random_animation_colors_count = random_palette and #random_palette,
        adjusted_length = mod_settings.length + ((#train.carriages - 1) * 30)
      }
    end

    -- save mod settings to global to reduce lookup time
    ---@return mod_settings
    local function get_mod_settings()
      local settings = settings.global
      local palette_name = settings["train-trails-palette"].value
      ---@type mod_settings
      return {
        sprite = trail_types.sprite[ settings["train-trails-color-and-glow"].value  ],
        light = trail_types.light[ settings["train-trails-color-and-glow"].value  ],
        length = tonumber(settings["train-trails-length"].value) ,
        scale = tonumber(settings["train-trails-scale"].value) ,
        color_type = settings["train-trails-color-type"].value ,
        balance = balance_to_ticks[ settings["train-trails-balance"].value  ],
        passengers_only = settings["train-trails-passengers-only"].value ,
        default_color = default_chat_colors[ settings["train-trails-default-color"].value  ],
        frequency = speeds[ settings["train-trails-speed"].value  ],
        amplitude = original_palettes[palette_name] and original_palettes[palette_name].amplitude,
        center = original_palettes[palette_name] and original_palettes[palette_name].center,
        animation_colors = animation_palettes[palette_name],
        animation_color_count = animation_palettes[palette_name] and #animation_palettes[palette_name],
        palette = palette_name,
      }
    end

    ---@param mod_settings mod_settings
    ---@return {uint: train_data}
    local function get_active_trains(mod_settings)
      local active_trains = nil
      for _, surface in pairs(game.surfaces) do
        for _, train in pairs(surface.get_trains()) do
          if active_states[train.state] then
            local data = create_train_data(mod_settings, train)
            active_trains = active_trains or {}
            active_trains[train.id] = data
          end
        end
      end
      return active_trains
    end

    ---@param created_tick number
    ---@param mod_settings mod_settings
    ---@param train_data train_data
    ---@return Color
    local function get_rainbow_color(created_tick, mod_settings, train_data)
      local modifier = (train_data.id + created_tick) * mod_settings.frequency
      local amplitude = mod_settings.amplitude
      local center = mod_settings.center
      local animation_colors = train_data.random_animation_colors or mod_settings.animation_colors
      if amplitude and center then
        return {
          r = sin(modifier + pi_0) * amplitude + center,
          g = sin(modifier + pi_2) * amplitude + center,
          b = sin(modifier + pi_4) * amplitude + center,
          a = 255,
        }
      elseif animation_colors then
        local index = floor(modifier % (mod_settings.animation_color_count or train_data.random_animation_colors_count)) + 1
        return animation_colors[index]
      else
        return { 1, 1, 1 }
      end
    end

    -- get the color for a given trail
    ---@param event_tick uint
    ---@param mod_settings mod_settings
    ---@param train_data train_data
    ---@param stock LuaEntity
    ---@return Color?
    local function get_trail_color(event_tick, mod_settings, train_data, stock)
      local default_color = default_chat_colors[mod_settings.default_color]
      local color_type = mod_settings.color_type

      if color_type == "rainbow" then
        return get_rainbow_color(event_tick, mod_settings, train_data)
      elseif color_type == "train" then
        local color = stock.color

        if color then
          return color
        elseif default_color == "rainbow" then
          return get_rainbow_color(event_tick, mod_settings, train_data)
        elseif type(default_color) == "table" then
          return default_color
        end
      end
    end
    -- draw a trail segment for a given train
    ---@param event_tick uint
    ---@param mod_settings mod_settings
    ---@param train_data train_data
    ---@param speed int
    local function draw_trail_segment(event_tick, mod_settings, train_data, speed)
      local stock = speed > 0 and train_data.front_stock or train_data.back_stock
      if not stock then return end

      local color = get_trail_color(event_tick, mod_settings, train_data, stock)
      if not color then return end

      local position = stock.position
      local surface = train_data.surface_index
      local length = train_data.adjusted_length
      local scale = mod_settings.scale * max( abs(speed), 0.66 )

      if mod_settings.sprite then
        draw_sprite {
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
      if mod_settings.light then
        draw_light {
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

    -- normalize the number of trails drawn per tile to make trails look consistent at all speeds
    ---@param event_tick uint
    ---@param mod_settings mod_settings
    ---@param train_data train_data
    local function draw_normalized_trail_segment(event_tick, mod_settings, train_data)
      local speed = train_data.train.speed -- tiles per tick
      if speed == 0 then return end

      local train_id = train_data.id
      local distance_counters = global.distance_counters or {}
      local tiles_since_last_trail = (distance_counters[train_id] or 0) + abs(speed * mod_settings.balance)

      if tiles_since_last_trail >= 1/3 then
        draw_trail_segment(event_tick, mod_settings, train_data, speed)
        tiles_since_last_trail = 0
      end

      global.distance_counters[train_id] = tiles_since_last_trail
    end

    -- create a lookup table of surfaces that players can see
    ---@return table<uint, boolean>
    local function get_visible_surfaces()
      local visible_surfaces = {}
      for _, player in pairs(game.connected_players) do
        visible_surfaces[player.surface_index] = true
      end
      return visible_surfaces
    end
  end

-- draw trail segments for any visible active trains
---@param event_tick uint
---@param mod_settings mod_settings
local function draw_trails(event_tick, mod_settings)
  local sprite = mod_settings.sprite
  local light = mod_settings.light
  if not (sprite or light) then return end

  global.active_train_datas = global.active_train_datas or get_active_trains(mod_settings)
  local active_train_datas = global.active_train_datas
  if not active_train_datas then return end

  global.distance_counters = global.distance_counters or {}

  local visible_surfaces = get_visible_surfaces()
  for train_id, train_data in pairs(active_train_datas) do
    if train_data.train.valid then
      if not visible_surfaces[train_data.surface_index] then break end
      draw_normalized_trail_segment(event_tick, mod_settings, train_data)
    else
      global.active_trains[train_id] = nil
    end
  end
end

---@param event EventData.on_tick
local function on_tick(event)
  if script.active_mods["trains-rights"] then goto end_of_train_trails_script end
  local mod_settings = get_mod_settings()
  local event_tick = event.tick
  if event_tick % mod_settings.balance == 0 then
    draw_trails(event_tick, mod_settings)
  end
  ::end_of_train_trails_script::
end

local simulation_script = func_capture.capture(on_tick)

for _, main_menu_simulation in pairs(data.raw["utility-constants"]["default"].main_menu_simulations) do
  if main_menu_simulation then
    if main_menu_simulation.update then
      main_menu_simulation.update = main_menu_simulation.update .. simulation_script
    else
      main_menu_simulation.update = simulation_script
    end
  end
end
