local Image = "http://www.roblox.com/asset/?id=6558374856"
--local Image = "http://www.roblox.com/asset/?id=8508980527"

for i,Part in pairs(workspace:GetDescendants()) do
	if Part:IsA("BasePart") and Part.Transparency == 0 and not game.Players:GetPlayerFromCharacter(Part.Parent) and not game.Players:GetPlayerFromCharacter(Part.Parent.Parent) then
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

		Part:GetPropertyChangedSignal("Transparency"):Connect(function()

			for i,Decal in pairs(Decals) do
				Decal.Transparency = Part.Transparency
			end

		end)

	end
end

workspace.DescendantAdded:Connect(function(Part)
	if not Part:IsA("BasePart") or Part.Transparency > 0 or game.Players:GetPlayerFromCharacter(Part.Parent) or game.Players:GetPlayerFromCharacter(Part.Parent.Parent) then
		return
			end
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
		Part:GetPropertyChangedSignal("Transparency"):Connect(function()

			for i,Decal in pairs(Decals) do
				Decal.Transparency = Part.Transparency
			end

		end)

	
end)
