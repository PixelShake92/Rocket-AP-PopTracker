-- Rocket Robot on Wheels Archipelago Auto-Tracker Implementation

-- Load the location_mapping file for correct memory addresses
ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua")

-- Define location ID ranges and naming patterns
local LOCATION_RANGES = {
    {min = 16777216, max = 16777227, prefix = "Whoopie World Ticket "},
    {min = 16842752, max = 16842763, prefix = "Clowney Island Ticket "},
    {min = 16908288, max = 16908299, prefix = "Paint Misbehavin' Ticket "},
    {min = 16973824, max = 16973835, prefix = "Mine Blowing Ticket "},
    {min = 17039360, max = 17039371, prefix = "Arabian Flights Ticket "},
    {min = 17104896, max = 17104907, prefix = "Pyramid Scheme Ticket "},
    {min = 17170432, max = 17170443, prefix = "Food Fright Ticket "}
}

-- Special location IDs (e.g., boss fights, abilities)
local SPECIAL_LOCATIONS = {
    [17235968] = "@Jojo's World/Defeat Jojo/Defeat Jojo",
    -- Do NOT put ability codes here as they should come from item_mapping
}

-- Machine part hex-to-name mapping
-- These match EXACTLY the names used in the JSON files (Clowney Island Machine Part 1, etc.)
local MACHINE_PART_LOOKUP = {
    -- Clowney Island Machine Parts
    [0x03010000] = {type = "clowney_machine_part", name = "Clowney Island Machine Part 1"},
    [0x03010001] = {type = "clowney_machine_part", name = "Clowney Island Machine Part 2"},
    [0x03010002] = {type = "clowney_machine_part", name = "Clowney Island Machine Part 3"},
    [0x03010003] = {type = "clowney_machine_part", name = "Clowney Island Machine Part 4"},
    [0x03010004] = {type = "clowney_machine_part", name = "Clowney Island Machine Part 5"},
    [0x03010005] = {type = "clowney_machine_part", name = "Clowney Island Machine Part 6"},
    [0x03010006] = {type = "clowney_machine_part", name = "Clowney Island Machine Part 7"},
    
    -- Paint Misbehavin' Machine Parts
    [0x03020000] = {type = "paint_machine_part", name = "Paint Misbehavin' Machine Part 1"},
    [0x03020001] = {type = "paint_machine_part", name = "Paint Misbehavin' Machine Part 2"},
    [0x03020002] = {type = "paint_machine_part", name = "Paint Misbehavin' Machine Part 3"},
    [0x03020003] = {type = "paint_machine_part", name = "Paint Misbehavin' Machine Part 4"},
    [0x03020004] = {type = "paint_machine_part", name = "Paint Misbehavin' Machine Part 5"},
    [0x03020005] = {type = "paint_machine_part", name = "Paint Misbehavin' Machine Part 6"},
    [0x03020006] = {type = "paint_machine_part", name = "Paint Misbehavin' Machine Part 7"},
    
    -- Mine Blowing Machine Parts
    [0x03030000] = {type = "mine_machine_part", name = "Mine Blowing Machine Part 1"},
    [0x03030001] = {type = "mine_machine_part", name = "Mine Blowing Machine Part 2"},
    [0x03030002] = {type = "mine_machine_part", name = "Mine Blowing Machine Part 3"},
    [0x03030003] = {type = "mine_machine_part", name = "Mine Blowing Machine Part 4"},
    [0x03030004] = {type = "mine_machine_part", name = "Mine Blowing Machine Part 5"},
    [0x03030005] = {type = "mine_machine_part", name = "Mine Blowing Machine Part 6"},
    [0x03030006] = {type = "mine_machine_part", name = "Mine Blowing Machine Part 7"},
    
    -- Arabian Flights Machine Parts
    [0x03040000] = {type = "arabian_machine_part", name = "Arabian Flights Machine Part 1"},
    [0x03040001] = {type = "arabian_machine_part", name = "Arabian Flights Machine Part 2"},
    [0x03040002] = {type = "arabian_machine_part", name = "Arabian Flights Machine Part 3"},
    [0x03040003] = {type = "arabian_machine_part", name = "Arabian Flights Machine Part 4"},
    [0x03040004] = {type = "arabian_machine_part", name = "Arabian Flights Machine Part 5"},
    [0x03040005] = {type = "arabian_machine_part", name = "Arabian Flights Machine Part 6"},
    [0x03040006] = {type = "arabian_machine_part", name = "Arabian Flights Machine Part 7"},
    
    -- Pyramid Scheme Machine Parts
    [0x03050000] = {type = "pyramid_machine_part", name = "Pyramid Scheme Machine Part 1"},
    [0x03050001] = {type = "pyramid_machine_part", name = "Pyramid Scheme Machine Part 2"},
    [0x03050002] = {type = "pyramid_machine_part", name = "Pyramid Scheme Machine Part 3"},
    [0x03050003] = {type = "pyramid_machine_part", name = "Pyramid Scheme Machine Part 4"},
    [0x03050004] = {type = "pyramid_machine_part", name = "Pyramid Scheme Machine Part 5"},
    [0x03050005] = {type = "pyramid_machine_part", name = "Pyramid Scheme Machine Part 6"},
    [0x03050006] = {type = "pyramid_machine_part", name = "Pyramid Scheme Machine Part 7"},
    
    -- Food Fright Machine Parts
    [0x03060000] = {type = "food_machine_part", name = "Food Fright Machine Part 1"},
    [0x03060001] = {type = "food_machine_part", name = "Food Fright Machine Part 2"},
    [0x03060002] = {type = "food_machine_part", name = "Food Fright Machine Part 3"},
    [0x03060003] = {type = "food_machine_part", name = "Food Fright Machine Part 4"},
    [0x03060004] = {type = "food_machine_part", name = "Food Fright Machine Part 5"},
    [0x03060005] = {type = "food_machine_part", name = "Food Fright Machine Part 6"},
    [0x03060006] = {type = "food_machine_part", name = "Food Fright Machine Part 7"}
}

