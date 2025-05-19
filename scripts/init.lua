-- Rocket Robot on Wheels Tracker Initialization Override
-- This file ensures all components are correctly loaded and working

-- ===== Custom init function to ensure everything loads in the correct order =====
function customInitTracker()
    print("=============== ROCKET ROBOT ON WHEELS TRACKER INITIALIZATION =================")
    
    -- Load items and modifiers
    Tracker:AddItems("items/items.json")
    Tracker:AddItems("items/modifiers.json")
    
    -- Load maps
    Tracker:AddMaps("maps/maps.json")
    
    -- Load logic before locations to ensure logic functions are available
    print("Loading logic...")
    ScriptHost:LoadScript("scripts/logic.lua")
    
    -- Load location files in specific order
    print("Loading locations...")
    Tracker:AddLocations("locations/whoopie_world.json")
    Tracker:AddLocations("locations/clowney_island.json")
    Tracker:AddLocations("locations/paint_misbehavin.json")
    Tracker:AddLocations("locations/mine_blowing.json")
    Tracker:AddLocations("locations/arabian_flights.json")
    Tracker:AddLocations("locations/pyramid_scheme.json")
    Tracker:AddLocations("locations/food_fright.json")
    Tracker:AddLocations("locations/jojos_world.json")
    
    -- Load tracker layout
    print("Loading layouts...")
    Tracker:AddLayouts("layouts/items.json")
    Tracker:AddLayouts("layouts/tracker.json")
    
    -- Load autotracking in specific order
    print("Loading autotracking components...")
    ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")
    ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua") 
    
    -- Force load our improved Archipelago script
    print("Loading Archipelago integration...")
    ScriptHost:LoadScript("scripts/autotracking/archipelago.lua")
	
    print("Rocket Robot on Wheels tracker v1.3.1 loaded successfully!")
    print("================ INITIALIZATION COMPLETE ================")
end

-- Run the custom initialization
customInitTracker()