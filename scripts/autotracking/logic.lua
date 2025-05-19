-- Base ability checks matching Rules.py
function has(item)
    return Tracker:ProviderCountForCode(item) > 0
end

function hasCount(item, amount)
    local count = Tracker:ProviderCountForCode(item)
    return count >= amount
end

function hasTickets(count)
    return hasCount("tickets", count)
end

function hasTinkerTokens(count)
    return hasCount("tinker_tokens", count)
end

function hasBeam()
    return has("tractor_beam") and has("throw")
end

function hasSwing()
    return has("tractor_beam") and has("swing")
end

function hasSlam()
    return has("slam")
end

function canSlam()
    return has("tractor_beam") and hasSlam()
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

-- Vehicle checks
function hasVehicle(vehicle)
    return has(vehicle .. "_vehicle")
end

-- Machine part checks (default to 7)
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

function hasGalaxy2000Screws()
    return has("galaxy_2000_screws")
end

-- Level access checks matching Rules.py
function canAccessLevel(level)
    if level == "Clowney Island" then
        return hasTickets(1)
    elseif level == "Paint Misbehavin'" then
        return hasTickets(1) and canSlam()
    elseif level == "Mine Blowing" then
        return hasTickets(15) and hasDoubleJump()
    elseif level == "Arabian Flights" then
        return hasTickets(25) and hasFreezeRay()
    elseif level == "Pyramid Scheme" then
        return hasTickets(40) and canGrappleSwing()
    elseif level == "Food Fright" then
        return hasTickets(40) and canGrappleSwing()
    elseif level == "Jojo's World" then
        return hasTickets(65)
    end
    return false
end

