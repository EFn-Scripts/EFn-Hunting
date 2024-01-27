local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateUseableItem('huntingknife', function(source)
    TriggerClientEvent('EFn-huntingknife',source)
end)

QBCore.Functions.CreateUseableItem('huntingbait', function(source)
    TriggerClientEvent('EFn-huntingbait', source)
end)

RegisterServerEvent('EFn-butcheranimal')
AddEventHandler('EFn-butcheranimal', function(animal)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    local boar = -832573324
    local deer = -664053099
    local coyote = 1682622302
    if animal == boar then
        xPlayer.Functions.AddItem('boarmeat', EFn.BoarMeat)
        xPlayer.Functions.AddItem('boartusk', EFn.BoarTusk)
    elseif animal == deer then
        xPlayer.Functions.AddItem('deerskin', EFn.DeerSkin)
        xPlayer.Functions.AddItem('deermeat', EFn.DeerMeat)
    elseif animal == coyote then
        xPlayer.Functions.AddItem('coyotefur', EFn.CoyoteFur)
        xPlayer.Functions.AddItem('coyotemeat', EFn.CoyoteMeat)
    else
        print('exploit detected')
        --add your ban event here for cheating
    end
end)

RegisterServerEvent('EFn-hunt:TakeItem')
AddEventHandler('EFn-hunt:TakeItem', function(item)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    xPlayer.Functions.RemoveItem(item, 1)
end)
