-- simple config
local Config = {}

Config.pedmodel = `cs_carbuyer`
Config.pedlocation = vector4(250.72, -1076.23, 29.29, 164.33) -- set up for https://github.com/leuxum1/courthouse-fivem
Config.pedloadrange = 20     --meters
Config.PedMethod = "qb-target"  -- qb-target or mojito_dialogue // remember to change the fxmanifest dependency  'mojito_dialogue' or 'qb-target'

--required stuff
local PlayerData = {}
QBCore = exports['qb-core']:GetCoreObject()

--RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    
    Wait(500)
    isLoggedIn = true
    PlayerData = QBCore.Functions.GetPlayerData()
    PlayerJob = PlayerData.job

    TriggerEvent("trbl-license:client:loadNPC")
end)

--RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

-- This is to make sure you can restart the resource manually without having to log-out.
AddEventHandler('onResourceStart', function(resource)
    
	if resource == GetCurrentResourceName() then
		Wait(200)
		
        PlayerData = QBCore.Functions.GetPlayerData()
		isLoggedIn = true
        TriggerEvent("trbl-license:client:loadNPC")
	end
end)

-- spawns the ped with the dependency https://github.com/Mojito-Fivem/mojito_dialogue
AddEventHandler("trbl-license:client:loadNPC", function()
    
    if Config.PedMethod == "qb-target" then
        exports['qb-target']:SpawnPed({
            model = Config.pedmodel,
            coords = Config.pedlocation,
            minusOne = true,
            freeze = true,
            invincible = true,
            blockevents = true,
            animDict = 'abigail_mcs_1_concat-0',
            anim = 'csb_abigail_dual-0',
            flag = 1,
            scenario = 'PROP_HUMAN_SEAT_COMPUTER',
            target = {
                options = {
                    {
                        type = "client",
                        event = "trbl-license:client:ShowMenu",
                        icon = "fas fa-money-check",
                        label = "Renew My License"
                    
                    }
                },
                distance = 2.0,
            },
        })


    elseif Config.PedMethod == "mojito_dialogue" then

        exports['mojito_dialogue']:NewDialogueCallback(Config.pedmodel, vector4(Config.pedlocation.x,Config.pedlocation.y,Config.pedlocation.z,Config.pedlocation.w), Config.pedloadrange, {
            title = "What license do you require?",
            items = {
                {text = "Driver", value="driver"},
                {text = "Weapon", value="weapon"},
                -- you could add truck / motobike here too if you have that set up.
                {text = "Cancel", value="no"}
            }
        }, function(selection)
            if selection == "driver" or selection == "weapon" then
                TriggerServerEvent("pedlicense:server:GivePedLicenseMeta", selection)
            else 
                TriggerEvent('QBCore:Notify', "Exited", "error")
            end
        end)

    else
        print("licenseped not set up correctly")
    end
end)


RegisterNetEvent('trbl-license:client:ShowMenu', function() 
    exports['qb-menu']:openMenu({
        {
            header = "What License do you require?",
            isMenuHeader = true,
        },
        {
            header = "Drivers License", 
            txt = "$50",
            params = {
                event = "trbl-license:client:licensereferral",
                args = "driver"
            }
        },
        
        {
            header = "Weapon License", 
            txt = "$50",
            params = {
                event = "trbl-license:client:licensereferral",  -- TriggerServerEvent("pedlicense:server:GivePedLicenseMeta", selection)
                args = "weapon"
            }
        },
        {
            header = "Close",
            txt = "",
            params = {
                event = "qb-menu:closeMenu"
            }
        },
    })
end)

RegisterNetEvent('trbl-license:client:licensereferral', function(selection) 
    if selection == 1 then
        TriggerServerEvent("pedlicense:server:GivePedLicenseMeta", "driver")
    elseif selection == 2 then
        TriggerServerEvent("pedlicense:server:GivePedLicenseMeta", "weapon")
    else
end