-- Sub-area access checks matching Rules.py
function canAccessSubArea(area)
    if area == "Whoopie World Outside" then
        return true
    elseif area == "Whoopie World Entrance Hall" then
        return hasTickets(1)
    elseif area == "Whoopie World Lobby" then
        return hasTickets(1) and canSlam()
    elseif area == "Whoopie World Raccoon Mouth" then
        return hasTickets(1) and canSlam() and hasSwing()
    elseif area == "Whoopie World Mine" then
        return canAccessLevel("Mine Blowing")
    elseif area == "Whoopie World Cloud Top" then
        return canAccessLevel("Arabian Flights")
    elseif area == "Whoopie World Screw Towers" then
        return canAccessSubArea("Whoopie World Cloud Top")
    elseif area == "Whoopie World Upper Level" then
        return hasTickets(40) and canGrappleSwing()
    elseif area == "Whoopie World Tumblers" then
        return canAccessSubArea("Whoopie World Upper Level") and canGrappleSwing() and hasDoubleJump()
    -- Clowney Island areas
    elseif area == "Clowney Island Exterior" then
        return canAccessLevel("Clowney Island")
    elseif area == "Clowney Island Bee-Ware" then
        return canAccessLevel("Clowney Island")
    elseif area == "Clowney Island Midway" then
        return canAccessLevel("Clowney Island")
    elseif area == "Clowney Island Dinosaur" then
        return canAccessLevel("Clowney Island") and hasClowneyMachineParts()
    elseif area == "Clowney Island Top of Dinosaur" then
        return canAccessSubArea("Clowney Island Dinosaur") and hasSwing()
    -- Paint Misbehavin' areas
    elseif area == "Paint Misbehavin' Ruins" then
        return canAccessLevel("Paint Misbehavin'")
    elseif area == "Paint Misbehavin' Guard Area" then
        return canAccessSubArea("Paint Misbehavin' Ruins") and (hasSwing() or hasVehicle("hover_splat"))
    elseif area == "Paint Misbehavin' Gallery" then
        return canAccessSubArea("Paint Misbehavin' Ruins") and hasVehicle("hover_splat")
    elseif area == "Paint Misbehavin' River Near Side" then
        return canAccessSubArea("Paint Misbehavin' Ruins") and canSlam() and (hasSwing() or hasVehicle("hover_splat"))
    elseif area == "Paint Misbehavin' River Far Side" then
        return canAccessSubArea("Paint Misbehavin' River Near Side") and (hasSwing() or hasDoubleJump() or hasFreezeRay())
    elseif area == "Paint Misbehavin' Upper Level" then
        return canAccessSubArea("Paint Misbehavin' River Far Side") and hasSwing() and (hasBeam() or hasDoubleJump())
    elseif area == "Paint Misbehavin' Aqueduct" then
        return canAccessSubArea("Paint Misbehavin' River Near Side") and hasPaintMachineParts() and hasVehicle("fin_bot")
    -- Mine Blowing areas
    elseif area == "Mine Blowing Main Shaft" then
        return canAccessLevel("Mine Blowing") and hasBeam()
    elseif area == "Mine Blowing Storage" then
        return canAccessSubArea("Mine Blowing Main Shaft")
    elseif area == "Mine Blowing Mushroom Cave" then
        return canAccessSubArea("Mine Blowing Main Shaft")
    elseif area == "Mine Blowing Gemstones" then
        return canAccessSubArea("Mine Blowing Storage")
    elseif area == "Mine Blowing Upper Level" then
        return canAccessSubArea("Mine Blowing Storage") and hasBeam()
    elseif area == "Mine Blowing Switch Area" then
        return canAccessSubArea("Mine Blowing Upper Level") and (hasSwing() or hasDoubleJump())
    elseif area == "Mine Blowing Mine Carts" then
        return canAccessSubArea("Mine Blowing Upper Level")
    elseif area == "Mine Blowing Lower Level" then
        return canAccessSubArea("Mine Blowing Switch Area") and hasBeam()
    elseif area == "Mine Blowing Rolling Rocks" then
        return canAccessSubArea("Mine Blowing Lower Level")
    elseif area == "Mine Blowing Machine Area" then
        return hasDoubleJump() and hasMineMachineParts()
    -- Arabian Flights areas
    elseif area == "Arabian Flights Purple Palace" then
        return canAccessLevel("Arabian Flights")
    elseif area == "Arabian Flights Exterior" then
        return canAccessLevel("Arabian Flights") and hasVehicle("shag_flyer")
    elseif area == "Arabian Flights Water" then
        return canAccessSubArea("Arabian Flights Exterior") and hasBeam()
    elseif area == "Arabian Flights Magnets" then
        return canAccessSubArea("Arabian Flights Exterior")
    elseif area == "Arabian Flights Wind" then
        return canAccessSubArea("Arabian Flights Exterior") and hasArabianMachineParts()
    -- Pyramid Scheme areas
    elseif area == "Pyramid Scheme Day" then
        return canAccessLevel("Pyramid Scheme")
    elseif area == "Pyramid Scheme Machine Room" then
        return canAccessLevel("Pyramid Scheme")
    elseif area == "Pyramid Scheme Night" then
        return canAccessLevel("Pyramid Scheme") and hasPyramidMachineParts()
    elseif area == "Pyramid Scheme Sundial Day" then
        return canAccessLevel("Pyramid Scheme") and hasSwing()
    elseif area == "Pyramid Scheme Rising Lava" then
        return canAccessSubArea("Pyramid Scheme Night") and hasDoubleJump()
    elseif area == "Pyramid Scheme Sundial Night" then
        return canAccessSubArea("Pyramid Scheme Night")
    elseif area == "Pyramid Scheme Lava Cave" then
        return canAccessSubArea("Pyramid Scheme Night") and hasVehicle("glider_bike")
    elseif area == "Pyramid Scheme Pillars Night" then
        return canAccessSubArea("Pyramid Scheme Night")
    elseif area == "Pyramid Scheme Pillars Day" then
        return canAccessSubArea("Pyramid Scheme Night")
    -- Food Fright areas
    elseif area == "Food Fright First Level Floor" then
        return canAccessLevel("Food Fright")
    elseif area == "Food Fright First Level Webs" then
        return canAccessLevel("Food Fright") and hasFoodMachineParts() and hasSwing()
    elseif area == "Food Fright Second Level Floor" then
        return canAccessSubArea("Food Fright First Level Webs") and canGrappleSwing()
    elseif area == "Food Fright Troll" then
        return canAccessSubArea("Food Fright Second Level Floor")
    elseif area == "Food Fright Second Level Upper" then
        return canAccessSubArea("Food Fright Second Level Floor") and canGrappleSwing()
    elseif area == "Food Fright Third Level" then
        return canAccessSubArea("Food Fright Second Level Upper") and hasSwing() and hasDoubleJump()
    elseif area == "Food Fright Monster" then
        return canAccessSubArea("Food Fright Third Level") and hasBeam() and hasVehicle("spider_rider")
    -- Jojo's World
    elseif area == "Jojo's World" then
        return canAccessLevel("Jojo's World")
    end
    return false
end

-- Final boss check
function canDefeatJojo()
    return hasSlam() and hasDoubleJump() and hasFreezeRay() and hasGrapple() and hasTickets(65)
end