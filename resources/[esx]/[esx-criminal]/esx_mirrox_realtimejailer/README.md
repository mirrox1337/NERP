# esx_jb_realtimejailer

Detta är ett jailsystem som använder IRL-tid för att fängsla någon. Om han återvänder ingame före tiden kommer han att läggas i fängelse igen.


```

function openJailMenu(playerid)
  local elements = {
    {label = "Häktningscell 1",     value = 'Haktet1'},
    {label = "Häktningscell  2",     value = 'Haktet2'},
    {label = "Häktningscell  3",     value = 'Haktet3'},
    {label = "Anstalten",     value = 'fangelset'},
    {label = "Libérer de cellule",     value = 'FreePlayer'},
  }
  ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'jail_menu',
	{
	  title    = 'Sätt i fängelset',
	  align    = 'right',
	  elements = elements,
	},
	function(data3, menu)
		if data3.current.value ~= "FreePlayer" then
			maxLength = 4
			AddTextEntry('FMMC_KEY_TIP8', "Antal timmar i fängelse")
			DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", maxLength)
			ESX.ShowNotification("~b~Ange antalet timmar du vill sätta personen i fängelse.")
			blockinput = true

			while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
				Citizen.Wait( 0 )
			end

			local jailtime = GetOnscreenKeyboardResult()

			UnblockMenuInput()

			if string.len(jailtime) >= 1 and tonumber(jailtime) ~= nil then
				TriggerServerEvent('esx_jb_jailer:PutInJail', playerid, data3.current.value, tonumber(jailtime)*60*60)
			else
				return false
			end
		else
			TriggerServerEvent('esx_jb_jailer:UnJailplayer', playerid)
		end
	end,
	function(data3, menu)
	  menu.close()
	end
  )
end

function UnblockMenuInput()
    Citizen.CreateThread( function()
        Citizen.Wait( 150 )
        blockinput = false 
    end )
end
```


ESX_KASHACTERS - (esx_kashacters/server)


```
local IdentifierTables = {
--Lägg till denna kod--
----------------------------------------
{table = "jail", column = "identifier"}
----------------------------------------
}
```