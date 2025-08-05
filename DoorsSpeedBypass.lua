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
task.wait(1)
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


while task.wait() do
	if getgenv().SpeedBypass == true and CollisionClone and Player.Character:FindFirstChild("HumanoidRootPart") then

		if Player.Character.HumanoidRootPart.Anchored and CollisionClone then
			CollisionClone.Massless = true
			task.wait(1)
		
		
		elseif not Player.Character.HumanoidRootPart.Anchored and CollisionClone then
			CollisionClone.Massless = not CollisionClone.Massless
			task.wait(0.215)
		end
	


		

	else
		
		if CollisionClone then
			CollisionClone.Massless = true
		end
		

	end

end
