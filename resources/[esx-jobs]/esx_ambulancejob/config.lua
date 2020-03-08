Config                            = {}

Config.DrawDistance               = 20.0

Config.Marker                     = {type = 27, x = 1.2, y = 1.2, z = 0.1, r = 119, g = 18, b = 130, a = 100, rotate = true }

Config.ReviveReward               = 700  -- revive reward, set to 0 if you don't want it enabled
Config.AntiCombatLog              = true -- enable anti-combat logging?
Config.LoadIpl                    = false -- disable if you're using fivem-ipl or other IPL loaders

Config.Locale                     = 'sv'

Config.EarlyRespawnTimer          = 60000 * 1  -- time til respawn is available
Config.BleedoutTimer              = 60000 * 10 -- time til the player bleeds out

Config.EnablePlayerManagement     = true

Config.RemoveWeaponsAfterRPDeath  = true
Config.RemoveCashAfterRPDeath     = true
Config.RemoveItemsAfterRPDeath    = true

-- Let the player pay for respawning early, only if he can afford it.
Config.EarlyRespawnFine           = false
Config.EarlyRespawnFineAmount     = 5000

Config.RespawnPoint = {coords = vector3(358.98, -588.91, 28.8), heading = 254.16}

Config.Hospitals = {

	CentralLosSantos = {

		Blip = {
			coords = vector3(299.29, -584.74, 48.26),
			sprite = 61,
			scale  = 0.8,
			color  = 2
		},

		AmbulanceActions = {
			vector3(299.01, -598.27, 42.31)
		},

		Pharmacies = {
			vector3(311.88, -597.51, 42.31)
		},

		Vehicles = {
			{
				Spawner = vector3(321.56, -557.99, 28.75),
				InsideShop = vector3(446.7, -1355.6, 43.5),
				Marker = { type = 36, x = 1.0, y = 1.0, z = 1.0, r = 119, g = 18, b = 130, a = 100, rotate = true },
				SpawnPoints = {
					{ coords = vector3(317.08, -556.25, 27.8), heading = 270.0, radius = 1.5 },
					{ coords = vector3(317.08, -553.46, 27.8), heading = 270.0, radius = 1.5 },
					{ coords = vector3(317.08, -550.66, 27.8), heading = 270.0, radius = 1.5 },
					{ coords = vector3(317.08, -547.83, 27.8), heading = 270.0, radius = 1.5 },
					{ coords = vector3(317.08, -544.97, 27.8), heading = 270.0, radius = 1.5 },
					{ coords = vector3(320.97, -541.74, 27.8), heading = 180.0, radius = 1.5 },
					{ coords = vector3(323.77, -541.74, 27.8), heading = 180.0, radius = 1.5 },
					{ coords = vector3(326.66, -541.74, 27.8), heading = 180.0, radius = 1.5 },
					{ coords = vector3(329.41, -541.74, 27.8), heading = 180.0, radius = 1.5 },
					{ coords = vector3(332.27, -541.74, 27.8), heading = 180.0, radius = 1.5 },
					{ coords = vector3(335.1,  -541.74, 27.8), heading = 180.0, radius = 1.5 }
				}
			}
		},

		Helicopters = {
			{
				Spawner = vector3(338.53, -586.84, 74.2),
				InsideShop = vector3(305.6, -1419.7, 41.5),
				Marker = { type = 34, x = 1.5, y = 1.5, z = 1.5, r = 119, g = 18, b = 130, a = 100, rotate = true },
				SpawnPoints = {
					{ coords = vector3(351.98, -588.05, 74.2), heading = 307.46, radius = 10.0 }
				}
			}
		},

		FastTravels = {
			--[[
			{
				From = vector3(294.7, -1448.1, 29.0),
				To = {coords = vector3(272.8, -1358.8, 23.5), heading = 0.0},
				Marker = {type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false}
			},

			{
				From = vector3(275.3, -1361, 23.5),
				To = {coords = vector3(295.8, -1446.5, 28.9), heading = 0.0},
				Marker = {type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false}
			},

			{
				From = vector3(247.3, -1371.5, 23.5),
				To = {coords = vector3(333.1, -1434.9, 45.5), heading = 138.6},
				Marker = {type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false}
			},

			{
				From = vector3(335.5, -1432.0, 45.50),
				To = {coords = vector3(249.1, -1369.6, 23.5), heading = 0.0},
				Marker = {type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false}
			},

			{
				From = vector3(234.5, -1373.7, 20.9),
				To = {coords = vector3(320.9, -1478.6, 28.8), heading = 0.0},
				Marker = {type = 1, x = 1.5, y = 1.5, z = 1.0, r = 102, g = 0, b = 102, a = 100, rotate = false}
			},

			{
				From = vector3(317.9, -1476.1, 28.9),
				To = {coords = vector3(238.6, -1368.4, 23.5), heading = 0.0},
				Marker = {type = 1, x = 1.5, y = 1.5, z = 1.0, r = 102, g = 0, b = 102, a = 100, rotate = false}
			}
			--]]
		},

		FastTravelsPrompt = {
			--Hissen till taket
			{
				From = vector3(330.11, -601.15, 43.28),
				To = {coords = vector3(339.07, -584.02, 74.16), heading = 0.0},
				Marker = {type = 20, x = 0.5, y = 0.1, z = 0.5, r = 119, g = 18, b = 130, a = 100, bob = true, face = true, rotate = false},
				Prompt = ('Tryck på ~INPUT_CONTEXT~ ta hissen upp till ~p~Taket')
			},

			--Hissen från taket
			{
				From = vector3(339.07, -584.02, 74.16),
				To = {coords = vector3(330.11, -601.15, 43.28), heading = 0.0},
				Marker = {type = 20, x = 0.5, y = 0.1, z = -0.5, r = 119, g = 18, b = 130, a = 100, bob = true, face = true, rotate = false},
				Prompt = ('Tryck på ~INPUT_CONTEXT~ ta hissen ner till ~p~Hisshallen')
			},

			--Hissen till garaget
			{
				From = vector3(332.26, -595.68, 43.28),
				To = {coords = vector3(319.62, -560.14, 28.73), heading = 0.0},
				Marker = {type = 20, x = 0.5, y = 0.1, z = -0.5, r = 119, g = 18, b = 130, a = 100, bob = true, face = true, rotate = false},
				Prompt = ('Tryck på ~INPUT_CONTEXT~ ta hissen ner till ~p~Garaget')
			},

			--Hissen från garaget
			{
				From = vector3(319.62, -560.14, 28.73),
				To = {coords = vector3(332.37, -595.53, 43.27), heading = 0.0},
				Marker = {type = 20, x = 0.5, y = 0.1, z = 0.5, r = 119, g = 18, b = 130, a = 100, bob = true, face = true, rotate = false},
				Prompt = ('Tryck på ~INPUT_CONTEXT~ ta hissen upp till ~p~Hisshallen')
			}
		}

	}
}

