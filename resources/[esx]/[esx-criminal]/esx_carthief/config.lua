Config              = {}
Config.DrawDistance = 8.0
Config.CopsRequired = 4
Config.BlipUpdateTime = 10000 --In milliseconds. I used it on 3000. If you want instant update, 50 is more than enough. Even 100 is good. I hope it doesn't kill FPS and the server.
Config.CooldownMinutes = 90
Config.CooldownTime = 7200 -- 2 hours
Config.TimeUntilBlipRemove = 26000 -- 4 minutes
Config.Locale = 'en'

Config.Zones = {
	VehicleSpawner = {
		Pos   = {x = -1661.46, y = -384.97, z = 43.84},
		Size  = {x = 2.0, y = 2.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Type  = 1,
		Colour    = 6, --BLIP
		Id        = 229, --BLIP
	},
}

Config.VehicleSpawnPoint = {
      Pos   = {x = -1661.46, y = -384.97, z = 43.84},
      Size  = {x = 3.0, y = 3.0, z = 1.0},
      Type  = -1,
}

Config.Delivery = {
	--Desert
	--Trevor Airfield 9.22KM
	Delivery1 = {
		Pos      = {x = 2130.68, y = 4781.32, z = 39.87},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Type  = 1,
		Payment  = 25000,
		Cars = {'zentorno','t20','reaper','italigtb','pfister811'},
	},
	--Lighthouse 9.61KM
	Delivery4 = {
		Pos      = {x = 3333.51, y = 5159.91, z = 17.20},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Type  = 1,
		Payment  = 24800,
		Cars = {'zentorno','t20','reaper','italigtb','pfister811'},
	},
	--House in Paleto 12.94KM
	Delivery7 = {
		Pos      = {x = -437.56, y = 6254.53, z = 29.02},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Type  = 1,
		Payment  = 23800,
		Cars = {'zentorno','t20','reaper','italigtb','pfister811'},
	},
	--Great Ocean Highway 10.47KM
	Delivery10 = {
		Pos      = {x = -2177.51, y = 4269.51, z = 47.93},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Type  = 1,
		Payment  = 25000,
		Cars = {'zentorno','t20','reaper','italigtb','pfister811'},
	},
	--Marina Drive Desert 8.15KM
	Delivery13 = {
		Pos      = {x = 895.02, y = 3603.87, z = 31.72},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Type  = 1,
		Payment  = 26500,
		Cars = {'zentorno','t20','reaper','italigtb','pfister811'},
	},
}
