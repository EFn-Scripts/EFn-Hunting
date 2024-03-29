local ESX, QBCore, baitexists, baitLocation, HuntedAnimalTable, busy = nil, nil, 0, nil, {}, false

CreateThread(function()
    if EFn.Framework == 'esx' then
        while ESX == nil do
            pcall(function() ESX = exports[EFn.Strings.esxName]:getSharedObject() end)
            if ESX == nil then
                TriggerEvent(EFn.Strings.esxMain, function(obj) ESX = obj end)
            end
            Wait(100)
        end
    elseif EFn.Framework == 'qbcore' then
        while QBCore == nil do
            TriggerEvent(EFn.Strings.qbMain, function(obj) QBCore = obj end)
            if QBCore == nil then
                QBCore = exports[EFn.Strings.qbName]:GetCoreObject()
            end
            Wait(100)
        end
    elseif EFn.Framework == 'standalone' then

    end
end)

isValidZone =  function()
    local zoneInH = GetNameOfZone(GetEntityCoords(PlayerPedId()))
    for k, v in pairs(EFn.HuntingZones) do
        if zoneInH == v or EFn.HuntAnyWhere == true then
            return true
        end
    end
end

SetSpawn = function(baitLocation)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local spawnCoords = nil
    while spawnCoords == nil do
        local spawnX = math.random(-EFn.SpawnDistanceRadius, EFn.SpawnDistanceRadius)
        local spawnY = math.random(-EFn.SpawnDistanceRadius, EFn.SpawnDistanceRadius)
        local spawnZ = baitLocation.z
        local vec = vector3(baitLocation.x + spawnX, baitLocation.y + spawnY, spawnZ)
        if #(playerCoords - vec) > EFn.SpawnDistanceRadius then
            spawnCoords = vec
        end
    end
    local worked, groundZ, normal = GetGroundZAndNormalFor_3dCoord(spawnCoords.x, spawnCoords.y, 1023.9)
    spawnCoords = vector3(spawnCoords.x, spawnCoords.y, groundZ)
    return spawnCoords
end

baitDown = function(baitLocation)
    CreateThread(function()
        while baitLocation ~= nil do
            local coords = GetEntityCoords(PlayerPedId())
            if #(baitLocation - coords) > EFn.DistanceFromBait then
                if math.random() < EFn.SpawnChance then
                    SpawnAnimal(baitLocation)
                    baitLocation = nil
                end
            end
            Wait(15000)
        end
    end)
end

