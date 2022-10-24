local module = {
	Drink = function(character)
		local humanoid = character:WaitForChild("Humanoid")
		humanoid.UseJumpPower = true
		humanoid.JumpPower = humanoid.JumpPower * 2.5
		wait(7)
		humanoid.JumpPower = humanoid.JumpPower / 2.5
		script:Destroy()
	end
}

return module
