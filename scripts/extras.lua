-- holds all extra creation functions

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

-- load modules 
local utility = require("scripts.utilities")

local Extras={}

local extraslist = {}
local extraslistpos = 1

function Extras.clearExtras( thisextra )
    for i=1,#extraslist do
        if extraslist[i].myName == "chainsaw" then
            Runtime:removeEventListener("enterFrame", extraslist[i])
        end
        extraslist[i]:removeSelf()
    end
    extraslist = {}
    extraslistpos = 1
end

function removeExtra (extra)
    extraslist[extra.pos] = nil
    extraslistpos = extraslistpos-1
    for i=extra.pos+1, #extraslist do
        extraslist[i-1] = extraslist[i]
        extraslist[i-1].pos = i-1
    end
    -- remove last entry in table
    table.remove(extraslist)
end
-- creates a random extra
function Extras.random(event)
    local params = event.source.params
    
    -- currently: extras
    -- 1=left chainsaw
    -- 2=right chainsaw
    -- 3=spinning chainsaw
    -- see utilities.weighted_choice for more details
    local weighted_table = params.weight
    
    -- call weighted distribution function to pick a table
    local chosen = utility.weighted_choice(weighted_table)
    
    if chosen == 1 then
        Extras.lchainsaw(event)
    elseif chosen == 2 then
        Extras.rchainsaw(event)
    elseif chosen == 3 then
        Extras.spinchainsaw(event)
    end
    
end

------------------------------------ Extras --------------------------------------------
-------------------------------------------------------------------------------------------

-- creates a chainsaw that moves up the edge
function Extras.lchainsaw(event)
    local params = event.source.params
    local chainsaw = display.newRect(0, screenH + 50, 90, 15 )
    chainsaw:setFillColor(1,0,0)
    chainsaw.myName = "chainsaw"
    chainsaw.collType = "passthrough"
    local function onEnterFramel(self, event)
        if self.y < -15 then
            Runtime:removeEventListener("enterFrame", self)
            removeExtra(self)
            self:removeSelf()
        elseif self.x < -60 then
            self:setLinearVelocity(50, -1*params.chainsawspeed)
        elseif self.x > 40 then
             self:setLinearVelocity(-50, -1*params.chainsawspeed)
        end
    end
    chainsaw.enterFrame = onEnterFramel
    
    -- add to physics
    physics.addBody( chainsaw, "kinematic", { bounce=0.1, friction=0.7 } )
    chainsaw.gravityScale = 0
    chainsaw:setLinearVelocity(50,-1*params.chainsawspeed)
    Runtime:addEventListener("enterFrame", chainsaw)

    -- add to list of extras
    chainsaw.pos = extraslistpos
    extraslistpos = extraslistpos + 1
    table.insert(extraslist, chainsaw)
end

-- creates a chainsaw that moves up the edge
function Extras.rchainsaw(event)
    local params = event.source.params
    local chainsaw = display.newRect(screenW, screenH + 50, 90, 15 )
    chainsaw:setFillColor(1,0,0)
    chainsaw.myName = "chainsaw"
    chainsaw.collType = "passthrough"
    
    local function onEnterFramer(self, event)
        if self.y < -15 then
            Runtime:removeEventListener("enterFrame", self)
            removeExtra(self)
            self:removeSelf()
        elseif self.x < screenW-40 then
            self:setLinearVelocity(50, -1*params.chainsawspeed)
        elseif self.x > screenW+60 then
             self:setLinearVelocity(-50, -1*params.chainsawspeed)
        end
    end
    chainsaw.enterFrame = onEnterFramer
    
    -- add to physics
    physics.addBody( chainsaw, "kinematic", { bounce=0.1, friction=0.7 } )
    chainsaw.gravityScale = 0
    chainsaw:setLinearVelocity(-50,-1*params.chainsawspeed)
    Runtime:addEventListener("enterFrame", chainsaw)

    -- add to list of extras
    chainsaw.pos = extraslistpos
    extraslistpos = extraslistpos + 1
    table.insert(extraslist, chainsaw)
end

function Extras.spinchainsaw(event)
    local params = event.source.params
    local xpos = {0, screenW}
    local chainsaw = display.newRect(xpos[math.random(2)], screenH + 50, 90, 5 )
    chainsaw:setFillColor(1,0,0)
    chainsaw.myName = "chainsaw"
    chainsaw.collType = "passthrough"
    
    local function onEnterFramer(self, event)
        if self.y < -15 then
            Runtime:removeEventListener("enterFrame", self)
            removeExtra(self)
            self:removeSelf()
        end
    end
    chainsaw.enterFrame = onEnterFramer
    
    -- add to physics
    physics.addBody( chainsaw, "kinematic", { bounce=0.1, friction=0.7 } )
    chainsaw.gravityScale = 0
    chainsaw:setLinearVelocity(0,-1*params.chainsawspeed)
    chainsaw.angularVelocity = 200
    Runtime:addEventListener("enterFrame", chainsaw)

    -- add to list of extras
    chainsaw.pos = extraslistpos
    extraslistpos = extraslistpos + 1
    table.insert(extraslist, chainsaw)    
end


return Extras