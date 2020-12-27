local playersProcessingtomato = {}

RegisterServerEvent('esx_illegal:pickedUptomato')
AddEventHandler('esx_illegal:pickedUptomato', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('tomato')

	if (xPlayer.getWeight() + xItem.weight) > xPlayer.getMaxWeight() then
		TriggerClientEvent('esx:showNotification', source, _U('tomato_inventoryfull'))
	else
		xPlayer.addInventoryItem(xItem.name, 1)
	end
end)

RegisterServerEvent('esx_illegal:processtomato')
AddEventHandler('esx_illegal:processtomato', function()
	if not playersProcessingtomato[source] then
		local _source = source

		playersProcessingtomato[_source] = ESX.SetTimeout(Config.Delays.tomatoProcessing, function()
			local xPlayer = ESX.GetPlayerFromId(_source)
			local xtomato, xmaturedtomato = xPlayer.getInventoryItem('tomato'), xPlayer.getInventoryItem('maturedtomato')
			if (xPlayer.getWeight() + xmaturedtomato.weight) > xPlayer.getMaxWeight() then
				TriggerClientEvent('esx:showNotification', _source, _U('tomato_processingfull'))
			elseif xtomato.count < 1 then
				TriggerClientEvent('esx:showNotification', _source, _U('tomato_processingenough'))
			else
				xPlayer.removeInventoryItem('tomato', 1)
				xPlayer.addInventoryItem('maturedtomato', 1)

				TriggerClientEvent('esx:showNotification', _source, _U('tomato_processed'))
			end

			playersProcessingtomato[_source] = nil
		end)
	else
		print(('esx_illegal: %s attempted to exploit tomato processing!'):format(GetPlayerIdentifiers(source)[1]))
	end
end)

function CancelProcessing(playerID)
	if playersProcessingtomato[playerID] then
		ESX.ClearTimeout(playersProcessingtomato[playerID])
		playersProcessingtomato[playerID] = nil
	end
end

RegisterServerEvent('esx_illegal:cancelProcessing')
AddEventHandler('esx_illegal:cancelProcessing', function()
	CancelProcessing(source)
end)

AddEventHandler('esx:playerDropped', function(playerID, reason)
	CancelProcessing(playerID)
end)

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
	CancelProcessing(source)
end)
