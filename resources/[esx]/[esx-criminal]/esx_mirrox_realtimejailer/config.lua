Config= {}
Config.Clothes = {
	police = {
		prison_wear = {
			male = {
				['tshirt_1'] = 15, ['tshirt_2'] = 0,
				['torso_1'] = 146, ['torso_2'] = 0,
				['decals_1'] = 0, ['decals_2'] = 0,
				['arms'] = 0,
				['pants_1'] = 3, ['pants_2'] = 7,
				['shoes_1'] = 12, ['shoes_2'] = 12,
				['chain_1'] = 50, ['chain_2'] = 0
			},
			female = {
				['tshirt_1'] = 3, ['tshirt_2'] = 0,
				['torso_1'] = 38, ['torso_2'] = 3,
				['decals_1'] = 0, ['decals_2'] = 0,
				['arms'] = 2,
				['pants_1'] = 3, ['pants_2'] = 15,
				['shoes_1'] = 66, ['shoes_2'] = 5,
				['chain_1'] = 0, ['chain_2'] = 2
			}
		}
	}
}

Config.Teleports = {
	["Gården"] = { 
		["x"] = 1636.35, 
		["y"] = 2565.12, 
		["z"] = 45.60, 
		["h"] = 176.71, 
		["goal"] = { 
			"Cellarna" 
		} 
	},

	["Gå ut"] = { 
		["x"] = 1845.6022949219, 
		["y"] = 2585.8029785156, 
		["z"] = 45.672061920166, 
		["h"] = 92.469093322754, 
		["goal"] = { 
			"Kontrollrum" 
		} 
	},

	["Cellarna"] = { 
		["x"] = 1800.6979980469, 
		["y"] = 2483.0979003906, 
		["z"] = -122.68814849854, 
		["h"] = 271.75274658203, 
		["goal"] = { 
			"Gården", 
			"Kontrollrum", 
			"Besökssrum" 
		} 
	},

	["Kontrollrum"] = { 
		["x"] = 1706.7625732422,
		["y"] = 2581.0793457031, 
		["z"] = -69.407371520996, 
		["h"] = 267.72802734375, 
		["goal"] = { 
			"Cellarna",
			"Gå ut"
		} 
	},

	["Besökssrum"] = {
		["x"] = 1699.7196044922, 
		["y"] = 2574.5314941406, 
		["z"] = -69.403930664063, 
		["h"] = 169.65020751953, 
		["goal"] = { 
			"Cellarna" 
		} 
	}
}
