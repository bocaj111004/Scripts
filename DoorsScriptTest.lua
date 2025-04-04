
-- Variables --

local Library = {
	MainFolder = Instance.new("Folder"),
	ObjectsFolder = Instance.new("Folder"),
	ScreenGui = Instance.new("ScreenGui"),
	OtherGui = Instance.new("ScreenGui"),
	HighlightsFolder = Instance.new("Folder"),
	BillboardsFolder = Instance.new("Folder"),
	Highlights = {},
	Labels = {},
	Elements = {},
	Frames = {},
	Connections = {},
	Billboards = {},
	ColorTable = {},
	TextTable = {},
	Font = Enum.Font.Oswald,
	ConnectionsTable = {},
	Objects = {},
	TracerTable = {},
	HighlightedObjects = {},
	RemoveIfNotVisible = true,
	Rainbow = false,
	UseBillboards = true,
	Tracers = false,
	ShowDistance = false,
	MatchColors = true,
	TextTransparency = 0,
	TracerOrigin = "Bottom",
	FillTransparency = 0.75,
	OutlineTransparency = 0,
	TextOutlineTransparency = 0,
	FadeTime = 0,
	TextSize = 20,
	OutlineColor = Color3.fromRGB(255,255,255)
}

local RainbowTable = {
	HueSetup = 0,
	Hue = 0,
	Step = 0,
	Color = Color3.new(),
	Enabled = false,


}


MainFolder = Library.MainFolder
ObjectsFolder = Library.ObjectsFolder
HttpService = game:GetService("HttpService")
HighlightedObjects = Library.HighlightedObjects
Highlights = Library.Highlights
Camera = workspace.CurrentCamera
ConnectionsTable = Library.ConnectionsTable
Objects = Library.Objects
Billboards = Library.Billboards
Frames = Library.Frames
ScreenGui = Library.ScreenGui
HighlightsFolder = Library.HighlightsFolder
BillboardsFolder = Library.BillboardsFolder
Labels = Library.Labels
Connections = Library.Connections
OtherGui = Library.OtherGui 
Elements = Library.Elements
TextTable = Library.TextTable
CoreGui = game:GetService("CoreGui")
Players = game:GetService("Players")
RunService = game:GetService("RunService")
TweenService = game:GetService("TweenService")
ProtectGui = protectgui or (function() end);
ColorTable = Library.ColorTable
ScreenGui.Parent = MainFolder
OtherGui.Parent = ScreenGui
HighlightsFolder.Parent = MainFolder
BillboardsFolder.Parent = MainFolder
MainFolder.Parent = CoreGui

pcall(ProtectGui,ScreenGui)
pcall(ProtectGui,OtherGui)

-- Functions --

function Library:GenerateRandomString()
	local Characters = "abcdefghijklmnopqrstuvwxyz1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ"

	local RandomString = ""


	local function GenerateSegment()

		local Result = {}
		local RandomNumber = math.random(6,11)
		for i = 1, RandomNumber do

			local RandomIndex = math.random(1, #Characters)
			table.insert(Result, Characters:sub(RandomIndex, RandomIndex))
		end
		return table.concat(Result)
	end
	local Segment1 = GenerateSegment()
	local Segment2 = GenerateSegment()
	local Segment3 = GenerateSegment()
	local Segment4 = GenerateSegment()
	local Segment5 = GenerateSegment()
	local Segment6 = GenerateSegment()
	RandomString = Segment1 .. Segment2 .. Segment3 .. Segment4 .. Segment5 .. Segment6
	return RandomString
end

function Library:AddESP(Parameters)
	local Object = Parameters.Object
	local TransparencyEnabled = false
	if Objects[Object] ~= nil then return end
	if ConnectionsTable[Object] == nil then





		local MainPart = nil
		if Parameters.BasePart then
			MainPart = Parameters.BasePart
		end

		local Highlight
		local ObjectTable = {}
		TextTable[Object] = Parameters.Text

		local TextFrame = Instance.new("Frame")
		TextFrame.Name = Library:GenerateRandomString()
		TextFrame.BackgroundTransparency = 1
		TextFrame.Size = UDim2.new(1,0,1,0)
		TextFrame.AnchorPoint = Vector2.new(0.5,0.5)
		TextFrame.Parent = ScreenGui
		local TextLabel = Instance.new("TextLabel")
		TextLabel.Name = Library:GenerateRandomString()
		TextLabel.BackgroundTransparency = 1
		TextLabel.Text = Parameters.Text
		TextLabel.TextTransparency = 1
		TextLabel.TextStrokeTransparency = Library.TextOutlineTransparency
		TextLabel.Size = UDim2.new(1,0,1,0)
		TextLabel.Font = Library.Font
		TextLabel.TextSize = Library.TextSize
		TextLabel.Parent = TextFrame
		TextLabel.TextColor3 = Parameters.Color
		local BillboardGui = Instance.new("BillboardGui")
		BillboardGui.Name = Library:GenerateRandomString()
		BillboardGui.Parent = BillboardsFolder
		BillboardGui.Adornee = Object
		BillboardGui.Size = UDim2.new(200,0,50,0)
		BillboardGui.AlwaysOnTop = true


		Billboards[Object] = BillboardGui
		Labels[Object] = TextLabel
		Objects[Object] = ObjectTable
		if Library.UseBillboards == true then
			TextLabel.Parent = BillboardGui
		else
			TextLabel.Parent = TextFrame
		end
		local Lines = {}

		local Camera = workspace.CurrentCamera
		local function GetLineOrigin()

			if Library.TracerOrigin == "Center" then
				local mousePos = game:GetService("UserInputService"):GetMouseLocation();
				return Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2.25)

			elseif Library.TracerOrigin == "Top" then
				return Vector2.new(Camera.ViewportSize.X/2, -Camera.ViewportSize.Y/18)	
			elseif Library.TracerOrigin == "Mouse" then
				return Vector2.new(game.Players.LocalPlayer:GetMouse().X,game.Players.LocalPlayer:GetMouse().Y)

			else
				if game.UserInputService.TouchEnabled and not game.UserInputService.KeyboardEnabled then
					return Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y*0.94)
				else
					return Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y*0.9475)
				end
			end
		end
		local function Setline(Line, Width, ColorToSet, Origin, Destination)
			local Position = (Origin + Destination) / 2
			Line.Position = UDim2.new(0, Position.X, 0, Position.Y)
			local Length = (Origin - Destination).Magnitude

			Line.Size = UDim2.new(0, Length, 0, Width)
			Line.Rotation = math.deg(math.atan2(Destination.Y - Origin.Y, Destination.X - Origin.X))
			Line.BackgroundColor3 = ColorTable[Object]
			Line.BorderColor3 = ColorTable[Object]
			Line.BorderSizePixel = 0

			if Line:FindFirstChild("UIStroke") then
				Line.UIStroke.Color = ColorTable[Object]
				Line.UIStroke.Thickness = 0.75
			end
		end
		local ConnectionCooldown = false
		local Connection = RunService.RenderStepped:Connect(function()
			
			if Library.Rainbow == true and Highlight ~= nil then
				Highlight.FillColor = RainbowTable.Color
				if Library.MatchColors == true then
					Highlight.OutlineColor = ColorTable[Object]
				else
					Highlight.OutlineColor = Library.OutlineColor
				end
				TextLabel.TextColor3 = RainbowTable.Color
			elseif Library.Rainbow == false and Highlight ~= nil then
				Highlight.FillColor = ColorTable[Object]
				if Library.MatchColors == true then
					Highlight.OutlineColor = ColorTable[Object]
				else
					Highlight.OutlineColor = Library.OutlineColor
				end
				TextLabel.TextColor3 = ColorTable[Object]
			end


	
			RunService.Heartbeat:Wait()

			local pos

			if Object:IsA("Model") then
				
				if Object.PrimaryPart ~= nil then
					
					pos = Object.PrimaryPart.Position
				else
					
					pos = Object.WorldPivot.Position

				end
			else
				
				if Object then
				
					pos = Object.Position
				end
			end

			
			if Library.ShowDistance == true then
				TextLabel.Text = TextTable[Object] .. "\n[" .. math.round(Players.LocalPlayer:DistanceFromCharacter(pos)) .. "]"
			else
				TextLabel.Text = TextTable[Object]
			end

			local vector, onScreen = game.Workspace.CurrentCamera:WorldToScreenPoint(pos)
			local Targets = {}
			local Character = Object
			if not Character then return end
			local LineOrigin = GetLineOrigin()

			local ScreenPoint, OnScreen = game.Workspace.CurrentCamera:WorldToScreenPoint(pos)
			TextLabel.Visible = OnScreen
			if OnScreen then
				table.insert(Targets, {Vector2.new(ScreenPoint.X, ScreenPoint.Y), ColorTable[Object]})
			


			end

			if Library.Tracers == true then
				if #Targets > #Lines then

					local NewLine = Instance.new("Frame")
					NewLine.Name = Library:GenerateRandomString()
					NewLine.AnchorPoint = Vector2.new(.5, .5)
					NewLine.Parent = ScreenGui


					local Border = Instance.new("UIStroke")
					Border.Parent = NewLine
					Border.Transparency = 1
					Border.Thickness = 0.75
					Border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					Library.TracerTable[Object] = NewLine

					if Library.Tracers == true  then
						game:GetService("TweenService"):Create(Border,TweenInfo.new(Library.FadeTime,Enum.EasingStyle.Quad),{Transparency = 0}):Play()
					end


					table.insert(Lines, NewLine)
				end
				if ConnectionCooldown == false then
				for i, Line in pairs(Lines) do
					local TargetData = Targets[i]
					if not TargetData then
						Line:Destroy()
						table.remove(Lines, i)
						continue
					end
					Setline(Line, 0, ColorTable[Object], LineOrigin, TargetData[1])
					end




				end

			elseif Library.Tracers == false then
				if ConnectionCooldown == false then
					
				for i,line in pairs(Lines) do


					line:Destroy()

				end
				end
			end	

			if Library.UseBillboards == false then
				local Position = Vector3.new(0,0,0)










				if Object:IsA("Model") then
					if Object.PrimaryPart then
						local NewVector, VisibleCheck = Camera:WorldToScreenPoint(Object.PrimaryPart.Position)
						local UIPosition = UDim2.new(NewVector.X/OtherGui.AbsoluteSize.X,0,NewVector.Y/OtherGui.AbsoluteSize.Y,0)

						TextFrame.Position = UIPosition
						TextFrame.Visible = VisibleCheck
						if ConnectionCooldown == false then
						if VisibleCheck == false then
							if Highlights[Object] then
								Highlights[Object]:Destroy()
								Highlights[Object] = nil
								Labels[Object] = TextLabel
							end
						else

							if Highlights[Object] == nil then
								local NewHighlight = Instance.new("Highlight")
								NewHighlight.FillTransparency = 1
								NewHighlight.OutlineTransparency = 1
								NewHighlight.Name = Library:GenerateRandomString()
								NewHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
								if TransparencyEnabled == true then
									NewHighlight.FillTransparency = Library.FillTransparency
									NewHighlight.OutlineTransparency = Library.OutlineTransparency
								else
									TweenService:Create(NewHighlight,TweenInfo.new(Library.FadeTime,Enum.EasingStyle.Quad),{FillTransparency = Library.FillTransparency}):Play()
									TweenService:Create(NewHighlight,TweenInfo.new(Library.FadeTime,Enum.EasingStyle.Quad),{OutlineTransparency = Library.OutlineTransparency}):Play()
								end
								NewHighlight.FillColor = Parameters.Color
								NewHighlight.OutlineColor = Parameters.Color
								NewHighlight.Parent = HighlightsFolder
								NewHighlight.Adornee = Object
								Highlight = NewHighlight
								Highlights[Object] = NewHighlight
								Labels[Object] = TextLabel
							end
						end
						end
					end
				else
					if Object then
						local NewVector, VisibleCheck = Camera:WorldToScreenPoint(Object.Position)
						local UIPosition = UDim2.new(NewVector.X/OtherGui.AbsoluteSize.X,0,NewVector.Y/OtherGui.AbsoluteSize.Y,0)


						TextFrame.Position = UIPosition
						TextFrame.Visible =  VisibleCheck
						if ConnectionCooldown == false then
						if VisibleCheck == false then
							if Highlights[Object] then
								Highlights[Object]:Destroy()
								Highlights[Object] = nil
								Labels[Object] = TextLabel
							end
						else

							if Highlights[Object] == nil then
								local NewHighlight = Instance.new("Highlight")
								NewHighlight.FillTransparency = 1
								NewHighlight.OutlineTransparency = 1
								NewHighlight.Name = Library:GenerateRandomString()
								NewHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
								if TransparencyEnabled == true then
									NewHighlight.FillTransparency = Library.FillTransparency
									NewHighlight.OutlineTransparency = Library.OutlineTransparency
								else
									TweenService:Create(NewHighlight,TweenInfo.new(Library.FadeTime,Enum.EasingStyle.Quad),{FillTransparency = Library.FillTransparency}):Play()
									TweenService:Create(NewHighlight,TweenInfo.new(Library.FadeTime,Enum.EasingStyle.Quad),{OutlineTransparency = Library.OutlineTransparency}):Play()
								end
								NewHighlight.FillColor = Parameters.Color
								NewHighlight.OutlineColor = Parameters.Color
								NewHighlight.Parent = HighlightsFolder
								NewHighlight.Adornee = Object
								Highlight = NewHighlight
								Highlights[Object] = NewHighlight
								Labels[Object] = TextLabel
							end
						end

						end
						end
				end


				ConnectionCooldown = true
task.wait(0.1)
ConnectionCooldown = false

			end
		end)
		table.insert(Connections,Connection)




		Highlights[Object] = Highlight
		Frames[Object] = TextFrame
		Labels[Object] = TextLabel
		ConnectionsTable[Object] = Connection
		Objects[Object] = ObjectTable
		ColorTable[Object] = Parameters.Color 

		if TextLabel then
			local Tween = TweenService:Create(TextLabel,TweenInfo.new(Library.FadeTime,Enum.EasingStyle.Quad),{TextTransparency = Library.TextTransparency})
			Tween:Play()
			Tween.Completed:Connect(function()
				TransparencyEnabled = true
			end)
		end




		table.insert(Elements,TextFrame)




		Object:GetPropertyChangedSignal("Parent"):Connect(function()
			Library:RemoveESP(Object)

		end)
		if Object.Parent ~= nil then
			Object.Parent:GetPropertyChangedSignal("Parent"):Connect(function()
				Library:RemoveESP(Object)

			end)
		end
		if Object:IsA("Model") and Object.PrimaryPart then
			Object.PrimaryPart:GetPropertyChangedSignal("Parent"):Connect(function()
				Library:RemoveESP(Object)

			end)
		end
	end
end


function Library:SetColorTable(Name,Color)
	ColorTable[Name] = Color
end

function Library:SetFadeTime(Number)
	Library.FadeTime = Number
end

function Library:SetTextTransparency(Number)
	Library.TextTransparency = Number
	for i,Label in pairs(Labels) do
		Label.TextTransparency = Number
	end
end

function Library:SetFillTransparency(Number)
	Library.FillTransparency = Number
	for i,Highlight in pairs(Highlights) do
		if Highlight:IsA("Highlight") then
			Highlight.FillTransparency = Number
		end
	end
end

function Library:SetOutlineTransparency(Number)
	Library.OutlineTransparency = Number
	for i,Highlight in pairs(Highlights) do
		if Highlight:IsA("Highlight") then
			Highlight.OutlineTransparency = Number
		end
	end
end

function Library:SetTextSize(Number)
	Library.TextSize = Number
	for i,Label in pairs(Labels) do
		Label.TextSize = Number
	end
end
function Library:SetTextOutlineTransparency(Number)
	Library.TextOutlineTransparency = Number
	for i,Label in pairs(Labels) do
		Label.TextStrokeTransparency = Number
	end
end
function Library:SetFont(Font)
	Library.Font = Font
	for i,Label in pairs(Labels) do
		Label.Font = Font
	end
end

function Library:UpdateObjectText(Object,Text)
	if Labels[Object] then
		TextTable[Object] = Text
	end
end

function Library:SetOutlineColor(Color)
	Library.OutlineColor = Color
end




function Library:RemoveESP(Object)
if Objects[Object] == nil then return end
	if ConnectionsTable[Object] ~= nil then

		local Highlight = Highlights[Object]
		local TextFrame = Frames[Object]
		local BillboardGui = Billboards[Object]
		local TextLabel = Labels[Object]
		Objects[Object] = nil
		if Highlight and TextLabel then
			TweenService:Create(Highlight,TweenInfo.new(Library.FadeTime,Enum.EasingStyle.Quad),{FillTransparency = 1}):Play()
			TweenService:Create(Highlight,TweenInfo.new(Library.FadeTime,Enum.EasingStyle.Quad),{OutlineTransparency = 1}):Play()
			TweenService:Create(TextLabel,TweenInfo.new(Library.FadeTime,Enum.EasingStyle.Quad),{TextTransparency = 1}):Play()
			task.wait(Library.FadeTime)	
		end

		
		if Library.TracerTable[Object] then
			Library.TracerTable[Object]:Destroy()
		end
		if TextFrame then
			TextFrame:Destroy()
		end
		if BillboardGui then
			BillboardGui:Destroy()
		end

		if ConnectionsTable[Object] and Objects[Object] == nil then
			ConnectionsTable[Object]:Disconnect()
			ConnectionsTable[Object] = nil
		end
		if Highlight and TextLabel then
			Highlight:Destroy()
			TextLabel:Destroy()
		end
	end
end




ConnectionsTable.RainbowConnection = RunService.RenderStepped:Connect(function(Delta)

	RainbowTable.Step = RainbowTable.Step + Delta

	if RainbowTable.Step >= (1 / 60) then
		RainbowTable.Step = 0

		RainbowTable.HueSetup = RainbowTable.HueSetup + (1 / 400);
		if RainbowTable.HueSetup > 1 then RainbowTable.HueSetup = 0; end;
		RainbowTable.Hue = RainbowTable.HueSetup;
		RainbowTable.Color = Color3.fromHSV(RainbowTable.Hue, 0.8, 1);


	end
end)




function Library:Unload()
	for i,Element in pairs(Elements) do

		Element:Destroy()

	end
	for i,Element in pairs(Library.TracerTable) do

		Element:Destroy()

	end
	for i,Connection in pairs(ConnectionsTable) do
		Connection:Disconnect()
	end
	
	ScreenGui:Destroy()
	OtherGui:Destroy()
	Library = nil
	getgenv().ESPLibrary = nil
end
-- Finishing Touches --

ObjectsFolder.Name = Library:GenerateRandomString()
MainFolder.Name = Library:GenerateRandomString()
ScreenGui.Name = Library:GenerateRandomString()
OtherGui.Name = Library:GenerateRandomString()
HighlightsFolder.Name = Library:GenerateRandomString()
BillboardsFolder.Name = Library:GenerateRandomString()
getgenv().ESPLibrary = Library

local ESPLibrary = Library
if queue_on_teleport then
queue_on_teleport("print('umm henlo')")
end
local Functions = {}
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local PathfindingService = game:GetService("PathfindingService")
local PathfindingFolder = Instance.new("Folder")
PathfindingFolder.Name = ESPLibrary:GenerateRandomString()
PathfindingFolder.Parent = game.Workspace
local scriptlink = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/bocaj111004/Scripts/refs/heads/main/DoorsScriptTest.lua")))()'

local ScriptName = "Jacob's Epic Script"
local RemotesFolder
if ReplicatedStorage:FindFirstChild("RemotesFolder") then
	RemotesFolder = ReplicatedStorage:FindFirstChild("RemotesFolder")
elseif ReplicatedStorage:FindFirstChild("EntityInfo") then
	RemotesFolder = ReplicatedStorage:FindFirstChild("EntityInfo")
else
	RemotesFolder = ReplicatedStorage:FindFirstChild("Bricks")
end
local ChatNotifyMonsters = false
local MonsterChatNotify = "has spawned. Find a hiding spot!"
local function ChatNotify(Text)
	local textchannel = game:GetService("TextChatService"):WaitForChild("TextChannels"):WaitForChild("RBXGeneral") 
	local message = Text
	textchannel:SendAsync(message)
end
function GetNearestAssetWithCondition(condition: () -> ())
	local nearestDistance = math.huge
	local nearest
	for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
		if not room:FindFirstChild("Assets") then continue end

		for _, asset in pairs(room.Assets:GetChildren()) do
			if condition(asset) and Player:DistanceFromCharacter(asset.PrimaryPart.Position) < nearestDistance then
				nearestDistance = Player:DistanceFromCharacter(asset.PrimaryPart.Position)
				nearest = asset
			end
		end
	end

	return nearest
end

local Connections = {}

local notifvolume = 3
EntityCounter = 0
GlitchCounter = 0
local textsize = 20
local textfont = "RobotoCondensed"
notif = true
NotifyType = "Linora"
pingid = "4590657391"
monsternotif = false
DeletingSeek = false
tracerthickness = 1


local function forcefireproximityprompt(Obj)
	if Obj:IsA("ProximityPrompt") and Obj.Parent ~= nil then 



		fireproximityprompt(Obj, 0)
		
		
	end
end
function GetPadlockCode(paper: Tool)
	if paper:FindFirstChild("UI") then
		local code = {}

		for _, image: ImageLabel in pairs(paper.UI:GetChildren()) do
			if image:IsA("ImageLabel") and tonumber(image.Name) then
				code[image.ImageRectOffset.X .. image.ImageRectOffset.Y] = {tonumber(image.Name), "_"}
			end
		end

		for _, image: ImageLabel in pairs(game.Players.LocalPlayer.PlayerGui.PermUI.Hints:GetChildren()) do
			if image.Name == "Icon" then
				if code[image.ImageRectOffset.X .. image.ImageRectOffset.Y] then
					code[image.ImageRectOffset.X .. image.ImageRectOffset.Y][2] = image.TextLabel.Text
				end
			end
		end

		local normalizedCode = {}
		for _, num in pairs(code) do
			normalizedCode[num[1]] = num[2]
		end

		return table.concat(normalizedCode)
	end

	return "_____"
end
function DoorsNotify(unsafeOptions)
	assert(typeof(unsafeOptions) == "table", "Expected a table as options argument but got " .. typeof(unsafeOptions))


	local options = {
		Title = unsafeOptions.Title,
		Description = unsafeOptions.Description,
		Reason = unsafeOptions.Reason,
		NotificationType = unsafeOptions.NotificationType,
		Image = unsafeOptions.Image,
		Color = nil,
		Time = unsafeOptions.Time,

		TweenDuration = 0.8
	}

	if options.NotificationType == nil then
		options.NotificationType = "NOTIFICATION"
	end
	local acheivement = game.Players.LocalPlayer.PlayerGui.MainUI["AchievementsHolder"].Achievement:Clone()
	acheivement.Size = UDim2.new(0, 0, 0, 0)
	acheivement.Frame.Position = UDim2.new(1.1, 0, 0, 0)
	acheivement.Name = "LiveAchievement"
	acheivement.Visible = true

	acheivement.Frame.TextLabel.Text = options.NotificationType

	if options.NotificationType == "WARNING" then
		acheivement.Frame.TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
		acheivement.Frame.UIStroke.Color = Color3.fromRGB(255, 0, 0)
		acheivement.Frame.Glow.ImageColor3 = Color3.fromRGB(255, 0, 0)
	end


	acheivement.Frame.Details.Desc.Text = tostring(options.Description)
	acheivement.Frame.Details.Title.Text = tostring(options.Title)
	acheivement.Frame.Details.Reason.Text = tostring(options.Reason or "")

	acheivement.Frame.ImageLabel.BackgroundTransparency = 0
	if options.Image ~= nil then
		if options.Image:match("rbxthumb://") or options.Image:match("rbxassetid://") then
			acheivement.Frame.ImageLabel.Image = tostring(options.Image or "rbxassetid://0")
		else
			acheivement.Frame.ImageLabel.Image = "rbxassetid://" .. tostring(options.Image or "0")
		end
	else
		acheivement.Frame.ImageLabel.Image = "rbxassetid://6023426923"
	end
	acheivement.Parent = game.Players.LocalPlayer.PlayerGui.MainUI["AchievementsHolder"]
	acheivement.Sound.SoundId = "rbxassetid://10469938989"

	acheivement.Sound.Volume = 1

	if notif == true then
		acheivement.Sound:Play()
	end

	task.spawn(function()
		acheivement:TweenSize(UDim2.new(1, 0, 0.2, 0), "In", "Quad", options.TweenDuration, true)

		task.wait(0.8)

		acheivement.Frame:TweenPosition(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.5, true)

		game:GetService("TweenService"):Create(acheivement.Frame.Glow, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In),{
			ImageTransparency = 1
		}):Play()

		if options.Time ~= nil then
			if typeof(options.Time) == "number" then
				task.wait(options.Time)
			elseif typeof(options.Time) == "Instance" then
				options.Time.Destroying:Wait()
			end
		else
			task.wait(10)
		end

		acheivement.Frame:TweenPosition(UDim2.new(1.1, 0, 0, 0), "In", "Quad", 0.5, true)
		task.wait(0.5)
		acheivement:TweenSize(UDim2.new(1, 0, -0.1, 0), "InOut", "Quad", 0.5, true)
		task.wait(0.5)
		acheivement:Destroy()
	end)
end
OtherLinora = false
local NotificationHolder = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Module.Lua"))()
local NotificationCustom1 = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Client.Lua"))()
local repo = 'https://raw.githubusercontent.com/bocaj111004/Linora/refs/heads/main/'
local ReplicatedStorage = game:GetService("ReplicatedStorage")



local RequireCheck, result = pcall(function()
	require(1) -- Attempt to use require
end)




if getgenv().Library == nil then
	local LibraryLoadstring = loadstring(game:HttpGet(repo .. 'Library.lua'))()
else
	OtherLinora = true	
end

local Library = getgenv().Library


Library.ScreenGui.DisplayOrder = 999999



local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
local Toggles = getgenv().Toggles
local Options = getgenv().Options





local function DisableJeff()
	for _, jeff in pairs(workspace:GetChildren()) do
		if jeff:IsA("Model") and jeff.Name == "JeffTheKiller" then
			task.spawn(function()
				repeat task.wait() until Library.Unloaded
				jeff:FindFirstChildOfClass("Humanoid").Health = 0
			end)
			for i, v in pairs(jeff:GetDescendants()) do
				if v:IsA("BasePart") then
					v.CanTouch = false
				end
			end
		end
	end
end
local function Notify(notifytable)
	local reason = nil
	if notifytable.Reason then
		reason = " "..notifytable.Reason
	else
		reason = ""
	end
	if NotifyType == "Linora" then
		if Library.NotifySide == "Left" then
			Library:Notify(notifytable.Title .. " | "..notifytable.Description .. reason,notifytable.Time or 10)
		else
			Library:Notify(notifytable.Description .. reason .. " | "..notifytable.Title,notifytable.Time or 10)
		end

	elseif NotifyType == "Doors" then
		DoorsNotify(notifytable)
	elseif NotifyType == "STX" then
		if notifytable.Image then
			if typeof(notifytable.Time) == "Instance" then
				NotificationCustom1:Notify(
					{Title = string.upper(notifytable.Title), Description = notifytable.Description.."\n"..reason},
					{OutlineColor = Color3.fromRGB(80, 80, 80),Time = 10, Type = "image",Color = Color3.fromRGB(255,255,255)},
					{Image = notifytable.Image, ImageColor = Color3.fromRGB(255,255,255)}
				)	
			else
				NotificationCustom1:Notify(
					{Title = string.upper(notifytable.Title), Description = notifytable.Description.."\n"..reason},
					{OutlineColor = Color3.fromRGB(80, 80, 80),Time = notifytable.Time or 10, Type = "image"},
					{Image = notifytable.Image, ImageColor = Color3.fromRGB(255,255,255)}
				)
			end	
		else
			if typeof(notifytable.Time or 10) == "Instance" then
				NotificationCustom1:Notify(
					{Title = string.upper(notifytable.Title), Description = notifytable.Description.."\n"..reason},
					{OutlineColor = Color3.fromRGB(80, 80, 80),Time = 10, Type = "default"}
				)	
			else
				NotificationCustom1:Notify(
					{Title = string.upper(notifytable.Title), Description = notifytable.Description.."\n"..reason},
					{OutlineColor = Color3.fromRGB(80, 80, 80),Time = notifytable.Time or 10, Type = "default"}
				)
			end
		end
	end
end
local function Sound()
	if notif == true and NotifyType ~= "Doors" then
		local sound = Instance.new("Sound")
		sound.Name = ESPLibrary:GenerateRandomString()
		sound.Volume = notifvolume
		sound.Parent = game.Players.LocalPlayer.PlayerGui:WaitForChild("MainUI")
		sound:Play()
		sound.SoundId = "rbxassetid://"..pingid
		sound.Ended:Wait()
		sound:Destroy()
	end
