-- builds characters

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

local M = {}

function M.createHero()
    -- make a crate (off-screen), position it, and rotate slightly
    local crate = display.newImageRect( "assets/crate.png", 45, 45 )
    crate.x, crate.y = screenW/2, screenH/4
    crate.myName = "Hero"

    -- add physics to the crate
    physics.addBody( crate, { density=1.0, friction=0.1, bounce=0.1 } )
    crate.isFixedRotation = true -- no spinning
    
    return crate
end

return M