-- Utility function to set any available property on an object
function setObjectCompleted(obj)
    if not obj then return end
    
    if obj.Active ~= nil then
        obj.Active = true
    elseif obj.AvailableChestCount ~= nil then
        obj.AvailableChestCount = 0
    elseif obj.Collected ~= nil then
        obj.Collected = true
    end
end

function onClear(slot_data)
    print("Resetting tracker state")
    
    -- Reset counters with verification
    local ticketObj = Tracker:FindObjectForCode("tickets")
    if ticketObj then 
        ticketObj.AcquiredCount = 0 
        print("Tickets counter reset")
    else
        print("ERROR: Could not find 'tickets' object!")
    end
    
    local tokenObj = Tracker:FindObjectForCode("tinker_tokens")
    if tokenObj then 
        tokenObj.AcquiredCount = 0 
        print("Tokens counter reset")
    else
        print("ERROR: Could not find 'tinker_tokens' object!")
    end
    
    -- Reset abilities if needed
    local abilities = {"tractor_beam", "swing", "slam", "double_jump", "freeze_ray", "grapple"}
    for _, ability in ipairs(abilities) do
        local obj = Tracker:FindObjectForCode(ability)
        if obj then 
            -- Check if this is a progressive item or toggle
            if obj.CurrentStage ~= nil then
                obj.CurrentStage = 0
                print("Reset progressive " .. ability)
            else 
                obj.Active = false 
                print("Reset " .. ability)
            end
        else
            print("ERROR: Could not find ability object: " .. ability)
        end
    end
    
    -- Reset vehicles
    local vehicles = {"dune_dog", "hover_splat", "fin_bot", "beam_lift", "shag_flyer", "glider_bike", "spider_rider"}
    for _, vehicle in ipairs(vehicles) do
        local obj = Tracker:FindObjectForCode(vehicle)
        if obj then obj.Active = false end
    end
    
    -- Reset machine parts
    local parts = {"clowney_machine_part", "paint_machine_part", "mine_machine_part", 
                  "arabian_machine_part", "pyramid_machine_part", "food_machine_part"}
    for _, part in ipairs(parts) do
        local obj = Tracker:FindObjectForCode(part)
        if obj then 
            obj.AcquiredCount = 0 
            print("Reset " .. part)
        else
            print("ERROR: Could not find machine part object: " .. part)
        end
    end
    
    print("Rocket Robot on Wheels tracker reset complete")
