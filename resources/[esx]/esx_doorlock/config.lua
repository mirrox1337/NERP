Config = {}
Config.Locale = 'sv'

Config.DoorList = {

	--
	-- Mission Row First Floor
	--

	-- Entrance Doors
	{
		textCoords = vector3(434.7, -982.0, 31.5),
		authorizedJobs = { 'police' },
		locked = false,
		distance = 2.5,
		doors = {
			{
				objName = 'v_ilev_ph_door01',
				objYaw = -90.0,
				objCoords = vector3(434.7, -980.6, 30.8)
			},

			{
				objName = 'v_ilev_ph_door002',
				objYaw = -90.0,
				objCoords = vector3(434.7, -983.2, 30.8)
			}
		}
	},

	-- To locker room & roof
	{
		objName = 'v_ilev_ph_gendoor004',
		objYaw = 90.0,
		objCoords  = vector3(449.6, -986.4, 30.6),
		textCoords = vector3(450.1, -986.3, 31.7),
		authorizedJobs = { 'police' },
		locked = true
	},

	-- Rooftop
	{
		objName = 'v_ilev_gtdoor02',
		objYaw = 90.0,
		objCoords  = vector3(464.3, -984.6, 43.8),
		textCoords = vector3(464.3, -984.0, 44.8),
		authorizedJobs = { 'police' },
		locked = true
	},

	-- Hallway to roof
	{
		objName = 'v_ilev_arm_secdoor',
		objYaw = 90.0,
		objCoords  = vector3(461.2, -985.3, 30.8),
		textCoords = vector3(461.5, -986.0, 31.5),
		authorizedJobs = { 'police' },
		locked = true
	},

	-- Armory
	{
		objName = 'v_ilev_arm_secdoor',
		objYaw = -90.0,
		objCoords  = vector3(452.6, -982.7, 30.6),
		textCoords = vector3(453.0, -982.6, 31.7),
		authorizedJobs = { 'police' },
		locked = true
	},

	-- Captain Office
	{
		objName = 'v_ilev_ph_gendoor002',
		objYaw = -180.0,
		objCoords  = vector3(447.2, -980.6, 30.6),
		textCoords = vector3(447.2, -980.0, 31.7),
		authorizedJobs = { 'police' },
		locked = true
	},

	-- To downstairs (double doors)
	{
		textCoords = vector3(444.6, -989.4, 31.7),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 4,
		doors = {
			{
				objName = 'v_ilev_ph_gendoor005',
				objYaw = 180.0,
				objCoords = vector3(443.9, -989.0, 30.6)
			},

			{
				objName = 'v_ilev_ph_gendoor005',
				objYaw = 0.0,
				objCoords = vector3(445.3, -988.7, 30.6)
			}
		}
	},

	--
	-- Mission Row Cells
	--

	-- Main Cells
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = 0.0,
		objCoords  = vector3(463.8, -992.6, 24.9),
		textCoords = vector3(463.3, -992.6, 25.1),
		authorizedJobs = { 'police' },
		locked = true
	},

	-- Cell 1
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = -90.0,
		objCoords  = vector3(462.3, -993.6, 24.9),
		textCoords = vector3(461.8, -993.3, 25.0),
		authorizedJobs = { 'police' },
		locked = true
	},

	-- Cell 2
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = 90.0,
		objCoords  = vector3(462.3, -998.1, 24.9),
		textCoords = vector3(461.8, -998.8, 25.0),
		authorizedJobs = { 'police' },
		locked = true
	},

	-- Cell 3
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = 90.0,
		objCoords  = vector3(462.7, -1001.9, 24.9),
		textCoords = vector3(461.8, -1002.4, 25.0),
		authorizedJobs = { 'police' },
		locked = true
	},

	-- To Back
	{
		objName = 'v_ilev_gtdoor',
		objYaw = 0.0,
		objCoords  = vector3(463.4, -1003.5, 25.0),
		textCoords = vector3(464.0, -1003.5, 25.5),
		authorizedJobs = { 'police' },
		locked = true
	},

	--
	-- Mission Row Back
	--

	-- Back (double doors)
	{
		textCoords = vector3(468.6, -1014.4, 27.1),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 4,
		doors = {
			{
				objName = 'v_ilev_rc_door2',
				objYaw = 0.0,
				objCoords  = vector3(467.3, -1014.4, 26.5)
			},

			{
				objName = 'v_ilev_rc_door2',
				objYaw = 180.0,
				objCoords  = vector3(469.9, -1014.4, 26.5)
			}
		}
	},

	-- Back Gate
	{
		objName = 'hei_prop_station_gate',
		objYaw = 90.0,
		objCoords  = vector3(488.8, -1017.2, 27.1),
		textCoords = vector3(488.8, -1020.2, 30.0),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 14,
		size = 2
	},

	--
	-- Sandy Shores
	--

	-- Entrance
	{
		objName = 'v_ilev_shrfdoor',
		objYaw = 30.0,
		objCoords  = vector3(1855.1, 3683.5, 34.2),
		textCoords = vector3(1855.1, 3683.5, 35.0),
		authorizedJobs = { 'police' },
		locked = false
	},

	--
	-- Paleto Bay
	--

	-- Entrance (double doors)
	{
		textCoords = vector3(-443.5, 6016.3, 32.0),
		authorizedJobs = { 'police' },
		locked = false,
		distance = 2.5,
		doors = {
			{
				objName = 'v_ilev_shrf2door',
				objYaw = -45.0,
				objCoords  = vector3(-443.1, 6015.6, 31.7),
			},

			{
				objName = 'v_ilev_shrf2door',
				objYaw = 135.0,
				objCoords  = vector3(-443.9, 6016.6, 31.7)
			}
		}
	},

	--
	-- Bolingbroke Penitentiary
	--

	-- Entrance (Two big gates)
	{
		objName = 'prop_gate_prison_01',
		objCoords  = vector3(1844.9, 2604.8, 44.6),
		textCoords = vector3(1844.9, 2608.5, 48.0),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 12,
		size = 2
	},

	{
		objName = 'prop_gate_prison_01',
		objCoords  = vector3(1818.5, 2604.8, 44.6),
		textCoords = vector3(1818.5, 2608.4, 48.0),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 12,
		size = 2
	},

	{
		textCoords = vector3(329.5, -585.81, 43.33),
		authorizedJobs = { 'ambulance', 'police', 'offambulance' },
		locked = true,
		distance = 4,
		doors = {
			{
				objName = 'v_ilev_cor_firedoor',
				objYaw = 340.0,
				objCoords  = vector3(330.01, -585.81, 43.33)
			},

			{
				objName = 'v_ilev_cor_firedoor',
				objYaw = 160.0,
				objCoords  = vector3(329.06, -585.81, 43.33)
			}
		}
	},
