local module = {
	Drink = function(character)
		local humanoid = character:WaitForChild("Humanoid")
		humanoid.MaxHealth = humanoid.MaxHealth * 1.75
		humanoid.Health = humanoid.Health * 1.75
		wait(7)
		humanoid.MaxHealth = humanoid.MaxHealth / 1.75
		humanoid.Health = humanoid.Health / 1.75
		script:Destroy()
	end
}

return module
