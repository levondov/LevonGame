-- Main script that controls the difficulty of the game by spawning platforms

M = {}

-- load modules 
local platforms = require("scripts.platforms")

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

-- game play parameters
local gameleveltimer = timer.performWithDelay(100, function() return true end, 1)
local platformtimer = timer.performWithDelay(100, function() return true end, 1)
local platformspawntime = 1000 -- how often new platforms spawn
local level = 0
local levelmax = 19 -- max level to go up to
local stagetime = 10000 -- length of each stage in ms
local startinglevelspeed = 10000 -- time for platforms to transition from bottom of screen to the top in ms
local levelspeedincrease = 500 -- speed to lower transition time every level

function M.start()
    -- starts the game 
    
    -- create starting platform
    platforms.starting()
    
    -- start stage
    M.stage()
    
end

function M.stop()
    -- stop the game

    -- remove game timer and current platform timer
    timer.cancel(gameleveltimer)
    timer.cancel(platformtimer)
    
    -- remove all existing platforms still on the screen
    transition.cancel()
    
    -- reset level
    level = 0
end

-- game stage
function M.stage()
    -- new level
    if level < levelmax then
        level = level + 1
    end
    
    -- add special levels in the if statement
    if level == 1 then
        local beginText = display.newText("Level 1",screenW/2,screenH+50,native.systemFont,32)
        transition.to(beginText, {time=5000,x=beginText.x,y=-100, onCancel=function(thistext) thistext:removeSelf() end, onComplete=function(thistext) thistext:removeSelf() end})
        
        local levelspeed = 10000
        platformtimer = timer.performWithDelay(platformspawntime, platforms.random, math.floor(stagetime/750))
        platformtimer.params = {transtime=levelspeed,numPlatforms=4,weight={1,0,0,0,0,0,0,0}}
    else
        local beginText = display.newText("Level "..level,screenW/2,screenH+50,native.systemFont,32)
        transition.to(beginText, {time=5000,x=beginText.x,y=-100 ,onCancel=function(thistext) thistext:removeSelf() end, onComplete=function(thistext) thistext:removeSelf() end})
        local levelspeed = startinglevelspeed - levelspeedincrease*level
        platformtimer = timer.performWithDelay(platformspawntime, platforms.random, math.floor(stagetime/750))
        platformtimer.params = {transtime=levelspeed,numPlatforms=4,weight={50-level*2,20,5,20,10,5,20,20}}
    end
        
    -- next stage
    gameleveltimer = timer.performWithDelay(stagetime+platformspawntime/2, M.stage, 1)
end





return M