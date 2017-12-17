-----------------------------------------------------------------------------------------
--
-- world.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"

-- include multitouch 
system.activate( "multitouch" )

-- load modules 
local game = require("levels.game")
local character = require("scripts.characters")
local borders = require("scripts.borders")
local score = require("scripts.scores")

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

-- End game 
local function onFireCollision(event)
   if (event.phase == "began") then
        if (event.other.myName == "floor" or event.other.myName == "ceil") then
            composer.gotoScene( "gameover", "fade", 300 ) 
        end
    end
end

-- cleanup objects
local function destroyObjs(group)
    -- removes all objects in group
    for i = 1, group.numChildren do
        group[1]:removeSelf()
    end
end

-- movement timers
-- add even for touching the background
local moveTimer = timer.performWithDelay(10, function() return true end, 1)
local touchx0,touchy0,touchid = 0,0,nil

local function moveEvent(event)
    if (touchx0 < screenW/2) then
        crate.x = crate.x - 4
    elseif (touchx0 >= screenW/2) then
        crate.x = crate.x + 4
    end
end
local function onBackgroundTouch(event)
    -- setup new timer
    if (event.phase == "began") then
        timer.cancel(moveTimer)
        touchx0,touchy0,touchid = event.x,event.y,event.id
        moveTimer = timer.performWithDelay(10,moveEvent,0)
    elseif (event.phase == "ended" and touchid == event.id) then
        timer.cancel(moveTimer)
    end
end

function scene:create( event )

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view

	-- We need physics started to add bodies, but we don't want the simulaton
	-- running until the scene is on the screen.
	physics.start()
    physics.pause()

    -- create a grey rectangle as the backdrop
	-- the physical screen will likely be a different shape than our defined content area
	-- since we are going to position the background from it's top, left corner, draw the
	-- background at the real top, left corner.
	local background = display.newRect( display.screenOriginX, display.screenOriginY, screenW, screenH )
	background.anchorX = 0 
	background.anchorY = 0
    background.myName = "background"
	background:setFillColor( .5 )
    
    
    -------Floor and Ceiling--------------------------------------------------------    
    local floor = borders.createfloor()
	physics.addBody( floor, "static", { friction=0.3} )
    
    local ceil = borders.createceil()
    physics.addBody( ceil, "static", { friction=0.3} )
    
    local lwall = borders.createleftwall()
    physics.addBody(lwall, "static", {friction=0.3})
    
    local rwall = borders.createrightwall()
    physics.addBody(rwall, "static", {friction=0.3})
    
    ----------------------------------------------------------------------------- 
    
    -- create character
    crate = character.createHero()
    
    -- create hiscores text
    local hiscores = score.getscoreText()
    
    -- add event listeners
    crate:addEventListener("collision", onFireCollision)
    background:addEventListener("touch", onBackgroundTouch)
    
	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( floor)
    sceneGroup:insert( ceil )
    sceneGroup:insert( lwall )
    sceneGroup:insert( rwall )
    sceneGroup:insert(hiscores)
    sceneGroup:insert( crate )
end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
    
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
        
        -- setup scoring system
        score.start()
        
        -- start the game
        game.start()
        
		physics.start()
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
        
        -- stop scoring
        score.stop()
        
        -- stop movement
        timer.cancel(moveTimer)
        
        -- stop game
        game.stop()

        --physics.stop()
	elseif phase == "did" then
		-- Called when the scene is now off screen
        composer.removeScene("levels.world")
	end
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view

    -- remove all objects
    destroyObjs(sceneGroup)
	
	package.loaded[physics] = nil
	physics = nil
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene