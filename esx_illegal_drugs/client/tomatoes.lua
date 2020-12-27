local spawnedtomatos = 0
local tomatoPlants = {}
local isPickingUp, isProcessing = false, false


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local coords = GetEntityCoords(PlayerPedId())

		if GetDistanceBetweenCoords(coords, Config.CircleZones.tomatoField.coords, true) < 50 then
			SpawntomatoPlants()
			Citizen.Wait(500)
		else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		if GetDistanceBetweenCoords(coords, Config.CircleZones.tomatoProcessing.coords, true) < 5 then
			if not isProcessing then
				ESX.ShowHelpNotification(_U('tomato_processprompt'))
			end

			if IsControlJustReleased(0, Keys['E']) and not isProcessing then

				if Config.LicenseEnable then
					ESX.TriggerServerCallback('esx_license:checkLicense', function(hasProcessingLicense)
						if hasProcessingLicense then
							Processtomato()
						else
							OpenBuyLicenseMenu('tomato_processing')
						end
					end, GetPlayerServerId(PlayerId()), 'tomato_processing')
				else
					Processtomato()
				end

			end
		else
			Citizen.Wait(500)
		end
	end
end)

function Processtomato()
	isProcessing = true

	ESX.ShowNotification(_U('tomato_processingstarted'))
	TriggerServerEvent('esx_illegal:processtomato')
	local timeLeft = Config.Delays.tomatoProcessing / 1000
	local playerPed = PlayerPedId()

	while timeLeft > 0 do
		Citizen.Wait(1000)
		timeLeft = timeLeft - 1

		if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.tomatoProcessing.coords, false) > 5 then
			ESX.ShowNotification(_U('tomato_processingtoofar'))
			TriggerServerEvent('esx_illegal:cancelProcessing')
			break
		end
	end

	isProcessing = false
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local nearbyObject, nearbyID

		for i=1, #tomatoPlants, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(tomatoPlants[i]), false) < 1 then
				nearbyObject, nearbyID = tomatoPlants[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then

			if not isPickingUp then
				ESX.ShowHelpNotification(_U('tomato_pickupprompt'))
			end

			if IsControlJustReleased(0, 38) and not isPickingUp then
				isPickingUp = true

				ESX.TriggerServerCallback('esx_legal:canPickUp', function(canPickUp)

					if canPickUp then
						TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)

						Citizen.Wait(2000)
						ClearPedTasks(playerPed)
						Citizen.Wait(1500)
		
						ESX.Game.DeleteObject(nearbyObject)
		
						table.remove(tomatoPlants, nearbyID)
						spawnedtomatos = spawnedtomatos - 1
		
						TriggerServerEvent('esx_illegal:pickedUptomato')
					else
						ESX.ShowNotification(_U('tomato_inventoryfull'))
					end

					isPickingUp = false

				end, 'maturedtomato')
			end

		else
			Citizen.Wait(500)
		end

	end

end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(tomatoPlants) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

function SpawntomatoPlants()
	while spawnedtomatos < 15 do
		Citizen.Wait(0)
		local tomatoCoords = GeneratetomatoCoords()

		ESX.Game.SpawnLocalObject('prop_sapling_break_01', tomatoCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(tomatoPlants, obj)
			spawnedtomatos = spawnedtomatos + 1
		end)
	end
end

function ValidatetomatoCoord(plantCoord)
	if spawnedtomatos > 0 then
		local validate = true

		for k, v in pairs(tomatoPlants) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.CircleZones.tomatoField.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GeneratetomatoCoords()
	while true do
		Citizen.Wait(1)

		local tomatoCoordX, tomatoCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-20, 20)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-20, 20)

		tomatoCoordX = Config.CircleZones.tomatoField.coords.x + modX
		tomatoCoordY = Config.CircleZones.tomatoField.coords.y + modY

		local coordZ = GetCoordZtomato(tomatoCoordX, tomatoCoordY)
		local coord = vector3(tomatoCoordX, tomatoCoordY, coordZ)

		if ValidatetomatoCoord(coord) then
			return coord
		end
	end
end

function GetCoordZtomato(x, y)
	local groundCheckHeights = { 50, 51.0, 52.0, 53.0, 54.0, 55.0, 56.0, 57.0, 58.0, 59.0, 60.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 53.85
end