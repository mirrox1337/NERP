Config                            = {}

Config.DrawDistance               = 5.0
Config.MarkerType                 = 20
Config.MarkerSize                 = {x = 1.2, y = 1.2, z = 0.1}
Config.MarkerColor                = {r = 119, g = 50, b = 204}

Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = true
Config.EnableESXIdentity          = true -- enable if you're using esx_identity
Config.EnableLicenses             = true -- enable if you're using esx_license

Config.EnableHandcuffTimer        = false -- enable handcuff timer? will unrestrain player after the time ends
Config.HandcuffTimer              = 10 * 60000 -- 10 mins

Config.EnableJobBlip              = false -- enable blips for cops on duty, requires esx_society
Config.EnableCustomPeds           = false -- enable custom peds in cloak room? See Config.CustomPeds below to customize peds

Config.EnableESXService           = false -- enable esx service?
Config.MaxInService               = 5

Config.Locale                     = 'sv'

Config.PoliceStations = {

	LSPD = {

		Blip = {
			Coords  = vector3(425.1, -979.5, 30.7),
			Sprite  = 60,
			Display = 4,
			Scale   = 0.8,
			Colour  = 29
		},

		Cloakrooms = {
			vector3(452.600, -993.306, 29.750)
		},

		Armories = {
			vector3(456.39144897461, -982.91027832031, 29.70)
		},

		Vehicles = {
			{
				Spawner = vector3(457.92, -1010.66, 28.430),
				InsideShop = vector3(228.5, -993.5, -99.5),
				SpawnPoints = {
					{coords = vector3(446.12, -1025.15, 28.29), heading = 4.6, radius = 4.0},
					{coords = vector3(442.27, -1025.8, 28.7), heading = 4.6, radius = 4.0},
					{coords = vector3(438.57, -1026.1, 28.44), heading = 4.6, radius = 4.0},
					{coords = vector3(434.98, -1026.73, 28.52), heading = 6.59, radius = 4.0},
					{coords = vector3(431.2, -1026.86, 28.58), heading = 6.59, radius = 4.0},
					{coords = vector3(427.37, -1027.29, 28.65), heading = 6.59, radius = 4.0}
				}
			},

			{
				Spawner = vector3(473.3, -1018.8, 28.0),
				InsideShop = vector3(228.5, -993.5, -99.0),
				SpawnPoints = {
					{coords = vector3(475.9, -1021.6, 28.0), heading = 276.1, radius = 6.0},
					{coords = vector3(484.1, -1023.1, 27.5), heading = 302.5, radius = 6.0}
				}
			}
		},

		Helicopters = {
			{
				Spawner = vector3(461.1, -981.5, 43.6),
				InsideShop = vector3(477.0, -1106.4, 43.0),
				SpawnPoints = {
					{coords = vector3(449.5, -981.2, 43.6), heading = 92.6, radius = 10.0}
				}
			}
		},

		BossActions = {
			vector3(448.417, -973.208, 29.695)
		}

	}

}

