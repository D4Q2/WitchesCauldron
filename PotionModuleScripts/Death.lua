local module = {
	Drink = function(character)
		local humanoid = character:WaitForChild("Humanoid")
		humanoid.Health = 0
		script:Destroy()
	end
}

return module
