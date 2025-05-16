-- Rocket Robot on Wheels Item Mapping
-- Maps items to tracker codes and types

ITEM_MAPPING = {
    -- Abilities (these have locked_item in Archipelago but no address)
    -- You'll need to find memory addresses for these or track them differently
    -- ["tractor_beam_ability"] = {"tractor_beam", "toggle"},
    -- ["swing_ability"] = {"swing", "toggle"},
    -- ["slam_ability"] = {"slam", "toggle"},
    -- ["double_jump_ability"] = {"double_jump", "toggle"},
    -- ["freeze_ray_ability"] = {"freeze_ray", "toggle"},
    -- ["grapple_ability"] = {"grapple", "toggle"},
    
    -- Vehicles (these also have locked_item but no address)
    -- ["dune_dog_vehicle"] = {"dune_dog", "toggle"},
    -- ["hover_splat_vehicle"] = {"hover_splat", "toggle"},
    -- ["fin_bot_vehicle"] = {"fin_bot", "toggle"},
    -- ["beam_lift_vehicle"] = {"beam_lift", "toggle"},
    -- ["shag_flyer_vehicle"] = {"shag_flyer", "toggle"},
    -- ["glider_bike_vehicle"] = {"glider_bike", "toggle"},
    -- ["spider_rider_vehicle"] = {"spider_rider", "toggle"},
    
    -- Machine Parts (progressive counters for each world)
    -- ["clowney_machine_part"] = {"clowney_machine_parts", "consumable"},
    -- ["paint_machine_part"] = {"paint_machine_parts", "consumable"},
    -- ["mine_machine_part"] = {"mine_machine_parts", "consumable"},
    -- ["arabian_machine_part"] = {"arabian_machine_parts", "consumable"},
    -- ["pyramid_machine_part"] = {"pyramid_machine_parts", "consumable"},
    -- ["food_machine_part"] = {"food_machine_parts", "consumable"},
    
    -- Collectibles with addresses would go here
    -- Example format if you have consumable item addresses:
    -- [0x????????] = {"tickets", "consumable"},
    -- [0x????????] = {"tinker_tokens", "consumable"},
    
    -- Special items
    -- ["galaxy_2000_screws"] = {"galaxy_screws", "toggle"},
    -- ["victory"] = {"victory", "toggle"},
}

-- Settings/Slot Data Mapping (if needed for Archipelago settings)
SETTINGS_MAPPING = {
    -- Example if you have settings that affect the tracker:
    -- [0x????????] = {"goal_setting", "toggle"},
    -- [0x????????] = {"tickets_required", "consumable"},
}