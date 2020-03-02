Config = {}

Config.Cut = {5, 10} -- money taken from the company min 5% max 10% (random)
Config.Enable3DText = true
Config.transferTime = 300 -- time required to transfer the money (seconds)
Config.RobberyDelay = 6.01 -- delay to rob the same company again (hours)
Config.MinimumCopsOnline = 5

-- Here you can add more jobs
Config.Jobs = {
    ["cardealer"] = {
        Pos = vector3(-32.12, -1108.79, 25.42),
        Heading = 335.20,
        open = false
    },
    ["taxi"] = {
        Pos = vector3(907.55, -157.52, 82.5),
        Heading = 235.8,
        open = false
    },
    ["bennys"] = {
        Pos = vector3(-203.83, -1338.35, 29.89),
        Heading = 268.58,
        open = false
    },
    ["unicorn"] = {
        Pos = vector3(98.27, -1290.08, 28.31),
        Heading = 301.65,
        open = false
    },
    ["mecano"] = {
        Pos = vector3(-350.62, -125.44, 38.01),
        Heading = 337.01,
        open = false
    }
}

Config["translation"] = {
    RobberyDelay = "~r~There has been recent a robbery here please wait",
    NotEnoughCops = "~r~There is not enough cops to start the robbery.",
    SendToCops = "There is a on going robbery.",
    PressToRob = "Press [E] to rob company",
    TransferingMoney = "Transfering money, please wait and stay close for the ~b~bluetooth ~w~connection. Time left ",
    StartHack = "Press [E] to initialize hack"
}