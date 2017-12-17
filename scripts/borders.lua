-- generate the borders around the game

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

local M = {}

function M.createfloor()
    -- create a floor object
	local floor = display.newRect(halfW,screenH, screenW, 75 )
    floor:setFillColor(1,0,0)
    floor.myName = "floor"
    return floor
end

function M.createceil()
    -- create a ceil object
    local ceil = display.newRect(halfW,0, screenW, 75)
    ceil:setFillColor(1,0,0)
    ceil.myName = "ceil"
    function moveUp(ceiling)
        transition.to(ceiling, {time=1000,x=halfW,y=-40, onComplete=moveDown,onCancel=function(thistext) thistext:removeSelf() end})
    end
    function moveDown(ceiling)
        transition.to(ceiling, {time=1000,x=halfW,y=0, onComplete=moveUp,onCancel=function(thistext) thistext:removeSelf() end})
    end
    transition.to(ceil, {time=1000,x=halfW,y=-40, onComplete=moveDown,onCancel=function(thistext) thistext:removeSelf() end})
    return ceil
end

function M.createleftwall()
    local lwall = display.newRect(0,screenH,5,screenH)
    lwall:setFillColor(50/255,50/255,50/255)
    lwall.anchorX = 0
    lwall.anchorY = 1
    lwall.myName = "lwall"
    return lwall
end

function M.createrightwall()
    local rwall = display.newRect(screenW-5,screenH,5,screenH)
    rwall:setFillColor(50/255,50/255,50/255)
    rwall.anchorX = 0
    rwall.anchorY = 1
    rwall.myName = "rwall"
    return rwall
end

return M