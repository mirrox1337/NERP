Config = {}

Config.Locale = 'sv'

Config.Delays = {
	WeedProcessing = 1000 * 10
}

Config.DrugDealerItems = {
	weed_pooch = 150
}

Config.LicenseEnable = false -- enable processing licenses? The player will be required to buy a license in order to process drugs. Requires esx_license

Config.LicensePrices = {
	weed_processing = {label = _U('license_weed'), price = 15000}
}

Config.GiveBlack = true -- give black money? if disabled it'll give regular cash.

Config.CircleZones = {
	WeedField = {coords = vector3(-2453.77, 2675.02, 2.83), name = _U('blip_weedfield'), color = 25, sprite = 496, radius = 100.0},
	WeedProcessing = {coords = vector3(-1173.22, -471.13, 60.06), name = _U('blip_weedprocessing'), color = 25, sprite = 496, radius = 100.0},
	DrugDealer = {coords = vector3(-947.54, -1315.23, 13.51), name = _U('blip_drugdealer'), color = 6, sprite = 378, radius = 100.0},
}