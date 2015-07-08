local storyboard = require( "storyboard" )
fsm = require("fsm")
local scene = storyboard.newScene()
local width = display.contentWidth
local height = display.contentHeight
local group, bg, level, bar, bar2, pig, pig2, ground, bird, msg, msg2, tapMsg, scoreMsg, nextLevel
local curLevel = 3
local numThrows = 0
local score = 2
local maxTap = 1
local numTaps = 0
local numPig = 1

local barSheets = {
 		{sheet = graphics.newImageSheet( "bar1.png", { width=60, height=20, numFrames=1})},
 		{sheet = graphics.newImageSheet( "bar2.png", { width=60, height=20, numFrames=1})},
 		{sheet = graphics.newImageSheet( "bar3.png", { width=60, height=20, numFrames=1})}
 	}
local sequenceData = {
        { name="seq1", sheet=barSheets[1].sheet, start=1, count=1, time=1, loopCount=0 },
        { name="seq2", sheet=barSheets[2].sheet, start=1, count=1, time=1, loopCount=0 },
        { name="seq3", sheet=barSheets[3].sheet, start=1, count=1, time=1, loopCount=0 }
    }

local pigSheets = {
	{sheet = graphics.newImageSheet( "pig_happy.png", { width=50, height=49, numFrames=1})},
 	{sheet = graphics.newImageSheet( "pig_dead.png", { width=50, height=49, numFrames=1})}
}

local pigSequenceData = {
	  { name="seq1", sheet=pigSheets[1].sheet, start=1, count=1, time=1, loopCount=0 },
      { name="seq2", sheet=pigSheets[2].sheet, start=1, count=1, time=1, loopCount=0 }
}

local boomSheet = graphics.newImageSheet("boom.png", { width = 134, height = 134, numFrames = 12 })
local boomSequenceData = { name = "explosion", start = 1, count = 10, time = 300, loopCount = 1, loopDirection = "forward" }
local boomEvent = display.newSprite(boomSheet, boomSequenceData)

local physics = require("physics")
physics.start()
--physics.setDrawMode ("hybrid")

happyState = {}
sadState = {}
pigEntires = {}

function scene:createScene( event )   
 	group = self.view
 	msgPrint()
 	displayObjects() 

 	addPhysics()
 	insertGroup()
 	local function beginListener (event)
 		if (event.phase == "began") then
 			audio.dispose(sound)
			sound = nil
			storyboard.gotoScene("endScene", { effect = "fade", time = 400, params = {curScoree = score}})
 		end
 		return true
 	end
 	nextLevel:addEventListener ("touch", beginListener)
end 

function displayObjects()
	bg = display.newImage ("background.png", width*.8, height*.82)
 	bg.alpha = .5
 	bar = display.newImage("slab.png", width/2+150, height)
 	bar1 = display.newImage("slab1.png", width-50, height-50)
 	bar2 = display.newImage("slab.png", width, height-70)
 	pig = stateAlter(width*.90, height, height*.9)  
 	pig2 = stateAlter(width*.55+80, height,height*.6)
 	ground = display.newRect(width/2,height*1.02,width*1.5,height*.1)
 	bird =  display.newImage("angry.png", width*.10, height*.10)
 	bird.startTime = -1 
 	nextLevel = display.newImage("next.png", width/5+400, height/2-100)
 	nextLevel.alpha = 0
end

function addPhysics()
 	physics.addBody(bar, "dynamic")
 	physics.addBody(bar1, "dynamic")
 	physics.addBody(bar2, "static")
 	physics.addBody(pig,"dynamic")
 	physics.addBody(pig2,"dynamic")
 	physics.addBody(ground, "static")
 	physics.addBody(bird, "static", {bounce = 0.2})
end

function msgPrint()
 	msg = display.newText ("Pig1: ", width*.10, height*80, font, 20)
 	msg:setFillColor( 1, 0, 1 )
 	msg2 = display.newText ("Pig2: ", width*.10, height*50, font, 20)
  	msg2:setFillColor( 1, 0, 1 )
  	level = display.newText ("Level ".. curLevel, width*.90, height*.10, font, 20)
  	tapMsg = display.newText("Taps Left: " .. maxTap - numTaps, width*10, height*.70, font, 15)
  	tapMsg:setFillColor(1,0,1)
  	scoreMsg = display.newText("Score: " .. score, width*.70, height*.10, font, 20)
