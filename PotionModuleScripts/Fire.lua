local module = {
	Drink = function(character)
		local humanoid = character:WaitForChild("Humanoid")
		local root = character:WaitForChild("Head")
		
		local fire = game.ReplicatedStorage:WaitForChild("Fire"):Clone()		
		fire.Parent = root
		
		for i = 1,40 do
			humanoid.Health -= 2
			wait(0.1)
		end
		
		fire:Destroy()
		script:Destroy()
	end
}

return module
