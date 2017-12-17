-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"

-- include hi score
local score = require("scripts.scores")

--------------------------------------------

-- forward declarations and other locals
local playBtn

-- 'onRelease' event listener for playBtn
local function onPlayBtnRelease()
    
	-- go to level1.lua scene
    composer.removeScene("gameover")
	composer.gotoScene( "levels.world", "fade", 500 )
	
	return true	-- indicates successful touch
end

function scene:create( event )
	local sceneGroup = self.view

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.
    
    -- basic screen info
    local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

	-- display a background image
	local background = display.newRect(0,0, display.actualContentWidth, display.actualContentHeight )
    background:setFillColor(0.5)
	background.anchorX = 0
	background.anchorY = 0
	background.x = 0 + display.screenOriginX 
	background.y = 0 + display.screenOriginY
	
	-- create/position logo/title image on upper-half of the screen
	--local titleLogo = display.newImageRect( "logo.png", 264, 42 )
	--titleLogo.x = display.contentCenterX
	--titleLogo.y = 100
    
    -- create game over text
    local txtbox = display.newText("Game Over",screenW/2,screenH/4,native.systemFont,36)
    
    -- create hi score text
    local hiscore = display.newText("Hiscore: " .. score.getscore(),screenW/2,screenH/3,native.systemFont,36)
	
	-- create a widget button (which will loads level1.lua on release)
	playBtn = widget.newButton{
		label="Play Again",
		labelColor = { default={255}, over={128} },
		default="button.png",
		over="button-over.png",
		width=154, height=40,
		onRelease = onPlayBtnRelease	-- event listener function
	}
	playBtn.x = display.contentCenterX
	playBtn.y = display.contentHeight - 125
	
	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( hiscore )
	sceneGroup:insert( playBtn )
    -- game over logo
    sceneGroup:insert( txtbox )
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
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	
	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene