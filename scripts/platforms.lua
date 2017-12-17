-- holds all platform creation functions

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

-- load modules 
local utility = require("scripts.utilities")

local Platform={}

function Platform.clearPlatform( thisPlatform )
    -- remove platform after transistion
    thisPlatform:removeSelf()
end

-- creates a random platform
function Platform.random(event)
    local params = event.source.params
    
    -- currently: Platforms
    -- 1=basic
    -- 2=disappearing
    -- 3=disappearing_spinning
    -- 4=jumping
    -- 5=spinning
    -- 6=falling
    -- 7=slowingleft
    -- 8=slowingright
    -- see utilities.weighted_choice for more details
    local weighted_table = params.weight
    
    -- call weighted distribution function to pick a table
    local chosen = utility.weighted_choice(weighted_table)
    
    if chosen == 1 then
        Platform.basic(event)
    elseif chosen == 2 then
        Platform.disappearing(event)
    elseif chosen == 3 then
        Platform.disappearing_spinning(event)
    elseif chosen == 4 then
        Platform.jumping(event)
    elseif chosen == 5 then
        Platform.spinning(event)
    elseif chosen == 6 then
        Platform.falling(event)
    elseif chosen == 7 then
        Platform.slowingleft(event)
    elseif chosen == 8 then
        Platform.slowingright(event)
    end
    
end

------------------------------------ PLATFORMS --------------------------------------------
-------------------------------------------------------------------------------------------

-- creates the starting platform
function Platform.starting(event)
    local platform = display.newImageRect("assets/platform.png", 80, 15 )
    platform.x, platform.y = screenW/2, screenH/1.5
    platform.myName = "starting"
    platform.collType = "passthrough"
    transition.to(platform, {time=10000,x=platform.x,y=-100, delay=10, onComplete=Platform.clearPlatform, onCancel=Platform.clearPlatform})
	physics.addBody( platform, "static", { bounce=0.3, friction=0.7 } )
end

-- creates basic platform
function Platform.basic(event)
    local params = event.source.params
    
    local platform = display.newRoundedRect(0,0, 90, 15 ,5)
    platform:setFillColor(0,0,0)
    platform.x, platform.y = math.random(-10,330), screenH+50
    platform.myName = "basic"
    platform.collType = "passthrough"
    transition.to(platform, {time=params.transtime,x=platform.x,y=-100, delay=1000, onComplete=Platform.clearPlatform, onCancel=Platform.clearPlatform})
	physics.addBody( platform, "static", { bounce=0.0, friction=0.7 } )
end

-- creates a disapearing platform
function Platform.disappearing(event)
    local params = event.source.params
    
    -- creates blinking of the platform by setting the alpha (opacity)
    local blinkingFlag = 0
    local function blinking(event)
        local params = event.source.params
        if blinkingFlag == 0 then
            params.platform.alpha = 0
            blinkingFlag = 1
        elseif blinkingFlag == 1 then
            params.platform.alpha = 1
            blinkingFlag = 0
        end
    end
    
    -- removes the platform from the game  
    local function removePlatform(event)
        local params = event.source.params
        -- cancel the transition and remove the object
        transition.cancel(params.platform)
    end
        
    -- collision event when the hero lands on the platform
    local function onCollision(event) 
        if (event.phase == "began") then
            if (event.other.myName == "Hero" and event.target.y > event.other.y) then
                -- start blinking for 0.8 second
                temp1 = timer.performWithDelay(100, blinking, 5)
                temp1.params = {platform=event.target}
                
                -- after 0.8 second remove the platform
                temp2 = timer.performWithDelay(500, removePlatform, 1)
                temp2.params = {platform=event.target}
            end
        end
    end
    
    local platform = display.newRoundedRect(0,0, 90, 15 ,5)
    platform:setFillColor(0,255,200)
    platform.x, platform.y = math.random(-10,330), screenH+50
    platform.myName = "disappearing"
    platform.collType = "passthrough"
    transition.to(platform, {time=params.transtime,x=platform.x,y=-100, delay=1000, onComplete=Platform.clearPlatform,onCancel=Platform.clearPlatform})
	physics.addBody( platform, "static", { bounce=0.0, friction=0.7 } )
    
    -- add event listeners
    platform:addEventListener("collision", onCollision)
end

-- creates a jumping platform
function Platform.jumping(event)
    local params = event.source.params
    
    -- collision event when the hero lands on the platform
    local function onCollision(event)
        if (event.other.myName == "Hero") then
            if (event.target.y > event.other.y) then
                -- only bounce if hero is on top of the platform, not below it
                event.other:setLinearVelocity(0,-250)
            end
        end
    end
    
    local platform = display.newRoundedRect(0,0, 90, 15 ,5)
    platform:setFillColor(1,1,0)
    platform.x, platform.y = math.random(-10,330), screenH+50
    platform.myName = "jumping"
    platform.collType = "passthrough"
    transition.to(platform, {time=params.transtime,x=platform.x,y=-100, delay=1000, onComplete=Platform.clearPlatform,onCancel=Platform.clearPlatform})
	physics.addBody( platform, "static", { bounce=0.0, friction=0.7 } )
    
    -- add event listeners
    platform:addEventListener("collision", onCollision)
end

