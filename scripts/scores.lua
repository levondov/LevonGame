-- builds characters

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

local M = {}

local scoreText = nil;
local score = 0
local scoretime = timer.performWithDelay(100, function() return true end,1)

function M.getscoreText()
    scoreText = display.newText( "000000", screenW/1.2, screenH/10, native.systemFontBold, 32 )
    return scoreText
end

function M.getscore()
    return score
end

function updateScore(event)
    score = score + 1
    scoreText.text = string.format( "%06d", score )
end

function M.start()
-- start game
    score = 0
    scoretime = timer.performWithDelay(1000/60, updateScore, 0)
end

function M.stop()
-- game over
    timer.cancel(scoretime)
end

function M.save()
-- saves the hi score
end
    
return M