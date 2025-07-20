if getgenv().CatModeExecuted == true then
	return

end


getgenv().CatModeExecuted = true





local Image = "http://www.roblox.com/asset/?id=6558374856"










local CatMode = {}








for i,Part in pairs(workspace:GetDescendants()) do
	if Part:IsA("BasePart") then
		local Decals = {}
		local Decal = Instance.new("Decal")
		Decal.Face = Enum.NormalId.Front
		Decal.Parent = Part
		Decal.Texture = Image
		table.insert(Decals, Decal)
		local Decal = Instance.new("Decal")
		Decal.Face = Enum.NormalId.Back
		Decal.Parent = Part
		Decal.Texture = Image
		table.insert(Decals, Decal)
		local Decal = Instance.new("Decal")
		Decal.Face = Enum.NormalId.Top
		Decal.Parent = Part
		Decal.Texture = Image
		table.insert(Decals, Decal)
		local Decal = Instance.new("Decal")
		Decal.Face = Enum.NormalId.Bottom
		Decal.Parent = Part
		Decal.Texture = Image
		table.insert(Decals, Decal)
		local Decal = Instance.new("Decal")
		Decal.Face = Enum.NormalId.Left
		Decal.Parent = Part
		Decal.Texture = Image
		table.insert(Decals, Decal)
		local Decal = Instance.new("Decal")
		Decal.Face = Enum.NormalId.Right
		Decal.Parent = Part
		Decal.Texture = Image
		table.insert(Decals, Decal)

		if Part.Transparency > 0 then
			for i,Decal in pairs(Decals) do
				Decal.Transparency = 1
			end
		end

		if Part.LocalTransparencyModifier > 0 then
			for i,Decal in pairs(Decals) do
				Decal.Transparency = 1
			end
		end

		Part:GetPropertyChangedSignal("Transparency"):Connect(function()

			for i,Decal in pairs(Decals) do
				Decal.Transparency = Part.Transparency
			end

		end)

		Part:GetPropertyChangedSignal("LocalTransparencyModifier"):Connect(function()
			if Part.LocalTransparencyModifier > 0 then
				for i,Decal in pairs(Decals) do
					Decal.Transparency = 1
				end
			else
				for i,Decal in pairs(Decals) do
					Decal.Transparency = Part.Transparency
				end
			end
		end)


	end

end

local Connection = workspace.DescendantAdded:Connect(function(Part)
	
	
	if not Part:IsA("BasePart") or Part:IsA("BasePart") and Part.Transparency > 0 or Part:IsA("BasePart") and Part.LocalTransparencyModifier > 0 then
		return
	end
	local Decals = {}
	local Decal = Instance.new("Decal")
	Decal.Face = Enum.NormalId.Front
	Decal.Parent = Part
	Decal.Texture = Image
	table.insert(Decals, Decal)
	task.wait(0.1)
	local Decal = Instance.new("Decal")
	Decal.Face = Enum.NormalId.Back
	Decal.Parent = Part
	Decal.Texture = Image
	table.insert(Decals, Decal)
	task.wait(0.1)
	local Decal = Instance.new("Decal")
	Decal.Face = Enum.NormalId.Top
	Decal.Parent = Part
	Decal.Texture = Image
	table.insert(Decals, Decal)
	task.wait(0.1)
	local Decal = Instance.new("Decal")
	Decal.Face = Enum.NormalId.Bottom
	Decal.Parent = Part
	Decal.Texture = Image
	table.insert(Decals, Decal)
	task.wait(0.1)
	local Decal = Instance.new("Decal")
	Decal.Face = Enum.NormalId.Left
	Decal.Parent = Part
	Decal.Texture = Image
	table.insert(Decals, Decal)
	task.wait(0.1)
	local Decal = Instance.new("Decal")
	Decal.Face = Enum.NormalId.Right
	Decal.Parent = Part
	Decal.Texture = Image
	table.insert(Decals, Decal)

	if Part.Transparency > 0 then
		for i,Decal in pairs(Decals) do
			Decal.Transparency = 1
		end
	end

	if Part.LocalTransparencyModifier > 0 then
		for i,Decal in pairs(Decals) do
			Decal.Transparency = 1
		end
	end

	Part:GetPropertyChangedSignal("Transparency"):Connect(function()

		for i,Decal in pairs(Decals) do
			Decal.Transparency = Part.Transparency
		end

	end)
	Part:GetPropertyChangedSignal("LocalTransparencyModifier"):Connect(function()
		if Part.LocalTransparencyModifier > 0 then
			for i,Decal in pairs(Decals) do
				Decal.Transparency = 1
			end
		else
			for i,Decal in pairs(Decals) do
				Decal.Transparency = Part.Transparency
			end
		end
	end)





end)

function CatMode:Disable()
	Connection:Disconnect()
end

getgenv().CatMode = CatMode

return CatMode
