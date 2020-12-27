RegisterServerEvent('esx_illegal:Wash')
AddEventHandler('esx_illegal:Wash', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local ammount = xPlayer.getAccount('black_money').money
	local co = false
	TriggerEvent('esx_illegal:cops', function(copsonline)
		co = copsonline
	end)
	
	if co == false then
		TriggerClientEvent('esx:showNotification', source, 'Es sind nicht genügend Polizisten im Dienst!')
		return
	end
	
	if xPlayer.job.name == 'police' or xPlayer.job.name == 'ambulance' then
		TriggerClientEvent('esx:showNotification', source, 'Als Polizist oder Medic im Dienst darfst du kein Geld waschen!')
		return
	end

	xPlayer.removeAccountMoney('black_money', ammount)

	xPlayer.addMoney(ammount - ammount * 0.15)

	TriggerClientEvent('esx:showNotification', source, _U('moneywash_washed', ammount))
end)

ESX.RegisterServerCallback('esx_illegal:GetBlackmoney', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local ammount = xPlayer.getAccount('black_money').money
	
	cb(ammount)
end)

ESX.RegisterServerCallback('esx_illegal:CheckMoneyWashLicense', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xMoneyWash = xPlayer.getInventoryItem('moneywash')

	if xMoneyWash.count == 1 then
		cb(true)
	else
		cb(false)
	end
end)