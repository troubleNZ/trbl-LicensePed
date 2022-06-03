-- simple config
local model = `cs_carbuyer`
local pedlocation = vector4(225.24, -428.48, 47.02, 326.35) -- set up for https://forum.cfx.re/t/jay17-courthouse-early-access/1350775
local pedloadrange = 20     --meters

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
    
    exports['mojito_dialogue']:NewDialogueCallback(model, vector4(pedlocation.x,pedlocation.y,pedlocation.z,pedlocation.w), pedloadrange, {
        title = "What license do you require?",
        items = {
            {text = "Driver", value="driver"},
            {text = "Weapon", value="weapon"},
            -- you could add truck / motobike here too if you have that set up.
            {text = "Cancel", value="no"}
        }
    }, function(selection)
        if selection == "driver" or selection == "weapon" then
            TriggerServerEvent("pedlicense:server:GivePedWeaponLicense", selection)
        else 
            TriggerEvent('QBCore:Notify', "Exited", "error")
        end
    end)
end)