end

-- Handle item collection
function onItem(index, item_id, item_name, player_number)
    print(string.format("Item received: ID=%s, Name=%s", item_id, item_name or "unknown"))
    
    -- Ticket collection - ONLY increment ticket counter here when we receive the item!
    if item_id == 1 or (item_name and (item_name:find("Ticket") or item_name == "Progressive Ticket")) then
        local obj = Tracker:FindObjectForCode("tickets")
        if obj then 
            obj.AcquiredCount = obj.AcquiredCount + 1 
            print("Ticket count updated to: " .. obj.AcquiredCount)
        else
            print("ERROR: 'tickets' object not found!")
        end
        return
    end
    
    -- Token collection
    if item_id == 2 or (item_name and (item_name:find("Token") or item_name:find("Tinker"))) then 
        local obj = Tracker:FindObjectForCode("tinker_tokens")
        if obj then 
            obj.AcquiredCount = obj.AcquiredCount + 1 
            print("Token count updated to: " .. obj.AcquiredCount)
        else
            print("ERROR: 'tinker_tokens' object not found!")
        end
        return
    end
    
    -- Ability items using a mapping table for cleaner code
    local ability_map = {
        [3] = "tractor_beam",
        [4] = "swing",
        [5] = "slam",
        [6] = "double_jump",
        [7] = "freeze_ray",
        [8] = "grapple"
    }
    
    -- Check by ID
    if ability_map[item_id] then
        local code = ability_map[item_id]
        local obj = Tracker:FindObjectForCode(code)
        if obj then 
            -- Check if this is a progressive item or toggle
            if obj.CurrentStage ~= nil then
                obj.CurrentStage = math.min(obj.CurrentStage + 1, obj.NumStages)
                print("Progressive item advanced: " .. code .. " to stage " .. obj.CurrentStage)
            else
                obj.Active = true 
                print("Ability activated: " .. code)
            end
        else
            print("ERROR: Ability object not found: " .. code)
        end
        return
    end
    
    -- Vehicle items
    local vehicle_map = {
        [10] = "dune_dog",
        [11] = "hover_splat",
        [12] = "fin_bot",
        [13] = "beam_lift",
        [14] = "shag_flyer",
        [15] = "glider_bike",
        [16] = "spider_rider"
    }
    
    if vehicle_map[item_id] then
        local obj = Tracker:FindObjectForCode(vehicle_map[item_id])
        if obj then obj.Active = true end
        return
    end
    
    -- Machine part items
    local part_map = {
        [20] = "clowney_machine_part",
        [21] = "paint_machine_part",
        [22] = "mine_machine_part",
        [23] = "arabian_machine_part",
        [24] = "pyramid_machine_part",
        [25] = "food_machine_part"
    }
    
    if part_map[item_id] then
        local obj = Tracker:FindObjectForCode(part_map[item_id])
        if obj then 
            obj.AcquiredCount = obj.AcquiredCount + 1
            print("Machine part counter incremented: " .. part_map[item_id] .. " = " .. obj.AcquiredCount)
        end
        return
    end
    
    -- Special items
    local special_map = {
        [30] = "galaxy_2000_screws",
        [31] = "victory"
    }
    
    if special_map[item_id] then
        local obj = Tracker:FindObjectForCode(special_map[item_id])
        if obj then obj.Active = true end
        return
    end
    
    -- Check by name as fallback
    if item_name then
        -- For abilities
        for id, code in pairs(ability_map) do
            local ability_name = code:gsub("_", " "):gsub("^%l", string.upper)
            if item_name:find(ability_name) then
                local obj = Tracker:FindObjectForCode(code)
                if obj then 
                    -- Check if this is a progressive item
                    if obj.CurrentStage ~= nil then
                        obj.CurrentStage = math.min(obj.CurrentStage + 1, obj.NumStages)
                        print("Progressive item advanced by name: " .. code .. " to stage " .. obj.CurrentStage)
                    else
                        obj.Active = true 
                        print("Ability activated by name: " .. code)
                    end
                end
                return
            end
        end
        
        -- For vehicles
        for id, code in pairs(vehicle_map) do
            local vehicle_name = code:gsub("_", " "):gsub("^%l", string.upper)
            if item_name:find(vehicle_name) then
                local obj = Tracker:FindObjectForCode(code)
                if obj then obj.Active = true end
                return
            end
        end
        
        -- For machine parts by name
        for id, code in pairs(part_map) do
            local part_name = code:gsub("_", " "):gsub("^%l", string.upper)
            if item_name:find(part_name) then
                local obj = Tracker:FindObjectForCode(code)
                if obj then 
                    obj.AcquiredCount = obj.AcquiredCount + 1
                    print("Machine part counter incremented by name: " .. code .. " = " .. obj.AcquiredCount)
                end
                return
            end
        end
    end
    
    print("Unhandled item: " .. (item_name or string.format("ID=%s", item_id)))
