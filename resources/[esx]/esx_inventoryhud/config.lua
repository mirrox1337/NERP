Config = {}
Config.Locale = 'sv'
Config.IncludeCash = true -- Include cash in inventory?
Config.IncludeWeapons = true -- Include weapons in inventory?
Config.IncludeAccounts = true -- Include accounts (bank, black money, ...)?
Config.ExcludeAccountsList = {"bank"} -- List of accounts names to exclude from inventory
Config.OpenControl = 289 -- Key for opening inventory. Edit html/js/config.js to change key for closing it.

-- List of item names that will close ui when used
Config.CloseUiItems = {"headbag", "fishingrod", "radio", "coke", "meth", "weed", "tuning_laptop"}

Config.ShopBlipID = 52
Config.AladdinFiskebutikBlipID = 68
Config.MohammedsLivsBlipID = 140
Config.LiquorBlipID = 93
Config.YouToolBlipID = 106
Config.PrisonShopBlipID = 52
Config.WeedStoreBlipID = 140
Config.WeaponShopBlipID = 110

Config.ShopLength = 14
Config.LiquorLength = 10
Config.YouToolLength = 2
Config.PrisonShopLength = 2
Config.InetShopLength = 2

Config.Color = 2
Config.AladdinFiskebutikBlipIDColor = 1
Config.MohammedsLivsBlipIDColor = 2
Config.WeaponColor = 1

Config.WeaponLiscence = {x = 12.47, y = -1105.5, z = 29.8}
Config.LicensePrice = 5000

