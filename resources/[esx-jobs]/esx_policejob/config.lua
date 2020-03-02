Config                            = {}
Config.DrawDistance               = 100.0
Config.MarkerType                 = 27
Config.MarkerSize                 = {x = 1.5, y = 1.5, z = 0.5}
Config.MarkerColor                = {r = 0, g = 0, b = 255}
Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = true
Config.EnableESXIdentity          = true -- only turn this on if you are using esx_identity
Config.EnableNonFreemodePeds      = true -- turn this on if you want custom peds
Config.EnableSocietyOwnedVehicles = false
Config.MaxInService               = -1
Config.Locale                     = 'en'

Config.PoliceStations = {

  LSPD1 = {
    Blip = {
      Pos   = {x = 425.130, y = -979.558, z = 30.711},
      Sprite  = 60,
      Display = 4,
      Scale   = 0.8,
      Colour  = 4,
    },

    AuthorizedWeapons = {
      {name = 'WEAPON_NIGHTSTICK',       price = 690},
      {name = 'WEAPON_COMBATPISTOL',     price = 9199},
      {name = 'WEAPON_SMG',              price = 15899},
      {name = 'WEAPON_CARBINERIFLE',     price = 21999},
      {name = 'WEAPON_STUNGUN',          price = 4999},
      {name = 'WEAPON_FLASHLIGHT',       price = 999},
      {name = 'WEAPON_FIREEXTINGUISHER', price = 495},
      {name = 'WEAPON_FLAREGUN',         price = 4499},
    },

    AuthorizedVehicles = {
      {name = 'police' , label = 'Volvo XC70'},
      {name = 'police2', label = 'Volvo V90 CC'},
      {name = 'police3', label = 'Volkswagen Buss'},
      {name = 'police4', label = 'Volkswagen Golf - Civil'},
      {name = 'fbi', label = 'Volvo V90 CC - Civil'},
      {name = 'policeold2', label = 'Volkswagen Buss - Civil'},
      {name = 'policeb', label = 'BMW 1200R'},
      {name = 'policevw', label = 'Volkswagen Transport'},
    },

    Cloakrooms = {
      {x = 452.600, y = -993.306, z = 29.750},
    },

    Armories = {
      {x = 456.39144897461, y = -982.91027832031, z = 29.70}
    },

    Vehicles = {
      {
        Spawner    = {x = 457.92, y = -1010.66, z = 27.430},
        SpawnPoint = {x = 438.42, y = -1018.3, z = 27.757},
        Heading    = 90.0
      }
    },

    Helicopters = {
      {
        Spawner    = {x = 459.4, y = -983.93, z = 42.691},
        SpawnPoint = {x = 450.04, y = -981.14, z = 42.691},
        Heading    = 0.0
      }
    },

    VehicleDeleters = {
      {x = 462.40, y = -1019.7, z = 27.104},
      {x = 462.74, y = -1014.4, z = 27.065}
    },

    BossActions = {
      {x = 448.417, y = -973.208, z = 29.695}
    }

  },

  SASP1 = {
    Blip = {
      Pos   = {x = 825.34204101563, y = -1290.0471191406, z = 28.240659713745 },
      Sprite  = 60,
      Display = 4,
      Scale = 0.9,
      Colour  = 4,
    },

    AuthorizedWeapons = {
      {name = 'WEAPON_NIGHTSTICK',       price = 690},
      {name = 'WEAPON_COMBATPISTOL',     price = 9199},
      {name = 'WEAPON_ASSAULTSMG',       price = 15899},
      {name = 'WEAPON_SPECIALCARBINE',   price = 21999},
      {name = 'WEAPON_PUMPSHOTGUN',      price = 12499},
      {name = 'WEAPON_STUNGUN',          price = 4999},
      {name = 'WEAPON_FLASHLIGHT',       price = 999},
      {name = 'WEAPON_FIREEXTINGUISHER', price = 495},
      {name = 'WEAPON_FLAREGUN',         price = 4499},
    },

    AuthorizedVehicles = {
      {name = 'police' , label = 'Police Vehicle 1'},
      {name = 'police2', label = 'Police Vehicle 2'},
      {name = 'police3', label = 'Police Vehicle 3'},
      {name = 'police4', label = 'Police Vehicle 4'},
      {name = 'policeb', label = 'Motorcycle'},
      {name = 'policet', label = 'Transport Van'},
    },

    Cloakrooms = {
      {x = 830.11590576172, y = -1311.4512939453, z = 27.13673210144 } -- state pd
    },

    Armories = {
      {x = 858.25366210938, y = -1321.5992431641, z = 27.136734008789 } -- state pd
    },

    Vehicles = {
      {
        Spawner    = {x = 863.17700195313, y = -1346.2406005859, z = 25.039228439331 }, --state pd
        SpawnPoint = {x = 871.07720947266, y = -1350.00390625, z = 25.3092918396 },  -- state pd
        Heading    = 90.0 --state pd
      }
    },

    Helicopters = {
      {
        Spawner    = {x = 466.477, y = -982.819, z = 42.691},
        SpawnPoint = {x = 450.04, y = -981.14, z = 42.691},
        Heading    = 0.0
      }
    },

    VehicleDeleters = {
      {x = 823.95031738281, y = -1371.1483154297, z = 25.136753082275 } --state pd
    },

    BossActions = {
      {x = 359.96, y = 4843.29, z = -59.98 } --state pd
    }

  },

  LSPD2 = {
    Blip = {
      Pos   = {x = -441.80764770508, y = 6012.5131835938, z = 31.716369628906 },
      Sprite  = 60,
      Display = 4,
      Scale = 0.9,
      Colour  = 4,
    },

    AuthorizedWeapons = {
      {name = 'WEAPON_NIGHTSTICK',       price = 690},
      {name = 'WEAPON_COMBATPISTOL',     price = 9199},
      {name = 'WEAPON_ASSAULTSMG',       price = 15899},
      {name = 'WEAPON_SPECIALCARBINE',   price = 21999},
      {name = 'WEAPON_PUMPSHOTGUN',      price = 12499},
      {name = 'WEAPON_STUNGUN',          price = 4999},
      {name = 'WEAPON_FLASHLIGHT',       price = 999},
      {name = 'WEAPON_FIREEXTINGUISHER', price = 495},
      {name = 'WEAPON_FLAREGUN',         price = 4499},
    },

    AuthorizedVehicles = {
      {name = 'police' , label = 'Police Vehicle 1'},
      {name = 'police2', label = 'Police Vehicle 2'},
      {name = 'police3', label = 'Police Vehicle 3'},
      {name = 'police4', label = 'Police Vehicle 4'},
      {name = 'policeb', label = 'Motorcycle'},
      {name = 'policet', label = 'Transport Van'},
    },

    Cloakrooms = {
      {x = -450.2878112793, y = 6016.482421875, z = 30.716369628906 },
    },

    Armories = {
      {x = -448.04425048828, y = 6007.7104492188, z = 30.716369628906 },
    },

    Vehicles = {
      {
        Spawner    = {x = -452.30313110352, y = 6005.6704101563, z = 30.840929031372 },
        SpawnPoint = {x = -454.96899414063, y = 6001.8876953125, z = 30.340549468994 },
        Heading    = 87.0
      }
    },

    Helicopters = {
      {
        Spawner    = {x = -462.88317871094, y = 5993.7685546875, z = 30.245756149292 },
        SpawnPoint = {x = -475.48043823242, y = 5988.326171875, z = 30.336708068848 },
        Heading    = 270.0
      }
    },

    VehicleDeleters = {
      {x = -447.64434814453, y = 5994.5024414063, z = 30.340551376343 },
    },

    BossActions = {
      {x = -441.80764770508, y = 6012.5131835938, z = 30.716369628906 },
    }

  },

IAA = {
    Blip = {
      Pos   = {x = -441.80764770508, y = 6012.5131835938, z = 31.716369628906 },
      Sprite  = 60,
      Display = 4,
      Scale = 0.9,
      Colour  = 4,
    },

    AuthorizedWeapons = {
      {name = 'WEAPON_NIGHTSTICK',       price = 690},
      {name = 'WEAPON_COMBATPISTOL',     price = 9199},
      {name = 'WEAPON_ASSAULTSMG',       price = 15899},
      {name = 'WEAPON_SPECIALCARBINE',   price = 21999},
      {name = 'WEAPON_PUMPSHOTGUN',      price = 12499},
      {name = 'WEAPON_STUNGUN',          price = 4999},
      {name = 'WEAPON_FLASHLIGHT',       price = 999},
      {name = 'WEAPON_FIREEXTINGUISHER', price = 495},
      {name = 'WEAPON_FLAREGUN',         price = 4499},
    },

    AuthorizedVehicles = {
      {name = 'police' , label = 'Police Vehicle 1'},
      {name = 'police2', label = 'Police Vehicle 2'},
      {name = 'police3', label = 'Police Vehicle 3'},
      {name = 'police4', label = 'Police Vehicle 4'},
      {name = 'policeb', label = 'Motorcycle'},
      {name = 'policet', label = 'Transport Van'},
    },

    Cloakrooms = {
      {x = 424.43, y = 4827.33, z = -59.98}
    },

    Armories = {
      {x = 417.36, y = 4809.66, z = -59.98}
    },

    Vehicles = {
      {
        Spawner    = {x = -452.30313110352, y = 6005.6704101563, z = 30.840929031372 },
        SpawnPoint = {x = -454.96899414063, y = 6001.8876953125, z = 30.340549468994 },
        Heading    = 87.0
      }
    },

    Helicopters = {
      {
        Spawner    = {x = 2031.32, y = 3003.99, z = -72.7 },
        SpawnPoint = {x = 2063.49, y = 2935.8, z = 47.35 },
        Heading    = 270.0
      }
    },

    VehicleDeleters = {
      {x = 2059.54, y = 2935.7, z = 46.42 },
    },

    BossActions = {
      {x = 359.96, y = 4843.29, z = -59.98 }
    }

  },

  SASP2 = {
    Blip = {
      Pos   = {x = 1851.0972900391, y = 3683.7622070313, z = 34.26708984375 },
      Sprite  = 60,
      Display = 4,
      Scale = 0.9,
      Colour  = 4,
    },

    AuthorizedWeapons = {
      {name = 'WEAPON_NIGHTSTICK',       price = 690},
      {name = 'WEAPON_COMBATPISTOL',     price = 9199},
      {name = 'WEAPON_ASSAULTSMG',       price = 15899},
      {name = 'WEAPON_SPECIALCARBINE',   price = 21999},
      {name = 'WEAPON_PUMPSHOTGUN',      price = 12499},
      {name = 'WEAPON_STUNGUN',          price = 4999},
      {name = 'WEAPON_FLASHLIGHT',       price = 999},
      {name = 'WEAPON_FIREEXTINGUISHER', price = 495},
      {name = 'WEAPON_FLAREGUN',         price = 4499},
    },

    AuthorizedVehicles = {
      {name = 'police' , label = 'Police Vehicle 1'},
      {name = 'police2', label = 'Police Vehicle 2'},
      {name = 'police3', label = 'Police Vehicle 3'},
      {name = 'police4', label = 'Police Vehicle 4'},
      {name = 'policeb', label = 'Motorcycle'},
      {name = 'policet', label = 'Transport Van'},
    },

    Cloakrooms = {
      {x = 1857.2354736328, y = 3689.8408203125, z = 33.26708984375 }, -- state pd
    },

    Armories = {
      {x = 1848.3413085938, y = 3690.1345214844, z = 33.26708984375 }, -- state pd
    },

    Vehicles = {
      {
        Spawner    = {x = 1866.208984375, y = 3693.8125, z = 32.737236022949 }, --state pd
        SpawnPoint = {x = 1872.9417724609, y = 3690.5759277344, z = 32.569362640381 },  -- state pd
        Heading    = 90.0 --state pd
      }
    },

    Helicopters = {
      {
        Spawner    = {x = 466.477, y = -982.819, z = 42.691},
        SpawnPoint = {x = 450.04, y = -981.14, z = 42.691},
        Heading    = 0.0
      }
    },

    VehicleDeleters = {
      {x = 1866.4152832031, y = 3699.6052246094, z = 32.535938262939 }, --state pd
    },

    BossActions = {
      {x = 1851.0972900391, y = 3683.7622070313, z = 33.26708984375 }, --state pd
    }

  },

}
