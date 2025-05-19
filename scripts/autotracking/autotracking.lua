-- Rocket Robot on Wheels Auto-tracking Main Script

-- Import mapping files
ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")

-- Configuration
CUR_INDEX = -1
SLOT_DATA = nil
CURRENT_LOCATION_CACHE = {}
DEBUG_ENABLED = true
lastTicketUpdate = 0
TICKET_UPDATE_INTERVAL = 5  -- seconds

-- Cache for previous memory values to detect changes
local PREVIOUS_VALUES = {}

-- Helper function for debug messages
function debugPrint(message)
    if DEBUG_ENABLED then
        print("[DEBUG] " .. message)
    end
end

-- Helper function to check if a memory value indicates "collected"
function isCollected(value)
    return value ~= 0x00
end

-- Force update ticket counter based on level ticket locations
function forceUpdateTicketCounter()
    local ticketCount = 0
    local levelPrefixes = {
        "Whoopie World", "Clowney Island", "Paint Misbehavin'", 
        "Mine Blowing", "Arabian Flights", "Pyramid Scheme", "Food Fright"
    }
    
    -- Count collected tickets
    for _, level in ipairs(levelPrefixes) do
        for letter = string.byte('A'), string.byte('L') do
            local ticketCode = string.format("@%s/%s Ticket %s/%s Ticket %s", 
                level, level, string.char(letter), level, string.char(letter))
            local obj = Tracker:FindObjectForCode(ticketCode)
            if obj and obj.Active then
                ticketCount = ticketCount + 1
                debugPrint("Found collected ticket: " .. ticketCode)
            end
        end
    }
    
    -- Update counter
    local ticketCounter = Tracker:FindObjectForCode("tickets")
    if ticketCounter then
        debugPrint("Updating ticket counter to " .. ticketCount)
        ticketCounter.AcquiredCount = ticketCount
    else
        print("ERROR: Ticket counter object not found")
    end
end

-- Check locations using memory addresses
function checkLocations()
    if not AutoTracker:HasConnection() then
        return
    end
    
    for address, location_data in pairs(LOCATION_MAPPING) do
        local current_value = AutoTracker:ReadU8(address, 0)
        local previous_value = PREVIOUS_VALUES[address] or 0
        
        -- Check if location was just collected
        if previous_value ~= current_value and isCollected(current_value) then
            if type(location_data) == "string" then
                -- It's a direct tracker code
                local obj = Tracker:FindObjectForCode(location_data)
                if obj then
                    if obj.Type == "toggle" then
                        obj.Active = true
                    elseif obj.Owner then
                        -- For chest counts in regions
                        obj.Owner.AvailableChestCount = obj.Owner.AvailableChestCount - 1
                    end
                    
                    debugPrint("Collected (direct code): " .. location_data)
                    
                    -- Update cache
                    CURRENT_LOCATION_CACHE[address] = true
                end
            elseif type(location_data) == "table" then
                if #location_data > 0 and type(location_data[1]) == "string" then
                    -- It's an array of paths or a single path
                    local path = location_data[1]
                    local obj = Tracker:FindObjectForCode(path)
                    if obj then
                        if obj.Type == "toggle" then
                            obj.Active = true
                        elseif obj.Owner then
                            obj.Owner.AvailableChestCount = obj.Owner.AvailableChestCount - 1
                        end
                        debugPrint("Collected (path): " .. path)
                    end
                    
                    -- Update cache
                    CURRENT_LOCATION_CACHE[address] = true
                end
            end
            
            -- Ticket location detection
            local location_str = ""
            if type(location_data) == "string" then
                location_str = location_data
            elseif type(location_data) == "table" and #location_data > 0 then
                location_str = location_data[1]
            end
            
            if location_str:find("Ticket") and not location_str:find("Token") then
                local ticketObj = Tracker:FindObjectForCode("tickets")
                if ticketObj then 
                    ticketObj.AcquiredCount = ticketObj.AcquiredCount + 1 
                    debugPrint("Ticket count from memory updated to: " .. ticketObj.AcquiredCount)
                end
            end
        end
        
        PREVIOUS_VALUES[address] = current_value
    end
end

-- Check items using memory addresses
function checkItems()
    if not AutoTracker:HasConnection() then
        return
    end
    
    for address, item_data in pairs(ITEM_MAPPING) do
        local current_value = AutoTracker:ReadU8(address, 0)
        local previous_value = PREVIOUS_VALUES[address] or 0
        
        if current_value ~= previous_value then
            if type(item_data) == "string" then
                -- Direct code handling
                local obj = Tracker:FindObjectForCode(item_data)
                if obj then
                    if obj.Type == "toggle" then
                        obj.Active = (current_value ~= 0)
                    elseif obj.Type == "consumable" then
                        obj.AcquiredCount = current_value
                    elseif obj.Type == "progressive" then
                        obj.CurrentStage = math.min(current_value, obj.NumStages)
                    end
                    debugPrint(string.format("Updated item %s to %s", item_data, current_value))
                end
            elseif type(item_data) == "table" then
                local tracker_code = item_data[1]
                local item_type = item_data[2]
                
                local obj = Tracker:FindObjectForCode(tracker_code)
                if obj then
                    if item_type == "toggle" and current_value > previous_value then
                        obj.Active = true
                        debugPrint("Got item: " .. tracker_code)
                    elseif item_type == "consumable" then
                        -- For consumables, update count based on the difference
                        local difference = current_value - previous_value
                        if difference > 0 then
                            obj.AcquiredCount = obj.AcquiredCount + difference
                            debugPrint("Got " .. difference .. " " .. tracker_code)
                        end
                    elseif item_type == "progressive" and current_value > previous_value then
                        -- For progressive items
                        if obj.CurrentStage ~= nil then
                            obj.CurrentStage = math.min(obj.CurrentStage + 1, obj.NumStages)
                            debugPrint("Progressive item " .. tracker_code .. " now at stage " .. obj.CurrentStage)
                        else
                            obj.Active = true
                            debugPrint("Activated " .. tracker_code .. " as non-progressive")
                        end
                    end
                end
            end
        }
        
        PREVIOUS_VALUES[address] = current_value
    end
}

