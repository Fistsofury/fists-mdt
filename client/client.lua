-- client.lua

local isOpen = false -- To track if the MDT interface is open

-- Function to open the MDT NUI
function openMDT()
    isOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({ type = 'openMDT' }) -- This will signal our NUI to open the MDT interface
end

-- Function to close the MDT NUI
function closeMDT()
    isOpen = false
    SetNuiFocus(false)
    SendNUIMessage({ type = 'closeMDT' }) -- This will signal our NUI to close the MDT interface
end

-- Registering the command to open the MDT
RegisterCommand('mdt', function()
    local job = exports.vorp_core:getUserJob() -- This gets the user's job from VORP core
    if Config.LawJobs[job] then
        openMDT()
    else
        TriggerEvent('vorp:Tip', 'You do not have permission to use this.', 5000) -- Notification for unauthorized access
    end
end, false)

-- NUI Callbacks
RegisterNUICallback('close', function(data, cb)
    closeMDT()
    cb('ok')
end)

RegisterNUICallback('submitCase', function(data, cb)
    -- Logic to handle case submission will go here
    -- You'll need to trigger a server event to save the case data
    cb('ok')
end)

-- Handling the image upload (pseudocode, as the implementation will depend on the service used)
RegisterNUICallback('uploadImage', function(data, cb)
    -- Pseudocode for uploading images, the actual implementation will depend on the chosen service
    -- TriggerServerEvent('fists-mdt:uploadImage', data.imageData)
    cb('ok')
end)

-- NUI Callback for updating cases
RegisterNUICallback('updateCase', function(data, cb)
    -- Trigger a server event to update the case details
    TriggerServerEvent('fists-mdt:updateCase', data.caseData)
    cb('ok')
end)

-- NUI Callback for searching cases
RegisterNUICallback('searchCases', function(data, cb)
    -- We will trigger a server event that searches for cases based on input data
    TriggerServerEvent('fists-mdt:searchCases', data.searchTerm)
    cb('ok')
end)

-- Handling the autocomplete for names
RegisterNUICallback('autocompleteName', function(data, cb)
    -- Trigger a server event to search for names that match the input
    TriggerServerEvent('fists-mdt:autocompleteName', data.partialName)
    cb('ok')
end)



-- More callbacks will be added here for other NUI interactions, like searching for cases, updating cases, etc.

-- Handling the interaction with the cabinet locations
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        for _, location in pairs(Config.Locations) do
            local distance = #(playerCoords - vector3(location.x, location.y, location.z))
            if distance < 1.5 then
                -- Draw text and handle the interaction when player is close enough
                DrawText3Ds(location.x, location.y, location.z, '[E] Open MDT')
                if IsControlJustReleased(0, 38) then -- E key
                    openMDT()
                end
            end
        end
    end
end)

-- Function to draw 3D text in the world
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


-- Event listener for server's response after searching for cases
RegisterNetEvent('fists-mdt:returnSearchResults')
AddEventHandler('fists-mdt:returnSearchResults', function(results)
    SendNUIMessage({
        type = 'updateCaseSearchResults',
        searchResults = results
    })
end)

-- Event listener for server's response after updating a case
RegisterNetEvent('fists-mdt:caseUpdated')
AddEventHandler('fists-mdt:caseUpdated', function(success, message)
    if success then
        SendNUIMessage({
            type = 'caseUpdateSuccess'
        })
        TriggerEvent('vorp:Tip', 'Case updated successfully.', 5000)
    else
        -- Handle the error scenario
        TriggerEvent('vorp:Tip', message, 5000)
    end
end)


-- Event listener for server's response for the autocomplete
RegisterNetEvent('fists-mdt:returnAutocompleteResults')
AddEventHandler('fists-mdt:returnAutocompleteResults', function(results)
    SendNUIMessage({
        type = 'updateAutocompleteResults',
        autocompleteResults = results
    })
end)



-- Add additional functions and logic as needed

-- ... [Rest of the code] ...

-- Add a function to initialize the script (optional, for better code organization)
function InitializeMDT()
    -- Any initial setup code can go here
end

-- Invoke the initialization function at script start
InitializeMDT()


-- Add additional functions and logic as needed
