if getgenv().GIHUN == true then
	return

end


getgenv().GIHUN = true

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
		task.wait(0.05)
	end
end


local Sound = Instance.new("Sound")
Sound.TimePosition = 0.2
Sound.SoundId = "rbxassetid://6308606116"
Sound.Volume = 3
Sound.Parent = game.CoreGui
Sound:Play()

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local GIHUN = Instance.new("ScreenGui")
GIHUN.Parent = game.CoreGui
GIHUN.DisplayOrder = 9999999
GIHUN.IgnoreGuiInset = true


local imageLabel = Instance.new("ImageLabel")
imageLabel.Size = UDim2.new(1, 0, 1, 0)
imageLabel.Position = UDim2.new(0, 0, 0, 0)
imageLabel.Image = "rbxassetid://8508980527"
imageLabel.BackgroundTransparency = 1
imageLabel.Parent = GIHUN

local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, 0, 0.1, 0)
textLabel.Position = UDim2.new(0, 0, 0.85, 0)
textLabel.BackgroundTransparency = 1
textLabel.TextScaled = true
textLabel.TextStrokeTransparency = 0
textLabel.TextColor3 = Color3.new(1, 1, 1)
textLabel.Font = Enum.Font.Oswald
textLabel.Parent = GIHUN
textLabel.Text = ""



task.wait(1)





AddText(textLabel, "hello there, " .. player.DisplayName .. "...")

task.wait(3)

AddText(textLabel, "oh, so you wanted blackking v2?")

task.wait(3)


AddText(textLabel, "i, gihunini, cannot allow you to possess such great power.")

task.wait(3)

AddText(textLabel, "now begone, mortal, and never return.")

task.wait(3)

game:GetService("TweenService"):Create(imageLabel, TweenInfo.new(3, Enum.EasingStyle.Linear), {ImageTransparency = 1}):Play()

game:GetService("TweenService"):Create(textLabel, TweenInfo.new(3, Enum.EasingStyle.Linear), {TextTransparency = 1}):Play()

game:GetService("TweenService"):Create(textLabel, TweenInfo.new(3, Enum.EasingStyle.Linear), {TextStrokeTransparency = 1}):Play()

task.wait(4)

getgenv().GIHUN = false

GIHUN:Destroy()

Sound:Destroy()
