local ReplicatedStorage = game:GetService("ReplicatedStorage")


local pickupEvent = ReplicatedStorage:WaitForChild("PickupItem")
local cauldronEvent = ReplicatedStorage:WaitForChild("AddToCauldron")
local drinkEvent = ReplicatedStorage:WaitForChild("DrinkPotion")

local potions = ReplicatedStorage:WaitForChild("Potions")

local cauldron = workspace:WaitForChild("Brewing"):WaitForChild("Cauldron")
local smokeEmitter = cauldron:WaitForChild("Smoke")
local levelHolder = cauldron:WaitForChild("Fill")
local levels = {
	levelHolder:WaitForChild("1"),
	levelHolder:WaitForChild("2"),
	levelHolder:WaitForChild("3"),
	levelHolder:WaitForChild("4"),
	levelHolder:WaitForChild("5")
}

local maxPickupDistance = 20

local cauldronItems = {}
local cauldronColors = {}

-- Blue Cyan Orange Pink Red White Yellow Black
local recipes = {
	{"Red","Orange","Yellow","Cyan","Blue","Pink"},        -- 
	{"White","White","White","White","Yellow","Yellow"},   -- 4W + 2Y
	{"Black","Black","Black","Red","Red","Red"},           -- 3B + 3R
	{"Pink","Pink","Pink","White","White","White"},        -- 3P + 3W
	{"Blue","Blue","Cyan","Cyan","White","White"},         -- 2b + 2C + 2W
	{"Orange","Red","Red","Red","Red","Yellow"},           -- 1O + 4R + 1Y
	{"Orange","Orange","Orange","Black","Black","Black"},  -- 3O + 3B
	{"Cyan","Cyan","Pink","Pink","Yellow","Yellow"}        -- 2C + 2P + 2Y
}
local results = {
	"Invisibility Potion",
	"Levitation Potion",
	"Death Potion",
	"Health Potion",
	"Speed Potion",
	"Fire Potion",
	"Strength Potion",
	"Jump Potion"
}


local function SetCauldronFillToLevel(newLevel)
	for i,level in ipairs(levels) do
		if i == newLevel then
			level.Transparency = 0
		else
			level.Transparency = 1
		end
	end
end

local function CauldronMixColor()
	local finalColor = Color3.new(0,0,0)
	
	for i,color in ipairs(cauldronColors) do
		local colorToAdd = Color3.new(color.R * (1.0/#cauldronColors), color.G * (1.0/#cauldronColors), color.B * (1.0/#cauldronColors))
		finalColor = Color3.new(finalColor.R + colorToAdd.R, finalColor.G + colorToAdd.G, finalColor.B + colorToAdd.B)
	end
	
	return finalColor
end

local function SetPotionColor(color)
	for i,level in ipairs(levels) do
		level.Color = color
	end
end

function CheckTablesMatch(t1,t2)
	if #t1 ~= #t2 then
		return false
	end
	
	for i,item in t1 do 
		if item~=t2[i] then 
			return false 
		end 
	end
	
	return true
end

pickupEvent.OnServerInvoke = function(player, item)
	local distanceFromPlayer = player:DistanceFromCharacter(item.Handle.Position)
	if distanceFromPlayer < maxPickupDistance then
		item.Parent = player.Backpack
		return true
	end
	
	return false
end

cauldronEvent.OnServerInvoke = function(player, item)
	local ingredient = item:GetAttribute("Ingredient")
	--print(player.Name .. " added " .. ingredient .. " to cauldron.")
	
	-- Add item to recipe
	table.insert(cauldronItems, ingredient)
	
	-- If cauldron is full
	if #cauldronItems == 6 then
		--create the potion and give it to the player
		table.sort(cauldronItems)
		
		local potion = "Muddled Mess"
		for i,recipe in ipairs(recipes) do
			table.sort(recipe)
			if CheckTablesMatch(recipe,cauldronItems) then
				potion = results[i]
				break
			end
		end
		local potionTemplate = potions:WaitForChild(potion)
		local newPotion = potionTemplate:Clone()
		newPotion.Parent = player.Backpack
		
		-- Do smoke effects
		smokeEmitter.Color = ColorSequence.new(CauldronMixColor(), Color3.new(0,0,0))
		smokeEmitter.Enabled = true
		wait(0.4)
		smokeEmitter.Enabled = false

		-- Empty arrays
		table.clear(cauldronItems)
		table.clear(cauldronColors)
	end
	
	-- Adjust cauldron fill
	SetCauldronFillToLevel(#cauldronItems)
	-- Set color
	table.insert(cauldronColors, item:GetAttribute("Color"))
	SetPotionColor(CauldronMixColor())
	
	-- Remove the item
	item:Destroy()
end

drinkEvent.OnServerInvoke = function(player, potion)
	local potionScript = require(potion:WaitForChild("Handle"):WaitForChild("Potion"))
	potionScript.Parent = workspace:WaitForChild("PotionScripts")
	potion:Destroy()
	
	potionScript.Drink(player.Character)
end
