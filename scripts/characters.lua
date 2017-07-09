-- builds characters

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

local M = {}

local function createHero()
    -- make a crate (off-screen), position it, and rotate slightly
    local crate = display.newImageRect( "assets/crate.png", 45, 45 )
    crate.x, crate.y = screenW/2, screenH/4
    crate.myName = "Hero"

    -- add physics to the crate
    physics.addBody( crate, { density=20.0, friction=0.1, bounce=0.3 } )
    crate.isFixedRotation = true -- no spinning
    
    return crate
end

M.createHero = createHero

return M