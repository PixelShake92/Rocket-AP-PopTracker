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

-- Booster pack hex-to-code mapping
local BOOSTER_PACK_LOOKUP = {
    [0x05000004] = "whoopie_booster1",
    [0x05000003] = "whoopie_booster2",
    [0x05000005] = "clowney_booster",
    [0x05000001] = "paint_booster",
    [0x05000002] = "mine_booster",
    [0x05000006] = "arabian_booster",
    [0x05000007] = "pyramid_booster1",
    [0x05000008] = "pyramid_booster2",
    [0x05000000] = "food_booster"
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
    
    -- Reset abilities
    local abilities = {"tractor_beam", "throw", "swing", "slam", "double_jump", "freeze_ray", "grapple"}
    for _, ability in ipairs(abilities) do
        local obj = Tracker:FindObjectForCode(ability)
        if obj then 
            obj.Active = false 
            print("Reset " .. ability)
        else
            print("ERROR: Could not find ability object: " .. ability)
        end
    end
    
    -- Reset super abilities
    local super_abilities = {"super_grab", "super_throw", "super_swing", "super_slam", "super_double_jump", "super_freeze_ray", "super_grapple"}
    for _, ability in ipairs(super_abilities) do
        local obj = Tracker:FindObjectForCode(ability)
        if obj then 
            obj.Active = false 
            print("Reset " .. ability)
        end
    end
    
    -- Reset vehicles
    local vehicles = {"dune_dog", "hover_splat", "fin_bot", "beam_lift", "shag_flyer", "glider_bike", "spider_rider"}
    for _, vehicle in ipairs(vehicles) do
        local obj = Tracker:FindObjectForCode(vehicle)
        if obj then obj.Active = false end
    end
    
    -- Reset booster packs
    local boosters = {"whoopie_booster1", "whoopie_booster2", "clowney_booster", "paint_booster", 
                     "mine_booster", "arabian_booster", "pyramid_booster1", "pyramid_booster2", "food_booster"}
    for _, booster in ipairs(boosters) do
        local obj = Tracker:FindObjectForCode(booster)
        if obj then 
            obj.Active = false 
            print("Reset " .. booster)
        else
            print("WARNING: Could not find booster pack object: " .. booster)
        end
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
    print(string.format("=== ITEM RECEIVED ==="))
    print(string.format("ID: %s", item_id))
    print(string.format("Name: %s", item_name or "unknown"))
    print(string.format("Index: %s", index))
    print(string.format("Player: %s", player_number))
    print(string.format("==================="))
    
    -- Ticket collection - check that it's actually a ticket
    if item_id == 1 or (item_name and item_name:find("Ticket") and not item_name:find("Super") and not item_name:find("Ability")) then
        -- Make sure this is actually a ticket and not an ability with "Ticket" in the log
        if item_name and not item_name:find("Ability") and not item_name:find("Super") then
            local obj = Tracker:FindObjectForCode("tickets")
            if obj then 
                obj.AcquiredCount = obj.AcquiredCount + 1 
                print("Ticket count updated to: " .. obj.AcquiredCount)
            else
                print("ERROR: 'tickets' object not found!")
            end
            return
        end
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
    
    -- Vehicle items by ID
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
        if obj then 
            obj.Active = true
            print("Vehicle activated: " .. vehicle_map[item_id])
        end
        return
    end
    
    -- Machine part items -
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
        else
            print("ERROR: Machine part object not found: " .. part_map[item_id])
        end
        return
    end
    
    -- Super abilities by ID
    local super_ability_map = {
        [10] = "super_grab",
        [11] = "super_throw", 
        [12] = "super_swing",
        [13] = "super_slam",
        [14] = "super_double_jump",
        [15] = "super_freeze_ray",
        [16] = "super_grapple",
        [17] = "super_speed"  -- Even though we don't track it
    }
    
    if super_ability_map[item_id] then
        local code = super_ability_map[item_id]
        if code == "super_speed" then
            print("Super Speed received - no tracker item")
            return
        end
        
        local obj = Tracker:FindObjectForCode(code)
        if obj then 
            obj.Active = true 
            print("Super ability activated by ID " .. item_id .. ": " .. code)
        else
            print("ERROR: Super ability object not found: " .. code)
        end
        return
    end
    
    -- Booster packs
    local booster_map = {
        [0x05000004] = "whoopie_booster1",
        [0x05000003] = "whoopie_booster2",
        [0x05000005] = "clowney_booster",
        [0x05000001] = "paint_booster",
        [0x05000002] = "mine_booster",
        [0x05000006] = "arabian_booster",
        [0x05000007] = "pyramid_booster1",
        [0x05000008] = "pyramid_booster2",
        [0x05000000] = "food_booster"
    }
    
    if booster_map[item_id] then
        local obj = Tracker:FindObjectForCode(booster_map[item_id])
        if obj then 
            obj.Active = true 
            print("Booster pack activated: " .. booster_map[item_id])
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
    
    -- Check by name as fallback for abilities
    if item_name then
        -- Trim whitespace and normalize the name
        local normalized_name = item_name:gsub("^%s+", ""):gsub("%s+$", "")
        print("Checking ability by name: '" .. normalized_name .. "'")
        
        -- Direct ability name mapping
        if normalized_name == "Tractor Beam" or normalized_name == "tractor_beam" or normalized_name == "Tractor Beam Ability" then
            local obj = Tracker:FindObjectForCode("tractor_beam")
            if obj then 
                obj.Active = true 
                print("ACTIVATED: tractor_beam (from name: " .. normalized_name .. ")")
            else
                print("ERROR: Could not find tractor_beam object!")
            end
            return
        elseif normalized_name == "Throw" or normalized_name == "throw" or normalized_name == "Throw Ability" then
            local obj = Tracker:FindObjectForCode("throw")
            if obj then 
                obj.Active = true 
                print("ACTIVATED: throw (from name: " .. normalized_name .. ")")
            else
                print("ERROR: Could not find throw object!")
            end
            return
        elseif normalized_name == "Swing" or normalized_name == "swing" or normalized_name == "Swing Ability" then
            local obj = Tracker:FindObjectForCode("swing")
            if obj then 
                obj.Active = true 
                print("ACTIVATED: swing (from name: " .. normalized_name .. ")")
            else
                print("ERROR: Could not find swing object!")
            end
            return
        elseif normalized_name == "Slam" or normalized_name == "slam" or normalized_name == "Slam Ability" then
            local obj = Tracker:FindObjectForCode("slam")
            if obj then 
                obj.Active = true 
                print("ACTIVATED: slam (from name: " .. normalized_name .. ")")
            else
                print("ERROR: Could not find slam object!")
            end
            return
        elseif normalized_name == "Double Jump" or normalized_name == "double_jump" or normalized_name == "Double Jump Ability" then
            local obj = Tracker:FindObjectForCode("double_jump")
            if obj then 
                obj.Active = true 
                print("ACTIVATED: double_jump (from name: " .. normalized_name .. ")")
            else
                print("ERROR: Could not find double_jump object!")
            end
            return
        elseif normalized_name == "Freeze Ray" or normalized_name == "freeze_ray" or normalized_name == "Freeze Ray Ability" then
            local obj = Tracker:FindObjectForCode("freeze_ray")
            if obj then 
                obj.Active = true 
                print("ACTIVATED: freeze_ray (from name: " .. normalized_name .. ")")
            else
                print("ERROR: Could not find freeze_ray object!")
            end
            return
        elseif normalized_name == "Grapple" or normalized_name == "grapple" or normalized_name == "Grapple Ability" then
            local obj = Tracker:FindObjectForCode("grapple")
            if obj then 
                obj.Active = true 
                print("ACTIVATED: grapple (from name: " .. normalized_name .. ")")
            else
                print("ERROR: Could not find grapple object!")
            end
            return
        end
        
        print("WARNING: Ability name '" .. normalized_name .. "' did not match any known ability")
        
        -- Special handling for "Throw Ability" which should activate throw
        if item_name == "Throw Ability" or item_name == "Throw" then
            local obj = Tracker:FindObjectForCode("throw")
            if obj then 
                obj.Active = true 
                print("ACTIVATED: throw")
            else
                print("ERROR: Could not find throw object!")
            end
            return
        end
        
        -- Super abilities by name
        if item_name == "Super Grab" then
            local obj = Tracker:FindObjectForCode("super_grab")
            if obj then 
                obj.Active = true 
                print("Super ability activated by name: super_grab")
            else
                print("ERROR: Could not find super_grab object!")
            end
            return
        elseif item_name == "Super Throw" then
            local obj = Tracker:FindObjectForCode("super_throw")
            if obj then 
                obj.Active = true 
                print("Super ability activated by name: super_throw")
            else
                print("ERROR: Could not find super_throw object!")
            end
            return
        elseif item_name == "Super Swing" then
            local obj = Tracker:FindObjectForCode("super_swing")
            if obj then 
                obj.Active = true 
                print("Super ability activated by name: super_swing")
            else
                print("ERROR: Could not find super_swing object!")
            end
            return
        elseif item_name == "Super Slam" then
            local obj = Tracker:FindObjectForCode("super_slam")
            if obj then 
                obj.Active = true 
                print("Super ability activated by name: super_slam")
            else
                print("ERROR: Could not find super_slam object!")
            end
            return
        elseif item_name == "Super Jump" or item_name == "Super Double Jump" then
            local obj = Tracker:FindObjectForCode("super_double_jump")
            if obj then 
                obj.Active = true 
                print("Super ability activated by name: super_double_jump")
            else
                print("ERROR: Could not find super_double_jump object!")
            end
            return
        elseif item_name == "Super Freeze" or item_name == "Super Freeze Ray" then
            local obj = Tracker:FindObjectForCode("super_freeze_ray")
            if obj then 
                obj.Active = true 
                print("Super ability activated by name: super_freeze_ray")
            else
                print("ERROR: Could not find super_freeze_ray object!")
            end
            return
        elseif item_name == "Super Grapple" then
            local obj = Tracker:FindObjectForCode("super_grapple")
            if obj then 
                obj.Active = true 
                print("Super ability activated by name: super_grapple")
            else
                print("ERROR: Could not find super_grapple object!")
            end
            return
        elseif item_name == "Super Speed" then
            -- Super Speed doesn't have a tracker item
            print("Super Speed received - no tracker item")
            return
        end
        
        -- For vehicles by name
        for id, code in pairs(vehicle_map) do
            local vehicle_name = code:gsub("_", " "):gsub("^%l", string.upper)
            if item_name:lower():find(code:gsub("_", " ")) or item_name:lower():find(code) then
                local obj = Tracker:FindObjectForCode(code)
                if obj then 
                    obj.Active = true
                    print("Vehicle activated by name: " .. code)
                end
                return
            end
        end
        
        -- For machine parts by name
        for id, code in pairs(part_map) do
            local part_name = code:gsub("_", " "):gsub("^%l", string.upper)
            if item_name:find(part_name) or item_name:find("Machine Part") then
                -- Try to determine which machine part from the name
                if (item_name:find("Clowney") or item_name:find("clowney")) and code == "clowney_machine_part" then
                    local obj = Tracker:FindObjectForCode(code)
                    if obj then 
                        obj.AcquiredCount = obj.AcquiredCount + 1
                        print("Machine part counter incremented by name: " .. code .. " = " .. obj.AcquiredCount)
                    end
                    return
                elseif (item_name:find("Paint") or item_name:find("paint")) and code == "paint_machine_part" then
                    local obj = Tracker:FindObjectForCode(code)
                    if obj then 
                        obj.AcquiredCount = obj.AcquiredCount + 1
                        print("Machine part counter incremented by name: " .. code .. " = " .. obj.AcquiredCount)
                    end
                    return
                elseif (item_name:find("Mine") or item_name:find("mine")) and code == "mine_machine_part" then
                    local obj = Tracker:FindObjectForCode(code)
                    if obj then 
                        obj.AcquiredCount = obj.AcquiredCount + 1
                        print("Machine part counter incremented by name: " .. code .. " = " .. obj.AcquiredCount)
                    end
                    return
                elseif (item_name:find("Arabian") or item_name:find("arabian")) and code == "arabian_machine_part" then
                    local obj = Tracker:FindObjectForCode(code)
                    if obj then 
                        obj.AcquiredCount = obj.AcquiredCount + 1
                        print("Machine part counter incremented by name: " .. code .. " = " .. obj.AcquiredCount)
                    end
                    return
                elseif (item_name:find("Pyramid") or item_name:find("pyramid")) and code == "pyramid_machine_part" then
                    local obj = Tracker:FindObjectForCode(code)
                    if obj then 
                        obj.AcquiredCount = obj.AcquiredCount + 1
                        print("Machine part counter incremented by name: " .. code .. " = " .. obj.AcquiredCount)
                    end
                    return
                elseif (item_name:find("Food") or item_name:find("food")) and code == "food_machine_part" then
                    local obj = Tracker:FindObjectForCode(code)
                    if obj then 
                        obj.AcquiredCount = obj.AcquiredCount + 1
                        print("Machine part counter incremented by name: " .. code .. " = " .. obj.AcquiredCount)
                    end
                    return
                end
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
        local partCode = partName  -- This is the exact name from the JSON
        local obj = Tracker:FindObjectForCode(partCode)
        if obj then
            print("Found machine part section by name: " .. partCode)
            setObjectCompleted(obj)
        else
            print("WARNING: Could not find machine part section: " .. partCode)
        end
        
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
    
    -- If LOCATION_MAPPING is available, use it (this handles booster packs too)
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