SpawnAnimal = function(location)
    local spawn = SetSpawn(location)
    local model = GetHashKey(EFn.HuntAnimals[math.random(1,#EFn.HuntAnimals)])
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(10) end
    local prey = CreatePed(28, model, spawn, true, true, true)
    TaskGoToCoordAnyMeans(prey, location, 1.0, 0, 0, 786603, 1.0)
    table.insert(HuntedAnimalTable, {id = prey, animal = model})
    SetModelAsNoLongerNeeded(model)
    if EFn.UseBlip then
        local blip = AddBlipForEntity(prey)
		     SetBlipDisplay(blip, 2)
		     SetBlipScale  (blip, 0.85)
		     SetBlipColour (blip, 2)
		     SetBlipAsShortRange(blip, false)
		     BeginTextCommandSetBlipName("STRING")
		     AddTextComponentString(EFn.BlipText)
		     EndTextCommandSetBlipName(blip)
    		end
    CreateThread(function()
        local destination = false
        while not IsPedDeadOrDying(prey) and not destination do
            local preyCoords = GetEntityCoords(prey)
            local distance = #(location - preyCoords)
            local guy = PlayerPedId()
            if distance < 0.35 then
                ClearPedTasks(prey)
                Wait(1500)
                TaskStartScenarioInPlace(prey, 'WORLD_DEER_GRAZING', 0, true)
                SetTimeout(8000, function()
                    destination = true
                end)
            end
            if #(preyCoords - GetEntityCoords(guy)) < EFn.DistanceTooCloseToAnimal then
                ClearPedTasks(prey)
                TaskSmartFleePed(prey, guy,600.0, -1, true, true)
                destination = true
            end
            Wait(1000)
        end
        if not IsPedDeadOrDying(prey) then
            TaskSmartFleePed(prey, guy,600.0, -1, true, true)
        end
    end)
end

RegisterNetEvent('EFn-huntingbait')
AddEventHandler('EFn-huntingbait', function()
    if not isValidZone() then
        Notify(EFn.Strings.NotValidZone)
        return
    end
    if busy then
        Notify(EFn.Strings.ExploitDetected)
        Wait(2000)
        Notify(EFn.Strings.DontSpawm)
        TriggerServerEvent('EFn-hunt:TakeItem', 'huntingbait')
        return
    end
    if baitexists ~= 0 and GetGameTimer() < (baitexists + 90000) then
        Notify(EFn.Strings.WaitToBait)
        return
    end
    baitexists = nil
    busy = true
    local player = PlayerPedId()
    TaskStartScenarioInPlace(player, 'WORLD_HUMAN_GARDENER_PLANT', 0, true)
    exports['progressBars']:startUI((15000), EFn.Strings.PlacingBait)
    Citizen.Wait(15000)
    ClearPedTasks(player)
    baitexists = GetGameTimer()
    local baitLocation = GetEntityCoords(player)
    Notify(EFn.Strings.BaitPlaced)
    TriggerServerEvent('EFn-hunt:TakeItem', 'huntingbait')
    baitDown(baitLocation)
    SpawnBaitItem(baitLocation)
    busy = false
end)

RegisterNetEvent('EFn-huntingknife')
AddEventHandler('EFn-huntingknife', function()
    CreateThread(function()
        Wait(1000)
        for index, value in ipairs(HuntedAnimalTable) do
            local person = PlayerPedId()
            local AnimalCoords = GetEntityCoords(value.id)
            local PlyCoords = GetEntityCoords(person)
            local AnimalHealth = GetEntityHealth(value.id)
            local PlyToAnimal = #(PlyCoords - AnimalCoords)
            local gun = EFn.HuntingWeapon
            local d = GetPedCauseOfDeath(value.id)
            if DoesEntityExist(value.id) and AnimalHealth <= 0 and PlyToAnimal < 2.0 and (gun == d or gun == nil) and not busy then
                busy = true
                LoadAnimDict('amb@medic@standing@kneel@base')
                LoadAnimDict('anim@gangops@facility@servers@bodysearch@')
                TaskTurnPedToFaceEntity(person, value.id, -1)
                Wait(1500)
                ClearPedTasksImmediately(person)
                TaskPlayAnim(person, 'amb@medic@standing@kneel@base' ,'base' ,8.0, -8.0, -1, 1, 0, false, false, false )
                TaskPlayAnim(person, 'anim@gangops@facility@servers@bodysearch@' ,'player_search' ,8.0, -8.0, -1, 48, 0, false, false, false )
                exports['progressBars']:startUI((5000), EFn.Strings.Harvest)
                ClearPedTasks(person)
                Notify(EFn.Strings.Butchered)
                DeleteEntity(value.id)
                TriggerServerEvent('EFn-butcheranimal', value.animal)
                busy = false
                table.remove(HuntedAnimalTable, index)
                DeleteBaitItem()
            elseif busy then
                Notify(EFn.Strings.ExploitDetected)
            elseif gun ~= d and AnimalHealth <= 0 and PlyToAnimal < 2.0 then
                Notify(EFn.Strings.Roadkill)
                DeleteEntity(value.id)
                table.remove(HuntedAnimalTable, index)
                DeleteBaitItem()
            elseif PlyToAnimal > 3.0 then
                Notify(EFn.Strings.NoAnimal)
            elseif AnimalHealth > 0 then
                Notify(EFn.Strings.NotDead)
            elseif not DoesEntityExist(value.id) and PlyToAnimal < 2.0 then
                Notify(EFn.Strings.NotYours)
            else
                Notify(EFn.Strings.WTF)
            end
        end
    end)
end)

SpawnBaitItem = function(result)
    local model = `prop_drug_package_02`
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(10) end
    local bait = CreateObject(model, result.x , result.y , result.z- 1.0, true, true, true)
    SetModelAsNoLongerNeeded(model)
    FreezeEntityPosition(bait, true)
end

DeleteBaitItem = function()
    local player = PlayerPedId()
    local location = GetEntityCoords(player)
    local bait = GetClosestObjectOfType(location, 5.0, `prop_drug_package_02`, false, false, false)
    local baitloc = GetEntityCoords(bait)
        if DoesEntityExist(bait) and #(location - baitloc) < 3 then
            DeleteEntity(bait)
        else
            print('no bait object found nearby?')
        end
    end


LoadAnimDict = function(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(10)
    end
end

Notify = function(text)
    --SetNotificationTextEntry('STRING') -- Standalone notification
    --AddTextComponentString(text) -- Standalone notification
    --DrawNotification(0,1) -- Standalone notification
    --ESX.ShowNotification(text) -- ESX Notification
    QBCore.Functions.Notify(text, "success") -- QB Notify
    -- add your own and hash off others.
end

