-- holds all platform creation functions

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

-- load modules 
local utility = require("scripts.utilities")

local Platform={}

local platformlist = {}
local platformcount = 1

function Platform.clearPlatforms()
    -- remove existing platforms
    for i = 1, #platformlist do
        Runtime:removeEventListener("enterFrame", platformlist[i])
        platformlist[i]:removeSelf()
    end

    -- reset variables for new game
    platformlist = {}
    platformcount = 1
end

function removePlatform (platform)
    platformlist[platform.pos] = nil
    platformcount = platformcount-1
    for i=platform.pos+1, #platformlist do
        platformlist[i-1] = platformlist[i]
        platformlist[i-1].pos = i-1
    end
    -- remove last entry in table
    table.remove(platformlist)
end

function onEnterFrame(self, event)
    if self.y < -15 or self.y > screenH+60 then
        Runtime:removeEventListener("enterFrame", self)
        removePlatform(self)
        self:removeSelf()
    end
end


function Platform.increaseSpeedPlatforms(newspeed)
    -- increase speed of all platforms in platform list
    for i = 1, #platformlist do
        if platformlist[i].myName == 'falling' then
            platformlist[i]:setLinearVelocity(0,newspeed)
        else
            platformlist[i]:setLinearVelocity(0,-1*newspeed)
        end
    end
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

    -- add to physics 
    physics.addBody( platform, "kinematic", { bounce=0.3, friction=0.7 } )
    platform.gravityScale = 0
    platform:setLinearVelocity(0,-1*50)

    -- add runtime event to remove platform
    platform.enterFrame = onEnterFrame
    Runtime:addEventListener("enterFrame", platform)
    
    -- add to platform list
    platform.pos = platformcount
    platformlist[platformcount] = platform
    platformcount = platformcount+1

end

-- creates basic platform
function Platform.basic(event)
    local params = event.source.params
    local platform = display.newImageRect( "assets/platform_main.png", 90, 15 )
    platform.x, platform.y = math.random(-10,330), screenH+50
    platform.myName = "basic"
    platform.collType = "passthrough"

    -- add to physics
    physics.addBody( platform, "kinematic", { bounce=0.1, friction=0.7 } )
    platform.gravityScale = 0
    platform:setLinearVelocity(0,-1*params.platformspeed)

    -- add runtime event to remove platform
    platform.enterFrame = onEnterFrame
    Runtime:addEventListener("enterFrame", platform)
    
    -- add to platform list
    platform.pos = platformcount
    platformlist[platformcount] = platform
    platformcount = platformcount+1    
end

-- creates a disapearing platform
function Platform.disappearing(event)
    local params = event.source.params
    
    -- removes the platform from the game  
    local function removePlatform2(event)
        local params = event.source.params
        -- put platform off screen, will be removed later
        params.platform.y = -50
    end
        
    -- collision event when the hero lands on the platform
    local function onCollision(event) 
        if (event.phase == "began") then
            if (event.other.myName == "Hero" and event.target.y > event.other.y) then
                -- start blinking for 0.8 second
                transition.blink(event.target, {time=800})
                
                -- after 0.8 second remove the platform
                temp2 = timer.performWithDelay(800, removePlatform2, 1)
                temp2.params = {platform=event.target}
            end
        end
    end
    
    local platform = display.newImageRect( "assets/platform_disappearing.png", 90, 15 )
    platform.x, platform.y = math.random(-10,330), screenH+50
    platform.myName = "disappearing"
    platform.collType = "passthrough"

    -- add to physics 
    physics.addBody( platform, "kinematic", { bounce=0.1, friction=0.7 } )
    platform.gravityScale = 0
    platform:setLinearVelocity(0,-1*params.platformspeed)
    -- add event listeners
    platform:addEventListener("collision", onCollision)

    -- add runtime event to remove platform
    platform.enterFrame = onEnterFrame
    Runtime:addEventListener("enterFrame", platform)
    
    -- add to platform list
    platform.pos = platformcount
    platformlist[platformcount] = platform
    platformcount = platformcount+1    
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
    
    local platform = display.newImageRect( "assets/platform_jumping.png", 90, 15 )
    platform.x, platform.y = math.random(-10,330), screenH+50
    platform.myName = "jumping"
    platform.collType = "passthrough"

    -- add to physics 
    physics.addBody( platform, "kinematic", { bounce=0.1, friction=0.7 } )
    platform.gravityScale = 0
    platform:setLinearVelocity(0,-1*params.platformspeed)
    -- add event listeners
    platform:addEventListener("collision", onCollision)

    -- add runtime event to remove platform
    platform.enterFrame = onEnterFrame
    Runtime:addEventListener("enterFrame", platform)
    
    -- add to platform list
    platform.pos = platformcount
    platformlist[platformcount] = platform
    platformcount = platformcount+1    