Config.Shops = {
    AladdinFiskebutik = {
        Locations = {
			{x = 814.59, y = -93.13,  z = 79.7, icon = 68, color = 1, name = 'Aladdins Fiskebutik'}
        },
        Items = {
			{name = 'fishingrod'},
			{name = 'fishbait'}
        }
    },

    Dealer = {
		Locations = {
			{x = -1207.59, y = -240.18,  z = 36.95, icon = 52, color = 4, name = 'Dealer'},
        },
        Items = {
			{name = 'silencieux'},
			{name = 'flashlight'},
			{name = 'seed'},
			{name = 'rizla'},
			{name = 'kaustiksoda'},
			{name = 'cement'},
			{name = 'bensin'},
			{name = 'clip'},
			{name = 'Våg'},
			{name = 'grinder'},
			{name = 'plasticbag'},
			{name = 'lockpick'},
			{name = 'radio'},
			{name = 'buntband'},
			{name = 'chemicals'},
			{name = 'jumelles'},
			{name = 'turtlebait'},
			{name = 'methlab'},
			{name = 'acetone'},
			{name = 'lithium'},
			{name = 'bulletproof_vest'},
			{name = 'plasticbag'}
        }
    },
    
    UrbicusBar = {
		Locations = {
			{x = -562.07, y = 288.27, z = 82.18, icon = 52, color = 4, name = 'Urbicus Bar'},
        },
        Items = {
			{name = 'ol'},
			{name = 'whisky'}
        }
	},

    MohammedsLivs = {
        Locations = {
            {x = -1172.07, y =  -1571.93, z = 3.70, icon = 106, color = 38, name = 'Mohammeds Livs'},
        },
        Items = {
			{name = 'cigaretter'},
			{name = 'lighter'},
			{name = 'rizla'},
			{name = 'snusdosa'},
		}
	},
	
	Sjukhus = {
        Locations = {
            {x = 316.88, y =  -588.64, z = 42.30, icon = 106, color = 38, name = 'Sjukhus Kiosk'},
        },
        Items = {
			{name = 'bread'},
			{name = 'water'}
		}
	},

	Telefonbutiken = {
        Locations = {
            {x = 1124.22, y =  -345.72, z = 66.2, icon = 459, color = 52, name = 'Telefon Butiken'},
        },
        Items = {
			{name = 'phone'},
		}
	},
	
	Gym = {
        Locations = {
            {x = -1195.62, y =  -1577.71, z = 3.61, icon = 106, color = 38, name = 'Gymbutik'},
        },
        Items = {
			{name = 'gym_membership'},
			{name = 'water'}
		}
    },

    Vending = {
        Locations = {
            { x = 220.22,  y = -866.9,  z = 30.50 },
			{ x = 312.544, y = -587.664, z = 43.29 },
			{ x = 449.857, y = -987.882, z = 26.69 },
			{ x = -208.049, y = -1342.076, z = 34.9, },

			--Ecola
			{ x = 821.91,	y = -2988.64,  z = 6.02 },
			{ x = 820.81,	y = -2988.68,  z = 6.02 },
			{ x = 809.82,	y = -2150.0,   z = 29.62 },
			{ x = 2560.57,	y = 380.13,    z = 108.62 },
			{ x = 2558.81,	y = 2601.82,   z = 38.09 },
			{ x = 2344.35,	y = 3127.13,   z = 48.21 },
			{ x = 1702.89,	y = 4923.42,   z = 42.06 },
			{ x = 1485.8,	y = 1134.97,   z = 114.33 },
			{ x = 1160.96,	y = -319.77,   z = 69.21 },
			{ x = 286.14,	y = 195.21,    z = 104.37 },
			{ x = 309.33,	y = 186.95,    z = 103.9 },
			{ x = 285.59,	y = 80.36,     z = 94.36 },
			{ x = 281.68,	y = 66.38,     z = 94.37 },
			{ x = 436.23,	y = -986.68,   z = 30.69 },
			{ x = -59.84,	y = -1749.34,  z = 29.32 },
			{ x = -46.78,	y = -1753.18,  z = 29.42 },
			{ x = 19.83,	y = -1114.28,  z = 29.8 },
			{ x = -325.56,	y = -738.59,   z = 33.96 },
			{ x = -310.1,	y = -739.47,   z = 33.96 },
			{ x = -334.82,	y = -785.04,   z = 38.78 },
			{ x = -325.51,	y = -738.58,   z = 43.6 },
			{ x = -334.9,	y = -784.87,   z = 48.42 },
			{ x = -694.37,	y = -793.32,   z = 33.68 },
			{ x = -709.31,	y = -910.05,   z = 19.22 },
			{ x = -1654.96,	y = -1096.42,  z = 13.12 },
			{ x = -1695.27,	y = -1126.33,  z = 13.15 },
			{ x = -1710.02,	y = -1133.83,  z = 13.14 },
			{ x = -1692.37,	y = -1087.75,  z = 13.15 },
			{ x = -1063.66,	y = -244.41,   z = 39.73 },
			{ x = -1824.94,	y = 794.77,    z = 138.16 },
			{ x = -2550.63,	y = 2316.61,   z = 33.22 },
			{ x = -1269.34,	y = -1427.98,  z = 4.35 },
			{ x = -1251.39,	y = -1450.37,  z = 4.35 },
			{ x = -1230.58,	y = -1447.75,  z = 4.27 },
			{ x = -1170.79,	y = -1574.44,  z = 4.66 },
			{ x = -1148.0,	y = -1601.07,  z = 4.39 },
			{ x = -1140.06,	y = -1623.16,  z = 4.41 },
			{ x = -1123.07,	y = -1643.82,  z = 4.66 },
			{ x = -246.52,	y = -2002.96,  z = 30.15 },
			{ x = -275.87,	y = -2041.86,  z = 30.15 },

			--Sprunk
			{ x = 821.91,	y = -2988.64,  z = 6.02 },
			{ x = 820.81,	y = -2988.68,  z = 6.02 },
			{ x = 809.82,	y = -2150.0,   z = 29.62 },
			{ x = 2560.57,	y = 380.13,    z = 108.62 },
			{ x = 2558.81,	y = 2601.82,   z = 38.09 },
			{ x = 2344.35,	y = 3127.13,   z = 48.21 },
			{ x = 1702.89,	y = 4923.42,   z = 42.06 },
			{ x = 1485.8,	y = 1134.97,   z = 114.33 },
			{ x = 1160.96,	y = -319.77,   z = 69.21 },
			{ x = 286.14,	y = 195.21,    z = 104.37 },
			{ x = 309.33,	y = 186.95,    z = 103.9 },
			{ x = 285.59,	y = 80.36,     z = 94.36 },
			{ x = 281.68,	y = 66.38,     z = 94.37 },
			{ x = -59.84,	y = -1749.34,  z = 29.32 },
			{ x = -46.78,	y = -1753.18,  z = 29.42 },
			{ x = 19.83,	y = -1114.28,  z = 29.8 },
			{ x = -325.56,	y = -738.59,   z = 33.96 },
			{ x = -310.1,	y = -739.47,   z = 33.96 },
			{ x = -334.82,	y = -785.04,   z = 38.78 },
			{ x = -325.51,	y = -738.58,   z = 43.6 },
			{ x = -334.9,	y = -784.87,   z = 48.42 },
			{ x = -694.37,	y = -793.32,   z = 33.68 },
			{ x = -709.31,	y = -910.05,   z = 19.22 },
			{ x = -1654.96,	y = -1096.42,  z = 13.12 },
			{ x = -1695.27,	y = -1126.33,  z = 13.15 },
			{ x = -1710.02,	y = -1133.83,  z = 13.14 },
			{ x = -1692.37,	y = -1087.75,  z = 13.15 },
			{ x = -1063.66,	y = -244.41,   z = 39.73 },
			{ x = -1824.94,	y = 794.77,    z = 138.16 },
			{ x = -2550.63,	y = 2316.61,   z = 33.22 },
			{ x = -1269.34,	y = -1427.98,  z = 4.35 },
			{ x = -1251.39,	y = -1450.37,  z = 4.35 },
			{ x = -1230.58,	y = -1447.75,  z = 4.27 },
			{ x = -1170.79,	y = -1574.44,  z = 4.66 },
			{ x = -1148.0,	y = -1601.07,  z = 4.39 },
			{ x = -1140.06,	y = -1623.16,  z = 4.41 },
			{ x = -1123.07,	y = -1643.82,  z = 4.66 },
			{ x = -246.52,	y = -2002.96,  z = 30.15 },
			{ x = -275.87,	y = -2041.86,  z = 30.15 }
        },
        Items = {
            {name = 'drpepper'},
            {name = 'water'},
            {name = 'chocolate'},
            {name = 'cupcake'},
            {name = 'iceteam'},
            {name = 'energy'}
        }
    },

    PrisonShop = {
        Locations = {
            {x = 1655.31, y = 2489.96, z = 45.86},
        },
        Items = {
            {name = 'bread'},
            {name = 'water'}
        }
    },

    InetShop = {
        Locations = {
            {x = -308.61,  y = 196.73,  z = 32.73}	
        },
        Items = {
            {name = 'phone'},
            {name = 'gps'}
        }
    },

    SexShop = {
        Locations = {
            {x = -175.1,  y = 230.13,  z = 88.10}	
        },
        Items = {
            {name = 'dildo'},
            {name = 'dildo2'}
        }
    },

}

