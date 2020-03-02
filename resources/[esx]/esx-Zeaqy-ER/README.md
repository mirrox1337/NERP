[esx-Zeaqy-ER]

[NOTES]

This is my first release, i made this just for fun and never had any use for it so i chose to release it.
DM me if there are any problems! :D
Discord: Zeaqy#1337
Thanks to gamz#8579 for adding a cam feature and some more stuff!

[What does it do]
This script allows you to go to the pillbox hospital and pay to get healed/revived, it will only work if there are no medic online.

[REQUIREMENTS]
  
esx_society

esx_ambulancejob

[INSTALLATION]

Step 1: Download the script.

Step 2: Put it in your resource folder.

Step 3: Add to esx_society/server/main.lua
```
RegisterServerEvent('esx_society:addMoney')
AddEventHandler('esx_society:addMoney', function(society, amount)
	
	local xPlayer = ESX.GetPlayerFromId(source)
	local society = GetSociety(society)
	
	if amount > 0 and xPlayer.get('money') >= amount then

		TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
			account.addMoney(amount)
		end)
	end
end)
```
Step 4: Add "start esx-Zeaqy-ER" to your server.cfg!