Config.AuthorizedWeapons = {
	recruit = {
		{weapon = 'WEAPON_NIGHTSTICK',       price = 690},
		{weapon = 'WEAPON_COMBATPISTOL', components = { 0, nil, 1000, nil, nil }, price = 9199 },
      	{weapon = 'WEAPON_STUNGUN',          price = 4999},
      	{weapon = 'WEAPON_FLASHLIGHT',       price = 999},
      	{weapon = 'WEAPON_FIREEXTINGUISHER', price = 495},
      	{weapon = 'WEAPON_FLAREGUN',         price = 4499}
	},

	officer = {
		{weapon = 'WEAPON_NIGHTSTICK',       price = 690},
		{weapon = 'WEAPON_COMBATPISTOL', components = { 0, nil, 1000, nil, nil }, price = 9199 },
		{weapon = 'WEAPON_SMG', components = { 0, nil, nil, 1000, 2500, nil }, price = 15899 },
		{weapon = 'WEAPON_SPECIALCARBINE', components = { 0, nil, nil, 4000, 8000, nil }, price = 21999 },
      	{weapon = 'WEAPON_STUNGUN',          price = 4999},
      	{weapon = 'WEAPON_FLASHLIGHT',       price = 999},
      	{weapon = 'WEAPON_FIREEXTINGUISHER', price = 495},
      	{weapon = 'WEAPON_FLAREGUN',         price = 4499}
	},

	sergeant = {
		{weapon = 'WEAPON_NIGHTSTICK',       price = 690},
		{weapon = 'WEAPON_COMBATPISTOL', components = { 0, nil, 1000, nil, nil }, price = 9199 },
		{weapon = 'WEAPON_SMG', components = { 0, nil, nil, 1000, 2500, nil }, price = 15899 },
		{weapon = 'WEAPON_SPECIALCARBINE', components = { 0, nil, nil, 4000, 8000, nil }, price = 21999 },
      	{weapon = 'WEAPON_STUNGUN',          price = 4999},
      	{weapon = 'WEAPON_FLASHLIGHT',       price = 999},
      	{weapon = 'WEAPON_FIREEXTINGUISHER', price = 495},
      	{weapon = 'WEAPON_FLAREGUN',         price = 4499}
	},

	lieutenant = {
		{weapon = 'WEAPON_NIGHTSTICK',       price = 690},
		{weapon = 'WEAPON_COMBATPISTOL', components = { 0, nil, 1000, nil, nil }, price = 9199 },
		{weapon = 'WEAPON_SMG', components = { 0, nil, nil, 1000, 2500, nil }, price = 15899 },
		{weapon = 'WEAPON_SPECIALCARBINE', components = { 0, nil, nil, 4000, 8000, nil }, price = 21999 },
      	{weapon = 'WEAPON_STUNGUN',          price = 4999},
      	{weapon = 'WEAPON_FLASHLIGHT',       price = 999},
      	{weapon = 'WEAPON_FIREEXTINGUISHER', price = 495},
      	{weapon = 'WEAPON_FLAREGUN',         price = 4499}
	},

	boss = {
		{weapon = 'WEAPON_NIGHTSTICK',       price = 690},
		{weapon = 'WEAPON_COMBATPISTOL', components = { 0, nil, 1000, nil, nil }, price = 9199 },
		{weapon = 'WEAPON_SMG', components = { 0, nil, nil, 4000, 8000, nil }, price = 15899 },
		{weapon = 'WEAPON_SPECIALCARBINE', components = { 0, nil, nil, 4000, 8000, nil }, price = 21999 },
      	{weapon = 'WEAPON_STUNGUN',          price = 4999},
      	{weapon = 'WEAPON_FLASHLIGHT',       price = 999},
      	{weapon = 'WEAPON_FIREEXTINGUISHER', price = 495},
      	{weapon = 'WEAPON_FLAREGUN',         price = 4499}
	}
}

Config.AuthorizedVehicles = {
	car = {
		recruit = {},

		officer = {
			{model = 'police' , label = 'Volvo XC70', price = 100},
      		{model = 'police2', label = 'Volvo V90 CC', price = 100},
      		{model = 'police3', label = 'Volkswagen Buss', price = 100},
      		{model = 'police4', label = 'Volkswagen Golf - Civil', price = 100},
      		{model = 'fbi', label = 'Volvo V90 CC - Civil', price = 100},
      		{model = 'policeold2', label = 'Volkswagen Buss - Civil', price = 100},
      		{model = 'policeb', label = 'BMW 1200R', price = 100},
     		{model = 'policevw', label = 'Volkswagen Transport', price = 100},
		},

		sergeant = {
			{model = 'police' , label = 'Volvo XC70', price = 100},
      		{model = 'police2', label = 'Volvo V90 CC', price = 100},
      		{model = 'police3', label = 'Volkswagen Buss', price = 100},
      		{model = 'police4', label = 'Volkswagen Golf - Civil', price = 100},
      		{model = 'fbi', label = 'Volvo V90 CC - Civil', price = 100},
      		{model = 'policeold2', label = 'Volkswagen Buss - Civil', price = 100},
      		{model = 'policeb', label = 'BMW 1200R', price = 100},
     		{model = 'policevw', label = 'Volkswagen Transport', price = 100},
		},

		lieutenant = {
			{model = 'police' , label = 'Volvo XC70', price = 100},
      		{model = 'police2', label = 'Volvo V90 CC', price = 100},
      		{model = 'police3', label = 'Volkswagen Buss', price = 100},
      		{model = 'police4', label = 'Volkswagen Golf - Civil', price = 100},
      		{model = 'fbi', label = 'Volvo V90 CC - Civil', price = 100},
      		{model = 'policeold2', label = 'Volkswagen Buss - Civil', price = 100},
      		{model = 'policeb', label = 'BMW 1200R', price = 100},
     		{model = 'policevw', label = 'Volkswagen Transport', price = 100},
		},

		boss = {
			{model = 'police' , label = 'Volvo XC70', price = 100},
      		{model = 'police2', label = 'Volvo V90 CC', price = 100},
      		{model = 'police3', label = 'Volkswagen Buss', price = 100},
      		{model = 'police4', label = 'Volkswagen Golf - Civil', price = 100},
      		{model = 'fbi', label = 'Volvo V90 CC - Civil', price = 100},
      		{model = 'policeold2', label = 'Volkswagen Buss - Civil', price = 100},
      		{model = 'policeb', label = 'BMW 1200R', price = 100},
     		{model = 'policevw', label = 'Volkswagen Transport', price = 100},
		}
	},

	helicopter = {
		recruit = {},

		officer = {},

		sergeant = {},

		lieutenant = {
			{model = 'polmav', props = {modLivery = 0}, price = 1000}
		},

		boss = {
			{model = 'polmav', props = {modLivery = 0}, price = 100000}
		}
	}
}

