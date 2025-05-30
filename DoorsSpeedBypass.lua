local Player = game:GetService('Players').LocalPlayer
local Character = Player.Character

local Collision = Character:WaitForChild("Collision", 9e9)
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart", 9e9)
local CollisionClone = Collision:Clone()
CollisionClone.Name = "ClonedCollision"
CollisionClone.Parent = Character
CollisionClone.CanCollide = false
CollisionClone.Massless = true



getgenv().SpeedBypass = true


while task.wait(0.22) do
	if getgenv().SpeedBypass == true then
		if HumanoidRootPart.Anchored then
			CollisionClone.Massless = true
		else
			CollisionClone.Massless = not CollisionClone.Massless
		end
	else
		CollisionClone.Massless = true

	end

end
