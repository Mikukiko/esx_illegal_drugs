Config = {}

Config.Locale = 'de'
-- You may configer the prices differently for you Server
Config.Delays = {
	WeedProcessing = 1000 * 11,
	MethProcessing = 1000 * 15,
	CokeProcessing = 1000 * 14,
	lsdProcessing = 1000 * 15,
	HeroinProcessing = 1000 * 13,
	thionylchlorideProcessing = 1000 * 13,
	tomatoProcessing = 1000 * 10,
}

Config.DrugDealerItems = {
	heroin = 190,
	marijuana = 221,
	meth = 290,
	coke = 180,
	lsd = 250,
}

Config.DealerItems = {
	tomato = 130,
	maturedtomato = 150,
	wheat = 125,
}

Config.ChemicalsConvertionItems = {
	hydrochloric_acid = 0,
	sodium_hydroxide = 0,
	sulfuric_acid = 0,
	lsa = 0,
}

Config.ChemicalsLicenseEnabled = false --Will Enable or Disable the need for a Chemicals License.
Config.MoneyWashLicenseEnabled = false --Will Enable or Disable the need for a MoneyWash License.

Config.LicensePrices = {
	weed_processing = {label = _U('license_weed'), price = 15000}
}

Config.Licenses = {
	moneywash = 75000,
	chemicalslisence = 100000,
}

Config.GiveBlack = true -- give black money? if disabled it'll give regular cash.

Config.CircleZones = {
	--Weed
	WeedField = {coords = vector3(2224.64, 5577.03, 53.85), name = _U('blip_WeedFarm'), color = 25, sprite = 496, radius = 100.0},
	WeedProcessing = {coords = vector3(-49.59, 1893.12, 195), name = _U('blip_Cokeprocessing'),color = 25, sprite = 496, radius = 20.0}, 
	
	--meth
	MethProcessing = {coords = vector3(2433.27, 4968.71, 41.01), name = _U('blip_methprocessing'), color = 25, sprite = 496, radius = 0.0},
	HydrochloricAcidFarm = {coords = vector3(1117.6, 2352.52, 49), name = _U('blip_HydrochloricAcidFarm'), color = 25, sprite = 496, radius = 7.0},
	SulfuricAcidFarm = {coords = vector3(1123.95, -1998.62, 35.44), name = _U('blip_SulfuricAcidFarm'), color = 25, sprite = 496, radius = 5.0},
	SodiumHydroxideFarm = {coords = vector3(46.01, -2716.06, 6), name = _U('blip_SodiumHydroxideFarm'), color = 25, sprite = 496, radius = 7.0},
	
	--Chemicals
	ChemicalsField = {coords = vector3(135.08, -3080.28, 4.9), name = _U('blip_ChemicalsFarm'), color = 25, sprite = 496, radius = 0.0},
	ChemicalsConvertionMenu = {coords = vector3(2907.16, 4345.06, 50.3), name = _U('blip_ChemicalsProcessing'), color = 25, sprite = 496, radius = 0.0},
	
	--Coke
	CokeField = {coords = vector3(351.39, 6517.09, 27.20), name = _U('blip_CokeFarm'), color = 25, sprite = 496, radius = 20.0},
	CokeProcessing = {coords = vector3(934.37, -1517.46, 31.02), name = _U('blip_weedprocessing'), color = 25, sprite = 496, radius = 100.0},
	
	--LSD
	lsdProcessing = {coords = vector3(1335.66, 4307.98, 37.09), name = _U('blip_lsdprocessing'),color = 25, sprite = 496, radius = 20.0},
	thionylchlorideProcessing = {coords = vector3(2370.83, 4944.29, 42), name = _U('blip_lsdprocessing'),color = 25, sprite = 496, radius = 20.0},
	
	--Heroin
	HeroinField = {coords = vector3(-2673.52, 2386.1, 7), name = _U('blip_heroinfield'), color = 25, sprite = 496, radius = 20},
	HeroinProcessing = {coords = vector3(-155.35, 6141.05, 32), name = _U('blip_heroinprocessing'), color = 25, sprite = 496, radius = 100.0},
	
	--Tomato
	tomatoField = {coords = vector3(2541.17, 4802.01, 33.41), name = _U('blip_tomatoField'), color = 25, sprite = 496, radius = 20},
	tomatoProcessing = {coords = vector3(1705.67, 4732.57, 42.15), name = _U('blip_tomatoProcessing'), color = 25, sprite = 496, radius = 100.0},
	
	--wheat
	wheatField = {coords = vector3(2299.03, 5129.47, 50.78), name = _U('blip_tomatoField'), color = 25, sprite = 496, radius = 20},
	wheatProcessing = {coords = vector3(916.01, 3567.4, 33.79), name = _U('blip_tomatoProcessing'), color = 25, sprite = 496, radius = 100.0},

	--DrugDealer
	DrugDealer = {coords = vector3(-1172.02, -1571.98, 4.66), name = _U('blip_drugdealer'), color = 6, sprite = 378, radius = 25.0},
	
	--greengrocer
	GreenGrocer = {coords = vector3(161.27, 6635.48, 31.59), name = _U('blip_drugdealer'), color = 6, sprite = 378, radius = 25.0},
	
	--License
	LicenseShop = {coords = vector3(707.17, -962.5, 30.4), name = _U('blip_lsdprocessing'),color = 25, sprite = 496, radius = 20.0},
	
	--MoneyWash
	MoneyWash = {coords = vector3(247.72, -3316.25, 5.79-0.98), name = _U('blip_drugdealer'), color = 6, sprite = 378, radius = 25.0},
}

Config.Blip = {
	--DrugDealer
	DrugDealer = {coords = vector3(-1172.02, -1571.98, 4.66), name = _U('blip_drugdealer'), color = 6, sprite = 403, radius = 25.0},
	
	--MoneyWash
	MoneyWash = {coords = vector3(247.72, -3316.25, 5.79-0.98), name = 'Geldwäsche', color = 6, sprite = 500, radius = 25.0},
	
	--GreenGrocer
	GreenGrocer = {coords = vector3(161.27, 6635.48, 31.59), name = 'Gemüsehändler', color = 11, sprite = 431, radius = 25.0},
	
	--Tomato
	tomatoField = {coords = vector3(2541.17, 4802.01, 33.41), name = 'Tomatenfeld', color = 11, sprite = 478, radius = 25.0},
	tomatoProcessing = {coords = vector3(1705.67, 4732.57, 42.15), name = 'Tomatenreifer', color = 11, sprite = 478, radius = 25.0},
}



-- Copyright SkyH4Xx
--https://github.com/SkyH4Xx