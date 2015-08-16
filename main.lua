display.setStatusBar(display.HiddenStatusBar)

-----------------------------------------------
--*** Set up our variables and group ***
-----------------------------------------------
local slotsGroup = display.newGroup()
local machineGroup = display.newGroup()

local _W = display.contentWidth
local _H = display.contentHeight
local mr = math.random

local spinAllowed = true
local slotColumn1 = {}
local slotColumn2 = {}
local slotColumn3 = {}

--image sheet
local options = {
	width = 100,
	height = 200,
	numFrames = 4,
	sheetContentWidth = 400,
	sheetContentHeight = 200
}
local spinSheet = graphics.newImageSheet( 'images/spinSprite.jpg', options )

local spinData1 = {name="spin1", start=1, count=4, time = 250, loopCount = 5}
local spinData2 = {name="spin2", frames={ 3, 4, 1, 2}, time=250, loopCount = 5}
local spinData3 = {name="spin3", frames={ 4, 1, 3, 2}, time=250, loopCount = 5}

-----------------------------------------------
--*** Set up our text objects and machine ***
-----------------------------------------------
local machine = display.newImageRect("images/tpumpsMachine.png",_W,_H)
machine.x = _W*0.5; machine.y = _H*0.5;
machineGroup:insert(machine)

local slotCover = display.newImageRect( "images/slotsCover.png", _W, _W/1.86 )
slotCover.x = _W*0.5; slotCover.y = _H*0.5;
machineGroup:insert( slotCover )

-----------------------------------------------
--*** Set up the visible slots ***
-----------------------------------------------
local function createSlots()
	--If theres any slots showing already remove them..
	local i
	for i = slotsGroup.numChildren,1,-1 do
		local child = slotsGroup[i]
		child.parent:remove( child )
		child = nil
	end

	--Use a loop to make them easily for us :)
	for i=1, 3 do
		local randomImage = mr(1,5)
		slotColumn1[i] = display.newImageRect("images/slot_"..randomImage..".jpg", _W/3, _H/3)
		slotColumn1[i].x = _W/2 - _W/3
		slotColumn1[i].y = _H*0.165 + (_H/3 *(i-1))  
		slotColumn1[i].slot = randomImage
		slotsGroup:insert(slotColumn1[i])

		randomImage = mr(1,5)
		slotColumn2[i] = display.newImageRect("images/slot_"..randomImage..".jpg", _W/3, _H/3)
		slotColumn2[i].x = _W/2
		slotColumn2[i].y = slotColumn1[i].y
		slotColumn2[i].slot = randomImage
		slotsGroup:insert(slotColumn2[i])

		randomImage = mr(1,5)
		slotColumn3[i] = display.newImageRect("images/slot_"..randomImage..".jpg", _W/3, _H/3)
		slotColumn3[i].x = slotColumn2[1].x + _W/3
		slotColumn3[i].y = slotColumn1[i].y 
		slotColumn3[i].slot = randomImage
		slotsGroup:insert(slotColumn3[i])
	end

	--Make it so we can bet again...
	spinAllowed = true
end
createSlots()

local function spinNow( event )
	if event.phase == "ended" and spinAllowed == true then
		spinAllowed = false -- so we can't bet until it's done

		--Now start out spriteSheet spinning
		local spin1, spin2, spin3
		local function spriteListener( event )
			if event.phase == "ended" then
				display.remove(spin1); spin1 = nil
				display.remove(spin2); spin2 = nil
				display.remove(spin3); spin3 = nil
				createSlots()
			end
		end

		spin1 = display.newSprite( spinSheet, spinData1 )
		spin1.x = slotColumn1[2].x; spin1.y = slotColumn1[2].y
		slotsGroup:insert(spin1)

		spin2 = display.newSprite( spinSheet, spinData2 )
		spin2.x = slotColumn2[2].x; spin2.y = slotColumn2[2].y
		slotsGroup:insert(spin2)

		spin3 = display.newSprite( spinSheet, spinData3 )
		spin3.x = slotColumn3[2].x; spin3.y = slotColumn3[2].y
		slotsGroup:insert(spin3)

		spin1:addEventListener( "sprite", spriteListener )
		spin1:play(); spin2:play(); spin3:play();
	end
	return true
end
--[[
local spinBtn = display.newRect(0,0,140,50)
spinBtn.x = _W-80; spinBtn.y = _H*0.82; spinBtn.alpha = 0.01
spinBtn:addEventListener("touch", spinNow)
machineGroup:insert(spinBtn)
--]]

display.currentStage:addEventListener( "touch", spinNow )

