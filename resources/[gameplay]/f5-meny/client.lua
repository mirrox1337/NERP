local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
  }
  
  ---esx
  local ESX 				= nil
  local PlayerData 	= {}
  
  ---custom scripts
  local cardOpen = false
  local snoing = 0
  local hasHandcuffs 			  = false
  local hasNyckel 			  = false
  local hasBlindfold 			  = false
  local hasDyrkset			  = false
  --local IsDragged               = false
  local hasBulletproof 		  = false
  
  local isSearching			  = false
  local isBlindfolded 		  = false
  local hasEquipped = false
  local playerCars = {}
  -- ESX
  Citizen.CreateThread(function()
	  while ESX == nil do
		  TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		  Citizen.Wait(0)
	  end
  end)
  
  RegisterNetEvent('esx:setJob')
  AddEventHandler('esx:setJob', function(job)
	  PlayerData.job = job
  end)
  
  --för att öppna menyn i andra scripts TriggerEvent('esx_qalle:openMenu')
  RegisterNetEvent('esx_qalle:openMenu')
  AddEventHandler('esx_qalle:openMenu', function()
	 openMenu()
  end)
  
  --- meny f5
  function openMenu()
	  ESX.UI.Menu.CloseAll()
  
	  ESX.UI.Menu.Open(
		  'default', GetCurrentResourceName(), 'f3_menu',
		  {
			  title    = 'Personliga Meny',
			  align    = 'right',
			  elements = {
				  {label = 'Person-Handlingar', value = 'id-card'},
				  {label = 'Individåtgärder', value = 'citizen'},
				  {label = 'Animationer', value = 'animations'},
				  {label = 'Accessoarer', value = 'mask'},
				  {label = 'Färdigheter', value = 'skills'},
				  {label = 'Stäng av / Sätt på telefonen', value = 'togglephone'},
				  {label = 'VD-Meny', value = 'test'},
			  }
		  },
		  function(data, menu)
			  if data.current.value == 'animations' then
				  TriggerEvent('esx_animations:openMenu')
			  elseif data.current.value == 'pee' then
				  TriggerEvent('pee')
			  elseif data.current.value == 'poop' then
				  TriggerEvent('poop')
			  elseif data.current.value == 'togglephone' then
		  TriggerServerEvent("esx_phone3:togglePhone")
			  elseif data.current.value == 'id-card' then
				  ESX.UI.Menu.Open(
					  'default', GetCurrentResourceName(), 'id_card_menu',
					  {
						  title    = 'Identifikation',
						  align    = 'right',
						  elements = {
							  {label = 'Arbete: ' .. PlayerData.job.label .. ' - ' .. PlayerData.job.grade_label, value = 'work'},
							  {label = 'Kolla på din legitimation', value = 'check'},
							  {label = 'Visa legitimation', value = 'show'},
							  {label = 'Kolla dina nycklar', value = 'keys'}
						  }
					  },
					  function(data2, menu2)
						  local action = data2.current.value
						  if action == 'korkort' then
							  ESX.TriggerServerCallback('esx_qalle:getLicenses', function (licenses)
  
								  local elements = {}
  
								  for i=1, #licenses, 1 do
									  if licenses[i].drive == 'yes' then
										  table.insert(elements, {label = 'B-Körkort'})
									  end
									  if licenses[i].drive == 'no' then
										  table.insert(elements, {label = '------'})
									  end
									  if licenses[i].bike == 'yes' then
										  table.insert(elements, {label = 'MC-Körkort'})
									  end
									  if licenses[i].bike == 'no' then
										  table.insert(elements, {label = '------'})
									  end
									  if licenses[i].truck == 'yes' then
										  table.insert(elements, {label = 'CE-K��rkort'})
									  end
									  if licenses[i].truck == 'no' then
										  table.insert(elements, {label = '------'})
									  end
								  end
  
  
									ESX.UI.Menu.Open(
										'default', GetCurrentResourceName(), 'licenses',
										{
										title    = 'Körkortsbehållare',
										align = 'right',
										elements = elements
  
									},
									function(data3, menu3)
						  
  
									end,
  
									function(data3, menu3)
										  menu3.close()
								  end
									)
								end, GetPlayerServerId(PlayerId()))
							elseif action == 'keys' then
							  ESX.TriggerServerCallback('esx_wille_lager:getKeys', function (Keys)
  
								  local elements = {}
  
								  for i=1, #Keys, 1 do
									  table.insert(elements, {label = 'Nyckel #' ..Keys[i].kU.. ' ' ..Keys[i].kN, keyName = Keys[i].kN, keyUnit = Keys[i].kU})
								  end
  
  
									ESX.UI.Menu.Open(
										'default', GetCurrentResourceName(), 'licenses',
										{
										title    = 'Nyckelskåp',
										align = 'right',
										elements = elements
  
									},
									function(data3, menu3)
										ESX.UI.Menu.Open(
										'default', GetCurrentResourceName(), 'give_key_confirmation',
										{
											title    = 'Ge iväg nyckel #' ..data3.current.keyUnit..'?',
											align = 'right',
											elements = {
												{label = 'Ja', value = 'yes'},
												{label = 'Nej', value = 'no'}
											}
										},
										function(data4, menu4)
  
											local player, distance = ESX.Game.GetClosestPlayer()
										  if distance ~= -1 and distance <= 3.0 then
											  if data4.current.value == 'yes' then
												  TriggerServerEvent('esx_wille_lager:giveKey', data3.current.keyName, data3.current.keyUnit, GetPlayerServerId(player))
												  ESX.UI.Menu.CloseAll()
												  openMenu()
												else
												  ESX.UI.Menu.CloseAll()
												  openMenu()
												end
											else
												--ESX.ShowNotification('Ingen i närheten')
												exports['mythic_notify']:SendAlert('error', 'Ingen person nära.')
												
											end                         
  
									end,
  
									function(data4, menu4)
									  menu4.close()
								  end
									)   
  
									end,
  
									function(data3, menu3)
										  menu3.close()
								  end
									)
								end, GetPlayerServerId(PlayerId()))      
						  elseif action == 'work' then
							ESX.UI.Menu.Open(
								'default', GetCurrentResourceName(), 'remove_confirmation',
								{
									title    = 'Vill du säga upp dig?',
									elements = {
										{label = 'Ja', value = 'yes'},
										{label = 'Nej', value = 'no'}
									}
								},
								function(data3, menu3)
  
								  if data3.current.value == 'yes' then
									  TriggerServerEvent('esx_qalle_jobs:unemployed', source)
									  --sendNotification('Du sa upp dig!', 'success', 5000)
									  exports['mythic_notify']:SendAlert('warning', 'Du har sagt upp dig.')
									  ESX.UI.Menu.CloseAll()
									  openMenu()
									else
									  ESX.UI.Menu.CloseAll()
									  openMenu()
									end                         
  
							end,
  
							function(data3, menu3)
							  menu3.close()
									  end
								  )                 			            		
									  elseif data2.current.value == 'check' then
											  TriggerServerEvent('korkort:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
									  elseif data2.current.value == 'show' then
											  local player, distance = ESX.Game.GetClosestPlayer()
  
											  if distance ~= -1 and distance <= 3.0 then
													  TriggerServerEvent('korkort:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player))
											  else
													  --ESX.ShowNotification('Ingen i närheten')
													  exports['mythic_notify']:SendAlert('error', 'Ingen person nära.')
											  end
									  end
							  end,
							  function(data2, menu2)
					  menu2.close()
				  end
					  )
			  elseif data.current.value == 'mask' then					
					  ESX.UI.Menu.Open(
						  
						  'default', GetCurrentResourceName(), 'asccesories_menu',
						  {
							  title    = 'Accessoarer',
							  align    = 'right',
							  elements = {
								  {label = 'Hjälm/Hatt På/Av', value = 'Helmet'},
								  {label = 'Mask På/Av', value = 'Mask'},
								  {label = 'Glasögon På/Av', value = 'Glasses'},
								  {label = 'Skottsäkervest På/Av', value = 'bulletproof'},
								  {label = 'Armaccessoarer På/Av', value = 'Watches'},
								  {label = 'Örhänge(n) På/Av', value = 'Ears'}
							  }
						  },
						  function(data2, menu2)
  
							  if data2.current.value == 'Helmet' then
								 --menu2.close()
								 local dict = "misscommon@van_put_on_masks"
								  local playerped = GetPlayerPed(PlayerId())
								  RequestAnimDict(dict)
								  while not HasAnimDictLoaded(dict) do
									Citizen.Wait(0)
								  end
								  TaskPlayAnim(playerped, dict, "put_on_mask_ps", 2.0, 2.5, -1, 49, 0, 0, 0, 0 )
								  Citizen.Wait(1000)
								 SetUnsetAccessory(data2.current.value)
								 ClearPedSecondaryTask(playerped)
							  end
  
							  if data2.current.value == 'Ears' then
								  --menu2.close()
								 SetUnsetAccessory(data2.current.value)
							  end
  
							  if data2.current.value == 'Glasses' then
								  --menu2.close()
								  local dict = "clothingspecs"
								  local playerped = GetPlayerPed(PlayerId())
								  RequestAnimDict(dict)
								  while not HasAnimDictLoaded(dict) do
									Citizen.Wait(0)
								  end
								  TaskPlayAnim(playerped, dict, "try_glasses_neutral_c", 2.0, 2.5, -1, 49, 0, 0, 0, 0 )
								  Citizen.Wait(1000)
								 SetUnsetAccessory(data2.current.value)
								 ClearPedSecondaryTask(playerped)
							  end
  
							  if data2.current.value == 'Watches' then
								  --menu2.close()
								 SetUnsetAccessory(data2.current.value)
							  end
  
							  if data2.current.value == 'bulletproof' then
								  if hasBulletproof and not hasEquipped then
								  --menu2.close()
								  TriggerEvent('esx_qalle:bulletproof')
								  hasEquipped = true
								  elseif hasEquipped then
								  TriggerEvent('esx_qalle:bulletproofoff')
								  hasEquipped = false
							  else
								  --sendNotification('Du har ingen Skottsäkervest', 'error', 2500)
								  exports['mythic_notify']:SendAlert('error', 'Du har ingen skottsäkervest.')
							  end
						  end
  
							  if data2.current.value == 'Mask' then
								  --menu2.close()
								  local dict = "misscommon@std_take_off_masks"
								  local playerped = GetPlayerPed(PlayerId())
								  RequestAnimDict(dict)
								  while not HasAnimDictLoaded(dict) do
									Citizen.Wait(0)
								  end
								  TaskPlayAnim(playerped, dict, "take_off_mask_rds", 2.0, 2.5, -1, 49, 0, 0, 0, 0 )
								  Citizen.Wait(1000)
								 SetUnsetAccessory(data2.current.value)
								 ClearPedSecondaryTask(playerped)
							  end
  
							  
						  end,
						  function(data2, menu2)
							  menu2.close()
						  end
					  )
			  elseif data.current.value == 'skills' then
					  exports["gamz-skillsystem"]:SkillMenu()
  
			  elseif data.current.value == 'citizen' then					
					  ESX.UI.Menu.Open(
						  
						  'default', GetCurrentResourceName(), 'citizen_menu',
						  {
							  title    = 'Individåtgärder',
							  align    = 'right',
							  elements = {
								  {label = 'Sök Igenom', value = 'search'},
									  --{label = ('Lyft upp person'), value = 'lift'},
								  {label = 'Ögonbindel På/Av', value = 'blind'},
								  {label = ('Eskotera'),    value = 'drag'},
								  {label = ('Knyt på buntband'),    value = 'handcuff'},
								   {label = ('Skär av buntband'),    value = 'unhandcuff'},
							  }
						  },
												  function(data2, menu2)
													  
													  if data.current.value == 'lift' and not isGettingLifted then
													  local closestPlayer, distance = ESX.Game.GetClosestPlayer()
														  if distance ~= -1 and distance <= 3.0 and not IsPedInAnyVehicle(GetPlayerPed(-1)) and not IsPedInAnyVehicle(GetPlayerPed(closestPlayer)) then
															  TriggerServerEvent('lift:tryLift', GetPlayerServerId(closestPlayer))
														  else
															  --ESX.ShowNotification('Ingen i närheten')
															  exports['mythic_notify']:SendAlert('error', 'Ingen person nära.')
														  end
													  end
  
								if data2.current.value == 'blind' then
								local player, distance = ESX.Game.GetClosestPlayer()
									if distance ~= -1 and distance <= 3.0 then
								   ESX.TriggerServerCallback('blindfold:itemCheck', function( hasItem )
									  TriggerServerEvent('blindfold', GetPlayerServerId(player), hasItem)
									end)
								else
								   --sendNotification('Ingen i närheten', 'error', 2500)
								   exports['mythic_notify']:SendAlert('error', 'Ingen person nära.')
								end    
							  elseif data2.current.value == "helmet" then
								  local player, distance = ESX.Game.GetClosestPlayer()
								  if distance ~= -1 and distance <= 3.0 then
									  if IsPedCuffed(GetPlayerPed(player)) or IsPedDeadOrDying(GetPlayerPed(player)) then
										  TriggerServerEvent("esx_qalle:removeHelmet", GetPlayerServerId(player))
									  end
								  else
									  --sendNotification('Ingen i närheten', 'error', 2500)
									  exports['mythic_notify']:SendAlert('error', 'Ingen person nära.')
								  end

								elseif data2.current.value == 'search' then
								   local player, distance = ESX.Game.GetClosestPlayer()
								   local target, distance = ESX.Game.GetClosestPlayer()
	
								   if distance ~= -1 and distance <= 3.0 then
										--- kollar ifall spelaren håller upp händerna eller cuffad eller död.
									   if IsEntityPlayingAnim(GetPlayerPed(player), "random@mugging3", "handsup_standing_base", 3) or IsEntityPlayingAnim(GetPlayerPed(player), "mp_arresting", "idle", 3) or IsPedDeadOrDying(GetPlayerPed(player)) then
										   OpenBodySearchMenu(target)
									   end
										--- kollar ifall spelaren inte håller upp händerna
                                   if not IsEntityPlayingAnim(GetPlayerPed(player), "random@mugging3", "handsup_standing_base", 3) then
                                       exports['mythic_notify']:SendAlert('error', 'Personen håller inte upp händerna')
								   end
							   else
								  --sendNotification('Ingen person nära', 'error', 2500)
								  exports['mythic_notify']:SendAlert('error', 'Ingen person nära.')
							   end							                                       
	
								elseif data2.current.value == 'handcuff' then
								   local player, distance = ESX.Game.GetClosestPlayer()
		   
									   if distance ~= -1 and distance <= 3.0 then
										   if hasHandcuffs then
											TriggerServerEvent('esx_qalle:removeInventoryItem','buntband', 1)
											TriggerServerEvent('esx_policejob:handcuff', GetPlayerServerId(player))
										   else
											   --sendNotification('Du har inga buntband', 'error', 2500)
											   exports['mythic_notify']:SendAlert('error', 'Du har inga buntband.')
										   end
									   else
										   --sendNotification('Ingen person nära', 'error', 2500)
										   exports['mythic_notify']:SendAlert('error', 'Ingen person nära.')
									   end
  
								elseif data2.current.value == 'unhandcuff' then
								   local player, distance = ESX.Game.GetClosestPlayer()
		   
									   if distance ~= -1 and distance <= 3.0 then
										if IsPedCuffed(GetPlayerPed(player)) then
											TriggerServerEvent('esx_policejob:unhandcuff', GetPlayerServerId(player))
										else
											  --sendNotification('Personen har inte buntband på sig', 'error', 2500)
											  exports['mythic_notify']:SendAlert('warning', 'Personen har inte buntband på sig.')
										end
									   else
										   --sendNotification('Ingen person nära', 'error', 2500)
										   exports['mythic_notify']:SendAlert('error', 'Ingen person nära.')
									   end
								elseif data2.current.value == 'drag' then
									local player, distance = ESX.Game.GetClosestPlayer()
									if distance ~= -1 and distance <= 3.0 then
									 TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(player))
									end
								end
							end,
							function(data2, menu2)
								menu2.close()
							end
					  )
  
			  elseif data.current.value == 'vehicle' then					
					  ESX.UI.Menu.Open(
						  
						  'default', GetCurrentResourceName(), 'vehicle_menu',
						  {
							  title    = 'Fordonåtgärder',
							  align    = 'right',
							  elements = {
								  {label = 'Lås / Låsupp', value = 'lock'},
								  {label = 'Motorn', value = 'engine'},
								  {label = 'Huven', value = 'door_f'},
								  {label = 'Bakluckan', value = 'door_f2'},
								  {label = 'Bakdörrarna', value = 'door_f3'},
								  {label = 'Framdörrarna', value = 'door_f4'},
								  {label = 'Lås Hastighet', value = 'hastighet'},
							  }
						  },
						  function(data2, menu2)
  
							  if data2.current.value == 'lock' then
								  OpenCloseVehicle()
							  end
  
							  if data2.current.value == 'engine' then
								  TriggerEvent("engine")
							  end					                                       
  
							  if data2.current.value == 'door_f' then
								  TriggerEvent("hood")
							  end
  
							  if data2.current.value == 'door_f2' then
								  TriggerEvent("trunk")
							  end
  
							  if data2.current.value == 'door_f3' then
								  TriggerEvent("rdoors")
							  end
  
							  if data2.current.value == 'door_f4' then
								  TriggerEvent("fdoors")
							  end
  
							  if data2.current.value == 'hastighet' then
							  ESX.UI.Menu.Open(
						  
						  'default', GetCurrentResourceName(), 'citizen_menu',
						  {
							  title    = 'Lås Hastighetsmeny',
							  elements = {
								  {label = '40', value = '40'},
								  {label = '60', value = '60'},
								  {label = '80', value = '80'},
								  {label = ('100'),    value = '100'},
								   {label = ('120'),    value = '120'},
								   {label = ('Återställ'), value = '0'}
							  }
						  },
						  function(data2, menu2)
							  if data2.current.value == '0' then
								  local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
								  SetEntityMaxSpeed(veh, 10000/3.65)
							  else
								  local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
								  SetEntityMaxSpeed(veh, data2.current.value/3.65)
							  end
  
  
							  
						  end,
						  function(data2, menu2)
							  menu2.close()
						  end
					  )
						  end
  
							  
						  end,
						  function(data2, menu2)
							  menu2.close()
						  end
					  )
			  elseif data.current.value == 'test' and PlayerData.job.grade_name == 'boss' then					
					  ESX.UI.Menu.Open(
						  
						  'default', GetCurrentResourceName(), 'boss_menu',
						  {
							  title    = 'CEO Meny',
							  align    = 'right',
							  elements = {
								  {label = 'Företagspengar', value = 'society_money'},
								  {label = 'Rekrytera (Närmsta Spelare)',     value = 'recruit_player'},
								  {label = 'Sparka (Närmsta Spelare)',              value = 'kick_player'},
								  {label = 'Höj Rang (Närmsta Spelare)', value = 'promote_player'},
								  {label = 'Sänk Rang (Närmsta Spelare)',  value = 'demote_player'}
							  }
						  },
						  function(data2, menu2)
  
							  if data2.current.value == 'society_money' then
							  money = nil
                              ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
                                exports['mythic_notify']:SendAlert('inform', 'Ditt företag ligger just nu på ' .. money .. ' SEK')
							   end, PlayerData.job.name)
							  end
  
							  if data2.current.value == 'recruit_player' then
								  if PlayerData.job.grade_name == 'boss' then
										  local job =  PlayerData.job.name
										  local grade = 0
										  local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
									  if closestPlayer == -1 or closestDistance > 3.0 then
										  --sendNotification('Ingen person nära', 'error', 2500)
										  exports['mythic_notify']:SendAlert('error', 'Ingen person nära.')
									  else
										  TriggerServerEvent('esx_qalle:recruit_player', GetPlayerServerId(closestPlayer), job,grade)
									  end
								  else
									  --sendNotification('Du har inte rättigheterna', 'error', 2500)
									  exports['mythic_notify']:SendAlert('error', 'Du har inte rättigheterna.')
								  end								
							  end
  
							  if data2.current.value == 'kick_player' then
								  if PlayerData.job.grade_name == 'boss' then
										  local job =  PlayerData.job.name
										  local grade = 0
										  local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
									  if closestPlayer == -1 or closestDistance > 3.0 then
										  --sendNotification('Ingen person nära', 'error', 2500)
										  exports['mythic_notify']:SendAlert('error', 'Ingen person nära.')
									  else
										  TriggerServerEvent('esx_qalle:kick_player', GetPlayerServerId(closestPlayer))
									  end
								  else
									  --sendNotification('Du har inte rättigheterna', 'error', 2500)
									  exports['mythic_notify']:SendAlert('error', 'Du har inte rättigheterna.')
								  end								
							  end
  
  
							  if data2.current.value == 'promote_player' then
								  if PlayerData.job.grade_name == 'boss' then
										  local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
									  if closestPlayer == -1 or closestDistance > 3.0 then
										  --sendNotification('Ingen person nära', 'error', 2500)
										  exports['mythic_notify']:SendAlert('error', 'Ingen person nära.')
									  else
										  TriggerServerEvent('esx_qalle:promote_player', GetPlayerServerId(closestPlayer))
									  end
								  else
									  --sendNotification('Du har inte rättigheterna', 'error', 2500)
									  exports['mythic_notify']:SendAlert('error', 'Du har inte rättigheterna.')
								  end																
							  end
  
							  if data2.current.value == 'demote_player' then
								  if PlayerData.job.grade_name == 'boss' then
										  local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
									  if closestPlayer == -1 or closestDistance > 3.0 then
										  --sendNotification('Ingen person nära', 'error', 2500)
										  exports['mythic_notify']:SendAlert('error', 'Ingen person nära.')
									  else
										  TriggerServerEvent('esx_qalle:demote_player', GetPlayerServerId(closestPlayer))
									  end
								  else
									  --sendNotification('Du har inte rättigheterna', 'error', 2500)
									  exports['mythic_notify']:SendAlert('error', 'Du har inte rättigheterna.')
								  end
							  end
							  
						  end,
						  function(data2, menu2)
							  menu2.close()
						  end
					  )
			  elseif data.current.value == 'material' then
  
			   end
  
		  end,
		  function(data, menu)
			  menu.close()
		  end
	  )
  end
  
  ---sökigenommeny
  function OpenBodySearchMenu(player)
  
	ESX.TriggerServerCallback('esx_qalle:getOtherPlayerData', function(data)
  
	  local elements = {}
  
	  table.insert(elements, {label = '--- Nycklar ---', value = nil})
  
  
	  --[[if data.nycklar ~= nil then
		  for i=1, #data.nycklar, 1 do
			  table.insert(elements, {label = 'Nyckel #' ..data.nycklar[i].kU.. ' ' ..data.nycklar[i].kN, keyName = data.nycklar[i].kN, keyUnit = data.nycklar[i].kU, action = 'take_key'})
		  end
	  end]]
  
	  for i=1, #data.data.inventory, 1 do
		if data.data.inventory[i].count > 0 and data.data.inventory[i].name == 'policecard' then
		  table.insert(elements, {
			label          = 'Polis Nyckel #' ..math.random(1,10),
			value          = data.data.inventory[i].name,
			itemType       = 'item_standard',
			amount         = data.data.inventory[i].count,
		  })
	  
		end
	  end
  
  
	  local blackMoney = 0
	  
	  for i=1, #data.data.accounts, 1 do
		if data.data.accounts[i].name == 'black_money' then
		  blackMoney = data.data.accounts[i].money
		end
	  end
	   
	  table.insert(elements, {label = '--- Pengar ---', value = nil})
  
	  table.insert(elements, {
		label      = 'Konfiskera Kontanter: ' .. data.data.money .. ' SEK',
		value      = 'money',
		itemType   = 'item_money',
		amount     = data.data.money,
	  })
	   
	  
	  table.insert(elements, {
		label          = 'Konfiskera Svarta: ' .. blackMoney .. ' SEK',
		value          = 'black_money',
		itemType       = 'item_account',
		amount         = blackMoney
	  })
	  
	  table.insert(elements, {label = '--- Vapen ---', value = nil})
  
	  for i=1, #data.data.weapons, 1 do
		table.insert(elements, {
		  label          = 'Konfiskera: ' .. ESX.GetWeaponLabel(data.data.weapons[i].name),
		  value          = data.data.weapons[i].name,
		  itemType       = 'item_weapon',
		  amount         = data.data.ammo,
		})
	  end
  
	  table.insert(elements, {label = '--- Föremål ---', value = nil})
  
	  for i=1, #data.data.inventory, 1 do
		if data.data.inventory[i].count > 0 and data.data.inventory[i].name ~= 'policecard' then
		  table.insert(elements, {
			label          = 'Konfiskera: ' .. data.data.inventory[i].count .. 'st ' .. data.data.inventory[i].label,
			value          = data.data.inventory[i].name,
			itemType       = 'item_standard',
			amount         = data.data.inventory[i].count,
		  })
	  
		end
	  end
  
  
	  ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'body_search',
		{
		  title    = 'Söker individ',
		  align    = 'right',
		  elements = elements,
		},
		function(data, menu)
  
		  local itemType = data.current.itemType
		  local itemName = data.current.value
		  local amount   = data.current.amount
  
		  if data.current.value ~= nil then
			  local player, distance = ESX.Game.GetClosestPlayer()
			  if snoing == 0 then
				  snoing = 1
  
				  RequestAnimDict("amb@medic@standing@kneel@exit")
				  RequestAnimDict("anim@gangops@facility@servers@bodysearch@")
				  RequestAnimDict("amb@medic@standing@kneel@base")
				  while not HasAnimDictLoaded("amb@medic@standing@kneel@exit") do
					  Citizen.Wait(0)
				  end
				  while not HasAnimDictLoaded("anim@gangops@facility@servers@bodysearch@") do
					  Citizen.Wait(0)
				  end
				  while not HasAnimDictLoaded("amb@medic@standing@kneel@base") do
					  Citizen.Wait(0)
				  end
				  if IsEntityDead(GetPlayerPed(player)) then
					  TaskPlayAnim(GetPlayerPed(-1), "amb@medic@standing@kneel@base" ,"base" ,8.0, -8.0, -1, 1, 0, false, false, false )
				  end
				  TaskPlayAnim(GetPlayerPed(-1), "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 48, 0, false, false, false )
				  Citizen.Wait(6200)
				  snoing = 0
				  local target, distance = ESX.Game.GetClosestPlayer()
				  if IsEntityPlayingAnim(GetPlayerPed(-1), "anim@gangops@facility@servers@bodysearch@" ,"player_search", 3) and distance ~= -1 and distance <= 3.0 then
					  TriggerServerEvent('esx_qalle:confiscatePlayerItem', GetPlayerServerId(target), itemType, itemName, amount)
					  OpenBodySearchMenu(player)   
					  Citizen.Wait(800)
				  else
					  menu.close()
					  --sendNotification('Personen är för långt bort', 'error', 2500)
					  exports['mythic_notify']:SendAlert('error', 'Ingen person nära.')
				  end 
				  if IsEntityPlayingAnim(GetPlayerPed(-1), "amb@medic@standing@kneel@base" ,"base", 3) then
					  TaskPlayAnim(GetPlayerPed(-1), "amb@medic@standing@kneel@exit" ,"exit" ,8.0, -8.0, -1, 0, 0, false, false, false )
				  end
			  end
		  else
			  local player, distance = ESX.Game.GetClosestPlayer()
			  if snoing == 0 then
				  snoing = 1
  
				  RequestAnimDict("amb@medic@standing@kneel@exit")
				  RequestAnimDict("anim@gangops@facility@servers@bodysearch@")
				  RequestAnimDict("amb@medic@standing@kneel@base")
				  while not HasAnimDictLoaded("amb@medic@standing@kneel@exit") do
					  Citizen.Wait(0)
				  end
				  while not HasAnimDictLoaded("anim@gangops@facility@servers@bodysearch@") do
					  Citizen.Wait(0)
				  end
				  while not HasAnimDictLoaded("amb@medic@standing@kneel@base") do
					  Citizen.Wait(0)
				  end
				  if IsEntityDead(GetPlayerPed(player)) then
					  TaskPlayAnim(GetPlayerPed(-1), "amb@medic@standing@kneel@base" ,"base" ,8.0, -8.0, -1, 1, 0, false, false, false )
				  end
				  TaskPlayAnim(GetPlayerPed(-1), "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 48, 0, false, false, false )
				  Citizen.Wait(6200)
				  snoing = 0
				  local target, distance = ESX.Game.GetClosestPlayer()
				  if IsEntityPlayingAnim(GetPlayerPed(-1), "anim@gangops@facility@servers@bodysearch@" ,"player_search", 3) and distance ~= -1 and distance <= 3.0 then
					  TriggerServerEvent('esx-qalle-storage:stealKey', GetPlayerServerId(target), data.current.keyUnit, data.current.keyName)
					  Citizen.Wait(800)
					  OpenBodySearchMenu(player)   
					  Citizen.Wait(800)
				  else
					  menu.close()
					  --sendNotification('Personen är för långt bort', 'error', 2500)
					  exports['mythic_notify']:SendAlert('error', 'Ingen person nära.')
				  end 
				  if IsEntityPlayingAnim(GetPlayerPed(-1), "amb@medic@standing@kneel@base" ,"base", 3) then
					  TaskPlayAnim(GetPlayerPed(-1), "amb@medic@standing@kneel@exit" ,"exit" ,8.0, -8.0, -1, 0, 0, false, false, false )
				  end
			  end
		  end 
  
		end,
		function(data, menu)
		  menu.close()
		end
	  )
  
	end, GetPlayerServerId(player))
  
  end
  
  function openVehicleMenu()
	  ESX.UI.Menu.Open(
  
	  'default', GetCurrentResourceName(), 'vehicle_menu',
	  {
		  title    = 'Fordonåtgärder',
		  align    = 'right',
		  elements = {
			  {label = 'Bälte av/på', value = 'beltToggle'},
			  {label = 'Lås / Låsupp', value = 'lock'},
			  {label = 'Motorn', value = 'engine'},
			  {label = 'Huven', value = 'door_f'},
			  {label = 'Bakluckan', value = 'door_f2'},
			  {label = 'Bakdörrarna', value = 'door_f3'},
			  {label = 'Framdörrarna', value = 'door_f4'},
			  {label = 'Lås Hastighet', value = 'hastighet'},
		  }
	  },
	  function(data, menu)
  
		  if data.current.value == 'lock' then
			  OpenCloseVehicle()
		  end
  
		  if data.current.value == 'engine' then
			  TriggerEvent("engine")
		  end
  
		  if data.current.value == 'beltToggle' then
			   beltToggle()
		  end				                                       
  
		  if data.current.value == 'door_f' then
			  TriggerEvent("hood")
		  end
  
		  if data.current.value == 'door_f2' then
			  TriggerEvent("trunk")
		  end
  
		  if data.current.value == 'door_f3' then
			  TriggerEvent("rdoors")
		  end
  
		  if data.current.value == 'door_f4' then
			  TriggerEvent("fdoors")
		  end
  
		  if data.current.value == 'hastighet' then
		  ESX.UI.Menu.Open(
  
			  'default', GetCurrentResourceName(), 'hastighet',
			  {
				  title    = 'Lås Hastighetsmeny',
				  align    = 'right',
				  elements = {
					  {label = '40', value = '40'},
					  {label = '60', value = '60'},
					  {label = '80', value = '80'},
					  {label = ('100'),    value = '100'},
					  {label = ('120'),    value = '120'},
					  {label = ('Återställ'), value = '0'}
				  }
			  },
		  function(data2, menu2)
			  if data2.current.value == '0' then
				  local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
				  SetEntityMaxSpeed(veh, 10000/3.65)
			  else
				  local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
				  SetEntityMaxSpeed(veh, data2.current.value/3.65)
			  end
  
  
		  
		  end,
	  function(data2, menu2)
		  menu2.close()
	  end
	  )
	  end
  
		  
	  end,
	  function(data, menu)
		  menu.close()
	  end
	  )
  end
  
  ---alla grejer
  RegisterNetEvent('esx:playerLoaded')
  AddEventHandler('esx:playerLoaded', function(xPlayer)
	  PlayerData = xPlayer
  
	  TriggerEvent('esx_qalle:hasNotBulletproof')
	  TriggerEvent('esx_qalle:hasNotHandcuffs')
	  TriggerEvent('esx_qalle:hasNotNyckel')
	  TriggerEvent('esx_qalle:hasNotBlindfold')
	  TriggerEvent('esx_qalle:hasNotDyrkset')
	  TriggerEvent('esx_qalle:hasNotECM')
  
	  for i=1, #PlayerData.inventory, 1 do
		  if PlayerData.inventory[i].name == 'buntband' then
			  if PlayerData.inventory[i].count > 0 then
				  TriggerEvent('esx_qalle:hasHandcuffs')
			  end
		  end
	  end
  
	  for i=1, #PlayerData.inventory, 1 do
		  if PlayerData.inventory[i].name == 'nyckel' then
			  if PlayerData.inventory[i].count > 0 then
				  TriggerEvent('esx_qalle:hasNyckel')
			  end
		  end
	  end
	  
	  for i=1, #PlayerData.inventory, 1 do
		  if PlayerData.inventory[i].name == 'blindfold' then
			  if PlayerData.inventory[i].count > 0 then
				  TriggerEvent('esx_qalle:hasBlindfold')
			  end
		  end
	  end
  
	  for i=1, #PlayerData.inventory, 1 do
		  if PlayerData.inventory[i].name == 'bulletproof' then
			  if PlayerData.inventory[i].count > 0 then
				  TriggerEvent('esx_qalle:hasBulletproof')
			  end
		  end
	  end
	  
	  for i=1, #PlayerData.inventory, 1 do
		  if PlayerData.inventory[i].name == 'dyrkset' then
			  if PlayerData.inventory[i].count > 0 then
				  TriggerEvent('esx_qalle:hasDyrkset')
			  end
		  end
	  end
  end)
  
  RegisterNetEvent('esx_qalle:hasNyckel')
  AddEventHandler('esx_qalle:hasNyckel', function()
	  hasNyckel = true
  end)
  
  RegisterNetEvent('esx_qalle:hasNotNyckel')
  AddEventHandler('esx_qalle:hasNotNyckel', function()
	  hasNyckel = false
  end)
  
  RegisterNetEvent('esx_qalle:hasHandcuffs')
  AddEventHandler('esx_qalle:hasHandcuffs', function()
	  hasHandcuffs = true
  end)
  
  RegisterNetEvent('esx_qalle:hasNotHandcuffs')
  AddEventHandler('esx_qalle:hasNotHandcuffs', function()
	  hasHandcuffs = false
  end)
  
  RegisterNetEvent('esx_qalle:hasBlindfold')
  AddEventHandler('esx_qalle:hasBlindfold', function()
	  hasBlindfold = true
  end)
  
  RegisterNetEvent('esx_qalle:hasNotBlindfold')
  AddEventHandler('esx_qalle:hasNotBlindfold', function()
	  hasBlindfold = false
  end)
  
  RegisterNetEvent('esx_qalle:hasDyrkset')
  AddEventHandler('esx_qalle:hasDyrkset', function()
	  hasDyrkset = true
  end)
  
  RegisterNetEvent('esx_qalle:hasNotDyrkset')
  AddEventHandler('esx_qalle:hasNotDyrkset', function()
	  hasDyrkset = false
  end)
  
  RegisterNetEvent('esx_qalle:hasBulletproof')
  AddEventHandler('esx_qalle:hasBulletproof', function()
	  hasBulletproof = true
  end)
  
  RegisterNetEvent('esx_qalle:hasNotBulletproof')
  AddEventHandler('esx_qalle:hasNotBulletproof', function()
	  hasBulletproof = false
  end)
  
  -- asccesories
  function SetUnsetAccessory(accessory)
	  
	  ESX.TriggerServerCallback('esx_accessories:get', function(hasAccessory, accessorySkin)
		  local _accessory = string.lower(accessory)
  
		  if hasAccessory then
			  TriggerEvent('skinchanger:getSkin', function(skin)
				  local mAccessory = -1
				  local mColor = 0      
				  if _accessory == "mask" then
					  mAccessory = 0
				  end
				  if skin[_accessory .. '_1'] == mAccessory then
					  mAccessory = accessorySkin[_accessory .. '_1']
					  mColor = accessorySkin[_accessory .. '_2']
				  end
				  local accessorySkin = {}
				  accessorySkin[_accessory .. '_1'] = mAccessory
				  accessorySkin[_accessory .. '_2'] = mColor
				  TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
			  end)
          else
              exports['mythic_notify']:SendAlert('error', 'Du har inte denna accessoaren')
		  end
  
	  end, accessory)
	  
  end
  
  -- C O N F I G --
  interactionDistance = 9.5 --The radius you have to be in to interact with the vehicle.
  lockDistance = 25 --The radius you have to be in to lock your vehicle.
  
  --  V A R I A B L E S --
  engineoff = false
  saved = false
  controlsave_bool = false
  
  -- E N G I N E --
  IsEngineOn = true
  RegisterNetEvent('engine')
  AddEventHandler('engine',function() 
	  local player = GetPlayerPed(-1)
	  
	  if (IsPedSittingInAnyVehicle(player)) then 
		  local vehicle = GetVehiclePedIsIn(player,false)
		  
		  if IsEngineOn == true then
			  IsEngineOn = false
			  SetVehicleEngineOn(vehicle,false,false,false)
		  else
			  IsEngineOn = true
			  SetVehicleUndriveable(vehicle,false)
			  SetVehicleEngineOn(vehicle,true,false,false)
		  end
		  
		  while (IsEngineOn == false) do
			  SetVehicleUndriveable(vehicle,true)
			  Citizen.Wait(0)
		  end
	  end
  end)
  
  -- T R U N K --
  RegisterNetEvent('trunk')
  AddEventHandler('trunk',function() 
	  local player = GetPlayerPed(-1)
			  if controlsave_bool == true then
				  vehicle = saveVehicle
			  else
				  vehicle = GetVehiclePedIsIn(player,true)
			  end
			  
			  local isopen = GetVehicleDoorAngleRatio(vehicle,5)
			  local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(player), GetEntityCoords(vehicle), 1)
			  
			  if distanceToVeh <= interactionDistance then
				  if (isopen == 0) then
				  SetVehicleDoorOpen(vehicle,5,0,0)
				  else
				  SetVehicleDoorShut(vehicle,5,0)
				  end
			  else
  
			  end
  end)
  
  RegisterNetEvent('fdoors')
  AddEventHandler('fdoors',function() 
	  local player = GetPlayerPed(-1)
			  if controlsave_bool == true then
				  vehicle = saveVehicle
			  else
				  vehicle = GetVehiclePedIsIn(player,true)
			  end
			  local isopen = GetVehicleDoorAngleRatio(vehicle,0) and GetVehicleDoorAngleRatio(vehicle,1)
			  local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(player), GetEntityCoords(vehicle), 1)
			  
			  if distanceToVeh <= interactionDistance then
				  if (isopen == 0) then
				  SetVehicleDoorOpen(vehicle,0,0,0)
				  SetVehicleDoorOpen(vehicle,1,0,0)
				  else
				  SetVehicleDoorShut(vehicle,0,0)
				  SetVehicleDoorShut(vehicle,1,0)
				  end
			  else
  
			  end
  end)	
  -- R E A R  D O O R S --
  RegisterNetEvent('rdoors')
  AddEventHandler('rdoors',function() 
	  local player = GetPlayerPed(-1)
			  if controlsave_bool == true then
				  vehicle = saveVehicle
			  else
				  vehicle = GetVehiclePedIsIn(player,true)
			  end
			  local isopen = GetVehicleDoorAngleRatio(vehicle,2) and GetVehicleDoorAngleRatio(vehicle,3)
			  local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(player), GetEntityCoords(vehicle), 1)
			  
			  if distanceToVeh <= interactionDistance then
				  if (isopen == 0) then
				  SetVehicleDoorOpen(vehicle,2,0,0)
				  SetVehicleDoorOpen(vehicle,3,0,0)
				  else
				  SetVehicleDoorShut(vehicle,2,0)
				  SetVehicleDoorShut(vehicle,3,0)
				  end
			  else
  
			  end
  end)		
  
  -- H O O D --
  RegisterNetEvent('hood')
  AddEventHandler('hood',function() 
	  local player = GetPlayerPed(-1)
		  if controlsave_bool == true then
			  vehicle = saveVehicle
		  else
			  vehicle = GetVehiclePedIsIn(player,true)
		  end
			  
			  local isopen = GetVehicleDoorAngleRatio(vehicle,4)
			  local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(player), GetEntityCoords(vehicle), 1)
			  
			  if distanceToVeh <= interactionDistance then
				  if (isopen == 0) then
				  SetVehicleDoorOpen(vehicle,4,0,0)
				  else
				  SetVehicleDoorShut(vehicle,4,0)
				  end
			  else
  
			  end
  end)
  
  
  -- notification
  function sendNotification(message, messageType, messageTimeout)
	  TriggerEvent("pNotify:SendNotification", {
		  text = message,
		  type = messageType,
		  queue = "wille",
		  timeout = messageTimeout,
		  layout = "bottomCenter"
	  })
  end
  
  --låsa / låsa upp
  function OpenCloseVehicle()
	local playerPed = GetPlayerPed(-1)
	local coords    = GetEntityCoords(playerPed)
	local coords2 = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 5.0, 0.0)
	local vehicle = nil
  
  
	if IsPedInAnyVehicle(playerPed,  false) then
	  vehicle = GetVehiclePedIsIn(playerPed, false)
	else
	  vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 7.0, 0, 71 )
	end
  
	--print(vehicle)
  
	if vehicle == 0 then
		local coordA = GetEntityCoords(GetPlayerPed(-1), 1)
	  local coordB = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 20.0, 0.0)
	  local targetVehicle = getVehicleInDirection(coordA, coordB)
		  if targetVehicle ~= nil then
			vehicle = targetVehicle
		  end
	end
  
  
	ESX.TriggerServerCallback('esx_qalle:requestPlayerCars', function(isOwnedVehicle)
  
	
	  local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
	  print (vehicleProps.plate)
	  if isOwnedVehicle or (PlayerData.job.name == 'police' and vehicleProps.plate == 'POLIS' or PlayerData.job.name == 'mecano' and vehicleProps.plate == 'MEKONOM' or PlayerData.job.name == 'ambulance' and vehicleProps.plate == 'AMBULANS' or PlayerData.job.name == 'taxi' and vehicleProps.plate == 'TAXI' or PlayerData.job.name == 'bennys' and vehicleProps.plate == 'BENNYS' or PlayerData.job.name == 'Securitas' and vehicleProps.plate == 'SECURITAS') then
		  local locked = GetVehicleDoorLockStatus(vehicle)
		  local heading = GetEntityHeading(playerPed)
		  if locked == 1 then -- if unlocked
			SetVehicleDoorsLocked(vehicle, 2)
					PlayVehicleDoorCloseSound(vehicle, 1)
					local dict = "anim@mp_player_intmenu@key_fob@"
					local playerped = GetPlayerPed(PlayerId())
						RequestAnimDict(dict)
						while not HasAnimDictLoaded(dict) do
						  Citizen.Wait(0)
						end		  
						exports['mythic_notify']:SendAlert('error', 'Du har LÅST fordonet.')
						--ESX.ShowNotification('Du har ~r~låst~w~ ditt fordon')
					if not IsPedInAnyVehicle(PlayerPedId(), true) then
						TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
	
						Citizen.Wait(100)
						  SetVehicleLights(vehicle, 2)
						  Citizen.Wait(200)
						  SetVehicleLights(vehicle, 1)
						  Citizen.Wait(200)
						  SetVehicleLights(vehicle, 2)
						  Citizen.Wait(200)
						  SetVehicleLights(vehicle, 1)
						  Citizen.Wait(200)
						  SetVehicleLights(vehicle, 2)
						  Citizen.Wait(200)
						  SetVehicleLights(vehicle, 0)
					end	
		  elseif locked == 2 then -- if locked
			local dict = "anim@mp_player_intmenu@key_fob@"
					local playerped = GetPlayerPed(PlayerId())
						RequestAnimDict(dict)
						while not HasAnimDictLoaded(dict) do
						  Citizen.Wait(0)
						end	
			SetVehicleDoorsLocked(vehicle, 1)
			PlayVehicleDoorOpenSound(vehicle, 0)
			if not IsPedInAnyVehicle(PlayerPedId(), true) then
				TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
			end	
			exports['mythic_notify']:SendAlert('success', 'Du har LÅST UPP fordonet.')
			  --ESX.ShowNotification('Du har ~g~låst upp~w~ ditt fordon')
			if not IsPedInAnyVehicle(playerPed,  false) then
			  SetPedIntoVehicle(playerPed, vehicle, -1)
			  TaskLeaveVehicle(playerPed, vehicle, 16)
			  SetEntityCoords(playerPed, coords.x, coords.y, coords.z-0.99, 1, 0, 0, 1)
			  SetEntityHeading(playerPed, heading)
			  TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
	
			  Citizen.Wait(100)
			  SetVehicleLights(vehicle, 2)
			  Citizen.Wait(200)
			  SetVehicleLights(vehicle, 1)
			  Citizen.Wait(200)
			  SetVehicleLights(vehicle, 2)
			  Citizen.Wait(200)
			  SetVehicleLights(vehicle, 1)
			  Citizen.Wait(200)
			  SetVehicleLights(vehicle, 2)
			  Citizen.Wait(200)
			  SetVehicleLights(vehicle, 0)
			  
			end
		  end
		else
			--sendNotification('Du har inga NYCKLAR till denna bil', 'error', 3500)
			exports['mythic_notify']:SendAlert('error', 'Du har inga nycklar till fordonet.')
			--ESX.ShowNotification('~r~Du har inga nycklar till fordonet.')
			
		end
	  end, GetVehicleNumberPlateText(vehicle))
	end
  
  -- Key events
  Citizen.CreateThread(function()
	  while true do
		  Wait(0)
		  if IsControlPressed(0, Keys['F3']) then
			  openMenu()
			end
			if IsControlPressed(0, Keys['M']) then
				openVehicleMenu()
			end
	  end
  end)
  
  local disableShuffle = true
  function disableSeatShuffle(flag)
	  disableShuffle = flag
  end
  
  function getVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
  end
  
  function beltToggle()
	if IsPedInAnyVehicle(GetPlayerPed(-1), false) and GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1), false)) ~= 8 and GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1), false)) ~= 13 and GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1), false)) ~= 14 then
	  TriggerEvent('balte')
	end
	  
  end
  
  Citizen.CreateThread(function()
	  while true do
		  Citizen.Wait(0)
		  if IsPedInAnyVehicle(GetPlayerPed(-1), false) and disableShuffle then
			  if GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0) == GetPlayerPed(-1) then
				  if GetIsTaskActive(GetPlayerPed(-1), 165) then
					  SetPedIntoVehicle(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)
				  end
			  end
		  end
	  end
  end)
  
  Citizen.CreateThread(function()
	while true do
  
	Wait(500)
	if not IsPedInAnyVehicle(GetPlayerPed(-1),  false) then
	  DecorRegister("IsBelted",  3)
		DecorSetInt(GetPlayerPed(-1), "IsBelted", 0)
	  end
	end
  end)
  
  Citizen.CreateThread(function()
	  while true do
		  Citizen.Wait(750)
		  if IsPedInAnyVehicle(GetPlayerPed(-1),  false) and GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1), false)) ~= 8 and GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1), false)) ~= 13 and GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1), false)) ~= 14 and (GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1) == GetPlayerPed(-1)  or GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0) == GetPlayerPed(-1)) then
			if beltep1 == false or beltep2 == false or beltep3 == false or beltep4 == false then
			  balteswarning = not balteswarning
			else
			  balteswarning = false
			end
		  else
			balteswarning = false
		  end
	  end
  end)
  
  Citizen.CreateThread(function()
	  while true do
		  Citizen.Wait(0)
		  numSeats = GetVehicleModelNumberOfSeats(GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1), false)))
		if numSeats > 0 and not IsVehicleSeatFree(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1) and DecorGetInt(GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1),"IsBelted") ~= 1 then
		  beltep1 = false
		else
		  beltep1 = true
		end
		if numSeats > 1 and not IsVehicleSeatFree(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0) and DecorGetInt(GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0),"IsBelted") ~= 1 then
		  beltep2 = false
		else
		  beltep2 = true
		end
		if  numSeats > 2 and not IsVehicleSeatFree(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1) and DecorGetInt(GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1),"IsBelted") ~= 1 then
		  beltep3 = false
		else
		  beltep3 = true
		end
		if  numSeats > 3 and not IsVehicleSeatFree(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2) and DecorGetInt(GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2),"IsBelted") ~= 1 then
		  beltep4 = false
		else
		  beltep4 = true
		end
	  end
  end)
  
  RegisterNetEvent("SeatShuffle")
  AddEventHandler("SeatShuffle", function()
	  if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
		  disableSeatShuffle(false)
		  Citizen.Wait(5000)
		  disableSeatShuffle(true)
	  else
		  CancelEvent()
	  end
  end)
  
  RegisterCommand("shuff", function(source, args, raw) --change command here
	  TriggerEvent("SeatShuffle")
  end, false) --False, allow everyone to run it