-- Main update function
function updateTracker()
    local success, errorMsg = pcall(function()
        checkLocations()
        checkItems()
        
        -- Periodically force update ticket counter
        local currentTime = os.time()
        if currentTime - lastTicketUpdate > TICKET_UPDATE_INTERVAL then
            forceUpdateTicketCounter() 
            lastTicketUpdate = currentTime
        end
    end)
    
    if not success then
        print("Error updating tracker: " .. errorMsg)
    end
}

-- Clear function for new game/reset
function onClear(slot_data)
    SLOT_DATA = slot_data
    CUR_INDEX = -1
    CURRENT_LOCATION_CACHE = {}
    PREVIOUS_VALUES = {}
    
    -- Reset counters
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
    local abilities = {"tractor_beam", "swing", "slam", "double_jump", "freeze_ray", "grapple", "speed"}
    for _, ability in ipairs(abilities) do
        local obj = Tracker:FindObjectForCode(ability)
        if obj then 
            if obj.CurrentStage ~= nil then
                obj.CurrentStage = 0
                print("Reset progressive " .. ability)
            else
                obj.Active = false
                print("Reset toggle " .. ability)
            end
        end
    end
    
    print("Rocket Robot tracker reset")
}

-- Archipelago item handler (if using Archipelago mode)
function onItem(index, item_id, item_name, player_number)
    if index <= CUR_INDEX then return end
    
    local is_local = player_number == Archipelago.PlayerNumber
    CUR_INDEX = index
    
    if is_local then
        print("Received via Archipelago: " .. item_name)
        
        -- Ticket collection
        if item_id == 1 or (item_name and (item_name:find("Ticket") or item_name == "Progressive Ticket")) then
            local obj = Tracker:FindObjectForCode("tickets")
            if obj then 
                obj.AcquiredCount = obj.AcquiredCount + 1 
                print("Ticket count updated to: " .. obj.AcquiredCount)
            end
            return
        end
        
        -- Token collection
        if item_id == 2 or (item_name and (item_name:find("Token") or item_name:find("Tinker"))) then 
            local obj = Tracker:FindObjectForCode("tinker_tokens")
            if obj then obj.AcquiredCount = obj.AcquiredCount + 1 end
            return
        end
        
        -- Progressive ability items
        local ability_map = {
            -- Base abilities (stage 1)
            [3] = "tractor_beam",
            [4] = "swing",
            [5] = "slam",
            [6] = "double_jump",
            [7] = "freeze_ray",
            [8] = "grapple",
            [9] = "speed",
            
            -- Super abilities (stage 2)
            [10] = "tractor_beam",
            [11] = "swing",
            [12] = "slam",
            [13] = "double_jump",
            [14] = "speed"
        }
        
        if ability_map[item_id] then
            local code = ability_map[item_id]
            local obj = Tracker:FindObjectForCode(code)
            if obj and obj.CurrentStage ~= nil then
                if item_id >= 10 and obj.CurrentStage > 0 then
                    -- Super ability if base is unlocked
                    obj.CurrentStage = math.min(obj.CurrentStage + 1, obj.NumStages)
                    print("Progressed " .. code .. " to stage " .. obj.CurrentStage)
                elseif item_id < 10 then
                    -- Base ability
                    obj.CurrentStage = math.min(obj.CurrentStage + 1, obj.NumStages)
                    print("Progressed " .. code .. " to stage " .. obj.CurrentStage)
                end
            elseif obj then
                obj.Active = true
                print("Activated " .. code)
            end
            return
        end
    }
}

-- Archipelago location handler
function onLocation(location_id, location_name)
    print("Location checked via Archipelago: " .. location_name)
    
    -- Handle tickets 
    if location_name and location_name:find("Ticket") and not location_name:find("Token") then
        local ticketObj = Tracker:FindObjectForCode("tickets")
        if ticketObj then 
            ticketObj.AcquiredCount = ticketObj.AcquiredCount + 1 
            print("Ticket count from AP location updated to: " .. ticketObj.AcquiredCount)
        end
    }
    
    -- Force update ticket counter
    forceUpdateTicketCounter()
}

-- Initialize autotracking
function init()
    print("Rocket Robot on Wheels autotracker initialized")
    
    -- Register update function to run every 100ms
    AutoTracker:SetRequestHandler(updateTracker, 100)
    
    -- Initialize counters
    local ticketObj = Tracker:FindObjectForCode("tickets")
    if ticketObj then 
        print("Ticket counter found with value: " .. ticketObj.AcquiredCount)
    else
        print("ERROR: 'tickets' object not found!")
    end
    
    -- Force a ticket counter update
    forceUpdateTicketCounter()
    
    -- Register Archipelago handlers if available
    if Archipelago then
        Archipelago:AddClearHandler("rocket_clear", onClear)
        Archipelago:AddItemHandler("rocket_item", onItem)
        Archipelago:AddLocationHandler("rocket_location", onLocation)
    }
}

-- Start the tracker
init()