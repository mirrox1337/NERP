Config                 = {}
Config.DrawDistance    = 10.0
Config.MaxErrors       = 6
Config.SpeedMultiplier = 3.6
Config.Locale          = 'en'

Config.Prices = {
  dmv         = 250,
  drive       = 500,
  drive_bike  = 350,
  drive_truck = 750
}

Config.VehicleModels = {
  drive       = 'dilettante',
  drive_bike  = 'sanchez',
  drive_truck = 'mule3'
}

Config.SpeedLimits = {
  residence = 50,
  town      = 80,
  freeway   = 120
}

Config.Zones = {

  DMVSchool = {
    Pos   = {x = 239.471, y = -1380.960, z = 32.741},
    Size  = {x = 1.5, y = 1.5, z = 0.5},
    Color = {r = 0, g = 255, b = 0},
    Type  = 1
  },

  VehicleSpawnPoint = {
    Pos   = {x = 244.1, y = -1415.47, z = 30.51},
    Size  = {x = 1.5, y = 1.5, z = 1.0},
    Color = {r = 204, g = 204, b = 0},
    Type  = -1
  },

}

Config.CheckPoints = {

-- INNE PÅ GÅRDEN
  {
    Pos = {x = 255.139, y = -1400.731, z = 29.537},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('next_point_speed') .. Config.SpeedLimits['residence'] .. 'km/h', 5000)
    end
  },

  {
    Pos = {x = 271.874, y = -1370.574, z = 30.932},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('go_next_point'), 5000)
    end
  },

  {
    Pos = {x = 234.907, y = -1345.385, z = 29.542},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      Citizen.CreateThread(function()
        DrawMissionText(_U('stop_for_ped'), 5000)
        PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
        FreezeEntityPosition(vehicle, true)
        Citizen.Wait(4000)
        FreezeEntityPosition(vehicle, false)
        DrawMissionText(_U('good_lets_cont'), 5000)

      end)
    end
  },



-- PÅ STAN
  {
    Pos = {x = 217.821, y = -1410.520, z = 28.292}, -- Sväng ut på gatan från körskolan
    Action = function(playerPed, vehicle, setCurrentZoneType)

      setCurrentZoneType('town')

      Citizen.CreateThread(function()
        DrawMissionText(_U('stop_look_left') .. Config.SpeedLimits['town'] .. 'km/h', 5000)
        PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
        FreezeEntityPosition(vehicle, true)
        Citizen.Wait(6000)
        FreezeEntityPosition(vehicle, false)
        DrawMissionText(_U('good_turn_right'), 5000)
      end)
    end
  },

  {
	Pos = {x = 183.87, y = -1395.87, z = 28.18}, -- Sväng höger och fortsätt mot bensinstationen
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('right_turn_gasstation'), 5000)
    end
  },

  {
	Pos = {x = 217.64, y = -1331.2, z = 28.16}, -- Sväng höger och förbered en vänstersväng
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('right_and_left_turn'), 5000)
    end
  },
  
  {
	Pos = {x = 261.01, y = -1305.58, z = 28.29}, -- Vänta på Passerande trafik och fortsätt sedan in på bensinstationen
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('wait_traffic_gasstation'), 5000)
    end
  },
  
  {
	Pos = {x = 262.3, y = -1251.94, z = 28.06}, -- BENSINSTATION, Se till att använda rätt bränsle till fordonet, Så kör vi vidare när du är klar.
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('gas_station'), 5000)
      PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
      FreezeEntityPosition(vehicle, true)
      Citizen.Wait(6000)
      FreezeEntityPosition(vehicle, false)
    end
  },

  {
	Pos = {x = 241.83, y = -1241.73, z = 28.18}, -- Sväng höger och fortsätt in mot stan. Glöm inte blinkersen.
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('right_turn_town'), 5000)
    end
  },

  {
	Pos = {x = 213.09, y = -1147.27, z = 28.27}, -- Då svänger vi vänster här, och fortsätter ner på sidogatan
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('left_turn_sidestreet'), 5000)
    end
  },

  {
	Pos = {x = 85.48, y = -1126.1, z = 28.19}, -- Sväng höger och förbered ytterligare en högersväng
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('right_turn_prep_right'), 5000)
    end
  },

  {
	Pos = {x = 83.18, y = -1083.37, z = 28.2}, -- Sväng in höger här på parkeringen.
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('right_turn_parking'), 5000)
    end
  },

  {
	Pos = {x = 104.72, y = -1071.1, z = 28.15}, -- Då var det dags att öva parkering! Det finns en bra plats där inne till vänster, parkera i den.
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('parking_prep'), 5000)
      PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
      FreezeEntityPosition(vehicle, true)
      Citizen.Wait(3000)
      FreezeEntityPosition(vehicle, false)
    end
  },

  {
	Pos = {x = 110.53, y = -1049.0, z = 28.18}, -- Hmm, ja det ser väl okej ut. Bra! då fortsätter vi. Ut på huvudleden igen.
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('parking_done'), 5000)
      PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
      FreezeEntityPosition(vehicle, true)
      Citizen.Wait(6000)
      FreezeEntityPosition(vehicle, false)
    end
  },

  {
	Pos = {x = 98.46, y = -1065.18, z = 28.21}, -- Då tar vi en Högersväng här och sedan lägger vi oss i det vänstra körfältet.
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('parking_leave'), 5000)
    end
  },

  {
	Pos = {x = 97.14, y = -1023.43, z = 28.33}, -- Ta vänster här.
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('left_turn'), 5000)
    end
  },

  {
	Pos = {x = 73.44, y = -982.58, z = 28.33}, -- Bra, fortsätt ner längs gatan och håll vänster.
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('cont_turn_left'), 5000)
    end
  },

  {
	Pos = {x = -8.3, y = -957.79, z = 28.34}, -- Sväng vänster ner mot bilfirman.
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('left_cardealer'), 5000)
    end
  },

  {
	Pos = {x = -55.35, y = -996.57, z = 28.12}, -- Då passerar vi snart bilfirman, dem har alla typer av fordon. ÖGONEN PÅ VÄGEN!
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('pass_cardealer'), 5000)
    end
  },

  {
	Pos = {x = -82.11, y = -1066.36, z = 26.15}, -- Fortsätt rakt fram i korsningen.
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('leave_cardealer'), 5000)
    end
  },

  {
	Pos = {x = -111.38, y = -1186.03, z = 25.67}, -- Håll höger och förbered en högersväng in mot bennys.
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('prep_turn_benny'), 5000)
    end
  },

  {
	Pos = {x = -112.1, y = -1289.47, z = 28.19}, -- Sväng höger
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('turn_benny'), 5000)
    end
  },

  {
	Pos = {x = -171.04, y = -1296.2, z = 30.01}, -- Du kan ställa dig intill husväggen på vänster sida
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('prep_benny_activity'), 5000)
    end
  },

  {
	Pos = {x = -184.38, y = -1318.52, z = 30.22}, -- Då ska vi öva Backa runt hörn, Lägg i backen och börja sakta backa runt hörnet.
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('bak_corner'), 5000)
      PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
      FreezeEntityPosition(vehicle, true)
      Citizen.Wait(3000)
      FreezeEntityPosition(vehicle, false)
    end
  },

  {
	Pos = {x = -190.52, y = -1305.81, z = 30.25}, -- Hmm, ja det där får väl duga! Vänd bilen så kör vi vidare!
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('leave_benny'), 5000)
    end
  },

  {
	Pos = {x = -261.15, y = -1304.65, z = 30.22}, -- Sväng vänster, så ska vi ta oss ut mot motorvägen. Glöm inte blinkersen!
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('prep_freeway'), 5000)
    end
  },

  {
	Pos = {x = -287.5, y = -1403.36, z = 30.17}, -- Sväng höger.
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('turn_benny'), 5000)
    end
  },
  
  
