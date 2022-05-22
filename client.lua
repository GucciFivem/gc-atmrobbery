local QBCore = exports['qb-core']:GetCoreObject()

local cops = 0



RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
end)

RegisterNetEvent('qb-police:CopCount', function()
    cops = amount
end)

function progress()
    Anim = true
    QBCore.Functions.Progressbar("power_hack", "Robbing ATM...", (30000), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false, 
        disableCombat = true,
    }, {
        animDict = "anim@heists@ornate_bank@grab_cash_heels",
        anim = "grab",
        flags = 16,
    }, {
       model = "prop_cs_heist_bag_02",
       bone = 57005,
       coords = { x = -0.005, y = 0.00, z = -0.16 },
       rotation = { x = 250.0, y = -30.0, z = 0.0 }, 
    }, {}, function() -- done
        Anim = false
        StopAnimTask(PlayerPedId(), "anim@heists@ornate_bank@grab_cash_heels", "grab", 1.0)
		SetPedComponentVariation((PlayerPedId()), 5, 47, 0, 0)

    end, function() -- Cancel
        Anim = false
        StopAnimTask(PlayerPedId(), "anim@heists@ornate_bank@grab_cash_heels", "grab", 1.0)
		
    end)

    CreateThread(function()
        while Anim do
            TriggerServerEvent('qb-hud:server:gain:stress', 3)
            Wait(12000)
        end
    end)
end

local function Alert()
    exports['ps-dispatch']:AtmRobbery()
end

local function hackanim()
    local animDict = "anim@heists@ornate_bank@hack"
    RequestAnimDict(animDict)
    RequestModel("hei_prop_hst_laptop")
    RequestModel("ch_p_m_bag_var02_arm_s") 
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    while not HasAnimDictLoaded(animDict)
        or not HasModelLoaded("hei_prop_hst_laptop")
        or not HasModelLoaded("ch_p_m_bag_var02_arm_s") do
        Wait(100)
    end
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    --SetEntityCoords(ped, coords.x, coords.y, coords.z + 1.15) 
    local targetPosition, targetRotation = (vec3(GetEntityCoords(ped))), vec3(GetEntityRotation(ped))
    local animPos = GetAnimInitialOffsetPosition(animDict, "hack_enter", coords.x, coords.y + 0.55, coords.z + 0.75)
    local animPos2 = GetAnimInitialOffsetPosition(animDict, "hack_loop", coords.x, coords.y + 0.55, coords.z + 0.75)
    local animPos3 = GetAnimInitialOffsetPosition(animDict, "hack_exit", coords.x, coords.y + 0.55, coords.z + 0.75)
    QBCore.Functions.TriggerCallback('gc-bobcatheist:server:getCops', function(cops)
        if cops >= Config.Cops then
    QBCore.Functions.TriggerCallback('QBCore:HasItem', function(hasitem)
            if hasitem then
                
                bag = CreateObject(`ch_p_m_bag_var02_arm_s`, targetPosition, 1, 1, 0)
                laptop = CreateObject(`hei_prop_hst_laptop`, targetPosition, 1, 1, 0)
                local IntroHack = NetworkCreateSynchronisedScene(animPos, targetRotation, 0, true, false, 1065353216, 0, 1.3)
                NetworkAddPedToSynchronisedScene(ped, IntroHack, animDict, "hack_enter", 0, 0, 1, 16, 1148846080, 0)
                NetworkAddEntityToSynchronisedScene(bag, IntroHack, animDict, "hack_enter_bag", 4.0, -8.0, 1)
                NetworkAddEntityToSynchronisedScene(laptop, IntroHack, animDict, "hack_enter_laptop", 4.0, -8.0, 1)
                HackLoop = NetworkCreateSynchronisedScene(animPos2, targetRotation, 2, false, true, 1065353216, -1, 1.0)
                NetworkAddPedToSynchronisedScene(ped, HackLoop, animDict, "hack_loop", 0, 0, -1, 1, 1148846080, 0)
                NetworkAddEntityToSynchronisedScene(bag, HackLoop, animDict, "hack_loop_bag", 1.0, 0.0, 1)
                NetworkAddEntityToSynchronisedScene(laptop, HackLoop, animDict, "hack_loop_laptop", 1.0, -0.0, 1)
                HackLoopFinish = NetworkCreateSynchronisedScene(animPos3, targetRotation, 2, false, false, 1065353216, -1, 1.3)
                NetworkAddPedToSynchronisedScene(ped, HackLoopFinish, animDict, "hack_exit", 0, 0, -1, 16, 1148846080, 0)
                NetworkAddEntityToSynchronisedScene(bag, HackLoopFinish, animDict, "hack_exit_bag", 4.0, -8.0, 1)
                NetworkAddEntityToSynchronisedScene(laptop, HackLoopFinish, animDict, "hack_exit_laptop", 4.0, -8.0, 1)
                SetPedComponentVariation(ped, 5, 0, 0, 0)
                NetworkStartSynchronisedScene(IntroHack)
                TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items["laptop_pink"], "remove")
                TriggerServerEvent("QBCore:Server:RemoveItem", "laptop_pink", 1)
                Wait(6000)
                FreezeEntityPosition(PlayerPedId(), true)
                NetworkStopSynchronisedScene(IntroHack)
                NetworkStartSynchronisedScene(HackLoop)
                exports['hacking']:OpenHackingGame(8, 4, 4, function(Success)
                    if Success then -- success
                        Alert()
                        NetworkStopSynchronisedScene(HackLoop)
                        NetworkStartSynchronisedScene(HackLoopFinish)
                        Wait(6000)
                        NetworkStopSynchronisedScene(HackLoopFinish)
                        DeleteObject(bag)
                        DeleteObject(laptop)
                        FreezeEntityPosition(PlayerPedId(), false)
                        HackSuccess()
                        SetPedComponentVariation(PlayerPedId(), 5, 82, 0, 0)
                    else
                        NetworkStopSynchronisedScene(HackLoop)
                        NetworkStartSynchronisedScene(HackLoopFinish)
                        Wait(6000)
                        NetworkStopSynchronisedScene(HackLoopFinish)
                        DeleteObject(bag)
                        DeleteObject(laptop)
                        HackFailed()
                        FreezeEntityPosition(PlayerPedId(), false)
                        SetPedComponentVariation(PlayerPedId(), 5, 82, 0, 0)
                    end
                end)
            else
                QBCore.Functions.Notify('You do not have the required items!', "error")
            end
        end, "laptop_pink")
        else
            QBCore.Functions.Notify('No Cops!', "error")
        end
    end)
