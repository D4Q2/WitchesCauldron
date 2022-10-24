local module = {
	Drink = function(character)
		local humanoid = character:WaitForChild("Humanoid")
		humanoid.WalkSpeed = humanoid.WalkSpeed * 2.1
		wait(5)
		humanoid.WalkSpeed = humanoid.WalkSpeed / 2.1
		script:Destroy()
	end
}

return module