Config.CustomPeds = {
	shared = {
		{label = 'Sheriff Ped', maleModel = 's_m_y_sheriff_01', femaleModel = 's_f_y_sheriff_01'},
		{label = 'Police Ped', maleModel = 's_m_y_cop_01', femaleModel = 's_f_y_cop_01'}
	},

	recruit = {},

	officer = {},

	sergeant = {},

	lieutenant = {},

	boss = {
		{label = 'SWAT Ped', maleModel = 's_m_y_swat_01', femaleModel = 's_m_y_swat_01'}
	}
}

-- CHECK SKINCHANGER CLIENT MAIN.LUA for matching elements
Config.Uniforms = {
	recruit = {
		male = {
			tshirt_1 = 59,  tshirt_2 = 1,
			torso_1 = 55,   torso_2 = 0,
			decals_1 = 0,   decals_2 = 0,
			arms = 41,
			pants_1 = 25,   pants_2 = 0,
			shoes_1 = 25,   shoes_2 = 0,
			helmet_1 = 46,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		},
		female = {
			tshirt_1 = 36,  tshirt_2 = 1,
			torso_1 = 48,   torso_2 = 0,
			decals_1 = 0,   decals_2 = 0,
			arms = 44,
			pants_1 = 34,   pants_2 = 0,
			shoes_1 = 27,   shoes_2 = 0,
			helmet_1 = 45,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		}
	},

	officer = {
		male = {
			tshirt_1 = 58,  tshirt_2 = 0,
			torso_1 = 55,   torso_2 = 0,
			decals_1 = 0,   decals_2 = 0,
			arms = 41,
			pants_1 = 25,   pants_2 = 0,
			shoes_1 = 25,   shoes_2 = 0,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		},
		female = {
			tshirt_1 = 35,  tshirt_2 = 0,
			torso_1 = 48,   torso_2 = 0,
			decals_1 = 0,   decals_2 = 0,
			arms = 44,
			pants_1 = 34,   pants_2 = 0,
			shoes_1 = 27,   shoes_2 = 0,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		}
	},

	sergeant = {
		male = {
			tshirt_1 = 58,  tshirt_2 = 0,
			torso_1 = 55,   torso_2 = 0,
			decals_1 = 8,   decals_2 = 1,
			arms = 41,
			pants_1 = 25,   pants_2 = 0,
			shoes_1 = 25,   shoes_2 = 0,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		},
		female = {
			tshirt_1 = 35,  tshirt_2 = 0,
			torso_1 = 48,   torso_2 = 0,
			decals_1 = 7,   decals_2 = 1,
			arms = 44,
			pants_1 = 34,   pants_2 = 0,
			shoes_1 = 27,   shoes_2 = 0,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		}
	},

	lieutenant = {
		male = {
			tshirt_1 = 58,  tshirt_2 = 0,
			torso_1 = 55,   torso_2 = 0,
			decals_1 = 8,   decals_2 = 2,
			arms = 41,
			pants_1 = 25,   pants_2 = 0,
			shoes_1 = 25,   shoes_2 = 0,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		},
		female = {
			tshirt_1 = 35,  tshirt_2 = 0,
			torso_1 = 48,   torso_2 = 0,
			decals_1 = 7,   decals_2 = 2,
			arms = 44,
			pants_1 = 34,   pants_2 = 0,
			shoes_1 = 27,   shoes_2 = 0,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		}
	},

	boss = {
		male = {
			tshirt_1 = 58,  tshirt_2 = 0,
			torso_1 = 55,   torso_2 = 0,
			decals_1 = 8,   decals_2 = 3,
			arms = 41,
			pants_1 = 25,   pants_2 = 0,
			shoes_1 = 25,   shoes_2 = 0,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		},
		female = {
			tshirt_1 = 35,  tshirt_2 = 0,
			torso_1 = 48,   torso_2 = 0,
			decals_1 = 7,   decals_2 = 3,
			arms = 44,
			pants_1 = 34,   pants_2 = 0,
			shoes_1 = 27,   shoes_2 = 0,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		}
	},

	bullet_wear = {
		male = {
			bproof_1 = 11,  bproof_2 = 1
		},
		female = {
			bproof_1 = 13,  bproof_2 = 1
		}
	},

	gilet_wear = {
		male = {
			tshirt_1 = 59,  tshirt_2 = 1
		},
		female = {
			tshirt_1 = 36,  tshirt_2 = 1
		}
	}
}
