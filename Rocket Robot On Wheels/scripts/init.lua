-- Initialize Rocket Robot on Wheels Tracker
print("Loading Rocket Robot on Wheels Pop Tracker...")

-- Load items and modifiers
Tracker:AddItems("items/items.json")
Tracker:AddItems("items/modifiers.json")

-- Load maps
Tracker:AddMaps("maps/maps.json")

-- Load logic
ScriptHost:LoadScript("scripts/logic.lua")

-- Load layouts
Tracker:AddLayouts("layouts/items.json")

-- Load locations
ScriptHost:LoadScript("scripts/loadlocations.lua")

-- Load autotracking (if needed for the future)
-- ScriptHost:LoadScript("scripts/autotracking.lua")

-- Load tracker layout
Tracker:AddLayouts("layouts/tracker.json")

print("Rocket Robot on Wheels tracker loaded successfully!")