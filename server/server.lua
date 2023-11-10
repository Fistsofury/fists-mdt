-- server.lua

local OxMySQL = exports.oxmysql -- Accessing oxmysql

-- Event for searching cases
RegisterNetEvent('fists-mdt:searchCases', function(searchTerm)
    local src = source
    -- Query the database for cases that match the searchTerm
    -- This is a simple query, more complex logic can be added for better search results
    OxMySQL.execute('SELECT * FROM mdt_data WHERE `case_number` LIKE @searchTerm OR `surname` LIKE @searchTerm OR `first_name` LIKE @searchTerm', { ['@searchTerm'] = '%' .. searchTerm .. '%' }, function(results)
        TriggerClientEvent('fists-mdt:returnSearchResults', src, results)
    end)
end)

-- Event for updating cases
RegisterNetEvent('fists-mdt:updateCase', function(caseData)
    local src = source
    -- Update case in the database with the new data
    -- Implement the database update logic here
    OxMySQL.execute('UPDATE mdt_data SET `status` = @status, `officers_notes` = @officers_notes, `updated_at` = NOW() WHERE `id` = @id', {
        ['@id'] = caseData.id,
        ['@status'] = caseData.status,
        ['@officers_notes'] = caseData.officers_notes,
    }, function(affectedRows)
        if affectedRows > 0 then
            TriggerClientEvent('fists-mdt:caseUpdated', src, true, 'Case updated successfully.')
        else
            TriggerClientEvent('fists-mdt:caseUpdated', src, false, 'Failed to update the case.')
        end
    end)
end)

-- Event for name autocomplete
RegisterNetEvent('fists-mdt:autocompleteName', function(partialName)
    local src = source
    -- Query the `characters` table for firstname and lastname that start with the partialName
    OxMySQL.execute('SELECT `firstname`, `lastname` FROM characters WHERE `firstname` LIKE @partialName OR `lastname` LIKE @partialName', { ['@partialName'] = partialName .. '%' }, function(results)
        TriggerClientEvent('fists-mdt:returnAutocompleteResults', src, results)
    end)
end)

-- Add additional server-side logic as needed

-- Function to initialize the script (optional, for better code organization)
local function InitializeMDTServer()
    -- Any server-side initial setup code can go here
end

-- Invoke the initialization function at script start
InitializeMDTServer()
