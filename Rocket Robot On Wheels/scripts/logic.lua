-- Rocket Robot on Wheels Tracker Logic Functions

-- Check if player has an item
function has(item)
    return Tracker:ProviderCountForCode(item) > 0
end

-- Check if player has all items in a list
function hasAll(items)
    for _, item in ipairs(items) do
        if not has(item) then 
            return false 
        end
    end
    return true
end

-- Check if player has any item in a list
function hasAny(items)
    for _, item in ipairs(items) do
        if has(item) then 
            return true 
        end
    end
    return false
end

-- Check if enough tickets have been collected
function hasTickets(count)
    local tickets = Tracker:ProviderCountForCode("tickets")
    return tickets >= count
end

-- Check if required item count is reached
function hasCount(item, amount)
    local count = Tracker:ProviderCountForCode(item)
    return count >= amount
end

-- Ability checks
function hasTractorBeam()
    return has("tractor_beam")
end

function hasSwing()
    return has("swing")
end

function hasSlam()
    return has("slam")
end

function canSlam()
    return hasTractorBeam() and hasSlam()
end

function hasDoubleJump()
    return has("double_jump")
end

function hasFreezeRay()
    return has("freeze_ray")
end

function hasGrapple()
    return has("grapple")
end

function canGrappleSwing()
    return hasSwing() and hasGrapple()
end

-- Machine part checks
function hasClowneyMachineParts(count)
    if count == nil then count = 7 end
    return hasCount("clowney_machine_part", count)
end

function hasPaintMachineParts(count)
    if count == nil then count = 7 end
    return hasCount("paint_machine_part", count)
end

function hasMineMachineParts(count)
    if count == nil then count = 7 end
    return hasCount("mine_machine_part", count)
end

function hasArabianMachineParts(count)
    if count == nil then count = 7 end
    return hasCount("arabian_machine_part", count)
end

function hasPyramidMachineParts(count)
    if count == nil then count = 7 end
    return hasCount("pyramid_machine_part", count)
end

function hasFoodMachineParts(count)
    if count == nil then count = 7 end
    return hasCount("food_machine_part", count)
end

-- Vehicle checks
function hasVehicle(vehicle)
    return has(vehicle)
end

-- Special item checks
function hasGalaxy2000Screws()
    return has("galaxy_2000_screws")
end

-- Tinker Token check (simplified version)
function hasTinkerTokens(count)
    local tokens = Tracker:ProviderCountForCode("tinker_tokens")
    return tokens >= count
end

-- Check if a level can be accessed
function canAccessLevel(level)
    if level == "clowney_island" then
        return hasTickets(1)
    elseif level == "paint_misbehavin" then
        return hasTickets(1) and canSlam()
    elseif level == "mine_blowing" then
        return hasTickets(15) and hasDoubleJump()
    elseif level == "arabian_flights" then
        return hasTickets(25) and hasFreezeRay()
    elseif level == "pyramid_scheme" then
        return hasTickets(40) and canGrappleSwing()
    elseif level == "food_fright" then
        return hasTickets(40) and canGrappleSwing()
    elseif level == "jojos_world" then
        return hasTickets(65)
    end
    return false
end

