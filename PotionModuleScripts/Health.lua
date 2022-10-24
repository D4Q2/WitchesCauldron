local module = {
	Drink = function(character)
		local humanoid = character:WaitForChild("Humanoid")
		humanoid.Health += 40
		script:Destroy()
	end
}

return module
