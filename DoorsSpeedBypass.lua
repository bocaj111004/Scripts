local Player = game:GetService('Players').LocalPlayer
local Character = Player.Character

local Collision = Character:WaitForChild("Collision", 9e9)
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart", 9e9)
local CollisionClone = Collision:Clone()
CollisionClone.Name = "ClonedCollision"
CollisionClone.Parent = Character
CollisionClone.CanCollide = false
CollisionClone.Massless = true

if CollisionClone:FindFirstChild("CollisionCrouch") then
	CollisionClone.CollisionCrouch:Destroy()
end

Player.CharacterAdded:Connect(function(NewCharacter)

	Collision = NewCharacter:WaitForChild("Collision", 9e9)
	HumanoidRootPart = NewCharacter:WaitForChild("HumanoidRootPart", 9e9)
	CollisionClone = Collision:Clone()
	CollisionClone.Name = "ClonedCollision"
	CollisionClone.Parent = NewCharacter
	CollisionClone.CanCollide = false
	CollisionClone.Massless = true
	Character = NewCharacter
end)



getgenv().SpeedBypass = true


while task.wait(0.22) do
	if getgenv().SpeedBypass == true and CollisionClone then

		if Player.Character:FindFirstChild("HumanoidRootPart") and not Player.Character.HumanoidRootPart.Anchored then
		CollisionClone.Massless = false
		end
		task.wait(0.22)


		if Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character.HumanoidRootPart.Anchored and CollisionClone then
			CollisionClone.Massless = true
			task.wait(1)
		end


		if CollisionClone then
			CollisionClone.Massless = true
		end

	end

end
