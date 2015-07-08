--MainScreen.lua

local storyboard = require("storyboard")
local MainScreen = storyboard.newScene()


function MainScreen:createScene(event)
	local group = self.view
	local background = display.newImage( "background.png", display.contentHeight/2, display.contentWidth/2 )
	local startButton = display.newImage( "startButton.png", display.contentWidth/2, display.contentHeight/2 )
	print( "mainscreen executed" )

	group:insert(background)
	group:insert(startButton)

	local function startListner(event)
		if(event.phase == "began")	then
		print( "startListner executed" )
		storyboard.gotoScene("level1", options)
		end
	end
	startButton:addEventListener( "touch", startListner )
end


--[[function MainScreen:exitScene(event)
	Runtime:removeEventListener( eventName, listener )
end
]]--


MainScreen:addEventListener( "createScene", MainScreen )
--MainScreen:addEventListener( "exitScene", MainScreen )

return MainScreen