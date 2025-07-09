if getgenv().CatMode == true then
	return

end


getgenv().CatMode = true

game.SoundService.AmbientReverb = Enum.ReverbType.CarpettedHallway

local GIHUN = Instance.new("ScreenGui")
GIHUN.Parent = game.CoreGui
GIHUN.DisplayOrder = 9999999
GIHUN.IgnoreGuiInset = true


local imageLabel = Instance.new("ImageLabel")
imageLabel.Size = UDim2.new(1, 0, 1, 0)
imageLabel.Position = UDim2.new(0, 0, 0, 0)
imageLabel.Image = "http://www.roblox.com/asset/?id=15436931192"
imageLabel.BackgroundTransparency = 1
imageLabel.ImageTransparency = 1
imageLabel.Parent = GIHUN

task.wait(3)




local function AddText(Label: TextLabel, Text: string)
	Label.Text = ""
	local String = Text:split("")
	for i,Letter in pairs(String) do
		Label.Text = Label.Text .. Letter
		local Sound = Instance.new("Sound")
		Sound.TimePosition = 0.1
		Sound.SoundId = "rbxassetid://147982968"
		Sound.Volume = 3
		Sound.Parent = game.CoreGui
		Sound:Play()
		game:GetService("Debris"):AddItem(Sound, 3)
		task.wait(0.055)
	end
end

local Image = "http://www.roblox.com/asset/?id=6558374856"

local Sound = Instance.new("Sound")
Sound.TimePosition = 0.2
Sound.SoundId = "rbxassetid://6308606116"
Sound.Volume = 3
Sound.Parent = game.CoreGui


local SoundEffect = Instance.new("DistortionSoundEffect")
SoundEffect.Parent = Sound
SoundEffect.Level = 0.75
SoundEffect.Priority = 0

Sound:Play()

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local imageLabel = Instance.new("ImageLabel")
imageLabel.Size = UDim2.new(1, 0, 1, 0)
imageLabel.Position = UDim2.new(0, 0, 0, 0)
imageLabel.Image = "http://www.roblox.com/asset/?id=15436931192"
imageLabel.BackgroundTransparency = 1
imageLabel.Parent = GIHUN

local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, 0, 0.055, 0)
textLabel.Position = UDim2.new(0, 0, 0.875, 0)
textLabel.BackgroundTransparency = 1
textLabel.TextScaled = true
textLabel.TextStrokeTransparency = 0
textLabel.TextColor3 = Color3.new(1, 1, 1)
textLabel.Font = Enum.Font.Oswald
textLabel.Parent = GIHUN
textLabel.Text = ""



task.wait(2)





AddText(textLabel, "Cat mode initiated, have fun!")

task.wait(1)




for i,Part in pairs(workspace:GetDescendants()) do
	if Part:IsA("BasePart") and Part.Transparency == 0 and Part.LocalTransparencyModifier == 0 then
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
	task.wait(0.1)
	Part:GetPropertyChangedSignal("Transparency"):Connect(function()

		for i,Decal in pairs(Decals) do
			Decal.Transparency = Part.Transparency
		end

	end)




end)

task.wait(1)

game:GetService("TweenService"):Create(imageLabel, TweenInfo.new(2, Enum.EasingStyle.Linear), {ImageTransparency = 1}):Play()

game:GetService("TweenService"):Create(textLabel, TweenInfo.new(2, Enum.EasingStyle.Linear), {TextTransparency = 1}):Play()

game:GetService("TweenService"):Create(textLabel, TweenInfo.new(2, Enum.EasingStyle.Linear), {TextStrokeTransparency = 1}):Play()

task.wait(4)


GIHUN:Destroy()

Sound:Destroy()