-- creates a spinning platform
function Platform.spinning(event)
    local params = event.source.params
    
    local platform = display.newRoundedRect(0,0, 90, 15 ,5)
    platform:setFillColor(0,0,0)
    platform.x, platform.y = math.random(-10,330), screenH+50
    platform.myName = "spinning"
    platform.collType = "passthrough"
    transition.to(platform, {time=params.transtime,x=platform.x,y=-100, delay=1000, onComplete=Platform.clearPlatform,onCancel=Platform.clearPlatform})
    transition.to(platform, {time=params.transtime,rotation=360, delay=1000})
	physics.addBody( platform, "static", { bounce=0.0, friction=0.7 } )
    
end

-- creates a falling platform
function Platform.falling(event)
    local params = event.source.params
    
    local vertices = { 0,0, 90,0, 75,15, 60,7.5, 45,15, 30,7.5, 15,15, }
    local platform = display.newPolygon(0,0,vertices)
    platform:setFillColor(1,0,1)
    platform.x, platform.y = math.random(-10,330), -50
    platform.myName = "falling"
    platform.collType = "passthrough"
    transition.to(platform, {time=params.transtime,x=platform.x,y=screenH+50, delay=1000, onComplete=Platform.clearPlatform,onCancel=Platform.clearPlatform})
	physics.addBody( platform, "static", { bounce=0.0, friction=0.7 } )
end

-- creates a disapearing spinning platform
function Platform.disappearing_spinning(event)
    local params = event.source.params
    
    -- creates blinking of the platform by setting the alpha (opacity)
    local blinkingFlag = 0
    local function blinking(event)
        local params = event.source.params
        if blinkingFlag == 0 then
            params.platform.alpha = 0
            blinkingFlag = 1
        elseif blinkingFlag == 1 then
            params.platform.alpha = 1
            blinkingFlag = 0
        end
    end
    
    -- removes the platform from the game  
    local function removePlatform(event)
        local params = event.source.params
        -- cancel the transition and remove the object
        transition.cancel(params.platform)
    end
        
    -- collision event when the hero lands on the platform
    local function onCollision(event) 
        if (event.phase == "began") then
            if (event.other.myName == "Hero" and event.target.y > event.other.y) then
                -- start blinking for 0.8 second
                temp1 = timer.performWithDelay(100, blinking, 5)
                temp1.params = {platform=event.target}
                
                -- after 0.8 second remove the platform
                temp2 = timer.performWithDelay(500, removePlatform, 1)
                temp2.params = {platform=event.target}
            end
        end
    end
    
    local platform = display.newRoundedRect(0,0, 90, 15 ,5)
    platform:setFillColor(0,255,200)
    platform.x, platform.y = math.random(-10,330), screenH+50
    platform.myName = "disappearing_spinning"
    platform.collType = "passthrough"
    transition.to(platform, {time=params.transtime,x=platform.x,y=-100, delay=1000, onComplete=Platform.clearPlatform,onCancel=Platform.clearPlatform})
    transition.to(platform, {time=params.transtime,rotation=360, delay=1000})
	physics.addBody( platform, "static", { bounce=0.0, friction=0.7 } )
    
    -- add event listeners
    platform:addEventListener("collision", onCollision)
end

function Platform.slowingleft(event)
    local params = event.source.params
    
    -- collision event when the hero lands on the platform
    function moveEvent(event)
        local params = event.source.params
        crate = params.crate
        if crate.x ~= nill then
            crate.x = crate.x + 3
        end
    end
    local pushtimer
    local function onCollision(event)
        print(event.phase)
        if (event.phase == "began") then
            if (event.other.myName == "Hero") then
                pushtimer = timer.performWithDelay(1000/60, moveEvent, 0)
                pushtimer.params = {crate=event.other}
            end
        else
            if (event.other.myName == "Hero") then
                timer.cancel(pushtimer)
            end
        end
    end
    
    local platform = display.newRoundedRect(0,0, 90, 15 ,5)
    platform:setFillColor(0,1,0)
    platform.x, platform.y = math.random(-10,330), screenH+50
    platform.myName = "slowing"
    platform.collType = "passthrough"
    transition.to(platform, {time=params.transtime,x=platform.x,y=-100, delay=1000, onComplete=Platform.clearPlatform, onCancel=Platform.clearPlatform})
	physics.addBody( platform, "static", { bounce=0.0, friction=50 } )  
    
    -- add event listeners
    platform:addEventListener("collision", onCollision)
end

function Platform.slowingright(event)
    local params = event.source.params
    
    -- collision event when the hero lands on the platform
    function moveEvent(event)
        local params = event.source.params
        crate = params.crate
        if crate.x ~= nill then
            crate.x = crate.x - 3
        end
    end
    local pushtimer
    local function onCollision(event)
        print(event.phase)
        if (event.phase == "began") then
            if (event.other.myName == "Hero") then
                pushtimer = timer.performWithDelay(1000/60, moveEvent, 0)
                pushtimer.params = {crate=event.other}
            end
        else
            if (event.other.myName == "Hero") then
                timer.cancel(pushtimer)
            end
        end
    end
    
    local platform = display.newRoundedRect(0,0, 90, 15 ,5)
    platform:setFillColor(0,1,0)
    platform.x, platform.y = math.random(-10,330), screenH+50
    platform.myName = "slowing"
    platform.collType = "passthrough"
    transition.to(platform, {time=params.transtime,x=platform.x,y=-100, delay=1000, onComplete=Platform.clearPlatform, onCancel=Platform.clearPlatform})
	physics.addBody( platform, "static", { bounce=0.0, friction=50 } )  
    
    -- add event listeners
    platform:addEventListener("collision", onCollision)
end

return Platform