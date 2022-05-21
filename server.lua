local QBCore = exports['qb-core']:GetCoreObject()
local Cooldown = false
local cash1 = 1500
local cash2 = 5000

RegisterServerEvent("gc-atmrobbery:success")
AddEventHandler("gc-atmrobbery:success", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(source)
    local bags = 1
    local info = {
        worth = math.random(cash1, cash2)
    }
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['laptop_pink'], 'remove')
    Player.Functions.RemoveItem("laptop_pink", 1)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['markedbills'], "add")
    Player.Functions.AddItem('markedbills', bags, false, info)
end)

RegisterServerEvent('gc-atmrobbery:server:cooldown')
AddEventHandler('gc-atmrobbery:server:cooldown', function()
    Cooldown = true
    local timer = 60000 * 60000
    while timer > 0 do
        Wait(1000)
        timer = timer - 1000
        if timer == 0 then
            Cooldown = false
        end
    end
end)

QBCore.Functions.CreateCallback("gc-atmrobbery:Cooldown", function(source, cb)
    if Cooldown then
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('gc-bobcatheist:server:getCops', function(source, cb)
    local amount = 0
    for k, v in pairs(QBCore.Functions.GetQBPlayers()) do
        if v.PlayerData.job.name == 'police' then
            amount = amount + 1
        end
    end
    cb(amount)
end)