-- PÅ MOTORVÄGEN
  {
	Pos = {x = -357.07, y = -1420.18, z = 28.24}, -- Höger här, och upp på motorvägen, nu ökar vi till MAX!
    Action = function(playerPed, vehicle, setCurrentZoneType)

      setCurrentZoneType('freeway')

      DrawMissionText(_U('hway_time') .. Config.SpeedLimits['freeway'] .. 'km/h', 5000)
      PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
    end
  },

  {
	Pos = {x = -168.25, y = -1244.3, z = 36.14}, -- Det går snabbt i 120km i timmen! Sväng höger här och kör av motorvägen!
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('leave_freeway'), 5000)
    end
  },



-- PÅ STAN
  {
	Pos = {x = -13.3, y = -1261.5, z = 31.93}, -- Då är vi tillbaka till stadskörning, då är det 80km i timmen som gäller!
    Action = function(playerPed, vehicle, setCurrentZoneType)

      setCurrentZoneType('town')

      DrawMissionText(_U('back_town') .. Config.SpeedLimits['town'] .. 'km/h', 5000)
    end
  },

  {
	Pos = {x = 35.63, y = -1266.65, z = 28.2}, -- Sväng höger.
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('turn_benny'), 5000)
    end
  },

  {
	Pos = {x = 81.28, y = -1335.84, z = 28.26}, -- Nu är vi nästan färdiga, ta oss tillbaka till körskolan.
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('almost_done'), 5000)
    end
  },

  {
	Pos = {x = 221.53, y = -1439.79, z = 28.26}, -- Gör en U sväng här.
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('u_turn'), 5000)
    end
  },

  {
	Pos = {x = 227.54, y = -1405.78, z = 28.93}, -- Parkera bilen i rutan intill trappan, så är vi klara! Grattis!
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('gratz_stay_alert'), 5000)
      PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
    end
  },

  {
    Pos = {x = 242.51, y = -1394.64, z = 29.42},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      ESX.Game.DeleteVehicle(vehicle)
    end
  },

}
