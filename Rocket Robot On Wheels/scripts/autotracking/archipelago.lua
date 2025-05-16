---@diagnostic disable: lowercase-global
-- Load Rocket Robot specific mapping files
ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua")

CUR_INDEX = -1
SLOT_DATA = nil
LOCAL_ITEMS = {}
GLOBAL_ITEMS = {}

-- Debug settings
AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP = true
AUTOTRACKER_ENABLE_ITEM_TRACKING = true
AUTOTRACKER_ENABLE_LOCATION_TRACKING = true

function onClear(slot_data)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onClear, slot_data:\n%s", dump_table(slot_data)))
    end
    SLOT_DATA = slot_data
    CUR_INDEX = -1
    
    -- Reset locations
    for _, location_data in pairs(LOCATION_MAPPING) do
        if location_data then
            local obj = Tracker:FindObjectForCode(location_data[1])
            if obj then
                if location_data[1]:sub(1, 1) == "@" then
                    obj.AvailableChestCount = obj.ChestCount
                else
                    obj.Active = false
                end
            end
        end
    end
    
    -- Reset items
    for _, v in pairs(ITEM_MAPPING) do
        if v[1] and v[2] then
            if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: clearing item %s of type %s", v[1], v[2]))
            end
            local obj = Tracker:FindObjectForCode(v[1])
            if obj then
                if v[2] == "toggle" then
                    obj.Active = false
                elseif v[2] == "progressive" then
                    obj.CurrentStage = 0
                    obj.Active = false
                elseif v[2] == "consumable" then
                    obj.AcquiredCount = 0
                elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                    print(string.format("onClear: unknown item type %s for code %s", v[2], v[1]))
                end
            elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: could not find object for code %s", v[1]))
            end
        end
    end

    PLAYER_NUMBER = Archipelago.PlayerNumber or -1
    TEAM_NUMBER = Archipelago.TeamNumber or 0

    LOCAL_ITEMS = {}
    GLOBAL_ITEMS = {}

    -- Read Rocket Robot specific slot data settings (if any)
    local function setFromSlotData(slot_data_key, item_code)
        local v = slot_data[slot_data_key]
        if not v then
            print(string.format("Could not find key '%s' in slot data", slot_data_key))
            return nil
        end

        local obj = Tracker:FindObjectForCode(item_code)
        if not obj then
            print(string.format("Could not find item for code '%s'", item_code))
            return nil
        end

        if obj.Type == 'toggle' then
            local active = v ~= 0
            obj.Active = active
            return v
        elseif obj.Type == 'progressive' then
            obj.CurrentStage = v
            return v
        elseif obj.Type == 'consumable' then
            obj.AcquiredCount = v
            return v
        else
            print(string.format("Unsupported item type '%s' for item '%s'", tostring(obj.Type), item_code))
            return nil
        end
    end

    -- Add Rocket Robot specific settings here as needed
end

-- Called when an item gets collected
function onItem(index, item_id, item_name, player_number)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onItem: %s, %s, %s, %s, %s", index, item_id, item_name, player_number, CUR_INDEX))
    end
    if not AUTOTRACKER_ENABLE_ITEM_TRACKING then
        return
    end
    if index <= CUR_INDEX then
        return
    end
    local is_local = player_number == Archipelago.PlayerNumber
    CUR_INDEX = index
    
    local v = ITEM_MAPPING[item_id]
    if not v then
        if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("onItem: could not find item mapping for id %s", item_id))
        end
        return
    end
    
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onItem: code: %s, type %s", v[1], v[2]))
    end
    
    if not v[1] then
        return
    end
    
    local obj = Tracker:FindObjectForCode(v[1])
    if obj then
        if v[2] == "toggle" then
            obj.Active = true
        elseif v[2] == "progressive" then
            if obj.Active then
                obj.CurrentStage = obj.CurrentStage + 1
            else
                obj.Active = true
            end
        elseif v[2] == "consumable" then
            obj.AcquiredCount = obj.AcquiredCount + obj.Increment
        elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("onItem: unknown item type %s for code %s", v[2], v[1]))
        end
    elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onItem: could not find object for code %s", v[1]))
    end
end

-- Called when a location gets cleared
function onLocation(location_id, location_name)
    local location_data = LOCATION_MAPPING[location_id]
    if not location_data then
        print(string.format("onLocation: could not find location mapping for id %s", location_id))
        return
    end

    local obj = Tracker:FindObjectForCode(location_data[1])
    if obj then
        if location_data[1]:sub(1, 1) == "@" then
            obj.AvailableChestCount = obj.AvailableChestCount - 1
        else
            obj.Active = true
        end
    else
        print(string.format("onLocation: could not find object for code %s", location_data[1]))
    end
end

-- Called when a locations is scouted
function onScout(location_id, location_name, item_id, item_name, item_player)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onScout: %s, %s, %s, %s, %s", location_id, location_name, item_id, item_name,
            item_player))
    end
    -- Not implemented yet
end

-- Called when a bounce message is received 
function onBounce(json)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onBounce: %s", dump_table(json)))
    end
    -- Your code goes here
end

-- Register Archipelago handlers
Archipelago:AddClearHandler("rocket_clear_handler", onClear)
Archipelago:AddItemHandler("rocket_item_handler", onItem)
Archipelago:AddLocationHandler("rocket_location_handler", onLocation)
Archipelago:AddScoutHandler("rocket_scout_handler", onScout)
-- Archipelago:AddBounceHandler("rocket_bounce_handler", onBounce)