end
Library.NotifySide = "Left"
task.wait(0.15)
if getgenv().JSHUB ~= true then
	getgenv().JSHUB = true

	if OtherLinora == false then
		if not game.Players.LocalPlayer.PlayerGui:FindFirstChild("MainUI") then
			Notify({Title = ScriptName .. " Initialisation", Description = ScriptName .. " is waiting for the game to load."})
			Sound()
			game.Players.LocalPlayer.PlayerGui:WaitForChild("MainUI",9999)
			
		
			task.wait(5)
		end




		Notify({Title = ScriptName .. " Initialisation",Description = "Script is now loading."})
		Sound()
		wait(1)
		local BreakerSolving = false
		function SolveBreakerBox()
			if game.Workspace.CurrentRooms:FindFirstChild("100") then

				if BreakerSolving == true then return end
				BreakerSolving = true
				Notify({
					Title = "ROOM 100",
					Description = "Interact with the breaker box.",
					Reason = "The breaker box will be automatically solved."
				})
				Sound()


				repeat task.wait(0.1)
					RemotesFolder.EBF:FireServer()
				until not workspace.CurrentRooms["100"]:FindFirstChild("DoorToBreakDown")
			end


		end
		local Entities = {"RushMoving","AmbushMoving","A60","A120","BackdoorRush","Eyes"}
		local ColorTable = {}
		local EntityShortNames = {
			["RushMoving"] = "Rush",
			["AmbushMoving"] = "Ambush",
			["A60"] = "A-60",
			["A120"] = "A-120",
			["BackdoorRush"] = "Blitz",
			["Eyes"] = "Eyes",
			["BackdoorLookman"] = "Lookman",
			["Lookman"] = "Eyes",
			["GloombatSwarm"] = "Gloombat Swarm",
			["Jeff"] = "Jeff",
			["Halt"] = "Halt"
		}
		local EntityAlliases = {
			["RushMoving"] = "Rush",
			["AmbushMoving"] = "Ambush",
			["A60"] = "A-60",
			["A120"] = "A-120",
			["BackdoorRush"] = "Blitz",
			["Eyes"] = "Eyes",
			["BackdoorLookman"] = "Lookman",
			["Lookman"] = "Eyes",
			["Gloombats"] = "Gloombat Swarm",
			["Halt"] = "Halt",
			["Jeff"] = "Jeff",
			["Giggle"] = "Giggle"
		}
		local EntityNotifers = {
			["Rush"] = false,
			["Ambush"] = false,
			["Eyes"] = false,
			["Blitz"] = false,
			["A-60"] = false,
			["A-120"] = false
		}
		local EntityIcons = {
			["RushMoving"] = "rbxassetid://10716032262",
			["AmbushMoving"] = "rbxassetid://10110576663",
			["A60"] = "rbxassetid://12571092295",
			["A120"] = "rbxassetid://12711591665",
			["BackdoorRush"] = "rbxassetid://16602023490",
			["Eyes"] = "rbxassetid://10183704772",
			["Lookman"] = "rbxassetid://10183704772",
			["BackdoorLookman"] = "rbxassetid://16764872677",
			["GloombatSwarm"] = "rbxassetid://79221203116470",
			["Halt"] = "rbxassetid://11331795398",
			["Jeff"] = "rbxassetid://103606506407224",
			["Giggle"] = ""
		}
		local EntityChatNotifyMessages = {
			["RushMoving"] = "Rush has spawned!",
			["AmbushMoving"] = "Ambush has spawned!",
			["A60"] = "A-60 has spawned!",
			["A120"] = "A-120 has spawned!",
			["BackdoorRush"] = "Blitz has spawned!",
			["Halt"] = "Halt will spawn in the next room!",
			["GloombatSwarm"] = "Gloombats will be in the next room. Turn off all light sources!",
			["Jeff"] = "Jeff has spawned!",
			["Eyes"] = "Eyes has spawned. Don't look at it!",
			["BackdoorLookman"] = "Lookman has spawned. Don't look at it!"
		}
		local EntityList = {"RushMoving","AmbushMoving","Eyes","A60","A120","BackdoorRush","Jeff","GloombatSwarm","Halt","BackdoorLookman"}	
		local Closets = {"Wardrobe","Rooms_Locker","Rooms_Locker_Fridge","Backdoor_Wardrobe","Locker_Large","Toolshed"}
		local Items = {"Lighter",
			"Flashlight",
			"Lockpick",
			"Vitamins",
			"Bandage",
			"StarVial",
			"LibraryHintPaper",
			"StarBottle",
			"StarJug",
			"Shakelight",
			"Straplight",
			"BigLight",
			"Battery",
			"Candle",
			"Crucifix",
			"CrucifixWall",
			"Glowsticks",
			"SkeletonKey",
			"Candy",
			"ShieldMini",
			"ShieldBig",
			"BandagePack",
			"BatteryPack",
			"RiftCandle",
			"Shakelight",
			"LaserPointer",
			"HolyGrenade",
			"Shears",
			"Straplight",
			"Smoothie",
			"Cheese",
			"Bulklight",
			"Bread",
			"AlarmClock",
			"RiftSmoothie",
			"GweenSoda",
			"GlitchCube"

		}
		local Items2 = {"Lighter",
			"Flashlight",
			"Lockpick",
			"Vitamins",
			"Bandage",
			"StarVial",
			"LibraryHintPaper",
			"StarBottle",
			"StarJug",
			"Shakelight",
			"Straplight",
			"BigLight",
			"Battery",
			"Candle",
			"Crucifix",
			"CrucifixWall",
			"Glowsticks",
			"SkeletonKey",
			"Candy",
			"ShieldMini",
			"ShieldBig",
			"BandagePack",
			"BatteryPack",
			"RiftCandle",
			"Shakelight",
			"LaserPointer",
			"HolyGrenade",
			"Shears",
			"Straplight",
			"Smoothie",
			"Cheese",
			"Bulklight",
			"Bread",
			"AlarmClock",
			"RiftSmoothie",
			"GweenSoda",
			"GlitchCube"

		}
		local SpeedBypassEnabled = false
		local SpeedBypassing = false
		local bypassdelay = 0.22
		local Character = Player.Character
		local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
		local Humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		local Collision = game.Players.LocalPlayer.Character:WaitForChild("Collision")
		local MainWeld = Collision:WaitForChild("Weld")
		local CollisionCrouch = Collision:FindFirstChild("CollisionCrouch") or nil
		local CollisionClone = Collision:Clone()

		CollisionClone.Parent = game.Players.LocalPlayer.Character
		CollisionClone.Name = ESPLibrary:GenerateRandomString()
		CollisionClone.Massless = true
		CollisionClone.CanQuery = false
		CollisionClone.CanCollide = false
		CollisionClone.Position = HumanoidRootPart.Position*Vector3.new(0,0,3)

		local CollisionClone2 = Collision:Clone()
		CollisionClone2.Parent = Character
		CollisionClone2.Name = ESPLibrary:GenerateRandomString()
		CollisionClone2.Massless = true
		CollisionClone2.CanQuery = false
		CollisionClone2.CanCollide = false


		if CollisionClone:FindFirstChild("CollisionCrouch") then
			CollisionClone.CollisionCrouch:Destroy()
		end
		if CollisionClone2:FindFirstChild("CollisionCrouch") then
			CollisionClone2.CollisionCrouch:Destroy()
		end
		function SpeedBypass()
			if SpeedBypassing == true or not CollisionClone then return end
			SpeedBypassing = true

			task.spawn(function()
				while Humanoid and CollisionClone do
					if not CollisionClone or Humanoid.WalkSpeed <= 21 then
						break
					end
					if HumanoidRootPart.Anchored then
						CollisionClone.Massless = true
						repeat task.wait() until not HumanoidRootPart.Anchored
						task.wait(0.15)
					else
						CollisionClone.Massless = not CollisionClone.Massless
					end
					task.wait(bypassdelay)
				end

				SpeedBypassing = false
				if CollisionClone then
					CollisionClone.Massless = true
				end
			end)
		end

		tracerorigin = "Bottom"
		SpeedBoostType = "SpeedBoost"
		MinesAnticheatBypassActive = false
		SpeedBoostEnabled = false
		doorcolor = Color3.fromRGB(0,255,0)
		ThirdPersonX = 0
		ThirdPersonY = 0.5
		ThirdPersonZ = 5
		espfadetime = 0.5
		espstrokethickness = 0
		entitycolor = Color3.fromRGB(255,0,0)
		bananapeelcolor = Color3.fromRGB(255,0,0)
		DoorsDifference = 0
		EntityESPShape = "Dynamic"
		EntityOutline = true
		DupeESP = false
		local bookcolor = Color3.fromRGB(0,255,255)
		local breakercolor = Color3.fromRGB(0,255,255)
		local textoffset = Vector3.new(0,0,0)
		local itemcolor = Color3.fromRGB(0,255,255)
		local generatorcolor = Color3.fromRGB(255,170,0)
		local snarecolor = Color3.fromRGB(255,0,0)
		local closetcolor = Color3.fromRGB(0, 255, 0)
		local keycolor = Color3.fromRGB(0,255,255)
		local levercolor = Color3.fromRGB(255,170,0)
		local goldcolor = Color3.fromRGB(255,255,0)
		local fusecolor = Color3.fromRGB(0,255,255)
		local rainbow = false
		local Color = Color3.fromRGB(255,255,255)
		local ft = 0.6
		local BypassSeek = false
		local ot = 0
		if not game.Players.LocalPlayer.PlayerGui:WaitForChild("MainUI",99999).Initiator:FindFirstChild("Main_Game") then

			Notify({
				Title = "Error",
				Description = "There was an error while loading the script",
			})	
			Sound()
			getgenv().JSHUB = false
		else
			local Modules = game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game.RemoteListener.Modules
			local EntityModules = game.ReplicatedStorage.ClientModules.EntityModules
			local Screech = Modules:FindFirstChild("Screech") or Modules:FindFirstChild("Screech_")
			local Halt = EntityModules.Shade
			local Dread = Instance.new("Folder")
			if Modules:FindFirstChild("Dread") then
				Dread = Modules.Dread
			end
			local Timothy = Modules.SpiderJumpscare
			local Glitch = EntityModules.Glitch
			local Void = game:GetService("ReplicatedStorage").ClientModules.EntityModules.Void
			local A90
			if Modules:FindFirstChild("A90") then
				A90 = Modules.A90
			end
			local tt = 0
			local oc = "White"
			local CurrentRoom = 0
			local MotorReplication = RemotesFolder.MotorReplication
			local highlight = false
			local BillboardsFolder = Instance.new("Folder")
			local Floor = game.ReplicatedStorage.GameData.Floor.Value
			BillboardsFolder.Parent = game.CoreGui
			BillboardsFolder.Name = "yay"
			for i,room in pairs(game.Workspace.CurrentRooms:GetChildren()) do
				CurrentRoom = (tonumber(room.Name) - 1)
			end
			game.Workspace.CurrentRooms.ChildAdded:Connect(function(child)
				CurrentRoom = (tonumber(child.Name) - 1)


			end)
			local function togglenoclip(value)

				noclip = value



			end
			if Floor == "Backdoor" then
				DoorsDifference = -51
			elseif Floor == "Mines" then
				DoorsDifference = 100
			end
			local tracers = false
			local SpeedBoost = 0

			local OldHotel = false
			if RemotesFolder.Name == "Bricks" then
				OldHotel = true
			end





			local ito = false

			Ambience = Color3.fromRGB(255,255,255)
			local AA = false
			NotifyEyes = false
			AntiScreech = false
			godmodefools = false
			Figure = nil
			AutoLibraryUnlockDistance = 35
			local RemoveFigure = false
			local RemoveHideVignette = false
			local GeneratorESP = false
			JumpBoost = 0
			local DoorReach = false
			local AntiSeekObstructions = false
			local NotifyA120 = false
			local WatermarkGui = Instance.new("ScreenGui")
			WatermarkGui.Parent = game.CoreGui
			WatermarkGui.ResetOnSpawn = false
			local Watermark = Instance.new("TextLabel")
			Watermark.Parent = WatermarkGui
			Watermark.Size = UDim2.new(1,0,0.4,0)
			Watermark.Position = UDim2.new(0,0,0.6,0)

			Watermark.Font = Enum.Font.Oswald
			Watermark.TextColor3 = Color3.fromRGB(255,255,255)
			Watermark.Visible = false
			Watermark.BackgroundTransparency = 1
			Watermark.Text = ""
			Watermark.TextScaled = true
			Watermark.TextTransparency = 0.9
			local Watermark2 = Instance.new("TextLabel")
			Watermark2.Parent = WatermarkGui
			Watermark2.Size = UDim2.new(1,0,0.035,0)
			Watermark2.Position = UDim2.new(0,0,-0.05,0)
			Watermark2.TextStrokeTransparency = 0
			Watermark2.Font = Enum.Font.Oswald
			Watermark2.TextColor3 = Color3.fromRGB(255,255,255)
			Watermark2.BackgroundTransparency = 1
			Watermark2.Text = ""
			Watermark2.TextScaled = true
			Watermark2.TextTransparency = 0
			Watermark.TextStrokeTransparency = 0
			OriginalAmbience = game.Lighting.Ambient
			local flytoggle = false
			EnableFOV = false
			AntiEyes = false
			FigureESP = false
			TransparentCloset = false
			TransparentClosetNumber = 0.75
			FuseESP = false
			anchorcolor = Color3.fromRGB(255,170,0)
			AnchorESP = false
			laddercolor = Color3.fromRGB(0,0,255)
			chestcolor = Color3.fromRGB(255,255,0)
			grumblecolor = Color3.fromRGB(255, 0, 0)
			louiecolor = Color3.fromRGB(0,255,255)
			jeffcolor = Color3.fromRGB(255,0,0)
			figurecolor = Color3.fromRGB(255,0,0)
			fusecolor = Color3.fromRGB(0,255,255)
			generatorcolor = Color3.fromRGB(255,170,0)
			timelevercolor = Color3.fromRGB(255,170,0)
			dupecolor = Color3.fromRGB(255,0,0)
			Ladders = false
			ReachDistance = 5
			autoplay = false
			ToolSpamSelf = false
			ToolSpamAll = false
			local AntiFH = false
			local AntiSnare = false
			local AntiDupe = false
			local NotifyTimeLevers = false

			local SnareESP = false
			local GrumbleESP = false
			local keycarddupe = false
			local godmodelocker = nil
			local MinesBypass = false
			local EntityESP = false
			local AntiLookman = false
			local AntiVacuum = false
			local fb = false
			local autoplaypart
			local ToolSpam = false
			local ItemESP = false
			local godmode = false
			local TimerLevers = false
			local AutoLibrary = false

			local AutoBreaker = false
			local keycardduped = false
			local flyspeed = 2
			local godmodenotif = false
			local keycardtable = {"NormalKeyCard", "RidgeKeyCard"}
			local spectate = false
			local antilag = false
			local speakers = false
			local rev = false
			local maxinteract = false
			VacuumESP = false
			local flyvelocity
			local NA = false
			local gold = false

			fov = 70
			local fovmultiplier = 1
			local interact = false
			local playingagain = false
			local PathfindingFolder = Instance.new("Folder")
			PathfindingFolder.Name = "PathfindingNodes"
			PathfindingFolder.Parent = game.Workspace
			local PathfindFunctions = {}
			type tPathfind = {
				esp: boolean,
				room_number: number, -- the room number
				real: table,
				fake: table,
				destroyed: boolean -- if the pathfind was destroyed for the Teleport
			}

			type tGroupTrack = {
				nodes: table,
				hasStart: boolean,
				hasEnd: boolean,
			}

			--@Internal nodes sorted by @GetNodes or @Pathfind
			type tSortedNodes = {
				real: table,
				fake: table,
				room: number,
			}

			local function tGroupTrackNew(startNode: Part | nil): tGroupTrack
				local create: tGroupTrack = {
					nodes = startNode and {startNode} or {},
					hasStart = false,
					hasEnd   = false,
				}
				return create
			end

			--@Internal funtion
			local function changeNodeColor(node: Model, color: Color3): Model
				if color == nil then
					node.Color = Options.SeekNodeColor.Value
					node.Transparency = 1
					node.Size = Vector3.new(1.0, 1.0, 1.0)
					return
				end
				node.Color = color
				node.Material = Enum.Material.Neon
				node.Transparency = 0
				node.Shape = Enum.PartType.Ball
				node.Size = Vector3.new(0.7, 0.7, 0.7)
				return node
			end

			--@Internal function
			--@Return #boolean. True if the pathfind algorithm was ran.
			local function HasAlreadyPathfind(nodesFolder: Folder): boolean
				local hasPathfind = nodesFolder:GetAttribute("_mspaint_nodes_pathfind")
				return hasPathfind
			end

			--@Internal function
			local function HasNodesToPathfind(room: Model)
				local roomNumber = tonumber(room.Name)
				--Make room number restrictions to avoid useless mapping.
				local seekChase = (string.find(room:GetAttribute("RawName"), "Seek"))

				local result = (seekChase)

				return result
			end

			--@Internal funtion
			local function sortNodes(nodes: table, reversed: boolean) -- Sort nodes by their number
				table.sort(nodes, function(a, b)
					local Anumber, _ = (a.Name):gsub("[^%d+]", "")
					local Bnumber, _ = (b.Name):gsub("[^%d+]", "")
					if reversed then
						return tonumber(Anumber) > tonumber(Bnumber) --example: 100 to 0
					end
					return tonumber(Anumber) < tonumber(Bnumber) --example: 0 to 100
				end)
				return nodes
			end

			--@Internal function
			--@Return #table with a sorted array of real and fake nodes and the room number. 
			--@Return #nil if there's no Nodes to be processed
			local function PathfindGetNodes(room: Model): tSortedNodes | nil

				if not HasNodesToPathfind(room) then return end

				local Nodes = {
					real = {},
					fake = {}
				}
				local nodeArray = room:WaitForChild("RunnerNodes", 5.0)
				if (nodeArray == nil) then 

					return
				end

				if not HasAlreadyPathfind(nodeArray) then 

					PathfindFunctions:Pathfind(room, true)
					return 
				end



				for _, node: Part in ipairs(nodeArray:GetChildren()) do
					--check for real nodes

					local realNumber = node:GetAttribute("_mspaint_real_node")
					if realNumber then table.insert(Nodes.real, node) continue end
					--check for fake nodes
					local fakeNumber = node:GetAttribute("_mspaint_fake_node")
					if fakeNumber then table.insert(Nodes.fake, node) end
				end

				--If there's no nodes, return the empty table
				if #Nodes.real <= 0 and #Nodes.fake <= 0 then 

					return
				end

				local sortedReal = sortNodes(Nodes.real)
				local sortedFake = sortNodes(Nodes.fake)

				local nodesList = {
					real = sortedReal,
					fake = sortedFake,
					roomNumber = tonumber(room.Name)
				}

				return nodesList
			end

			--@Internal function
			--@Return nil. __Set the node attribute.__ Can only be called after the __@Pathfind function is completed.__
			local function PathfindSetNodes(nodes: table, nameAttribute: string)

				for i, node: Part in ipairs(nodes) do
					node:SetAttribute(nameAttribute, i)
				end
			end

			local WhitelistConfig = {
				[45] = {firstKeep = 3, lastKeep = 2},
				[46] = {firstKeep = 2, lastKeep = 2},
				[47] = {firstKeep = 2, lastKeep = 2},
				[48] = {firstKeep = 2, lastKeep = 2},
				[49] = {firstKeep = 2, lastKeep = 4},
			}

			--@Internal function
			local function NodeDestroy(nodesList: tSortedNodes)
				if not nodesList then return end

				print("[NodeDestroy] Attempting to destroy nodes in room: " .. tostring(nodesList.roomNumber))

				local roomConfig = WhitelistConfig[nodesList.roomNumber]

				local _firstKeep = roomConfig.firstKeep
				local _lastKeep  = roomConfig.lastKeep

				local _removeTotal = #nodesList.real - (_firstKeep + _lastKeep) --remove nodes that arent in the first or last
				for idx=1, _removeTotal do
					local node = nodesList.real[_firstKeep + 1]
					--changeNodeColor(node, MinecartPathNodeColor.Orange) --debug only
					node:Destroy()
					table.remove(nodesList.real, _firstKeep + 1)
				end

				--Destroy all the fake nodes
				for _, node in ipairs(nodesList.fake) do
					node:Destroy()
					table.remove(nodesList.fake, 1)
				end


			end

			--@Internal function
			--@Return #boolean. True if the pathfind algorithm was ran.
			local function HasAlreadyDestroyed(room: Model): boolean

				local nodesFolder = room:WaitForChild("RunnerNodes", 5.0)
				if (nodesFolder == nil) then 

					return
				end
				local result = nodesFolder:GetAttribute("_mspaint_player_teleported") ~= nil

				return result
			end

			--The Minecart Teleport Function, this will be called with @NodeDestroy.
--[[
    Use "_mspaint_player_teleported" to track the status of the Teleport meaning that:
    _mspaint_player_teleported = nil   ==> Node not destroyed
    _mspaint_player_teleported = false ==> Node destroyed
    _mspaint_player_teleported = true ==> Nodes was destroyed + Player sucessfully teleported.
]]


			--External function to be called.
			function PathfindFunctions:DrawNodes(room: Model)
				local nodesList = PathfindGetNodes(room)
				if not nodesList or HasNodesToPathfind(room) == false then return end

				local espRealColor = if Toggles.MinecartPathVisualiser.Value then Color3.fromRGB(0,255,0) else Color3.fromRGB(255,0,0)

				--[ESP] Draw the real path
				for _, realNode in ipairs(nodesList.real) do
					changeNodeColor(realNode, espRealColor)
				end

				--[ESP] Draw the fake path
				-- for idx, fakeNode in ipairs(nodesList.fake) do
				--     changeNodeColor(fakeNode, MinecartPathNodeColor.Red)
				-- end
			end

			--@Return nil. Map the nodes in the __RunnerNodes__ and call features functions (@DrawNode; @Teleport).
			function PathfindFunctions:Pathfind(room: Model, forcePathfind: boolean)
				if not HasNodesToPathfind(room) then return end

				if not forcePathfind then
					--wait until SendRunnerNodes is trigged
					local pathTimeout = tick() + 5
					repeat task.wait()
					until #PathfindFunctions.pathfindQueue > 0 or tick() > pathTimeout
					pcall(table.remove, PathfindFunctions.pathfindQueue, 1)
				end

				local nodesFolder = room:FindFirstChild("RunnerNodes")
				if (nodesFolder == nil) then return end

				local nodes = nodesFolder:GetChildren()

				local numOfNodes = #nodes
				if numOfNodes <= 0 then return end 

				if HasAlreadyPathfind(nodesFolder) then return end


    --[[
        Pathfind is a computational expensive process to make, 
        however we don't have node loops, 
        so we can ignore a few verifications.
        If you want to understand how this is working, search for "Pathfiding Algorithms"

        The shortest explanation i can give is that, this is a custom pathfinding to find "gaps" between
        nodes and creating "path" groups. With the groups estabilished we can make the correct validations.

        -Bacalhauz
    ]]
				--Distance weights [DO NOT EDIT, unless something breaks...]
				local _shortW = 4
				local _longW = 24

				local doorModel = room:WaitForChild("Door", 5) -- Will be used to find the correct last node.

				local _startNode = nodes[1]
				local _lastNode = nil --we need to find this node.

				local _gpID = 1
				local stackNode = {} --Group all track groups here.
				stackNode[_gpID] = tGroupTrackNew()

				--Ensure sort all nodes properly (reversed)
				nodes = sortNodes(nodes, true)

				local _last = 1
				for i=_last+1, numOfNodes, 1 do
					local nodeA: Part = nodes[_last]
					local nodeB: Part = _lastNode and nodes[i] or doorModel

					local distance = (nodeA:GetPivot().Position - nodeB:GetPivot().Position).Magnitude

					local isEndNode = distance <= _shortW
					local isNodeNear = (distance > _shortW and distance <= _longW)

					local _currNodeTask = "Track"
					if isNodeNear or isEndNode then
						if not _lastNode then -- this will only be true, once.
							_currNodeTask = "End"
							_lastNode = nodeA
						end
					else
						_currNodeTask = "Fake"
					end

					--check if group is diff, ignore "End" or "Start" tasks
					if  (_currNodeTask == "Fake" or _currNodeTask == "End") and _lastNode then
						_gpID += 1
						stackNode[_gpID] = tGroupTrackNew()
						if _currNodeTask == "End" then
							stackNode[_gpID].hasEnd = true
						end
					end
					table.insert(stackNode[_gpID].nodes, nodeA)

					--Use this to debug the nodeTask


					_last = i
					--_lastNodeTask = _currNodeTask
				end
				stackNode[_gpID].hasStart = true --after the reversed path finding, the last group has the start node.
				table.insert(stackNode[_gpID].nodes, _startNode)
				--if we only have one group, means that there's no fake path.
				local hasMoreThanOneGroup = _gpID > 1

				local _closestNodes = {} --unwanted nodes if any
				local hasIncorrectPath = false -- if this is true, we're cooked. No path for you ):
				if hasMoreThanOneGroup then

					for _gpI, v: tGroupTrack in ipairs(stackNode) do
						_closestNodes[_gpI] = {}


						if _gpI <= 1 then continue end


						--Sort table for the normal flow, A -> B (was B -> A before)
						v.nodes = sortNodes(v.nodes, false)

						--Finally, perform the clean up by removing wrong nodes when a "distance jump" is found
						local _gplast = 1
						local hasNodeJump = false
						for _gpS=_gplast+1, #v.nodes, 1 do
							local nodeA: Part = v.nodes[_gplast]
							local nodeB: Part = v.nodes[_gpS]

							local distance = (nodeA:GetPivot().Position - nodeB:GetPivot().Position).Magnitude

							hasNodeJump = (distance >= _longW)
							if not hasNodeJump then _gplast = _gpS continue end


							--Ok, we found a node jump, now we need to know what should be the closest node
							--table.remove(v.nodes, _gpS)

							local nodeSearchPath = nodeB

							--Search again with the nodeSearchPath
							local closestDistance = math.huge

							local _gpFlast = #v.nodes
							for i=_gpFlast-1, 1, -1 do

								local fnode = v.nodes[_gpFlast]
								local Sdistance = (nodeSearchPath:GetPivot().Position - fnode:GetPivot().Position).Magnitude
								_gpFlast = i

								if Sdistance == 0.00 then continue end --node is self


								if Sdistance <= closestDistance then
									closestDistance = Sdistance
									table.insert(_closestNodes[_gpI], fnode)
									table.remove(v.nodes, _gpFlast+1)
									continue
								end
								break
							end
							--table.insert(v.nodes, _gpS, nodeSearchPath)

							local _FoundAmount = #_closestNodes[_gpI]
							if _FoundAmount > 1 then 

							else
								warn(string.format("[TrackGroup] Group %s ERROR: Unable to find closest node, path is likely broken.", _gpI))
								hasIncorrectPath = true
							end
							break
						end
						if not hasNodeJump then

						end
					end

					for _gpI, v: tGroupTrack in ipairs(stackNode) do

					end
				end

				if hasIncorrectPath then return end

				--finally, draw the correct path. gg
				local realNodes = {} --our precious nodes finally here :pray:
				local fakeNodes = {} --we hate you but ok
				for _gpFI, v: tGroupTrack in ipairs(stackNode) do
					local finalWrongNode = false
					if _gpFI == 1 and hasMoreThanOneGroup then
						finalWrongNode = true 
					end

					for _, vfinal in ipairs(v.nodes) do
						if finalWrongNode then
							table.insert(fakeNodes, vfinal)
							continue
						end
						table.insert(realNodes, vfinal)
					end

					--Draw wrong path calculated on DeepPath.
					for _, nfinal in ipairs(_closestNodes[_gpFI]) do
						table.insert(fakeNodes, nfinal)
					end
				end
				--our result is stored in the part itself in order.

				local nodesList: tSortedNodes = {
					real = sortNodes(realNodes, false),
					fake = sortNodes(fakeNodes, false)
				}

				nodesFolder:SetAttribute("_mspaint_nodes_pathfind", true)
				PathfindSetNodes(nodesList.real, "_mspaint_real_node")
				PathfindSetNodes(nodesList.fake, "_mspaint_fake_node")
				--Call any feature that requires the pathfind nodes--
			end


			local vps = game.Workspace.CurrentCamera.ViewportSize

			local function PlayAgain()
				if playingagain == false then
					playingagain = true
					Notify({Title = "Teleporting",Description = "Teleporting in 3 seconds..."})
					Sound()
					RemotesFolder.PlayAgain:FireServer()

				else
					Notify({Title = "Teleporting", Description = "Teleporting in 3 seconds..."})
					Sound()
				end

			end
			local Connection1 = game["Run Service"].RenderStepped:Connect(function()

				if fb == true and OldHotel == true or fb == true and Floor == "Fools" then

					game.Lighting.Ambient = Color3.fromRGB(255,255,255)
				elseif fb == false and OldHotel == true or fb == false and Floor == "Fools" then
					game.Lighting.Ambient = Color3.fromRGB(0,0,0)

				end

				if game.Workspace.Camera:FindFirstChild("Screech") and AntiScreech == true then
					game.Workspace.Camera.Screech:Destroy()
				end

				if Floor == "Fools" or OldHotel == true then
					if AntiEyes == true and game.Workspace:FindFirstChild("Eyes") or AntiEyes == true and game.Workspace:FindFirstChild("Lookman") then
						MotorReplication:FireServer(0, -90, 0, false)


					end


				end
			end)

			local textgui = Instance.new("ScreenGui")
			textgui.Parent = game.CoreGui
			textgui.Name = "Text"
			local tracergui = Instance.new("ScreenGui")
			tracergui.Parent = game.CoreGui
			tracergui.Name = "Tracers"

			ESPLibrary:SetTextSize(20)
			
			ESPLibrary:SetFadeTime(0.5)
			ESPLibrary:SetFillTransparency(0.65)
			ESPLibrary.UseBillboards = false


			function RemoveESP(inst)
				inst:SetAttribute("CurrentESP",false)



			end


			if game.Workspace.CurrentRooms:FindFirstChild("0") and not game.Workspace.CurrentRooms:FindFirstChild("2") then
				Player:SetAttribute("CurrentRoom","0")
			end
			local function esp(Target,TracerTarget,Text, ColorText, shoulddestroy, instanthighlight)
				local connections = {}
				local destroying = false
				local waittable = {"Door","KeyObtain"}
				local transparencyenabled = false





				if Target:GetAttribute("ESP") ~= true and Target:GetAttribute("CurrentESP") ~= true then
					
					












					

					
					if TracerTarget ~= nil then
						TracerTarget:GetPropertyChangedSignal("Parent"):Connect(function()
							Target:SetAttribute("CurrentESP",false)


						end)
						TracerTarget:GetPropertyChangedSignal("Parent"):Connect(function()
							Target:SetAttribute("CurrentESP",false)

						end)
					end
					Target:GetPropertyChangedSignal("Parent"):Connect(function()
						Target:SetAttribute("CurrentESP",false)

					end)

				

Player:GetAttributeChangedSignal("CurrentRoom"):Connect(function()
						
						if Target ~= nil and Target.Parent ~= nil then
							if Target:GetAttribute("CurrentESP") ~= true  then
								ESPLibrary:AddESP({
									Object = Target,
									Text = Text,
									Color = ColorText
								})
							end
						
						
							
								if shoulddestroy == true and tonumber(Target:GetAttribute("ParentRoom")) == tonumber(Player:GetAttribute("CurrentRoom")) and Target:GetAttribute("ESP") == true or shoulddestroy == true and tonumber(Target:GetAttribute("ParentRoom")) == tonumber(Player:GetAttribute("CurrentRoom"))+1 and Target:GetAttribute("ESP") == true then
								if ESPLibrary.Objects[Target] == nil then
										ESPLibrary:AddESP({
											Object = Target,
											Text = Text,
											Color = ColorText
										})
									end
									
							elseif shoulddestroy == true and tonumber(Target:GetAttribute("ParentRoom")) > tonumber(Player:GetAttribute("CurrentRoom"))+1 or shoulddestroy == true and tonumber(Target:GetAttribute("ParentRoom")) < tonumber(Player:GetAttribute("CurrentRoom")) or Target:GetAttribute("ESP") ~= true then


									
							
								if ESPLibrary.Objects[Target] ~= nil then
									ESPLibrary:RemoveESP(Target)
								end
									end
									


								

							end

						
						if Target == nil or Target.Parent == nil or Target:IsA("Model") and Target.PrimaryPart == nil then
							Target:SetAttribute("CurrentESP",false)
						end
				
						

end)
					Target:GetAttributeChangedSignal("ESP"):Connect(function()

						if Target ~= nil and Target.Parent ~= nil then
							if Target:GetAttribute("CurrentESP") ~= true  then
								ESPLibrary:AddESP({
									Object = Target,
									Text = Text,
									Color = ColorText
								})
							end



							if shoulddestroy == true and tonumber(Target:GetAttribute("ParentRoom")) == tonumber(Player:GetAttribute("CurrentRoom")) and Target:GetAttribute("ESP") == true or shoulddestroy == true and tonumber(Target:GetAttribute("ParentRoom")) == tonumber(Player:GetAttribute("CurrentRoom"))+1 and Target:GetAttribute("ESP") == true then
								if ESPLibrary.Objects[Target] == nil then
									ESPLibrary:AddESP({
										Object = Target,
										Text = Text,
										Color = ColorText
									})
								end

							elseif shoulddestroy == true and tonumber(Target:GetAttribute("ParentRoom")) < tonumber(Player:GetAttribute("CurrentRoom")) or Target:GetAttribute("ESP") ~= true then




								if ESPLibrary.Objects[Target] ~= nil then
									ESPLibrary:RemoveESP(Target)
								end
							end





						end


						if Target == nil or Target.Parent == nil or Target:IsA("Model") and Target.PrimaryPart == nil then
							Target:SetAttribute("CurrentESP",false)
						end



					end)
				end


				Target:GetAttributeChangedSignal("CurrentESP"):Connect(function()
					if Target:GetAttribute("CurrentESP") == false then
						Target:SetAttribute("ESP",false)
					
						ESPLibrary:RemoveESP(Target)
					end

				end)
				task.wait(0.05)
				Target:SetAttribute("ESP", true)
				Target:SetAttribute("ESP",true)
				Target:SetAttribute("CurrentESP", true)
			



			end


			function DisableDupe(Model)
				if Model.Name == "FakeDoor" and AntiDupe == true or Model.Name == "DoorFake" and AntiDupe == true or Model.Name == "SideroomSpace" and AntiVacuum == true then

					for i,part in pairs(Model:GetDescendants()) do

						if part:IsA("ProximityPrompt") or part.Name == "TouchInterest" then
							part:Destroy()

						elseif part:IsA("Part") then
							local r = game["Run Service"].RenderStepped:Connect(function()
								part.CanTouch = false

							end)
							game.Workspace.CurrentRooms.ChildAdded:Wait()
							r:Disconnect()







						end


					end
				end
			end
			function ApplyDupeESP(Model: Model)
				if Model:IsDescendantOf(workspace) then
					if Model.Name == "DoorFake" or Model.Name == "FakeDoor" then
						if Model:FindFirstChild("Door") then
							esp(Model.Door,Model.Door,"Dupe",dupecolor,true,false)
							print("applied dupe esp")
						
