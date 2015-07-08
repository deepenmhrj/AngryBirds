local storyboard = require( "storyboard" )

local scene = storyboard.newScene()
local width = display.contentWidth
local height = display.contentHeight

function scene:createScene( event )
	local group = self.view
	local backg = display.newImage ("background.png", width/2, height/2)
	backg.alpha = .5
	local msg = display.newText ("Final Score: " .. event.params.curScoree, width/2, height*.95, font, 20)
 	msg:setFillColor( 1, 0, 1 )
	local gameDone = display.newImage("GameOver.png", width/2, height/2)
	group:insert(gameDone)
	group:insert(msg)
	group:insert(backg)
end

scene:addEventListener ( "createScene", scene)
return scene