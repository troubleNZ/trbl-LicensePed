CreateThread(function(resourceName)
    local resourceName = GetCurrentResourceName()
    PerformHttpRequest('https://raw.githubusercontent.com/troubleNZ/trbl-versions/main/trbl-LicensePed.json', function (errorCode, resultData, resultHeaders)
      if not resultData then return end
      local retData  = json.decode(resultData)
      local version  = retData["version"]
      local currentVersion  = GetResourceMetadata(resourceName, "version", 0)
      local upToDateMsg = retData["up-to-date"]["message"]
      local updateMsg  = retData["requires-update"]["message"]
      if version ~= currentVersion then
        local updMessage = "^3 - Update here: " .. GetResourceMetadata(resourceName, "repository", 0) .. " (current: v" .. currentVersion .. ", newest: v" .. version .. ")^0"
        if retData["requires-update"]["important"] and updateMsg ~= nil then
          print("")
          print("  ^1Important Message:^0")
          print("")
          print((updateMsg):format(resourceName))
          print(updMessage)
          print("")
          print("")
        elseif updateMsg ~= nil then
          print((updateMsg):format(resourceName) .. "^0")
          print(updMessage)
        end
      elseif upToDateMsg ~= nil then
        print((upToDateMsg):format(resourceName) .. "^0")
      end
    end, 'GET')
  end)


  
local QBCore = exports['qb-core']:GetCoreObject()
RegisterServerEvent('trbl-license:server:GivePedLicenseMeta')
AddEventHandler('trbl-license:server:GivePedLicenseMeta', function(selection)
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

RegisterNetEvent('trbl-license:server:requestId', function(item)
  local src = source
  local Player = QBCore.Functions.GetPlayer(src)
  if not Player then return end
  local itemInfo = Config.Purchasables[item]
  if not Player.Functions.RemoveMoney("cash", itemInfo.cost) then return TriggerClientEvent('QBCore:Notify', src, ('You don\'t have enough money on you, you need %s cash'):format(itemInfo.cost), 'error') end
  local info = {}
  if item == "id_card" then
      info.citizenid = Player.PlayerData.citizenid
      info.firstname = Player.PlayerData.charinfo.firstname
      info.lastname = Player.PlayerData.charinfo.lastname
      info.birthdate = Player.PlayerData.charinfo.birthdate
      info.gender = Player.PlayerData.charinfo.gender
      info.nationality = Player.PlayerData.charinfo.nationality
  elseif item == "driver_license" then
      info.firstname = Player.PlayerData.charinfo.firstname
      info.lastname = Player.PlayerData.charinfo.lastname
      info.birthdate = Player.PlayerData.charinfo.birthdate
      info.type = "Class C Driver License"
  elseif item == "weaponlicense" then
      info.firstname = Player.PlayerData.charinfo.firstname
      info.lastname = Player.PlayerData.charinfo.lastname
      info.birthdate = Player.PlayerData.charinfo.birthdate
  else
      return DropPlayer(src, 'Attempted exploit abuse')
  end
  if not Player.Functions.AddItem(item, 1, nil, info) then return end
  TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'add')
end)