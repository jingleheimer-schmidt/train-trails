
if mods["Automatic_Train_Painter"] then
    if data.raw["string-setting"] and data.raw["string-setting"]["u-loco"] then
        data.raw["string-setting"]["u-loco"].default_value = ""
    end
end

-- require("colorize_locale")
