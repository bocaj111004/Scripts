
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
						game:GetService("RunService").RenderStepped:Connect(function()
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