end

function HackFailed()
    QBCore.Functions.Notify("Thought this would be easy?")
    if math.random(1, 100) <= 40 then
		TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
		QBCore.Functions.Notify("You left fingerprints...")
	end
end

function HackSuccess()
    QBCore.Functions.Notify("Success")
    ClearPedTasksImmediately(PlayerPedId())
    progress()
    Wait(30000)
    TriggerServerEvent("gc-atmrobbery:success")
    TriggerServerEvent('gc-atmrobbery:server:cooldown')
end

function call()
    local chance = 50
    if math.random(1, 100) <= chance then
        TriggerServerEvent('police:server:policeAlert', 'ATM ROBBERY')
    end
end

RegisterNetEvent('gc-atmrobbery:client:hit', function()
    hackanim()
end)

local ATMS = {
    "prop_atm_01",
    "prop_atm_02",
    "prop_atm_03",
    "prop_flecca_atm"
}
exports['qb-target']:AddTargetModel(ATMS, {
    options = {
        {
            type = "client",
            event = "gc-atmrobbery:client:hit",
            icon = "fas fa-laptop",
            label = "Rob ATM",

            canInteract = function()
                if IsPedAPlayer(entity) then return false end
                return true
            end,
            item = 'laptop_pink',
        },
    },
    distance = 1.5
})

exports['qb-target']:AddBoxZone('fleccaatm1', vector3(147.66, -1035.69, 29.34), 1, 1, {
    name='atm1',
    heading=164.14,
    debugPoly=false,
    minZ = 29.34,
    maxZ = 31.34,
    }, {
        options = {
            {
                type = 'client',
                event = 'gc-atmrobbery:client:hit',
                icon = 'fas fa-laptop',
                label = 'Rob ATM',

                canInteract = function()
                    return true
                end,
                item = 'laptop_pink',
            },
        },
    distance = 1.0
})

exports['qb-target']:AddBoxZone('fleccaatm2', vector3(146.00, -1035.13, 29.34), 1, 1, {
    name='atm2',
    heading=158.87,
    debugPoly=false,
    minZ = 29.34,
    maxZ = 31.34,
    }, {
        options = {
            {
                type = 'client',
                event = 'gc-atmrobbery:client:hit',
                icon = 'fas fa-laptop',
                label = 'Rob ATM',

                canInteract = function()
                    return true
                end,
                item = 'laptop_pink',
            },
        },
    distance = 1.0
})


exports['qb-target']:AddBoxZone('fleccaatm3', vector3(-2958.98, 487.68, 15.46), 1, 1, {
    name='atm3',
    heading=188.30,
    debugPoly=false,
    minZ = 15.46,
    maxZ = 17.46,
    }, {
        options = {
            {
                type = 'client',
                event = 'gc-atmrobbery:client:hit',
                icon = 'fas fa-laptop',
                label = 'Rob ATM',

                canInteract = function()
                    return true
                end,
                item = 'laptop_pink',
            },
        },
    distance = 1.0
})

exports['qb-target']:AddBoxZone('fleccaatm4', vector3(-2956.97, 487.60, 15.46), 1, 1, {
    name='atm4',
    heading=179.31,
    debugPoly=false,
    minZ = 15.46,
    maxZ = 17.46,
    }, {
        options = {
            {
                type = 'client',
                event = 'gc-atmrobbery:client:hit',
                icon = 'fas fa-laptop',
                label = 'Rob ATM',

                canInteract = function()
                    return true
                end,
                item = 'laptop_pink',
            },
        },
    distance = 1.0
})

exports['qb-target']:AddBoxZone('fleccaatm5', vector3(-97.49, 6455.39, 31.47), 1, 1, {
    name='atm5',
    heading=49.74,
    debugPoly=false,
    minZ = 31.47,
    maxZ = 33.47,
    }, {
        options = {
            {
                type = 'client',
                event = 'gc-atmrobbery:client:hit',
                icon = 'fas fa-laptop',
                label = 'Rob ATM',

                canInteract = function()
                    return true
                end,
                item = 'laptop_pink',
            },
        },
    distance = 1.0
})

exports['qb-target']:AddBoxZone('fleccaatm6', vector3(-95.72, 6457.27, 31.46), 1, 1, {
    name='atm6',
    heading=51.85,
    debugPoly=false,
    minZ = 31.46,
    maxZ = 33.46,
    }, {
        options = {
            {
                type = 'client',
                event = 'gc-atmrobbery:client:hit',
                icon = 'fas fa-laptop',
                label = 'Rob ATM',

                canInteract = function()
                    return true
                end,
                item = 'laptop_pink',
            },
        },
    distance = 1.0
})

