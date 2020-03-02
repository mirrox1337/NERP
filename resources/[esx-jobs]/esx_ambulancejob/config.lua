Config                            = {}
Config.DrawDistance               = 20.0
Config.MarkerColor                = { r = 0, g = 255, b = 0 }

local second = 1000
local minute = 60 * second

-- Hur mycket tid innan auto respawn på sjukhus
Config.RespawnDelayAfterRPDeath   = 1800 * second

--- Combatlog # KOCKEN
Config.ReviveReward               = 700  -- revive reward, set to 0 if you don't want it enabled
Config.AntiCombatLog              = true -- enable anti-combat logging?
Config.LoadIpl                    = true -- disable if you're using fivem-ipl or other IPL loaders

-- Hur lång tid det är kvar tills den frågar en spelare när man vill spawna på sjukhuset
Config.RespawnToHospitalMenuTimer = true
Config.MenuRespawnToHospitalDelay = 500 * second

Config.EnablePlayerManagement     = true
Config.EnableSocietyOwnedVehicles = false
Config.RemoveWeaponsAfterRPDeath  = true
Config.RemoveCashAfterRPDeath     = true
Config.RemoveItemsAfterRPDeath    = true

-- Visar hur lång tid det är kvar tills man dör
Config.ShowDeathTimer             = true

Config.EarlyRespawn               = false
-- The player can have a fine (on bank account)
Config.RespawnFine           = false
Config.RespawnFineAmount     = 50000

Config.Locale                     = 'en'

Config.VirusWear = {
  male = {
      ['tshirt_1'] = 62,  ['tshirt_2'] = 3,
      ['torso_1'] = 67,   ['torso_2'] = 3,
      ['decals_1'] = 0,   ['decals_2'] = 0,
      ['arms'] = 86,
      ['pants_1'] = 40,   ['pants_2'] = 3,
      ['shoes_1'] = 62,   ['shoes_2'] = 4,
      ['helmet_1'] = -1,  ['helmet_2'] = 0,
      ['chain_1'] = 0,    ['chain_2'] = 0,
      ['glasses_1'] = 0,  ['glasses_2'] = 0,
      ['bproof_1'] = 0,   ['bproof_2'] = 0,
      ['bags_1'] = 36,    ['bags_2'] = 0,
      ['mask_1'] = 46,    ['mask_2'] = 0,
      ['ears_1'] = 0,     ['ears_2'] = 0
  },
  female = {
      ['tshirt_1'] = 43,  ['tshirt_2'] = 3,
      ['torso_1'] = 61,   ['torso_2'] = 3,
      ['decals_1'] = 0,   ['decals_2'] = 0,
      ['arms'] = 101,
      ['pants_1'] = 40,   ['pants_2'] = 3,
      ['shoes_1'] = 65,   ['shoes_2'] = 4,
      ['helmet_1'] = -1,  ['helmet_2'] = 0,
      ['chain_1'] = 0,    ['chain_2'] = 0,
      ['glasses_1'] = 5,  ['glasses_2'] = 0,
      ['bproof_1'] = 0,   ['bproof_2'] = 0,
      ['bags_1'] = 36,    ['bags_2'] = 0,
      ['mask_1'] = 46,    ['mask_2'] = 0,
      ['ears_1'] = 0,     ['ears_2'] = 0
  }
}

Config.Blip = {
  Pos     = { x = 299.29, y = -584.74, z = 48.26 },
  Sprite  = 61,
  Display = 4,
  Scale   = 0.8,
}

Config.HelicopterSpawner = {
    SpawnPoint  = { x = 351.9, y = -587.8, z = 74.17 },
    Heading     = 170.58
}

