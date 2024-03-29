ESX, QBCore = nil, nil

if EFn.Framework  == 'esx' then
    pcall(function() ESX = exports[EFn.Strings.esxName]:getSharedObject() end)
    if ESX == nil then
        TriggerEvent(EFn.Strings.esxMain, function(obj) ESX = obj end)
    end
    
elseif EFn.Framework == 'qbcore' then
    TriggerEvent(EFn.Strings.qbMain, function(obj) QBCore = obj end)
    if QBCore == nil then
        QBCore = exports[EFn.Strings.qbName]:GetCoreObject()
    end
    
elseif EFn.Framework  == 'standalone' then
	-- you can add your own custom framework here
end

if EFn.Framework == 'esx' then 
    UseableItemEvent = ESX.RegisterUsableItem
    GetUserData = ESX.GetPlayerFromId
    addItem = addInventoryItem
elseif EFn.Framework == 'qbcore' then 
    UseableItemEvent  = QBCore.Functions.CreateUseableItem
    GetUserData = QBCore.Functions.GetPlayer
    addItem = Functions.AddItem
end

UseableItemEvent('huntingknife', function(source)
    TriggerClientEvent('EFn-huntingknife',source)
end)

UseableItemEvent('huntingbait', function(source)
    TriggerClientEvent('EFn-huntingbait', source)
end)

RegisterServerEvent('EFn-butcheranimal')
AddEventHandler('EFn-butcheranimal', function(animal)
    local xPlayer = GetUserData(source)
    local boar = -832573324
    local deer = -664053099
    local coyote = 1682622302
    if animal == boar then
        xPlayer.addItem('boarmeat', EFn.BoarMeat)
        xPlayer.addItem('boartusk', EFn.BoarTusk)
    elseif animal == deer then
        xPlayer.addItem('deerskin', EFn.DeerSkin)
        xPlayer.addItem('deermeat', EFn.DeerMeat)
    elseif animal == coyote then
        xPlayer.addItem('coyotefur', EFn.CoyoteFur)
        xPlayer.addItem('coyotemeat', EFn.CoyoteMeat)
    else
        print('exploit detected')
        --add your ban event here for cheating
    end
end)

RegisterServerEvent('EFn-hunt:TakeItem')
AddEventHandler('EFn-hunt:TakeItem', function(item)
    if EFn.Framework = 'esx' then 
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem(item, 1)
    elseif EFn.Framework == 'qbcore' then
        local xPlayer = QBCore.Functions.GetPlayer(source)
        xPlayer.Functions.RemoveItem(item, 1)
    else 
        --do nothing
end)
