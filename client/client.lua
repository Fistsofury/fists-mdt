-- add vorp core here

local isOpen = false -- To track if the MDT interface is open


function openMDT()
    isOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({ type = 'openMDT' }) 
end

-- Function to close the MDT NUI
function closeMDT()
    isOpen = false
    SetNuiFocus(false)
    SendNUIMessage({ type = 'closeMDT' }) 
end

-- Registering the command to open the MDT
RegisterCommand('mdt', function()
  --  local job = Job check here
  --  if Config.LawJobs[job] then
        openMDT()
  --  else
  --      TriggerEvent('vorp:Tip', 'You do not have permission to use this.', 5000) -- Notification for unauthorized access
 --   end
end, false)

-- NUI Callbacks
RegisterNUICallback('close', function(data, cb)
    closeMDT()
    cb('ok')
end)

RegisterNUICallback('submitCase', function(data, cb)
--tbc
    cb('ok')
end)

-- TBC
RegisterNUICallback('uploadImage', function(data, cb)

    cb('ok')
end)

-- NUI Callback for updating cases
RegisterNUICallback('updateCase', function(data, cb)
    TriggerServerEvent('fists-mdt:updateCase', data.caseData)
    cb('ok')
end)

-- NUI Callback for searching cases
RegisterNUICallback('searchCases', function(data, cb)
    TriggerServerEvent('fists-mdt:searchCases', data.searchTerm)
    cb('ok')
end)

-- Handling the autocomplete for names
RegisterNUICallback('autocompleteName', function(data, cb)
    -- Trigger a server event to search for names that match the input
    TriggerServerEvent('fists-mdt:autocompleteName', data.partialName)
    cb('ok')
end)




Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        for _, location in pairs(Config.Locations) do
            local distance = #(playerCoords - vector3(location.x, location.y, location.z))
            if distance < 1.5 then
                DrawText3Ds(location.x, location.y, location.z, '[E] Open MDT')
                if IsControlJustReleased(0, 38) then -- E key
                    openMDT()
                end
            end
        end
    end
end)


function DrawText3Ds(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry('STRING')
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0140, 0.015 + factor, 0.03, 41, 11, 41, 68)
end



RegisterNetEvent('fists-mdt:returnSearchResults')
AddEventHandler('fists-mdt:returnSearchResults', function(results)
    SendNUIMessage({
        type = 'updateCaseSearchResults',
        searchResults = results
    })
end)


RegisterNetEvent('fists-mdt:caseUpdated')
AddEventHandler('fists-mdt:caseUpdated', function(success, message)
    if success then
        SendNUIMessage({
            type = 'caseUpdateSuccess'
        })
        TriggerEvent('vorp:Tip', 'Case updated successfully.', 5000)
    else

        TriggerEvent('vorp:Tip', message, 5000)
    end
end)



RegisterNetEvent('fists-mdt:returnAutocompleteResults')
AddEventHandler('fists-mdt:returnAutocompleteResults', function(results)
    SendNUIMessage({
        type = 'updateAutocompleteResults',
        autocompleteResults = results
    })
end)


