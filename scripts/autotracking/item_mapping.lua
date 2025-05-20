-- Updated item_mapping.lua to better handle machine parts
ITEM_MAPPING = {
    -- Main collectibles
    [1] = {"tickets", "consumable"},    -- Ticket
    [2] = {"tinker_tokens", "consumable"}, -- Token
    
    -- Progressive abilities
    [3] = {"tractor_beam", "progressive"},   -- Tractor Beam
    [4] = {"swing", "progressive"},          -- Swing
    [5] = {"slam", "progressive"},           -- Slam
    [6] = {"double_jump", "progressive"},    -- Double Jump
    [7] = {"freeze_ray", "progressive"},     -- Freeze Ray
    [8] = {"grapple", "progressive"},        -- Grapple
    [9] = {"speed", "progressive"},          -- Speed (Super only)
    
    -- Super abilities (increment the progressive items)
    [10] = {"tractor_beam", "progressive"},  -- Super Grab - increase tractor beam stage
    [11] = {"swing", "progressive"},         -- Super Throw - increase swing stage
    [12] = {"slam", "progressive"},          -- Super Swing - increase slam stage
    [13] = {"double_jump", "progressive"},   -- Super Jump - increase double jump stage
    [14] = {"speed", "progressive"},         -- Super Speed - increase speed stage

    -- Vehicles
    [20] = {"dune_dog", "toggle"},
    [21] = {"hover_splat", "toggle"},
    [22] = {"fin_bot", "toggle"},
    [23] = {"beam_lift", "toggle"},
    [24] = {"shag_flyer", "toggle"},
    [25] = {"glider_bike", "toggle"},
    [26] = {"spider_rider", "toggle"},
    
    -- Machine Parts (mapped to memory addresses)
    -- Clowney Island Machine Parts
    [0x03010000] = {"clowney_machine_part", "consumable"},
    [0x03010001] = {"clowney_machine_part", "consumable"},
    [0x03010002] = {"clowney_machine_part", "consumable"},
    [0x03010003] = {"clowney_machine_part", "consumable"},
    [0x03010004] = {"clowney_machine_part", "consumable"},
    [0x03010005] = {"clowney_machine_part", "consumable"},
    [0x03010006] = {"clowney_machine_part", "consumable"},
    
    -- Paint Misbehavin' Machine Parts
    [0x03020000] = {"paint_machine_part", "consumable"},
    [0x03020001] = {"paint_machine_part", "consumable"},
    [0x03020002] = {"paint_machine_part", "consumable"},
    [0x03020003] = {"paint_machine_part", "consumable"},
    [0x03020004] = {"paint_machine_part", "consumable"},
    [0x03020005] = {"paint_machine_part", "consumable"},
    [0x03020006] = {"paint_machine_part", "consumable"},
    
    -- Mine Blowing Machine Parts
    [0x03030000] = {"mine_machine_part", "consumable"},
    [0x03030001] = {"mine_machine_part", "consumable"},
    [0x03030002] = {"mine_machine_part", "consumable"},
    [0x03030003] = {"mine_machine_part", "consumable"},
    [0x03030004] = {"mine_machine_part", "consumable"},
    [0x03030005] = {"mine_machine_part", "consumable"},
    [0x03030006] = {"mine_machine_part", "consumable"},
    
    -- Arabian Flights Machine Parts
    [0x03040000] = {"arabian_machine_part", "consumable"},
    [0x03040001] = {"arabian_machine_part", "consumable"},
    [0x03040002] = {"arabian_machine_part", "consumable"},
    [0x03040003] = {"arabian_machine_part", "consumable"},
    [0x03040004] = {"arabian_machine_part", "consumable"},
    [0x03040005] = {"arabian_machine_part", "consumable"},
    [0x03040006] = {"arabian_machine_part", "consumable"},
    
    -- Pyramid Scheme Machine Parts
    [0x03050000] = {"pyramid_machine_part", "consumable"},
    [0x03050001] = {"pyramid_machine_part", "consumable"},
    [0x03050002] = {"pyramid_machine_part", "consumable"},
    [0x03050003] = {"pyramid_machine_part", "consumable"},
    [0x03050004] = {"pyramid_machine_part", "consumable"},
    [0x03050005] = {"pyramid_machine_part", "consumable"},
    [0x03050006] = {"pyramid_machine_part", "consumable"},
    
    -- Food Fright Machine Parts
    [0x03060000] = {"food_machine_part", "consumable"},
    [0x03060001] = {"food_machine_part", "consumable"},
    [0x03060002] = {"food_machine_part", "consumable"},
    [0x03060003] = {"food_machine_part", "consumable"},
    [0x03060004] = {"food_machine_part", "consumable"},
    [0x03060005] = {"food_machine_part", "consumable"},
    [0x03060006] = {"food_machine_part", "consumable"},
    
    -- Legacy indices for compatibility
    [30] = {"clowney_machine_part", "consumable"},
    [31] = {"paint_machine_part", "consumable"},
    [32] = {"mine_machine_part", "consumable"},
    [33] = {"arabian_machine_part", "consumable"},
    [34] = {"pyramid_machine_part", "consumable"},
    [35] = {"food_machine_part", "consumable"},
    
    -- Special items
    [40] = {"galaxy_2000_screws", "toggle"},
    [41] = {"victory", "toggle"},
    
    -- String-based lookups for alt naming
    ["tractor_beam_ability"] = {"tractor_beam", "progressive"},
    ["swing_ability"] = {"swing", "progressive"},
    ["slam_ability"] = {"slam", "progressive"},
    ["double_jump_ability"] = {"double_jump", "progressive"},
    ["freeze_ray_ability"] = {"freeze_ray", "progressive"},
    ["grapple_ability"] = {"grapple", "progressive"},
    
    ["super_grab"] = {"tractor_beam", "progressive"},
    ["super_throw"] = {"swing", "progressive"},
    ["super_swing"] = {"slam", "progressive"},
    ["super_jump"] = {"double_jump", "progressive"},
    ["super_speed"] = {"speed", "progressive"},
    
    -- Alternate naming patterns
    ["Tractor Beam"] = {"tractor_beam", "progressive"},
    ["Swing"] = {"swing", "progressive"},
    ["Slam"] = {"slam", "progressive"},
    ["Double Jump"] = {"double_jump", "progressive"},
    ["Freeze Ray"] = {"freeze_ray", "progressive"},
    ["Grapple"] = {"grapple", "progressive"},
    ["Speed"] = {"speed", "progressive"},
    
    ["Super Grab"] = {"tractor_beam", "progressive"},
    ["Super Throw"] = {"swing", "progressive"},
    ["Super Swing"] = {"slam", "progressive"},
    ["Super Jump"] = {"double_jump", "progressive"},
    ["Super Speed"] = {"speed", "progressive"},
    
    -- Vehicles
    ["dune_dog_vehicle"] = {"dune_dog", "toggle"},
    ["hover_splat_vehicle"] = {"hover_splat", "toggle"},
    ["fin_bot_vehicle"] = {"fin_bot", "toggle"},
    ["beam_lift_vehicle"] = {"beam_lift", "toggle"},
    ["shag_flyer_vehicle"] = {"shag_flyer", "toggle"},
    ["glider_bike_vehicle"] = {"glider_bike", "toggle"},
    ["spider_rider_vehicle"] = {"spider_rider", "toggle"},
    
    -- Alternate naming patterns
    ["Dune Dog"] = {"dune_dog", "toggle"},
    ["Hover Splat"] = {"hover_splat", "toggle"},
    ["Fin Bot"] = {"fin_bot", "toggle"},
    ["Beam Lift"] = {"beam_lift", "toggle"},
    ["Shag Flyer"] = {"shag_flyer", "toggle"},
    ["Glider Bike"] = {"glider_bike", "toggle"},
    ["Spider Rider"] = {"spider_rider", "toggle"},
    
    -- Machine parts path mapping 
    ["@Clowney Island/Clowney Island Machine Part 1/Clowney Island Machine Part 1"] = {"clowney_machine_part", "consumable"},
    ["@Clowney Island/Clowney Island Machine Part 2/Clowney Island Machine Part 2"] = {"clowney_machine_part", "consumable"},
    ["@Clowney Island/Clowney Island Machine Part 3/Clowney Island Machine Part 3"] = {"clowney_machine_part", "consumable"},
    ["@Clowney Island/Clowney Island Machine Part 4/Clowney Island Machine Part 4"] = {"clowney_machine_part", "consumable"},
    ["@Clowney Island/Clowney Island Machine Part 5/Clowney Island Machine Part 5"] = {"clowney_machine_part", "consumable"},
    ["@Clowney Island/Clowney Island Machine Part 6/Clowney Island Machine Part 6"] = {"clowney_machine_part", "consumable"},
    ["@Clowney Island/Clowney Island Machine Part 7/Clowney Island Machine Part 7"] = {"clowney_machine_part", "consumable"},
    
    ["@Paint Misbehavin'/Paint Misbehavin' Machine Part 1/Paint Misbehavin' Machine Part 1"] = {"paint_machine_part", "consumable"},
    ["@Paint Misbehavin'/Paint Misbehavin' Machine Part 2/Paint Misbehavin' Machine Part 2"] = {"paint_machine_part", "consumable"},
    ["@Paint Misbehavin'/Paint Misbehavin' Machine Part 3/Paint Misbehavin' Machine Part 3"] = {"paint_machine_part", "consumable"},
    ["@Paint Misbehavin'/Paint Misbehavin' Machine Part 4/Paint Misbehavin' Machine Part 4"] = {"paint_machine_part", "consumable"},
    ["@Paint Misbehavin'/Paint Misbehavin' Machine Part 5/Paint Misbehavin' Machine Part 5"] = {"paint_machine_part", "consumable"},
    ["@Paint Misbehavin'/Paint Misbehavin' Machine Part 6/Paint Misbehavin' Machine Part 6"] = {"paint_machine_part", "consumable"},
    ["@Paint Misbehavin'/Paint Misbehavin' Machine Part 7/Paint Misbehavin' Machine Part 7"] = {"paint_machine_part", "consumable"},
    
    ["@Mine Blowing/Mine Blowing Machine Part 1/Mine Blowing Machine Part 1"] = {"mine_machine_part", "consumable"},
    ["@Mine Blowing/Mine Blowing Machine Part 2/Mine Blowing Machine Part 2"] = {"mine_machine_part", "consumable"},
    ["@Mine Blowing/Mine Blowing Machine Part 3/Mine Blowing Machine Part 3"] = {"mine_machine_part", "consumable"},
    ["@Mine Blowing/Mine Blowing Machine Part 4/Mine Blowing Machine Part 4"] = {"mine_machine_part", "consumable"},
    ["@Mine Blowing/Mine Blowing Machine Part 5/Mine Blowing Machine Part 5"] = {"mine_machine_part", "consumable"},
    ["@Mine Blowing/Mine Blowing Machine Part 6/Mine Blowing Machine Part 6"] = {"mine_machine_part", "consumable"},
    ["@Mine Blowing/Mine Blowing Machine Part 7/Mine Blowing Machine Part 7"] = {"mine_machine_part", "consumable"},
    
    ["@Arabian Flights/Arabian Flights Machine Part 1/Arabian Flights Machine Part 1"] = {"arabian_machine_part", "consumable"},
    ["@Arabian Flights/Arabian Flights Machine Part 2/Arabian Flights Machine Part 2"] = {"arabian_machine_part", "consumable"},
    ["@Arabian Flights/Arabian Flights Machine Part 3/Arabian Flights Machine Part 3"] = {"arabian_machine_part", "consumable"},
    ["@Arabian Flights/Arabian Flights Machine Part 4/Arabian Flights Machine Part 4"] = {"arabian_machine_part", "consumable"},
    ["@Arabian Flights/Arabian Flights Machine Part 5/Arabian Flights Machine Part 5"] = {"arabian_machine_part", "consumable"},
    ["@Arabian Flights/Arabian Flights Machine Part 6/Arabian Flights Machine Part 6"] = {"arabian_machine_part", "consumable"},
    ["@Arabian Flights/Arabian Flights Machine Part 7/Arabian Flights Machine Part 7"] = {"arabian_machine_part", "consumable"},
    
    ["@Pyramid Scheme/Pyramid Scheme Machine Part 1/Pyramid Scheme Machine Part 1"] = {"pyramid_machine_part", "consumable"},
    ["@Pyramid Scheme/Pyramid Scheme Machine Part 2/Pyramid Scheme Machine Part 2"] = {"pyramid_machine_part", "consumable"},
    ["@Pyramid Scheme/Pyramid Scheme Machine Part 3/Pyramid Scheme Machine Part 3"] = {"pyramid_machine_part", "consumable"},
    ["@Pyramid Scheme/Pyramid Scheme Machine Part 4/Pyramid Scheme Machine Part 4"] = {"pyramid_machine_part", "consumable"},
    ["@Pyramid Scheme/Pyramid Scheme Machine Part 5/Pyramid Scheme Machine Part 5"] = {"pyramid_machine_part", "consumable"},
    ["@Pyramid Scheme/Pyramid Scheme Machine Part 6/Pyramid Scheme Machine Part 6"] = {"pyramid_machine_part", "consumable"},
    ["@Pyramid Scheme/Pyramid Scheme Machine Part 7/Pyramid Scheme Machine Part 7"] = {"pyramid_machine_part", "consumable"},
    
    ["@Food Fright/Food Fright Machine Part 1/Food Fright Machine Part 1"] = {"food_machine_part", "consumable"},
    ["@Food Fright/Food Fright Machine Part 2/Food Fright Machine Part 2"] = {"food_machine_part", "consumable"},
    ["@Food Fright/Food Fright Machine Part 3/Food Fright Machine Part 3"] = {"food_machine_part", "consumable"},
    ["@Food Fright/Food Fright Machine Part 4/Food Fright Machine Part 4"] = {"food_machine_part", "consumable"},
    ["@Food Fright/Food Fright Machine Part 5/Food Fright Machine Part 5"] = {"food_machine_part", "consumable"},
    ["@Food Fright/Food Fright Machine Part 6/Food Fright Machine Part 6"] = {"food_machine_part", "consumable"},
    ["@Food Fright/Food Fright Machine Part 7/Food Fright Machine Part 7"] = {"food_machine_part", "consumable"},
    
    -- Machine Parts generic names
    ["clowney_machine_part"] = {"clowney_machine_part", "consumable"},
    ["paint_machine_part"] = {"paint_machine_part", "consumable"},
    ["mine_machine_part"] = {"mine_machine_part", "consumable"},
    ["arabian_machine_part"] = {"arabian_machine_part", "consumable"},
    ["pyramid_machine_part"] = {"pyramid_machine_part", "consumable"},
    ["food_machine_part"] = {"food_machine_part", "consumable"},
    
    -- Alternate naming patterns
    ["Clowney Machine Part"] = {"clowney_machine_part", "consumable"},
    ["Paint Machine Part"] = {"paint_machine_part", "consumable"},
    ["Mine Machine Part"] = {"mine_machine_part", "consumable"},
    ["Arabian Machine Part"] = {"arabian_machine_part", "consumable"},
    ["Pyramid Machine Part"] = {"pyramid_machine_part", "consumable"},
    ["Food Machine Part"] = {"food_machine_part", "consumable"},
    
    -- Collectibles
    ["ticket"] = {"tickets", "consumable"},
    ["Ticket"] = {"tickets", "consumable"},
    ["tinker_token"] = {"tinker_tokens", "consumable"},
    ["Tinker Token"] = {"tinker_tokens", "consumable"},
    ["Token"] = {"tinker_tokens", "consumable"},
    
    -- Special items
    ["galaxy_2000_screws"] = {"galaxy_2000_screws", "toggle"},
    ["Galaxy 2000 Screws"] = {"galaxy_2000_screws", "toggle"},
    ["victory"] = {"victory", "toggle"},
    ["Victory"] = {"victory", "toggle"},
    
    -- Booster Packs
    ["whoopie_booster_pack1"] = {"whoopie_booster1", "toggle"},
    ["whoopie_booster_pack2"] = {"whoopie_booster2", "toggle"},
    ["clowney_booster_pack"] = {"clowney_booster", "toggle"},
    ["paint_booster_pack"] = {"paint_booster", "toggle"},
    ["mine_booster_pack"] = {"mine_booster", "toggle"},
    ["arabian_booster_pack"] = {"arabian_booster", "toggle"},
    ["pyramid_booster_pack1"] = {"pyramid_booster1", "toggle"},
    ["pyramid_booster_pack2"] = {"pyramid_booster2", "toggle"},
    ["food_booster_pack"] = {"food_booster", "toggle"}
}

