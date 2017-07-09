-- Main script that controls the difficulty of the game by spawning platforms

M = {}

-- load modules 
local platforms = require("scripts.platforms")

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

-- group for all platform timers
local platforms_timer = {}
local gameleveltimer = timer.performWithDelay(100, function() return true end, 1)

function M.start()
    -- starts the game 
    
    -- create starting platform
    platforms.createPlatforms_starting()
    
    -- start level 1
    M.stage1()
    
    local stage = "stage"
    local level = 1
    local total_levels = 6
    
    local function nextStage()
        -- every x seconds, it will stop current platforms and start the next stage by calling a stage function, e.g. "stage2"
        M.clearTimers_all()
        level = level + 1
        newstage = stage .. level
        M[newstage]()
    end
    
    -- each stage lasts 30 seconds
    -- will start with stage 2
    gameleveltimer = timer.performWithDelay(15000, nextStage, total_levels-1)
end

function M.stop()
    -- stop the game
    
    -- remove paltform timers
    M.clearTimers_all()

    -- remove game timer
    timer.cancel(gameleveltimer)
    
    -- remove all existing platforms still on the screen
    transition.cancel()
    platforms.clearPlatforms_all()
end

function M.clearTimers_all()
    -- removes all platforms in platforms_list
    for k, v in pairs(platforms_timer) do
        timer.cancel(v)
    end
end

----------------------------- GAME STAGES ----------------------------------------
----------------------------------------------------------------------------------

function M.stage1()
    -- stage 1, just regular platforms
    
    tm = timer.performWithDelay(750, platforms.createPlatforms_basic, 0)
    tm.params = {transtime=8000}
    platforms_timer[#platforms_timer+1]=tm
end


function M.stage2()
    -- stage 2, regular platforms spawning slower, same speed as stage 1
    tm = timer.performWithDelay(1000, platforms.createPlatforms_basic, 0)
    tm.params = {transtime=8000}
    platforms_timer[#platforms_timer+1]=tm
end

function M.stage3()
    -- stage 3, regular platforms, spawn even slower, moving a bit faster
    tm = timer.performWithDelay(1250, platforms.createPlatforms_basic, 0)
    tm.params = {transtime=7000}
    platforms_timer[#platforms_timer+1]=tm
end

function M.stage4()
    -- stage 4, regular platforms, moving a bit faster
    tm = timer.performWithDelay(1250, platforms.createPlatforms_basic, 0)
    tm.params = {transtime=5000}
    platforms_timer[#platforms_timer+1]=tm
end 

function M.stage5()
    -- stage 5, regular platforms, spawn even slower
    tm = timer.performWithDelay(1500, platforms.createPlatforms_basic, 0)
    tm.params = {transtime=5000}
    platforms_timer[#platforms_timer+1]=tm
end

function M.stage6()
    -- stage 5, regular platforms, spawn even slower
    tm = timer.performWithDelay(2000, platforms.createPlatforms_basic, 0)
    tm.params = {transtime=4000}
    platforms_timer[#platforms_timer+1]=tm
end 









return M