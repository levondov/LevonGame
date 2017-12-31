-- Main script that controls the difficulty of the game by spawning platforms

M = {}

-- load modules 
local platforms = require("scripts.platforms")
local extras = require("scripts.extras")

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

-- game play timers
local gameleveltimer = timer.performWithDelay(100, function() return true end, 1)
local platformtimer = timer.performWithDelay(100, function() return true end, 1)
local extratimer = timer.performWithDelay(100, function() return true end, 1)

-- platform parameters
local platformspawntime = 1500 -- how often new platforms spawn
local platformspawns = 10 -- platform spawns per a level

-- chainsaws
local chainsawspawntime = 2000 -- how often new chainsaws spawn
local chainsawspeed = 75 -- chainsaw speed
local chainsawspawns = 10 -- how many to spawn

-- level parameters
local level = 0
local levelmax = 20 -- max level to go up to
local stagetime = 10000 -- length of each stage in ms
local startinglevelspeed = 50 -- time for platforms to transition from bottom of screen to the top in ms
local levelspeedincrease = 10 -- speed to lower transition time every level

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
    timer.cancel(extratimer)

    -- remove all existing platforms
    platforms.clearPlatforms()
    -- remove all existing extras
    extras.clearExtras()

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

    -- display current level
    genLevelText(tostring(level))
    
    -- add special levels in the if statement
    if level == 1 then
        local platformspeed = startinglevelspeed
        platformtimer = timer.performWithDelay(platformspawntime, platforms.random, platformspawns)
        platformtimer.params = {platformspeed=platformspeed,weight={1,0,0,0,0,0,0,0}}
    else
        -- increase platform speed, remove platforms off screen
        local platformspeed = startinglevelspeed + levelspeedincrease*level
        -- platforms.clearOffScreenPlatforms()
        platforms.increaseSpeedPlatforms(platformspeed)

        -- generate new platforms
        platformtimer = timer.performWithDelay(platformspawntime, platforms.random, platformspawns)
        platformtimer.params = {platformspeed=platformspeed,weight={50-level*2,20,5,20,10,5,20,20}}

        -- spawn chainsaws every x level
        if math.fmod(level, 3) == 0 then
            extratimer = timer.performWithDelay(chainsawspawntime, extras.random, chainsawspawns)
            extratimer.params = {chainsawspeed=chainsawspeed, weight={1,1,1}}
        end
    end
        
    -- next stage
    gameleveltimer = timer.performWithDelay(platformspawntime*platformspawns, M.stage, 1)
end

-- utility functions
function genLevelText(level)
    local beginText = display.newText("Level "..level,screenW/2,screenH+50,native.systemFont,32)
    transition.to(beginText, {time=5000,x=beginText.x,y=-50, onCancel=function(thistext) thistext:removeSelf() end, onComplete=function(thistext) thistext:removeSelf() end})
end



return M