-- Helper function to get tracker code from item description
function get_tracker_code_for_item(item_description)
    if ITEM_MAPPING[item_description] then
        if type(ITEM_MAPPING[item_description]) == "string" then
            return ITEM_MAPPING[item_description]
        elseif type(ITEM_MAPPING[item_description]) == "table" then
            return ITEM_MAPPING[item_description][1]
        end
    end
    
    -- Try to extract the ID from item path format
    if item_description:match("^@[^/]+/([^/]+)/") then
        local item_name = item_description:match("^@[^/]+/([^/]+)/")
        -- Check if it's a machine part
        if item_name:find("Machine Part") then
            local level = item_description:match("^@([^/]+)/")
            if level then
                if level == "Clowney Island" then
                    return "clowney_machine_part"
                elseif level == "Paint Misbehavin'" then
                    return "paint_machine_part"
                elseif level == "Mine Blowing" then
                    return "mine_machine_part"
                elseif level == "Arabian Flights" then
                    return "arabian_machine_part"
                elseif level == "Pyramid Scheme" then
                    return "pyramid_machine_part"
                elseif level == "Food Fright" then
                    return "food_machine_part"
                end
            end
        end
    end
    
    return nil
end

-- Helper function to get item type from tracker code
function get_item_type(tracker_code)
    for _, mapping in pairs(ITEM_MAPPING) do
        if type(mapping) == "table" and mapping[1] == tracker_code then
            return mapping[2]
        end
    end
    return "toggle" -- Default to toggle
end