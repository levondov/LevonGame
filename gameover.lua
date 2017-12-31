-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local json = require( "json" )

local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"

-- include hi score
local score = require("scripts.scores")

--------------------------------------------

-- forward declarations and other locals
local playBtn
local hiscoreField

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
	local background = display.newImageRect( "assets/background1.png", display.actualContentWidth, display.actualContentHeight )
	background:setFillColor(0.5)
	background.anchorX = 0
	background.anchorY = 0
	background.x = 0 + display.screenOriginX 
	background.y = 0 + display.screenOriginY
	
	-- create/position logo/title image on upper-half of the screen
	--local titleLogo = display.newImageRect( "logo.png", 264, 42 )
	--titleLogo.x = display.contentCenterX
	--titleLogo.y = 100

	-- function to generate leaderboards
	local function networkListener( event )
    	if ( event.isError ) then
        	print( "Network error: ", event.response )
        	local txtranklst = display.newText("Error loading high scores", screenW/2, screenH/3 + 80,native.systemFont,24)
        	sceneGroup:insert( txtranklst )
    	else
    		-- create leaderboard shape
    		local txtrankbox = display.newRoundedRect(screenW/2,screenH/1.5, screenW-75, screenH/3+80, 12 )
    		txtrankbox:setFillColor( 0, 0 )
    		txtrankbox.strokeWidth = 5
    		txtrankbox:setStrokeColor(1,1,0)
    		sceneGroup:insert( txtrankbox )
    		local decoded, pos, msg = json.decode( event.response )
    	    for i = 0, table.getn(decoded) do
    	    	local ypos = screenH/3 + 100 + 20*i
    	    	local txtrank
    	    	local txtrank2
    	    	if i > 0 then
    	    		txtrank = "   "..decoded[i].rank.."        "..decoded[i].name
    	    		txtrank2 = decoded[i].score
    	    	else
    	    		txtrank = "Rank       Player"
    	    		txtrank2 = "Score"
    	    	end
    	    	local options = 
    	    	{
    	    		text = txtrank,
    	    		x = screenW/2,
    	    		y = ypos,
    	    		width = screenW-100,
    	    		font = native.systemFont,
    	    		fontSize = 16,
    	    		align = 'left'
	    	    }
	    		local options2 = 
    	    	{
    	    		text = txtrank2,
    	    		x = screenW/2,
    	    		y = ypos,
    	    		width = screenW-100,
    	    		font = native.systemFont,
    	    		fontSize = 16,
    	    		align = 'right'
	    	    }
    	    	local txtranklst = display.newText( options )
    	    	local txtranklst2 = display.newText( options2 )
    	    	sceneGroup:insert( txtranklst )
    	    	sceneGroup:insert( txtranklst2 )
    	    end
    	end
	end
	-- after submitting a hiscore, generate leaderboards
	local function networkListener2( event )
		if (event.phase == "ended") then
    		-- load highscores
			network.request( "http://13.56.160.42:8000/highscores10/", "GET", networkListener )
		end
	end
	-- after user enters name, submit hiscore
	local function textListener (event)
		if ( event.phase == "ended" or event.phase == "submitted" ) then
			-- submit highscore
			hiscoreField:removeSelf()
			hiscoreField = nil
			local sysinfo = system.getInfo("deviceID")
			local params = {}
			params.body = "player_id="..sysinfo.."&player_name="..event.target.text.."&score="..score.getscore()
			network.request( "http://13.56.160.42:8000/registration/", "POST", networkListener2, params)
		end
	end

	-- Create text field
	hiscoreField = native.newTextField( screenW/2, screenH/2, 180, 30 )
	hiscoreField:addEventListener( "userInput", textListener )
	sceneGroup:insert( hiscoreField )
    -- create game over text
    local txtbox = display.newText("Game Over",screenW/2,screenH/5,native.systemFont,36)
    
    -- create hi score text
    local score = display.newText("Score: " .. score.getscore(),screenW/2,screenH/4,native.systemFont,36)
    local hiscore = display.newText("Leaderboards ",screenW/2,screenH/2.5,native.systemFont,42)
    hiscore:setFillColor(1,1,0)
	
	
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
	playBtn.y = display.contentHeight - 25
	
	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( hiscore )
	sceneGroup:insert( playBtn )
	sceneGroup:insert( score )
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
	if hiscoreField ~= nil then
		hiscoreField:removeSelf()
	end
	
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