Config.Zones = {
--[[
  HospitalInteriorEntering1 = { -- ok
    Pos  = { x = 299.65, y = -579.1, z = 44.26 },
    Size = { x = 1.5, y = 1.5, z = 1.0 },
    Type = -1
  },

  HospitalInteriorInside1 = { -- ok
    Pos  = { x = 299.65, y = -579.1, z = 44.26 },
    Size = { x = 1.5, y = 1.5, z = 1.0 },
    Type = -1
  },

  HospitalInteriorOutside1 = { -- ok
    Pos  = { x = 299.65, y = -579.1, z = 44.26 },
    Size = { x = 1.5, y = 1.5, z = 1.0 },
    Type = -1
  },

  HospitalInteriorExit1 = { -- ok
    Pos  = { x = 299.65, y = -579.1, z = 44.26 },
    Size = { x = 1.5, y = 1.5, z = 1.0 },
    Type = -1
  },

  HospitalInteriorEntering2 = { -- Heli tp / spawn trigger - interior
    Pos  = { x = 299.65, y = -579.1, z = 44.26 },
    Size = { x = 1.5, y = 1.5, z = 1.0 },
    Type = -1
  },

  HospitalInteriorInside2 = { -- Heli tp / spawn trigger - på taket
    Pos  = { x = 299.65, y = -579.1, z = 44.26 },
    Size = { x = 1.5, y = 1.5, z = 1.0 },
    Type = -1
  },

  HospitalInteriorOutside2 = { -- Ascenseur retour depuis toit
    Pos  = { x = 299.65, y = -579.1, z = 44.26 },
    Size = { x = 1.5, y = 1.5, z = 1.0 },
    Type = -1
  },

  HospitalInteriorExit2 = { -- Toit entré
    Pos  = { x = 299.65, y = -579.1, z = 44.26 },
    Size = { x = 1.5, y = 1.5, z = 1.0 },
    Type = -1
  },
]]
  AmbulanceActions = { -- CLOACKROOM 
  	Pos  = {x = 299.01, y = -598.27,z = 42.31 },
    Size = { x = 1.5, y = 1.5, z = 0.4 },
    Type = 27
  },

  VehicleSpawner = {
    Pos  = { x = 323.78, y = -556.53, z = 27.75 },
    Size = { x = 1.5, y = 1.5, z = 1.0 },
    Type = 27
  },

  VehicleSpawnPoint = {
    Pos  = { x = 329.34, y = -556.11, z = 27.75 },
    Size = { x = 1.5, y = 1.5, z = 1.0 },
    Type = -1
	
  },

  VehicleDeleter = {
    Pos  = { x = 341.29, y = -560.73, z = 27.75 },
    Size = { x = 3.0, y = 3.0, z = 1.0 },
    Type = 27
  },

  VehicleSpawner2 = { -- HELI
    Pos  = { x = 340.29, y = -589.1, z = 73.20 },
    Size = { x = 1.5, y = 1.5, z = 1.0 },
    Type = 27
  },

  VehicleSpawnPoint2 = { -- HELI
    Pos  = { x = 351.29, y = -587.91, z = 73.20 },
    Size = { x = 1.5, y = 1.5, z = 1.0 },
    Type = -1
	
  },

  VehicleDeleter2 = { -- HELI
    Pos  = { x = 351.29, y = -587.91, z = 73.20 },
    Size = { x = 3.0, y = 3.0, z = 1.0 },
    Type = -1
  },
  
  Pharmacy = {
    Pos  = { x = 311.88, y = -597.51, z = 42.31 },
    Size = { x = 1.5, y = 1.5, z = 1.0 },
    Type = 27
  },

  ParkingDoorGoOutInside = {
    Pos  = { x = 322.59, y = -1401.23, z = 76.17 },
    Size = { x = 1.5, y = 1.5, z = 1.0 },
    Type = -1
  },

  ParkingDoorGoOutOutside = {
    Pos  = { x = 322.59, y = -1401.23, z = 76.17 },
    Size = { x = 1.5, y = 1.5, z = 1.0 },
    Type = -1
  },

  ParkingDoorGoInInside = {
    Pos  = { x = 322.59, y = -1401.23, z = 76.17 },
    Size = { x = 1.5, y = 1.5, z = 1.0 },
    Type = -1
  },

  ParkingDoorGoInOutside = {
    Pos  = { x = 322.59, y = -1401.23, z = 76.17 },
    Size = { x = 1.5, y = 1.5, z = 1.0 },
    Type = -1
  },
  
  StairsGoTopTop = {
    Pos  = { x = 322.59, y = -1401.23, z = 76.17 },
    Size = { x = 1.5, y = 1.5, z = 1.0 },
    Type = -1
  },
  
  StairsGoTopBottom = {
    Pos  = { x = 322.59, y = -1401.23, z = 76.17 },
    Size = { x = 1.5, y = 1.5, z = 1.0 },
    Type = -1
  },
  
  StairsGoBottomTop = {
    Pos  = { x = 322.59, y = -1401.23, z = 76.17 },
    Size = { x = 1.5, y = 1.5, z = 1.0 },
    Type = -1
  },

  StairsGoBottomBottom = {
    Pos  = { x = 322.59, y = -1401.23, z = 76.17 },
    Size = { x = 1.5, y = 1.5, z = 1.0 },
    Type = -1
  },

  SjukhusCard = {
    Pos   = { x = 310.47, y = -597.94, z = 42.39 },
    Size  = { x = 1.0, y = 1.0, z = 1.0 },
    Color = { r = 0, g = 0, b = 255 },
    Type  = 27
  },
}

