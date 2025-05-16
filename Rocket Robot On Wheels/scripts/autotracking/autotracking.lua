-- Rocket Robot on Wheels Auto-tracking Main Script
-- Based on DKC3 tracker structure

-- Import mapping files
ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")

-- Configuration
CUR_INDEX = -1
SLOT_DATA = nil
CURRENT_LOCATION_CACHE = {}

-- Cache for previous memory values to detect changes
local PREVIOUS_VALUES = {}

-- Helper function to check if a memory value indicates "collected"
function isCollected(value)
    -- You'll need to test what value indicates collected in Rocket Robot
    -- Common patterns:
    -- return value == 0x01  -- For flags that are 1 when collected
    -- return value ~= 0x00  -- For any non-zero value
    -- return value == 0xFF  -- For flags that are 255 when collected
    
    -- Start with this and adjust based on testing
    return value ~= 0x00
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
            local world = location_data[1]
            local location_name = location_data[2]
            local tracker_name = "@" .. world .. "/" .. location_name
            
            local obj = Tracker:FindObjectForCode(tracker_name)
            if obj then
                if obj.Type == "toggle" then
                    obj.Active = true
                elseif obj.Owner then
                    -- For chest counts in regions
                    obj.Owner.AvailableChestCount = obj.Owner.AvailableChestCount - 1
                end
                
                print("Collected: " .. tracker_name)
                
                -- Update cache
                CURRENT_LOCATION_CACHE[address] = true
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
        
        local tracker_code = item_data[1]
        local item_type = item_data[2]
        
        if previous_value ~= current_value then
            local obj = Tracker:FindObjectForCode(tracker_code)
            if obj then
                if item_type == "toggle" and current_value > previous_value then
                    obj.Active = true
                    print("Got item: " .. tracker_code)
                elseif item_type == "consumable" then
                    -- For consumables, update count based on the difference
                    local difference = current_value - previous_value
                    if difference > 0 then
                        obj.AcquiredCount = obj.AcquiredCount + difference
                        print("Got " .. difference .. " " .. tracker_code)
                    end
                elseif item_type == "progressive" then
                    obj.CurrentStage = math.min(current_value, obj.NumStages)
                    print("Progressive item " .. tracker_code .. " now at stage " .. obj.CurrentStage)
                end
            end
        end
        
        PREVIOUS_VALUES[address] = current_value
    end
end

-- Main update function
function updateTracker()
    checkLocations()
    checkItems()
end

-- Clear function for new game/reset
function onClear(slot_data)
    SLOT_DATA = slot_data
    CUR_INDEX = -1
    CURRENT_LOCATION_CACHE = {}
    PREVIOUS_VALUES = {}
    
    print("Rocket Robot tracker reset")
end

-- Archipelago item handler (if using Archipelago mode)
function onItem(index, item_id, item_name, player_number)
    if index <= CUR_INDEX then return end
    
    local is_local = player_number == Archipelago.PlayerNumber
    CUR_INDEX = index
    
    -- Handle Archipelago-received items here if needed
    if is_local then
        print("Received via Archipelago: " .. item_name)
    end
end

-- Archipelago location handler
function onLocation(location_id, location_name)
    print("Location checked via Archipelago: " .. location_name)
end

-- Initialize autotracking
function init()
    print("Rocket Robot on Wheels autotracker initialized")
    
    -- Register update function to run every 100ms
    AutoTracker:SetRequestHandler(updateTracker, 100)
    
    -- Register Archipelago handlers if available
    if Archipelago then
        Archipelago:AddClearHandler("rocket_clear", onClear)
        Archipelago:AddItemHandler("rocket_item", onItem)
        Archipelago:AddLocationHandler("rocket_location", onLocation)
    end
end

-- Start the tracker
init()