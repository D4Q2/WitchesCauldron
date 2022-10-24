local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerService = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")


local pickupEvent = ReplicatedStorage:WaitForChild("PickupItem")
local cauldronEvent = ReplicatedStorage:WaitForChild("AddToCauldron")
local drinkEvent = ReplicatedStorage:WaitForChild("DrinkPotion")
local drinkAnimRef = ReplicatedStorage:WaitForChild("Drink")

local cauldronSetup = workspace:WaitForChild("Brewing")
local cauldron = cauldronSetup:WaitForChild("Cauldron")
local cauldCollider = cauldronSetup:WaitForChild("CauldCollider")

local drinkKey = "Q"
local pickupKey = "E"
local maxPickupDistance = 20
local readingRecipe = false

local player = PlayerService.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local mouse = player:GetMouse()

local playerGui = player:WaitForChild("PlayerGui")
local toolPickupGui = playerGui:WaitForChild("ToolPickupGui")
local cauldronGui = playerGui:WaitForChild("CauldronGui")

local screenGui = playerGui:WaitForChild("ScreenGui")
local actionText = screenGui:WaitForChild("ActionText")
local scrolls = screenGui:WaitForChild("Scrolls"):GetChildren()


local function MouseTargetIsTool()
	return mouse.Target and mouse.Target:FindFirstAncestorOfClass("Tool")
end

local function MouseTargetIsCauldron()
	return mouse.Target == cauldron or mouse.Target == cauldCollider
end

local function PlayerHeldIngredient()
	for i,part in ipairs(character:GetChildren()) do
		if part:IsA("Tool") and CollectionService:HasTag(part, "Ingredient") then
			return part
		end
	end
	return nil
end

local function PlayerHeldPotion()
	for i,part in ipairs(character:GetChildren()) do
		if part:IsA("Tool") and CollectionService:HasTag(part, "Potion") then
			return part
		end
	end
	return nil
end

local function PlayerHeldRecipe()
	for i,part in ipairs(character:GetChildren()) do
		if part:IsA("Tool") and CollectionService:HasTag(part, "Recipe") then
			return part
		end
	end
	return nil
end


-- Start game

local drinkAnim = humanoid:LoadAnimation(drinkAnimRef)

local function DrinkPotion(potion)
	drinkAnim:Play()
	wait(drinkAnim.Length)
	drinkEvent:InvokeServer(potion)
end

local function ReadRecipe(recipeName)
	for i,scroll in ipairs(scrolls) do
		scroll.Visible = (scroll.Name == recipeName)
	end
end

	
RunService.Heartbeat:Connect(function(deltaTime)
	local item = PlayerHeldPotion()
	if item then
		actionText.Text = drinkKey .. " to drink " .. item.Name
	else
		item = PlayerHeldRecipe()
		if item then
			actionText.Text = drinkKey .. " to read " .. item.Name
		else
			ReadRecipe("")
			actionText.Text = ""
		end
	end
end)

UserInputService.InputChanged:Connect(function()
	if mouse.Target then
		if MouseTargetIsTool() and player:DistanceFromCharacter(mouse.Target.Parent.Handle.Position) < maxPickupDistance then
			toolPickupGui.Enabled = true
			toolPickupGui.Adornee = mouse.Target
			
		else
			toolPickupGui.Enabled = false
			toolPickupGui.Adornee = nil
			if (mouse.Target == cauldron or mouse.Target == cauldCollider) and PlayerHeldIngredient() ~= nil then
				cauldronGui.Enabled = true
				cauldronGui.Adornee = cauldron
			else
				cauldronGui.Enabled = false
				cauldronGui.Adornee = nil
			end
		end
	end
end)

UserInputService.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode[pickupKey] then
		if MouseTargetIsTool() then
			local item = mouse.Target.Parent
			if pickupEvent:InvokeServer(item) then
				toolPickupGui.Enabled = false
				toolPickupGui.Adornee = nil
			end
		
		elseif MouseTargetIsCauldron() then
			local item =  PlayerHeldIngredient()
			if item and cauldronEvent:InvokeServer(item) then
				--
			end
		end
	elseif input.KeyCode == Enum.KeyCode[drinkKey] then
		local potion = PlayerHeldPotion()
		if potion then
			DrinkPotion(potion)
		else
			local recipe = PlayerHeldRecipe()
			if recipe then
				if not readingRecipe then
					ReadRecipe(recipe.Name)
					readingRecipe = true
				else
					ReadRecipe("")
					readingRecipe = false
				end
			end
		end
	end
end)
