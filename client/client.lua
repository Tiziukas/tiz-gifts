ESX = exports["es_extended"]:getSharedObject()
local menuOpen = false
AddEventHandler('onClientResourceStart', function (resourceName)
    if(GetCurrentResourceName() ~= resourceName) then
        return
    else
        CreatePedInteractions()
    end
end)
CreateThread(function()
    for k,v in pairs (Config.Props) do
        RequestModel(v.model)
        local iter_for_request = 1
        while not HasModelLoaded(v.model) and iter_for_request < 5 do
            Wait(500)                
            iter_for_request = iter_for_request + 1
        end
        if not HasModelLoaded(v.model) then
            SetModelAsNoLongerNeeded(v.model)
        else
            local ped = PlayerPedId()
            local created_object = CreateObjectNoOffset(v.model, v.coords.x, v.coords.y, v.coords.z - 1, 1, 0, 1)
            PlaceObjectOnGroundProperly(created_object)
            SetEntityHeading(created_object, v.coords.w)
            FreezeEntityPosition(created_object, true)
            SetModelAsNoLongerNeeded(v.model)
        end
    end
end)
RegisterNetEvent('tizid:openmenuu')
AddEventHandler("tizid:openmenuu", function()
    menuOpen = true
    -- Registers the menu
    lib.registerContext({
        id = 'GiftMenu',
        title = Config.Language.menutitle,
        onExit = toggleMenu(),
        options = {
            {
                title = Config.Language.notifytitle,
                description = Config.Language.receivepresent,
                icon = 'fas fa-gift',
                onSelect = function()
                    DoApplication()
                end,
            }
        }
    }) 

    lib.showContext('GiftMenu')   
end)

function DoApplication()
    hasReceived = lib.callback('tizid:checkreceived', false)
    if hasReceived then
        local playerID = source
        lib.notify({
            title = Config.Language.notifytitle,
            description = Config.Language.receivedpresent,
            type = 'success'
        })
        TriggerServerEvent("tizid:paymentas", playerID)
        TriggerServerEvent("tizid:checkgift", playerID)
    else
        lib.notify({
            title = Config.Language.notifytitle,
            description = Config.Language.areceivedpresent,
            type = 'success'
        })
    end
    exports.ox_target:removeModel(entitya, pedOptions)
end
function CreatePedInteractions()
    if Config.InteractionMethod == "target" then
        entitya = "prop_xmas_tree_int"
        pedOptions = {{
            name = Config.Language.targetname,
            icon = 'fas fa-tree',
            label = Config.Language.targetname,
            onSelect = function()
                TriggerEvent('tizid:openmenuu')
            end 
        }}
        exports.ox_target:addModel(entitya, pedOptions)
    end
end
function toggleMenu()
    if menuOpen then
        menuOpen = false
    else
        menuOpen = true
    end
end