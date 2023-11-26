ESX = exports["es_extended"]:getSharedObject()
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    else 
        MySQL.Async.execute('DELETE FROM giftsreceived;', function() end)
    end
end)

RegisterNetEvent('tizid:checkgift')
AddEventHandler("tizid:checkgift", function(playerID, input)
    local _source = source  
    local xPlayer = ESX.GetPlayerFromId(_source)

    MySQL.Async.execute('INSERT INTO giftsreceived (id, received) VALUES (@id, @received)', -- (id, oldname, newname, type, dob) -- (@id, @oldname, @newname, @type, @)
    {
        ['id']   = xPlayer.identifier,
        ['received']   = 'yes'
    }, function ()
    end)
end)
RegisterNetEvent('tizid:paymentas')
AddEventHandler("tizid:paymentas", function()
    local playerId = source
    exports.ox_inventory:AddItem(playerId, Config.RewardBox, 1)
end)
lib.callback.register('tizid:checkreceived', function()
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local identifier = xPlayer.identifier 
	local hasLicense = MySQL.prepare.await('SELECT `received` FROM `giftsreceived` WHERE `id` = ?', {
        identifier
    })
	if hasLicense == 'yes' then
        return false
    else 
        return true
    end
end)

ESX.RegisterUsableItem('giftbox', function(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    exports.ox_inventory:AddItem(playerId, Config.Rewards.reward1, Config.RewardQuantity.reward1q)
    exports.ox_inventory:AddItem(playerId, Config.Rewards.reward2, Config.RewardQuantity.reward2q)
    exports.ox_inventory:AddItem(playerId, Config.Rewards.reward3, Config.RewardQuantity.reward3q)
    xPlayer.removeInventoryItem('giftbox', 1)
end)