end
					
				elseif Model.Name == "SideroomSpace" then
					local model = Instance.new("Model")
					model.Parent = Model
					local humanoid = Instance.new("Humanoid")
					humanoid.Parent = model
					local part = Instance.new("Part")
					part.Parent = model
					part.Name = "Door"
					part.Transparency = 0.99
					part.CanCollide = false
					part.CFrame = Model.Collision.CFrame*CFrame.new(0,0,3)
					part.Anchored = true
					part.Size = Vector3.new(Model.Collision.Size.X,20,10)

					part.Color = Color3.fromRGB(255,0,0)
					part.Material = Enum.Material.ForceField
					esp(part,part,"Vacuum",dupecolor,false,false)
					game.Workspace.CurrentRooms:FindFirstChild(model:GetAttribute("ParentRoom")).Destroying:Wait()
					part:SetAttribute("ESP",false)
				
				end
				end
				end
			local NotifierConnection
			if OldHotel == true then
				NotifierConnection = game.Workspace.ChildAdded:Connect(function(child)

					if child:IsA("Model") then
						local mainpart = child.PrimaryPart
						if mainpart == nil then

							if child.Name ~= "RushMoving" and child.Name ~= "AmbushMoving" then
								mainpart = child:WaitForChild("Core")
							else
								mainpart = child:WaitForChild("RushNew")
							end
						end
						if child.Name == "Lookman" then
							child.Name = "Eyes"
						end

						if child:IsA("Model") then



							if child:IsA("Model") then
								if child:IsDescendantOf(workspace) then
									if table.find(Entities,child.Name) and Floor ~= "Fools" and OldHotel == false or table.find(Entities,child.Name) and Player:DistanceFromCharacter(mainpart.Position) < 10000 and Floor == "Fools" or table.find(Entities,child.Name) and Player:DistanceFromCharacter(mainpart.Position) < 10000 and OldHotel == true then
										EntityCounter += 1
										if child.Name == "Eyes" or child.Name == "BackdoorLookman" then
											if Options.NotifyMonsters.Value[EntityShortNames[child.Name]] then
												Notify({Title = "ENTITIES", Description = EntityAlliases[child.Name] .. " has spawned.",Reason = "Don't look at it!",Image = EntityIcons[child.Name],NotificationType = "WARNING",Time = child})
												Sound()	
												if ChatNotifyMonsters == true then
													ChatNotify(EntityChatNotifyMessages[child.Name])
												end
											end

										else

											if Options.NotifyMonsters.Value[EntityShortNames[child.Name]] then
												if godmode == true and OldHotel == true and child.Name == "RushMoving" then
													Notify({Title =  "ENTITIES", Description =  EntityAlliases[child.Name] .." has spawned. Don't be too close.",Reason = "He can kill you while going down.",Image = EntityIcons[child.Name],NotificationType = "WARNING",Time = child})
												elseif godmode == true and child.Name == "A120" then
													Notify({Title =  "ENTITIES", Description = EntityAlliases[child.Name] .." has spawned. Hide!",Reason = "Godmode doesn't work for A-120.",Image = EntityIcons[child.Name],NotificationType = "WARNING",Time = child})	
												elseif godmode == true then
													Notify({Title =  "ENTITIES", Description = EntityAlliases[child.Name] .." has spawned. Don't worry.",Reason = "You have godmode enabled!",Image = EntityIcons[child.Name],NotificationType = "WARNING",Time = child})
												elseif godmode == false then
													Notify({Title =  "ENTITIES", Description = EntityAlliases[child.Name] .." has spawned.",Reason = "Find a hiding spot!",Image = EntityIcons[child.Name],NotificationType = "WARNING",Time = child})
												end
												Sound()
												if ChatNotifyMonsters == true then
													ChatNotify(EntityChatNotifyMessages[child.Name])
												end
											end
										end




										if EntityESP == true then

											local model = Instance.new("Model")
											model.Parent = child
											local hum = Instance.new("Humanoid")
											hum.Parent = model
											local part = Instance.new("Part")
											part.CFrame = mainpart.CFrame
											part.Parent = model
											part.CanCollide = false
											part.Transparency = 0.99
											part.Massless = true
											part.Color = Color3.fromRGB(255,0,0)
											part.Size = Vector3.new(14,14,14)
											if child.Name == "Eyes" or child.Name == "BackdoorLookman" then
												part.Size = Vector3.new(9,9,9)
											end


											part.Orientation = Vector3.new(0,0,0)
											local mesh = Instance.new("SpecialMesh")
											mesh.Parent = part
											local pos = part.Position

											local oldpos = pos
											local positonconnection = game["Run Service"].RenderStepped:Connect(function()
												if child.Name ~= "A120" and RemotesFolder.Name == "RemotesFolder" then
													pos = part.Position
													local distance = (pos.Y - oldpos.Y)


													--if  then
													if pos == game.Workspace.CurrentRooms[CurrentRoom]:WaitForChild("RoomExit").Position or pos.X == oldpos.X and pos.Z == oldpos.Z and pos.Y ~= oldpos.Y  or pos.X == game.Workspace.CurrentRooms[CurrentRoom].RoomExit.Position.X and pos.Y == game.Workspace.CurrentRooms[CurrentRoom].RoomExit.Position.Y then
														task.wait(0.05)
														part:SetAttribute("ESP",false)
													end
													oldpos = pos

												end
											end)	




											local weld = Instance.new("WeldConstraint")
											weld.Parent = child
											weld.Part0 = part
											weld.Part1 = mainpart
											weld.Enabled = true
											if child.Name == "Eyes" or child.Name == "Lookman" then
												ESPLibrary:AddESP({
													Object = part,
													Text = EntityAlliases[child.Name],
													Color = entitycolor
												}
												)
												game.Workspace.CurrentRooms.ChildAdded:Wait()
												part:SetAttribute("ESP",false)
											else
												ESPLibrary:AddESP({
													Object = part,
													Text = EntityAlliases[child.Name],
													Color = entitycolor
												}
												)
											end
											child.Destroying:Wait()
											part:Destroy()		
											positonconnection:Disconnect()
										end
									end
								end
							end
						end
					end
				end)
			else
				NotifierConnection = game.Workspace.ChildAdded:Connect(function(child)
					task.wait(0.1)
					local mainpart
					if child:IsA("Model") then
						mainpart = child.PrimaryPart
						if mainpart == nil then
							if child.Name == "Eyes" or child.Name == "BackdoorLookman" or child.Name == "Lookman" then
								mainpart = child:WaitForChild("Core")
							else
								mainpart = child:WaitForChild("RushNew")
							end
						end
					end
					if child.Name == "Lookman" then
						child.Name = "Eyes"
					end
					if child:IsA("Model") then



						if child:IsA("Model") then
							if child:IsDescendantOf(workspace) then
								if table.find(Entities,child.Name) and Floor ~= "Fools" and OldHotel == false or table.find(Entities,child.Name) and Player:DistanceFromCharacter(mainpart.Position) < 10000 and Floor == "Fools" or table.find(Entities,child.Name) and Player:DistanceFromCharacter(mainpart.Position) < 10000 and OldHotel == true then
									EntityCounter += 1
									if child.Name == "Eyes" or child.Name == "BackdoorLookman" then
										if Options.NotifyMonsters.Value[EntityShortNames[child.Name]] then
											Notify({Title = "ENTITIES", Description = EntityAlliases[child.Name] .. " has spawned.",Reason = "Don't look at it!",Image = EntityIcons[child.Name],NotificationType = "WARNING",Time = child})
											Sound()	
											if ChatNotifyMonsters == true then
												ChatNotify(EntityChatNotifyMessages[child.Name])
											end
										end

									else

										if Options.NotifyMonsters.Value[EntityShortNames[child.Name]] then
											if godmode == true and OldHotel == true and child.Name == "RushMoving" then
												Notify({Title =  "ENTITIES", Description =  EntityAlliases[child.Name] .." has spawned. Don't be too close.",Reason = "He can kill you while going down.",Image = EntityIcons[child.Name],NotificationType = "WARNING",Time = child})
											elseif godmode == true and child.Name == "A120" then
												Notify({Title =  "ENTITIES", Description = EntityAlliases[child.Name] .." has spawned. Hide!",Reason = "Godmode doesn't work for A-120.",Image = EntityIcons[child.Name],NotificationType = "WARNING",Time = child})	
											elseif godmode == true and Floor == "Fools" and child.Name == "AmbushMoving" then
												Notify({Title =  "ENTITIES", Description = EntityAlliases[child.Name] .." has spawned.",Reason = "Because of a godmode failsafe, you will not be able to continue until Ambush leaves.",Image = EntityIcons[child.Name],NotificationType = "WARNING",Time = child})
											elseif godmode == true then
												Notify({Title =  "ENTITIES", Description = EntityAlliases[child.Name] .." has spawned. Don't worry.",Reason = "You have godmode enabled!",Image = EntityIcons[child.Name],NotificationType = "WARNING",Time = child})
											elseif godmode == false then
												Notify({Title =  "ENTITIES", Description = EntityAlliases[child.Name] .." has spawned.",Reason = "Find a hiding spot!",Image = EntityIcons[child.Name],NotificationType = "WARNING",Time = child})
											end
											Sound()
											if ChatNotifyMonsters == true then
												ChatNotify(EntityChatNotifyMessages[child.Name])
											end
										end
									end




									if EntityESP == true then
										local model = Instance.new("Model")
										model.Parent = child
										local hum = Instance.new("Humanoid")
										hum.Parent = model
										local part = Instance.new("Part")
										part.CFrame = mainpart.CFrame
										part.Parent = model
										part.CanCollide = false
										part.Transparency = 0.99
										part.Massless = true
										part.Color = Color3.fromRGB(255,0,0)
										part.Size = Vector3.new(14,14,14)
										if child.Name == "Eyes" or child.Name == "BackdoorLookman" then
											part.Size = Vector3.new(9,9,9)
										end
										part.Orientation = Vector3.new(0,0,0)
										local mesh = Instance.new("SpecialMesh")
										mesh.Parent = part


										local pos = part.Position

										local oldpos = pos
										local positonconnection = game["Run Service"].RenderStepped:Connect(function()
											if child.Name ~= "A120" and RemotesFolder.Name == "RemotesFolder" then
												pos = part.Position
												local distance = (pos.Y - oldpos.Y)


												--if  then
												if pos == game.Workspace.CurrentRooms[CurrentRoom]:WaitForChild("RoomExit").Position or pos.X == oldpos.X and pos.Z == oldpos.Z and pos.Y ~= oldpos.Y  or pos.X == game.Workspace.CurrentRooms[CurrentRoom].RoomExit.Position.X and pos.Y == game.Workspace.CurrentRooms[CurrentRoom].RoomExit.Position.Y then
													task.wait(0.05)
													part:SetAttribute("ESP",false)
												end
												oldpos = pos

											end
										end)		




										local weld = Instance.new("WeldConstraint")
										weld.Parent = child
										weld.Part0 = part
										weld.Part1 = mainpart
										weld.Enabled = true
										if child.Name == "Eyes" or child.Name == "Lookman" then
											ESPLibrary:AddESP({
												Object = part,
												Text = EntityAlliases[child.Name],
												Color = entitycolor
											}
											)
											game.Workspace.CurrentRooms.ChildAdded:Wait()
											part:SetAttribute("ESP",false)
										else
											ESPLibrary:AddESP({
												Object = part,
												Text = EntityAlliases[child.Name],
												Color = entitycolor
											}
											)

										end
										child.Destroying:Wait()
										part:Destroy()	
										positonconnection:Disconnect()	



									end
								end
							end
						end
					end
				end)	
			end
			function touch(x)
				x = x:FindFirstAncestorWhichIsA("Part")
				if x then

					task.spawn(function()
						firetouchinterest(x, HumanoidRootPart, 1)
						task.wait()
						firetouchinterest(x, HumanoidRootPart, 0)
					end)

					x.CFrame = HumanoidRootPart.CFrame
				end
			end

			function DeleteSeek()
				if Floor ~= "Fools" and OldHotel == false then
					local collision
					if DeletingSeek == false then
						DeletingSeek = true
						local tries = 0

						Notify({
							Title = "No Seek",
							Description = "Disabling Seek...",
						})
						Sound()


						for i,e in pairs(game.Workspace:GetDescendants()) do
							local parent = e.Parent.Parent
							if e.Name == "TriggerSeek" then
								e:Destroy()
							end
							if e:IsA("TouchTransmitter") and parent.Name == "TriggerEventCollision" then

								game.Players.LocalPlayer.Character:WaitForChild("Collision").Anchored = true
								while task.wait() and e do


									if e:IsDescendantOf(workspace) then
										touch(e)

									end
									tries += 1
									if tries > 25 then
										game.Players.LocalPlayer.Character:WaitForChild("Collision").Anchored = false
										Notify({
											Title = "No Seek",
											Description = "Failed to disable Seek!",
										})
										Sound()

										break
									elseif e.Parent ~= parent then

										if DeletingSeek == true then
											DeletingSeek = false
											Notify({
												Title = "No Seek",
												Description = "Seek is now disabled!",
											})
											Sound()
										end
										game.Players.LocalPlayer.Character:WaitForChild("Collision").Anchored = false



									end
								end


							end

						end





					end
				end
			end
			local function GetRoom(inst: Instance)
				for i,room in pairs(game.Workspace:FindFirstChild("CurrentRooms"):GetChildren()) do
					if inst:IsDescendantOf(room) then
						return room.Name
					end
				end
			end
			local function DisableSeekFools()
				if Floor == "Fools" or OldHotel == true then
					if Floor == "Fools" then
						game.Workspace.CurrentRooms.ChildAdded:Wait()
					end
					task.wait(0.25)	
					if CurrentRoom > 15 then
						Notify({Title = "No Seek",Description = "Disabling Seek..."})
						Collision.Anchored = true
						task.wait(0.25)
						Notify({Title = "No Seek",Description = "Seek is now disabled!"})

						Sound()
						Collision.Anchored = false
						if Floor == "Fools" or OldHotel == true then
							for i,collision in pairs(game.Workspace:GetDescendants()) do
								if collision.Name == "TriggerEventCollision" and collision:IsDescendantOf(workspace) and collision:FindFirstChild("Collision") then

									collision:Destroy()

								end
							end
						end
					end
				end
			end
			local fly = {
				enabled = false,
				flyBody = Instance.new("BodyVelocity"),

			}

			fly.flyBody.Velocity = Vector3.zero
			fly.flyBody.MaxForce = Vector3.one * 9e9

			local keys = false
			local books = false
			local levers = false
			local doors = false
			local closets = false



			local Window = Library:CreateWindow({
				Title = ScriptName .. " | " .. "DOORS",
				Center = true,
				AutoShow = true,
				TabPadding = 3,
				MenuFadeTime = 0
			})
			local Tabs = {
				-- Creates a new tab titled Main
				Main = Window:AddTab('Player'),
				Exploits = Window:AddTab('Cheats'),
				ESP = Window:AddTab('ESP'),
				Visuals = Window:AddTab('Visuals'),

				
				Fun = Window:AddTab('Fun'),
				UISettings = Window:AddTab('UI Settings')






			}

			


			local UISettings = Tabs["UISettings"]


			OldPhysics = HumanoidRootPart.CustomPhysicalProperties



			local ESP = Tabs.ESP:AddLeftGroupbox('Objects')
			local ExploitsRightTab = Tabs.Exploits:AddRightTabbox('stuffz')
			local MainLeftTab = Tabs.Main:AddLeftTabbox('stuffz')
			local ESPSettings = Tabs.ESP:AddRightGroupbox("Settings")
			local LeftGroupBox = MainLeftTab:AddTab('Movement')

			local CharacterTab = MainLeftTab:AddTab('Character')
			local LeftGroupBox2 = ExploitsRightTab:AddTab('Bypass')
			local ExploitsLeftTab = Tabs.Exploits:AddLeftTabbox('stuffz')

			
			local NotificationsTab = Tabs.Visuals:AddRightTabbox('Notifications')
			local LeftGroupBox6 = NotificationsTab:AddTab('Notifiers')
			

			local LeftGroupBox9 = Tabs.Visuals:AddLeftGroupbox('Camera')
			local VisualsRemove = Tabs.Visuals:AddLeftGroupbox('Removals')

			local Anti = ExploitsLeftTab:AddTab('Anti')
			local Remove = ExploitsLeftTab:AddTab('Remove')


			local Automation = ExploitsRightTab:AddTab('Automation')
			local ExtraVisualsTab = Tabs.Visuals:AddLeftGroupbox('Extra')
			EntityAlliasesTab = Tabs.Fun:AddRightGroupbox('Custom Entity Names')
			ChatNotifyMessagesTab = NotificationsTab:AddTab('Chat Notify')


			local RightGroupBox = Tabs.Main:AddRightGroupbox('Prompt')


			local LeftGroupBox11 = Tabs.Exploits:AddLeftGroupbox('Scripts')
			local Items = Tabs.Fun:AddLeftGroupbox('Custom Items')
			local LeftGroupBox4 = Tabs.Main:AddRightGroupbox('Misc')
			local CustomAcheivement = Tabs.Fun:AddLeftGroupbox('Custom Acheivement')

			CustomAcheivement:AddInput('CATitle',{
				Numeric = false,
				Finished = false,
				Placeholder = "Achievement Name",
				Text = "Achievement Name",

			})
			CustomAcheivement:AddInput('CADescription',{
				Numeric = false,
				Finished = false,
				Placeholder = "Achievement Text",
				Text = "Achievement Text",

			})
			CustomAcheivement:AddInput('CAObtainment',{
				Numeric = false,
				Finished = false,
				Placeholder = "Achievement Obtainment",
				Text = "Achievement Obtainment",

			})
			CustomAcheivement:AddInput('CAImage',{
				Numeric = true,
				Finished = false,
				Placeholder = "Achievement Icon ID",
				Text = "Achievement Icon",

			})
			CustomAcheivement:AddInput('CADelay',{
				Numeric = true,
				Finished = false,
				Placeholder = "Delay",
				Text = "Delay (Seconds)",

			})
			CustomAcheivement:AddDivider()
			CustomAcheivement:AddButton({
				Text = "Get Achievement",
				Tooltip = "Make an Unlocked Achievement Notification with the provided parameters",
				DoubleClick = false,
				Func = function()
					if tonumber(Options.CADelay.Value) then
						task.wait(Options.CADelay.Value)
					end
					local table = {

						Title = Options.CATitle.Value or "Achievement",
						Description = Options.CADescription.Value or "I'm a pro at this game",
						Reason = Options.CAObtainment.Value or "Beat the game 1238719237 times",
						Image = "rbxassetid://" .. Options.CAImage.Value or "rbcassetid://14229414086",
						NotificationType = "UNLOCKED ACHIEVEMENT"

					}
					DoorsNotify(table)
				end
			})

			ChatNotifyMessagesTab:AddToggle('ChatNotify', {
				Text = 'Enabled',
				Default = false, -- Default value (true / false)
				Tooltip = 'Send Entity Alert messages in the chat, visible to everyone', -- Information shown when you hover over the toggle

				Callback = function(Value)
					ChatNotifyMonsters = Value
				end
			});
			ChatNotifyMessagesTab:AddDivider()
			Items:AddDropdown('SelectItem', {
				Values = {'Flashlight','Gummy Flashlight','Shears (On Anything)'},
				Default = 0, -- number index of the value / string
				Multi = false, -- true / false, allows multiple choices to be selected

				Text = 'Select Item',
				Tooltip = 'Select the item you want to get.', -- Information shown when you hover over the dropdown

				Callback = function(Value)

				end
			})
			Items:AddDivider()

			Items:AddButton({
				Text = 'Give Item',
				Func = function()
					local Value = Options.SelectItem.Value
					if Value == "Shears (On Anything)" then
						loadstring(game:HttpGet("https://raw.githubusercontent.com/MrNeRD0/Doors-Hack/main/shears_done.lua"))()
					elseif Value == "Flashlight" then
						local Modules = game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game.RemoteListener.Modules
						local shears = game:GetObjects("rbxassetid://12794355024")[1]
						shears.CanBeDropped = false
						shears.Handle.Material = Enum.Material.Metal
						shears.Handle.Color = Color3.fromRGB(75,79,94)
						shears.Handle.Transparency = 0
						shears.Handle.Dark.Color = Color3.fromRGB(91,93,105)
						shears.Handle.Dark.Material = Enum.Material.Metal
						shears.Handle.Glass.Color = Color3.fromRGB(255,255,255)
						shears.Handle.Switch.Color = Color3.fromRGB(145,146,162)
						shears.Parent = game.Players.LocalPlayer.Backpack

						shears:WaitForChild("Handle").SpotLight.Brightness = 3
						shears:WaitForChild("Handle").SpotLight.Range = 75
						shears:WaitForChild("Handle").SpotLight.Angle = 60
						shears:WaitForChild("Handle").SpotLight.Color = Color3.fromRGB(189, 149, 113)
						shears:SetAttribute("LightSourceBeam",true)
						shears:SetAttribute("LightSourceStrong",true)
						shears:SetAttribute("Enabled",false)
						shears:SetAttribute("Interactable",true)
						shears:SetAttribute("LightSource",true)

						shears:SetAttribute("NamePlural","Shakelights")
						shears:SetAttribute("NameSingular","Shakelight")
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
									if Modules:FindFirstChild("Screech") then
										Modules.Screech.Name = "Screech_"
									end	
								else

									if Modules:FindFirstChild("Screech_") then
										if AntiScreech == false then
											Modules["Screech_"].Name = "Screech"
										end
									end
								end

								task.wait(0.25)

								Shaking = false


							end

						end)
						local connection = RunService.RenderStepped:Connect(function()
							if enabled == true then
								shears:WaitForChild("Handle").SpotLight.Enabled = true
								Shake_Sound.PlaybackSpeed = 1

							else
								shears:WaitForChild("Handle").SpotLight.Enabled = false
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
							if Modules:FindFirstChild("Screech_") then
								if AntiScreech == false then
									Modules["Screech_"].Name = "Screech"
								end
							end

						end)	
						shears.Destroying:Wait()
						connection:Disconnect()
					elseif Value == "Bulklight" then
						local Modules = game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game.RemoteListener.Modules
						local shears = game:GetObjects("rbxassetid://81989292919242")[1]
						local attachments = {}
						shears.CanBeDropped = false

						shears.Parent = game.Players.LocalPlayer.Backpack
						shears:FindFirstChild("Animations"):Destroy()
						for i,attach in pairs(shears:GetDescendants()) do
							if attach:IsA("SpotLight") or attach:IsA("PointLight") or attach:IsA("SurfaceLight") then
								table.insert(attachments,attach)
							end

						end


						shears:SetAttribute("LightSourceBeam",true)
						shears:SetAttribute("LightSourceStrong",true)
						shears:SetAttribute("Enabled",false)
						shears:SetAttribute("Interactable",true)
						shears:SetAttribute("LightSource",true)
						shears:SetAttribute("ToolGripOffset",Vector3.new(0, 0, 1.5))

						shears:SetAttribute("NamePlural","Shakelights")
						shears:SetAttribute("NameSingular","Shakelight")



						shears.Handle.Orientation = Vector3.new(0,0,0)
						local newCFrame = CFrame.new(-0, -1.5, 1.5, 1, 0, -0, 0, 0, 1, 0, -1, 0)

						shears.Grip = newCFrame
						shears.WorldPivot = CFrame.new(-46.6105042, 277.06485, 317.182953, 0, 0, 1, 0, 1, -0, -1, 0, 0)
						shears.Name = "Flashlight"

						local Animations_Folder = Instance.new("Folder")
						Animations_Folder.Name = "Animations"
						Animations_Folder.Parent = shears
						local Shake_Animation = Instance.new("Animation")
						Shake_Animation.AnimationId = "rbxassetid://15686338453"
						Shake_Animation.Parent = Animations_Folder
						local Idle_Animation = Instance.new("Animation")
						Idle_Animation.AnimationId = "rbxassetid://15764585564"
						Idle_Animation.Parent = Animations_Folder
						local Idle_Animation_2 = Instance.new("Animation")
						Idle_Animation_2.AnimationId = "rbxassetid://15764034159"
						Idle_Animation_2.Parent = Animations_Folder

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
						shears.TextureId = "rbxassetid://15399271835"

						local Animator = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):FindFirstChildOfClass("Animator")
						local anim2 = Animator:LoadAnimation(Idle_Animation)
						anim2.Priority = Enum.AnimationPriority.Action4
						local anim4 = Animator:LoadAnimation(Idle_Animation_2)
						anim4.Priority = Enum.AnimationPriority.Action4


						local anim3 = Animator:LoadAnimation(Equip_Animation)
						anim3.Priority = Enum.AnimationPriority.Action3


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
									if Modules:FindFirstChild("Screech") then
										Modules.Screech.Name = "Screech_"
									end	
								else

									if Modules:FindFirstChild("Screech_") then
										if AntiScreech == false then
											Modules["Screech_"].Name = "Screech"
										end
									end
								end

								task.wait(0.5)

								Shaking = false


							end

						end)
						local connection = RunService.RenderStepped:Connect(function()
							if enabled == true then
								anim2:Play()
								anim4:Stop()
								for i,light in pairs(attachments) do
									light.Enabled = true
								end
								shears.Handle.ShadowMaker.Decal.Transparency = 0
								Shake_Sound.PlaybackSpeed = 0.95

							else
								if shears.Parent == Character then
									anim4:Play()
								end
								anim2:Stop()

								for i,light in pairs(attachments) do
									light.Enabled = false
								end
								shears.Handle.ShadowMaker.Decal.Transparency = 1
								Shake_Sound.PlaybackSpeed = 0.7

							end
						end)
						shears.Equipped:Connect(function()



						end)
						shears.Unequipped:Connect(function()
							anim2:Stop()
							anim4:Stop()
							enabled = false
							if Modules:FindFirstChild("Screech_") then
								if AntiScreech == false then
									Modules["Screech_"].Name = "Screech"
								end
							end

						end)	
						shears.Destroying:Wait()
						connection:Disconnect()

					elseif Value == "Gummy Flashlight" then
						local Modules = game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game.RemoteListener.Modules
						local shears = game:GetObjects("rbxassetid://12794355024")[1]
						shears.CanBeDropped = false
						shears.Parent = game.Players.LocalPlayer.Backpack
						shears:WaitForChild("Handle").SpotLight.Brightness = 2
						shears:WaitForChild("Handle").SpotLight.Range = 75
						shears:WaitForChild("Handle").SpotLight.Angle = 50
						shears:SetAttribute("LightSourceBeam",true)
						shears:SetAttribute("LightSourceStrong",true)
						shears:SetAttribute("Enabled",false)
						shears:SetAttribute("Interactable",true)
						shears:SetAttribute("LightSource",true)

						shears:SetAttribute("NamePlural","Shakelights")
						shears:SetAttribute("NameSingular","Shakelight")
						local newCFrame = CFrame.new(0.00991821289, -0.17137143, 0.0771455616, 1, 0, 0, 0, 0, -1, 0, 1, 0)

						shears.Grip = newCFrame
						shears.WorldPivot = CFrame.new(249.886551, 1.53111672, -16.8949146, -0.765167952, 0.00742102973, 0.64378804, -0.000446901657, 0.999927223, -0.0120574543, -0.643830597, -0.00951368641, -0.765108943)
						shears.Name = "Shakelight"
						local Animations_Folder = Instance.new("Folder")
						Animations_Folder.Name = "Animations"
						Animations_Folder.Parent = shears
						local Shake_Animation = Instance.new("Animation")
						Shake_Animation.AnimationId = "rbxassetid://12001275923"
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
						Shake_Sound.SoundId = "rbxassetid://11374330092"
						Shake_Sound.PlaybackSpeed = 0.9
						Shake_Sound.Volume = 1
						local Shaking = false

						shears.TextureId = "rbxassetid://11373085609"

						local Animator = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):FindFirstChildOfClass("Animator")
						local anim2 = Animator:LoadAnimation(Idle_Animation)
						anim2.Priority = Enum.AnimationPriority.Action3

						local anim3 = Animator:LoadAnimation(Equip_Animation)
						anim3.Priority = Enum.AnimationPriority.Action3
						anim3:Play()

						local anim = Animator:LoadAnimation(Shake_Animation)	

						shears.Activated:Connect(function()
							if Shaking == false and shears.Parent == game.Players.LocalPlayer.Character then





								anim.Priority = Enum.AnimationPriority.Action4

								anim:Stop()
								Shaking = true
								task.wait()
								anim:Play()

								Shake_Sound:Play()

								task.wait(0.25)

								Shaking = false


							end

						end)
						shears.Equipped:Connect(function()
							anim3:Play()
							anim2:Play()
							if Modules:FindFirstChild("Screech") then
								Modules.Screech.Name = "Screech_"
							end
						end)
						shears.Unequipped:Connect(function()
							anim2:Stop()
							if Modules:FindFirstChild("Screech_") then
								if AntiScreech == false then
									Modules["Screech_"].Name = "Screech"
								end
							end
						end)



					end	
				end,
				DoubleClick = false,
				Tooltip = 'Get the selected item.'
			})

			local function AddRetroTab()
				
				Anti:AddToggle('AntiLava',{
					Text = "Anti-Killbricks",
					Default = false,
					Tooltip = 'Prevents the killbricks from Retro Mode from hurting you.',
				})
				Toggles.AntiLava:OnChanged(function(value)
					for i,room in pairs(game.Workspace.CurrentRooms:GetChildren()) do
						for i,part in pairs(room:GetDescendants()) do
							if part.Name == "Lava" then
								part.CanTouch = not value
							elseif part.Name == "ScaryWall" then
								for i,part2 in pairs(part:GetDescendants()) do
									if part2:IsA("BasePart") then
										part2.CanTouch = not value
										part2.CanCollide = not value
									end
								end
							end
						end
					end
				end)
			end
			

			function AddBackdoorTab()
				
				Anti:AddToggle('AntiLookman', {
					Text = 'Anti-Lookman',
					Default = false, -- Default value (true / false)
					Tooltip = "Allows you to look into The Lookman's eyes without taking damage.", -- Information shown when you hover over the toggle

					Callback = function(Value)

						AntiLookman = Value

					end
				})
				Anti:AddToggle('AntiVacuum', {
					Text = 'Anti-Vacuum',
					Default = false, -- Default value (true / false)
					Tooltip = 'Prevents Vacuum from sucking you out into the void.', -- Information shown when you hover over the toggle

					Callback = function(Value)

						AntiVacuum = Value
						if Value == true then
							for i,e in pairs(game.Workspace:GetDescendants()) do
								if e.Name == "SideroomSpace" then
									DisableDupe(e)
								end


							end
						end

					end
				})
				
				ESP:AddToggle('ToggleTimeLever', {
					Text = 'Time Levers',
					Default = false, -- Default value (true / false)
					Tooltip = 'Highlights all Time Levers that spawn.', -- Information shown when you hover over the toggle

					Callback = function(Value)
						TimerLevers = Value
						if Value == true then
							for i,inst in pairs(game.Workspace.CurrentRooms:FindFirstChild(CurrentRoom):GetDescendants()) do
								if inst.Name == "TimerLever" and inst:FindFirstChild("Main") then
									esp(inst,inst.Main,"Time Lever", levercolor,true,false)
								end
							end
							game.Workspace.CurrentRooms.ChildAdded:Wait()
							for i,inst in pairs(game.Workspace.CurrentRooms:FindFirstChild(CurrentRoom + 1):GetDescendants()) do
								if inst.Name == "TimerLever" and inst:FindFirstChild("Main") then
									esp(inst,inst.Main,"Time Lever", levercolor,true,false)
								end
							end
						end
						if Value == false then
							for i,inst in pairs(game.Workspace.CurrentRooms:GetDescendants()) do
								if inst.Name == "TimerLever" then
									inst:SetAttribute("ESP", false)
								end
							end
						end
					end
				})

				Toggles.ToggleTimeLever:AddColorPicker('ColorPickerTimeLever', {
					Default = timelevercolor, -- Bright green
					Title = 'Time Levers', -- Optional. Allows you to have a custom color picker title (when you open it)
					Transparency = 0, -- Optional. Enables transparency changing for this color picker (leave as nil to disable)

					Callback = function(Value)
						timelevercolor = Value
					end
				})
			end
			local function AddFoolsTab()

				
				Remove:AddToggle('BypassSeek', {
					Text = 'Remove Seek Chases [Older Build]',
					Tooltip = 'Prevents Seek from spawning with the SUPER HARD MODE!!! or the Hotel- Modifier enabled.',
					Default = false, -- Default value (true / false)
					Callback = function(Value)
						BypassSeek = Value
						if Value == true then

							for i,inst in pairs(game.Workspace:GetDescendants()) do
								if inst.Name == "Collision" and inst.Parent.Name == "TriggerEventCollision" then



									DisableSeekFools()


								end
							end


						end
					end,
				})
				
				Anti:AddToggle("AntiBananaPeel",{Text = "Anti-Banana", Default = false,Tooltip = 'Prevents Banana Peels tripping you over.'})

				Anti:AddToggle("AntiJeff",{Text = "Anti-Jeff",Default = false,Tooltip = 'Prevents Jeff The Killer hurting you.'})
				


				Anti:AddToggle("GodmodeFigure", {Text = "Anti-Figure [Older Build]",Default = false,Tooltip = 'Allows you to touch Figure without him killing you.'})
				
				ESP:AddToggle("BananaESP",{
					Text = "Banana Peels",
					Default = false,
					Tooltip = 'Highlights all Banana Peels that spawn.',
					Callback = function(value)
						for i,e in pairs(game.Workspace:GetChildren()) do
							if e.Name == "BananaPeel" then
								if value == true then
									esp(e,e,"Banana",bananapeelcolor,true,false)
								else
									e:SetAttribute("ESP",false)	
								end
							end
						end
					end,
				})
				ESP:AddToggle("JeffESP",{
					Text = "Jeff The Killer",
					Default = false,
					Tooltip = 'Highlights Jeff The Killer if he spawns.',
					Callback = function(value)
						if value == true then
							for i,e in pairs(game.Workspace:GetDescendants()) do
								if e.Name == "JefTheKiller" then


									esp(e,e.HumanoidRootPart,"Jeff", jeffcolor,false,false)


								end
							end
						end
					end,
				})
				Toggles.BananaESP:AddColorPicker('ColorPickerBanana', {
					Default = bananapeelcolor, -- Bright green
					Title = 'Banana Peels', -- Optional. Allows you to have a custom color picker title (when you open it)
					Transparency = 0, -- Optional. Enables transparency changing for this color picker (leave as nil to disable)

					Callback = function(Value)
						bananapeelcolor =  Value
					end
				})
				Toggles.JeffESP:AddColorPicker('ColorPickerJeff', {
					Default = jeffcolor, -- Bright green
					Title = 'Jeff The Killer', -- Optional. Allows you to have a custom color picker title (when you open it)
					Transparency = 0, -- Optional. Enables transparency changing for this color picker (leave as nil to disable)

					Callback = function(Value)
						jeffcolor =  Value
					end
				})


				Toggles.GodmodeFigure:OnChanged(function(value)
					if Floor == "Fools"  or OldHotel == true then
						if value and not Toggles.Toggle250.Value then Toggles.Toggle250:SetValue(true) Toggles.Noclip:SetValue(true)

							Notify({Title = "Anti-Figure",Description = "Godmode was automatically enabled because it's required for Figure Godmode!"})
							Sound()
							if CurrentRoom ~= 50 or CurrentRoom ~= 100 then return end

							for _, figure in pairs(workspace.CurrentRooms:GetDescendants()) do
								if figure:IsA("Model") and figure.Name == "Figure" then
									for i, v in pairs(figure:GetDescendants()) do
										if v:IsA("BasePart") then
											if not v:GetAttribute("Clip") then v:SetAttribute("Clip", v.CanCollide) end

											v.CanTouch = not value
											v.CanCollide = value
										end
									end

								end
							end
						end
					end

				end)

				if Floor == "Fools" or OldHotel == true then
					Toggles.AntiBananaPeel:OnChanged(function(value)
						for _, peel in pairs(workspace:GetChildren()) do
							if peel.Name == "BananaPeel" then
								peel.CanTouch = not value
							end
						end
					end)

					Toggles.AntiJeff:OnChanged(function(value)
						for _, jeff in pairs(workspace:GetChildren()) do
							if jeff:IsA("Model") and jeff.Name == "JeffTheKiller" then
								task.spawn(function()
									repeat task.wait() until Library.Unloaded
									jeff:FindFirstChildOfClass("Humanoid").Health = 0
								end)
								for i, v in pairs(jeff:GetDescendants()) do
									if v:IsA("BasePart") then
										v.CanTouch = not value
									end
								end
							end
						end
					end)

				end


			end

			function AddRoomsTab()
				
					Remove:AddToggle('AntiA90', {
						Text = 'Remove A-90',
						Default = false, -- Default value (true / false)
						Tooltip = 'Prevents A-90 from spawning.', -- Information shown when you hover over the toggle

						Callback = function(Value)
							if A90 then
								if Value == true then
									A90.Name = "A90_Dumb"
								else
									A90.Name = "A90"
								end
							end
						end
					})
					
				Automation:AddToggle("AutoRooms", {
						Text = "Auto A-1000",
						Default = false,
						Tooltip = 'Automatically complete The Rooms',


					})


				Automation:AddToggle("AutoRoomsDebug", { 
						Text = "Show Debug Info",
						Tooltip = 'Show extra information about Auto A-1000',
						Default = false
					})

				Automation:AddToggle("ShowAutoRoomsPathNodes", { 
						Text = "Show Pathfinding Nodes",
						Tooltip = 'Visualises where the player will automatically move to.',
						Default = false

					})
				Automation:AddToggle("AutoRoomsIgnoreA60",{Text = "Ignore A-60",Default = false,Tooltip = 'Auto A-1000 will not hide from the entity A-60.', Callback = function(Value)if Value == true then if game.ReplicatedStorage.GameData.Floor.Value == "Rooms" then if SpeedBypassEnabled == true then Options.WS:SetMax(15) if SpeedBoost > 15 then Options.WS:SetValue(15) end Notify({Title = "Ignore A-60",Description = "Godmode has automatically enabled and max walkspeed has been set to 20.",Reason = "This is to avoid lagging back."}) Sound() end
							end	
						elseif Value == false then
							if SpeedBypassEnabled == true then
								Options.WS:SetMax(60)		
							end



						end  end})

				
				if game.ReplicatedStorage.GameData.Floor.Value == "Rooms" then
					Toggles.AntiA90:OnChanged(function(value)

						if Toggles.AutoRooms.Value and not value then
							Notify({
								Title = "Auto A-1000",
								Description = "No A-90 is required for Auto A-1000 to work!",
								Reason = "No A-90 has been enabled",
								Sound()
							})

							Toggles.AntiA90:SetValue(true)

						end



					end)
					
					local function GetAutoRoomsPathfindingGoal(): BasePart
						local entity = (workspace:FindFirstChild("A60") or workspace:FindFirstChild("A120"))
						if entity and entity.PrimaryPart.Position.Y > -10 then
							if entity.Name == "A120" or entity.Name == "A60" and not Toggles.AutoRoomsIgnoreA60.Value then
								local GoalLocker = GetNearestAssetWithCondition(function(asset)
									return asset.Name == "Rooms_Locker" and not asset.HiddenPlayer.Value and asset.PrimaryPart.Position.Y > -10 or asset.Name == "Rooms_Locker_Fridge" and not asset.HiddenPlayer.Value and asset.PrimaryPart.Position.Y > -10
								end)

								return GoalLocker.PrimaryPart
							end
						end
						return workspace.CurrentRooms[CurrentRoom].RoomExit
					end


					local _internal_mspaint_pathfinding_nodes = Instance.new("Folder", game.Workspace) do
						_internal_mspaint_pathfinding_nodes.Name = "pathfinding_nodes"
					end

					local _internal_mspaint_pathfinding_block = Instance.new("Folder", game.Workspace) do
						_internal_mspaint_pathfinding_block.Name = "pathfinding_block"
					end

					Toggles.ShowAutoRoomsPathNodes:OnChanged(function(value)
						for _, node in pairs(_internal_mspaint_pathfinding_nodes:GetChildren()) do
							node.Transparency = value and 0.5 or 1
						end
						for _, nodeBlock in pairs(_internal_mspaint_pathfinding_block:GetChildren()) do
							nodeBlock.Transparency = value and 0.9 or 1
						end
					end)

					local A1000Connection = game["Run Service"].RenderStepped:Connect(function()
						if not Toggles.AutoRooms.Value then return end

						local entity = (workspace:FindFirstChild("A60") or workspace:FindFirstChild("A120"))

						local isEntitySpawned = (entity and entity.PrimaryPart.Position.Y > -10)
						if isEntitySpawned and not game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored then
							if entity.Name == "A120" or entity.Name == "A60" and not Toggles.AutoRoomsIgnoreA60.Value then
								local pathfindingGoal = GetAutoRoomsPathfindingGoal()

								if pathfindingGoal.Parent:FindFirstChild("HidePrompt") then
									forcefireproximityprompt(pathfindingGoal.Parent.HidePrompt)
									if game.Players.LocalPlayer.Character:GetAttribute("Hiding") ~= true and game.Players.LocalPlayer:DistanceFromCharacter(pathfindingGoal.Position) < 5 then
										local pos = CFrame.new(pathfindingGoal.Position)*CFrame.new(0,0,2)
										game.Workspace.CurrentCamera.CFrame = pos
									end
								end

							end
						elseif not isEntitySpawned and game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored or entity and entity.Name == "A60" and Toggles.AutoRoomsIgnoreA60.Value  then

							for i = 1, 10 do
								game.ReplicatedStorage.RemotesFolder.CamLock:FireServer()
							end
						end
					end)

					Toggles.AutoRooms:OnChanged(function(value)
						local hasResetFailsafe = false

						local function nodeCleanup()
							_internal_mspaint_pathfinding_nodes:ClearAllChildren()
							_internal_mspaint_pathfinding_block:ClearAllChildren()
							hasResetFailsafe = true
						end
						local function moveToCleanup()
							if game.Players.LocalPlayer.Character.Humanoid then
								game.Players.LocalPlayer.Character.Humanoid:Move(game.Players.LocalPlayer.Character.HumanoidRootPart.Position)
								game.Players.LocalPlayer.Character.Humanoid.WalkToPart = nil
								game.Players.LocalPlayer.Character.Humanoid.WalkToPoint = game.Players.LocalPlayer.Character.RootPart.Position
							end
							nodeCleanup()
						end

						if value then
							Toggles.AntiA90:SetValue(true)
							local lastRoomValue = 0

							local function createNewBlockedPoint(point: PathWaypoint)
								local block = Instance.new("Part", _internal_mspaint_pathfinding_block)
								local pathMod = Instance.new("PathfindingModifier", block)
								pathMod.Label = "pathBlock"
								

								block.Name = ESPLibrary:GenerateRandomString()
								block.Shape = Enum.PartType.Block

								local sizeY = 10

								block.Size = Vector3.new(1, sizeY, 1)
								block.Color = Color3.fromRGB(255, 130, 30)
								block.Material = Enum.Material.Neon
								block.Position = point.Position + Vector3.new(0, sizeY / 2, 0)
								block.Anchored = true
								block.CanCollide = false
								block.Transparency = Toggles.ShowAutoRoomsPathNodes.Value and 1 or 1
							end

							local function doAutoRooms()
								local pathfindingGoal = GetAutoRoomsPathfindingGoal()

								if CurrentRoom ~= lastRoomValue then
									_internal_mspaint_pathfinding_block:ClearAllChildren()
									lastRoomValue = CurrentRoom
								end



								local path = game:GetService("PathfindingService"):CreatePath({
									AgentCanJump = false,
									AgentCanClimb = false,
									WaypointSpacing = 5,
									AgentRadius = 1,
									Costs = {
										_ms_pathBlock = 8 --cost will increase the more stuck you get.
									}
								})

								path:ComputeAsync(HumanoidRootPart.Position - Vector3.new(0, 2.5, 0), pathfindingGoal.Position)
								local waypoints = path:GetWaypoints()
								local waypointAmount = #waypoints

								if path.Status == Enum.PathStatus.Success then
									hasResetFailsafe = true
									task.spawn(function()
										task.wait(0.1)
										hasResetFailsafe = false
										if game.Players.LocalPlayer.Character.Humanoid and game.Players.LocalPlayer.Character.Collision then
											local checkFloor = game.Players.LocalPlayer.Character.Humanoid.FloorMaterial
											local isStuck = checkFloor == Enum.Material.Air or checkFloor == Enum.Material.Concrete
											if isStuck then
												repeat task.wait()
													Collision.CanCollide = false
													Collision.CollisionCrouch.CanCollide = not (godmode)
												until not isStuck or hasResetFailsafe
												Collision.CanCollide = not (godmode)
											end
											hasResetFailsafe = true
										end
									end)
									if Toggles.AutoRoomsDebug.Value then
										local desc = "Attempting to move to " .. pathfindingGoal.Parent.Name
										if tonumber(pathfindingGoal.Parent.Name) then
											desc = "Attempting to move to the Next Door ["..tostring(tonumber(pathfindingGoal.Parent.Name) + 1).."]" 
										end
										Notify({
											Title = "Auto A-1000 Debug",
											Description = desc,
										})
										Sound()
									end
									_internal_mspaint_pathfinding_nodes:ClearAllChildren()

									for i, waypoint in pairs(waypoints) do
										local node = Instance.new("Part", _internal_mspaint_pathfinding_nodes) do
											node.Name = ESPLibrary:GenerateRandomString()
											node.Size = Vector3.new(1, 1, 1)
											node.Orientation = Vector3.new(0,0,90)
											node:SetAttribute("Number",i)
											node.Position = waypoint.Position-Vector3.new(0,0.4,0)
											node.Anchored = true
											node.Material = Enum.Material.Neon
											node.CanCollide = false
											node.Shape = Enum.PartType.Cylinder
											node.Color = Color3.fromRGB(255,170,0)
											node.Transparency = Toggles.ShowAutoRoomsPathNodes.Value and 0 or 1
										end
									end

									local lastWaypoint = nil
									for i, waypoint in pairs(waypoints) do
										local moveToFinished = false
										local recalculate = false
										local waypointConnection = game.Players.LocalPlayer.Character.Humanoid.MoveToFinished:Connect(function() moveToFinished = true end)
										if not moveToFinished or not Toggles.AutoRooms.Value then
											game.Players.LocalPlayer.Character.Humanoid:MoveTo(waypoint.Position)

											local entity = (workspace:FindFirstChild("A120"))
											local isEntitySpawned = (entity and entity.PrimaryPart.Position.Y > -10)
											local entity2 = (workspace:FindFirstChild("A60"))

											local isEntitySpawned2 = (entity and entity.PrimaryPart.Position.Y > -10 and not Toggles.AutoRoomsIgnoreA60.Value)

											if isEntitySpawned and not game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored and pathfindingGoal.Parent.Name ~= "Rooms_Locker" and pathfindingGoal.Parent.Name ~= "Rooms_Locker_Fridge" or isEntitySpawned2 and not game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored and pathfindingGoal.Parent.Name ~= "Rooms_Locker" and pathfindingGoal.Parent.Name ~= "Rooms_Locker_Fridge" then
												waypointConnection:Disconnect()

												if not Toggles.AutoRooms.Value then
													nodeCleanup()
													break
												else
													for i,node in pairs(_internal_mspaint_pathfinding_nodes:GetChildren()) do
														if node:GetAttribute("Number") == i then
															node:Destroy()
														end
													end
												end

												break
											end

											task.delay(1.5, function()
												if moveToFinished then return end
												if (not Toggles.AutoRooms.Value) then return moveToCleanup() end

												repeat task.wait(0.25) until (not game.Players.LocalPlayer.Character:GetAttribute("Hiding") and not game.Players.LocalPlayer.Character.PrimaryPart.Anchored)
												if Toggles.AutoRoomsDebug.Value then

												end
												recalculate = true
												if lastWaypoint == nil and waypointAmount > 1 then
													waypoint = waypoints[i+1]
												else
													waypoint = waypoints[i-1]
												end

												createNewBlockedPoint(waypoint)
											end)
										end

										repeat task.wait() until moveToFinished or not Toggles.AutoRooms.Value or recalculate
										lastWaypoint = waypoint

										waypointConnection:Disconnect()

										if not Toggles.AutoRooms.Value then
											nodeCleanup()
											break
										else
											for i,node in pairs(_internal_mspaint_pathfinding_nodes:GetChildren()) do
												if node:GetAttribute("Number") == i then
													node:Destroy()
												end
											end
										end

										if recalculate then break end
									end
								else
									if Toggles.AutoRoomsDebug.Value then
										Notify({
											Title = "Auto A-1000 Debug",
											Description = "Pathfinding failed with status " .. tostring(path.Status)   
										}, Toggles.AutoRoomsDebug.Value)
										Sound()

										Character:PivotTo(Character:GetPivot() + workspace.CurrentCamera.CFrame.LookVector * Vector3.new(1, 0, 1) * -10)

										Humanoid.HipHeight = 0
										task.wait()
										Humanoid.HipHeight = 3



									end
								end
							end
							while Toggles.AutoRooms.Value and not Library.Unloaded do
								if CurrentRoom == 1000 then
									Notify({
										Title = "Auto Rooms",
										Description = "You have reached A-1000",

									})

									break
								end

								doAutoRooms()
							end

						end
					end)
				end
			end
			function AddMinesTab()

				



					Anti:AddToggle("AntiGiggle", {
						Text = "Anti-Giggle",
						Default = false,
						Tooltip = 'Prevents Giggle from attacking you.',
						Callback = function(value)
							for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
								for _, giggle in pairs(room:GetChildren()) do
									if giggle.Name == "GiggleCeiling" then
										giggle:WaitForChild("Hitbox", 5).CanTouch = not value
									end
								end
							end
						end,
					})

					Anti:AddToggle("AntiGloomEgg", {
						Text = "Anti-Egg",
						Default = false,
						Tooltip = 'Allows you to step on Gloombat Eggs without them breaking.'
					})

				

					

					Anti:AddToggle("AntiSeekFlood", {
						Text = "Anti-Seek [Dam]",
						Default = false,
						Tooltip = 'Prevents Dam Seek from hurting you.'
					})

				
				
				ESP:AddToggle('ToggleFuseESP', {
					Text = 'Fuses',
					Default = false, -- Default value (true / false)
					Tooltip = 'Highlights all Generator Fuses.', -- Information shown when you hover over the toggle

					Callback = function(Value)
						FuseESP = Value
						if Value == true then
							for i,inst in pairs(game.Workspace.CurrentRooms:GetDescendants()) do
								if inst.Name == "FuseObtain" then

									esp(inst,inst.Hitbox,"Fuse", fusecolor,true,false)


								end
							end

							game.Workspace.CurrentRooms.ChildAdded:Wait()
							for i,inst in pairs(game.Workspace.CurrentRooms:GetDescendants()) do
								if inst.Name == "FuseObtain" then

									esp(inst,inst.Hitbox,"Fuse", fusecolor,true,false)


								end
							end
						end
						if Value == false then
							for i,inst in pairs(game.Workspace.CurrentRooms:GetDescendants()) do
								if inst.Name == "FuseObtain" then
									inst:SetAttribute("ESP", false)
								end
							end
						end
					end
				})
				ESP:AddToggle('ToggleGeneratorESP', {
					Text = 'Generators',
					Default = false, -- Default value (true / false)
					Tooltip = 'Highlights all Generators', -- Information shown when you hover over the toggle

					Callback = function(Value)
						GeneratorESP = Value
						if Value == true then
							for i,inst in pairs(game.Workspace.CurrentRooms:GetDescendants()) do
								if inst.Name == "MinesGenerator" then

									esp(inst,inst.GeneratorMain,"Generator", generatorcolor,true,false)
								elseif inst.Name == "MinesGateButton" then
									esp(inst,inst.MainPart,"Gate Button", generatorcolor,true,false)


								end
							end

							game.Workspace.CurrentRooms.ChildAdded:Wait()
							for i,inst in pairs(game.Workspace.CurrentRooms:GetDescendants()) do
								if inst.Name == "MinesGenerator" then

									esp(inst,inst.GeneratorMain,"Generator", generatorcolor,true,false)
								elseif inst.Name == "MinesGateButton" then
									esp(inst,inst.MainPart,"Gate Button", generatorcolor,true,false)


								end
							end
						end
						if Value == false then
							for i,inst in pairs(game.Workspace.CurrentRooms:GetDescendants()) do
								if inst.Name == "MinesGenerator" or inst.Name == "MinesGateButton" then
									inst:SetAttribute("ESP", false)
								end
							end
						end
					end
				})
				ESP:AddToggle('ToggleLadderESP', {
					Text = 'Ladders',
					Default = false, -- Default value (true / false)
					Tooltip = 'Highlights all Laders', -- Information shown when you hover over the toggle

					Callback = function(Value)
						Ladders = Value
						if Value == true then
							for i,inst in pairs(game.Workspace.CurrentRooms:FindFirstChild(CurrentRoom):GetDescendants()) do
								if inst.Name == "Ladder" and inst:FindFirstChild("Main") then
									esp(inst,inst.Main,"Ladder", laddercolor,true,false)
								end
							end
							game.Workspace.CurrentRooms.ChildAdded:Wait()
							for i,inst in pairs(game.Workspace.CurrentRooms:FindFirstChild(CurrentRoom + 1):GetDescendants()) do
								if inst.Name == "Ladder" and inst:FindFirstChild("Main") then
									esp(inst,inst.Main,"Ladder", laddercolor,true,false)
								end
							end
						end
						if Value == false then
							for i,inst in pairs(game.Workspace.CurrentRooms:GetDescendants()) do
								if inst.Name == "Ladder" then
									inst:SetAttribute("ESP", false)
								end
							end
						end
					end
				})
				ESP:AddToggle('ToggleAnchorESP', {
					Text = 'Anchors',
					Default = false, -- Default value (true / false)
					Tooltip = 'Highlights all Anchors in Room 150', -- Information shown when you hover over the toggle

					Callback = function(Value)
						AnchorESP = Value
						if Value == true then
							for i,inst in pairs(game.Workspace.CurrentRooms:FindFirstChild(CurrentRoom):GetDescendants()) do
								if inst.Name == "MinesAnchor" and inst:FindFirstChild("Sign") then
									esp(inst,inst.PrimaryPart,"Anchor".. " "..inst.Sign.TextLabel.Text, grumblecolor,false,false)
								end
							end
							game.Workspace.CurrentRooms.ChildAdded:Wait()
							for i,inst in pairs(game.Workspace.CurrentRooms:FindFirstChild(CurrentRoom):GetDescendants()) do
								if inst.Name == "MinesAnchor" and inst:FindFirstChild("Sign") then
									esp(inst,inst.PrimaryPart,"Anchor".. " "..inst.Sign.TextLabel.Text, grumblecolor,false,false)
								end
							end
						end
						if Value == false then
							for i,inst in pairs(game.Workspace.CurrentRooms:GetDescendants()) do
								if inst.Name == "MinesAnchor" then
									inst:SetAttribute("ESP", false)
								end
							end
						end
					end
				})

				ESP:AddToggle('ToggleGrumbleESP', {
					Text = 'Grumbles',
					Default = false, -- Default value (true / false)
					Tooltip = 'Highlights all Grumbles in Room 150', -- Information shown when you hover over the toggle

					Callback = function(Value)
						GrumbleESP = Value
						if Value == true then
							for i,inst in pairs(game.Workspace.CurrentRooms:FindFirstChild(CurrentRoom):GetDescendants()) do
								if inst.Name == "GrumbleRig" and inst:FindFirstChild("Root") then
									esp(inst,inst.Root,"Grumble", grumblecolor,false,false)
								end
							end
							game.Workspace.CurrentRooms.ChildAdded:Wait()
							for i,inst in pairs(game.Workspace.CurrentRooms:FindFirstChild(CurrentRoom + 1):GetDescendants()) do
								if inst.Name == "GrumbleRig" and inst:FindFirstChild("Root") then
									esp(inst,inst.Root,"Grumble", grumblecolor,false,false)
								end
							end
						end
						if Value == false then
							for i,inst in pairs(game.Workspace.CurrentRooms:GetDescendants()) do
								if inst.Name == "GrumbleRig" then
									inst:SetAttribute("ESP", false)
								end
							end
						end
					end
				})
				ESP:AddToggle('ToggleMouseESP', {
					Text = 'Louie [Mouse]',
					Default = false, -- Default value (true / false)
					Tooltip = 'Highlights Louie when he spawns', -- Information shown when you hover over the toggle

					Callback = function(Value)
						GrumbleESP = Value
						if Value == true then
							for i,inst in pairs(game.Workspace.CurrentRooms:FindFirstChild(CurrentRoom):GetDescendants()) do
								if inst.Name == "MouseHole" and inst:FindFirstChild("Darkness") then
									esp(inst,inst.Darkness,"Louie [Mouse]", louiecolor,false,false)
								end
							end
							game.Workspace.CurrentRooms.ChildAdded:Wait()
							for i,inst in pairs(game.Workspace.CurrentRooms:FindFirstChild(CurrentRoom + 1):GetDescendants()) do
								if inst.Name == "MouseHole" and inst:FindFirstChild("Darkness") then
									esp(inst,inst.Darkness,"Louie [Mouse]", louiecolor,false,false)
								end
							end
						end
						if Value == false then
							for i,inst in pairs(game.Workspace.CurrentRooms:GetDescendants()) do
								if inst.Name == "MouseHole" then
									inst:SetAttribute("ESP", false)
								end
							end
						end
					end
				})

				Toggles.ToggleFuseESP:AddColorPicker('ColorPickerFuse', {
					Default = fusecolor, -- Bright green
					Title = 'Fuses', -- Optional. Allows you to have a custom color picker title (when you open it)
					Transparency = 0, -- Optional. Enables transparency changing for this color picker (leave as nil to disable)

					Callback = function(Value)
						fusecolor = Value
					end
				})

				Toggles.ToggleGeneratorESP:AddColorPicker('ColorPickerGenerator', {
					Default = generatorcolor, -- Bright green
					Title = 'Generators', -- Optional. Allows you to have a custom color picker title (when you open it)
					Transparency = 0, -- Optional. Enables transparency changing for this color picker (leave as nil to disable)

					Callback = function(Value)
						generatorcolor = Value
					end
				})
				Toggles.ToggleLadderESP:AddColorPicker('ColorPickerLadder', {
					Default = laddercolor, -- Bright green
					Title = 'Ladders', -- Optional. Allows you to have a custom color picker title (when you open it)
					Transparency = 0, -- Optional. Enables transparency changing for this color picker (leave as nil to disable)

					Callback = function(Value)
						laddercolor = Value
					end
				})
				Toggles.ToggleAnchorESP:AddColorPicker('ColorPickerAnchor', {
					Default = anchorcolor, -- Bright green
					Title = 'Anchors', -- Optional. Allows you to have a custom color picker title (when you open it)
					Transparency = 0, -- Optional. Enables transparency changing for this color picker (leave as nil to disable)
					Callback = function(Value)
						anchorcolor = Value
					end
				})
				Toggles.ToggleGrumbleESP:AddColorPicker('ColorPickerGrumble', {
					Default = grumblecolor, -- Bright green
					Title = 'Grumbles', -- Optional. Allows you to have a custom color picker title (when you open it)
					Transparency = 0, -- Optional. Enables transparency changing for this color picker (leave as nil to disable)

					Callback = function(Value)
						grumblecolor = Value
					end
				})
				Toggles.ToggleMouseESP:AddColorPicker('ColorPickerMouse', {
					Default = louiecolor, -- Bright green
					Title = 'Louie [Mouse]', -- Optional. Allows you to have a custom color picker title (when you open it)
					Transparency = 0, -- Optional. Enables transparency changing for this color picker (leave as nil to disable)

					Callback = function(Value)
						louiecolor = Value
					end
				})
				LeftGroupBox2:AddDivider()
				LeftGroupBox2:AddToggle("MinecartPathVisualiser", {
					Text = "Show Seek Path [Mines]",
					Default = false,
					Tooltip = 'Shows you the correct way to go in the first Seek Chase'
				})
				Toggles.MinecartPathVisualiser:AddColorPicker('SeekNodeColor', {
					Default = Color3.fromRGB(0,255,0), -- Bright green
					Title = nil, -- Optional. Allows you to have a custom color picker title (when you open it)
					Transparency = 0, -- Optional. Enables transparency changing for this color picker (leave as nil to disable)


				})
				LeftGroupBox2:AddToggle("TheMinesAnticheatBypass", {
					Text = "Anticheat Bypass [Mines]",
					Default = false,
					Tooltip = 'Enabled the Ladder Anticheat Bypass [The Mines only].'
				})

				if Floor == "Mines" then
					Toggles.TheMinesAnticheatBypass:OnChanged(function(value)
						MinesBypass = value
						if value then



							Notify({
								Title = "Anticheat bypass",
								Description = "Get on a ladder to bypass the Anticheat.",


							})
							Sound()
						else
							RemotesFolder:WaitForChild("ClimbLadder"):FireServer()



							-- Ladder ESP


						end
					end)
					Toggles.ToggleLadderESP:OnChanged(function(value)

						if value then







							-- Ladder ESP
							for _, v in pairs(workspace.CurrentRooms:GetDescendants()) do
								if v:IsA("Model") and v.Name == "Ladder" then
									esp(v,v.PrimaryPart,"Ladder", laddercolor,true,false)
								end
							end

						end
					end)

					Toggles.AntiGloomEgg:OnChanged(function(value)
						for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
							for _, gloomPile in pairs(room:GetChildren()) do
								if gloomPile.Name == "GloomPile" then
									for _, gloomEgg in pairs(gloomPile:GetDescendants()) do
										if gloomEgg.Name == "Egg" then
											gloomEgg.CanTouch = not value
										end
									end
								end
							end
						end
					end)


					local Bridges = {}
					Toggles.AntiSeekObstructions:OnChanged(function(value)
						if value then
							for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
								if not room:FindFirstChild("Parts") then continue end

								for _, bridge in pairs(room.Parts:GetChildren()) do
									if bridge.Name == "Bridge" then
										for _, barrier in pairs(bridge:GetChildren()) do
											if not (barrier.Name == "PlayerBarrier" and barrier.Size.Y == 2.75 and (barrier.Rotation.X == 0 or barrier.Rotation.X == 180)) then continue end

											local clone = barrier:Clone()
											clone.CFrame = clone.CFrame * CFrame.new(0, 0, -5)
											clone.Color = Color3.new(0, 0.666667, 1)
											clone.Name = ESPLibrary:GenerateRandomString()
											clone.Size = Vector3.new(clone.Size.X, clone.Size.Y, 11)
											clone.Transparency = 0.5
											clone.Parent = bridge
											table.insert(Bridges, clone)
										end
									end
								end
							end
						else
							for _, bridge in pairs(Bridges) do
								bridge:Destroy()
							end
						end
					end)
					local Pipes = {}
					

					Toggles.AntiGiggle:OnChanged(function(value)
						for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
							for _, giggle in pairs(room:GetChildren()) do
								if giggle.Name == "GiggleCeiling" then
									giggle:WaitForChild("Hitbox", 5).CanTouch = not value
								end
							end
						end
					end)
					Toggles.AntiSeekFlood:OnChanged(function(value)
						local room = workspace.CurrentRooms:FindFirstChild("100")

						if room and room:FindFirstChild("_DamHandler") then
							local seekFlood = room._DamHandler:FindFirstChild("SeekFloodline")
							if seekFlood then
								seekFlood.CanCollide = value
							end
						end
					end)
					game.Workspace.CurrentRooms.ChildAdded:Connect(function(child)


						if child.Name == "100" and child:FindFirstChild("_DamHandler") then
							local seekFlood = child._DamHandler:FindFirstChild("SeekFloodline")
							if seekFlood then
								seekFlood.CanCollide = Toggles.AntiSeekFlood.Value
							end
						end
						if Toggles.AntiGloomEgg.Value then
							for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
								for _, gloomPile in pairs(room:GetChildren()) do
									if gloomPile.Name == "GloomPile" then
										for _, gloomEgg in pairs(gloomPile:GetDescendants()) do
											if gloomEgg.Name == "Egg" then
												gloomEgg.CanTouch = not Toggles.AntiGloomEgg.Value
											end
										end
									end
								end
							end
						end
						game.Workspace.CurrentRooms.ChildAdded:Wait()
						for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
							for _, giggle in pairs(room:GetChildren()) do
								if giggle.Name == "GiggleCeiling" then
									giggle:WaitForChild("Hitbox", 5).CanTouch = not Toggles.AntiGiggle.Value
								end
							end
						end

						if Toggles.AntiGloomEgg.Value then
							for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
								for _, gloomPile in pairs(room:GetChildren()) do
									if gloomPile.Name == "GloomPile" then
										for _, gloomEgg in pairs(gloomPile:GetDescendants()) do
											if gloomEgg.Name == "Egg" then
												gloomEgg.CanTouch = not Toggles.AntiGloomEgg.Value
											end
										end
									end
								end
							end
						end
						if Toggles.AntiSeekObstructions.Value then
							for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
								if not room:FindFirstChild("Parts") then continue end

								for _, bridge in pairs(room.Parts:GetChildren()) do
									if bridge.Name == "Bridge" then
										for _, barrier in pairs(bridge:GetChildren()) do
											if not (barrier.Name == "PlayerBarrier" and barrier.Size.Y == 2.75 and (barrier.Rotation.X == 0 or barrier.Rotation.X == 180)) then continue end

											local clone = barrier:Clone()
											clone.CFrame = clone.CFrame * CFrame.new(0, 0, -5)
											clone.Color = Color3.new(0.333333, 1, 0)
											clone.Name = ESPLibrary:GenerateRandomString()
											clone.Size = Vector3.new(clone.Size.X, clone.Size.Y, 11)
											clone.Transparency = 0.5
											clone.Parent = bridge

											table.insert(Bridges, clone)
										end
									end
								end
							end
						else
							for _, bridge in pairs(Bridges) do
								bridge:Destroy()
							end
						end
						local room = workspace.CurrentRooms:FindFirstChild("100")

						if room then
							local seekFlood = room._DamHandler
							if seekFlood then
								for i,part in pairs(seekFlood:GetDescendants()) do
							
								seekFlood.CanTouch = not Toggles.AntiSeekFlood.Value
								end
								end
						end
					end)
				end









				local function Pathfinde(room)
					if Floor == "Mines" and #PathfindingFolder:GetChildren() == 0 then
						if Toggles.MinecartPathVisualiser.Value then
							if tonumber(room.Name) >= 43 and tonumber(room.Name) <= 49 or tonumber(room.Name) >= 77 and tonumber(room.Name) <= 83 then

								PathfindFunctions:DrawNodes(room)
							end
						end
					end
				end
			end
			local cooldown = false
			game["Run Service"].RenderStepped:Connect(function()
				if cooldown == false and Toggles.MinecartPathVisualiser then
					cooldown = true

					if Toggles.MinecartPathVisualiser.Value then
						PathfindFunctions:DrawNodes(game.Workspace.CurrentRooms[CurrentRoom])

					else
						PathfindingFolder:ClearAllChildren()
					end
					task.wait(0.1)
					cooldown = false
				end
			end)




			LeftGroupBox4:AddButton({
				Text = 'Kill Character',
				Func = function()
					if RemotesFolder:FindFirstChild("Underwater") then
						RemotesFolder.Underwater:FireServer(true)
					end
				end,
				DoubleClick = false,
				Tooltip = 'Kills your character [takes 15 seconds to work].'
			})
			LeftGroupBox4:AddButton({
				Text = 'Play Again',
				Func = function()
					PlayAgain()
				end,
				DoubleClick = true,
				Tooltip = 'Join a new match'
			})
			LeftGroupBox4:AddButton({
				Text = 'Return To Lobby',
				Func = function()
					RemotesFolder.Lobby:FireServer()
				end,
				DoubleClick = true,
				Tooltip = 'Return to the Main Lobby'
			})



			LeftGroupBox11:AddButton({
				Text = 'Infinite Yield',
				Func = function()
					loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
				end,
				DoubleClick = false,
				Tooltip = 'Executes the Infinite Yield Admin Script'
			})
			LeftGroupBox11:AddButton({
				Text = 'Dex Explorer',
				Func = function()
					loadstring(game:HttpGet('https://pastebin.com/raw/vmNjF3fZ'))()
				end,
				DoubleClick = false,
				Tooltip = 'Executes the Dex Explorer Script'
			})

			RightGroupBox:AddToggle('Toggle7', {
				Text = 'Instant Interact',
				Default = false, -- Default value (true / false)
				Tooltip = 'Make all prompts instant.', -- Information shown when you hover over the toggle

				Callback = function(Value)
					interact = Value
				end
			})


			RightGroupBox:AddToggle('Toggle9', {
				Text = 'Prompt Clip',
				Default = false, -- Default value (true / false)
				Tooltip = 'Allows you to trigger prompts through walls.', -- Information shown when you hover over the toggle

				Callback = function(Value)
					ito = Value
				end
			})
			RightGroupBox:AddToggle('Toggle8', {
				Text = 'Prompt Reach',
				Default = false, -- Default value (true / false)
				Tooltip = 'Allows prompts to be triggered from further away', -- Information shown when you hover over the toggle

				Callback = function(Value)
					maxinteract = Value
				end
			})
			RightGroupBox:AddSlider('ReachDistance', {
				Text = 'Max Distance',
				Default = 7.5,
				Min = 7.5,
				Max = 14.5,
				Rounding = 1,
				Compact = false,

				Callback = function(Value)
					ReachDistance = Value


				end
			})
			Automation:AddToggle('AA', {
				Text = 'Auto Interact',
				Default = false, -- Default value (true / false)
				Tooltip = 'Automatically trigger prompts.', -- Information shown when you hover over the toggle

				Callback = function(Value)

					AA = Value

				end
			}):AddKeyPicker('AutoInteract', {


				Default = 'R', -- String as the name of the keybind (MB1, MB2 for mouse buttons)
				SyncToggleState = true,


				-- You can define custom Modes but I have never had a use for it.
				Mode = 'Hold', -- Modes: Always, Toggle, Hold

				Text = 'Auto Interact', -- Text to display in the keybind menu
				NoUI = false, -- Set to true if you want to hide from the Keybind menu,

				-- Occurs when the keybind is clicked, Value is `true`/`false`
				Callback = function(Value)

				end,

				-- Occurs when the keybind itself is changed, `New` is a KeyCode Enum OR a UserInputType Enum
				ChangedCallback = function(New)
				end
			})

			Automation:AddToggle('AutoBreaker', {
				Text = 'Auto Breaker Puzzle',
				Default = false, -- Default value (true / false)
				Tooltip = "Automatically solves the Breaker Minigame", -- Information shown when you hover over the toggle

				Callback = function(Value)
					AutoBreaker = Value
					if Value == true and CurrentRoom == 100 then
						for i,e in pairs(game.Workspace:GetDescendants()) do
							if e.Name == "ElevatorBreaker" then
								SolveBreakerBox(e)
							end
						end
					end
				end
			})
			Automation:AddDivider()
			Automation:AddToggle('AutoLibrary', {
				Text = 'Auto Library Code',
				Default = false, -- Default value (true / false)
				Tooltip = "Automatically solves the code for door 50", -- Information shown when you hover over the toggle

				Callback = function(Value)
					AutoLibrary = Value
				end
			})
			Automation:AddToggle('AutoUnlockPadlock', {
				Text = 'Auto Unlock Padlock',
				Default = false, -- Default value (true / false)
				Tooltip = "Automatically unlock the library padlock when closer than the provided distance.", -- Information shown when you hover over the toggle


			})
			Automation:AddSlider('AutoUnlockPadlockDistance', {
				Text = 'Unlock Distance',
				Default = 35,
				Min = 10,
				Max = 75,
				Rounding = 0,
				Compact = false,

				Callback = function(Value)
					AutoLibraryUnlockDistance = Value

				end
			})
			Automation:AddDivider()




			Remove:AddToggle('AntiScreech', {
				Text = 'Remove Screech',
				Default = false, -- Default value (true / false)
				Tooltip = 'Prevent Screech from spawning', -- Information shown when you hover over the toggle

				Callback = function(Value)
					AntiScreech = Value
					if Value == true then
						Screech.Name = "Screech_"
					else
						Screech.Name = "Screech"
					end
				end
			})
			Remove:AddToggle('AntiHalt', {
				Text = 'Remove Halt',
				Default = false, -- Default value (true / false)
				Tooltip = 'Removed Halt from the Halt Room.', -- Information shown when you hover over the toggle

				Callback = function(Value)
					if Value == true then
						Halt.Name = "Shade_"
					else
						Halt.Name = "Shade"
					end
				end
			})
			Remove:AddToggle('AntiDread', {
				Text = 'Remove Dread',
				Default = false, -- Default value (true / false)
				Tooltip = 'Prevents dread from spawning, allowing you to say in rooms\nfor as long as you want.', -- Information shown when you hover over the toggle
				Callback = function(Value)
					if Value == true then
						Dread.Name = "Dread_"
					else
						Dread.Name = "Dread"
					end
				end
			})

			Anti:AddToggle('AntiEyes', {
				Text = 'Anti-Eyes',
				Default = false, -- Default value (true / false)
				Tooltip = 'Allows you to look at The Eyes without taking damage.', -- Information shown when you hover over the toggle

				Callback = function(Value)
					AntiEyes = Value
				end
			})
			Anti:AddToggle('AntiSeekObstructions', {
				Text = 'Anti-Seek [Obstrctions]',
				Default = false, -- Default value (true / false)
				Tooltip = "Prevents Seek's Arms and the fallen chaneliers in Seek\nchases [Floor 1] from hurting you", -- Information shown when you hover over the toggle

				Callback = function(Value)
					AntiSeekObstructions = Value
					for i,e in pairs(game.Workspace:GetDescendants()) do
						if e.Name == "Seek_Arm" then
							for i,a in pairs(e.Parent:GetDescendants()) do
								if a:IsA("BasePart") then
									a.CanTouch = false
								end
							end
						end
					end
				end
			})
			Anti:AddToggle('AntiSnare', {
				Text = 'Anti-Snare',
				Default = false, -- Default value (true / false)
				Tooltip = 'Allows you to step on Snares without triggering them', -- Information shown when you hover over the toggle

				Callback = function(Value)
					AntiSnare = Value
					if Value == true then
						Notify({Title = "WARNING",Description = "Snares in the prevoius and next room MAY be able to hurt you.",Reason = "All Snares afterwards are harmless."})
						Sound()
						for i,room in pairs(game.Workspace.CurrentRooms:GetChildren()) do
							if room:FindFirstChild("Assets") then
								for i,e in pairs(room.Assets:GetChildren()) do
									if e.Name == "Snare" then


									
											if e:FindFirstChild("Hitbox") then
												e.Hitbox.CanTouch = false
												if e.Hitbox:FindFirstChild("TouchInterest") then
													e.Hitbox.TouchInterest:Destroy()
												end
											end
										









										
									end
								end
							end
						end
					end
				end
			})
			Anti:AddToggle('AntiDupe', {
				Text = 'Anti-Dupe',
				Default = false, -- Default value (true / false)
				Tooltip = 'Prevents you from opening Dupe [Fake] doors.', -- Information shown when you hover over the toggle

				Callback = function(Value)
					AntiDupe = Value
					if Value == true then
						for i,e in pairs(game.Workspace:GetDescendants()) do
							if e.Name == "DoorFake" or e.Name == "FakeDoor" then
								DisableDupe(e)
							end


						end
					end
				end
			})
			Anti:AddDivider()
			VisualsRemove:AddToggle('NoHidingVegnette', {
				Text = 'No Hiding Vigenette',
				Default = false, -- Default value (true / false)
				Tooltip = 'Removes the Hiding screen effect', -- Information shown when you hover over the toggle

				Callback = function(Value)
					RemoveHideVignette = Value
				end
			})
			VisualsRemove:AddToggle('AntiGlitch', {
				Text = 'No Glitch Jumpscare',
				Default = false, -- Default value (true / false)
				Tooltip = "Removes Glitch's Screen Effects", -- Information shown when you hover over the toggle

				Callback = function(Value)
					if Value == true then
						Glitch.Name = "Glitch_"
					else
						Glitch.Name = "Glitch"
					end
				end
			})
			VisualsRemove:AddToggle('AntiVoid', {
				Text = 'No Void Jumpscare',
				Default = false, -- Default value (true / false)
				Tooltip = "Removes Void's Screen Effects", -- Information shown when you hover over the toggle

				Callback = function(Value)
					if Value == true then
						Void.Name = "Void_"
					else
						Void.Name = "Void"
					end
				end
			})
			VisualsRemove:AddToggle('AntiTimothy', {
				Text = 'No Timothy Jumpscare',
				Default = false, -- Default value (true / false)
				Tooltip = "Removes Timothy the Spider's jumpscare", -- Information shown when you hover over the toggle

				Callback = function(Value)
					if Value == true then
						Timothy.Name = "SpiderJumpscare_"
					else
						Timothy.Name = "SpiderJumpscare"
					end
				end
			})
			LeftGroupBox6:AddDropdown('NotifyMonsters', {
				Values = {"Rush","Ambush","Blitz","Eyes","Lookman","Jeff The Killer","A-60","A-120","Giggle","Gloombat Swarm","Halt"},
				Default = 0, -- number index of the value / string
				Multi = true, -- true / false, allows multiple choices to be selected

				Text = 'Notify Entities',
				Tooltip = 'Select which Entities should notify you when they spawn', -- Information shown when you hover over the dropdown


			})
			LeftGroupBox6:AddDivider()
			LeftGroupBox6:AddToggle('notif', {
				Text = 'Play Sound',
				Default = true, -- Default value (true / false)
				Tooltip = 'Play a ping sound, alerting you to notifications', -- Information shown when you hover over the toggle

				Callback = function(Value)
					notif = Value
				end
			});
			local pingtype = "New"

			LeftGroupBox6:AddDropdown('Dropdown9', {
				Values = {'New','Old','Custom'},
				Default = 2, -- number index of the value / string
				Multi = false, -- true / false, allows multiple choices to be selected

				Text = 'Ping Sound',
				Tooltip = 'Select the ping sound', -- Information shown when you hover over the dropdown

				Callback = function(Value)
					pingtype = Value
					if Value == "New" then
						pingid = 4590662766
					elseif Value == "Old" then
						pingid = 4590657391
					else
						pingid = pingidcustom
					end
				end
			})
			LeftGroupBox6:AddDivider()



			LeftGroupBox6:AddInput('PingID', {
				Default = '',
				Numeric = true, -- true / false, only allows numbers
				Finished = false, -- true / false, only calls callback when you press enter

				Text = 'Custom Sound ID',
				Tooltip = 'Set a custom ping sound ID', -- Information shown when you hover over the textbox

				Placeholder = 'Enter Sound ID Here', -- placeholder text when the box is empty
				-- MaxLength is also an option which is the max length of the text

				Callback = function(Value)
					pingidcustom = Value
					if pingtype == "Custom" then
						pingid = pingidcustom
					end
				end
			})
			LeftGroupBox6:AddSlider('AlertVolume', {
				Text = 'Sound Volume',
				Default = 3.0,
				Min = 0.5,
				Max = 5.0,
				Rounding = 1,
				Compact = false,

				Callback = function(Value)
					notifvolume = Value

				end
			})

			LeftGroupBox6:AddDropdown('Dropdown1', {
				Values = {'Linora','Doors','STX'},
				Default = 1, -- number index of the value / string
				Multi = false, -- true / false, allows multiple choices to be selected

				Text = 'Notification Style',
				Tooltip = 'Select how the notifications should appear', -- Information shown when you hover over the dropdown

				Callback = function(Value)
					NotifyType = Value
				end
			})
			LeftGroupBox6:AddDropdown('Dropdown2', {
				Values = {'Left','Right'},
				Default = (if Library.IsMobile then 2 else 1), -- number index of the value / string
				Multi = false, -- true / false, allows multiple choices to be selected

				Text = 'Linora Notification Side',
				Tooltip = 'Select which side notifications should appear on, if\nthe Linora Notification Style is selected.', -- Information shown when you hover over the dropdown

				Callback = function(Value)
					Library.NotifySide = Value
				end
			})
			LeftGroupBox6:AddButton({
				Text = 'Test Notification',
				Func = function()
					Notify({Title = "Test Notification",Description = "This is a test notification."})
					Sound()
				end,
				DoubleClick = false,
				Tooltip = 'Send a Notifcation to test your Settings'
			})



			LeftGroupBox:AddSlider('WS', {
				Text = 'Speed Boost',
				Default = 0,
				Min = 0,
				Max = 6,
				Rounding = 0,
				Compact = false,

				Callback = function(Value)
					SpeedBoost = Value


				end
			})
			LeftGroupBox:AddToggle('WSToggle', {
				Text = 'Enable Speed Boost',
				Default = false, -- Default value (true / false)
				Tooltip = 'Enables Increased movement speed', -- Information shown when you hover over the toggle

				Callback = function(Value)
					SpeedBoostEnabled = Value
				end
			})
			LeftGroupBox:AddDivider()


			LeftGroupBox9:AddToggle('ToggleAmbience', {
				Text = 'Ambience',
				Default = false, -- Default value (true / false)
				Tooltip = 'Enables the Ambience Color to be the selected Color', -- Information shown when you hover over the toggle
				Callback = function(Value)
					fb = Value
				end,
			}):AddColorPicker('Ambience',{
				Default = Color3.fromRGB(255,255,255),
				Title = "Ambience",
				Transparency = 0,
				Callback = function(Value)
					Ambience = Value
				end,
			})



			LeftGroupBox9:AddDivider()
			LeftGroupBox9:AddSlider('FOV', {
				Text = 'FOV',
				Default = 70,
				Min = 70,
				Max = 120,
				Rounding = 0,
				Compact = false,

				Callback = function(value)

					fov = value


				end
			})
			LeftGroupBox9:AddToggle("EnableFOV",{
				Text = "Enable FOV",
				Default = false,
				Tooltip = 'Enables the Field Of View changer',
				Callback = function(Value)
					EnableFOV = Value
				end,
			})
			LeftGroupBox2:AddToggle('SpeedBypass', {
				Text = 'Speed Bypass',
				Default = false, -- Default value (true / false)
				Tooltip = 'Bypasses the Speed Anticheat, allowing you to walk muchfaster',
				Callback = function(Value)
					SpeedBypassEnabled = Value
					if Value == true then
						if not Toggles.AutoRoomsIgnoreA60.Value or Floor ~= "Rooms" then
							Options.WS:SetMax(60)
						end
						SpeedBypass()

					else
						Options.WS:SetMax(6)
						if SpeedBoost > 6 then
							Options.WS:SetValue(6)
						end
						task.wait(0.25)
						CollisionClone.Massless = true


					end
				end,
			})
			LeftGroupBox2:AddSlider('BypassCooldown', {
				Text = 'Speed Bypass Delay',
				Default = 0.22,
				Min = 0.22,
				Max = 0.25,
				Rounding = 3,
				Compact = false,

				Callback = function(Value)
					bypassdelay = Value

				end
			})
			LeftGroupBox2:AddDivider()
			LeftGroupBox2:AddToggle('Toggle250', {
				Text = 'Godmode',
				Default = false, -- Default value (true / false)
				Tooltip = 'Prevents Entities like Rush from killing you\nWARNING: Do not use fly or noclip while using godmode.', -- Information shown when you hover over the toggle

				Callback = function(Value)

					godmode = Value


					if Value == false then


						task.wait(0.1)
						Collision.Position = HumanoidRootPart.Position Vector3.new(0, 0, 0)
					end
				end



			}):AddKeyPicker('Keybind3', {


				Default = 'G', -- String as the name of the keybind (MB1, MB2 for mouse buttons)
				SyncToggleState = true,


				-- You can define custom Modes but I have never had a use for it.
				Mode = 'Toggle', -- Modes: Always, Toggle, Hold

				Text = 'Godmode', -- Text to display in the keybind menu
				NoUI = false, -- Set to true if you want to hide from the Keybind menu,

				-- Occurs when the keybind is clicked, Value is `true`/`false`
				Callback = function(Value)


				end,

				-- Occurs when the keybind itself is changed, `New` is a KeyCode Enum OR a UserInputType Enum
				ChangedCallback = function(New)
				end
			})
			LeftGroupBox2:AddToggle('ACM', {
				Text = 'Anticheat Manipulation',
				Default = false, -- Default value (true / false)
				Tooltip = 'Flings your character forwards, tricking the anticheat into teleporting\nyou slightly forwards.', -- Information shown when you hover over the toggle

				Callback = function(Value)


				end

			}):AddKeyPicker('AnticheatManipulation', {


				Default = 'V', -- String as the name of the keybind (MB1, MB2 for mouse buttons)
				SyncToggleState = true,


				-- You can define custom Modes but I have never had a use for it.
				Mode = 'Hold', -- Modes: Always, Toggle, Hold

				Text = 'Anticheat Manipulation', -- Text to display in the keybind menu
				NoUI = false, -- Set to true if you want to hide from the Keybind menu,

				-- Occurs when the keybind is clicked, Value is `true`/`false`
				Callback = function(Value)


				end,

				-- Occurs when the keybind itself is changed, `New` is a KeyCode Enum OR a UserInputType Enum
				ChangedCallback = function(New)
				end
			})

			EntityAlliasesTab:AddLabel('Set custom Names for Entities')
			EntityAlliasesTab:AddDivider()
			EntityAlliasesTab:AddInput('CustomRushAlias', {
				Default = 'Rush',
				Numeric = false, -- true / false, only allows numbers
				Finished = true, -- true / false, only calls callback when you press enter

				Text = 'Rush',
				Tooltip = nil, -- Information shown when you hover over the textbox

				Placeholder = 'Enter Alias Here', -- placeholder text when the box is empty
				-- MaxLength is also an option which is the max length of the text

				Callback = function(Value)
					EntityAlliases["RushMoving"] = Value



				end
			})

			EntityAlliasesTab:AddInput('CustomAmbushAlias', {
				Default = 'Ambush',
				Numeric = false, -- true / false, only allows numbers
				Finished = true, -- true / false, only calls callback when you press enter

				Text = 'Ambush',
				Tooltip = nil, -- Information shown when you hover over the textbox

				Placeholder = 'Enter Alias Here', -- placeholder text when the box is empty
				-- MaxLength is also an option which is the max length of the text

				Callback = function(Value)
					EntityAlliases["AmbushMoving"] = Value



				end
			})
			EntityAlliasesTab:AddInput('CustomEyesAlias', {
				Default = 'Eyes',
				Numeric = false, -- true / false, only allows numbers
				Finished = true, -- true / false, only calls callback when you press enter

				Text = 'Eyes',
				Tooltip = nil, -- Information shown when you hover over the textbox

				Placeholder = 'Enter Alias Here', -- placeholder text when the box is empty
				-- MaxLength is also an option which is the max length of the text

				Callback = function(Value)
					EntityAlliases["Eyes"] = Value



				end
			})

			EntityAlliasesTab:AddInput('CustomBlitzAlias', {
				Default = 'Blitz',
				Numeric = false, -- true / false, only allows numbers
				Finished = true, -- true / false, only calls callback when you press enter

				Text = 'Blitz',
				Tooltip = nil, -- Information shown when you hover over the textbox

				Placeholder = 'Enter Alias Here', -- placeholder text when the box is empty
				-- MaxLength is also an option which is the max length of the text

				Callback = function(Value)
					EntityAlliases["BackdoorRush"] = Value



				end
			})
			EntityAlliasesTab:AddInput('CustomLookmanAlias', {
				Default = 'Lookman',
				Numeric = false, -- true / false, only allows numbers
				Finished = true, -- true / false, only calls callback when you press enter

				Text = 'Lookman',
				Tooltip = nil, -- Information shown when you hover over the textbox

				Placeholder = 'Enter Alias Here', -- placeholder text when the box is empty
				-- MaxLength is also an option which is the max length of the text

				Callback = function(Value)
					EntityAlliases["BackdoorLookman"] = Value



				end
			})
			EntityAlliasesTab:AddInput('CustomA60Alias', {
				Default = 'A-60',
				Numeric = false, -- true / false, only allows numbers
				Finished = true, -- true / false, only calls callback when you press enter

				Text = 'A-60',
				Tooltip = nil, -- Information shown when you hover over the textbox

				Placeholder = 'Enter Alias Here', -- placeholder text when the box is empty
				-- MaxLength is also an option which is the max length of the text

				Callback = function(Value)
					EntityAlliases["A60"] = Value



				end
			})

			EntityAlliasesTab:AddInput('CustomA120Alias', {
				Default = 'A-120',
				Numeric = false, -- true / false, only allows numbers
				Finished = true, -- true / false, only calls callback when you press enter

				Text = 'A-120',
				Tooltip = nil, -- Information shown when you hover over the textbox

				Placeholder = 'Enter Alias Here', -- placeholder text when the box is empty
				-- MaxLength is also an option which is the max length of the text

				Callback = function(Value)
					EntityAlliases["A120"] = Value



				end
			})

			EntityAlliasesTab:AddInput('CustomJeffAlias', {
				Default = 'Jeff',
				Numeric = false, -- true / false, only allows numbers
				Finished = true, -- true / false, only calls callback when you press enter

				Text = 'Jeff The Killer',
				Tooltip = nil, -- Information shown when you hover over the textbox

				Placeholder = 'Enter Alias Here', -- placeholder text when the box is empty
				-- MaxLength is also an option which is the max length of the text

				Callback = function(Value)
					EntityAlliases["Jeff"] = Value



				end
			})
			EntityAlliasesTab:AddInput('CustomGiggleAlias', {
				Default = 'Giggle',
				Numeric = false, -- true / false, only allows numbers
				Finished = true, -- true / false, only calls callback when you press enter

				Text = 'Giggle',
				Tooltip = nil, -- Information shown when you hover over the textbox

				Placeholder = 'Enter Alias Here', -- placeholder text when the box is empty
				-- MaxLength is also an option which is the max length of the text

				Callback = function(Value)
					EntityAlliases["Giggle"] = Value



				end
			})
			EntityAlliasesTab:AddInput('CustomGloombatsAlias', {
				Default = 'Gloombat Swarm',
				Numeric = false, -- true / false, only allows numbers
				Finished = true, -- true / false, only calls callback when you press enter

				Text = 'Gloombat Swarm',
				Tooltip = nil, -- Information shown when you hover over the textbox

				Placeholder = 'Enter Alias Here', -- placeholder text when the box is empty
				-- MaxLength is also an option which is the max length of the text

				Callback = function(Value)
					EntityAlliases["Gloombats"] = Value



				end
			})

			EntityAlliasesTab:AddInput('CustomHaltAlias', {
				Default = 'Halt',
				Numeric = false, -- true / false, only allows numbers
				Finished = true, -- true / false, only calls callback when you press enter

				Text = 'Halt',
				Tooltip = nil, -- Information shown when you hover over the textbox

				Placeholder = 'Enter Alias Here', -- placeholder text when the box is empty
				-- MaxLength is also an option which is the max length of the text

				Callback = function(Value)
					EntityAlliases["Halt"] = Value



				end
			})


			CharacterTab:AddToggle('Noclip', {
				Text = 'Noclip',
				Default = false, -- Default value (true / false)
				Tooltip = 'Disables collisions, allowing you to walk through objects', -- Information shown when you hover over the toggle

				Callback = function(Value)
					togglenoclip(Value)
				end

			}):AddKeyPicker('Keybind3', {


				Default = 'N', -- String as the name of the keybind (MB1, MB2 for mouse buttons)
				SyncToggleState = true,


				-- You can define custom Modes but I have never had a use for it.
				Mode = 'Toggle', -- Modes: Always, Toggle, Hold

				Text = 'Noclip', -- Text to display in the keybind menu
				NoUI = false, -- Set to true if you want to hide from the Keybind menu,

				-- Occurs when the keybind is clicked, Value is `true`/`false`
				Callback = function(Value)



				end,

				-- Occurs when the keybind itself is changed, `New` is a KeyCode Enum OR a UserInputType Enum
				ChangedCallback = function(New)
				end
			})
			CharacterTab:AddToggle('NoclipBypass', {
				Text = 'Noclip Bypass',
				Default = false, -- Default value (true / false)
				Tooltip = 'Use Anticheat Manipulation to bypass the Noclip Anticheat', -- Information shown when you hover over the toggle


			})
			CharacterTab:AddDivider()
			
			OldPhysics = HumanoidRootPart.CustomPhysicalProperties
			CharacterTab:AddToggle('NoAccell', {
				Text = 'No Acceleration',
				Default = false, -- Default value (true / false)
				Tooltip = 'Prevents your character from sliding due to high walkspeed.', -- Information shown when you hover over the toggle

				Callback = function(Value)
					NA = Value

					for i,part in pairs(Character:GetDescendants()) do
						if part:IsA("BasePart") then

							if Value == true then
								part.CustomPhysicalProperties = CustomPhysicalProperties
							else
								part.CustomPhysicalProperties = OldPhysics
							end
						end
					end
				end
			})
			local NAC = Player.CharacterAdded:Connect(function(NewCharacter)
				if Toggles.NoAccell.Value then
					for i,part in pairs(NewCharacter:GetDescendants()) do
						if part:IsA("BasePart") then


							part.CustomPhysicalProperties = CustomPhysicalProperties

						end
					end
				end
			end)
			LeftGroupBox:AddToggle('Jump', {
				Text = 'Enable Jump',
				Default = false, -- Default value (true / false)
				Tooltip = 'Allows your character to jump.', -- Information shown when you hover over the toggle

				Callback = function(Value)
					game.Players.LocalPlayer.Character:SetAttribute("CanJump",Value)
					JumpBoost = 5 + Options.JumpBoost.Value
				end
			})
			LeftGroupBox:AddSlider('JumpBoost', {
				Text = 'Jump Boost',
				Default = 0,
				Min = 0,
				Max = 50,
				Rounding = 0,
				Compact = false,

				Callback = function(Value)
					JumpBoost = 5 + Value


				end
			})


			CharacterTab:AddToggle('DoorReach', {
				Text = 'Door Reach',
				Default = false, -- Default value (true / false)
				Tooltip = 'Open Doors from much further away', -- Information shown when you hover over the toggle

				Callback = function(Value)
					DoorReach = Value
				end
			})
			LeftGroupBox2:AddToggle('AntiFH', {
				Text = 'Crouch Spoof',
				Default = false, -- Default value (true / false)
				Tooltip = 'Makes the game think you are always crouching [Useful for Figure].', -- Information shown when you hover over the toggle

				Callback = function(Value)
					AntiFH = Value
				end
			})
			CharacterTab:AddDivider()
			CharacterTab:AddToggle('TransparentCloset', {
				Text = 'Transparent Closets',
				Default = false, -- Default value (true / false)
				Tooltip = 'Makes the current Hiding Spot transparent', -- Information shown when you hover over the toggle

				Callback = function(Value)
					TransparentCloset = Value
				end
			})
			CharacterTab:AddSlider("HidingTransparency",{
				Text = "Transparency",
				Default = 0.5,
				Min = 0,
				Max = 1,
				Rounding = 2,
				Callback = function(Value)
					TransparentClosetNumber = Value
				end,
			})
			LeftGroupBox9:AddDivider()
			LeftGroupBox9:AddToggle('Toggle50', {
				Text = 'Third Person',
				Default = false, -- Default value (true / false)
				Tooltip = 'Zooms your camera out to be able to see your Character', -- Information shown when you hover over the toggle

				Callback = function(Value)
					thirdp = Value
				end
			}):AddKeyPicker('Keybind5', {


				Default = 'T', -- String as the name of the keybind (MB1, MB2 for mouse buttons)
				SyncToggleState = true,


				-- You can define custom Modes but I have never had a use for it.
				Mode = 'Toggle', -- Modes: Always, Toggle, Hold

				Text = 'Third Person', -- Text to display in the keybind menu
				NoUI = false, -- Set to true if you want to hide from the Keybind menu,

				-- Occurs when the keybind is clicked, Value is `true`/`false`
				Callback = function(Value)
					thirdp = Value

				end,

				-- Occurs when the keybind itself is changed, `New` is a KeyCode Enum OR a UserInputType Enum
				ChangedCallback = function(New)
				end
			})
			LeftGroupBox9:AddSlider('TPX', {
				Text = 'Offset X',
				Default = 0,
				Min = -10,
				Max = 10,
				Rounding = 1,
				Compact = false,

				Callback = function(Value)
					ThirdPersonX = Value

				end
			})
			LeftGroupBox9:AddSlider('TPY', {
				Text = 'Offset Y',
				Default = 0,
				Min = -10,
				Max = 10,
				Rounding = 1,
				Compact = false,

				Callback = function(Value)
					ThirdPersonY = Value

				end
			})
			LeftGroupBox9:AddSlider('TPZ', {
				Text = 'Offset Z',
				Default = 5,
				Min = -10,
				Max = 10,
				Rounding = 1,
				Compact = false,

				Callback = function(Value)
					ThirdPersonZ = Value

				end
			})
			LeftGroupBox:AddDivider()
			LeftGroupBox:AddToggle('Toggle111', {
				Text = 'Fly',
				Default = false, -- Default value (true / false)
				Tooltip = 'Fly freely around the map', -- Information shown when you hover over the toggle

				Callback = function(Value)
					flytoggle = Value
					if flytoggle == true then
						fly.enabled = Value
						fly.flyBody.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart

					else
						fly.flyBody.Parent = nil

					end
				end
			}):AddKeyPicker('Keybind9', {


				Default = 'F', -- String as the name of the keybind (MB1, MB2 for mouse buttons)
				SyncToggleState = true,


				-- You can define custom Modes but I have never had a use for it.
				Mode = 'Toggle', -- Modes: Always, Toggle, Hold

				Text = 'Fly', -- Text to display in the keybind menu
				NoUI = false, -- Set to true if you want to hide from the Keybind menu,

				-- Occurs when the keybind is clicked, Value is `true`/`false`
				Callback = function(Value)
					flytoggle = Value
					if Value == true then 
						game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
					else
						game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
					end
				end,

				-- Occurs when the keybind itself is changed, `New` is a KeyCode Enum OR a UserInputType Enum
				ChangedCallback = function(New)
				end
			})
			LeftGroupBox:AddSlider('Slider9', {
				Text = 'Fly Speed',
				Default = 2,
				Min = 1,
				Max = 10,
				Rounding = 1,
				Compact = false,

				Callback = function(Value)
					flyspeed = Value

				end
			})
			ESP:AddToggle('KeyESP', {
				Text = 'Keys',
				Default = false, -- Default value (true / false)
				Tooltip = 'Highlight all Keys that spawn', -- Information shown when you hover over the toggle

				Callback = function(Value)
					keys = Value
					if Value == true then
						for i,inst in pairs(game.Workspace.CurrentRooms:FindFirstChild(tonumber(Player:GetAttribute("CurrentRoom"))):GetDescendants()) do
							if inst.Name == "KeyObtain" then
								if inst.Hitbox:FindFirstChild("Key") then
									esp(inst,inst.Hitbox.Key,"Door Key".." ["..tonumber(inst:GetAttribute("ParentRoom")+DoorsDifference+1).."]", keycolor,true,false)
								elseif inst.Hitbox:FindFirstChild("KeyHitbox") then
									esp(inst,inst.Hitbox.KeyHitbox,"Door Key".." ["..tonumber(inst:GetAttribute("ParentRoom")+DoorsDifference+1).."]", "KeyColor",true,false)
								end
							end
							if inst.Name == "ElectricalKeyObtain" then
								if inst.Hitbox:FindFirstChild("Key") then
									esp(inst,inst.Hitbox.Key,"Electrical Key", keycolor,true,false)
								elseif inst.Hitbox:FindFirstChild("KeyHitbox") then
									esp(inst,inst.Hitbox.KeyHitbox,"Electrical Key", keycolor,true,false)
								end
							end
						end

						game.Workspace.CurrentRooms.ChildAdded:Wait()
						for i,inst in pairs(game.Workspace.CurrentRooms:FindFirstChild(tonumber(Player:GetAttribute("CurrentRoom"))+1):GetDescendants()) do
							if inst.Name == "KeyObtain" then
								if inst.Hitbox:FindFirstChild("Key") then
									esp(inst,inst.Hitbox.Key,"Door Key".." ["..tonumber(inst:GetAttribute("ParentRoom")+DoorsDifference+1).."]", keycolor,true,false)
								elseif inst.Hitbox:FindFirstChild("KeyHitbox") then
									esp(inst,inst.Hitbox.KeyHitbox,"Door Key".." ["..tonumber(inst:GetAttribute("ParentRoom")+DoorsDifference+1).."]", keycolor,true,false)
								end
							end
							if inst.Name == "ElectricalKeyObtain" then
								if inst.Hitbox:FindFirstChild("Key") then
									esp(inst,inst.Hitbox.Key,"Electrical Key", keycolor,true,false)
								elseif inst.Hitbox:FindFirstChild("KeyHitbox") then
									esp(inst,inst.Hitbox.KeyHitbox,"Electrical Key", keycolor,true,false)
								end
							end
						end
					end
					if Value == false then
						for i,inst in pairs(game.Workspace.CurrentRooms:GetDescendants()) do
							if inst.Name == "KeyObtain" then
								inst:SetAttribute("ESP", false)
							end
						end
					end
				end
			})
			ESP:AddToggle('DoorESP', {
				Text = 'Doors',
				Default = false, -- Default value (true / false)
				Tooltip = 'Highlight all Doors', -- Information shown when you hover over the toggle

				Callback = function(Value)
					doors = Value
					if Value == true then
						for i,inst in pairs(game.Workspace.CurrentRooms:FindFirstChild(tonumber(Player:GetAttribute("CurrentRoom"))):GetDescendants()) do
							if inst.Name == "Door" and inst:FindFirstChild("Door") then
								local doorcount = 0
								local knob = inst.Door:FindFirstChild("Knob") or inst.Door
								if inst.Parent.Name == "49" and Floor == "Hotel" or inst.Parent.Name == "49" and Floor == "Fools" or inst.Parent.Name == "50" and Floor == "Hotel" or inst.Parent.Name == "50" and Floor == "Fools" then

									if inst.Parent:GetAttribute("RequiresKey") == true then
										esp(inst,inst.Hidden,"Door", doorcolor,true,false)
									else
										esp(inst,inst.Hidden,"Door", doorcolor,true,false)
									end
								else

									if inst.Parent:GetAttribute("RequiresKey") == true then

										esp(inst.Door,knob,"Door", doorcolor,true,false)
									else
										esp(inst.Door,knob,"Door", doorcolor,true,false)
									end
								end


							end
						end
						for i,inst in pairs(game.Workspace.CurrentRooms:FindFirstChild(tonumber(Player:GetAttribute("CurrentRoom")) + 1):GetDescendants()) do
							if inst.Name == "Door" and inst:FindFirstChild("Door") then
								local knob = inst.Door:FindFirstChild("Knob") or inst.Door
								if inst.Parent.Name == "49" and Floor == "Hotel" or inst.Parent.Name == "49" and Floor == "Fools" or inst.Parent.Name == "50" and Floor == "Hotel" or inst.Parent.Name == "50" and Floor == "Fools" then

									if inst.Parent:GetAttribute("RequiresKey") == true then
										esp(inst,inst.Hidden,"Door", doorcolor,true,false)
									else
										esp(inst,inst.Hidden,"Door", doorcolor,true,false)
									end
								else

									if inst.Parent:GetAttribute("RequiresKey") == true then

										esp(inst.Door,knob,"Door", doorcolor,true,false)
									else
										esp(inst.Door,knob,"Door", doorcolor,true,false)
									end
								end


							end
						end
						game.Workspace.CurrentRooms.ChildAdded:Wait()
						for i,inst in pairs(game.Workspace.CurrentRooms:FindFirstChild(tonumber(Player:GetAttribute("CurrentRoom")) + 1):GetDescendants()) do
							if inst.Name == "Door" and inst:FindFirstChild("Door") then
								local knob = inst.Door:FindFirstChild("Knob") or inst.Door
								if inst.Parent.Name == "49" and Floor == "Hotel" or inst.Parent.Name == "49" and Floor == "Fools" or inst.Parent.Name == "50" and Floor == "Hotel" or inst.Parent.Name == "50" and Floor == "Fools" then

									if inst.Parent:GetAttribute("RequiresKey") == true then
										esp(inst,inst.Hidden,"Door", doorcolor,true,false)
									else
										esp(inst,inst.Hidden,"Door", doorcolor,true,false)
									end
								else

									if inst.Parent:GetAttribute("RequiresKey") == true then

										esp(inst.Door,knob,"Door", doorcolor,true,false)
									else
										esp(inst.Door,knob,"Door", doorcolor,true,false)
									end
								end

							end
						end
					end

					if Value == false then
						for i,inst in pairs(game.Workspace.CurrentRooms:GetDescendants()) do
							if inst.Name == "Door" then
								inst:SetAttribute("ESP",false)
							end
						end
					end
				end

			})
			ESP:AddToggle('ClosetESP', {
				Text = 'Closets',
				Default = false, -- Default value (true / false)
				Tooltip = 'Highlight all Hiding Spots', -- Information shown when you hover over the toggle

				Callback = function(Value)
					closets = Value
					if Value == true then
						for i,inst in pairs(game.Workspace.CurrentRooms:FindFirstChild(tonumber(Player:GetAttribute("CurrentRoom"))):GetDescendants()) do
							if inst.Name == "Wardrobe" and inst:FindFirstChild("Main") then
								esp(inst,inst.Main,"Closet", closetcolor,true,false)
							end


							if inst.Name == "Backdoor_Wardrobe" and inst:FindFirstChild("Main") then
								esp(inst,inst.Main,"Closet", closetcolor,true,false)
							end

							if inst.Name == "RetroWardrobe" and inst:FindFirstChild("Main") and closets == true
							then
								esp(inst,inst.Main,"Closet", closetcolor,true,false)
							end

							if inst.Name == "Bed" and inst:FindFirstChild("Main") and closets == true
							then
								esp(inst,inst.Main,"Bed", closetcolor,true,false)
							end
							if inst.Name == "Rooms_Locker" and inst:FindFirstChild("Base") then
								esp(inst,inst.Base,"Locker", closetcolor,true,false)
							end
							if inst.Name == "Rooms_Locker_Fridge" and inst:FindFirstChild("Base") then
								esp(inst,inst.Base,"Locker", closetcolor,true,false)
							end


							if inst.Name == "Locker_Large" and inst:FindFirstChild("Main") then
								esp(inst,inst.Main,"Locker", closetcolor,true,false)
							end
						end


						game.Workspace.CurrentRooms.ChildAdded:Wait()
						for i,inst in pairs(game.Workspace.CurrentRooms:FindFirstChild(tonumber(Player:GetAttribute("CurrentRoom")) + 1):GetDescendants()) do
							if inst.Name == "Wardrobe" and inst:FindFirstChild("Main") then
								esp(inst,inst.Main,"Closet", closetcolor,true,false)
							end


							if inst.Name == "Backdoor_Wardrobe" and inst:FindFirstChild("Main") then
								esp(inst,inst.Main,"Closet", closetcolor,true,false)
							end

							if inst.Name == "RetroWardrobe" and inst:FindFirstChild("Main") and closets == true
							then
								esp(inst,inst.Main,"Closet", closetcolor,true,false)
							end

							if inst.Name == "Bed" and inst:FindFirstChild("Main") and closets == true
							then
								esp(inst,inst.Main,"Bed", closetcolor,true,false)
							end


							if inst.Name == "Rooms_Locker" and inst:FindFirstChild("Base") then
								esp(inst,inst.Base,"Locker", closetcolor,true,false)
							end


							if inst.Name == "Rooms_Locker_Fridge" and inst:FindFirstChild("Base") then
								esp(inst,inst.Base,"Locker", closetcolor,true,false)
							end


							if inst.Name == "Locker_Large" and inst:FindFirstChild("Main") then
								esp(inst,inst.Main,"Locker", closetcolor,true,false)
							end
							if inst.Name == "Rooms_Locker_Fridge" and inst:FindFirstChild("Base") then
								esp(inst,inst.Base,"Locker", closetcolor,true,false)
							end
						end
					end
					if Value == false then
						for i,inst in pairs(game.Workspace.CurrentRooms:GetDescendants()) do
							if inst.Name == "Wardrobe" or inst.Name == "Backdoor_Wardrobe" or inst.Name == "Rooms_Locker" or inst.Name == "Rooms_Locker_Fridge" or inst.Name == "Locker_Large" or inst.Name == "RetroWardrobe" or inst.Name == "Bed" then
								inst:SetAttribute("ESP", false)
							end
						end
					end
				end

			})
			ESP:AddToggle('LeverESP', {
				Text = 'Levers',
				Default = false, -- Default value (true / false)
				Tooltip = 'Highlights Basement Levers', -- Information shown when you hover over the toggle

				Callback = function(Value)
					levers = Value
					if Value == true then
						for i,inst in pairs(game.Workspace.CurrentRooms:FindFirstChild(tonumber(Player:GetAttribute("CurrentRoom"))):GetDescendants()) do
							if inst.Name == "LeverForGate" and inst:FindFirstChild("Main") then
								esp(inst,inst.Main,"Gate Lever", levercolor,true,false)
							end
						end
						game.Workspace.CurrentRooms.ChildAdded:Wait()
						for i,inst in pairs(game.Workspace.CurrentRooms:FindFirstChild(tonumber(Player:GetAttribute("CurrentRoom")) + 1):GetDescendants()) do
							if inst.Name == "LeverForGate" and inst:FindFirstChild("Main") then
								esp(inst,inst.Main,"Gate Lever", levercolor,true,false)
							end
						end
					end
					if Value == false then
						for i,inst in pairs(game.Workspace.CurrentRooms:GetDescendants()) do
							if inst.Name == "LeverForGate" then
								inst:SetAttribute("ESP", false)
							end
						end
					end
				end
			})
			ESP:AddToggle('ChestESP', {
				Text = 'Chests',
				Default = false, -- Default value (true / false)
				Tooltip = 'Highlights Chests', -- Information shown when you hover over the toggle

				Callback = function(Value)
					levers = Value
					if Value == true then
						for i,inst in pairs(game.Workspace.CurrentRooms:FindFirstChild(tonumber(Player:GetAttribute("CurrentRoom"))):GetDescendants()) do
							if inst.Name == "ChestBox" and inst:FindFirstChild("Main")  or inst.Name == "ChestBoxLocked" and inst:FindFirstChild("Main")then
								local Text = "Chest"
								if inst:GetAttribute("Locked") == true then
									Text = "Locked Chest"
								end
								esp(inst,inst.Main,Text, chestcolor,true,false)
							end
						end
						game.Workspace.CurrentRooms.ChildAdded:Wait()
						for i,inst in pairs(game.Workspace.CurrentRooms:FindFirstChild(tonumber(Player:GetAttribute("CurrentRoom")) + 1):GetDescendants()) do
							if inst.Name == "ChestBox" and inst:FindFirstChild("Main") or inst.Name == "ChestBoxLocked" and inst:FindFirstChild("Main") then
								local Text = "Chest"
								if inst:GetAttribute("Locked") == true then
									Text = "Locked Chest"
								end
								esp(inst,inst.Main,Text, chestcolor,true,false)
							end
						end
					end
					if Value == false then
						for i,inst in pairs(game.Workspace.CurrentRooms:GetDescendants()) do
							if inst.Name == "ChestBox" or inst.Name == "ChestBoxLocked" then
								inst:SetAttribute("ESP", false)
							end
						end
					end
				end
			})
			ESP:AddToggle('FigureESP', {
				Text = 'Figure',
				Default = false, -- Default value (true / false)
				Tooltip = 'Highlights the Figure', -- Information shown when you hover over the toggle

				Callback = function(Value)
					FigureESP = Value
					if Value == true then
						for i,inst in pairs(game.Workspace.CurrentRooms:FindFirstChild(tonumber(Player:GetAttribute("CurrentRoom"))):GetDescendants()) do
							if inst.Name == "FigureRig" and inst:FindFirstChild("Torso") or inst.Name == "Figure" and inst:FindFirstChild("Torso") then
								esp(inst,inst.Torso,"Figure", entitycolor,true,false)
							end
						end
						game.Workspace.CurrentRooms.ChildAdded:Wait()
						for i,inst in pairs(game.Workspace.CurrentRooms:FindFirstChild(tonumber(Player:GetAttribute("CurrentRoom")) + 1):GetDescendants()) do
							if inst.Name == "FigureRig" and inst:FindFirstChild("Torso") or inst.Name == "Figure" and inst:FindFirstChild("Torso") then
								esp(inst,inst.Torso,"Figure", entitycolor,true,false)
							end
						end
					end
					if Value == false then
						for i,inst in pairs(game.Workspace.CurrentRooms:GetDescendants()) do
							if inst.Name == "FigureRig" or inst.Name == "Figure" then
								inst:SetAttribute("ESP", false)
							end
						end
					end
				end
			})
			ESP:AddToggle('ItemESP', {
				Text = 'Items',
				Default = false, -- Default value (true / false)
				Tooltip = 'Highlights all Items that spawn', -- Information shown when you hover over the toggle

				Callback = function(Value)
					ItemESP = Value
					if Value == true then
						for i,inst in pairs(game.Workspace.CurrentRooms:FindFirstChild(tonumber(Player:GetAttribute("CurrentRoom"))):GetDescendants()) do
							if table.find(Items,inst.Name) or table.find(Items2,inst.Name)then

								task.wait(0.85)
								if inst:FindFirstChild("Main") then
									esp(inst,inst:FindFirstChild("Main"), itemcolor,true,false)
								end
							end
							if inst.Name == "LibraryHintPaper" then
								esp(inst,inst.Handle,"Library Paper",itemcolor,false,false)
							end
						end
						game.Workspace.CurrentRooms.ChildAdded:Wait()
						for i,inst in pairs(game.Workspace.CurrentRooms:FindFirstChild(tonumber(Player:GetAttribute("CurrentRoom"))):GetDescendants()) do
							if table.find(Items,inst.Name) or table.find(Items2,inst.Name)then

								task.wait(0.75)
								if inst:FindFirstChild("Main") then
									esp(inst,inst:FindFirstChild("Main"), itemcolor,true,false)
								end

							end
							if inst.Name == "LibraryHintPaper" then
								esp(inst,inst.Handle,"Library Paper",itemcolor,false,false)
							end
						end
					end
					if Value == false then
						for i,inst in pairs(game.Workspace.CurrentRooms:GetDescendants()) do
							if  table.find(Items,inst.Name) or table.find(Items2,inst.Name) or inst.Name == "LibraryHintPaper" then
								inst:SetAttribute("ESP", false)
							end
						end
					end
				end
			})
			ESP:AddToggle('SnareESP', {
				Text = 'Snare',
				Default = false, -- Default value (true / false)
				Tooltip = 'Highlights all Snares', -- Information shown when you hover over the toggle

				Callback = function(Value)
					SnareESP = Value
					if Value == true then
						for i,inst in pairs(game.Workspace.CurrentRooms:FindFirstChild(tonumber(Player:GetAttribute("CurrentRoom"))):GetDescendants()) do
							if inst.Name == "Snare" and inst.PrimaryPart ~= nil then
								inst:WaitForChild("Snare").Roots.Transparency = 1
								inst:WaitForChild("Snare").SnareBase.Transparency = 1
								inst:WaitForChild("Void").Transparency = 0	
								inst:WaitForChild("Void").Color = Color3.fromRGB(76, 67, 55)
								if tonumber(inst.Parent.Parent.Name) >= CurrentRoom+1 then
									esp(inst,inst.Void,"Snare", snarecolor,true,false)
								end		

							end
						end


					end
					if Value == false then
						for i,inst in pairs(game.Workspace.CurrentRooms:GetDescendants()) do
							if inst.Name == "Snare" then
								inst:SetAttribute("ESP", false)
							end
						end
					end
				end
			})
			ESP:AddToggle('GoldESP', {
				Text = 'Gold',
				Default = false, -- Default value (true / false)
				Tooltip = 'Highlights all Gold [Currency] that spawns.', -- Information shown when you hover over the toggle

				Callback = function(Value)
					gold = Value
					if Value == true then
						for i,inst in pairs(game.Workspace.CurrentRooms:FindFirstChild(tonumber(Player:GetAttribute("CurrentRoom"))):GetDescendants()) do
							if inst.Name == "GoldPile" and inst.PrimaryPart ~= nil then
								inst.ChildAdded:Wait()
								esp(inst,inst.PrimaryPart,"Gold ["..inst:GetAttribute("GoldValue").."]", goldcolor,false,false)
							end
						end
						for i,inst in pairs(game.Workspace.CurrentRooms:FindFirstChild(tonumber(Player:GetAttribute("CurrentRoom")) + 1):GetDescendants()) do
							if inst.Name == "GoldPile" and inst.PrimaryPart ~= nil then
								inst.ChildAdded:Wait()
								esp(inst,inst.PrimaryPart,"Gold ["..inst:GetAttribute("GoldValue").."]", goldcolor,false,false)
							end
						end

						game.Workspace.CurrentRooms.ChildAdded:Wait()
						for i,inst in pairs(game.Workspace.CurrentRooms:FindFirstChild(tonumber(Player:GetAttribute("CurrentRoom")) + 1):GetDescendants()) do
							if inst.Name == "GoldPile" and inst.PrimaryPart ~= nil then
								inst.ChildAdded:Wait()
								esp(inst,inst.PrimaryPart,"Gold ["..inst:GetAttribute("GoldValue").."]", goldcolor,false,false)
							end
						end
					end
					if Value == false then
						for i,inst in pairs(game.Workspace.CurrentRooms:GetDescendants()) do
							if inst.Name == "GoldPile" then
								inst:SetAttribute("ESP", false)
							end
						end
					end
				end
			})
			ESP:AddToggle('DupeESP', {
				Text = 'Dupe',
				Default = false, -- Default value (true / false)
				Tooltip = 'Highlights all Dupe [Fake] doors that spawn', -- Information shown when you hover over the toggle

				Callback = function(Value)
					DupeESP = Value
					if Value == true then
						for i,door in pairs(game.Workspace:GetDescendants()) do
							if door.Name == "FakeDoor" or door.Name == "DoorFake" or door.Name == "SideroomSpace" then
								ApplyDupeESP(door)
							end
						end	
					end
					if Value == false then
						for i,inst in pairs(game.Workspace.CurrentRooms:GetDescendants()) do
							if inst.Name == "FakeDoor" or inst.Name == "DoorFake" or inst.Name == "SideroomSpace" then
								inst.Door:SetAttribute("ESP", false)
							end
						end
					end
				end
			})
			ESP:AddToggle('BookESP', {
				Text = 'Books',
				Default = false, -- Default value (true / false)
				Tooltip = 'Highlights all Books in The Library [Room 50].', -- Information shown when you hover over the toggle

				Callback = function(Value)
					books = Value
					if Value == true then
						for i,inst in pairs(game.Workspace.CurrentRooms:FindFirstChild(tonumber(Player:GetAttribute("CurrentRoom"))):GetDescendants()) do
							if inst.Name == "LiveHintBook" and inst:FindFirstChild("Base") then
								esp(inst,inst.Base,"Book", bookcolor,true,false)
							end
						end
						game.Workspace.CurrentRooms.ChildAdded:Wait()
						for i,inst in pairs(game.Workspace.CurrentRooms:FindFirstChild(tonumber(Player:GetAttribute("CurrentRoom")) + 1):GetDescendants()) do
							if inst.Name == "LiveHintBook" and inst:FindFirstChild("Base") then
								esp(inst,inst.Base,"Book", bookcolor,true,false)
							end
						end
					end
					if Value == false then
						for i,inst in pairs(game.Workspace.CurrentRooms:GetDescendants()) do
							if inst.Name == "LiveHintBook" then
								inst:SetAttribute("ESP", false)
							end
						end
					end
				end
			})
			ESP:AddToggle('BreakerESP', {
				Text = 'Breakers',
				Default = false, -- Default value (true / false)
				Tooltip = 'Highlights all Breakers [Room 100].', -- Information shown when you hover over the toggle

				Callback = function(Value)
					breakers = Value
					if Value == true then
						for i,inst in pairs(game.Workspace.CurrentRooms:FindFirstChild(tonumber(Player:GetAttribute("CurrentRoom"))):GetDescendants()) do
							if inst.Name == "LiveBreakerPolePickup" and inst:FindFirstChild("Base") then
								esp(inst,inst.Base,"Breaker", breakercolor,true,false)
							end
						end
						for i,inst in pairs(game.Workspace.CurrentRooms:FindFirstChild(tonumber(Player:GetAttribute("CurrentRoom")) + 1):GetDescendants()) do
							if inst.Name == "LiveBreakerPolePickup" and inst:FindFirstChild("Base") then
								esp(inst,inst.Base,"Breaker", breakercolor,true,false)
							end
						end
						game.Workspace.CurrentRooms.ChildAdded:Wait()
						for i,inst in pairs(game.Workspace.CurrentRooms:FindFirstChild(tonumber(Player:GetAttribute("CurrentRoom")) + 1):GetDescendants()) do
							if inst.Name == "LiveBreakerPolePickup" and inst:FindFirstChild("Base") then
								esp(inst,inst.Base,"Breaker", breakercolor,true,false)
							end
						end
					end
					if Value == false then
						for i,inst in pairs(game.Workspace.CurrentRooms:GetDescendants()) do
							if inst.Name == "LiveBreakerPolePickup" then
								inst:SetAttribute("ESP", false)
							end
						end
					end
				end
			})
			ESP:AddToggle('EntityESP', {
				Text = 'Entities',
				Default = false, -- Default value (true / false)
				Tooltip = 'Highlights all Entities that spawn.', -- Information shown when you hover over the toggle

				Callback = function(Value)
					EntityESP = Value

				end
			})
			
			ESP:AddDivider()




			Toggles.DoorESP:AddColorPicker('ColorPicker1', {
				Default = doorcolor, -- Bright green
				Title = 'Doors', -- Optional. Allows you to have a custom color picker title (when you open it)
				Transparency = 0, -- Optional. Enables transparency changing for this color picker (leave as nil to disable)

				Callback = function(Value)
					doorcolor = Value
					ColorTable["Door"] = Value
				end
			})
			Toggles.ClosetESP:AddColorPicker('ColorPicker2', {
				Default = closetcolor, -- Bright green
				Title = 'Closets', -- Optional. Allows you to have a custom color picker title (when you open it)
				Transparency = 0, -- Optional. Enables transparency changing for this color picker (leave as nil to disable)

				Callback = function(Value)
					closetcolor = Value
				end
			})
			Toggles.KeyESP:AddColorPicker('KeyColor', {
				Default = keycolor, -- Bright green
				Title = 'Keys', -- Optional. Allows you to have a custom color picker title (when you open it)
				Transparency = 0, -- Optional. Enables transparency changing for this color picker (leave as nil to disable)

				Callback = function(Value)
					keycolor = Value
				end
			})
			Toggles.LeverESP:AddColorPicker('ColorPicker4', {
				Default = levercolor, -- Bright green
				Title = 'Levers', -- Optional. Allows you to have a custom color picker title (when you open it)
				Transparency = 0, -- Optional. Enables transparency changing for this color picker (leave as nil to disable)

				Callback = function(Value)
					levercolor = Value
				end
			})
			Toggles.ItemESP:AddColorPicker('ColorPicker8', {
				Default = itemcolor, -- Bright green
				Title = 'Items', -- Optional. Allows you to have a custom color picker title (when you open it)
				Transparency = 0, -- Optional. Enables transparency changing for this color picker (leave as nil to disable)

				Callback = function(Value)
					itemcolor = Value
				end
			})
			Toggles.FigureESP:AddColorPicker('ColorPicker8', {
				Default = figurecolor, -- Bright green
				Title = 'Figure', -- Optional. Allows you to have a custom color picker title (when you open it)
				Transparency = 0, -- Optional. Enables transparency changing for this color picker (leave as nil to disable)

				Callback = function(Value)
					figurecolor = Value
				end
			})
			Toggles.SnareESP:AddColorPicker('ColorPicker5', {
				Default = snarecolor, -- Bright green
				Title = 'Snare', -- Optional. Allows you to have a custom color picker title (when you open it)
				Transparency = 0, -- Optional. Enables transparency changing for this color picker (leave as nil to disable)

				Callback = function(Value)
					snarecolor = Value
				end
			})
			Toggles.GoldESP:AddColorPicker('ColorPicker6', {
				Default = goldcolor, -- Bright green
				Title = 'Gold', -- Optional. Allows you to have a custom color picker title (when you open it)
				Transparency = 0, -- Optional. Enables transparency changing for this color picker (leave as nil to disable)

				Callback = function(Value)
					goldcolor = Value
				end
			})
			Toggles.DupeESP:AddColorPicker('DupeESPColor', {
				Default = dupecolor, -- Bright green
				Title = 'Fake Doors', -- Optional. Allows you to have a custom color picker title (when you open it)
				Transparency = 0, -- Optional. Enables transparency changing for this color picker (leave as nil to disable)

				Callback = function(Value)
					dupecolor = Value
				end
			})
			Toggles.EntityESP:AddColorPicker('ColorPicker7', {
				Default = entitycolor, -- Bright green
				Title = 'Entities', -- Optional. Allows you to have a custom color picker title (when you open it)
				Transparency = 0, -- Optional. Enables transparency changing for this color picker (leave as nil to disable)

				Callback = function(Value)
					entitycolor = Value
				end
			})
			Toggles.ChestESP:AddColorPicker('ChestColorPicker', {
				Default = chestcolor, -- Bright green
				Title = 'Chests', -- Optional. Allows you to have a custom color picker title (when you open it)
				Transparency = 0, -- Optional. Enables transparency changing for this color picker (leave as nil to disable)

				Callback = function(Value)
					chestcolor = Value
				end
			})
			Toggles.BookESP:AddColorPicker('ColorPicker9', {
				Default = bookcolor, -- Bright green
				Title = 'Books', -- Optional. Allows you to have a custom color picker title (when you open it)
				Transparency = 0, -- Optional. Enables transparency changing for this color picker (leave as nil to disable)

				Callback = function(Value)
					bookcolor = Value
				end
			})
			Toggles.BreakerESP:AddColorPicker('ColorPicker10', {
				Default = breakercolor, -- Bright green
				Title = 'Breakers', -- Optional. Allows you to have a custom color picker title (when you open it)
				Transparency = 0, -- Optional. Enables transparency changing for this color picker (leave as nil to disable)

				Callback = function(Value)
					breakercolor = Value
				end
			})

			ESPSettings:AddToggle('Toggle21', {
				Text = 'Rainbow ESP',
				Default = false, -- Default value (true / false)
				Tooltip = 'Makes all ESP highlights have a rainbow effect.', -- Information shown when you hover over the toggle

				Callback = function(Value)
					ESPLibrary.Rainbow = Value
				end
			})
			ESPSettings:AddDivider()
			ESPSettings:AddSlider('Slider3', {
				Text = 'Fill Transparency',
				Default = 0.65,
				Min = 0,
				Max = 1,
				Rounding = 2,
				Compact = false,

				Callback = function(Value)
					ESPLibrary:SetFillTransparency(Value)

				end
			})
			ESPSettings:AddSlider('Slider4', {
				Text = 'Outline Transparency',
				Default = 0,
				Min = 0,
				Max = 1,
				Rounding = 2,
				Compact = false,

				Callback = function(Value)
					ESPLibrary:SetOutlineTransparency(Value)

				end
			})
			ESPSettings:AddSlider('Slider5', {
				Text = 'Text Transparency',
				Default = 0,
				Min = 0,
				Max = 1,
				Rounding = 2,
				Compact = false,

				Callback = function(Value)
					ESPLibrary:SetTextTransparency(Value)

				end
			})

			ESPSettings:AddSlider('ESPFadeTime', {
				Text = 'Fade Time',
				Default = 0.5,
				Min = 0,
				Max = 2,
				Rounding = 2,
				Compact = false,

				Callback = function(Value)
					ESPLibrary:SetFadeTime(Value)

				end
			})
			ESPSettings:AddSlider('Slider5', {
				Text = 'Text Size',
				Default = 18,
				Min = 1,
				Max = 100,
				Rounding = 0,
				Compact = false,

				Callback = function(Value)
					ESPLibrary:SetTextSize(Value)

				end
			})
			ESPSettings:AddSlider('ESPStrokeTransparency', {
				Text = 'Text Outline Transparency',
				Default = 0,
				Min = 0,
				Max = 1,
				Rounding = 2,
				Compact = false,

				Callback = function(Value)
					ESPLibrary:SetTextOutlineTransparency(Value)

				end
			})

			ESPSettings:AddDropdown("ESPFont", { Values = { "Arial", "SourceSans", "Highway", "Fantasy","FredokaOne", "Gotham", "DenkOne", "JosefinSans", "Nunito", "Oswald", "RobotoCondensed", "Sarpanch", "Ubuntu" }, Default = 11, Multi = false, Text = "Text Font", Callback = function(Value) ESPLibrary:SetFont(Value) end})
			ESPSettings:AddDivider()
			ESPSettings:AddToggle('SyncColors', {
				Text = 'Match Colors',
				Default = true, -- Default value (true / false)
				Tooltip = 'Makes all ESP highlights Outline Color match their\n Fill Color.', -- Information shown when you hover over the toggle

				Callback = function(Value)
					ESPLibrary.MatchColors = Value
				end
			})
			ESPLibrary:SetFont(Options.ESPFont.Value)
			ESPSettings:AddToggle('ShowDistance', {
				Text = 'Show Distance',
				Default = false, -- Default value (true / false)
				Tooltip = 'Shows the distance [in studs] that the object\nis away from the Player', -- Information shown when you hover over the toggle

				Callback = function(Value)
					ESPLibrary.ShowDistance = Value
				end
			})
			ESPSettings:AddDivider()
			ESPSettings:AddToggle('EnableTracers', {
				Text = 'Enable Tracers',
				Default = false, -- Default value (true / false)
				Tooltip = 'Shows a line on screen that points to the object', -- Information shown when you hover over the toggle

				Callback = function(Value)
					ESPLibrary.Tracers = Value
				end
			})
			ESPSettings:AddDropdown("ESPFont", {
				Values = {'Bottom','Top','Center','Mouse'},
					Default = 1,
					Multi = false,
					Text = "Tracer Origin",
					Callback = function(Value) ESPLibrary.TracerOrigin = Value
					end
			})

			


			

			ExtraVisualsTab:AddToggle("WatermarkToggle",{
				Text = "Watermark",
				Default = false,
				Tooltip = 'Allows you to have Custom Text always visible on the Screen',
				Callback = function(value)
					Watermark.Visible = value
				end,
			})
			ExtraVisualsTab:AddInput('WatermarkText', {
				Default = '',
				Numeric = false, -- true / false, only allows numbers
				Finished = true, -- true / false, only calls callback when you press enter

				Text = 'Watermark Text',
				Tooltip = 'Select the Text for the Watermark', -- Information shown when you hover over the textbox

				Placeholder = 'Enter Text Here', -- placeholder text when the box is empty
				-- MaxLength is also an option which is the max length of the text

				Callback = function(Value)
					Watermark.Text = Value
				end
			})

			LeftGroupBox2:AddButton({
				Text = 'Unlock Golden Rift',
				Func = function()
					local Room = game.Workspace.CurrentRooms:FindFirstChild("100") or game.Workspace.CurrentRooms:FindFirstChild("200")
					if Floor ~= "Fools" and OldHotel == false then
						if Room then
							Room:WaitForChild("Assets").RiftSpawn.Rift.StarCenter.StarRiftPrompt.Enabled = true
							Room:WaitForChild("Assets").RiftSpawn.Rift.StarCenter.ParticlesIn.Core.Enabled = true
							Room:WaitForChild("Assets").RiftSpawn.Rift.StarCenter.ParticlesIn.RainbowShards.Enabled = true
							Room:WaitForChild("Assets").RiftSpawn.Rift.StarCenter.ParticlesIn.Triangles.Enabled = true
							Room:WaitForChild("Assets").RiftSpawn.Rift.StarCenter.ParticlesIn.ZoomParticle.Enabled = true
							Room:WaitForChild("Assets").RiftSpawn.Rift.StarCenter.ParticlesIn.Core.TimeScale = 0.1
							Room:WaitForChild("Assets").RiftSpawn.Rift.StarCenter.ParticlesIn.RainbowShards.TimeScale = 0.1
							Room:WaitForChild("Assets").RiftSpawn.Rift.StarCenter.ParticlesIn.Triangles.TimeScale = 0.1
							Room:WaitForChild("Assets").RiftSpawn.Rift.StarCenter.ParticlesIn.ZoomParticle.TimeScale = 0.1
							Notify({Title = "Golden Rift Bypass",Description = "Successfully unlocked the Golden Rift."})
							Sound()
						else
							Notify({Title = "Golden Rift Bypass",Description = "You must be in room 100 or 200 to do this."})
							Sound()
						end
					else
						Notify({Title = "Golden Rift Bypass",Description = "The Golden Rift is only in the new hotel."})
						Sound()
					end
				end,
				DoubleClick = false,
				Tooltip = 'Unlocks the Golden Rift in the Rift Room [Room 100/200].'
			})
			LeftGroupBox2:AddButton({
				Text = 'Get Glitch Fragment',
				Func = function()
					local active = true

					Notify({Title = "Glitch Fragment Bypass",Description = "Attempting to spawn a glitch fragment.",Reason = "This will take a while."})
					Sound()

					while task.wait() do
						if active == true then
							if active == true then
								Character:PivotTo(CFrame.new(666,666,666) * (Character:GetPivot() + workspace.CurrentCamera.CFrame.LookVector * Vector3.new(1, 1, 1) * -250))


								task.wait(0.5)	
							end
							if active == true then

								task.wait(0.5)

								if tonumber(Player:GetAttribute("GlitchLevel")) >= 5 then
									active = false
									Notify({Title = "Glitch Fragment Bypass",Description = "A glitch fragment should spawn in the next drawer you open!"})
									Sound()
									repeat task.wait() until game.LogService.MessageOut


									break



								end
							end
						end
					end


				end,
				DoubleClick = false,
				Tooltip = 'Repeatedly spawns Glitch in order to spawn a Glitch Fragment.'
			})

			-- Movement
			for i,message in pairs(EntityList) do
				ChatNotifyMessagesTab:AddInput(message .. "ChatNotifyMessage", {
					Default = EntityChatNotifyMessages[message],
					Numeric = false, -- true / false, only allows numbers
					Finished = true, -- true / false, only calls callback when you press enter

					Text = EntityShortNames[message],
					Tooltip = 'The Message to send in the Chat when '..message.. ' spawns.', -- Information shown when you hover over the textbox

					Placeholder = 'Enter Message Here', -- placeholder text when the box is empty
					-- MaxLength is also an option which is the max length of the text

					Callback = function(Value)
						EntityChatNotifyMessages[message] = Value
						local message2 = game:GetService("Chat"):FilterStringForBroadcast(Value, game.Players.LocalPlayer)
						if string.find(message2,"#") then
							Notify({Title = "WARNING",Description = "The entered chat message has been moderated and will not be visible to others.",Reason = "Please enter a different message."})
							Sound()
						end

					end
				})
			end
			if RequireCheck == true then
				VisualsRemove:AddDivider()
				VisualsRemove:AddToggle('NoCameraShake',{
					Default = false,
					Tooltip = 'Prevents the camera from shaking',
					Text = "No Camera Shake"
				})
				VisualsRemove:AddToggle('NoCameraBobbing',{
					Default = false,
					Tooltip = 'Prevents the camera from bobbing',
					Text = "No Camera Bobbing"
				})
			end
			for i,part in pairs(game.Workspace.CurrentRooms:GetDescendants()) do
				if part:IsDescendantOf(game.Workspace.CurrentRooms:FindFirstChild(CurrentRoom)) then
					GetRoom(part)
				elseif part:IsDescendantOf(game.Workspace.CurrentRooms:FindFirstChild(tostring(tonumber(CurrentRoom)+1))) then 
					GetRoom(part)
				end
			end
			
			local NoclipConnection = RunService.RenderStepped:Connect(function()
				HumanoidRootPart.CanCollide = false
				for i,part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
					if part:IsA("BasePart") then
						if part ~= CollisionCrouch and part ~= Collision and part ~= CollisionClone and part ~= CollisionClone2 then
							part.CanCollide = false


						end
					end
				end


				Collision.CanCollide = false

				if noclip == true then
					if Collision:FindFirstChild("CollisionCrouch") then
						Collision:FindFirstChild("CollisionCrouch").CanCollide = false
					end
					Collision.CanCollide = false
					CollisionClone2.CanCollide = false

					CollisionClone.CanCollide = false

				elseif Collision.CollisionGroup ~= "PlayerCrouching" then
					CollisionClone.CanCollide = false
					Collision.CanCollide = false
					CollisionClone2.CanCollide = true
					if Collision:FindFirstChild("CollisionCrouch") then
						Collision:FindFirstChild("CollisionCrouch").CanCollide = true
					end
				end
				if godmode == true and noclip == false and Collision.CollisionGroup ~= "PlayerCrouching" then
					if Collision:FindFirstChild("CollisionCrouch") then
						Collision:FindFirstChild("CollisionCrouch").CanCollide = false
					end
					CollisionClone2.CanCollide = true
					Collision.CanCollide = false
				end
				if Collision.CollisionGroup == "PlayerCrouching" and noclip == false then
					Collision.CanCollide = false

					if Collision:FindFirstChild("CollisionCrouch") then
						Collision:FindFirstChild("CollisionCrouch").CanCollide = true
					end
					CollisionClone.CanCollide = false
					CollisionClone2.CanCollide = false



				end
			end)
			SpeedBypass()
			local promptsnum = 1

			local firstenabled = false
			for i,inst in pairs(game.Workspace:GetDescendants()) do
				inst:SetAttribute("ParentRoom",GetRoom(inst))
				if inst:IsA("ProximityPrompt") then
					local connections = {}
					RoomName = inst:GetAttribute("ParentRoom")
					local ConnectionCooldown = false
					connections.connection = game["Run Service"].RenderStepped:Connect(function()
						if inst ~= nil and inst:IsDescendantOf(workspace) and ConnectionCooldown == false then
							ConnectionCooldown = true
							if inst:GetAttribute("OldHoldTime") == nil then
								inst:SetAttribute("OldHoldTime",inst.HoldDuration)
							end
							if inst:GetAttribute("PromptClip") == nil then
								inst:SetAttribute("PromptClip",inst.RequiresLineOfSight)
							end
							if interact == true then
								inst.HoldDuration = 0
							else
								inst.HoldDuration = inst:GetAttribute("OldHoldTime")
							end
							if inst:GetAttribute("OldDistance") == nil then
								inst:SetAttribute("OldDistance",inst.MaxActivationDistance)
							end
							if maxinteract == true then
								inst.MaxActivationDistance = ReachDistance
							else
								inst.MaxActivationDistance = inst:GetAttribute("OldDistance")
							end
							if ito == true then
								inst.RequiresLineOfSight = false
							else
								inst.RequiresLineOfSight = inst:GetAttribute("PromptClip")
							end


							local ParentObject = inst.Parent

							local ParentDistance = 0
							if ParentObject:IsA("Model") then
								ParentDistance = Player:DistanceFromCharacter(ParentObject.WorldPivot.Position)
							elseif ParentObject:IsA("BasePart") then
								ParentDistance = Player:DistanceFromCharacter(ParentObject.Position)
							end

							if Toggles.AA.Value or Options.AutoInteract:GetState() == true then

								if inst.Parent.Name ~= "KeyObtainFake" and not string.find(inst.Parent.Parent.Name,"Fake") and not string.find(inst.Name,"RiftPrompt") and inst.Name ~= "HidePrompt" and ParentDistance < 15 then

									if inst.Name == "PropPrompt" and inst.Parent.Prop:GetAttribute("Hint") ~= inst.Parent:GetAttribute("Hint") then

										forcefireproximityprompt(inst)

									end



								end

							end

							task.wait(0.1)
							ConnectionCooldown = false
						end

					end)
					inst:GetPropertyChangedSignal("Parent"):Connect(function()
						connections.connection:Disconnect()
					end)
					game.Workspace.CurrentRooms.ChildRemoved:Connect(function(child)
						if RoomName == child.Name then
							connections.connection:Disconnect()
						end
					end)



				end
			end
			
			for i,inst in pairs(game.Workspace:GetDescendants()) do
				if inst:IsA("ProximityPrompt") then
					local connections = {}
					RoomName = inst:GetAttribute("ParentRoom")
					local ConnectionCooldown = false
					connections.connection = game["Run Service"].RenderStepped:Connect(function()
						if inst ~= nil and inst:IsDescendantOf(workspace) and ConnectionCooldown == false then
							ConnectionCooldown = true
							if inst:GetAttribute("OldHoldTime") == nil then
								inst:SetAttribute("OldHoldTime",inst.HoldDuration)
							end
							if inst:GetAttribute("PromptClip") == nil then
								inst:SetAttribute("PromptClip",inst.RequiresLineOfSight)
							end
							if interact == true then
								inst.HoldDuration = 0
							else
								inst.HoldDuration = inst:GetAttribute("OldHoldTime")
							end
							if inst:GetAttribute("OldDistance") == nil then
								inst:SetAttribute("OldDistance",inst.MaxActivationDistance)
							end
							if maxinteract == true then
								inst.MaxActivationDistance = ReachDistance
							else
								inst.MaxActivationDistance = inst:GetAttribute("OldDistance")
							end
							if ito == true then
								inst.RequiresLineOfSight = false
							else
								inst.RequiresLineOfSight = inst:GetAttribute("PromptClip")
							end


							local ParentObject = inst.Parent

							local ParentDistance = 0
							if ParentObject:IsA("Model") then
								ParentDistance = Player:DistanceFromCharacter(ParentObject.WorldPivot.Position)
							elseif ParentObject:IsA("BasePart") then
								ParentDistance = Player:DistanceFromCharacter(ParentObject.Position)
							end

							if Toggles.AA.Value or Options.AutoInteract:GetState() == true then

								if inst.Parent.Name ~= "KeyObtainFake" and not string.find(inst.Parent.Parent.Name,"Fake") and not string.find(inst.Name,"RiftPrompt") and inst.Name ~= "HidePrompt" and ParentDistance < 15 then

									if inst.Name == "PropPrompt" and inst.Parent.Prop:GetAttribute("Hint") ~= inst.Parent:GetAttribute("Hint") then

										forcefireproximityprompt(inst)

									end



								end

							end

							task.wait(0.1)
							ConnectionCooldown = false
						end

					end)
					inst:GetPropertyChangedSignal("Parent"):Connect(function()
						connections.connection:Disconnect()
					end)
					game.Workspace.CurrentRooms.ChildRemoved:Connect(function(child)
						if RoomName == child.Name then
							connections.connection:Disconnect()
						end
					end)



				end
			end
			
			
			local Connection5 = game.Workspace.DescendantAdded:Connect(function(inst)

				inst:SetAttribute("ParentRoom",GetRoom(inst))
				if inst:GetAttribute("ParentRoom") then


					if inst.Name == "Snare" then


						local r = game["Run Service"].RenderStepped:Connect(function()
							if inst:FindFirstChild("Hitbox") then
								if SnareESP == true then
									inst:WaitForChild("Snare").Roots.Transparency = 1
									inst:WaitForChild("Snare").SnareBase.Transparency = 1
									inst:WaitForChild("Void").Transparency = 0	
									inst:WaitForChild("Void").Color = Color3.fromRGB(76, 67, 55)
									if tonumber(inst.Parent.Parent.Name) >= CurrentRoom then
										esp(inst,inst.Void,"Snare", snarecolor,true,false)
									end		 
								end
								if AntiSnare == true then
									inst.Hitbox.CanTouch = false
									if inst.Hitbox:FindFirstChild("TouchInterest") then
										inst.Hitbox.TouchInterest:Destroy()
									end
								end
							end
						end)
						game.Workspace.CurrentRooms.ChildAdded:Wait()
						r:Disconnect()	
					end

					if inst:FindFirstChild("HiddenPlayer") then
						RoomName = inst:GetAttribute("ParentRoom")
						local parts = {}
						for i,part in pairs(inst:GetDescendants()) do
							if part:IsA("BasePart") then
								if part.Transparency == 0 then
									table.insert(parts,part)
								end
							end
							task.wait()
						end



					
						inst:FindFirstChild("HiddenPlayer"):GetPropertyChangedSignal("Value"):Connect(function()
							if ConnectionCooldown == false then
								ConnectionCooldown = true
								if inst:FindFirstChild("HiddenPlayer") then
									if inst.HiddenPlayer.Value == Character and TransparentCloset == true then
										for i,e in pairs(parts) do
											e.Transparency = TransparentClosetNumber

										end

									else
										for i,e in pairs(parts) do
											e.Transparency = 0

										end
									end
								end
							
							end
						end)

						
					end
					if inst:IsA("ProximityPrompt") then
						local connections = {}
						RoomName = inst:GetAttribute("ParentRoom")
						local ConnectionCooldown = false
						connections.connection = game["Run Service"].RenderStepped:Connect(function()
							if inst ~= nil and inst:IsDescendantOf(workspace) and ConnectionCooldown == false then
								ConnectionCooldown = true
								if inst:GetAttribute("OldHoldTime") == nil then
									inst:SetAttribute("OldHoldTime",inst.HoldDuration)
								end
								if inst:GetAttribute("PromptClip") == nil then
									inst:SetAttribute("PromptClip",inst.RequiresLineOfSight)
								end
								if interact == true then
									inst.HoldDuration = 0
								else
									inst.HoldDuration = inst:GetAttribute("OldHoldTime")
								end
								if inst:GetAttribute("OldDistance") == nil then
									inst:SetAttribute("OldDistance",inst.MaxActivationDistance)
								end
								if maxinteract == true then
									inst.MaxActivationDistance = ReachDistance
								else
									inst.MaxActivationDistance = inst:GetAttribute("OldDistance")
								end
								if ito == true then
									inst.RequiresLineOfSight = false
								else
									inst.RequiresLineOfSight = inst:GetAttribute("PromptClip")
								end


								local ParentObject = inst.Parent

								local ParentDistance = 0
								if ParentObject:IsA("Model") then
									ParentDistance = Player:DistanceFromCharacter(ParentObject.WorldPivot.Position)
								elseif ParentObject:IsA("BasePart") then
									ParentDistance = Player:DistanceFromCharacter(ParentObject.Position)
								end

								if Toggles.AA.Value or Options.AutoInteract:GetState() == true then

									if inst.Parent.Name ~= "KeyObtainFake" and not string.find(inst.Parent.Parent.Name,"Fake") and not string.find(inst.Name,"RiftPrompt") and inst.Name ~= "HidePrompt" and ParentDistance < 15 then

										forcefireproximityprompt(inst)



									end

								end

								task.wait(0.1)
								ConnectionCooldown = false
							end

						end)
						inst:GetPropertyChangedSignal("Parent"):Connect(function()
							connections.connection:Disconnect()
						end)
						game.Workspace.CurrentRooms.ChildRemoved:Connect(function(child)
							if RoomName == child.Name then
								connections.connection:Disconnect()
							end
						end)



					end
					if inst.Name == "DoorFake" and AntiDupe == true or inst.Name == "FakeDoor" and AntiDupe == true  then
						DisableDupe(inst)



					elseif inst.Name == "GiggleCeiling" and Toggles.AntiGiggle.Value then
						inst:WaitForChild("Hitbox", 5).CanTouch = false



					elseif inst.Name == "Lava" and Toggles.AntiLava.Value then
						inst.CanTouch = false
					elseif inst.Name == "ScaryWall" and Toggles.AntiLava.Value then
						for i,part in pairs(inst:GetDescendants()) do
							if part:IsA("BasePart") then
								part.CanTouch = false
								part.CanCollide = false
							end
						end
					elseif inst:IsA("Model") and inst.Name == "Figure" and Toggles.GodmodeFigure.Value or inst:IsA("Model") and inst.Name == "FigureRagdoll" and Toggles.GodmodeFigure.Value then
						for i, v in pairs(inst:GetDescendants()) do
							if v:IsA("BasePart") then
								if not v:GetAttribute("Clip") then v:SetAttribute("Clip", v.CanCollide) end

								v.CanTouch = false
								v.CanCollide = true
							end
						end	

					elseif inst.Name == "GloomPile" then
						for _, gloomEgg in pairs(inst:GetDescendants()) do
							if gloomEgg.Name == "Egg" then
								gloomEgg.CanTouch = not Toggles.AntiGloomEgg.Value
							end
						end

					elseif inst.Name == "DoorFake" and AntiDupe == true or inst.Name == "FakeDoor" and AntiDupe == true  then
						DisableDupe(inst)

					elseif inst.Name == "TriggerEventCollision" then

						if BypassSeek == true then

							DisableSeekFools()
						end	
					elseif inst.Name == "SideroomSpace" and AntiVacuum == true then
						DisableDupe(inst)

					end
					if inst.Name == "GoldPile" and inst.PrimaryPart ~= nil and gold == true then
						
						esp(inst,inst.PrimaryPart,"Gold ["..inst:GetAttribute("GoldValue").."]", goldcolor,true,false)




					elseif inst.Name == "Ladder" and inst.PrimaryPart ~= nil
					then
						if Ladders == true then
							esp(inst,inst.PrimaryPart,"Ladder", laddercolor,true,false)
						end
						if MinesBypass == true then








							-- Ladder ESP

						else
							if workspace:FindFirstChild("_internal_mspaint_acbypassprogress") then workspace:FindFirstChild("_internal_mspaint_acbypassprogress"):Destroy() end



							local Bypassed = true
							if Bypassed == true then
								RemotesFolder.ClimbLadder:FireServer()
								Bypassed = false


							end
						end





					elseif inst.Name == "FuseObtain" and  FuseESP == true then
						if inst:FindFirstChild("Hitbox") then

							esp(inst,inst.Hitbox,"Fuse", fusecolor,true,false)

						end





					elseif inst.Name == "ChestBox" and inst:FindFirstChild("Main") and Toggles.ChestESP.Value or inst.Name == "ChestBoxLocked" and inst:FindFirstChild("Main") and Toggles.ChestESP.Value then
							local Text = "Chest"
							if inst:GetAttribute("Locked") == true then
								Text = "Locked Chest"
							end
							esp(inst,inst.Main,Text, chestcolor,true,false)
						

						
					elseif inst.Name == "KeyObtain" and  keys == true  then
						
							if inst:WaitForChild("Hitbox"):FindFirstChild("Key") then
								esp(inst,inst:WaitForChild("Hitbox").Key,"Door Key".." ["..tonumber(inst:GetAttribute("ParentRoom")+DoorsDifference).."]", keycolor,true,false)
							elseif inst:WaitForChild("Hitbox"):FindFirstChild("KeyHitbox") then
								esp(inst,inst:WaitForChild("Hitbox").KeyHitbox,"Door Key".." ["..tonumber(inst:GetAttribute("ParentRoom")+DoorsDifference).."]", keycolor,true,false)
							
						end



					elseif inst.Name == "Door" and inst:FindFirstChild("Door")

					then


						if doors == true then

							if inst.Name == "Door" and inst:FindFirstChild("Door") then
								local CurrentRoom = tonumber(inst:GetAttribute("ParentRoom"))-1

								local knob = inst.Door:FindFirstChild("Knob") or inst.Door
								if inst.Parent.Name == "49" or inst.Parent.Name == "50" then

									if inst.Parent:GetAttribute("RequiresKey") == true then
										esp(inst,inst.Hidden,"Door", doorcolor,true,true)
									else
										esp(inst,inst.Hidden,"Door", doorcolor,true,true)
									end
								else

									if inst.Parent:GetAttribute("RequiresKey") == true then

										esp(inst.Door,knob,"Door", doorcolor,true,true)
									else
										esp(inst.Door,knob,"Door", doorcolor,true,true)
									end
								end

							end


						end


					elseif inst.Name == "LeverForGate" and inst:FindFirstChild("Main") and levers == true
					then
						esp(inst.Main,inst.Main,"Lever", levercolor,true,false)



					elseif inst.Name == "Wardrobe" and inst:FindFirstChild("Main") and closets == true
					then
						esp(inst,inst.Main,"Closet", closetcolor,true,false)

					elseif inst.Name == "Toolshed" and inst:FindFirstChild("Main") and closets == true
					then
						esp(inst,inst.Main,"Closet", closetcolor,true,false)	
					elseif inst.Name == "Rooms_Locker" and inst:FindFirstChild("Base") and closets == true
					then
						esp(inst,inst.Base,"Locker", closetcolor,true,false)

					else	if inst.Name == "Rooms_Locker_Fridge" and inst:FindFirstChild("Base") and closets == true
						then
							esp(inst,inst.Base,"Locker", closetcolor,true,false)

						elseif inst.Name == "Locker_Large" and inst:FindFirstChild("Main") and closets == true
						then
							esp(inst,inst.Main,"Locker", closetcolor,true,false)

						elseif inst.Name == "MinesAnchor" and inst:FindFirstChild("Sign") and AnchorESP == true then
							esp(inst,inst.PrimaryPart,"Anchor".. " "..inst.Sign.TextLabel.Text, grumblecolor,false,false)

						elseif inst.Name == "DoorFake" and AntiDupe == true or inst.Name == "FakeDoor" and AntiDupe == true  then
							DisableDupe(inst)	
						elseif inst.Name == "RetroWardrobe" and inst:FindFirstChild("Main") and closets == true
						then
							esp(inst,inst.Main,"Closet", closetcolor,true,false)
						elseif inst.Name == "Bed" and inst:FindFirstChild("Main") and closets == true
						then
							esp(inst,inst.Main,"Bed", closetcolor,true,false)	
						elseif inst.Name == "Backdoor_Wardrobe" and inst:FindFirstChild("Main") and closets == true
						then
							esp(inst,inst.Main,"Closet", closetcolor,true,false)

					
						elseif inst.Name == "ElectricalKeyObtain" and  keys == true  then
							if inst:FindFirstChild("Hitbox") then
								if inst.Hitbox:FindFirstChild("Key") then
									esp(inst,inst.Hitbox.Key,"Electrical Key", keycolor,true,false)
								elseif inst.Hitbox:FindFirstChild("KeyHitbox") then
									esp(inst,inst.Hitbox.KeyHitbox,"Electrical Key", keycolor,true,false)
								end
							end
						elseif inst.Name == "FuseObtain" and  FuseESP == true then
							if inst:FindFirstChild("Hitbox") then

								esp(inst,inst.Hitbox,"Fuse", fusecolor,true,false)

							end

						elseif inst.Name == "Seek_Arm" and AntiSeekObstructions == true then
							if inst.Name == "Seek_Arm" then
								for i,a in pairs(inst.Parent.Parent:GetDescendants()) do
									if a:IsA("BasePart") and a.Parent.Name ~= "Door" then
										a.CanTouch = false
									end
								end
							end

						elseif inst.Name == "MinesGenerator" and GeneratorESP == true then

							esp(inst,inst:WaitForChild("GeneratorMain"),"Generator", generatorcolor,true,false)
						elseif inst.Name == "MinesGateButton" and GeneratorESP == true then
							esp(inst,inst.MainPart,"Gate Button", generatorcolor,true,false)



						elseif inst.Name == "Snare" and SnareESP == true then
							
							esp(inst.Hitbox,inst.Hitbox,"Snare",snarecolor,true,false)
						elseif inst.Name == "GrumbleRig" and inst:FindFirstChild("Root") and GrumbleESP == true then
							esp(inst,inst.Root,"Grumble", grumblecolor,false,false)

						elseif inst.Name == "LiveHintBook" and books == true then
							esp(inst,inst.Base,"Book", bookcolor,true,false)




						elseif inst.Name == "FigureRig" and inst:FindFirstChild("Torso") or inst.Name == "Figure" and inst:FindFirstChild("Torso") or inst.Name == "FigureRagdoll" and inst:FindFirstChild("Torso") then
							Figure = inst
							if FigureESP == true then
								esp(inst,inst.Torso,"Figure", entitycolor,true,false)
							end





						elseif inst.Name == "LiveBreakerPolePickup" and breakers == true then
							esp(inst,inst.Base,"Breaker", breakercolor,true,false)





						elseif inst.Name == "JeffTheKiller" and Toggles.AntiJeff.Value then
							DisableJeff()



						elseif inst.Name == "TimerLever" and inst:FindFirstChild("Main") then
							task.wait(1)
							if TimerLevers == true then
								esp(inst,inst.Main,"Time Lever", timelevercolor,true,false)
								local r = game["Run Service"].RenderStepped:Connect(function()
									if inst then
										if not inst:FindFirstChild("Main") then
											inst:SetAttribute("CurrentESP",false)
										end
									end
								end)
								inst.Destroying:Wait()
								r:Disconnect()





							end


						end

					end


				end



			end)
			for i,inst in pairs(game.Workspace:GetDescendants()) do
				if inst:FindFirstChild("HiddenPlayer") then
					RoomName = inst:GetAttribute("ParentRoom")
					local parts = {}
					for i,part in pairs(inst:GetDescendants()) do
						if part:IsA("BasePart") then
							if part.Transparency == 0 then
								table.insert(parts,part)
							end
						end
						task.wait()
					end



					inst:FindFirstChild("HiddenPlayer"):GetPropertyChangedSignal("Value"):Connect(function()
						if ConnectionCooldown == false then
							ConnectionCooldown = true
							if inst:FindFirstChild("HiddenPlayer") then
								if inst.HiddenPlayer.Value == Character and TransparentCloset == true then
									for i,e in pairs(parts) do
										e.Transparency = TransparentClosetNumber

									end

								else
									for i,e in pairs(parts) do
										e.Transparency = 0

									end
								end
							end

						end
					end)
				end
				
			end

			for i,inst in pairs(game.Workspace:GetDescendants()) do
				if inst.Name == "ClientOpen"then
					RoomName = inst.Parent:GetAttribute("ParentRoom") 
					local ConnectionCooldown = false
					local r = game["Run Service"].RenderStepped:Connect(function()
if ConnectionCooldown == false then
						if inst:IsDescendantOf(workspace) then			
							if inst.Parent.Name == "Door" and DoorReach == true and game.Players.LocalPlayer:DistanceFromCharacter(inst.Parent.Door.Position) < 25 or inst.Parent.Name == "Door" and DoorReach == false and game.Players.LocalPlayer:DistanceFromCharacter(inst.Parent.Door.Position) < 4 then
								inst:FireServer()
							end
						end
						ConnectionCooldown = true
						task.wait(0.1)
						ConnectionCooldown = false
						end
					end)
					game.Workspace.CurrentRooms.ChildRemoved:Connect(function(child)
						if RoomName == child.Name then
							r:Disconnect()
						end
					end)
				end
			end

			local AntiConnection = game.Workspace.CurrentRooms.DescendantAdded:Connect(function(inst)
				inst:SetAttribute("ParentRoom",GetRoom(inst))
				
				if inst.Name == "Snare" then


					local r = game["Run Service"].RenderStepped:Connect(function()
						if inst:FindFirstChild("Hitbox") then
							if SnareESP == true then
								inst:WaitForChild("Snare").Roots.Transparency = 1
								inst:WaitForChild("Snare").SnareBase.Transparency = 1
								inst:WaitForChild("Void").Transparency = 0	
								inst:WaitForChild("Void").Color = Color3.fromRGB(76, 67, 55)
								if tonumber(inst.Parent.Parent.Name) >= tonumber(Player:GetAttribute("CurrentRoom")) then
									esp(inst,inst.Void,"Snare", snarecolor,true,false)
								end		 
							end
							if AntiSnare == true then
								inst.Hitbox.CanTouch = false
								if inst.Hitbox:FindFirstChild("TouchInterest") then
									inst.Hitbox.TouchInterest:Destroy()
								end
							end
						end
					end)
					inst.Destroying:Wait()
					r:Disconnect()	
				end
				if inst.Name == "LibraryHintPaper" and Toggles.ItemESP.Value then
					esp(inst,inst.Handle,"Library Paper",itemcolor,false,false)
				end
				if inst:FindFirstChild("HiddenPlayer") then
					RoomName = inst:GetAttribute("ParentRoom")
					local parts = {}
					for i,part in pairs(inst:GetDescendants()) do
						if part:IsA("BasePart") then
							if part.Transparency == 0 then
								table.insert(parts,part)
							end
						end
						task.wait()
					end


local ConnectionCooldown = false
					local r = game["Run Service"].RenderStepped:Connect(function()
if ConnectionCooldown == false then
						ConnectionCooldown = true
						if inst:FindFirstChild("HiddenPlayer") then
							if inst.HiddenPlayer.Value == Character and TransparentCloset == true then
								for i,e in pairs(parts) do
									e.Transparency = TransparentClosetNumber

								end

							else
								for i,e in pairs(parts) do
									e.Transparency = 0

								end
							end
						end
						task.wait(0.1)
						ConnectionCooldown = false
						end
					end)

					game.Workspace.CurrentRooms.ChildRemoved:Connect(function(child)
						if RoomName == child.Name then
							r:Disconnect()
						end
					end)
				end
				if inst:IsA("ProximityPrompt") then
					local connections = {}
					RoomName = inst:GetAttribute("ParentRoom")
					local ConnectionCooldown = false
					connections.connection = game["Run Service"].RenderStepped:Connect(function()
						if inst ~= nil and inst:IsDescendantOf(workspace) and ConnectionCooldown == false then
							ConnectionCooldown = true
							if inst:GetAttribute("OldHoldTime") == nil then
								inst:SetAttribute("OldHoldTime",inst.HoldDuration)
							end
							if inst:GetAttribute("PromptClip") == nil then
								inst:SetAttribute("PromptClip",inst.RequiresLineOfSight)
							end
							if interact == true then
								inst.HoldDuration = 0
							else
								inst.HoldDuration = inst:GetAttribute("OldHoldTime")
							end
							if inst:GetAttribute("OldDistance") == nil then
								inst:SetAttribute("OldDistance",inst.MaxActivationDistance)
							end
							if maxinteract == true then
								inst.MaxActivationDistance = ReachDistance
							else
								inst.MaxActivationDistance = inst:GetAttribute("OldDistance")
							end
							if ito == true then
								inst.RequiresLineOfSight = false
							else
								inst.RequiresLineOfSight = inst:GetAttribute("PromptClip")
							end


							local ParentObject = inst.Parent

							local ParentDistance = 0
							if ParentObject:IsA("Model") then
								ParentDistance = Player:DistanceFromCharacter(ParentObject.WorldPivot.Position)
							elseif ParentObject:IsA("BasePart") then
								ParentDistance = Player:DistanceFromCharacter(ParentObject.Position)
							end

							if Toggles.AA.Value or Options.AutoInteract:GetState() == true then

								if inst.Parent.Name ~= "KeyObtainFake" and not string.find(inst.Parent.Parent.Name,"Fake") and not string.find(inst.Name,"RiftPrompt") and inst.Name ~= "HidePrompt" and ParentDistance < 15 then

									if inst.Name == "PropPrompt" and inst.Parent.Prop:GetAttribute("Hint") ~= inst.Parent:GetAttribute("Hint") then

										forcefireproximityprompt(inst)

									end



								end

							end

							task.wait(0.1)
							ConnectionCooldown = false
						end

					end)
					inst:GetPropertyChangedSignal("Parent"):Connect(function()
						connections.connection:Disconnect()
					end)
					game.Workspace.CurrentRooms.ChildRemoved:Connect(function(child)
						if RoomName == child.Name then
							connections.connection:Disconnect()
						end
					end)



				end






				if DupeESP == true then
					ApplyDupeESP(inst)
				end


				if inst.Name == "GrumbleRig" and inst:FindFirstChild("Root") and GrumbleESP == true then
					esp(inst,inst.Root,"Grumble", grumblecolor,false,false)






				elseif inst.Name == "Lava" and Toggles.AntiLava.Value then
					inst.CanTouch = false
				elseif inst.Name == "ScaryWall" and Toggles.AntiLava.Value then
					for i,part in pairs(inst:GetDescendants()) do
						if part:IsA("BasePart") then
							part.CanTouch = false
							part.CanCollide = false
						end
					end
				elseif inst:IsA("Model") and inst.Name == "Figure" and Toggles.GodmodeFigure.Value or inst:IsA("Model") and inst.Name == "FigureRagdoll" and Toggles.GodmodeFigure.Value then
					for i, v in pairs(inst:GetDescendants()) do
						if v:IsA("BasePart") then
							if not v:GetAttribute("Clip") then v:SetAttribute("Clip", v.CanCollide) end

							v.CanTouch = false
							v.CanCollide = true
						end
					end	

				elseif inst.Name == "DoorFake" or inst.Name == "FakeDoor"  then
					if AntiDupe == true then
						DisableDupe(inst)
					end
					if DupeESP == true then
						ApplyDupeESP(inst)
					end

				elseif inst.Name == "SideroomSpace" and AntiVacuum == true then
					DisableDupe(inst)




				elseif inst.Name == "ClientOpen"then
					RoomName = inst.Parent:GetAttribute("ParentRoom") 
					local ConnectionCooldown = false
					local r = game["Run Service"].RenderStepped:Connect(function()
						
						if ConnectionCooldown == false then
							if inst:IsDescendantOf(workspace) then			
								if inst.Parent.Name == "Door" and DoorReach == true and game.Players.LocalPlayer:DistanceFromCharacter(inst.Parent.Door.Position) < 25 or inst.Parent.Name == "Door" and DoorReach == false and game.Players.LocalPlayer:DistanceFromCharacter(inst.Parent.Door.Position) < 4 then
									inst:FireServer()
								end
							end
							ConnectionCooldown = true
							task.wait(0.1)
							ConnectionCooldown = false
						end
					end)
					game.Workspace.CurrentRooms.ChildRemoved:Connect(function(child)
						if RoomName == child.Name then
							r:Disconnect()
						end
					end)

				elseif inst.Name == "Door" and inst:FindFirstChild("Door")

				then


					if doors == true then
						local CurrentRoom = tonumber(inst.Parent.Name)-1
						if inst.Name == "Door" and inst:FindFirstChild("Door") then

							local knob = inst.Door:FindFirstChild("Knob") or inst.Door
							if inst.Parent.Name == "49" and Floor == "Hotel" or inst.Parent.Name == "49" and Floor == "Fools" or inst.Parent.Name == "50" and Floor == "Hotel" or inst.Parent.Name == "50" and Floor == "Fools" then

								if inst.Parent:GetAttribute("RequiresKey") == true then
									esp(inst,inst.Hidden,"Door", doorcolor,true,true)
								else
									esp(inst,inst.Hidden,"Door", doorcolor,true,true)
								end
							else

								if inst.Parent:GetAttribute("RequiresKey") == true then

									esp(inst.Door,knob,"Door", doorcolor,true,true)
								else
									esp(inst.Door,knob,"Door", doorcolor,true,true)
								end
							end

						end


					end


				elseif inst.Name == "Snare" and SnareESP == true

				then




				elseif inst.Name == "GoldPile" and inst.PrimaryPart ~= nil and gold == true then
					task.wait(0.5)
					esp(inst,inst.PrimaryPart,"Gold ["..inst:GetAttribute("GoldValue").."]", goldcolor,false,false)


				elseif table.find(Items,inst.Name) and inst:FindFirstChild("Main") and ItemESP == true or table.find(Items2,inst.Name) and inst:FindFirstChild("Main") and ItemESP == true then
					esp(inst,inst:WaitForChild("Main") or inst,inst.Name, itemcolor,true,false)

				elseif inst.Name == "LiveBreakerPolePickup" and breakers == true then
					esp(inst,inst.Base,"Breaker", breakercolor,true,false)

				elseif inst.Name == "Lava" and Toggles.AntiLava.Value then
					inst.CanTouch = false
				elseif inst.Name == "ScaryWall" and Toggles.AntiLava.Value then
					for i,part in pairs(inst:GetDescendants()) do
						if part:IsA("BasePart") then
							part.CanTouch = false
							part.CanCollide = false
						end
					end
				elseif inst:IsA("Model") and inst.Name == "Figure" and Toggles.GodmodeFigure.Value or inst:IsA("Model") and inst.Name == "FigureRagdoll" and Toggles.GodmodeFigure.Value then
					for i, v in pairs(inst:GetDescendants()) do
						if v:IsA("BasePart") then
							if not v:GetAttribute("Clip") then v:SetAttribute("Clip", v.CanCollide) end

							v.CanTouch = false
							v.CanCollide = true
						end
					end	
				end
				if inst.Name == "FigureRig" and inst:FindFirstChild("Torso") or inst.Name == "Figure" and inst:FindFirstChild("Torso") or inst.Name == "FigureRagdoll" and inst:FindFirstChild("Torso") then
					Figure = inst
					if FigureESP == true then
						esp(inst,inst.Torso,"Figure", entitycolor,true,false)
					end

				end

				if inst:FindFirstChild("HiddenPlayer") then
					RoomName = inst:GetAttribute("ParentRoom")
					local parts = {}
					for i,part in pairs(inst:GetDescendants()) do
						if part:IsA("BasePart") then
							if part.Transparency == 0 then
								table.insert(parts,part)
							end
						end
						task.wait()
					end



					inst:FindFirstChild("HiddenPlayer"):GetPropertyChangedSignal("Value"):Connect(function()
						if ConnectionCooldown == false then
							ConnectionCooldown = true
							if inst:FindFirstChild("HiddenPlayer") then
								if inst.HiddenPlayer.Value == Character and TransparentCloset == true then
									for i,e in pairs(parts) do
										e.Transparency = TransparentClosetNumber

									end

								else
									for i,e in pairs(parts) do
										e.Transparency = 0

									end
								end
							end

						end
					end)
				end
				if inst:IsA("ProximityPrompt") then
					local connections = {}
					RoomName = inst:GetAttribute("ParentRoom")
					local ConnectionCooldown = false
					connections.connection = game["Run Service"].RenderStepped:Connect(function()
						if inst ~= nil and inst:IsDescendantOf(workspace) and ConnectionCooldown == false then
							ConnectionCooldown = true
							if inst:GetAttribute("OldHoldTime") == nil then
								inst:SetAttribute("OldHoldTime",inst.HoldDuration)
							end
							if inst:GetAttribute("PromptClip") == nil then
								inst:SetAttribute("PromptClip",inst.RequiresLineOfSight)
							end
							if interact == true then
								inst.HoldDuration = 0
							else
								inst.HoldDuration = inst:GetAttribute("OldHoldTime")
							end
							if inst:GetAttribute("OldDistance") == nil then
								inst:SetAttribute("OldDistance",inst.MaxActivationDistance)
							end
							if maxinteract == true then
								inst.MaxActivationDistance = ReachDistance
							else
								inst.MaxActivationDistance = inst:GetAttribute("OldDistance")
							end
							if ito == true then
								inst.RequiresLineOfSight = false
							else
								inst.RequiresLineOfSight = inst:GetAttribute("PromptClip")
							end

						
						local ParentObject = inst.Parent
					
						local ParentDistance = 0
						if ParentObject:IsA("Model") then
							ParentDistance = Player:DistanceFromCharacter(ParentObject.WorldPivot.Position)
						elseif ParentObject:IsA("BasePart") then
							ParentDistance = Player:DistanceFromCharacter(ParentObject.Position)
						end

						if Toggles.AA.Value or Options.AutoInteract:GetState() == true then

							if inst.Parent.Name ~= "KeyObtainFake" and not string.find(inst.Parent.Parent.Name,"Fake") and not string.find(inst.Name,"RiftPrompt") and inst.Name ~= "HidePrompt" and ParentDistance < 15 then

								if inst.Name == "PropPrompt" and inst.Parent.Prop:GetAttribute("Hint") ~= inst.Parent:GetAttribute("Hint") then
									
									forcefireproximityprompt(inst)
									
									end



							end
							
						end

task.wait(0.1)
ConnectionCooldown = false
end

					end)
					inst:GetPropertyChangedSignal("Parent"):Connect(function()
						connections.connection:Disconnect()
					end)
					game.Workspace.CurrentRooms.ChildRemoved:Connect(function(child)
						if RoomName == child.Name then
							connections.connection:Disconnect()
						end
					end)



				end
				if inst.Name == "DoorFake" and AntiDupe == true or inst.Name == "FakeDoor" and AntiDupe == true  then
					DisableDupe(inst)

				elseif inst.Name == "SideroomSpace" and AntiVacuum == true then
					DisableDupe(inst)

				elseif inst.Name == "GiggleCeiling" then
					if Options.NotifyMonsters.Value["Giggle"] then
						Notify({Title = "ENTITIES",Description = EntityAlliases["Giggle"] .. " has spawned.",Reason = "Make sure not to walk under it!",NotificationType = "WARNING",Time = inst,Image = EntityIcons["Giggle"]})
						Sound()
					end
					if Toggles.AntiGiggle.Value then
						inst:WaitForChild("Hitbox", 5).CanTouch = false
					end




				elseif inst.Name == "Lava" and Toggles.AntiLava.Value then
					inst.CanTouch = false
				elseif inst.Name == "ScaryWall" and Toggles.AntiLava.Value then
					for i,part in pairs(inst:GetDescendants()) do
						if part:IsA("BasePart") then
							part.CanTouch = false
							part.CanCollide = false
						end
					end
				elseif inst.Name == "MouseHole" and Toggles.ToggleMouseESP.Value then
					inst:WaitForChild("Darkness")
					esp(inst,inst.Darkness,"Louie [Mouse]", louiecolor,true,false)
					
					
				elseif table.find(Items,inst.Name) and Toggles.ItemESP.Value or table.find(Items2,inst.Name) and Toggles.ItemESP.Value then
					
					
						esp(inst,inst:WaitForChild("Main",99999),inst.Name, itemcolor,true,false)	
					
				elseif inst:IsA("Model") and inst.Name == "Figure" and Toggles.GodmodeFigure.Value or inst:IsA("Model") and inst.Name == "FigureRagdoll" and Toggles.GodmodeFigure.Value then
					for i, v in pairs(inst:GetDescendants()) do
						if v:IsA("BasePart") then
							if not v:GetAttribute("Clip") then v:SetAttribute("Clip", v.CanCollide) end

							v.CanTouch = false
							v.CanCollide = true
						end
					end	


				elseif inst.Name == "ChestBox" and inst:FindFirstChild("Main") and Toggles.ChestESP.Value or inst.Name == "ChestBoxLocked" and inst:FindFirstChild("Main") and Toggles.ChestESP.Value then
					local Text = "Chest"
					if inst:GetAttribute("Locked") == true then
						Text = "Locked Chest"
					end
					esp(inst,inst.Main,Text, chestcolor,true,false)	
					
				elseif inst.Name == "GloomPile" then
					for _, gloomEgg in pairs(inst:GetDescendants()) do
						if gloomEgg.Name == "Egg" then
							gloomEgg.CanTouch = not Toggles.AntiGloomEgg.Value
						end
					end

				elseif inst.Name == "DoorFake" or inst.Name == "FakeDoor" then
					if AntiDupe == true then
						DisableDupe(inst)
					end
					if DupeESP == true then
						ApplyDupeESP(inst)
					end
				elseif inst.Name == "TriggerEventCollision" then

					if BypassSeek == true and Floor == "Fools" or BypassSeek == true and OldHotel == true then

						DisableSeekFools()
					end	
				elseif inst.Name == "SideroomSpace" then
					if AntiVacuum == true then
						DisableDupe(inst)
					end
					if DupeESP == true then
						ApplyDupeESP(inst)
					end

					if inst.Name == "GoldPile" and inst.PrimaryPart ~= nil and gold == true then
						task.wait(0.5)
						esp(inst,inst.PrimaryPart,"Gold ["..inst:GetAttribute("GoldValue").."]", goldcolor,false,false)

					elseif inst.Name == "Snare" and inst.PrimaryPart ~= nil and SnareESP == true
					then
						esp(inst,inst.PrimaryPart,"Snare", snarecolor,true,false)

					elseif inst.Name == "Ladder" and inst.PrimaryPart ~= nil
					then
						if Ladders == true then
							esp(inst,inst.PrimaryPart,"Ladder", laddercolor,true,false)
						end
						if MinesBypass == true then








							-- Ladder ESP

						else
							if workspace:FindFirstChild("_internal_mspaint_acbypassprogress") then workspace:FindFirstChild("_internal_mspaint_acbypassprogress"):Destroy() end



							local Bypassed = true
							if Bypassed == true then
								RemotesFolder.ClimbLadder:FireServer()
								Bypassed = false


							end
						end















					elseif inst.Name == "Door" and inst:FindFirstChild("Door")

					then


						if doors == true then
							if inst.Name == "Door" and inst:FindFirstChild("Door") then
								local CurrentRoom = tonumber(inst.Parent.Name)-1



								local knob = inst.Door:FindFirstChild("Knob") or inst.Door
								if inst.Parent.Name == "49" and Floor == "Hotel" or inst.Parent.Name == "49" and Floor == "Fools" or inst.Parent.Name == "50" and Floor == "Hotel" or inst.Parent.Name == "50" and Floor == "Fools" then

									if inst.Parent:GetAttribute("RequiresKey") == true then
										esp(inst,inst.Hidden,"Door", doorcolor,true,true)
									else
										esp(inst,inst.Hidden,"Door", doorcolor,true,true)
									end
								else

									if inst.Parent:GetAttribute("RequiresKey") == true then

										esp(inst.Door,knob,"Door", doorcolor,true,true)
									else
										esp(inst.Door,knob,"Door", doorcolor,true,true)
									end
								end
							end


						end

					elseif inst.Name == "MinesGateButton" and GeneratorESP == true then
						esp(inst,inst.MainPart,"Gate Button", generatorcolor,true,false)
					elseif inst.Name == "LeverForGate" and inst:FindFirstChild("Main") and levers == true
					then
						esp(inst.Main,inst.Main,"Gate Lever", levercolor,true,false)



					elseif inst.Name == "Wardrobe" and inst:FindFirstChild("Main") and closets == true
					then
						esp(inst,inst.Main,"Closet", closetcolor,true,false)

					elseif inst.Name == "GiggleCeiling"then

						if EntityESP == true then
							esp(inst,inst:WaitForChild("Root"),"Giggle",entitycolor,true,false)
						end
					elseif inst.Name == "Toolshed" and inst:FindFirstChild("Main") and closets == true
					then
						esp(inst,inst.Main,"Closet", closetcolor,true,false)	
					elseif inst.Name == "Rooms_Locker" and inst:FindFirstChild("Base") and closets == true
					then
						esp(inst,inst.Base,"Locker", closetcolor,true,false)

					else	if inst.Name == "Rooms_Locker_Fridge" and inst:FindFirstChild("Base") and closets == true
						then
							esp(inst,inst.Base,"Locker", closetcolor,true,false)

						elseif inst.Name == "RetroWardrobe" and inst:FindFirstChild("Main") and closets == true
						then
							esp(inst,inst.Main,"Closet", closetcolor,true,false)
						elseif inst.Name == "Bed" and inst:FindFirstChild("Main") and closets == true
						then
							esp(inst,inst.Main,"Bed", closetcolor,true,false)
						elseif inst.Name == "Locker_Large" and inst:FindFirstChild("Main") and closets == true
						then
							esp(inst,inst.Main,"Locker", closetcolor,true,false)

						elseif inst.Name == "MinesAnchor" and inst:FindFirstChild("Sign") and AnchorESP == true then
							esp(inst,inst.PrimaryPart,"Anchor".. " "..inst.Sign.TextLabel.Text, grumblecolor,false,false)

						elseif inst.Name == "DoorFake" and AntiDupe == true or inst.Name == "FakeDoor" and AntiDupe == true  then
							DisableDupe(inst)	

						elseif inst.Name == "Backdoor_Wardrobe" and inst:FindFirstChild("Main") and closets == true
						then
							esp(inst,inst.Main,"Closet", closetcolor,true,false)
						elseif inst.Name == "DoorFake" or inst.Name == "FakeDoor" or inst.Name == "SideroomSpace" then
							if DupeESP == true then
								ApplyDupeESP(inst)
							end
						elseif inst.Name == "KeyObtain" and keys == true  then
							inst:WaitForChild("Hitbox")
								if inst.Hitbox:FindFirstChild("Key") then
									esp(inst,inst.Hitbox.Key,"Door Key".." ["..tonumber(inst:GetAttribute("ParentRoom")+DoorsDifference+1).."]", keycolor,true,false)
								elseif inst.Hitbox:FindFirstChild("KeyHitbox") then
									esp(inst,inst.Hitbox.KeyHitbox,"Door Key".." ["..tonumber(inst:GetAttribute("ParentRoom")+DoorsDifference+1).."]", keycolor,true,false)
								end
							
						elseif inst.Name == "ElectricalKeyObtain" and  keys == true  then
							inst:WaitForChild("Hitbox")
						
								if inst.Hitbox:FindFirstChild("Key") then
									esp(inst,inst.Hitbox.Key,"Electrical Key", keycolor,true,false)
								elseif inst.Hitbox:FindFirstChild("KeyHitbox") then
									esp(inst,inst.Hitbox.KeyHitbox,"Electrical Key", keycolor,true,false)
								end
							

						elseif inst.Name == "FuseObtain" and  FuseESP == true then
							if inst:FindFirstChild("Hitbox") then

								esp(inst,inst.Hitbox,"Fuse", fusecolor,true,false)

							end
						elseif inst.Name == "DoorFake" or inst.Name == "FakeDoor" then
							if AntiDupe == true then
								DisableDupe(inst)
							end
							if DupeESP == true then
								ApplyDupeESP(inst)
							end
						elseif inst.Name == "Seek_Arm" and AntiSeekObstructions == true then
							if inst.Name == "Seek_Arm" then
								for i,a in pairs(inst.Parent.Parent:GetDescendants()) do
									if a:IsA("BasePart") and a.Parent.Name ~= "Door" then
										a.CanTouch = false
									end
								end
							end

						elseif inst.Name == "MinesGenerator" and GeneratorESP == true then

							esp(inst,inst:WaitForChild("GeneratorMain"),"Generator", generatorcolor,true,false)




						elseif inst.Name == "GrumbleRig" and inst:FindFirstChild("Root") and GrumbleESP == true then
							esp(inst,inst.Root,"Grumble", grumblecolor,false,false)

						elseif inst.Name == "LiveHintBook" and books == true then
							esp(inst,inst.Base,"Book", bookcolor,true,false)




						elseif inst.Name == "FigureRig" and inst:FindFirstChild("Torso") or inst.Name == "Figure" and inst:FindFirstChild("Torso") or inst.Name == "FigureRagdoll" and inst:FindFirstChild("Torso") then
							Figure = inst
							if FigureESP == true then
								esp(inst,inst.Torso,"Figure", entitycolor,true,false)
							end





						elseif inst.Name == "LiveBreakerPolePickup" and breakers == true then
							esp(inst,inst.Base,"Breaker", breakercolor,true,false)







						elseif inst.Name == "JeffTheKiller" and Toggles.AntiJeff.Value then
							DisableJeff()

						elseif inst.Name == "TriggerEventCollision" and Toggles.BypassSeek2.Value and OldHotel == true then
							DisableSeekFools()

						elseif inst.Name == "TimerLever" and inst:FindFirstChild("Main") then

							if TimerLevers == true then
								esp(inst,inst.Main,"Time Lever", timelevercolor,true,false)
								local r = game["Run Service"].RenderStepped:Connect(function()
									if inst then
										if not inst:FindFirstChild("Main") then
											inst:SetAttribute("ESP",false)
										end
									end
								end)

								game.Workspace.CurrentRooms.ChildRemoved:Connect(function(child)
									if inst:GetAttribute("ParentRoom") == child.Name then
										r:Disconnect()
									end
								end)



							end


						end
					end

				end
				
				task.wait(0.25)
				
				task.wait(0.01)
				if inst.Name == "Snare" then


					local r = game["Run Service"].RenderStepped:Connect(function()
						if inst:FindFirstChild("Hitbox") then
							if SnareESP == true then
								inst:WaitForChild("Snare").Roots.Transparency = 1
								inst:WaitForChild("Snare").SnareBase.Transparency = 1
								inst:WaitForChild("Void").Transparency = 0	
								inst:WaitForChild("Void").Color = Color3.fromRGB(76, 67, 55)
								if tonumber(inst.Parent.Parent.Name) >= tonumber(Player:GetAttribute("CurrentRoom")) then
									esp(inst,inst.Void,"Snare", snarecolor,true,false)
								end		 
							end
							if AntiSnare == true then
								inst.Hitbox.CanTouch = false
								if inst.Hitbox:FindFirstChild("TouchInterest") then
									inst.Hitbox.TouchInterest:Destroy()
								end
							end
						end
					end)
					inst.Destroying:Wait()
					r:Disconnect()	
				end
				if inst.Name == "LibraryHintPaper" and Toggles.ItemESP.Value then
					esp(inst,inst.Handle,"Library Paper",itemcolor,false,false)
				end
				if inst:FindFirstChild("HiddenPlayer") then
					RoomName = inst:GetAttribute("ParentRoom")
					local parts = {}
					for i,part in pairs(inst:GetDescendants()) do
						if part:IsA("BasePart") then
							if part.Transparency == 0 then
								table.insert(parts,part)
							end
						end
						task.wait()
					end


					local ConnectionCooldown = false
					local r = game["Run Service"].RenderStepped:Connect(function()
						if ConnectionCooldown == false then
							ConnectionCooldown = true
							if inst:FindFirstChild("HiddenPlayer") then
								if inst.HiddenPlayer.Value == Character and TransparentCloset == true then
									for i,e in pairs(parts) do
										e.Transparency = TransparentClosetNumber

									end

								else
									for i,e in pairs(parts) do
										e.Transparency = 0

									end
								end
							end
							task.wait(0.1)
							ConnectionCooldown = false
						end
					end)

					game.Workspace.CurrentRooms.ChildRemoved:Connect(function(child)
						if RoomName == child.Name then
							r:Disconnect()
						end
					end)
				end
				if inst:IsA("ProximityPrompt") then
					local connections = {}
					RoomName = inst:GetAttribute("ParentRoom")
					local ConnectionCooldown = false
					connections.connection = game["Run Service"].RenderStepped:Connect(function()
						if inst ~= nil and inst:IsDescendantOf(workspace) and ConnectionCooldown == false then
							ConnectionCooldown = true
							if inst:GetAttribute("OldHoldTime") == nil then
								inst:SetAttribute("OldHoldTime",inst.HoldDuration)
							end
							if inst:GetAttribute("PromptClip") == nil then
								inst:SetAttribute("PromptClip",inst.RequiresLineOfSight)
							end
							if interact == true then
								inst.HoldDuration = 0
							else
								inst.HoldDuration = inst:GetAttribute("OldHoldTime")
							end
							if inst:GetAttribute("OldDistance") == nil then
								inst:SetAttribute("OldDistance",inst.MaxActivationDistance)
							end
							if maxinteract == true then
								inst.MaxActivationDistance = ReachDistance
							else
								inst.MaxActivationDistance = inst:GetAttribute("OldDistance")
							end
							if ito == true then
								inst.RequiresLineOfSight = false
							else
								inst.RequiresLineOfSight = inst:GetAttribute("PromptClip")
							end


							local ParentObject = inst.Parent

							local ParentDistance = 0
							if ParentObject:IsA("Model") then
								ParentDistance = Player:DistanceFromCharacter(ParentObject.WorldPivot.Position)
							elseif ParentObject:IsA("BasePart") then
								ParentDistance = Player:DistanceFromCharacter(ParentObject.Position)
							end

							if Toggles.AA.Value or Options.AutoInteract:GetState() == true then

								if inst.Parent.Name ~= "KeyObtainFake" and not string.find(inst.Parent.Parent.Name,"Fake") and not string.find(inst.Name,"RiftPrompt") and inst.Name ~= "HidePrompt" and ParentDistance < 15 then

									if inst.Name == "PropPrompt" and inst.Parent.Prop:GetAttribute("Hint") ~= inst.Parent:GetAttribute("Hint") then

										forcefireproximityprompt(inst)

									end



								end

							end

							task.wait(0.1)
							ConnectionCooldown = false
						end

					end)
					inst:GetPropertyChangedSignal("Parent"):Connect(function()
						connections.connection:Disconnect()
					end)
					game.Workspace.CurrentRooms.ChildRemoved:Connect(function(child)
						if RoomName == child.Name then
							connections.connection:Disconnect()
						end
					end)



				end






				if DupeESP == true then
					ApplyDupeESP(inst)
				end


				if inst.Name == "GrumbleRig" and inst:FindFirstChild("Root") and GrumbleESP == true then
					esp(inst,inst.Root,"Grumble", grumblecolor,false,false)






				elseif inst.Name == "Lava" and Toggles.AntiLava.Value then
					inst.CanTouch = false
				elseif inst.Name == "ScaryWall" and Toggles.AntiLava.Value then
					for i,part in pairs(inst:GetDescendants()) do
						if part:IsA("BasePart") then
							part.CanTouch = false
							part.CanCollide = false
						end
					end
				elseif inst:IsA("Model") and inst.Name == "Figure" and Toggles.GodmodeFigure.Value or inst:IsA("Model") and inst.Name == "FigureRagdoll" and Toggles.GodmodeFigure.Value then
					for i, v in pairs(inst:GetDescendants()) do
						if v:IsA("BasePart") then
							if not v:GetAttribute("Clip") then v:SetAttribute("Clip", v.CanCollide) end

							v.CanTouch = false
							v.CanCollide = true
						end
					end	

				elseif inst.Name == "DoorFake" or inst.Name == "FakeDoor"  then
					if AntiDupe == true then
						DisableDupe(inst)
					end
					if DupeESP == true then
						ApplyDupeESP(inst)
					end

				elseif inst.Name == "SideroomSpace" and AntiVacuum == true then
					DisableDupe(inst)




				elseif inst.Name == "ClientOpen"then
					RoomName = inst.Parent:GetAttribute("ParentRoom") 
					local ConnectionCooldown = false
					local r = game["Run Service"].RenderStepped:Connect(function()

						if ConnectionCooldown == false then
							if inst:IsDescendantOf(workspace) then			
								if inst.Parent.Name == "Door" and DoorReach == true and game.Players.LocalPlayer:DistanceFromCharacter(inst.Parent.Door.Position) < 25 or inst.Parent.Name == "Door" and DoorReach == false and game.Players.LocalPlayer:DistanceFromCharacter(inst.Parent.Door.Position) < 4 then
									inst:FireServer()
								end
							end
							ConnectionCooldown = true
							task.wait(0.1)
							ConnectionCooldown = false
						end
					end)
					game.Workspace.CurrentRooms.ChildRemoved:Connect(function(child)
						if RoomName == child.Name then
							r:Disconnect()
						end
					end)

				elseif inst.Name == "Door" and inst:FindFirstChild("Door")

				then


					if doors == true then
						local CurrentRoom = tonumber(inst.Parent.Name)-1
						if inst.Name == "Door" and inst:FindFirstChild("Door") then

							local knob = inst.Door:FindFirstChild("Knob") or inst.Door
							if inst.Parent.Name == "49" and Floor == "Hotel" or inst.Parent.Name == "49" and Floor == "Fools" or inst.Parent.Name == "50" and Floor == "Hotel" or inst.Parent.Name == "50" and Floor == "Fools" then

								if inst.Parent:GetAttribute("RequiresKey") == true then
									esp(inst,inst.Hidden,"Door", doorcolor,true,true)
								else
									esp(inst,inst.Hidden,"Door", doorcolor,true,true)
								end
							else

								if inst.Parent:GetAttribute("RequiresKey") == true then

									esp(inst.Door,knob,"Door", doorcolor,true,true)
								else
									esp(inst.Door,knob,"Door", doorcolor,true,true)
								end
							end

						end


					end


				elseif inst.Name == "Snare" and SnareESP == true

				then




				elseif inst.Name == "GoldPile" and inst.PrimaryPart ~= nil and gold == true then
					task.wait(0.5)
					esp(inst,inst.PrimaryPart,"Gold ["..inst:GetAttribute("GoldValue").."]", goldcolor,false,false)


				elseif table.find(Items,inst.Name) and inst:FindFirstChild("Main") and ItemESP == true or table.find(Items2,inst.Name) and inst:FindFirstChild("Main") and ItemESP == true then
					esp(inst,inst:WaitForChild("Main") or inst,inst.Name, itemcolor,true,false)

				elseif inst.Name == "LiveBreakerPolePickup" and breakers == true then
					esp(inst,inst.Base,"Breaker", breakercolor,true,false)

				elseif inst.Name == "Lava" and Toggles.AntiLava.Value then
					inst.CanTouch = false
				elseif inst.Name == "ScaryWall" and Toggles.AntiLava.Value then
					for i,part in pairs(inst:GetDescendants()) do
						if part:IsA("BasePart") then
							part.CanTouch = false
							part.CanCollide = false
						end
					end
				elseif inst:IsA("Model") and inst.Name == "Figure" and Toggles.GodmodeFigure.Value or inst:IsA("Model") and inst.Name == "FigureRagdoll" and Toggles.GodmodeFigure.Value then
					for i, v in pairs(inst:GetDescendants()) do
						if v:IsA("BasePart") then
							if not v:GetAttribute("Clip") then v:SetAttribute("Clip", v.CanCollide) end

							v.CanTouch = false
							v.CanCollide = true
						end
					end	
				end
				if inst.Name == "FigureRig" and inst:FindFirstChild("Torso") or inst.Name == "Figure" and inst:FindFirstChild("Torso") or inst.Name == "FigureRagdoll" and inst:FindFirstChild("Torso") then
					Figure = inst
					if FigureESP == true then
						esp(inst,inst.Torso,"Figure", entitycolor,true,false)
					end

				end

				if inst:FindFirstChild("HiddenPlayer") then
					RoomName = inst:GetAttribute("ParentRoom")
					local parts = {}
					for i,part in pairs(inst:GetDescendants()) do
						if part:IsA("BasePart") then
							if part.Transparency == 0 then
								table.insert(parts,part)
							end
						end
					end



					inst:FindFirstChild("HiddenPlayer"):GetPropertyChangedSignal("Value"):Connect(function()
						if ConnectionCooldown == false then
							ConnectionCooldown = true
							if inst:FindFirstChild("HiddenPlayer") then
								if inst.HiddenPlayer.Value == Character and TransparentCloset == true then
									for i,e in pairs(parts) do
										e.Transparency = TransparentClosetNumber

									end

								else
									for i,e in pairs(parts) do
										e.Transparency = 0

									end
								end
							end

						end
					end)
				end
				
				if inst.Name == "DoorFake" and AntiDupe == true or inst.Name == "FakeDoor" and AntiDupe == true  then
					DisableDupe(inst)

				elseif inst.Name == "SideroomSpace" and AntiVacuum == true then
					DisableDupe(inst)

				elseif inst.Name == "GiggleCeiling" then
					if Options.NotifyMonsters.Value["Giggle"] then
						Notify({Title = "ENTITIES",Description = EntityAlliases["Giggle"] .. " has spawned.",Reason = "Make sure not to walk under it!",NotificationType = "WARNING",Time = inst,Image = EntityIcons["Giggle"]})
						Sound()
					end
					if Toggles.AntiGiggle.Value then
						inst:WaitForChild("Hitbox", 5).CanTouch = false
					end




				elseif inst.Name == "Lava" and Toggles.AntiLava.Value then
					inst.CanTouch = false
				elseif inst.Name == "ScaryWall" and Toggles.AntiLava.Value then
					for i,part in pairs(inst:GetDescendants()) do
						if part:IsA("BasePart") then
							part.CanTouch = false
							part.CanCollide = false
						end
					end
				elseif inst.Name == "MouseHole" and Toggles.ToggleMouseESP.Value then
					inst:WaitForChild("Darkness")
					esp(inst,inst.Darkness,"Louie [Mouse]", louiecolor,true,false)


				elseif table.find(Items,inst.Name) and Toggles.ItemESP.Value or table.find(Items2,inst.Name) and Toggles.ItemESP.Value then


					esp(inst,inst:WaitForChild("Main",99999),inst.Name, itemcolor,true,false)	

				elseif inst:IsA("Model") and inst.Name == "Figure" and Toggles.GodmodeFigure.Value or inst:IsA("Model") and inst.Name == "FigureRagdoll" and Toggles.GodmodeFigure.Value then
					for i, v in pairs(inst:GetDescendants()) do
						if v:IsA("BasePart") then
							if not v:GetAttribute("Clip") then v:SetAttribute("Clip", v.CanCollide) end

							v.CanTouch = false
							v.CanCollide = true
						end
					end	


				elseif inst.Name == "GloomPile" then
					for _, gloomEgg in pairs(inst:GetDescendants()) do
						if gloomEgg.Name == "Egg" then
							gloomEgg.CanTouch = not Toggles.AntiGloomEgg.Value
						end
					end

				elseif inst.Name == "DoorFake" or inst.Name == "FakeDoor" then
					if AntiDupe == true then
						DisableDupe(inst)
					end
					if DupeESP == true then
						ApplyDupeESP(inst)
					end
				elseif inst.Name == "TriggerEventCollision" then

					if BypassSeek == true and Floor == "Fools" or BypassSeek == true and OldHotel == true then

						DisableSeekFools()
					end	
				elseif inst.Name == "SideroomSpace" then
					if AntiVacuum == true then
						DisableDupe(inst)
					end
					if DupeESP == true then
						ApplyDupeESP(inst)
					end

					if inst.Name == "GoldPile" and inst.PrimaryPart ~= nil and gold == true then
						task.wait(0.5)
						esp(inst,inst.PrimaryPart,"Gold ["..inst:GetAttribute("GoldValue").."]", goldcolor,false,false)

					elseif inst.Name == "Snare" and inst.PrimaryPart ~= nil and SnareESP == true
					then
						esp(inst,inst.PrimaryPart,"Snare", snarecolor,true,false)

					elseif inst.Name == "Ladder" and inst.PrimaryPart ~= nil
					then
						if Ladders == true then
							esp(inst,inst.PrimaryPart,"Ladder", laddercolor,true,false)
						end
						if MinesBypass == true then








							-- Ladder ESP

						else
							if workspace:FindFirstChild("_internal_mspaint_acbypassprogress") then workspace:FindFirstChild("_internal_mspaint_acbypassprogress"):Destroy() end



							local Bypassed = true
							if Bypassed == true then
								RemotesFolder.ClimbLadder:FireServer()
								Bypassed = false


							end
						end















					elseif inst.Name == "Door" and inst:FindFirstChild("Door")

					then


						if doors == true then
							if inst.Name == "Door" and inst:FindFirstChild("Door") then
								local CurrentRoom = tonumber(inst.Parent.Name)-1



								local knob = inst.Door:FindFirstChild("Knob") or inst.Door
								if inst.Parent.Name == "49" and Floor == "Hotel" or inst.Parent.Name == "49" and Floor == "Fools" or inst.Parent.Name == "50" and Floor == "Hotel" or inst.Parent.Name == "50" and Floor == "Fools" then

									if inst.Parent:GetAttribute("RequiresKey") == true then
										esp(inst,inst.Hidden,"Door", doorcolor,true,true)
									else
										esp(inst,inst.Hidden,"Door", doorcolor,true,true)
									end
								else

									if inst.Parent:GetAttribute("RequiresKey") == true then

										esp(inst.Door,knob,"Door", doorcolor,true,true)
									else
										esp(inst.Door,knob,"Door", doorcolor,true,true)
									end
								end
							end


						end

					elseif inst.Name == "MinesGateButton" and GeneratorESP == true then
						esp(inst,inst.MainPart,"Gate Button", generatorcolor,true,false)
					elseif inst.Name == "LeverForGate" and inst:FindFirstChild("Main") and levers == true
					then
						esp(inst.Main,inst.Main,"Gate Lever", levercolor,true,false)



					elseif inst.Name == "Wardrobe" and inst:FindFirstChild("Main") and closets == true
					then
						esp(inst,inst.Main,"Closet", closetcolor,true,false)

					elseif inst.Name == "GiggleCeiling"then

						if EntityESP == true then
							esp(inst,inst:WaitForChild("Root"),"Giggle",entitycolor,true,false)
						end
					elseif inst.Name == "Toolshed" and inst:FindFirstChild("Main") and closets == true
					then
						esp(inst,inst.Main,"Closet", closetcolor,true,false)	
					elseif inst.Name == "Rooms_Locker" and inst:FindFirstChild("Base") and closets == true
					then
						esp(inst,inst.Base,"Locker", closetcolor,true,false)

					else	if inst.Name == "Rooms_Locker_Fridge" and inst:FindFirstChild("Base") and closets == true
						then
							esp(inst,inst.Base,"Locker", closetcolor,true,false)

						elseif inst.Name == "RetroWardrobe" and inst:FindFirstChild("Main") and closets == true
						then
							esp(inst,inst.Main,"Closet", closetcolor,true,false)
						elseif inst.Name == "Bed" and inst:FindFirstChild("Main") and closets == true
						then
							esp(inst,inst.Main,"Bed", closetcolor,true,false)
						elseif inst.Name == "Locker_Large" and inst:FindFirstChild("Main") and closets == true
						then
							esp(inst,inst.Main,"Locker", closetcolor,true,false)

						elseif inst.Name == "MinesAnchor" and inst:FindFirstChild("Sign") and AnchorESP == true then
							esp(inst,inst.PrimaryPart,"Anchor".. " "..inst.Sign.TextLabel.Text, grumblecolor,false,false)

						elseif inst.Name == "DoorFake" and AntiDupe == true or inst.Name == "FakeDoor" and AntiDupe == true  then
							DisableDupe(inst)	

						elseif inst.Name == "Backdoor_Wardrobe" and inst:FindFirstChild("Main") and closets == true
						then
							esp(inst,inst.Main,"Closet", closetcolor,true,false)
						elseif inst.Name == "DoorFake" or inst.Name == "FakeDoor" or inst.Name == "SideroomSpace" then
							if DupeESP == true then
								ApplyDupeESP(inst)
							end
						elseif inst.Name == "KeyObtain" and keys == true  then
							inst:WaitForChild("Hitbox")
							if inst.Hitbox:FindFirstChild("Key") then
								esp(inst,inst.Hitbox.Key,"Door Key".." ["..tonumber(inst:GetAttribute("ParentRoom")+DoorsDifference+1).."]", keycolor,true,false)
							elseif inst.Hitbox:FindFirstChild("KeyHitbox") then
								esp(inst,inst.Hitbox.KeyHitbox,"Door Key".." ["..tonumber(inst:GetAttribute("ParentRoom")+DoorsDifference+1).."]", keycolor,true,false)
							end

						elseif inst.Name == "ElectricalKeyObtain" and  keys == true  then
							inst:WaitForChild("Hitbox")

							if inst.Hitbox:FindFirstChild("Key") then
								esp(inst,inst.Hitbox.Key,"Electrical Key", keycolor,true,false)
							elseif inst.Hitbox:FindFirstChild("KeyHitbox") then
								esp(inst,inst.Hitbox.KeyHitbox,"Electrical Key", keycolor,true,false)
							end


						elseif inst.Name == "FuseObtain" and  FuseESP == true then
							if inst:FindFirstChild("Hitbox") then

								esp(inst,inst.Hitbox,"Fuse", fusecolor,true,false)

							end
						elseif inst.Name == "DoorFake" or inst.Name == "FakeDoor" then
							if AntiDupe == true then
								DisableDupe(inst)
							end
							if DupeESP == true then
								ApplyDupeESP(inst)
							end
						elseif inst.Name == "Seek_Arm" and AntiSeekObstructions == true then
							if inst.Name == "Seek_Arm" then
								for i,a in pairs(inst.Parent.Parent:GetDescendants()) do
									if a:IsA("BasePart") and a.Parent.Name ~= "Door" then
										a.CanTouch = false
									end
								end
							end

						elseif inst.Name == "MinesGenerator" and GeneratorESP == true then

							esp(inst,inst:WaitForChild("GeneratorMain"),"Generator", generatorcolor,true,false)


						elseif inst.Name == "ChestBox" and inst:FindFirstChild("Main") and Toggles.ChestESP.Value or inst.Name == "ChestBoxLocked" and inst:FindFirstChild("Main") and Toggles.ChestESP.Value then
							local Text = "Chest"
							if inst:GetAttribute("Locked") == true then
								Text = "Locked Chest"
							end
							esp(inst,inst.Main,Text, chestcolor,true,false)

						elseif inst.Name == "GrumbleRig" and inst:FindFirstChild("Root") and GrumbleESP == true then
							esp(inst,inst.Root,"Grumble", grumblecolor,false,false)

						elseif inst.Name == "LiveHintBook" and books == true then
							esp(inst,inst.Base,"Book", bookcolor,true,false)




						elseif inst.Name == "FigureRig" and inst:FindFirstChild("Torso") or inst.Name == "Figure" and inst:FindFirstChild("Torso") or inst.Name == "FigureRagdoll" and inst:FindFirstChild("Torso") then
							Figure = inst
							if FigureESP == true then
								esp(inst,inst.Torso,"Figure", entitycolor,true,false)
							end





						elseif inst.Name == "LiveBreakerPolePickup" and breakers == true then
							esp(inst,inst.Base,"Breaker", breakercolor,true,false)







						elseif inst.Name == "JeffTheKiller" and Toggles.AntiJeff.Value then
							DisableJeff()

						elseif inst.Name == "TriggerEventCollision" and Toggles.BypassSeek2.Value and OldHotel == true then
							DisableSeekFools()

						elseif inst.Name == "TimerLever" and inst:FindFirstChild("Main") then

							if TimerLevers == true then
								esp(inst,inst.Main,"Time Lever", timelevercolor,true,false)
								local r = game["Run Service"].RenderStepped:Connect(function()
									if inst then
										if not inst:FindFirstChild("Main") then
											inst:SetAttribute("ESP",false)
										end
									end
								end)

								game.Workspace.CurrentRooms.ChildRemoved:Connect(function(child)
									if inst:GetAttribute("ParentRoom") == child.Name then
										r:Disconnect()
									end
								end)



							end


						end
					end

				end

			end)
			game.Workspace.CurrentRooms.ChildAdded:Connect(function(child)
				if child.Name == "51" then
					Player:SetAttribute("CurrentRoom","50")
					CurrentRoom = 50
				end

			end)
			local SpeedBypassConnection = Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
				if Humanoid.WalkSpeed > 21 then
					SpeedBypass()
				end
			end)







			local Connection4 = game.Workspace.ChildAdded:Connect(function(inst)
				if inst.Name == "GloombatSwarm" then
					EntityCounter += 1
					if Options.NotifyMonsters.Value["Gloombat Swarm"] then
						Notify({Title = "ENTITIES",Description = "A "..EntityAlliases["Gloombats"].." has spawned.",Reason = "Keep all light sources turned off for the next few rooms.",NotificationType = "WARNING",Time = inst,Image = EntityIcons["GloombatSwarm"]})
						Sound()
						if ChatNotifyMonsters == true then
							ChatNotify(EntityChatNotifyMessages["GloombatSwarm"])
						end
					end
				end
				if inst.Name == "BackdoorLookman" then
					EntityCounter += 1
					if Options.NotifyMonsters.Value["Lookman"] then
						Notify({Title = "ENTITIES",Description = EntityAlliases["BackdoorLookman"].." has spawned.",Reason = "Don't look at it!",NotificationType = "WARNING",Time = inst,Image = EntityIcons["BackdoorLookman"]})
						Sound()
						if ChatNotifyMonsters == true then
							ChatNotify(EntityChatNotifyMessages["BackdoorLookman"])
						end
					end
				end
				if inst.Name == "JeffTheKiller" then
					EntityCounter += 1
					if Options.NotifyMonsters.Value["Jeff The Killer"] then
						Notify({Title = "ENTITIES",Description = EntityAlliases["Jeff"] .. " spawned.",NotificationType = "WARNING",Time = inst,Image = EntityIcons["Jeff"]})
						Sound()
						if ChatNotifyMonsters == true then
							ChatNotify(EntityChatNotifyMessages["Jeff"])
						end
					end
					if Toggles.JeffESP.Value then

						esp(inst,inst.HumanoidRootPart,EntityAlliases["Jeff"], jeffcolor,false,false)
						
					end	
				end
				if inst.Name == "BananaPeel" then
					inst:SetAttribute("ParentRoom",tostring(CurrentRoom+1))
					if Toggles.AntiBananaPeel.Value then
						inst.CanTouch = false
					end
					Player:GetAttributeChangedSignal("CurrentRoom"):Connect(function()



						task.wait(0.25)
						if tonumber(Player:GetAttribute("CurrentRoom")) == tonumber(inst:GetAttribute("ParentRoom")) then
							if Toggles.BananaESP.Value
							then

								esp(inst,inst,"Banana", bananapeelcolor,true,false)	
							end
						else
							inst:SetAttribute("ESP",false)
						end
					end)




				end

			end)



			AddRoomsTab()
			AddMinesTab()
			AddBackdoorTab()
			AddFoolsTab()
			AddRetroTab()
		

			local count = 0
			local active1 = true
			game.Workspace.CurrentRooms.ChildAdded:Connect(function(child)

				if string.find(child:GetAttribute("RawName"), "Halt") or child:GetAttribute("Shade") then
					if Options.NotifyMonsters.Value["Halt"] then
						Notify({Title = "ENTITIES",Description = EntityAlliases["Halt"] .. " will spawn in the next room.",Image = EntityIcons["Halt"]})
						Sound()
						if ChatNotifyMonsters == true then
							ChatNotify(EntityChatNotifyMessages["Halt"])
						end
					end
					game.Workspace.CurrentRooms.ChildAdded:Wait()
					EntityCounter += 1
				end

			end)

			workspace.ChildAdded:Connect(function(child)

				DisableJeff()	
				if child.Name == "100" then
					Player:SetAttribute("CurrentRoom","100")
				end


				if CurrentRoom == 50 or CurrentRoom == 100 then
					if Toggles.GodmodeFigure.Value or Toggles.GodmodeFigure2.Value then
						for _, figure in pairs(workspace.CurrentRooms:GetDescendants()) do
							if figure:IsA("Model") and figure.Name == "Figure" or figure:IsA("Model") and figure.Name == "FigureRagdoll"  then

								for i, v in pairs(figure:GetDescendants()) do
									if v:IsA("BasePart") then
										v:SetNetworkOwner(Player)
										if OldHotel == true then
											game:GetService("TweenService"):Create(v,TweenInfo.new(5),{CFrame = CFrame.new(99999,99999,99999)}):Play()
										end
										if not v:GetAttribute("Clip") then v:SetAttribute("Clip", v.CanCollide) end

										v.CanTouch = false
										v.CanCollide = false
									end
								end


							end

						end
					end
				end






			end)

			game.Players.LocalPlayer.CharacterAdded:Connect(function(NewCharacter)

				CollisionClone:Destroy()
				CollisionClone2:Destroy()
				task.wait(0.25)
				Character = NewCharacter


				Collision = NewCharacter:WaitForChild("Collision")	
				MainWeld = Collision:WaitForChild("Weld")
				Collision.Position = HumanoidRootPart.Position

				CollisionClone = Collision:Clone()
				CollisionClone.Parent = NewCharacter
				CollisionClone.Name = ESPLibrary:GenerateRandomString()
				CollisionClone.Massless = true
				CollisionClone.CanQuery = false
				CollisionClone.CanCollide = false
				CollisionClone.Position = HumanoidRootPart.Position + Vector3.new(0,2.5,3)


				CollisionClone2 = Collision:Clone()
				CollisionClone2.Parent = NewCharacter
				CollisionClone2.Name = ESPLibrary:GenerateRandomString()
				CollisionClone2.Massless = true
				CollisionClone2.CanQuery = false
				CollisionClone2.CanCollide = false
				CollisionClone2.Position = HumanoidRootPart.Position


				Humanoid = NewCharacter:FindFirstChildOfClass("Humanoid")
				HumanoidRootPart = NewCharacter:WaitForChild("HumanoidRootPart")
				CollisionCrouch = Collision:FindFirstChild("CollisionCrouch") or nil
				if CollisionClone:FindFirstChild("CollisionCrouch") then
					CollisionClone.CollisionCrouch:Destroy()
				end
				if CollisionClone2:FindFirstChild("CollisionCrouch") then
					CollisionClone2.CollisionCrouch:Destroy()
				end	
				task.wait()
				if Toggles.NoAccell.Value then
					for i,part in pairs(NewCharacter:GetDescendants()) do
						if part:IsA("BasePart") then
							part.CustomPhysicalProperties = CustomPhysicalProperties
						end
					end
				end
				for i,room in pairs(game.Workspace:FindFirstChild("CurrentRooms"):GetChildren()) do
					if tonumber(room.Name) == (CurrentRoom) then
						Player:SetAttribute("CurrentRoom",room.Name)
					end
				end
				task.wait()
				SpeedBypass()	
			end)
			local FigureConnection = RunService.RenderStepped:Connect(function()
				if Figure ~= nil then
					if Toggles.GodmodeFigure.Value then
						if CurrentRoom == 50 or CurrentRoom == 100 then

							Collision.CanTouch = false


						else
							Collision.CanTouch = true
						end

					else
						Collision.CanTouch = true
					end
				end
			end)


			-- UI Settings

			TimeInRun = 0
			if not game.Workspace.CurrentRooms:FindFirstChild("2") then
				game.Workspace.CurrentRooms.ChildAdded:Connect(function(child)
					if child.Name == "2" then
						while task.wait(1) do
							TimeInRun += 1
						end
					end

				end)
			else
				while task.wait(1) do
					TimeInRun += 1
				end
			end

			Player:GetAttributeChangedSignal("GlitchLevel"):Connect(function()
				Player:SetAttribute("CurrentRoom",CurrentRoom)
				if tonumber(Player:GetAttribute("GlitchLevel")) ~= 0 then
					GlitchCounter += 1
				end
			end)

			local MenuTab = UISettings:AddRightTabbox('stuffz')
			local MenuSettings = MenuTab:AddTab("Settings")
			local Contributors = MenuTab:AddTab("Credits")

			-- I set NoUI so it does not show up in the keybinds menu

			MenuSettings:AddToggle('KeybindMenu', {
				Text = 'Show Keybind Menu',
				Default = false, -- Default value (true / false)
				Tooltip = 'Toggles the Keybind Menu, showing all Keybinds and their status.', -- Information shown when you hover over the toggle

				Callback = function(Value)
					Library.KeybindFrame.Visible = Value
				end

			})
			MenuSettings:AddToggle('KeepOnTeleport', {
				Text = 'Auto Execute',
				Default = false, -- Default value (true / false)
				Tooltip = 'Automatically execute '..ScriptName .. ' when you join a new game.', -- Information shown when you hover over the toggle,
				Callback = function(Value)
					if Value == true then
						queue_on_teleport(scriptlink)
					else
						queue_on_teleport("print('Auto Execute Cancelled')")
					end
				end,



			})




			Contributors:AddLabel("Jacob - Creator",true)





			Library.ShowCustomCursor = false


			MenuSettings:AddToggle("CustomCursor", {
				Text = "Show Custom Cursor",
				Default = true,
				Tooltip= "Show the Library's Custom Cursor",
				Callback = function(value) Library.ShowCustomCursor = value end
			})
			MenuSettings:AddToggle("ShowTopText", {
				Text = "Show Top Stats",
				Default = false,
				Tooltip = "Toggles the Text at the top of the screen",
				
			})

			MenuSettings:AddLabel('GUI Toggle Keybind'):AddKeyPicker('MenuKeybind', { Default = 'RightControl', NoUI = true, Text = 'GUI Toggle keybind' })

			Library:SetWatermarkVisibility(false)

			-- Example of dynamically-updating watermark with common traits (fps and ping)
			local FrameTimer = tick()
			local FrameCounter = 0;
			local FPS = 60;
			local function formatTime(seconds)
				local hours = math.floor(seconds / 3600) -- Calculate full hours
				seconds = seconds % 3600 -- Remainder after removing hours
				local minutes = math.floor(seconds / 60) -- Calculate full minutes
				seconds = seconds % 60 -- Remainder is the remaining seconds

				-- Format the string
				local formattedTime = string.format("%02d:%02d:%02d", hours, minutes, seconds)
				return formattedTime
			end

			-- Example usage


			local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
				FrameCounter += 1;

				if (tick() - FrameTimer) >= 1 then
					FPS = FrameCounter;
					FrameTimer = tick();
					FrameCounter = 0;
				end;

				Library:SetWatermark((''..ScriptName..' | FPS: %s | Ping: %s ms | Current Room: '..(tonumber(Player:GetAttribute("CurrentRoom"))+DoorsDifference).." | Entity Counter: "..EntityCounter .. " | Glitch Counter: "..GlitchCounter .. " | Run Time: " .. formatTime(TimeInRun)):format(
					math.floor(FPS),
					math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
					));
				Library:SetWatermarkVisibility(Toggles.ShowTopText.Value)
			end);

			Library.KeybindFrame.Visible = false; -- todo: add a function for this

			Library:OnUnload(function()
				WatermarkConnection:Disconnect()

				print('Unloaded!')
				Library.Unloaded = true
			end)
			Library.ToggleKeybind = Options.MenuKeybind


			Library.ShowCustomCursor = true
			NotifyType = "Linora"

			wait()
			Notify({Title = "Info",Description = "Loading Successful. "..ScriptName.." is in early beta. Expect some bugs."})
			Sound()
			ThemeManager:SetLibrary(Library)
			SaveManager:SetLibrary(Library)
			SaveManager:IgnoreThemeSettings()


			ThemeManager:SetFolder("JacobsPressureScriptThemes")
			SaveManager:SetFolder("TestConfigs")

			SaveManager:IgnoreThemeSettings()


			ThemeManager:SetFolder("JacobsPressureScriptThemes")
			SaveManager:SetFolder("TestConfigs")

			ThemeManager:ApplyToTab(UISettings)
			SaveManager:BuildConfigSection(UISettings)


			local lb = game.Lighting.Ambient
			local solved = false
			
			
			local AnticheatBypassConnection = Character:GetAttributeChangedSignal("Climbing"):Connect(function()
				if MinesBypass == true  then
					if Character:GetAttribute("Climbing") == true then
						task.wait(1)
						Character:SetAttribute("Climbing",false)

						Notify({Title = "Anticheat Bypass", Description = "Successfully bypassed the Anticheat!", Reason = "It will only last until the next cutscene!"})
						MinesAnticheatBypassActive = true
						Sound()
					else
						MinesAnticheatBypassActive = false
					end
				end
			end)
			local AutoLibrarySolved = false
			local AutoPadlockConnection = game["Run Service"].RenderStepped:Connect(function()
				local room = game.Workspace.CurrentRooms:FindFirstChild("50")
				if AutoLibrary == true and AutoLibrarySolved == false and room and room.Door:FindFirstChild("Padlock") then
					local child = Character:FindFirstChild("LibraryHintPaper") or game.Players.LocalPlayer.Backpack:FindFirstChild("LibraryHintPaper") or Character:FindFirstChild("LibraryHintPaperHard") or game.Players.LocalPlayer.Backpack:FindFirstChild("LibraryHintPaperHard")
					if child ~= nil then
						local code = GetPadlockCode(child)
						local output, count = string.gsub(code, "_", "_")
						local padlock = workspace:FindFirstChild("Padlock", true)
						local part
						for i,e in pairs(padlock:GetDescendants()) do
							if e:IsA("BasePart") then
								part = e
							end
						end

						if solved == false and not tonumber(code) then
							if string.len(output) < 2 then
								if Floor == "Fools" then
									output = "__________"	
								else
									output = "_____"
								end
							end

						end				
						if tonumber(code) and string.len(output) == 5 and solved == false and Floor ~= "Fools" or tonumber(code) and string.len(output) == 10 and Floor == "Fools" and solved == false then
							AutoLibrarySolved = true
							solved = true
							Notify({Title = "Auto Library",Description = "The Library code is '".. output.."'.",Time = room.Door.Padlock})
							Sound()

							local r = game["Run Service"].RenderStepped:Connect(function()
								if tonumber(code) and game.Players.LocalPlayer:DistanceFromCharacter(part.Position) <= AutoLibraryUnlockDistance and Toggles.AutoUnlockPadlock.Value then

									RemotesFolder.PL:FireServer(code)
								end
							end)
							game.Workspace.CurrentRooms.ChildAdded:Wait()
							r:Disconnect()


						end
					end

				end


			end)

		
			


			local function u2()
				local Camera = game.Workspace.CurrentCamera


				if Humanoid.MoveDirection == Vector3.new(0, 0, 0) then

					return Humanoid.MoveDirection

				else


				end
				local v12 = (Camera.CFrame * CFrame.new((CFrame.new(Camera.CFrame.p, Camera.CFrame.p + Vector3.new(Camera.CFrame.lookVector.x, 0, Camera.CFrame.lookVector.z)):VectorToObjectSpace(Humanoid.MoveDirection)))).p - Camera.CFrame.p;
				if v12 == Vector3.new() then
					return v12
				end
				return v12.unit
			end
			local ncrp = RaycastParams.new()
			ncrp.FilterType = Enum.RaycastFilterType.Exclude
			local Bypassing = true
			local acmcooldown = false
			noclipbypassing = false
			AvoidingFigure = false
			if RequireCheck == true then
				Toggles.NoCameraBobbing:OnChanged(function()

					require(game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game).spring.Speed = (Toggles.NoCameraBobbing.Value and 9e9 or 8)

				end)
			end

			local MainConnectionCooldown = false
			
			local MainConnection = game["Run Service"].RenderStepped:Connect(function()
				if AntiFH == true then
					if RemotesFolder:FindFirstChild("Crouch") then
						RemotesFolder.Crouch:FireServer(true)
					end
				end



				if thirdp == true then


					game.Workspace.CurrentCamera.CFrame = game.Workspace.CurrentCamera.CFrame * CFrame.new(ThirdPersonX,ThirdPersonY,ThirdPersonZ)
				end
				if EnableFOV == true then	
					game.Workspace.CurrentCamera.FieldOfView = fov
				end
				if game.Workspace:FindFirstChild("Eyes") and Floor ~= "Fools" and OldHotel == false and AntiEyes == true or game.Workspace:FindFirstChild("BackdoorLookman") and AntiLookman == true then



					RemotesFolder.MotorReplication:FireServer(-650)


				end
if MainConnectionCooldown == false then

				if fb == true  then
					local lighting = game:GetService("Lighting")
					game:GetService("TweenService"):Create(lighting,TweenInfo.new(1,Enum.EasingStyle.Exponential),{Ambient = Ambience}):Play()
				elseif Floor == "Fools" or OldHotel == true then
					local lighting = game:GetService("Lighting")
					game:GetService("TweenService"):Create(lighting,TweenInfo.new(1,Enum.EasingStyle.Exponential),{Ambient = OriginalAmbience}):Play()

				end
				if fly.enabled == true then
					local velocity = Vector3.zero

					velocity = u2()


					fly.flyBody.Velocity = velocity * (flyspeed * 10)



				end


					

				if RemoveHideVignette == true and OldHotel == false then
					if Player.PlayerGui:FindFirstChild("MainUI") then
						Player.PlayerGui.MainUI.MainFrame.HideVignette.Visible = false
					end
				end


				Humanoid.JumpHeight = JumpBoost
				if godmode == true and noclipbypassing == false then
					if CollisionClone2 then
						if Floor ~= "Fools" and OldHotel == false then 
							local raycast = workspace:Raycast(HumanoidRootPart.Position, Vector3.new(0, -1000, 0), ncrp)

							if raycast then
								RemotesFolder.Crouch:FireServer(true)

								CollisionClone.CanCollide = false	
								Collision.Position = HumanoidRootPart.Position-Vector3.new(0,3,0)
								CollisionClone.Position = HumanoidRootPart.Position

							end
						else

							local raycast = workspace:Raycast(HumanoidRootPart.Position, Vector3.new(0, -1000, 0), ncrp)

							if raycast then
								if game.Workspace:FindFirstChild("AmbushMoving") or AvoidingFigure == true then

									Collision.Position = HumanoidRootPart.Position + Vector3.new(0, 250, 0)
									CollisionClone.Position = Collision.Position - Vector3.new(0, 250, 0)

								else
									Collision.Position = HumanoidRootPart.Position - Vector3.new(0, 9, 0)
									CollisionClone.Position = Collision.Position + Vector3.new(0, 9, 0)
								end
								if Toggles.GodmodeFigure.Value then
									if CurrentRoom == 50 or CurrentRoom == 100 then
										local Figure = game.Workspace.CurrentRooms:FindFirstChild(CurrentRoom):WaitForChild("FigureSetup").FigureRagdoll
										if (Collision.Position - Figure.Torso.Position).Magnitude < 10 then
											AvoidingFigure = true
										else

											AvoidingFigure = false
										end

									else

										AvoidingFigure = false
									end
								end


							end
						end
					else

						CollisionClone2.Position = HumanoidRootPart.Position
						CollisionClone2.CanCollide = false
					end

				end
				if godmode == false then
					CollisionClone2.Position = HumanoidRootPart.Position


					CollisionClone.Position = HumanoidRootPart.Position+Vector3.new(0,3,0)
					Collision.Position = HumanoidRootPart.Position
				end


				

				local ray = Ray.new(HumanoidRootPart.CFrame.Position, HumanoidRootPart.CFrame.LookVector * 0.25)
				local part = workspace:FindPartOnRay(ray)

				if Toggles.AutoRoomsIgnoreA60.Value and Floor == "Rooms" then
					Toggles.Toggle250:SetValue(true)
				end
				


				



				if Toggles.GodmodeFigure.Value and Floor == "Fools" then
					Toggles.Toggle250:SetValue(true)
					Toggles.Noclip:SetValue(true)
				end

				if  Toggles.ACM.Value and Floor ~= "Fools" and OldHotel == false and MinesAnticheatBypassActive == false   or Options.AnticheatManipulation:GetState() == true and Floor ~= "Fools" and OldHotel == false and MinesAnticheatBypassActive == false then
					if acmcooldown == false then

						Character:PivotTo(Character:GetPivot() + workspace.CurrentCamera.CFrame.LookVector * Vector3.new(1, 0, 1) * -250)

						Humanoid.HipHeight = 0

					end

				else
					Humanoid.HipHeight = 3







				end

				local ray = Ray.new((HumanoidRootPart.CFrame*CFrame.new(0,3,0)).Position, HumanoidRootPart.CFrame.LookVector)
				local part = workspace:FindPartOnRay(ray)

				if noclipbypassing == false and part and part.CanCollide == true and noclip == true and MinesBypass == false and Floor ~= "Fools" and OldHotel == false and MinesAnticheatBypassActive == false  and not part:IsDescendantOf(game.Workspace.CurrentRooms[CurrentRoom].Door) and Toggles.NoclipBypass.Value then

					local position = Collision.Position
					local newposition = (Collision.Position + (Collision.CFrame.lookVector*0.5))

					noclipbypassing = true
					Character:PivotTo(Character:GetPivot() + workspace.CurrentCamera.CFrame.LookVector * Vector3.new(1, 0, 1) * -250)
					Collision.Massless = true
					task.wait()

					Collision.Massless = false
					noclipbypassing = false

				end


				if RequireCheck == true then
					if Toggles.NoCameraShake.Value then
						require(game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game).csgo = CFrame.new()
					end
				end
task.wait(0.1)
MainConnectionCooldown = false
end
			end)		