Config.AuthorizedVehicles = {
	car = {
		ambulance = {
			{label = 'Ambulans - Volvo XC70', model = 'ambulance', price = 100},
          	{label = 'Ambulans - Volkswagen Amarok', model = 'ambulance2', price = 100},
          	{label = 'Ambulans - Volvo XC90 Nilsson', model = 'xc90n', price = 100},
          	{label = 'Akutbil', model = 'policeold2', price = 100},  
		},

		doctor = {
			{label = 'Ambulans - Volvo XC70', model = 'ambulance', price = 100},
          	{label = 'Ambulans - Volkswagen Amarok', model = 'ambulance2', price = 100},
          	{label = 'Ambulans - Volvo XC90 Nilsson', model = 'xc90n', price = 100},
          	{label = 'Akutbil', model = 'policeold2', price = 100},  
		},

		chief_doctor = {
			{label = 'Ambulans - Volvo XC70', model = 'ambulance', price = 100},
          	{label = 'Ambulans - Volkswagen Amarok', model = 'ambulance2', price = 100},
          	{label = 'Ambulans - Volvo XC90 Nilsson', model = 'xc90n', price = 100},
          	{label = 'Akutbil', model = 'policeold2', price = 100},  
		},

		boss = {
			{label = 'Ambulans - Volvo XC70', model = 'ambulance', price = 100},
          	{label = 'Ambulans - Volkswagen Amarok', model = 'ambulance2', price = 100},
          	{label = 'Ambulans - Volvo XC90 Nilsson', model = 'xc90n', price = 100},
          	{label = 'Akutbil', model = 'policeold2', price = 100},  
		}
	},

	helicopter = {
		ambulance = {},

		doctor = {
			{model = 'frogger', price = 100}
		},

		chief_doctor = {
			{model = 'frogger', price = 100},
		},

		boss = {
			{model = 'frogger', price = 100},
		}
	}
}
