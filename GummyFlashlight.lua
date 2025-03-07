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
								
									Modules["Screech_"].Name = "Screech"
								
							end
						end)



					