local LookmanConnectionCooldown = false
			local LookmanConnection = game["Run Service"].RenderStepped:Connect(function()
				
if LookmanConnectionCooldown == false then
				LookmanConnectionCooldown = true
				if game.Workspace:FindFirstChild("BackdoorLookman")  then
					local inst = game.Workspace:FindFirstChild("BackdoorLookman")
					

					if EntityESP == true and not inst:GetAttribute("_Lookman")then
						local model = Instance.new("Model")
						model.Parent = inst
						local hum = Instance.new("Humanoid")
						hum.Parent = model
						local part = Instance.new("Part")
						part.CFrame = inst.Core.CFrame*CFrame.new(0,-5,0)
						part.Parent = model
						part.CanCollide = false
						part.Transparency = 0.99
						part.Massless = true
						part.Color = Color3.fromRGB(255,0,0)
						part.Size = Vector3.new(6,10,6)

						part.Shape = Enum.PartType.Cylinder

						part.Orientation = Vector3.new(0,0,0)
						inst:SetAttribute("_Lookman",true)
						local mesh = Instance.new("SpecialMesh")
						mesh.Parent = part

						local r = game["Run Service"].RenderStepped:Connect(function()
							part.Orientation = Vector3.new(0,0,0)
						end)

						local weld = Instance.new("WeldConstraint")
						weld.Parent = inst
						weld.Part0 = part
						weld.Part1 = inst.Core
						weld.Enabled = true
						esp(part,part,EntityAlliases[inst.Name], entitycolor,false,false)
						inst.Destroying:Connect(function()
							part:Destroy()	
							r:Disconnect()	
						end)
					end
				end
				task.wait(0.1)
LookmanConnectionCooldown = false
end
			end)

			
			local SCCooldown = false
		
			
			if Character:GetAttribute("SpeedBoost") == nil then
				Character:SetAttribute("SpeedBoost",0)
			end
			if Character:GetAttribute("SpeedBoostExtra") == nil then
				Character:SetAttribute("SpeedBoostExtra",0)
			end
			if Character:GetAttribute("SpeedBoostBehind") == nil then
				Character:SetAttribute("SpeedBoostBehind",0)
			end
			local SpeedConnection = RunService.RenderStepped:Connect(function()
if Character ~= nil then
				if SCCooldown == false then
					SCCooldown = true
						local CrouchNerf = 0
				

					
					
					if Collision and Collision.CollisionGroup == "PlayerCrouching" then
						CrouchNerf = 5
					else
						CrouchNerf = 0

					end
					if SpeedBoostEnabled == true then

							local num = 15 + (Character:GetAttribute("SpeedBoost") + Character:GetAttribute("SpeedBoostBehind") + Character:GetAttribute("SpeedBoostExtra") + SpeedBoost - CrouchNerf)
						Humanoid.WalkSpeed = num
				
					end

					task.wait(0.1)
					SCCooldown = false
				end
end
			end)
			
			game["Run Service"].RenderStepped:Connect(function(Delta)
			
				if game.Workspace.CurrentRooms:FindFirstChild("100")  then

					if workspace.CurrentRooms["100"]:FindFirstChild("ElevatorBreaker") then
						if AutoBreaker == true then
							SolveBreakerBox()

						end
					end
				end
				
			end)

			Notify({Title = "WARNING",Description = "Godmode doesn't work for A-120.",Reason = "YOU NEED TO HIDE WHEN IT SPAWNS!"})
			Library.NotifySide = "Left"
			if Library.IsMobile then
				Library.NotifySide = "Right"	
			end




			if HumanoidRootPart.CustomPhysicalProperties ~= nil then
				CustomPhysicalProperties = PhysicalProperties.new(100, HumanoidRootPart.CustomPhysicalProperties.Friction, HumanoidRootPart.CustomPhysicalProperties.Elasticity, HumanoidRootPart.CustomPhysicalProperties.FrictionWeight, HumanoidRootPart.CustomPhysicalProperties.ElasticityWeight)
			end

			SaveManager:LoadAutoloadConfig()

			local Unloading = false
			function Unload()
				if Unloading == false then
					Unloading = true

					Notify({Title = "Info",Description = "Unloading "..ScriptName.."..."})
					Sound()
					Connection1:Disconnect()

					AntiConnection:Disconnect()
					MainConnection:Disconnect()
					SpeedConnection:Disconnect()
					FigureConnection:Disconnect()
					Connection5:Disconnect()
					Connection4:Disconnect()
					textgui:Destroy()
					tracergui:Destroy()
					PathfindingFolder:Destroy()

					LookmanConnection:Disconnect()
					NAC:Disconnect()
					NoclipConnection:Disconnect()
					NotifierConnection:Disconnect()
					Toggles.AutoRooms:SetValue(false)
					Screech.Name = "Screech"
					for i,Connection in pairs(Connections) do
						Connection:Disconnect()			
					end
					if A90 then
						A90.Name = "A90"
					end
					Timothy.Name = "SpiderJumpscare"
					if Dread then
						Dread.Name = "Dread"
					end
					Void.Name = "Void"
					Halt.Name = "Shade"
					if Collision.CollisionGroup ~= "PlayerCrouching" then
						if RemotesFolder:FindFirstChild("Crouch") then
							RemotesFolder.Crouch:FireServer(false)
						end
					end
					Glitch.Name = "Glitch"
					EnableFOV = false

					Collision.Position = HumanoidRootPart.Position
					Collision.CanCollide = true
					CollisionClone:Destroy()
					CollisionClone2:Destroy()
					PathfindingFolder:Destroy()
					Character:SetAttribute("SpeedBoost",0)
					Character:SetAttribute("SpeedBoostBehind",0)
					Character:SetAttribute("SpeedBoostExtra",0)

					CollisionClone:Destroy()
					for i,ui in pairs(game.Players.LocalPlayer.PlayerGui:GetChildren()) do
						if ui.Name == "Tracers" then
							ui:Destroy()
						end

					end
					for i,inst in pairs(game.Workspace:GetDescendants()) do
						inst:SetAttribute("ESP",false)



					end
					game.Workspace.CurrentCamera.FieldOfView = fov
					game:GetService("TweenService"):Create(game.Workspace.CurrentCamera,TweenInfo.new(1,Enum.EasingStyle.Exponential),{FieldOfView = 70}):Play()
					game:GetService("TweenService"):Create(game.Lighting,TweenInfo.new(1,Enum.EasingStyle.Exponential),{Ambient = OriginalAmbience}):Play()
					task.wait(3)
					Notify({Title = "Info",Description = "Unloading complete.",Reason = "The GUI will terminate momentarily."})
					Sound()
					task.wait(3)
					Humanoid.WalkSpeed = 15

					Library:Unload()
					ESPLibrary:Unload()
					Library = nil
					ESPLibrary = nil

					getgenv().JSHUB = false
					getgenv().Library = nil

				else
					Notify({Title = "Error",Description = ScriptName .. " is already unloading."})	
					Sound()
				end
			end	
			MenuSettings:AddDivider()
			MenuSettings:AddButton('Unload', function() Unload() end)
		end


	else
		getgenv().Library:Notify(ScriptName .. " Initialisation | ".."Another script using Linora has been detected. Please unload it to use "..ScriptName..".")
		Sound()
		getgenv().JSHUB = false
	end

else
	Notify({Title = "Loading Error", Description = "Script has already been executed."})
	Sound()
end


