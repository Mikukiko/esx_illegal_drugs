local playersProcessingwheat = {}

RegisterServerEvent('esx_illegal:pickedUpwheat')
AddEventHandler('esx_illegal:pickedUpwheat', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('wheat')

	if (xPlayer.getWeight() + xItem.weight) > xPlayer.getMaxWeight() then
		TriggerClientEvent('esx:showNotification', source, _U('wheat_inventoryfull'))
	else
		xPlayer.addInventoryItem(xItem.name, 1)
	end
end)

RegisterServerEvent('esx_illegal:processwheat')
AddEventHandler('esx_illegal:processwheat', function()
	if not playersProcessingwheat[source] then
		local _source = source

		playersProcessingwheat[_source] = ESX.SetTimeout(Config.Delays.wheatProcessing, function()
			local xPlayer = ESX.GetPlayerFromId(_source)
			local xwheat, xflour = xPlayer.getInventoryItem('wheat'), xPlayer.getInventoryItem('flour')
			if (xPlayer.getWeight() + xflour.weight) > xPlayer.getMaxWeight() then
				TriggerClientEvent('esx:showNotification', _source, _U('wheat_processingfull'))
			elseif xwheat.count < 2 then
				TriggerClientEvent('esx:showNotification', _source, _U('wheat_processingenough'))
			else
				xPlayer.removeInventoryItem('wheat', 2)
				xPlayer.addInventoryItem('flour', 1)

				TriggerClientEvent('esx:showNotification', _source, _U('wheat_processed'))
			end

			playersProcessingwheat[_source] = nil
		end)
	else
		print(('esx_illegal: %s attempted to exploit wheat processing!'):format(GetPlayerIdentifiers(source)[1]))
	end
end)

function CancelProcessing(playerID)
	if playersProcessingwheat[playerID] then
		ESX.ClearTimeout(playersProcessingwheat[playerID])
		playersProcessingwheat[playerID] = nil
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
