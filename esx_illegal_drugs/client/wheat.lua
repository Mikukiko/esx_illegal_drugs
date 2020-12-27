local spawnedwheats = 0
local wheatPlants = {}
local isPickingUp, isProcessing = false, false


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local coords = GetEntityCoords(PlayerPedId())

		if GetDistanceBetweenCoords(coords, Config.CircleZones.wheatField.coords, true) < 50 then
			SpawnwheatPlants()
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

		if GetDistanceBetweenCoords(coords, Config.CircleZones.wheatProcessing.coords, true) < 5 then
			if not isProcessing then
				ESX.ShowHelpNotification(_U('wheat_processprompt'))
			end

			if IsControlJustReleased(0, Keys['E']) and not isProcessing then

				if Config.LicenseEnable then
					ESX.TriggerServerCallback('esx_license:checkLicense', function(hasProcessingLicense)
						if hasProcessingLicense then
							Processwheat()
						else
							OpenBuyLicenseMenu('wheat_processing')
						end
					end, GetPlayerServerId(PlayerId()), 'wheat_processing')
				else
					Processwheat()
				end

			end
		else
			Citizen.Wait(500)
		end
	end
end)

function Processwheat()
	isProcessing = true

	ESX.ShowNotification(_U('wheat_processingstarted'))
	TriggerServerEvent('esx_illegal:processwheat')
	local timeLeft = Config.Delays.wheatProcessing / 1000
	local playerPed = PlayerPedId()

	while timeLeft > 0 do
		Citizen.Wait(1000)
		timeLeft = timeLeft - 1

		if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.wheatProcessing.coords, false) > 5 then
			ESX.ShowNotification(_U('wheat_processingtoofar'))
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

		for i=1, #wheatPlants, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(wheatPlants[i]), false) < 1 then
				nearbyObject, nearbyID = wheatPlants[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then

			if not isPickingUp then
				ESX.ShowHelpNotification(_U('wheat_pickupprompt'))
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
		
						table.remove(wheatPlants, nearbyID)
						spawnedwheats = spawnedwheats - 1
		
						TriggerServerEvent('esx_illegal:pickedUpwheat')
					else
						ESX.ShowNotification(_U('wheat_inventoryfull'))
					end

					isPickingUp = false

				end, 'flour')
			end

		else
			Citizen.Wait(500)
		end

	end

end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(wheatPlants) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

function SpawnwheatPlants()
	while spawnedwheats < 15 do
		Citizen.Wait(0)
		local wheatCoords = GeneratewheatCoords()

		ESX.Game.SpawnLocalObject('prop_sapling_break_02', wheatCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(wheatPlants, obj)
			spawnedwheats = spawnedwheats + 1
		end)
	end
end

function ValidatewheatCoord(plantCoord)
	if spawnedwheats > 0 then
		local validate = true

		for k, v in pairs(wheatPlants) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.CircleZones.wheatField.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GeneratewheatCoords()
	while true do
		Citizen.Wait(1)

		local wheatCoordX, wheatCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-20, 20)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-20, 20)

		wheatCoordX = Config.CircleZones.wheatField.coords.x + modX
		wheatCoordY = Config.CircleZones.wheatField.coords.y + modY

		local coordZ = GetCoordZwheat(wheatCoordX, wheatCoordY)
		local coord = vector3(wheatCoordX, wheatCoordY, coordZ)

		if ValidatewheatCoord(coord) then
			return coord
		end
	end
end

function GetCoordZwheat(x, y)
	local groundCheckHeights = { 50, 51.0, 52.0, 53.0, 54.0, 55.0, 56.0, 57.0, 58.0, 59.0, 60.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 53.85
end