end

function insertGroup()
	group:insert (msg)
  	group:insert (msg2)
 	group:insert(ground)
 	group:insert (bg)
 	group:insert (level)
 	group:insert(bar)
 	group:insert(bar1)
 	group:insert(bar2)
 	group:insert(pig)
 	group:insert(pig2)
 	group:insert(ground)
 	group:insert(bird)
 	group:insert(pig.myHP)
 	group:insert(pig2.myHP)
 	group:insert(tapMsg)
 	group:insert(scoreMsg)
 	group:insert(boomEvent)
 	group:insert(nextLevel)
end

function tap(event)
	if numTaps < maxTap then 
		local X1 = bird.x
		local Y1 = bird.y
		local X2 = event.x
		local Y2 = event.y
		bird.bodyType = "dynamic"
		bird:applyLinearImpulse( (X2-X1)/1000, (Y2-Y1)/1000, bird.x, bird.y)
	end
		numTaps = numTaps + 1
		bird.startTime = system.getTimer() 
	tapMsg.text = "Taps Left: " .. maxTap - numTaps  
	scoreMsg.text = "Score: " .. score
	nextLevel.alpha = 1
end

function onCollision(event)
	if ( event.object2.name == "pig" or event.object2.name == "pig2") and event.phase == "ended" then
		scoreMsg.text = "Score: " .. score
		numThrows = numThrows + 1
		boomEvent.x = event.object2.x  
		boomEvent.y = event.object2.y  
	    boomEvent:play()
	    print("a")
		
			event.object2:setSequence("seq2")
			event.object2.numHits = 1
			event.object2.myHP:setSequence ("seq2")
			score = score + 1 
 				    print("b")

			event.object2:removeSelf()
			event.object2.myHP:setSequence ("seq3")
			event.object2.numHits = 2
			score = score + 2  
				    print("c")

	elseif(event.object1.name=="pig" or event.object1.name=="pig2") and event.phase == "ended" then
		scoreMsg.text = "Score: " .. score
		numThrows = numThrows + 1
		boomEvent.x = event.object2.x  
		boomEvent.y = event.object2.y  
	    boomEvent:play()
	    print(event.object1.name)

			event.object1:setSequence("seq2")
			pig:setSequence( "seq2" )
			event.object1.numHits = 1
			event.object1.myHP:setSequence ("seq2")
			score = score + 1 

			event.object1.myHP:setSequence ("seq3")
			event.object1:removeSelf()
			event.object1.numHits = 2
			score = score + 2  
				    print("C")
	end

end


function stateAlter(x, y, HPY)
	local piggy = display.newSprite(pigSheets[1].sheet, pigSequenceData)
	piggy.homex = x
	piggy.homey = y
	piggy.fsm = fsm.new(piggy)
	piggy.fsm:changeState ( happyState )
	piggy.myHP = display.newSprite (barSheets[1].sheet, sequenceData)
	piggy.myHP.x = width*2
	piggy.myHP.y = HPY
	piggy.name = "pig" .. numPig 
	piggy.numHits = 0 
	numPig = numPig + 1
	table.insert(pigEntires, piggy)
	return piggy
end

function happyState:enter(owner)
	owner.x = owner.homex
	owner.y = owner.homey
end

function happyState:execute(owner)
	if owner.numHits == 2 then
		owner.fsm:changeState(sadState)
	end 
end

function happyState:exit(owner)

end

function sadState:enter(owner) 
	Runtime:removeEventListener( "collision", onCollision )
end

function sadState:execute(owner)

end

function sadState:exit(owner)
	Runtime:removeEventListener( "collision", onCollision )
end

function update ( event )
	for i=1,#pigEntires do
		pigEntires[i].fsm:update(event)
	end
end


scene:addEventListener( "createScene", scene )
display.currentStage:addEventListener("touch", tap)
Runtime:addEventListener("collision", onCollision)
Runtime:addEventListener("enterFrame", update)

return scene