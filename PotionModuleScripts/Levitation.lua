local module = {
	Drink = function(character)
		local root = character:WaitForChild("HumanoidRootPart")
		
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		local newLevitator = Instance.new("LinearVelocity")
		
		newLevitator.Attachment0 = root:WaitForChild("RootRigAttachment")
		newLevitator.VectorVelocity = Vector3.new(0,10000,0)
		newLevitator.MaxForce = 5000
		newLevitator.Parent = root
		wait(0.1)		
		newLevitator.MaxForce = 3000
		wait(3)
		newLevitator:Destroy()
		
		script:Destroy()
	end
}

return module