--Slutart kod

	{
		textCoords = vector3(251.95, -1366.2, 24.54),
		authorizedJobs = { 'ambulance', 'police', 'offambulance' },
		locked = true,
		distance = 4,
		doors = {
			{
				objName = 'v_ilev_cor_firedoor',
				objYaw = 320.0,
				objCoords  = vector3(253.03, -1366.27, 24.54),
			},

			{
				objName = 'v_ilev_cor_firedoor',
				objYaw = 140.0,
				objCoords  = vector3(251.45, -1364.97, 24.54),
			}
		}
	},

	--[[{
        objName = 'v_ilev_cor_doorglassb',
		objCoords  = {x = 253.20, y = -1361.58, z = 24.54},
		textCoords = {x = 253.54, y = -1361.21, z = 24.54},
		authorizedJobs = { 'ambulance' },
		locked = true,
		distance = 2
	},


	{
        objName = 'v_ilev_cor_doorglassa',
		objCoords  = {x = 254.55, y = -1359.91, z = 24.54},
		textCoords = {x = 254.18, y = -1360.31, z = 24.54},
		authorizedJobs = { 'ambulance' },
		locked = true,
		distance = 2
	},

	{
        objName = 'v_ilev_cor_doorglassb',
		objCoords  = {x = 266.32, y = -1345.89, z = 24.54},
		textCoords = {x = 266.56, y = -1345.61, z = 24.54},
		authorizedJobs = { 'ambulance' },
		locked = true,
		distance = 2.5
	},


	{
        objName = 'v_ilev_cor_doorglassa',
		objCoords  = {x = 267.67, y = -1344.28, z = 24.54},
		textCoords = {x = 267.35, y = -1344.72, z = 24.54},
		authorizedJobs = { 'ambulance' },
		locked = true,
		distance = 2.5
	},

	{
        objName = 'v_ilev_cor_doorglassb',
		objCoords  = {x = 282.39, y = -1343.04, z = 24.54},
		textCoords = {x = 282.73, y = -1342.65, z = 24.54},
		authorizedJobs = { 'ambulance' },
		locked = true,
		distance = 2.5
	},


	{
        objName = 'v_ilev_cor_doorglassa',
		objCoords  = {x = 283.81, y = -1341.36, z = 24.54},
		textCoords = {x = 283.48, y = -1341.74, z = 24.54},
		authorizedJobs = { 'ambulance' },
		locked = true,
		distance = 2.5
	},

	{
        objName = 'v_ilev_cor_doorglassb',
		objCoords  = {x = 286.73, y = -1343.92, z = 24.54},
		textCoords = {x = 286.44, y = -1344.27, z = 24.54},
		authorizedJobs = { 'ambulance' },
		locked = true,
		distance = 2.5
	},


	{
        objName = 'v_ilev_cor_doorglassa',
		objCoords  = {x = 285.36, y = -1345.56, z = 24.54},
		textCoords = {x = 285.64, y = -1345.15, z = 24.54},
		authorizedJobs = { 'ambulance' },
		locked = true,
		distance = 2.5
	},]]


	-- Sjukhus ytter dubbeldörrars
	--[[{
		textCoords = vector3(299.9063,-584.41,43.89),
		authorizedJobs = { 'ambulance', 'police' },
		locked = false,
		distance = 2.5,
		doors = {
			{
				objName = 'ex_prop_exec_office_door01',
				objCoords  = vector3(299.9063, -584.0541, 43.59),
				objYaw = 0


			},

			{
				objName = 'ex_prop_exec_office_door01',
				objCoords  = {x = 299.3366, y = -585.6013, z = 43.44227},
				objYaw = 0

			},

		}
	},]]

	-- Addons
	--

	
	-- Entrance Gate (Mission Row mod) https://www.gta5-mods.com/maps/mission-row-pd-ymap-fivem-v1
	{
		objName = 'prop_gate_airport_01',
		objCoords  = vector3(412.6, -1020.94, 30.0),
		textCoords = vector3(412.6, -1020.94, 32.0),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 14,
		size = 2
	}
}