-- Check if a sub-area can be accessed
function canAccessSubArea(area)
    if area == "whoopie_outside" then
        return true
    elseif area == "whoopie_entrance" or area == "whoopie_entrance_hall" then
        return hasTickets(1)
    elseif area == "whoopie_lobby" then
        return hasTickets(1) and canSlam()
    elseif area == "whoopie_raccoon_mouth" then
        return hasTickets(1) and canSlam() and hasSwing()
    elseif area == "whoopie_mine" then
        return hasTickets(15) and hasDoubleJump()
    elseif area == "whoopie_cloud_top" then
        return hasTickets(25) and hasFreezeRay()
    elseif area == "whoopie_screw_towers" then
        return hasTickets(25) and hasFreezeRay()
    elseif area == "whoopie_upper_level" then
        return hasTickets(40) and canGrappleSwing()
    elseif area == "whoopie_tumblers" then
        return hasTickets(40) and canGrappleSwing() and hasDoubleJump()
    -- Clowney Island areas
    elseif area == "clowney_exterior" then
        return hasTickets(1)
    elseif area == "clowney_midway" then
        return hasTickets(1)
    elseif area == "clowney_bee_ware" then
        return hasTickets(1)
    elseif area == "clowney_dinosaur" then
        return hasTickets(1) and hasClowneyMachineParts(7)
    elseif area == "clowney_top_dinosaur" then
        return hasTickets(1) and hasClowneyMachineParts(7) and hasSwing()
    -- Paint Misbehavin' areas
    elseif area == "paint_ruins" then
        return hasTickets(1) and canSlam()
    elseif area == "paint_guard_area" then
        return hasTickets(1) and canSlam() and (hasSwing() or hasVehicle("hover_splat"))
    elseif area == "paint_gallery" then
        return hasTickets(1) and canSlam() and hasVehicle("hover_splat")
    elseif area == "paint_river_near" then
        return hasTickets(1) and canSlam() and (hasSwing() or hasVehicle("hover_splat"))
    elseif area == "paint_river_far" then
        return hasTickets(1) and canSlam() and (hasSwing() or hasVehicle("hover_splat")) and (hasSwing() or hasDoubleJump() or hasFreezeRay())
    elseif area == "paint_upper" then
        return hasTickets(1) and canSlam() and hasSwing() and (hasTractorBeam() or hasDoubleJump())
    elseif area == "paint_aqueduct" then
        return hasTickets(1) and canSlam() and hasPaintMachineParts(7) and hasVehicle("fin_bot")
    -- Mine Blowing areas
    elseif area == "mine_main_shaft" then
        return hasTickets(15) and hasDoubleJump() and hasTractorBeam()
    elseif area == "mine_storage" then
        return hasTickets(15) and hasDoubleJump() and hasTractorBeam()
    elseif area == "mine_mushroom_cave" then
        return hasTickets(15) and hasDoubleJump() and hasTractorBeam()
    elseif area == "mine_gemstones" then
        return hasTickets(15) and hasDoubleJump() and hasTractorBeam()
    elseif area == "mine_upper" then
        return hasTickets(15) and hasDoubleJump() and hasTractorBeam()
    elseif area == "mine_switch_area" then
        return hasTickets(15) and hasDoubleJump() and hasTractorBeam() and (hasSwing() or hasDoubleJump())
    elseif area == "mine_mine_carts" then
        return hasTickets(15) and hasDoubleJump() and hasTractorBeam()
    elseif area == "mine_lower" then
        return hasTickets(15) and hasDoubleJump() and hasTractorBeam()
    elseif area == "mine_rolling_rocks" then
        return hasTickets(15) and hasDoubleJump() and hasTractorBeam()
    elseif area == "mine_machine_area" then
        return hasMineMachineParts(7) and hasDoubleJump()
    -- Arabian Flights areas
    elseif area == "arabian_palace" then
        return hasTickets(25) and hasFreezeRay()
    elseif area == "arabian_exterior" then
        return hasTickets(25) and hasFreezeRay() and hasVehicle("shag_flyer")
    elseif area == "arabian_water" then
        return hasTickets(25) and hasFreezeRay() and hasVehicle("shag_flyer") and hasTractorBeam()
    elseif area == "arabian_magnets" then
        return hasTickets(25) and hasFreezeRay() and hasVehicle("shag_flyer")
    elseif area == "arabian_wind" then
        return hasTickets(25) and hasFreezeRay() and hasVehicle("shag_flyer") and hasArabianMachineParts(7)
    -- Pyramid Scheme areas
    elseif area == "pyramid_day" then
        return hasTickets(40) and canGrappleSwing()
    elseif area == "pyramid_machine_room" then
        return hasTickets(40) and canGrappleSwing()
    elseif area == "pyramid_night" then
        return hasTickets(40) and canGrappleSwing() and hasPyramidMachineParts(7)
    elseif area == "pyramid_sundial_day" then
        return hasTickets(40) and canGrappleSwing() and hasSwing()
    elseif area == "pyramid_rising_lava" then
        return hasTickets(40) and canGrappleSwing() and hasPyramidMachineParts(7) and hasDoubleJump()
    elseif area == "pyramid_sundial_night" then
        return hasTickets(40) and canGrappleSwing() and hasPyramidMachineParts(7)
    elseif area == "pyramid_lava_cave" then
        return hasTickets(40) and canGrappleSwing() and hasPyramidMachineParts(7) and hasVehicle("glider_bike")
    elseif area == "pyramid_pillars_night" then
        return hasTickets(40) and canGrappleSwing() and hasPyramidMachineParts(7)
    elseif area == "pyramid_pillars_day" then
        return hasTickets(40) and canGrappleSwing() and hasPyramidMachineParts(7)
    -- Food Fright areas
    elseif area == "food_first_floor" then
        return hasTickets(40) and canGrappleSwing()
    elseif area == "food_first_webs" then
        return hasTickets(40) and canGrappleSwing() and hasFoodMachineParts(7) and hasSwing()
    elseif area == "food_second_floor" then
        return hasTickets(40) and canGrappleSwing() and hasFoodMachineParts(7) and hasSwing()
    elseif area == "food_troll" then
        return hasTickets(40) and canGrappleSwing() and hasFoodMachineParts(7) and hasSwing()
    elseif area == "food_second_upper" then
        return hasTickets(40) and canGrappleSwing() and hasFoodMachineParts(7) and hasSwing()
    elseif area == "food_third" then
        return hasTickets(40) and canGrappleSwing() and hasFoodMachineParts(7) and hasSwing() and hasDoubleJump()
    elseif area == "food_monster" then
        return hasTickets(40) and canGrappleSwing() and hasFoodMachineParts(7) and hasSwing() and hasDoubleJump() and hasTractorBeam() and hasVehicle("spider_rider")
    -- Jojo's World
    elseif area == "jojos_world" then
        return hasTickets(65)
    end
    return false
end

-- Final boss check
function canDefeatJojo()
    return canSlam() and hasDoubleJump() and hasFreezeRay() and hasGrapple() and hasTickets(65)
end

print("Rocket Robot on Wheels logic functions loaded")