--vikt--
Config.Limit = 30000
Config.DefaultWeight = 100
Config.userSpeed = false
Config.WeightSqlBased = false

Config.localWeight = {
 --###-->> vikt <<--###-- 
acetone = 350,
ambulansnyckel = 20,
bandage = 5,
bensin = 750,
black_chip = 5,
blindfold = 15,
blowpipe = 1000,
bong = 500,
bulletproof_vest = 1840,
buntband = 10,
burger = 170,
busshammare = 1000,
carokit = 1000,
carotool = 1000,
cement = 100,
champagne = 95,
chemicals = 950,
cigarett = 1,
clip = 200,
cocaine = 100,
cocaineleaf = 5,
gcocaineleaf = 5,
coke = 100,
cocaine = 100,
coke_pooch = 1000,
packedcocaine = 100,
weed_pooch = 25,
marijuana = 20,
water = 50,
bread = 50,
methlab = 4500,
phone = 120,
meth = 100,
triadcoin = 20,
polisnyckel = 20,
turtlebait = 50,
turtle = 1000,
fishingrod = 300,
fish = 350,
fishbait = 15,
lithium = 20,
morphine = 5,
hydrocodone = 50,
vicodin = 50,
medkit = 100,
medikit = 100,
firstaid = 100,
gauze = 100,
black_money = 10,
polisnyckel = 20,
huvudnyckel = 20,
gambinonyckel = 20,
urbicuscard = 20,
yusuf = 20,
grip = 70,
flashlight = 150,
silencieux = 200,
anonymouscard = 20,
lom = 130,
radio = 200,
zedscard = 20,
journalistcard = 20,
cardealercard = 20,
bankcard = 20,
securitascard = 20,
leather = 30,
raw_meat = 60,
virusphone = 120,
crackedphone = 120,
creditcard = 10,
rolexklocka = 50,
laptop = 2000,
rosadildo = 250,
trasa = 15,
hamburgare = 160,
bag = 200,
vipkort = 20,
super = 20,
ol = 33,
redbullvodka = 45,
rottvin = 80,
vittvin = 80,
lockpick = 150,
phoneoff = 120,
surfplatta = 200,
halsbandd = 70,
smycke = 50,
klockaa = 50,
grinder = 100,
cement = 100,
kaustiksoda = 500,
jewels = 50,
plasticbag = 10,
donvito_item = 250,
seed = 18,
jumelles = 160,
lighter = 10,
dmv = 10,
drive = 25,
drive_bike = 25,
drive_truck = 25,
tequila = 80,
whisky = 80,
rhum = 80,
vodka = 80,
jager = 80
}