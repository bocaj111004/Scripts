local RunService = game:GetService("RunService")

local shears = game:GetObjects("rbxassetid://13468481018")[1]
local attachments = {}
shears.CanBeDropped = false


shears:FindFirstChild("Animations"):Destroy()


shears.Parent = game.Players.LocalPlayer.Backpack
shears.Handle:WaitForChild("Switch").Name = "Switch_"
shears.Handle:WaitForChild("ShadowMaker").Decal.Color3 = Color3.fromRGB(0,0,0)
shears.Handle:WaitForChild("Neon").Attachment.SurfaceLight.Range = 60
shears.Handle:WaitForChild("Neon").Attachment.SurfaceLight.Angle = 55
shears.Handle:WaitForChild("Neon").Attachment.SurfaceLight.Brightness = 3
shears.Handle:WaitForChild("Neon").Attachment.SurfaceLight.Color = Color3.fromRGB(255, 201, 153)
shears.Handle:WaitForChild("Neon").LightAttach.SurfaceLight.Range = 60
shears.Handle:WaitForChild("Neon").LightAttach.SurfaceLight.Angle = 34
shears.Handle:WaitForChild("Neon").LightAttach.SurfaceLight.Brightness = 3
shears.Handle:WaitForChild("Neon").LightAttach.SurfaceLight.Color = Color3.fromRGB(189, 149, 113)


local EndAttachment = Instance.new("Attachment")
EndAttachment.Name = "EndAttachment"
EndAttachment.Parent = shears:WaitForChild("Handle").Neon
EndAttachment.CFrame = CFrame.new(0, 0, -8.66573334, 1, 0, 0, 0, 1, 0, 0, 0, 1)
local Beam = Instance.new("Beam")
Beam.Parent = shears:WaitForChild("Handle").Neon
shears:WaitForChild("Handle").Neon.LightAttach.SurfaceLight.Color = Color3.fromRGB(235, 171, 124)




local color = Color3.fromRGB(235, 171, 124)

-- Create a ColorSequence using just this color for both Keypoints
local colorSequence = ColorSequence.new({
	ColorSequenceKeypoint.new(0,Color3.fromRGB(235, 171, 124)),
	ColorSequenceKeypoint.new(0.5,Color3.fromRGB(235, 171, 124)),
	ColorSequenceKeypoint.new(1,Color3.fromRGB(235, 171, 124))
})
Beam.LightEmission = 1
Beam.LightInfluence = 0
Beam.Brightness = 0
Beam.Texture = "rbxassetid://15149007027"
Beam.TextureLength = 14
Beam.TextureMode = Enum.TextureMode.Static
Beam.TextureSpeed = 0
Beam.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(0.5, 0.047956),
	NumberSequenceKeypoint.new(0.75, 0),
	NumberSequenceKeypoint.new(1, 1),

})

Beam.Attachment0 = shears:WaitForChild("Handle").Neon.LightAttach
Beam.Attachment1 = EndAttachment
Beam.Width0 = 1
Beam.Width1 = 20
Beam.CurveSize0 = 0
Beam.CurveSize1 = 0
Beam.FaceCamera = true
Beam.Segments = 20
Beam.ZOffset = 0


shears:SetAttribute("LightSourceBeam",true)
shears:SetAttribute("LightSourceStrong",true)
shears:SetAttribute("Enabled",false)
shears:SetAttribute("Interactable",true)
shears:SetAttribute("LightSource",true)
shears:SetAttribute("Durability",nil)
shears:SetAttribute("DurabilityMax",nil)
shears:SetAttribute("NamePlural","Shakelights")
shears:SetAttribute("NameSingular","Shakelight")
shears:SetAttribute("ToolOffset",Vector3.new(0, 0.20000000298023224, -0.20000000298023224))
local newCFrame = CFrame.new(-0.094802849, -0.00991820451, 0.0960054174, 0, 0, -1, -1, 0, 0, 0, 1, 0)

shears.Grip = newCFrame
shears.WorldPivot = CFrame.new(249.886551, 1.53111672, -16.8949146, -0.765167952, 0.00742102973, 0.64378804, -0.000446901657, 0.999927223, -0.0120574543, -0.643830597, -0.00951368641, -0.765108943)
shears.Name = "Flashlight"
local Animations_Folder = Instance.new("Folder")
Animations_Folder.Name = "Animations"
Animations_Folder.Parent = shears
local Shake_Animation = Instance.new("Animation")
Shake_Animation.AnimationId = "rbxassetid://15386224888"
Shake_Animation.Parent = Animations_Folder
local Idle_Animation = Instance.new("Animation")
Idle_Animation.AnimationId = "rbxassetid://11372556429"
Idle_Animation.Parent = Animations_Folder
local Equip_Animation = Instance.new("Animation")
Equip_Animation.AnimationId = "rbxassetid://15386368619"
Equip_Animation.Parent = Animations_Folder
local Shake_Sound = Instance.new("Sound")
Shake_Sound.Name = "Shake_Sound"
Shake_Sound.Parent = shears
Shake_Sound.Volume = 1
Shake_Sound.SoundId = "rbxassetid://9114481260"
Shake_Sound.PlaybackSpeed = 0.9
local Shaking = false
shears.TextureId = "rbxassetid://16680616231"

local Animator = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):FindFirstChildOfClass("Animator")
local anim2 = Animator:LoadAnimation(Idle_Animation)
anim2.Priority = Enum.AnimationPriority.Action3

local anim3 = Animator:LoadAnimation(Equip_Animation)
anim3.Priority = Enum.AnimationPriority.Action3
anim3:Play()

local anim = Animator:LoadAnimation(Shake_Animation)	
local enabled = false
shears.Activated:Connect(function()
	if Shaking == false and shears.Parent == game.Players.LocalPlayer.Character then





		anim.Priority = Enum.AnimationPriority.Action4

		anim:Stop()
		Shaking = true
		task.wait()
		anim:Play()

		Shake_Sound:Play()
		enabled = not enabled
		if enabled == true then
			
		else

			
		end

		task.wait(0.25)

		Shaking = false


	end

end)
local connection = RunService.RenderStepped:Connect(function()
	for i,attach in pairs(attachments) do
		attach.Enabled = enabled
	end
	if enabled == true then

		Shake_Sound.PlaybackSpeed = 1

	else

		Shake_Sound.PlaybackSpeed = 0.7

	end
end)
shears.Equipped:Connect(function()
	anim3:Play()
	anim2:Play()

end)
shears.Unequipped:Connect(function()
	anim2:Stop()
	enabled = false
	

end)	
task.wait(0.1)
for i,attach in pairs(shears:GetDescendants()) do
	if attach:IsA("SpotLight") or attach:IsA("PointLight") or attach:IsA("SurfaceLight") or attach:IsA("ParticleEmitter") and attach.Name == "Shiny"  then
		table.insert(attachments,attach)
		if attach:IsA("ParticleEmitter") then


			if attach.Name == "Shiny" then
				attach.Texture = "rbxassetid://15148942452"
				attach.Rate = 20
				attach.Lifetime = NumberRange.new(0.3,0.3)
				attach.LightEmission = 0.1
				attach.Size = NumberSequence.new({
					NumberSequenceKeypoint.new(0,1.3),
					NumberSequenceKeypoint.new(0.5,1.3),
					NumberSequenceKeypoint.new(1,1.3)
				})
				attach.Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),

					NumberSequenceKeypoint.new(0.5, 0),
					NumberSequenceKeypoint.new(1, 1)
				})
			end



		end

	end

end
shears.Destroying:Wait()
connection:Disconnect()