end

-- creates a spinning platform
function Platform.spinning(event)
    local params = event.source.params
    
    local platform = display.newImageRect( "assets/platform_main.png", 90, 15 )
    platform.x, platform.y = math.random(-10,330), screenH+50
    platform.myName = "spinning"
    platform.collType = "passthrough"

    -- add to physics 
    physics.addBody( platform, "kinematic", { bounce=0.1, friction=0.7 } )
    platform.gravityScale = 0
    platform:setLinearVelocity(0,-1*params.platformspeed)
    platform.angularVelocity = 50

    -- add runtime event to remove platform
    platform.enterFrame = onEnterFrame
    Runtime:addEventListener("enterFrame", platform)
    
    -- add to platform list
    platform.pos = platformcount
    platformlist[platformcount] = platform
    platformcount = platformcount+1    
    
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

    -- add to physics 
    physics.addBody( platform, "kinematic", { bounce=0.1, friction=0.7 } )
    platform.gravityScale = 0
    platform:setLinearVelocity(0,params.platformspeed)

    -- add runtime event to remove platform
    platform.enterFrame = onEnterFrame
    Runtime:addEventListener("enterFrame", platform)
    
    -- add to platform list
    platform.pos = platformcount
    platformlist[platformcount] = platform
    platformcount = platformcount+1    
end

-- creates a disapearing spinning platform
function Platform.disappearing_spinning(event)
    local params = event.source.params
    
    -- removes the platform from the game  
    local function removePlatform2(event)
        local params = event.source.params
        -- put platform off screen, will be removed later
        params.platform.y = -50
    end
        
    -- collision event when the hero lands on the platform
    local function onCollision(event) 
        if (event.phase == "began") then
            if (event.other.myName == "Hero" and event.target.y > event.other.y) then
                -- start blinking for 0.8 second
                transition.blink(event.target, {time=800})
                
                -- after 0.8 second remove the platform
                temp2 = timer.performWithDelay(800, removePlatform2, 1)
                temp2.params = {platform=event.target}
            end
        end
    end
    
    local platform = display.newImageRect( "assets/platform_disappearing.png", 90, 15 )
    platform.x, platform.y = math.random(-10,330), screenH+50
    platform.myName = "disappearing_spinning"
    platform.collType = "passthrough"

    -- add to physics 
    physics.addBody( platform, "kinematic", { bounce=0.1, friction=0.7 } )
    platform.gravityScale = 0
    platform:setLinearVelocity(0,-1*params.platformspeed)
    platform.angularVelocity = 50

    -- add event listeners
    platform:addEventListener("collision", onCollision)

    -- add runtime event to remove platform
    platform.enterFrame = onEnterFrame
    Runtime:addEventListener("enterFrame", platform)
    
    -- add to platform list
    platform.pos = platformcount
    platformlist[platformcount] = platform
    platformcount = platformcount+1    
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
    
    local platform = display.newImageRect( "assets/platform_moving.png", 90, 15 )
    platform.x, platform.y = math.random(-10,330), screenH+50
    platform.myName = "slowing"
    platform.collType = "passthrough"

    -- add to physics 
    physics.addBody( platform, "kinematic", { bounce=0.1, friction=0.7 } )
    platform.gravityScale = 0
    platform:setLinearVelocity(0,-1*params.platformspeed)

    -- add event listeners
    platform:addEventListener("collision", onCollision)

    -- add runtime event to remove platform
    platform.enterFrame = onEnterFrame
    Runtime:addEventListener("enterFrame", platform)
    
    -- add to platform list
    platform.pos = platformcount
    platformlist[platformcount] = platform
    platformcount = platformcount+1    
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
    
    local platform = display.newImageRect( "assets/platform_moving.png", 90, 15 )
    platform.x, platform.y = math.random(-10,330), screenH+50
    platform.myName = "slowing"
    platform.collType = "passthrough"

    -- add to physics 
    physics.addBody( platform, "kinematic", { bounce=0.1, friction=0.7 } )
    platform.gravityScale = 0
    platform:setLinearVelocity(0,-1*params.platformspeed)

    -- add event listeners
    platform:addEventListener("collision", onCollision)

    -- add runtime event to remove platform
    platform.enterFrame = onEnterFrame
    Runtime:addEventListener("enterFrame", platform)
    
    -- add to platform list
    platform.pos = platformcount
    platformlist[platformcount] = platform
    platformcount = platformcount+1    
end

return Platform