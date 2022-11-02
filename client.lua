local PlayerData = {}
QBCore = exports['qb-core']:GetCoreObject()

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    
    Wait(500)
    isLoggedIn = true
    PlayerData = QBCore.Functions.GetPlayerData()
    PlayerJob = PlayerData.job

    TriggerEvent("trbl-license:client:loadNPC")
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
    if Config.PedMethod == "qb-target" then
        exports['qb-target']:RemoveSpawnedPed('licenseped')
    end
end)

AddEventHandler('onResourceStart', function(resource)
    
    if Config.PedMethod == "qb-target" then
        exports['qb-target']:RemoveSpawnedPed('licenseped')
    end

	if resource == GetCurrentResourceName() then
		Wait(200)
		
        PlayerData = QBCore.Functions.GetPlayerData()
		isLoggedIn = true
        TriggerEvent("trbl-license:client:loadNPC")
	end
end)

-- spawns the ped with either dependency https://github.com/Mojito-Fivem/mojito_dialogue or qb-target
AddEventHandler("trbl-license:client:loadNPC", function()
    
    if Config.PedMethod == "qb-target" then
        exports['qb-target']:SpawnPed({
            name = 'licenseped',
            model = Config.pedmodel,
            coords = Config.pedlocationTarget,
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
                        label = "Apply for License"
                    },
                    {
                        type = "client",
                        event = "trbl-license:client:PurchaseMenu",
                        icon = "fas fa-money-check",
                        label = "Recover Lost Documentation"
                    }                    
                },
                distance = Config.distance,
            },
        })
    elseif Config.PedMethod == "mojito_dialogue" then
        exports['mojito_dialogue']:NewDialogueCallback(Config.pedmodel, vector4(Config.pedlocation.x,Config.pedlocation.y,Config.pedlocation.z,Config.pedlocation.w), Config.pedloadrange, {
            title = "What license do you require?",
            items = {
                {text = "Driver", value="driver"},
                {text = "Weapon", value="weapon"},
                -- you could add pilot / truck / motobike here too if you have that set up.
                {text = "Cancel", value="no"}
            }
        }, function(selection)
            if selection == "driver" or selection == "weapon" then
                TriggerServerEvent("trbl-license:server:GivePedLicenseMeta", selection)
            else 
                TriggerEvent('QBCore:Notify', "Exited", "error")
            end
        end)

    else
        print("licenseped not set up correctly")
    end
end)

-- show menu if using qb-target
RegisterNetEvent('trbl-license:client:ShowMenu', function() 
    local mainMenu = {{
            header = "What License are you applying for?",
            isMenuHeader = true,
        }
    }
    for k, v in pairs(Config.Purchasables) do
        mainMenu[#mainMenu + 1] = {
            header = v.label,
            icon = "fa-solid fa-circle",
            params = {
                event = 'trbl-license:client:licensereferral',
                args = v.item
            }
        }
    end
    exports['qb-menu']:openMenu(mainMenu)
end)


-- purchase the item

RegisterNetEvent('trbl-license:client:PurchaseMenu', function()
    local purchaseMenu = {        
        {
            header = "Print a new license?",
            isMenuHeader = true,
        },
    }
	for k, v in pairs(Config.Purchasables) do
        purchaseMenu[#purchaseMenu + 1] = {
            header = v.label,
            icon = "fa-solid fa-circle",
            params = {
                event = 'trbl-license:client:requestId',
                args = k
            }
        }
    end
    exports['qb-menu']:openMenu(purchaseMenu)
end)

-- set meta
RegisterNetEvent('trbl-license:client:licensereferral', function(selection)    
    TriggerServerEvent("trbl-license:server:GivePedLicenseMeta", selection)
end)

RegisterNetEvent('trbl-license:client:requestId', function(id)
    local inRange = false
    local license = Config.Purchasables[id]
    local pcoords = GetEntityCoords(PlayerPedId())
    local dist = #(pcoords - vector3(Config.pedlocationTarget.x,Config.pedlocationTarget.y,Config.pedlocationTarget.z))
    if dist <= Config.distance then inRange = true end
    if inRange and license and Config.Purchasables[id].cost == license.cost then
        TriggerServerEvent('trbl-license:server:requestId', license.item)
        QBCore.Functions.Notify(('You have received your %s for $%s'):format(license.label, license.cost), 'success', 3500)
    else
        QBCore.Functions.Notify('Too far from the issuer', 'error')
    end
end)