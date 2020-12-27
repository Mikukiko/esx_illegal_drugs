local playersProcessingPoppyResin = {}

RegisterServerEvent('esx_illegal:pickedUpPoppy')
AddEventHandler('esx_illegal:pickedUpPoppy', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('poppyresin')

	if (xPlayer.getWeight() + xItem.weight) > xPlayer.getMaxWeight() then
		TriggerClientEvent('esx:showNotification', source, _U('poppy_inventoryfull'))
	else
		xPlayer.addInventoryItem(xItem.name, 1)
	end
end)

RegisterServerEvent('esx_illegal:processPoppyResin')
AddEventHandler('esx_illegal:processPoppyResin', function()
	if not playersProcessingPoppyResin[source] then
		local _source = source

		playersProcessingPoppyResin[_source] = ESX.SetTimeout(Config.Delays.HeroinProcessing, function()
			local xPlayer = ESX.GetPlayerFromId(_source)
			local xPoppyResin, xHeroin = xPlayer.getInventoryItem('poppyresin'), xPlayer.getInventoryItem('heroin')
			local co = false
			
			TriggerEvent('esx_illegal:cops', function(copsonline)
				co = copsonline
			end)
			if (xPlayer.getWeight() + xHeroin.weight) > xPlayer.getMaxWeight() then
				TriggerClientEvent('esx:showNotification', _source, _U('heroin_processingfull'))
			elseif xPoppyResin.count < 1 then
				TriggerClientEvent('esx:showNotification', _source, _U('heroin_processingenough'))
			elseif co == false then
				TriggerClientEvent('esx:showNotification', _source, 'Es sind nicht genügend Polizisten im Dienst!')
			else
				xPlayer.removeInventoryItem('poppyresin', 2)
				xPlayer.addInventoryItem('heroin', 1)

				TriggerClientEvent('esx:showNotification', _source, _U('heroin_processed'))
			end

			playersProcessingPoppyResin[_source] = nil
		end)
	else
		print(('esx_illegal: %s attempted to exploit heroin processing!'):format(GetPlayerIdentifiers(source)[1]))
	end
end)

function CancelProcessing(playerID)
	if playersProcessingPoppyResin[playerID] then
		ESX.ClearTimeout(playersProcessingPoppyResin[playerID])
		playersProcessingPoppyResin[playerID] = nil
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
