Config                            = {}

Config.Teleporters = {

	['Sjukhus taket'] = {
		['Job'] = 'none',
		['Enter'] = { 
			['x'] = 330.43,
			['y'] = -600.86, 
			['z'] = 42.28,
			['Information'] = '[~g~E~w~] Ta hissen upp till taket', 
		},
		['Exit'] = {
			['x'] = 339.07,
			['y'] =-584.02,
			['z'] = 73.16, 
			['Information'] = '[~g~E~w~] Ta hissen ner till hisshallen' 
		}
	},

	['Garage-Sjukhus'] = {
		['Job'] = 'ambulance', 
		['Enter'] = { 
			['x'] = 332.37,
			['y'] = -595.53, 
			['z'] = 42.27,
			['Information'] = '[~g~E~w~] Ta hissen ner till Garaget', 
		},
		['Exit'] = {
			['x'] = 319.62,
			['y'] = -560.14,
			['z'] = 27.73,
			['Information'] = '[~g~E~w~] Ta hissen upp till hisshallen', 
		}
	},

	['GaragePolis'] = {
		['Job'] = 'police',  
		['Enter'] = { 
			['x'] = 440.21,
			['y'] = -999.47, 
			['z'] = 29.82,
			['Information'] = '[~g~E~w~] Gå in', 
		},
		['Exit'] = {
			['x'] = 445.98,
			['y'] = -996.54,
			['z'] = 29.69, 
			['Information'] = '[~g~E~w~] Gå ut' 
		}
	}, --- 1395.45 1141.83 114.64

	['Frånstationtillgarage'] = {
		['Job'] = 'police',  
		['Enter'] = { 
			['x'] = 452.02,
			['y'] = -988.31, 
			['z'] = 25.72,
			['Information'] = '[~g~E~w~] Gå till Garaget', 
		},
		['Exit'] = {
			['x'] = 463.70,
			['y'] = -1013.17,
			['z'] = 27.09, 
			['Information'] = '[~g~E~w~] Gå till cell' 
		}
	}, 

	['FrånGarageTillTak'] = {
		['Job'] = 'police',  
		['Enter'] = { 
			['x'] = 458.93,
			['y'] = -1008.05, 
			['z'] = 27.37,
			['Information'] = '[~g~E~w~] Gå till tak', 
		},
		['Exit'] = {
			['x'] = 476.22,
			['y'] = -1008.21,
			['z'] = 40.02, 
			['Information'] = '[~g~E~w~] Gå till garaget'
		}
	},

	['förhörsrum'] = {
		['Job'] = 'none',  
		['Enter'] = { 
			['x'] = 464.97,
			['y'] = -989.98, 
			['z'] = 23.92,
			['Information'] = '[~g~E~w~] för att Gå till Förhörsrummen.', 
		},
		['Exit'] = {
			['x'] = 2060.47,
			['y'] = 2978.39,
			['z'] = -68.3, 
			['Information'] = '[~g~E~w~] för att Gå till Stationen'
		}
	},

	--[[['Kokain'] = {
		['Job'] = 'none',
		['Enter'] = { 
			['x'] = 35.45,
			['y'] = 153.99, 
			['z'] = 116.52,
			['Information'] = '[~g~E~w~] Gå in',
		},
		['Exit'] = {
			['x'] = 1088.45,
			['y'] = -3187.78, 
			['z'] = -39.99, 
			['Information'] = '[~g~E~w~] Gå ut' 
		}
	},

	['meth'] = {
		['Job'] = 'none',
		['Enter'] = { 
			['x'] = 1192.3,
			['y'] = -1248.84, 
			['z'] = 39.35,
			['Information'] = '[~g~E~w~] Gå in',
		},
		['Exit'] = {
			['x'] = 996.96,
			['y'] = -3200.69, 
			['z'] = -37.39, 
			['Information'] = '[~g~E~w~] Gå ut' 
		}
	},]]

	['klubben'] = {
		['Job'] = 'none',
		['Enter'] = { 
			['x'] = -1386.19,
			['y'] = -627.46, 
			['z'] = 29.72,
			['Information'] = '[~g~E~w~] Gå in',
		},
		['Exit'] = {
			['x'] = -1569.46,
			['y'] = -3017.63, 
			['z'] = -75.31, 
			['Information'] = '[~g~E~w~] Gå ut' 
		}
	},

	['crafting'] = {
		['Job'] = 'none',
		['Enter'] = { 
			['x'] = -595.18,
			['y'] = -1653.04, 
			['z'] = 19.70,
			['Information'] = '[~g~E~w~] Gå in',
		},
		['Exit'] = {
			['x'] = 1004.65,
			['y'] = -2992.1, 
			['z'] = -40.60, 
			['Information'] = '[~g~E~w~] Gå ut' 
		}
	},

	--[[['weed'] = {
		['Job'] = 'none',
		['Enter'] = { 
			['x'] = -1224.39,
			['y'] = -711.27, 
			['z'] = 21.34,
			['Information'] = '[~g~E~w~] Gå in',
		},
		['Exit'] = {
			['x'] = 1065.65,
			['y'] = -3183.5, 
			['z'] = -40.16, 
			['Information'] = '[~g~E~w~] Gå ut' 
		}
	},
	
		['lifeinvaderMeeting'] = {
		['Job'] = 'none',
		['Enter'] = { 
			['x'] = -1048.6,
			['y'] = -238.45, 
			['z'] = 43.050,
			['Information'] = '[~g~E~w~] Gå in i mötesrummet',
		},
		['Exit'] = {
			['x'] = -1047.03,
			['y'] = -237.61, 
			['z'] = 43.050, 
			['Information'] = '[~g~E~w~] Gå in i kontoret' 
		}
	},]]
	
			['lifeinvaderHelipad'] = {
		['Job'] = 'none',
		['Enter'] = { 
			['x'] = -1075.63,
			['y'] = -252.97, 
			['z'] = 43.050,
			['Information'] = '[~g~E~w~] Ta hissen upp till taket',
		},
		['Exit'] = {
			['x'] = -1072.32,
			['y'] = -246.46, 
			['z'] = 53.050, 
			['Information'] = '[~g~E~w~] Ta hissen ner till kontoret' 
		}
	},
	
		['lifeinvaderElevator'] = {
		['Job'] = 'none',
		['Enter'] = { 
			['x'] = -1078.2,
			['y'] = -254.32, 
			['z'] = 36.86,
			['Information'] = '[~g~E~w~] Ta hissen upp till kontoret',
		},
		['Exit'] = {
			['x'] = -1078.35,
			['y'] = -254.13, 
			['z'] = 43.050,
			['Information'] = '[~g~E~w~] Ta hissen ner till lobbyn' 
		}
	},
	
		['lifeinvaderFantasirummet'] = {
		['Job'] = 'none',
		['Enter'] = { 
			['x'] = -1062.76,
			['y'] = -240.87, 
			['z'] = 43.050,
			['Information'] = '[~g~E~w~] Gå in i fantasirummet',
		},
		['Exit'] = {
			['x'] = -1063.59,
			['y'] = -239.6, 
			['z'] = 43.050,
			['Information'] = '[~g~E~w~] Gå in i kontoret' 
		}
	},
	
			['ZedsGarage'] = {
		['Job'] = 'zeds',
		['Enter'] = { 
			['x'] = 973.83,
			['y'] = -101.50, 
			['z'] = 73.85,
			['Information'] = '[~g~E~w~] Gå in i garaget',
		},
		['Exit'] = {
			['x'] = 965.93,
			['y'] = -104.5, 
			['z'] = 73.55,
			['Information'] = '[~g~E~w~] Gå in i klubbhuset' 
		}
	},
		
	['MotelPanic'] = {
		['Job'] = 'none',
		['Enter'] = { 
			['x'] = 154.26,
			['y'] = -1002.91, 
			['z'] = -99.90,
			['Information'] = '~r~Hjälp! ~w~[~g~E~w~] ~r~Om du har fastnat i motellet!',
		},
		['Exit'] = {
			['x'] = 311.16,
			['y'] = -205.82, 
			['z'] = 52.90, 
			['Information'] = '',
		}
	},

	['Terassen'] = {
		['Job'] = 'none',
		['Enter'] = { 
			['x'] = 109.42,
			['y'] = -1090.33, 
			['z'] = 28.3,
			['Information'] = '[~g~E~w~] Gå upp till Terrassen',
		},
		['Exit'] = {
			['x'] = 91.24,
			['y'] = -1099.06, 
			['z'] = 62.39,
			['Information'] = '[~g~E~w~] Gå ner' 
		}
	},

}
