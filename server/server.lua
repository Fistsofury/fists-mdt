

RegisterNetEvent('fists-mdt:searchCases', function(searchTerm)
    local src = source
    exports.oxmysql L.execute('SELECT * FROM mdt_data WHERE `case_number` LIKE @searchTerm OR `surname` LIKE @searchTerm OR `first_name` LIKE @searchTerm', { ['@searchTerm'] = '%' .. searchTerm .. '%' }, function(results)
        TriggerClientEvent('fists-mdt:returnSearchResults', src, results)
    end)
end)

-- Event for updating cases
RegisterNetEvent('fists-mdt:updateCase', function(caseData)
    local src = source
    exports.oxmysql .execute('UPDATE mdt_data SET `status` = @status, `officers_notes` = @officers_notes, `updated_at` = NOW() WHERE `id` = @id', {
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
    exports.oxmysql L.execute('SELECT `firstname`, `lastname` FROM characters WHERE `firstname` LIKE @partialName OR `lastname` LIKE @partialName', { ['@partialName'] = partialName .. '%' }, function(results)
        TriggerClientEvent('fists-mdt:returnAutocompleteResults', src, results)
    end)
end)


local function InitializeMDTServer()

end

