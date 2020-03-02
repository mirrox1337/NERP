Config = {}

----------------------------------------------------
-------- Intervalles en secondes -------------------
----------------------------------------------------

-- Temps d'attente Antispam / Waiting time for antispam
Config.AntiSpamTimer = 15

-- Vérification et attribution d'une place libre / Verification and allocation of a free place
Config.TimerCheckPlaces = 3

-- Mise à jour du message (emojis) et accès à la place libérée pour l'heureux élu / Update of the message (emojis) and access to the free place for the lucky one
Config.TimerRefreshClient = 3

-- Mise à jour du nombre de points / Number of points updating
Config.TimerUpdatePoints = 6

----------------------------------------------------
------------ Nombres de points ---------------------
----------------------------------------------------

-- Nombre de points gagnés pour ceux qui attendent / Number of points earned for those who are waiting
Config.AddPoints = 1

-- Nombre de points perdus pour ceux qui sont entrés dans le serveur / Number of points lost for those who entered the server
Config.RemovePoints = 1

-- Nombre de points gagnés pour ceux qui ont 3 emojis identiques (loterie) / Number of points earned for those who have 3 identical emojis (lottery)
Config.LoterieBonusPoints = 25

-- Förtur i kön
Config.Points = {
	-- {'steamID', points},
	 {'steam:110000106425ae3', 5000}, --Owner
	 {'steam:1100001083996ad', 500}, --(SWE)Rasmus#2000
	 {'steam:110000105a80a45', 500}, --Krille#2261
	 {'steam:1100001058e30b9', 5000}, --Lindrozstaff
	 {'steam:110000104bbf3b3', 500}, --Samuelkarlsson#2481
	 {'steam:1100001076b8c75', 500}, --Brewwan
	 {'steam:11000010c57b036', 500}, --Jenny
	 {'steam:110000100025395', 500},  --naus#6973
	 {'steam:11000010a74de80', 5000},  --Kiwi^#2817staff
	 {'steam:11000010e0f3a91', 500},  --Not phoon#1843
	 {'steam:11000010040a1a5', 500},  --noffe#2335
	 {'steam:110000100000638', 500},  --KennyB#6693
	 {'steam:11000010ce4391a', 500},  --Sleepys#5474
	 {'steam:110000102b29738', 500},  --Tjhorven#9541
	 {'steam:1100001099861a2', 500},  --Sötnosen#8155
	 {'steam:110000101f0c1ae', 500},  --Demonen#3234
	 {'steam:11000010a3a1480', 500},  --Dosh#4739
	 {'steam:1100001037efb42', 500},  --Alextheralex#8970
	 {'steam:11000010a4b5f71', 500},  --revisorn7#3690
	 {'steam:110000105a84fc5', 500},  --MR#0497
	 {'steam:11000013cbd66d5', 500},  --SotarN#7273
	 {'steam:110000131e45f65', 001}  --Wajkie#8525
	 
}

----------------------------------------------------
------------- Textes des messages ------------------
----------------------------------------------------

-- Si steam n'est pas détecté / If steam is not detected
Config.NoSteam = "Steam kunde inte upptäckas, starta om Steam samt FiveM och försök igen."
-- Config.NoSteam = "Steam was not detected. Please (re)launch Steam and FiveM, and try again."

-- Message d'attente / Waiting text
Config.EnRoute = "Vänligen vänta på din tur i kön. Du har samlat "
-- Config.EnRoute = "You are on the road. You have already traveled"

-- "points" traduits en langage RP / "points" for RP purpose
Config.PointsRP = "Köpoäng"
-- Config.PointsRP = "kilometers"

-- Position dans la file / position in the queue
Config.Position = "Du är på plats "
-- Config.Position = "You are in position "

-- Texte avant les emojis / Text before emojis
Config.EmojiMsg = "Om siffrorna fryser, starta om FiveM: "
-- Config.EmojiMsg = "If the emojis are frozen, restart your client: "

-- Quand le type gagne à la loterie / When the player win the lottery
Config.EmojiBoost = "Wow!, " .. Config.LoterieBonusPoints .. " " .. Config.PointsRP .. " tjänat!"
-- Config.EmojiBoost = "!!! Yippee, " .. Config.LoterieBonusPoints .. " " .. Config.PointsRP .. " won !!!"

-- Anti-spam message / anti-spam text
Config.PleaseWait_1 = "Vänligen vänta "
Config.PleaseWait_2 = " sekunder. Anslutningen sker per automatik!"
-- Config.PleaseWait_1 = "Please wait "
-- Config.PleaseWait_2 = " seconds. The connection will start automatically!"

-- Me devrait jamais s'afficher / Should never be displayed
Config.Accident = "Ops, det hände en olycka.."
-- Config.Accident = "Oops, you just had an accident ... If it happens again, you can inform the support :)"

-- En cas de points négatifs / In case of negative points
Config.Error = " ERROR: Starta om kö-systemet. "
-- Config.Error = " ERROR : RESTART THE QUEUE SYSTEM AND CONTACT THE SUPPORT "


Config.EmojiList = {
	'1️⃣', 
	'2️⃣',
	'3️⃣', 
	'4️⃣', 
	'5️⃣',
	'6️⃣', 
	'7️⃣', 
	'8️⃣',
	'9️⃣',
	'🔟'
}
