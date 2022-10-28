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
RegisterServerEvent('pedlicense:server:GivePedLicenseMeta')
AddEventHandler('pedlicense:server:GivePedLicenseMeta', function(selection)
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
