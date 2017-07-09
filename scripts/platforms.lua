-- holds all platform creation functions

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

local Platform={}

local platforms_list = display.newGroup();

function Platform.clearPlatforms_all()
    -- removes all platforms in platforms_list
    for i = 1, platforms_list.numChildren do
        platforms_list[1]:removeSelf()
    end
end

function Platform.clearPlatform( thisPlatform )
    -- remove platform after transisiotn
    platforms_list[1]:removeSelf()
end

-- creates the starting platform
function Platform.createPlatforms_starting(event)
    local platform = display.newImageRect("assets/platform.png", 80, 15 )
    platform.x, platform.y = screenW/2, screenH/1.5
    platform.collType = "passthrough"
    transition.to(platform, {time=10000,x=platform.x,y=-100, delay=10, onComplete=Platform.clearPlatform})
	physics.addBody( platform, "static", { bounce=0.3, friction=0.7 } )
    -- platform:applyForce(0, 50, platform.x, platform.y)
    
    -- add platform to group
    platforms_list:insert(platform)
    
end

-- creates basic platform
function Platform.createPlatforms_basic(event)
    local params = event.source.params
    
    local platform = display.newRoundedRect(0,0, 90, 15 ,5)
    platform:setFillColor(0,0,0)
    platform.x, platform.y = math.random(-10,330), screenH+50
    platform.collType = "passthrough"
    transition.to(platform, {time=params.transtime,x=platform.x,y=-100, delay=1000, onComplete=Platform.clearPlatform})
	physics.addBody( platform, "static", { bounce=0.3, friction=0.7 } )
    -- platform:applyForce(0, 50, platform.x, platform.y)
    
    -- add platform to group
    platforms_list:insert(platform)
    
end

return Platform