end

-- Handle location clearing
function onLocation(location_id, location_name)
    print(string.format("Location cleared: ID=%s, Name=%s", location_id, location_name))
    
    -- Check if this location is a machine part using precise naming
    local locationInfo = MACHINE_PART_LOOKUP[location_id]
    if locationInfo then
        local partType = locationInfo.type
        local partName = locationInfo.name
        print("Found machine part location: " .. partName)
        
        -- Try to find the machine part section in the json
        local partCode = partName  -- This is the exact name from the JSON (e.g., "Clowney Island Machine Part 1")
        local obj = Tracker:FindObjectForCode(partCode)
        if obj then
            print("Found machine part section by name: " .. partCode)
            setObjectCompleted(obj)
        else
            print("WARNING: Could not find machine part section: " .. partCode)
        end
        
        -- We do NOT increment the machine part counter here anymore
        -- that happens in onItem when the player receives the actual machine part item
    end
    
    -- Try to find codes based on ID ranges
    local location_codes = {}
    
    -- Check standard location ranges
    for _, range in ipairs(LOCATION_RANGES) do
        if location_id >= range.min and location_id <= range.max then
            local letter = string.char(65 + (location_id - range.min)) -- A-L
            local code = range.prefix .. letter
            table.insert(location_codes, code)
            break
        end
    end
    
    -- Check special locations
    if SPECIAL_LOCATIONS[location_id] then
        table.insert(location_codes, SPECIAL_LOCATIONS[location_id])
    end
    
    -- Try standard location codes
    for _, code in ipairs(location_codes) do
        local obj = Tracker:FindObjectForCode(code)
        if obj then
            print("Found standard location: " .. code)
            setObjectCompleted(obj)
        end
    end
    
    -- If LOCATION_MAPPING is available, use it
    if LOCATION_MAPPING and LOCATION_MAPPING[location_id] then
        local mappedCodes = LOCATION_MAPPING[location_id]
        if type(mappedCodes) == "string" then
            -- Single string case
            local obj = Tracker:FindObjectForCode(mappedCodes)
            if obj then
                print("Found mapped location: " .. mappedCodes)
                setObjectCompleted(obj)
            end
        elseif type(mappedCodes) == "table" then
            -- Table case (path format or array)
            if mappedCodes[1] then
                for i, path in ipairs(mappedCodes) do
                    local obj = Tracker:FindObjectForCode(path)
                    if obj then
                        print("Found mapped location path: " .. path)
                        setObjectCompleted(obj)
                    end
                end
            else
                -- Handle the path structure case
                local path = "@" .. mappedCodes[1] .. "/" .. mappedCodes[2]
                local obj = Tracker:FindObjectForCode(path)
                if obj then
                    print("Found mapped location by path: " .. path)
                    setObjectCompleted(obj)
                end
            end
        end
    end
    
    -- Try direct location name as fallback
    if location_name then
        local obj = Tracker:FindObjectForCode(location_name)
        if obj then
            print("Found location by name: " .. location_name)
            setObjectCompleted(obj)
        end
    end
    
    -- Force refresh UI to ensure changes are displayed
    Tracker:UiHint("RefreshLayouts", "")
end

-- Register handlers
Archipelago:AddClearHandler("rocket_clear", onClear)
Archipelago:AddItemHandler("rocket_item", onItem)
Archipelago:AddLocationHandler("rocket_location", onLocation)

print("Rocket Robot on Wheels Archipelago integration loaded successfully")