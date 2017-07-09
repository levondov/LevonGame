-- generate the borders around the game

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

local M = {}

function M.createfloor()
    -- create a floor object
	local floor = display.newRect(halfW,screenH, screenW, 75 )
    floor:setFillColor(255,0,0)
    floor.myName = "floor"
    return floor
end

function M.createceil()
    -- create a ceil object
    local ceil = display.newRect(halfW,0, screenW, 75)
    ceil:setFillColor(0,255,0)
    ceil.myName = "ceil"
    return ceil
end

function M.createleftwall()
    local lwall = display.newRect(0,screenH,0,screenH)
    lwall:setFillColor(50,50,50)
    lwall.anchorX = 0
    lwall.anchorY = 1
    lwall.myName = "lwall"
    return lwall
end

function M.createrightwall()
    local rwall = display.newRect(screenW,screenH,0,screenH)
    rwall:setFillColor(50,50,50)
    rwall.anchorX = 0
    rwall.anchorY = 1
    rwall.myName = "rwall"
    return rwall
end

return M