ESX = nil
local CopsOnline = 0

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_illegal:sellDrug')
AddEventHandler('esx_illegal:sellDrug', function(itemName, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = Config.DrugDealerItems[itemName]
	local xItem = xPlayer.getInventoryItem(itemName)

	if not price then
		print(('esx_illegal: %s attempted to sell an invalid drug!'):format(xPlayer.identifier))
		return
	end

	if xItem.count < amount then
		TriggerClientEvent('esx:showNotification', source, _U('dealer_notenough'))
		return
	end
	
	a()
	
	if CopsOnline == 0 then
		TriggerClientEvent('esx:showNotification', source, 'Es sind nicht genügend Polizisten im Dienst!')
		return
	end

	price = ESX.Math.Round(price * amount)

	if Config.GiveBlack then
		xPlayer.addAccountMoney('black_money', price)
	else
		xPlayer.addMoney(price)
	end

	xPlayer.removeInventoryItem(xItem.name, amount)

	TriggerClientEvent('esx:showNotification', source, _U('dealer_sold', amount, xItem.label, ESX.Math.GroupDigits(price)))
end)

RegisterServerEvent('esx_illegal:sellItem')
AddEventHandler('esx_illegal:sellItem', function(itemName, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = Config.DealerItems[itemName]
	local xItem = xPlayer.getInventoryItem(itemName)

	if not price then
		print(('esx_illegal: %s attempted to sell an invalid item!'):format(xPlayer.identifier))
		return
	end

	if xItem.count < amount then
		TriggerClientEvent('esx:showNotification', source, _U('dealer_notenough'))
		return
	end

	price = ESX.Math.Round(price * amount)

	xPlayer.addMoney(price)

	xPlayer.removeInventoryItem(xItem.name, amount)

	TriggerClientEvent('esx:showNotification', source, _U('dealer_sold', amount, xItem.label, ESX.Math.GroupDigits(price)))
end)

ESX.RegisterServerCallback('esx_illegal:buyLicense', function(source, cb, licenseName)
	local xPlayer = ESX.GetPlayerFromId(source)
	local license = Config.LicensePrices[licenseName]

	if license == nil then
		print(('esx_illegal: %s attempted to buy an invalid license!'):format(xPlayer.identifier))
		cb(false)
	end

	if xPlayer.getMoney() >= license.price then
		xPlayer.removeMoney(license.price)

		TriggerEvent('esx_license:addLicense', source, licenseName, function()
			cb(true)
		end)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_illegal:canPickUp', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem(item)
	a()
	if xPlayer.getWeight() > xPlayer.getMaxWeight() then
		cb(false)
	else
		if CopsOnline >= 1 then
			cb(true)
		else
			cb(false)
		end
	end
end)

ESX.RegisterServerCallback('esx_legal:canPickUp', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem(item)
	if xPlayer.getWeight() > xPlayer.getMaxWeight() then
		cb(false)
	else
		cb(true)
	end
end)

RegisterServerEvent('esx_illegal:cops')
AddEventHandler('esx_illegal:cops', function(cb)
	a()
	if CopsOnline >= 1 then
		cb(true)
	else
		cb(false)
	end
end)

function a()
	local xPlayers = ESX.GetPlayers()
	CopsOnline = 0
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			CopsOnline = CopsOnline + 1
		end
	end
end



--Copyright SkyH4Xx @https://github.com/SkyH4Xx