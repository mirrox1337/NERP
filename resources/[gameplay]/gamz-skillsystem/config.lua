Config = {}

Config.UpdateFrequency = 7200 -- seconds interval between removing values 

Config.Notifications = true -- notification when skill is added

Config.Skills = {
    ["Kondition"] = {
        ["Current"] = 5, -- Default value 
        ["RemoveAmount"] = -0.4, -- % to remove when updating,
        ["Stat"] = "MP0_STAMINA" -- GTA stat hashname
    },

    ["Styrka"] = {
        ["Current"] = 5,
        ["RemoveAmount"] = -0.3,
        ["Stat"] = "MP0_STRENGTH"
    },

    ["Lungkapacitet"] = {
        ["Current"] = 2,
        ["RemoveAmount"] = -0.2,
        ["Stat"] = "MP0_LUNG_CAPACITY"
    },

    ["Skytte"] = {
        ["Current"] = 0,
        ["RemoveAmount"] = -0.1,
        ["Stat"] = "MP0_SHOOTING_ABILITY"
    },

    ["Körning"] = {
        ["Current"] = 0,
        ["RemoveAmount"] = -0.3,
        ["Stat"] = "MP0_DRIVING_ABILITY"
    }
--[[
    ["Wheelie"] = {
        ["Current"] = 0,
        ["RemoveAmount"] = -0.2,
        ["Stat"] = "MP0_WHEELIE_ABILITY"
    }
]]
}
