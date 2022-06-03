
local QBCore = exports['qb-core']:GetCoreObject()
RegisterServerEvent('pedlicense:server:GivePedWeaponLicense')
AddEventHandler('pedlicense:server:GivePedWeaponLicense', function(selection)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if Player then
        local licenseTable = Player.PlayerData.metadata["licences"]
            if licenseTable[selection] == false then
                licenseTable[selection] = true
                Player.Functions.SetMetaData("licences", licenseTable)
                TriggerClientEvent('QBCore:Notify', src, "You have been granted a license", "success", 5000)
                --print('exit serverside')
                -- you should maybe put a logging event here.
            else
                TriggerClientEvent('QBCore:Notify', src, "You already have a license", "error", 5000)
            end
    end 

end)