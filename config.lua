Config = {}
Config.CrimeCategories = {
    ['Theft'] = {
        ['Pickpocketing'] = { fine = 50, sentence = 1 },
        -- More specific crimes under Theft
    },
    ['Burglary'] = {
        ['House Break-in'] = { fine = 100, sentence = 3 },
        -- More specific crimes under Burglary
    },
    -- More categories
}

Config.LawJobs = {
    'sheriff',
    'deputy',
    'marshal',
    -- Add additional law jobs as needed
}

Config.Locations = {
    { x = 123.456, y = 234.567, z = 345.678 },  -- Example coordinates
    -- Add additional locations as needed
}

