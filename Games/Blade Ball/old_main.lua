		-- main.lua check
			--[[
			local IsRaw = false
			local Range = 1 or 14
			for i, v in next, getconstants(Range) do
				if v == "ТUРLЕ" then
					IsRaw = true
				end
			end
			
			if not IsRaw then
				warn("directly executed")
			end
			--]]
		-- main.lua check
		
		local ArrayField = loadstring(game:HttpGet("https://raw.githubusercontent.com/Hosvile/Refinement/main/MC%3AArrayfield%20Library"))() --Documentation url: https://docs.sirius.menu/community/arrayfield
		
		--Window
		local Window = ArrayField:CreateWindow({
			Name = "InfiniX | Blade Ball",
			LoadingTitle = "InfiniX | Blade Ball",
			LoadingSubtitle = "by Hosvile",
			ConfigurationSaving = {
				Enabled = true,
				FolderName = nil, -- Create a custom folder for your hub/game
				FileName = "Infinixity"
			},
			Discord = {
				Enabled = true,
				Invite = "ZZPyRhS6cV", -- The Discord invite code, do not include discord.gg/
				RememberJoins = false -- Set this to false to make them join the discord every time they load it up
			},
		})
		
		--Elements
		local Buttons = {}
		local Toggles = {}
		local Dropdowns = {}
		local Inputs = {}
		local Sliders = {}
		local Keybinds = {}
		
		--Services
		local HttpService = game:GetService("HttpService")
		local SocialService = game:GetService("SocialService")
		local StarterGui = game:GetService("StarterGui")
		local RunService = game:GetService("RunService")
		local UserInputService = game:GetService("UserInputService")
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		local Players = game:GetService("Players")
		
		--Scripts
		local VisualCDScript = game.Players.LocalPlayer.PlayerGui.Hotbar.VisualCD
		
		--Remotes
		local ParryRemote
		local ParryButtonRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ParryButtonPress")
		local GetParryAmt = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("getParryAmt")
		local AbilityButtonRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("AbilityButtonPress")
		local Rapture = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("PlrRaptured")
		local RagingDeflection = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("PlrRagingDeflectiond")
		local VisualCD = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("VisualCD")
		local VisualBindableCD = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("VisualBindableCD")
		
		local TempSignal
		TempSignal = SocialService.ChildAdded:Connect(function(self)
			if self.Name:match("\n") and self:IsA("RemoteEvent") then
				if not ParryRemote then
					TempSignal:Disconnect(); TempSignal = nil
					
					ParryRemote = self
				end
			end
		end)

		while not ParryRemote do
			task.wait()
		end
		
		--Players
		local LocalPlayer = Players.LocalPlayer
		
		--Input
		local Mouse = LocalPlayer:GetMouse()
		
		--Camera
		local Camera = workspace.CurrentCamera
		
		--Folders
		local Balls = game:GetService("Workspace").Balls
		local PlayerGui = LocalPlayer.PlayerGui
		local Upgrades = LocalPlayer:WaitForChild("Upgrades")
		
		--References
		local Remotes = ReplicatedStorage:WaitForChild("Remotes")
		local Packages = ReplicatedStorage:WaitForChild("Packages")
		
		--Modules
		local Cooldown = Packages:WaitForChild("Cooldown")
		
		--Requires
		local r_Cooldown = require(Cooldown)
		
		--Functions
		
		--[[
		local VisualCDFunction
		
		if getgc and debug and debug.getinfo and getfenv then
			for i, v in pairs(getgc()) do
				if type(v) == "function" and getfenv(v).script == VisualCDScript then
					local name = debug.getinfo(v).name
					if name and name == "visualcd" then
						VisualCDFunction = v
					end
				end
			end
		end
		--]]
		
		--Main
		local Create = {}
		local __Config = {
			DebugMode = false;
			VisualizePath = false;
			SafetyMode = true;
			FastMode = true;
			BeastMode = false;
			AutoParry = true;
			AutoSpamParry = true;
			RageParry = false;
			BlockSpamParry = true;
			BlockMode = "Hold";
			FollowBall = false;
			CurveBall = true;
			FreezeBall = false;
			AimCamera = false;
			AutoMove = false;
			TargetMode = "Last";
			CurvingMode = "Default";
			Random = false;
			Collision = true;
			SpamBind = Enum.KeyCode.V;
			Range = 0.5;
			DirectPoint = 0;
			SpamDistance = 20;
			SpamIteration = 1;
			SpamTimeThreshold = 0.5;
			Debounce = false;
		}
		local Configmt = {__newindex = function(self, key, value)
			--__Config[key] = value
			rawset(self, key, value)
		end}
		local __State = setmetatable({
			DebugMode = false;
			TouchPoints = {};
			VisualizePath = false;
			SafetyMode = true;
			FastMode = true;
			BeastMode = false;
			AutoParry = true;
			AutoSpamParry = true;
			RageParry = false;
			BlockSpamParry = true;
			FollowBall = false;
			CurveBall = true;
			FreezeBall = false;
			AimCamera = false;
			AutoMove = false;
		}, Configmt)
		local __Main = {}
		local __Function = {}
		local __Fire = setmetatable({
			BlockMode = "Hold";
			TargetMode = "Last";
			CurvingMode = "Default";
			Random = false;
		}, Configmt)
		local __Status = {}
		local __Condition = {}
		local __Player = setmetatable({
			Collision = true;
			Ping = 0;
			LastParried = nil;
			SpamBind = Enum.KeyCode.V;
		}, Configmt)
		local __Cam = {}
		local __Ball = setmetatable({
			Velocity = Vector3.new(0, 0, 0);
			LastParried = os.clock();
			IntervalSpawn = 0;
			Range = 0.5;
			DirectPoint = 0;
			SpamDistance = 20;
			SpamIteration = 1;
			SpamTimeThreshold = 0.5;
			ParryCount = 0;
			SpamCount = 0;
			Debounce = false;
			AbilityDebounce = false;
			LastTarget = nil;
			LastTargetParried = false;
			LastSpeed = Vector3.new(0, 0, 0);
		}, Configmt)
		local __Map = {}
		local __Button = {}
		
		local print = print
		local warn = warn
		
		-- Initial
			local OldPrint, OldWarn = print, warn
			DebugMode = function(Value)
				if Value then
					print = OldPrint
					warn = OldWarn
				else
					print = function() end
					warn = function() end
				end
				__Config.DebugMode = Value
			end
			
			-- Load
				if makefolder and isfolder and not isfolder("Infinixity") then
					makefolder("Infinixity")
				end
				
				local path = "Infinixity/BladeBall/"
				
				if isfile and isfile(path .. "config.json") then
					warn("config.json")
					local Config = HttpService:JSONDecode(readfile(path .. "config.json"))
					for Index, Value in pairs(Config) do
						if Value ~= nil then
							if __State[Index] ~= nil and typeof(__State[Index]) ~= "function" then
								__State[Index] = Value
							end
							if __Player[Index] ~= nil and typeof(__Player[Index]) ~= "function" then
								__Player[Index] = Value
							end
							if __Ball[Index] ~= nil and typeof(__Ball[Index]) ~= "function" then
								__Ball[Index] = Value
							end
							if __Fire[Index] ~= nil and typeof(__Fire[Index]) ~= "function" then
								__Fire[Index] = Value
							end
							__Config[Index] = Value
						end
					end
				end
			-- Load
			
			DebugMode(__Config.DebugMode)
			
			function VisualCDFire(Block, Ability, Duration)
				local Ping = game.Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
				
				warn("Block:", Block, "Ability:", Ability, "Duration:", Duration)
				
				if Block and not Duration then
					__Ball.Debounce = false
					print("BlockDebounce false")
				elseif Block and not Ability and Duration then
					__Ball.Debounce = true
					print("BlockDebounce true")
					task.spawn(function()
						local Start = os.clock()
						repeat RunService.PostSimulation:Wait() until os.clock() - Start >= Duration or __Ball.Debounce ~= true
						if os.clock() - Start >= Duration then
							warn("BlockDebounce set to false")
							VisualCDFire(true, nil, nil)
						end
					end)
				elseif Ability and not Duration then
					__Ball.AbilityDebounce = false
					print("AbilityDebounce false")
				elseif Ability and Duration then
					__Ball.AbilityDebounce = true
					print("AbilityDebounce true")
					task.spawn(function()
					local Start = os.clock()
						repeat RunService.PostSimulation:Wait() until os.clock() - Start >= Duration or __Ball.AbilityDebounce ~= true
						if os.clock() - Start >= Duration then
							warn("Abilityebounce set to false")
							VisualCDFire(false, true, nil)
						end
					end)
				end
			end
			
			-- VisualCD.OnClientEvent:Connect(VisualCDFire)
			
			-- VisualBindableCD.Event:Connect(VisualCDFire)
		-- Initial
		
		-- Create
			local DotsFolder = Instance.new("Folder")
			Create.Path = function(self, Ball, Object, Data)
				local DotsFolder = Ball:FindFirstChild("Path")
				if not DotsFolder then
					DotsFolder = Instance.new("Folder")
					DotsFolder.Name = "Path"
					DotsFolder.Parent = Ball
				end
				
				--[[
				for _, Instance in pairs(DotsFolder:GetDescendants()) do
					Instance:Destroy()
				end
				]]
				
				-- Calculate the direction and magnitude of the initial velocity
				local Velocity
				pcall(function()
					Velocity = Velocity or Ball.Velocity
				end)
				if not Velocity then Velocity = __Ball.Velocity end
				local Direction = Velocity.Unit
				local Speed = Velocity.Magnitude
				
				-- Calculate the time of flight using the kinematic equation
				local YOffset = 0 or Object.Position.Y - Ball.Position.Y
				local TimeOfFlight = (Speed + math.sqrt(Speed^2 + 2 * math.abs(YOffset) * 9.81)) / 9.81
				
				-- Calculate the horizontal distance based on the time of flight
				local Distance = (Ball.Position - Object.Position).Magnitude
				local HorizontalDistance = Speed * TimeOfFlight
				
				-- Calculate the number of dots needed based on spacing
				local Dots = HorizontalDistance / Data.Spacing
				local ClampedDots = Distance / Data.Spacing
				
				-- Calculate the time interval between dots
				local TimeInterval = TimeOfFlight / Dots
				
				-- Create the circular dots along the curved path
				for i = 1, ClampedDots do
					-- Calculate the horizontal position at this time interval
					local HorizontalPosition = Direction * (i * Data.Spacing)
				
					-- Calculate the vertical position at this time interval using the kinematic equation
					YOffset = -0.5 * 9.81 * (i * TimeInterval)^2
				
					-- Calculate the total position
					Position = Ball.Position + HorizontalPosition + Vector3.new(0, YOffset, 0)
					
					-- Create a circular dot
					local Dot = DotsFolder:FindFirstChild(("Dot %d"):format(i))
					if Dot then
						Dot.Position = Position
					else
						Dot = Instance.new("Part")
						Dot.Name = ("Dot %d"):format(i)
						Dot.Size = Vector3.new(Data.Radius * 2, Data.Radius * 2, Data.Radius* 2)
						Dot.Shape = Enum.PartType.Ball -- Use the Ball shape for a circle
						Dot.Position = Position
						Dot.Anchored = true
						Dot.CanCollide = false
						Dot.Transparency = ((i+1) / (ClampedDots*1)) + 0.1
						Dot.Material = "Neon"
						Dot.BrickColor = BrickColor.new("Bright red") -- Adjust color as needed
						Dot.Parent = DotsFolder
					end
				end
			end
		-- Create
		
		--__Function
			__Function.RandomString = function(self, Length)
				local Array = {}
				for i = 1, Length do
				Array[i] = string.char(math.random(32, 126))
				end
				return table.concat(Array)
			end
			
			__Function.Random = function(self, Choices)
				local Sum = 0
				for _, Choice in next, Choices do
					Sum = Sum + Choice.Weight
				end
				Sum = math.random(0, Sum)
				for _, Choice in next, Choices do
					Sum = Sum - Choice.Weight
					if Sum <= 0 then
						return Choice.Value
					end
				end
			end
			
			local CharacterAddedFunctions = {}
			__Function.CharacterAdded = function(self, Character, Func, Fire)
				CharacterAddedFunctions[#CharacterAddedFunctions + 1] = Func
				if Fire then Func(Character) end
			end
			
			__Function.CharacterDied = function(self, Character, Func, Fire)
				local Index = #CharacterAddedFunctions + 1
				CharacterAddedFunctions[Index] = function(Character)
					local Humanoid = Character:WaitForChild("Humanoid")
					if Humanoid and Humanoid:IsA("Humanoid") then
						Humanoid.Died:Connect(Func)
					end
				end
				
				if Fire then CharacterAddedFunctions[Index](Character) end
			end
			
			__Function.Fire = function(self, Remote, ...)
				if Remote:IsA("RemoteEvent") then
					Remote:FireServer(...)
				elseif Remote:IsA("BindableEvent") then
					Remote:Fire(...)
				end
			end
		--__Function
		
		--__Fire
			local Prioritize = false
			__Fire.Parry = function(self, Bool)
				if Bool then
					--__Function:Fire(ParryButtonRemote)
				elseif __Player:Ability("Rapture") and not __Ball.AbilityDebounce then
					local args, Object = {}
					args[2] = __Cam:PlayerPoints()
					
					if __Fire.TargetMode == "Nearest to Mouse" then
						Object = __Player:HumanoidRootPart(__Player:Nearest())
					elseif __Fire.TargetMode == "Last Targeted Player" then
						Object = __Player:HumanoidRootPart(__Ball.LastTarget)
					elseif __Fire.TargetMode == "Closest Player" then
						Object = __Player:HumanoidRootPart(__Player:Closest())
					elseif __Fire.TargetMode == "Furthest Player" then
						Object = __Player:HumanoidRootPart(__Player:Furthest())
					elseif __Fire.TargetMode == "Weakest Player" then
						Object = __Player:HumanoidRootPart(__Player:Weakest())
					elseif __Fire.TargetMode == "Strongest Player" then
						Object = __Player:HumanoidRootPart(__Player:Strongest())
					end
					
					if Object then
						WorldToScreenPoint = Camera:WorldToScreenPoint(Object.Position)
						args[3] = {WorldToScreenPoint.X, WorldToScreenPoint.Y}
					end
					
					if not args[3] then
						args[3] = {Mouse.X, Mouse.Y}
					end
					
					if __State.CurveBall then
						args[1] = __Cam:Angle(__Fire.CurvingMode, __Player:HumanoidRootPart(LocalPlayer), Object)
					else
						args[1] = Camera.CFrame
					end
					
					Prioritize = true
					task.spawn(function()
						local Start = os.clock()
						local Humanoid = __Player:Humanoid(LocalPlayer)
						repeat task.wait() until Humanoid and Humanoid.WalkSpeed > 0 or os.clock() - Start >= 1
						if Humanoid and Humanoid.WalkSpeed > 0 or os.clock() - Start >= 1 then
							Prioritize = false
						end
					end)
					
					VisualCDFire(false, true, 35)
					__Function:Fire(Rapture, unpack(args))
				elseif __Player:Ability("Raging Deflection") and not __Ball.AbilityDebounce then
					local args, Object = {}
					args[2] = __Cam:PlayerPoints()
					
					if __Fire.TargetMode == "Nearest to Mouse" then
						Object = __Player:HumanoidRootPart(__Player:Nearest())
					elseif __Fire.TargetMode == "Last Targeted Player" then
						Object = __Player:HumanoidRootPart(__Ball.LastTarget)
					elseif __Fire.TargetMode == "Closest Player" then
						Object = __Player:HumanoidRootPart(__Player:Closest())
					elseif __Fire.TargetMode == "Furthest Player" then
						Object = __Player:HumanoidRootPart(__Player:Furthest())
					elseif __Fire.TargetMode == "Weakest Player" then
						Object = __Player:HumanoidRootPart(__Player:Weakest())
					elseif __Fire.TargetMode == "Strongest Player" then
						Object = __Player:HumanoidRootPart(__Player:Strongest())
					end
					
					if Object then
						WorldToScreenPoint = Camera:WorldToScreenPoint(Object.Position)
						args[3] = {WorldToScreenPoint.X, WorldToScreenPoint.Y}
					end
					
					if not args[3] then
						args[3] = {Mouse.X, Mouse.Y}
					end
					
					if __State.CurveBall then
						args[1] = __Cam:Angle(__Fire.CurvingMode, __Player:HumanoidRootPart(LocalPlayer), Object)
					else
						args[1] = Camera.CFrame
					end
					
					Prioritize = true
					task.spawn(function()
						local Start = os.clock()
						local Humanoid = __Player:Humanoid(LocalPlayer)
						repeat task.wait() until Humanoid and Humanoid.WalkSpeed > 0 or os.clock() - Start >= 1
						if Humanoid and Humanoid.WalkSpeed > 0 or os.clock() - Start >= 1 then
							Prioritize = false
						end
					end)
					
					VisualCDFire(false, true, 35)
					__Function:Fire(RagingDeflection, unpack(args))
				elseif __Fire.TargetMode and not Prioritize then
					local args, Object = {}
					args[1] = 1.5
					args[3] = __Cam:PlayerPoints()
					
					if __Fire.TargetMode == "Nearest to Mouse" then
						Object = __Player:HumanoidRootPart(__Player:Nearest())
					elseif __Fire.TargetMode == "Last Targeted Player" then
						Object = __Player:HumanoidRootPart(__Ball.LastTarget)
					elseif __Fire.TargetMode == "Closest Player" then
						Object = __Player:HumanoidRootPart(__Player:Closest())
					elseif __Fire.TargetMode == "Furthest Player" then
						Object = __Player:HumanoidRootPart(__Player:Furthest())
					elseif __Fire.TargetMode == "Weakest Player" then
						Object = __Player:HumanoidRootPart(__Player:Weakest())
					elseif __Fire.TargetMode == "Strongest Player" then
						Object = __Player:HumanoidRootPart(__Player:Strongest())
					end
					
					if Object then
						WorldToScreenPoint = Camera:WorldToScreenPoint(Object.Position)
						warn("Found Object", __Fire.TargetMode)
						args[4] = {WorldToScreenPoint.X, WorldToScreenPoint.Y}
						warn("WorldToScreenPoint:", WorldToScreenPoint.X, WorldToScreenPoint.Y)
					end
					
					if not args[4] then
						args[4] = {Mouse.X, Mouse.Y}
					end
					
					if __State.CurveBall then
						args[2] = __Cam:Angle(__Fire.CurvingMode, __Player:HumanoidRootPart(LocalPlayer), Object)
					else
						args[2] = Camera.CFrame
					end
					
					VisualCDFire(true, nil, 1.3)
					__Function:Fire(ParryRemote, unpack(args))
				else
					--__Function:Fire(ParryButtonRemote)
				end
			end
		--__Fire
		
		--__Status
			__Status.Standoff = function(self)
				return #workspace.Alive:GetChildren() == 2
			end
		--__Status
		
		--__Condition
			__Condition.Child = function(self, Parent, Child)
				return Parent and Parent:FindFirstChild(Child)
			end
		--__Condition
		
		--__Player
			__Player.Humanoid = function(self, Player)
				local Humanoid = Player and Player:IsA("Player") and Player.Character and Player.Character:FindFirstChildWhichIsA("Humanoid") or Player and Player:IsA("Actor") and Player:FindFirstChildWhichIsA("Humanoid")
				return Humanoid
			end
			
			__Player.HumanoidRootPart = function(self, Player)
				local Humanoid = __Player:Humanoid(Player)
				return Humanoid and Humanoid.RootPart
			end
			
			__Player.Alive = function(self, Player)
				Player = Player or LocalPlayer
				Player = workspace.Alive:FindFirstChild(Player.Name)
				local Humanoid = Player and Player.PrimaryPart and Player:FindFirstChildWhichIsA("Humanoid")
				return Humanoid and (Humanoid.Health > 0 or Humanoid.Parent:FindFirstChild("Highlight"))
			end
			
			__Player.Playing = function(self)
				local Alive = 0
				for _, Player in pairs(workspace.Alive:GetChildren()) do
					Player = Players:FindFirstChild(Player.Name)
					local Humanoid = Player and __Player:Humanoid(Player)
					if Humanoid and Humanoid.Health > 0 then
						Alive = Alive + 1
					end
				end
				return Alive > 0
			end
			
			__Player.Ability = function(self, Name)
				local Ability = LocalPlayer.Character and __Condition:Child(LocalPlayer.Character.Abilities, Name)
				if Ability and Ability.Enabled then
					return true
				end
			end
			
			__Player.Frozen = function(self)
				local Humanoid = __Player:Humanoid(LocalPlayer)
				return Humanoid and Humanoid.WalkSpeed <= 0
			end
			
			local CanCollideSignal
			__Player.CanCollide = function(self, State)
				if LocalPlayer.Character and State ~= nil then
					if CanCollideSignal then CanCollideSignal:Disconnect() end
					if State == false then
						CanCollideSignal = RunService.PostSimulation:Connect(function()
							for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
								if v:IsA("BasePart") then
									__Player.Collision = State
									v.CanCollide = State
								end
							end
						end)
					end
				elseif State == nil then
					return __Player.Collision
				end
			end
			
			local ClipCameraState, OriginalOcclusion = true
			__Player.ClipCamera = function(self, State)
				if State == false then
					ClipCameraState = false
					if not OriginalOcclusion then OriginalOcclusion = LocalPlayer.DevCameraOcclusionMode end
					LocalPlayer.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam
				elseif PreviousOcclusion and State == true then
					ClipCameraState = true
					LocalPlayer.DevCameraOcclusionMode = OriginalOcclusion
				elseif State == nil then
					return ClipCameraState
				end
			end
			
			__Player.FollowBall = function(self, Ball)
				if Ball and LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
					if __Player:CanCollide() then __Player:CanCollide(false) end
					if __Player:ClipCamera() then __Player:ClipCamera(false) end
					local HumanoidRootPart = __Player:HumanoidRootPart(LocalPlayer)
					local Velocity
					pcall(function()
						Velocity = Velocity or Ball.Velocity
					end)
					if not Velocity then Velocity = __Ball.Velocity end
					local Position = Vector3.new(Ball.Position.X, __Map.GroundLevel - 20, Ball.Position.Z) - Velocity.Unit * 10
					if Position.Magnitude == Position.Magnitude then
						LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(Position))
					end
				end
			end
			
			warn(__Player.FollowBall)
			
			__Player.Invisible = function(self, Player)
				if Player.Character and Player.Character:FindFirstChild("Torso") and Player.Character.Torso.Transparency >= 0.75 then
					return true
				end
			end
			
			__Player.Alone = function(self)
				local Alive, Amount = #workspace.Alive:GetChildren() - 1, 0
				for _, Player in pairs(Players:GetPlayers()) do
					if Player ~= LocalPlayer and __Player:Invisible(Player) and __Player:Alive(Player) then
						Amount = Amount + 1
					end
					if Amount >= Alive then return true end
				end
			end
			
			__Player.RunningAway = function(self, Ball, HumanoidRootPart)
				local Humanoid = Ball and __Player:Humanoid(LocalPlayer)
				if HumanoidRootPart then
					local RunDirection = (HumanoidRootPart.Position - Ball.Position).Unit
					local ForwardDirection = HumanoidRootPart.CFrame.LookVector
					local PlayerVelocity = Humanoid.MoveDirection
					local Angle = math.deg(math.acos(RunDirection:Dot(ForwardDirection)))
					
					local ThresholdAngle = 90
					local MovingAway = RunDirection:Dot(PlayerVelocity) > 0
					
					if MovingAway then
						return true
					else
						return false
					end
				end
			end
			
			local ParryCount, OldParryCount = 0, 0
			__Player.WalkTo = function(self, Player)
				local Humanoid = __Player:Humanoid(LocalPlayer)
				local HumanoidRootPart = Humanoid and __Player:HumanoidRootPart(Player)
				if HumanoidRootPart then
					local Direction = (HumanoidRootPart.Position - Humanoid.Parent.PrimaryPart.Position).Unit
					local TargetPosition
					
					ParryCount = (__Ball.ParryCount) % 10
					
					if ParryCount >= 6 then
						TargetPosition = HumanoidRootPart.Position - Direction * (20 + __Ball.SpamDistance * ParryCount)
					else
						TargetPosition = HumanoidRootPart.Position - Direction * math.clamp(60 - __Ball.SpamDistance * ParryCount, __Ball.SpamDistance - 10, 60)
					end
					
					if TargetPosition then
						Humanoid:MoveTo(TargetPosition, HumanoidRootPart)
					end
				end
			end
			
			__Player.Nearest = function(self)
				local ClosestDistance, ClosestPlayer = math.huge, nil
					
				for i, Player in ipairs(Players:GetPlayers()) do
					local HumanoidRootPart = __Player:HumanoidRootPart(Player)
					local Distance = (HumanoidRootPart.Position - Mouse.Hit.Position).Magnitude
				
					if Distance < ClosestDistance then
						ClosestDistance = Distance
						ClosestPlayer = Player
					end
				end
				
				return ClosestPlayer
			end
			
			__Player.Strongest = function(self)
				local LastKills, Strongest = 0, nil
				
				for _, Player in pairs(Players:GetPlayers()) do
					local Leaderstats = Player:FindFirstChild("leaderstats")
					local Kills = Leaderstats and Leaderstats:FindFirstChild("Kills")
					Kills = Kills and Kills.Value
					
					if Kills and Kills > LastKills and __Player:Alive(Player) then
						LastKills = Kills
						Strongest = Player
					end
				end
				
				return Strongest
			end
			
			__Player.Weakest = function(self)
				local LastKills, Weakest = math.huge, nil
				
				for _, Player in pairs(Players:GetPlayers()) do
					local Leaderstats = Player:FindFirstChild("leaderstats")
					local Kills = Leaderstats and Leaderstats:FindFirstChild("Kills")
					Kills = Kills and Kills.Value
					
					if Kills and Kills < LastKills and __Player:Alive(Player) then
						LastKills = Kills
						Weakest = Player
					end
				end
				
				return Weakest
			end
			
			__Player.Furthest = function(self)
				local HumanoidRootPart = __Player:HumanoidRootPart(LocalPlayer)
				
				if HumanoidRootPart then
					local LastPlayer = {Player = nil, Distance = nil}
					
					for _, Player in pairs(Players:GetPlayers()) do
						local Object = __Player:Alive(Player) and __Player:HumanoidRootPart(Player)
						if Player ~= LocalPlayer and Object then
							local Distance = (HumanoidRootPart.Position - Object.Position).Magnitude
							if not LastPlayer.Distance then
								LastPlayer.Distance = Distance
							end
							
							if LastPlayer.Distance < Distance then
								LastPlayer.Player = Player
								LastPlayer.Distance = Distance
							end
						end
					end
					
					return LastPlayer.Player
				end
			end
			
			__Player.Closest = function(self)
				local HumanoidRootPart = __Player:HumanoidRootPart(LocalPlayer)
				if HumanoidRootPart then
					local LastPlayer = {Player = nil, Distance = nil}
					for _, Player in pairs(Players:GetPlayers()) do
						local Object = __Player:Alive(Player) and __Player:HumanoidRootPart(Player)
						if Player ~= LocalPlayer and Object then
							local Distance = (HumanoidRootPart.Position - Object.Position).Magnitude
							if not LastPlayer.Distance then
								LastPlayer.Distance = Distance
							end
							
							if LastPlayer.Distance > Distance then
								LastPlayer.Player = Player
								LastPlayer.Distance = Distance
							end
						end
					end
					return LastPlayer.Player
				end
			end
		--__Player
		
		--__Cam
			__Cam.Angle = function(self, Mode, Object1, Object2)
				local Position = Camera.CFrame.Position
				local UpVector = Camera.CFrame.UpVector
				local RightVector = Camera.CFrame.RightVector
				
				local Matrix
				if Mode == "Default" then
					Matrix = Camera.CFrame
				elseif Mode == "Upwards" then
					Matrix = CFrame.fromMatrix(Position, RightVector, UpVector, Vector3.new(0, -1, 0))
				elseif Mode == "Backwards" and Object1 and Object2 then
					local LookVector = (Object2.Position - Object1.Position).Unit
					Matrix = CFrame.fromMatrix(Position, RightVector, UpVector, LookVector)
				elseif Mode == "Forwards" and Object1 and Object2 then
					local LookVector = (Object1.Position - Object2.Position).Unit
					Matrix = CFrame.fromMatrix(Position, RightVector, UpVector, LookVector)
				elseif Mode == "Random" and Object1 and Object2 then
					local LookVector = (Object2.Position - Object1.Position).Unit
					local Choices = {
						{Value = CFrame.fromMatrix(Position, RightVector, UpVector, Vector3.new(0, -1, 0)), Weight = 60},
						{Value = CFrame.fromMatrix(Position, RightVector, UpVector, LookVector), Weight = 30},
						{Value = Camera.CFrame, Weight = 10},
					}
					
					Matrix = __Function:Random(Choices)
				end
				
				warn("Matrix:", Matrix, "\nCamera:", Camera.CFrame, "\n")
				
				return Matrix or Camera.CFrame
			end
			
			__Cam.PlayerPoints = function(self)
				local Table = {}
				for _, Player in pairs(Players:GetPlayers()) do
					local UserId, HumanoidRootPart = tostring(Player.UserId), __Player:HumanoidRootPart(Player)
					if HumanoidRootPart and not __Player:Invisible(Player) then
						Table[Player.Name] = Camera:WorldToScreenPoint(HumanoidRootPart.Position)
					end
				end
				
				return Table
			end
			
			__Cam.LookAt = function(self, Object)
				if typeof(Object) == "Instance" then
					Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, Object.Position)
				end
			end
		--__Cam
		
		--__Ball
			__Ball.RealBall = function(self)
				for _, Ball in pairs(Balls:GetChildren()) do
					if Ball:GetAttribute("realBall") == true then
						return Ball
					end
				end
			end
			
			__Ball.FakeBall = function(self)
				for _, Ball in pairs(Balls:GetChildren()) do
					if Ball:GetAttribute("realBall") == false then
						return Ball
					end
				end
			end
			
			__Ball.Speed = function(self, Ball)
				local Velocity
				pcall(function()
					Velocity = Velocity or Ball.Velocity
				end)
				if not Velocity then Velocity = __Ball.Velocity end
				if Ball and __Ball.LastSpeed.Magnitude < Velocity.Magnitude then
					__Ball.LastSpeed = Velocity
				end
			end
			
			__Ball.Distance = function(self, Ball, Player, Studs)
				if Ball and Player then
					local Object = __Player:HumanoidRootPart(Player)
					local Object2 = __Player:HumanoidRootPart(LocalPlayer)
					local Distance = Object and (Object.Position - Ball.Position)
					local PlayerDistance = Object2 and (Object2.Position - Object.Position)
					
					if Distance.Magnitude <= Studs and PlayerDistance.Magnitude > Studs then
						return true
					else
						warn("Studs Distance:", Distance.Magnitude, "Studs:", Studs, "Player Distance:", PlayerDistance.Magnitude)
					end
				end
			end
			
			__Ball.Directed = function(self, Ball, Player)
				if Ball and Player then
					local Velocity
					pcall(function()
						Velocity = Velocity or Ball.Velocity
					end)
					if not Velocity then Velocity = __Ball.Velocity end
					local Object = __Player:HumanoidRootPart(Player)
					local Distance = Object and (Object.Position - Ball.Position)
					local DotProduct = Distance and Distance.Unit:Dot(Velocity.Unit)
					
					if DotProduct >= __Ball.DirectPoint then
						--warn(DotProduct, ">", __Ball.DirectPoint, "Distance:", Distance.Magnitude, Player)
						return true, DotProduct
					end
				end
			end
			
			__Ball.Target = function(self, Ball)
				--[[
				local Ball = __Ball:FakeBall()
				if Ball and Ball.Color == Color3.fromRGB(255, 0, 4) then
					return true
				end
				--]]
				if Ball and Ball:GetAttribute("target") == LocalPlayer.Name then
					return true
				elseif Ball and Ball:FindFirstChild("GetTargetCharacter") then
					local Character = Ball:FilterType("GetTargetCharacter"):Invoke()
					if Character == LocalPlayer.Character or Character == LocalPlayer then
						return true
					end
				end
			end
			
			__Ball.Parry = function(self, Ball, Spam, Velocity)
				if Ball then
					local Object = __Player:HumanoidRootPart(LocalPlayer)
					if Velocity then print("Velocity:", Velocity) end
					local Velocity
					pcall(function()
						Velocity = Velocity or Ball.Velocity
					end)
					if not Velocity then Velocity = __Ball.Velocity end
					local DistanceVector = Ball.Position - Object.Position
					local Distance = DistanceVector.Magnitude
					local Range = Velocity.Magnitude >= 1 and 10 + 0.25 * (os.clock() - __Ball.IntervalSpawn) or 10
					local Ping = game.Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
					local EstimatedDistance = (Velocity * (__Ball.Range + Ping)).Magnitude
					
					if (__Player:RunningAway(Ball, Object) and Velocity.Magnitude >= 0) or Spam then
						local EstimatedTime = (Distance / Velocity.Magnitude)
						local EstimatedPosition = Ball.Position + Velocity * EstimatedTime
						local ActualDistance = (Object.Position - EstimatedPosition).Magnitude
						EstimatedDistance = (Velocity * (0.4)).Magnitude
						--warn("Running", EstimatedTime, "<=", __Ball.Range + Ping, "Distance:", Distance, "EstimatedDistance:", EstimatedDistance, "Ball Velocity:", Velocity.Magnitude, "Range:", Range)
						return EstimatedTime <= __Ball.Range + Ping and (Distance <= EstimatedDistance or Distance <= Range)
					end
					
					--warn("Parry Distance:", Distance, "EstimatedDistance:", EstimatedDistance, "Range:", Range)
					return Distance <= EstimatedDistance or Distance <= Range
				end
			end
			
			local ParryAmount = GetParryAmt:InvokeServer()
			local Overlap = OverlapParams["new"]()
			Overlap["FilterType"] = Enum["RaycastFilterType"]["Include"]
			__Ball.Parry = function(self, Ball, Spam, Velocity)
				if Ball then
					local Object = __Player:HumanoidRootPart(LocalPlayer)
					local Velocity
					pcall(function()
						Velocity = Velocity or Ball.Velocity
					end)
					if not Velocity then Velocity = __Ball.Velocity end
					local DistanceVector = Ball.Position - Object.Position
					local Distance = DistanceVector.Magnitude
					local Range = Velocity.Magnitude >= 1 and 10 + 0.25 * (os.clock() - __Ball.IntervalSpawn) or 10
					local Ping = LocalPlayer:GetNetworkPing()
					local EstimatedDistance = (Velocity * (__Ball.Range + Ping)).Magnitude
					
					local Result = 0.55 + Ping 
					Result = Ball.AssemblyLinearVelocity * Result
					Result = Ball.Position + Result
					
					local Result2 = Result - Ball.Position
					Result2 = Result - Ball.Position
					Result2 = Result2 / 2
					Result2 = Ball.Position + Result2
					
					local Result3 = Ball.Position + Result
					Result3 = Result - Ball.Position
					Result3 = Result3 / 2
					
					local Magnitude = Result3.Magnitude
					Magnitude = Magnitude + 10
					
					Overlap["FilterDescendantsInstances"] = {LocalPlayer, LocalPlayer.Character}
					local Parts = workspace:GetPartBoundsInRadius(Ball.Position, EstimatedDistance, Overlap)
					
					if #Parts > 0 then
						print("Returned true parry")
						return true
					end
				end
			end
			
			__Ball.SpamParry = function(self, Ball, Player)
				if Ball and Player then
					local Velocity
					pcall(function()
						Velocity = Velocity or Ball.Velocity
					end)
					if not Velocity then Velocity = __Ball.Velocity end
					local Distance = (__Player:HumanoidRootPart(LocalPlayer).Position - __Player:HumanoidRootPart(Player).Position)
					local PingAccountability = __Ball.Range + game.Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
					local EstimatedDistance = (Velocity * PingAccountability).Magnitude
					
					local Threshold = __Ball.SpamDistance + __Ball.SpamCount / (500 * __Ball.SpamIteration)
					if ((Distance.Magnitude <= Threshold) or (Distance.Magnitude <= EstimatedDistance and Distance.Magnitude <= Threshold)) then
						return true
					end
				end
			end
		--__Ball
		
		--__Button
			__Button.Block = function()
				local Hotbar = PlayerGui:FindFirstChild("Hotbar")
				return Hotbar and Hotbar:FindFirstChild("Block")
			end
			
			__Button.Ability = function()
				local Hotbar = PlayerGui:FindFirstChild("Hotbar")
				return Hotbar and Hotbar:FindFirstChild("Ability")
			end
		--__Button
		
		--__Main
			__Main.FastMode = function(self)
				workspace.DescendantAdded:Connect(function(Instance)
					if __State.FastMode and Instance:IsA("ParticleEmitter") and Instance.Name ~= "SlashEffect" then
						task.spawn(function()
							task.wait()
							Instance:Destroy()
						end)
					end
				end)
				
				local old; old = hookmetamethod and hookmetamethod(game,"__newindex",function(self, k, v)
					if __State.FastMode and typeof(self) == "Instance" and self:IsA("ParticleEmitter") and k == "Parent" and v then
						return nil
					end
					return old(self, k, v)
				end)
			end
			
			local Excempt = {"dash"}
			__Main.BeastMode = function(self)
				if __State.BeastMode then
					for _, Instance in pairs(Upgrades:GetChildren()) do
						if table.find(Excempt, Instance.Name:lower()) then
							Instance.Value = math.huge
						end
					end
					
					if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Abilities") then
						for _, Instance in pairs(LocalPlayer.Character.Abilities:GetChildren()) do
							if table.find(Excempt, Instance.Name:lower()) then
								Instance.Disabled = false
								Instance.Enabled = true
							end
						end
					end
				elseif not __State.BeastMode then
					for _, Instance in pairs(Upgrades:GetChildren()) do
						if table.find(Excempt, Instance.Name:lower()) then
							Instance.Value = 2
						end
					end
				end
			end
			
			local BlockCanCall = false
			__Main.BlockEvent = function(self)
				local Signals, Loop, HeldDown = {}, false, false
				local function Input(Button1, Button2)
					for i, Signal in pairs(Signals) do Signal:Disconnect() Signals[i] = nil end
					
					-- Block
					Signals[#Signals+1] = Button1.InputBegan:Connect(function(input)
						if __State.BlockSpamParry and BlockCanCall and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not Loop then
							input.Changed:Connect(function()
								if input.UserInputState == Enum.UserInputState.End then
									Loop = false
								end
							end)
							Loop = true
							while Loop or __Fire.BlockMode == "Toggle" and BlockCanCall do
								for i = 1, __Ball.SpamIteration do
									__Fire:Parry()
									__Ball.SpamCount = __Ball.SpamCount + 1
								end
								RunService.PostSimulation:Wait()
							end
						end
					end)
					
					Signals[#Signals+1] = Button1.MouseButton1Down:Connect(function()
						HeldDown = true
						if __Fire.BlockMode == "Hold" then
							BlockCanCall = true
						elseif __Fire.BlockMode == "Toggle" then
						end
					end)
					
					Signals[#Signals+1] = Button1.MouseButton1Up:Connect(function()
						if __Fire.BlockMode == "Hold" then
							BlockCanCall = false
						elseif __Fire.BlockMode == "Toggle" and HeldDown then
							BlockCanCall = not BlockCanCall
							warn("BlockCanCall:", BlockCanCall)
							while BlockCanCall do
								for i = 1, __Ball.SpamIteration do
									__Fire:Parry()
									__Ball.SpamCount = __Ball.SpamCount + 1
								end
								RunService.PostSimulation:Wait()
							end
						end
						HeldDown = false
					end)
				end
				
				Input(__Button:Block(), __Button:Ability())
				
				PlayerGui.ChildAdded:Connect(function(Child)
					if Child.Name == "Hotbar" then
						Input(Child:WaitForChild("Block"), Child:WaitForChild("Ability"))
					end
				end)
			end
			
			local IsLooped, Iteration = nil, 0
			__Main.Parry = function(self, Ball, Target, Player)
				if Ball and Ball.Parent then
					--if not UserInputService:GetFocusedTextBox() and __Player.SpamBind and UserInputService:IsKeyDown(__Player.SpamBind) then
						--__Fire:Parry()
					if not __Ball:Target(Ball) then
					elseif __State.AutoParry and not __Ball.Debounce then
						if __Ball:Target(Ball) and __Ball:Parry(Ball) then
							--[[
							if __Ball.LastTarget and __Ball.LastTarget.Parent then
								IsLooped = true
								local OldLastTarget = __Ball.LastTarget
								while OldLastTarget and OldLastTarget.Parent and __Player:Alive(LocalPlayer) and __Player:Alive(OldLastTarget) and __Ball:Distance(Ball, OldLastTarget, 5) do
									warn("Still directed to", OldLastTarget)
									RunService.PostSimulation:Wait()
								end
								IsLooped = false
							end
							--]]
							local Direct, Point = __Ball:Directed(Ball, LocalPlayer)
							if Direct and __Ball:Target(Ball) then
								local BallDistance = (__Player:HumanoidRootPart(LocalPlayer).Position - Ball.Position).Magnitude
								if (Iteration >= 0 or Iteration >= Iteration*(BallDistance/25)) then
									warn("Normal parry")
									__Fire:Parry()
									Iteration = 0
									return
								end
								warn("Iteration:", Iteration)
								Iteration = Iteration + 1
							end
						end
					end
				end
			end
			
			
			local IsLooped = false
			__Main.SpamParry = function(self, Player)
				if __State.AutoSpamParry and not IsLooped then
					IsLooped = true
					warn("LastParried:", __Player.LastParried)
					while __Player:Playing() and __Player:Alive(LocalPlayer) and __Player:Alive(__Ball.LastTarget) and __Player.LastParried and __Player.LastParried <= __Ball.SpamTimeThreshold do
						for i = 1, __Ball.SpamIteration do
							__Fire:Parry()
							__Ball.SpamCount = __Ball.SpamCount + 1
						end
						task.wait()
					end
					IsLooped = false
				end
			end
			
			__Main.VisualizePath = function(self, Ball, Player)
				if __State.VisualizePath and Ball and Player then
					local HumanoidRootPart = __Player:HumanoidRootPart(Player)
					local Data = {
						Spacing = 10,
						Radius = 1,
						Parent = DotsFolder
					}
					Create:Path(Ball, HumanoidRootPart, Data)
				end
			end
			
			__Main.FollowBall = function(self, Ball)
				if __State.FollowBall then
					local Velocity
					pcall(function()
						Velocity = Velocity or Ball.Velocity
					end)
					if not Velocity then Velocity = __Ball.Velocity end
					__Player:FollowBall(Ball)
					if (Ball and __Ball:Target(Ball)) and Velocity.Magnitude > 1 then
						__State.FollowBall = false
						__Fire:Parry()
						repeat
							LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(Ball.Position) + Vector3.new(0, -5, 0))
							RunService.PostSimulation:Wait()
						until not __Ball.Debounce
						__State.FollowBall = true
					end
					
					return false
				end
			end
			
			__Main.AutoMove = function(self)
				if __State.AutoMove and __Ball.LastTarget then
					__Player:WalkTo(__Ball.LastTarget)
				end
			end
			
			local PrevPosition, Distance = nil, Vector3.new(0, 0, 0)
			__Main.PreSimulation = function(self, Delta)
				local Ball = __Ball:RealBall()
				
				if __State.AimCamera then
					local Ball = __Ball:RealBall()
					__Cam:LookAt(Ball)
				end
				
				if Ball then
					if PrevPosition then
						__Ball.Velocity = Distance / Delta
						Distance = (Ball.Position - PrevPosition)
					end
					PrevPosition = Ball.Position
				end
			end
			
			__Main.PostSimulation = function(self, Delta)
				local Ball = __Ball:RealBall()
				local Target = Ball and Ball:GetAttribute('target')
				local Player = Target and Players:FindFirstChild(Target) or Target and workspace.Alive:FindFirstChild(Target)
				
				__Ball:Speed(Ball)
				
				if Player and not (Player == LocalPlayer or Player == __Ball.LastTarget) then
					__Ball.ParryCount = 0
					__Ball.SpamCount = 0
				end
				
				if not __Player:Alive() then
					__Player.LastParried = os.clock()
				end
				
				task.spawn(function() __Main:BeastMode() end)
				
				task.spawn(function() __Main:VisualizePath(Ball, Player) end)
				
				task.spawn(function() __Main:FollowBall(Ball) end)
				
				task.spawn(function() __Main:AutoMove() end)
				
				task.spawn(function() __Main:Parry(Ball, Target, Player) end)
				
				task.spawn(function() __Main:SpamParry(Player) end)
				
				if Player ~= LocalPlayer then
					__Ball.LastTarget = Player
				end
			end
		--__Main
		
		-- Initial
			--game:GetService("ReplicatedStorage").Remotes.Store.GetOwnedAbilities:InvokeServer()
			
			--game:GetService("ReplicatedStorage").Remotes.kebaind:FireServer()
			
			__Main:FastMode()
			
			__Main:BlockEvent()
			
			RunService.PreSimulation:Connect(function(Delta)
				__Main:PreSimulation(Delta)
			end)
			
			RunService.PostSimulation:Connect(function(Delta)
				__Main:PostSimulation(Delta)
			end)
			
			function BallState(Instance)
				print("Instance:", "(" .. Instance.Name .. ")")
				if Instance.Name == "zapper" then
					task.wait(2)
					print("Telekinesis")
					local Ball = __Ball:RealBall()
					if __Ball:Target() and __Ball:Parry(Ball, false, __Ball.LastSpeed) then
						warn("Special Parry")
						__Fire:Parry()
					end
				elseif Instance.Name == "FREEZER" then
					task.wait(5)
					print("Freezer")
					local Ball = __Ball:RealBall()
					if __Ball:Target() and __Ball:Parry(Ball, false, __Ball.LastSpeed) then
						warn("Special Parry")
						__Fire:Parry()
					end
				end
			end
			
			function BallsChildAdded(Ball)
				if Ball then
					pcall(function()
						__Ball.LastSpeed = Ball.Velocity
					end)
					if not __Ball.LastSpeed then __Ball.LastSpeed = __Ball.Velocity end
					__Ball.Velocity = Vector3.new(0, 0, 0)
					Ball.DescendantAdded:Connect(BallState)
				end
				
				__Ball.IntervalSpawn = os.clock()
				__Ball.LastParried = os.clock()
				__Player.LastParried = os.clock()
			end
			
			workspace.Balls.ChildAdded:Connect(BallsChildAdded)
			
			for _, Ball in pairs(workspace.Balls:GetChildren()) do
				BallsChildAdded(Ball)
			end
			
			workspace.Map.DescendantAdded:Connect(function(Instance)
				if Instance.Name == "BottomCircle" then
					__Map.GroundLevel = Instance.Position.Y + Instance.Size.Y
					__Ball.ParryCount = 0
					__Ball.SpamCount = 0
				end
			end)
			
			for _, Instance in pairs(workspace.Map:GetDescendants()) do
				if Instance.Name == "BottomCircle" then
					__Map.GroundLevel = Instance.Position.Y + Instance.Size.Y
				end
			end
			
			Remotes.BallAdded.OnClientEvent:Connect(function(Ball)
				warn("BallAdded:", Ball)
			end)
			
			Remotes.BallRemoved.OnClientEvent:Connect(function(...)
				warn("BallRemoved:", ...)
			end)
			
			Remotes.Killed.OnClientEvent:Connect(function(...)
				warn("Killed:", ...)
			end)
			
			Remotes.ParryAttemptAll.OnClientEvent:Connect(function(Fx, Player)
				warn("ParryAttemptAll:", Fx, "Player:", Player, Player.Parent)
				if Player == LocalPlayer.Character then
					--VisualCDFire(true, nil, 1.3)
				end
			end)
			
			local LastParried, LastLocalParried = os.clock(), os.clock()
			Remotes.ParrySuccessAll.OnClientEvent:Connect(function(Fx, Player)
				warn("ParrySuccessAll:", Fx, "Player:", Player, Player.Parent)
				__Ball.LastParried = os.clock() - LastParried
				LastParried = os.clock()
				if Player == __Player:HumanoidRootPart(LocalPlayer) then -- Check time gap on us deflecting
					__Ball.ParryCount = __Ball.ParryCount + 1
					
					task.spawn(function()
						while __Ball:Directed(__Ball:RealBall(), LocalPlayer) do task.wait() end
						VisualCDFire(true, nil, nil)
					end)
					
					__Player.LastParried = os.clock() - LastLocalParried
					LastLocalParried = os.clock()
				elseif Player ~= __Player:HumanoidRootPart(__Ball.LastTarget) then
					__Player.LastParried = nil
				end
			end)
			
			Remotes.UnParry.OnClientEvent:Connect(function(...)
				warn("UnParry:", ...)
			end)
			
			Remotes.PlrDashed.OnClientEvent:Connect(function(...)
				warn("PlrDashed:", ...)
			end)
			
			Remotes.PlrPulled.OnClientEvent:Connect(function(...)
				warn("PlrPulled:", ...)
			end)
			
			Remotes.EndCD.OnClientEvent:Connect(function(...)
				warn("EndCD:", ...)
				VisualCDFire(true, nil, nil)
				VisualCDFire(false, true, nil)
				__Player.LastParried = nil
			end)
			
			__Function:CharacterDied(LocalPlayer.Character, function(Character)
				if (__State.AutoParry or __State.AutoSpamParry) then
					ArrayField:Notify({Title = "Death", Content = "Seems like you died. Here are possible causes: misclick, desync, latency spike, or lag spike.", Duration = 15})
					BallsChildAdded()
				end
			end, true)
			
			game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(Character)
				for _, Func in pairs(CharacterAddedFunctions) do
					Func(Character)
				end
			end)
			
			UserInputService.InputBegan:Connect(function(input)
				if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
					local Index = #__State.TouchPoints + 1
					__State.TouchPoints[Index] = input
					
					input.Changed:Connect(function()
						if input.UserInputState == Enum.UserInputState.End then
							table.remove(__State.TouchPoints, Index)
						end
					end)
				end
			end)
		-- Initial
		
		-- UI Library
		local Exploit = Window:CreateTab("Exploit", 4483362458) -- Title, Image
		local Combat = Exploit:CreateSection("Combat", false)
		local Macro = Exploit:CreateSection("Macro", false)
		local Config = Exploit:CreateSection("Config", false)
		
		-- Combat
			Toggles["AutoParry"] = Exploit:CreateToggle({
				Name = "Auto Parry",
				CurrentValue = __Config.AutoParry,
				SectionParent = Combat,
				Callback = function(Value)
					__State.AutoParry = Value
					__Config.AutoParry = Value
				end,
			})
			
			Toggles["AutoSpamParry"] = Exploit:CreateToggle({
				Name = "Auto Spam Parry",
				CurrentValue = __Config.AutoSpamParry,
				SectionParent = Combat,
				Callback = function(Value)
					__State.AutoSpamParry = Value
					__Config.AutoSpamParry = Value
				end,
			})
			
			Toggles["FollowBall"] = Exploit:CreateToggle({
				Name = "Follow Ball",
				CurrentValue = __State.FollowBall,
				SectionParent = Combat,
				Callback = function(Value)
					__State.FollowBall = Value
				end,
			})
			
			Toggles["CanCollide"] = Exploit:CreateToggle({
				Name = "No-Clip",
				CurrentValue = not __Player.Collision,
				SectionParent = Combat,
				Callback = function(Value)
					__Player:CanCollide(not Value)
				end,
			})
			
			Toggles["AutoMove"] = Exploit:CreateToggle({
				Name = "Auto Move",
				CurrentValue = __State.AutoMove,
				SectionParent = Combat,
				Callback = function(Value)
					__State.AutoMove = Value
				end,
			})
			
			warn(__Config.Range)
			
			Sliders["Range"] = Exploit:CreateSlider({
				Name = "Parry Range (Recommended 0.5)",
				Range = {0.3, 1},
				Increment = 0.05,
				Suffix = "Range",
				CurrentValue = __Config.Range,
				SectionParent = Combat,
				Callback = function(Value)
					__Ball.Range = Value
					__Config.Range = Value
				end,
			})
			
			Sliders["DirectPoint"] = Exploit:CreateSlider({
				Name = "Direct Point (Recommended -0.25 to 0)",
				Range = {-0.5, 0.5},
				Increment = 0.05,
				Suffix = "Point",
				CurrentValue = __Config.DirectPoint,
				SectionParent = Combat,
				Callback = function(Value)
					__Ball.DirectPoint = Value
					__Config.DirectPoint = Value
				end,
			})
			
			Sliders["SpamDistance"] = Exploit:CreateSlider({
				Name = "Spam Distance (Recommended 20 to 30)",
				Range = {20, 60},
				Increment = 5,
				Suffix = "Distance",
				CurrentValue = __Config.SpamDistance,
				SectionParent = Combat,
				Callback = function(Value)
					__Ball.SpamDistance = Value
					__Config.SpamDistance = Value
				end,
			})
			
			Sliders["SpamIteration"] = Exploit:CreateSlider({
				Name = "Spam Iteration (Recommended 1 to 2)",
				Range = {1, 50},
				Increment = 1,
				Suffix = "Distance",
				CurrentValue = __Config.SpamIteration,
				SectionParent = Combat,
				Callback = function(Value)
					__Ball.SpamIteration = Value
					__Config.SpamIteration = Value
				end,
			})
			
			Sliders["SpamTimeThreshold"] = Exploit:CreateSlider({
				Name = "Spam Time Threshold (Recommended 0.3)",
				Range = {0.05, 1},
				Increment = 0.025,
				Suffix = "Threshold",
				CurrentValue = __Config.SpamTimeThreshold,
				SectionParent = Combat,
				Callback = function(Value)
					__Ball.SpamTimeThreshold = Value
					__Config.SpamTimeThreshold = Value
				end,
			})
		-- Combat
		
		-- Macro
			--[[
			Inputs["Keybind"] = Exploit:CreateInput({
				Name = "Keybind",
				PlaceholderText = "V",
				CharacterLimit = 1,
				RemoveTextAfterFocusLost = false,
				SectionParent = Macro,
				Callback = function(Text)
					__Player.SpamBind = loadstring("return Enum.KeyCode[" .. tostring(Text:upper()) .. "]")()
					__Config.SpamBind = __Player.SpamBind
				end,
			})]]
			
			Toggles["VisualizePath"] = Exploit:CreateToggle({
				Name = "Visualize Path",
				CurrentValue = __Config.VisualizePath,
				SectionParent = Macro,
				Callback = function(Value)
					__State.VisualizePath = Value
					__Config.VisualizePath = Value
				end,
			})
			
			Toggles["FreezeBall"] = Exploit:CreateToggle({
				Name = "Freeze Ball",
				CurrentValue = __State.FreezeBall,
				SectionParent = Macro,
				Callback = function(Value)
					__State.FreezeBall = Value
					while __State.FreezeBall do
						game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Freeze"):FireServer()
						task.wait()
					end
				end,
			})
		-- Macro
		
		-- Config
			Buttons["SaveConfig"] = Exploit:CreateButton({
				Name = "Save Config",
				SectionParent = Config,
				Callback = function()
					local JSON = HttpService:JSONEncode(__Config)
					print(JSON)
					writefile(path .. "config.json", JSON)
				end,
			})
			
			Toggles["HideButton"] = Exploit:CreateToggle({
				Name = "Hide Button",
				CurrentValue = false,
				SectionParent = Config,
				Callback = function(Value)
					ArrayField.UniButton.ImageTransparency = Value and 1 or not Value and 0
				end,
			})
			
			Toggles["UnlockFPS"] = Exploit:CreateToggle({
				Name = "Unlock FPS",
				CurrentValue = false,
				SectionParent = Config,
				Callback = function(Value)
					if setfpscap then
						print(Value and math.huge or not Value and 60)
						setfpscap(Value and math.huge or not Value and 60)
					end
				end,
			})
			
			Toggles["SafetyMode"] = Exploit:CreateToggle({
				Name = "Safety Mode (Unlock)",
				CurrentValue = __State.SafetyMode,
				SectionParent = Config,
				Callback = function(Value)
					__State.SafetyMode = Value
					local function State(Element)
						if Value then
							Element:Lock()
						else
							Element:Unlock()
						end
					end
					
					State(Sliders["WalkSpeed"])
					State(Toggles["FreezeBall"])
					State(Toggles["FollowBall"])
					State(Toggles["CanCollide"])
					State(Toggles["BeastMode"])
					
					if not Value then
						ArrayField:Notify({Title = "Safety Mode Disabled", Content = "Features that can increase your chance of being banned has been unlocked."})
					end
				end,
			})
			
			Toggles["FastMode"] = Exploit:CreateToggle({
				Name = "Fast Mode",
				CurrentValue = __Config.FastMode,
				SectionParent = Config,
				Callback = function(Value)
					__State.FastMode = Value
					__Config.FastMode = Value
				end,
			})
			
			Toggles["BeastMode"] = Exploit:CreateToggle({
				Name = "Beast Mode",
				CurrentValue = __State.BeastMode,
				SectionParent = Config,
				Callback = function(Value)
					__State.BeastMode = Value
				end,
			})
			
			local TargetingModeOptions = {"Nearest to Mouse", "Closest Player", "Furthest Player", "Last Targeted Player", "Weakest Player", "Strongest Player"}
			Dropdowns["TargetingMode"] = Exploit:CreateDropdown({
				Name = "Targeting Mode",
				Options = TargetingModeOptions,
				CurrentOption = __Config.TargetMode,
				MultiSelection = false,
				SectionParent = Config,
				Callback = function(Option)
					__Fire.TargetMode = Option
					__Config.TargetMode = __Fire.TargetMode
				end,
			})
			
			Toggles["AimCamera"] = Exploit:CreateToggle({
				Name = "Aim Camera at the Ball",
				CurrentValue = __State.AimCamera,
				SectionParent = Config,
				Callback = function(Value)
					__State.AimCamera = Value
				end,
			})
			
			Toggles["BlockSpamParry"] = Exploit:CreateToggle({
				Name = "Block Spam Parry",
				CurrentValue = __Config.BlockSpamParry,
				SectionParent = Config,
				Callback = function(Value)
					__State.BlockSpamParry = Value
					__Config.BlockSpamParry = Value
				end,
			})
			
			local BlockModeOptions = {"Hold", "Toggle"}
			Dropdowns["BlockMode"] = Exploit:CreateDropdown({
				Name = "Block Mode",
				Options = BlockModeOptions,
				CurrentOption = __Config.BlockMode,
				MultiSelection = false,
				SectionParent = Config,
				Callback = function(Option)
					__Fire.BlockMode = Option
					__Config.BlockMode = __Fire.BlockMode
				end,
			})
			
			Toggles["CurveBall"] = Exploit:CreateToggle({
				Name = "Auto Curve Ball",
				CurrentValue = __Config.CurveBall,
				SectionParent = Config,
				Callback = function(Value)
					__State.CurveBall = Value
					__Config.CurveBall = Value
				end,
			})
			
			local CurvingModeOptions = {"Random", "Upwards", "Backwards", "Forward", "Default"}
			Dropdowns["CurvingMode"] = Exploit:CreateDropdown({
				Name = "Curving Mode",
				Options = CurvingModeOptions,
				CurrentOption = __Config.CurvingMode,
				MultiSelection = false,
				SectionParent = Config,
				Callback = function(Option)
					__Fire.CurvingMode = Option
					__Config.CurvingMode = __Fire.CurvingMode
				end,
			})
			
			Sliders["WalkSpeed"] = Exploit:CreateSlider({
				Name = "Walk Speed",
				Range = {16, 160},
				Increment = 1,
				Suffix = "Speed",
				CurrentValue = __Player:Humanoid(LocalPlayer).WalkSpeed,
				SectionParent = Combat,
				Callback = function(Value)
					__Player:Humanoid(LocalPlayer).WalkSpeed = Value
				end,
			})
			
			--[
			Toggles["DebugMode"] = Exploit:CreateToggle({
				Name = "Debug Mode",
				CurrentValue = __Config.DebugMode,
				SectionParent = Config,
				Callback = DebugMode,
			})
			--]]
			
			--[[
			Toggles["RageParry"] = Exploit:CreateToggle({
				Name = "Auto Rage Parry",
				CurrentValue = __State.RageParry,
				SectionParent = Config,
				Callback = function(Value)
					__State.RageParry = Value
					if Value then
						ArrayField:Notify({Title = "Auto Rage Parry Usage", Content = "Enable Auto Parry from Combat for Auto Rage Parry to work."})
					end
				end,
			})
			]]
		-- Config
		
		if __State.SafetyMode then -- Safety Mode
			Sliders["WalkSpeed"]:Lock()
			Toggles["FreezeBall"]:Lock()
			Toggles["FollowBall"]:Lock()
			Toggles["CanCollide"]:Lock()
			Toggles["BeastMode"]:Lock()
		end
