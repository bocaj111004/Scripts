local Player = game:GetService('Players').LocalPlayer
local Character = Player.Character

local Collision = Character:WaitForChild("Collision", 9e9)
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart", 9e9)
local CollisionClone = Collision:Clone()
CollisionClone.Name = "ClonedCollision"
CollisionClone.Parent = Character
CollisionClone.CanCollide = false
CollisionClone.CanTouch = false
CollisionClone.CanQuery = false
CollisionClone.Massless = true


if getgenv().SpeedBypass == nil then 
	getgenv().SpeedBypass = false
	end

while true do
	if getgenv().SpeedBypass == true then
		if HumanoidRootPart.Anchored then
			CollisionClone.Massless = true
		else
			CollisionClone.Massless = not CollisionClone.Massless
		end

		
	end
	task.wait(0.23)
end
