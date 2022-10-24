local module = {
	Drink = function(character)
		for i,child in ipairs(character:GetChildren()) do
			if child:IsA("BasePart") and child.Name ~= "HumanoidRootPart" then
				child.Transparency = 1
			end
			for i,childChild in ipairs(child:GetChildren()) do
				if childChild:IsA("BasePart") or childChild:IsA("Decal") then
					childChild.Transparency = 1
				end
			end
		end
		wait(5)
		for i,child in ipairs(character:GetChildren()) do
			if child:IsA("BasePart") and child.Name ~= "HumanoidRootPart" then
				child.Transparency = 0
			end
			for i,childChild in ipairs(child:GetChildren()) do
				if childChild:IsA("BasePart") or childChild:IsA("Decal") then
					childChild.Transparency = 0
				end
			end
		end
		script:Destroy()
	end
}

return module
