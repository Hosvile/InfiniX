local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Hosvile/InfiniX/main/Library/User%20Interface/main.lua", true))("Infinixity")
-- Library

local service = setmetatable({}, {
	__index = function(self, key)
		return cloneref(game.GetService(game, key))
	end
})

local Players = service.Players
local LocalPlayer = Players.LocalPlayer

--References
local RunService = service.RunService
local CoreGui = service.CoreGui
--CoreGui = LocalPlayer.PlayerGui
local TweenService = service.TweenService
local UserInputService = service.UserInputService


local Mouse = LocalPlayer:GetMouse()

-- Template
--[[
local Core = Library:Init({
	Name = "Infinixity";
	Parent = LocalPlayer.PlayerGui;
	Theme_ = {
		Primary = { -- 6
			{
				Color = Color3.fromRGB(10, 10, 10);
				Gradient = Color3.fromRGB(173, 254, 151);
			};
			{
				Color = Color3.fromRGB(20, 20, 20);
				Gradient = Color3.fromRGB(131, 193, 115);
			};
			{
				Color = Color3.fromRGB(30, 30, 30);
				Gradient = Color3.fromRGB(86, 181, 141);
			};
			{
				Color = Color3.fromRGB(40, 40, 40);
				Gradient = Color3.fromRGB(117, 254, 162);
			};
			{
				Color = Color3.fromRGB(50, 50, 50);
				Gradient = Color3.fromRGB(0, 254, 151);
			};
			{
				Color = Color3.fromRGB(255, 255, 255);
				Gradient = Color3.fromRGB(255, 255, 255);
			};
		};
		Secondary = { -- 6
			{
				Color = Color3.fromRGB(70, 70, 70);
				Gradient = Color3.fromRGB(70, 90, 70);
			};
			{
				Color = Color3.fromRGB(80, 80, 80);
				Gradient = Color3.fromRGB(80, 100, 80);
			};
			{
				Color = Color3.fromRGB(90, 90, 90);
				Gradient = Color3.fromRGB(90, 110, 90);
			};
			{
				Color = Color3.fromRGB(100, 100, 100);
				Gradient = Color3.fromRGB(100, 120, 100);
			};
			{
				Color = Color3.fromRGB(110, 110, 110);
				Gradient = Color3.fromRGB(110, 130, 110);
			};
			{
				Color = Color3.fromRGB(120, 120, 120);
				Gradient = Color3.fromRGB(120, 140, 120);
			};
		};
	}
})

Core:Validate({
	Name = "Infinixity";
	Tutorial = true;
	Validate = "abc";
	Buttons = {
		{
			Name = "PandaDev";
			Image = "http://www.roblox.com/asset/?id=16438925153";
			Function = function(self)
				print("PandaDev")
			end
		};
		{
			Name = "Magixx",
			Image = "",
			Function = function(self)
				print("Magixx")
			end
		}
	};
	Function = function(self, Value, Input)

	end
})

for i = 1, 5 do
	Core:Notify({
		Name = "Infinixity" .. tostring(i);
		Title = "Title" .. tostring(i);
		Body = "Body";
		Buttons = {
			{
				Name = "Yes";
				Function = function(self)
					print("Yes")
				end;
			};
			{
				Name = "No";
				Function = function(self)
					print("No")
				end;
			}
		}
	})
end

local Window = Core:CreateWindow({
	Name = "Infinixity";
	Scale = 0.75;
})

local Tab, Section
for i = 1, 40 do
	Tab = Window:CreateTab({
		Name = ("Tab %d"):format(i);
	})
	task.wait()
	for i = 1, 2 do
		Section = Tab:CreateSection({
			Name = ("Section %d"):format(i);
		})
		Section:CreateSpacing({})
		Section:CreateLabel({
			Name = "Label";
		})
		Section:CreateParagraph({})
		Section:CreateButton({
			Name = "Button";
			Body = string.rep("Body", 5);
			Function = function(self) -- : Nil
				game:GetService("StarterGui"):SetCore("DevConsoleVisible",true)
			end;
		})
		Section:CreateButton({
			Name = "Button";
			Body = string.rep("Body", 5);
			Function = function(self) -- : Nil
				game:Shutdown()
			end;
		})
		Section:CreateToggle({
			Name = "Toggle";
			Body = string.rep("Body", 5);
			Init = true;
			State = false;
			Function = function(self, Value) -- : Boolean
				warn("	Toggle:", Value)
			end;
		})
		Section:CreateDropdown({
			Name = "Dropdown";
			Body = string.rep("Body", 5);
			Init = true;
			State = false;
			Table = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K"};
			Function = function(self, Value) -- : String
				warn("	Dropdown:", Value)
			end;
		})
		Section:CreateDropdown({
			Name = "Dropdown";
			Body = string.rep("Body", 5);
			Init = true;
			State = false;
			Table = {A = "A", B = "B"};
			Selected = {}; -- If defined the dropdown becomes a multi
			Function = function(self, Value) -- : Table -- Input is Dropdown still open or not : Boolean
				warn("	Dropdown:", Value)
				table.foreach(Value, print)
			end;
		})
		local Dropdown = Section:CreateDropdown({
			Name = "Dropdown";
			Body = string.rep("Body", 5);
			Init = false;
			State = false;
			Table = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K"};
			Selected = {"A"}; -- If defined the dropdown becomes a multi
			Function = function(self, Value, Input) -- : Table -- Input is Dropdown still open or not : Boolean
				warn("	Dropdown:", Value)
				table.foreach(Value, print)
			end;
		})
		Dropdown:Set("Table", {"A", "B", "C"})
		Dropdown:Set("Selected", {"B"})
		local Slider = Section:CreateSlider({
			Name = "Slider";
			Init = true;
			Min = 1;
			Max = 10;
			Value = 1;
			Increment = 1;
			Function = function(self, Value, Input) -- : Number -- Input is whether we're still sliding or not : Boolean
				warn("	Slider:", Value, Input)
			end;
		})
		task.spawn(function()
			while task.wait(0.5) do
				local Ping

				--pcall(function()
				Ping = LocalPlayer:GetNetworkPing()
				--end)

				if not Ping then Ping = 0.05 end

				--Slider:Set("Value", 0.3-0.05 + 0.05 * (Ping/0.05))
				--Slider:Call()
			end
		end)
		Section:CreateInput({
			Name = "Input";
			Init = true;
			Text = "";
			Placeholder = "";
			ContentText = false; -- Whether we get the ContentText or Text
			ClearTextOnFocus = false;
			Function = function(self, Value, Input) -- Value is the text on the TextBox: String -- Input is whether we entered or not : Boolean
				warn("	Input:", Value, Input)
			end;
		})
		Section:CreateKeybind({
			Name = "Keybind";
			Init = true;
			Keybind = "a";
			Function = function(self, Value) -- Value is the key pressed to call this function: KeyCode
				warn("	Keybind:", Value)
			end;
		})
		Section:CreateColorPicker({
			Name = "ColorPicker";
			Init = true;
			Color = Color3.new(1, 1, 1);
			Function = function(self, Value) -- Value is a Color3: Color3
				warn("	ColorPicker:", Value)
			end;
		})
		Section:CreateDropdown({
			Name = "Dropdown";
			Body = string.rep("Body", 5);
			Init = true;
			State = false;
			Table = {A = "A", B = "B"};
			Function = function(self, Value) -- : String
				warn("	Dropdown:", Value)
			end;
		})
		Section:CreateDropdown({
			Name = "Dropdown";
			Body = string.rep("Body", 5);
			Init = true;
			State = false;
			Table = {A = "A", B = "B"};
			Selected = {}; -- If defined the dropdown becomes a multi
			Function = function(self, Value) -- : Table
				warn("	Dropdown:", Value)
				table.foreach(Value, print)
			end;
		})
		local Dropdown = Section:CreateDropdown({
			Name = "Dropdown";
			Body = string.rep("Body", 5);
			Init = false;
			State = false;
			Table = {"A", "B"};
			Selected = {"A"}; -- If defined the dropdown becomes a multi
			Function = function(self, Value) -- : Table
				warn("	Dropdown:", Value)
				table.foreach(Value, print)
			end;
		})
		Dropdown:Set("Table", {"A", "B", "C"})
		Dropdown:Set("Selected", {"B"})
	end
end

local Section
for i = 1, 1 do

end

for i = 1, 1 do

end
--]]
-- Template

-- Initial
getgenv().getnilinstances = getnilinstances or function()
	local nilTable = {}

	for _, regVal in next, getreg() do
		if typeof(regVal) == "table" then
			for _, tableItem in next, regVal do
				if typeof(tableItem) == "Instance" then
					table.insert(nilTable, tableItem)
				end
			end
		end
	end

	return nilTable
end

-- Services
local Workspace = service.Workspace
local Camera = Workspace.CurrentCamera
local HttpService = service.HttpService
local StarterGui = service.StarterGui
local StarterPlayer = service.StarterPlayer
local RunService = service.RunService
local TweenService = service.TweenService
local UserInputService = service.UserInputService
local ReplicatedStorage = service.ReplicatedStorage
local ReplicatedFirst = service.ReplicatedFirst
local VirtualInputManager = service.VirtualInputManager
local VirtualUser = service.VirtualUser
local Players = service.Players

-- Players
local LocalPlayer = Players.LocalPlayer

-- Folders
local PlayerGui = LocalPlayer.PlayerGui
local PlayerScripts = LocalPlayer.PlayerScripts
local StarterPlayerScripts = StarterPlayer.StarterPlayerScripts

-- Functions
local Function = {}

Function.RecurseTable = function(self, Table, Func)
	for key, value in pairs(Table) do
		Func(key, value)

		if type(value) == "table" and value ~= Table then
			self:RecurseTable(value, Func)
		end
	end
end

Function.CloneTable = function(self, Table)
	local Tables = {}
	local Table_Clone = {}

	table.insert(Tables, Table)

	for key, value in pairs(Table) do
		if type(value) == "table" and value ~= Table and not table.find(Tables, value) then
			value = self:CloneTable(value)
		end

		rawset(Table_Clone, key, value)
	end

	return Table_Clone
end

Function.EQTable = function(self, Table, Table2)
	for key, value in pairs(Table) do
		if Table[key] ~= Table2[key] then
			return false
		end
	end

	return true
end

Function.MapTable = function(self, Table)

end

Function.GetHumanoid = function(self, Character)
	if Character then
		if Character:IsA("Player") then
			Character = Character.Character
		end
		
		return Character and Character:FindFirstChildWhichIsA("Humanoid")
	end
end

Function.GetHumanoidRootPart = function(self, Character)
	local Humanoid = Function:GetHumanoid(Character)
	
	if Humanoid and Humanoid.RootPart then
		return Humanoid.RootPart
	end
end

Function.GetModelCFrame = function(self, Model)
	return ({Model:GetBoundingBox()})[1]
end

Function.SetupScript = function(self, Script)
	return {
		Script = Script,
		Closure = getscriptclosure(Script)
	}
end

Function.SetupModule = function(self, Module)
	return {
		Module = Module,
		Required = require(Module),
		Closure = getscriptclosure(Module)
	}
end

Function.CenterOfVectors = function(self, Vectors)
	local minX, maxX = math.huge, -math.huge
	local minY, maxY = math.huge, -math.huge
	local minZ, maxZ = math.huge, -math.huge

	for _, v in pairs(Vectors) do
		if (v.X < minX) then
			minX = v.X
		end
		if (v.X > maxX) then
			maxX = v.X
		end
		if (v.Y < minY) then
			minY = v.Y
		end
		if (v.Y > maxY) then
			maxY = v.Y
		end
		if (v.Z < minZ) then
			minZ = v.Z
		end
		if (v.Z > maxZ) then
			maxZ = v.Z
		end
	end

	local minVector = Vector3.new(minX, minY, minZ)
	local maxVector = Vector3.new(maxX, maxY, maxZ)

	local center = minVector:Lerp(maxVector, 0.5)

	return center
end

Function.IsNetworkOwner = function(self, Object)
	local Humanoid = {
		LocalPlayer = Function:GetHumanoid(LocalPlayer.Character)
	}

	return isnetworkowner and isnetworkowner(Object) or
			   (Humanoid.LocalPlayer.RootPart.Position - Object.Position).Magnitude <= LocalPlayer.SimulationRadius or
			   Object:IsDescendantOf(LocalPlayer.Character) -- or Object:IsA("BasePart") and not Object.Anchored
end

Function.Click = function(self)
	VirtualUser:CaptureController()
	VirtualUser:Button1Down(Vector2.new(851, 158))
end

Function.Random = function(self, Choices)
	local Sum = 0
	
	for _, Choice in next, Choices do
		Sum = Sum + Choice.Weight
	end
	
	if Sum > 0 then
		Sum = math.random(0, Sum)
	end
	
	for _, Choice in next, Choices do
		Sum = Sum - Choice.Weight
		
		if Sum <= 0 then
			return Choice.Value
		end
	end
end

do
	local CharacterAddedFunctions = {}
	Function.CharacterAdded = function(self, Character, Func, Fire)
		CharacterAddedFunctions[#CharacterAddedFunctions + 1] = Func
		if Fire then
			Func(Character)
		end
	end

	Function.CharacterDied = function(self, Character, Func, Fire)
		local Index = #CharacterAddedFunctions + 1
		CharacterAddedFunctions[Index] = function(Character)
			local Humanoid = Character:WaitForChild("Humanoid")
			Humanoid = Humanoid:IsA("Humanoid") and Humanoid or Character:FindFirstChildWhichIsA("Humanoid")
			if Humanoid then
				Humanoid.Died:Connect(Func)
			end
		end

		if Fire then
			CharacterAddedFunctions[Index](Character)
		end
	end

	LocalPlayer.CharacterAdded:Connect(function(Character)
		for _, Func in pairs(CharacterAddedFunctions) do
			Func(Character)
		end
	end)
end

do
	local Tween = nil

	Function.TweenObject = function(self, State, Frame, Object)
		if not State and Tween then
			Tween:Cancel()

			Tween = nil
		elseif State and not Tween then
			local Distance = (Frame.Position - Object.CFrame.Position).Magnitude

			local NewCFrame = {Frame:GetComponents()}
			NewCFrame[1] = Frame.Position.X
			NewCFrame[2] = math.clamp(Frame.Position.Y, 12.5, math.huge)
			NewCFrame[3] = Frame.Position.Z

			Tween = TweenService:Create(Object, TweenInfo.new(Distance / 350, Enum.EasingStyle.Linear), {
				CFrame = CFrame.new(unpack(NewCFrame))
			})

			Tween:Play()
		end
	end
end

Function.TimeToPosition = function(self, Distance, Velocity)
	return (Distance / Velocity.Magnitude).Magnitude
end

Function.TowardsPosition = function(self, Position, Position2, Velocity)
	local Distance = (Position - Position2)
	local DotProduct = Distance and Distance.Unit:Dot(Velocity.Unit)

	return DotProduct
end

Function.FireRemote = function(self, namecall, Remote, ...)
	if Remote:IsA("RemoteEvent") then
		if not namecall then
			Remote:FireServer(...)
		else
			setnamecallmethod("FireServer")
			namecall(Remote, ...)
		end
	elseif Remote:IsA("BindableEvent") then
		if not namecall then
			Remote:Fire(...)
		else
			setnamecallmethod("Fire")
			namecall(Remote, ...)
		end
	end
end

Function.Timer = function(self, Duration)
	local Timestamp = os.clock()
	
	return (function()
		local Time = os.clock() - Timestamp
		
		return Time >= (Duration or 0)
	end)
end

do
	local Players_Cache = {}
	local Functions_Cache = {}

	Function.OnPlayer = function(self, init, func)
		local OnPlayer = function(Player)
			local Signals = {}

			Signals["CharacterAdded"] = Player.CharacterAdded:Connect(function(Character)
				for _, Connection in pairs(Functions_Cache) do
					Connection(Character)
				end
			end)

			Players_Cache[Player] = Signals
		end

		for _, Player in pairs(Players:GetPlayers()) do
			if init then func(Player.Character) end

			OnPlayer(Player)
		end

		Players.PlayerAdded:Connect(function(Player)
			OnPlayer(Player)
		end)

		Players.PlayerRemoving:Connect(function(Player)
			local Signals = Players_Cache[Player]

			if Signals then
				for key, Signal in pairs(Signals) do
					Signal:Disconnect()

					Signals[key] = nil

					Players_Cache[Player] = nil
				end
			end
		end)
	end
end

-- Initial
local Core = Library:Init({
	Name = "Infinixity";
	Parent = nil;
	Theme = {
        Primary = { -- 7
            {
                Color = Color3.fromRGB(255, 255, 255);
                Gradient = Color3.fromRGB(254, 254, 254);
            };
            {
                Color = Color3.fromRGB(60, 60, 60);
                Gradient = Color3.fromRGB(62, 62, 62);
            };
            { -- Inputs
                Color = Color3.fromRGB(50, 50, 50);
                Gradient = Color3.fromRGB(50, 50, 50);
            };
            {
                Color = Color3.fromRGB(150, 150, 150);
                Gradient = Color3.fromRGB(254, 254, 254);
            };
            {
                Color = Color3.fromRGB(255, 255, 255);
                Gradient = Color3.fromRGB(210, 210, 210);
            };
            {
                Color = Color3.fromRGB(255, 255, 255);
                Gradient = Color3.fromRGB(255, 255, 255);
            };
            {
                Color = Color3.fromRGB(0, 0, 0);
                Gradient = Color3.fromRGB(0, 0, 0);
            };
        };
        Secondary = { -- 6
            { 
                Color = Color3.fromRGB(15, 15, 15);
                Gradient = Color3.fromRGB(40, 40, 40);
            };
            { -- Window.Objects.Box
                Color = Color3.fromRGB(40, 40, 40);
                Gradient = Color3.fromRGB(40, 40, 40);
            };
            { -- Containers
                Color = Color3.fromRGB(30, 30, 30);
                Gradient = Color3.fromRGB(40, 40, 40);
            };
            {
                Color = Color3.fromRGB(30, 30, 30);
                Gradient = Color3.fromRGB(40, 40, 40);
            };
            {
                Color = Color3.fromRGB(10, 10, 10);
                Gradient = Color3.fromRGB(10, 10, 10);
            };
            {
                Color = Color3.fromRGB(20, 20, 20);
                Gradient = Color3.fromRGB(20, 20, 20);
            };
        };
    }
})

-- Initial
do
	local Cache = {
		Local = {};
	}
	
	local Debounce = {
	}
	
	-- References
	local Reference = {
	}
	
	-- Modules
	local Modules = {
		
	}

	-- LocalScripts
	local LocalScripts = {
	}

	-- Remotes
	local Remotes = {
	}
	
	-- Signals
	local Signal = setmetatable({}, {
		__newindex = function(self, key, value)
			rawset(self, key, {
				["Signal"] = value,
				["Disconnect"] = function(self)
					value:Disconnect()
					rawset(self, key, nil)
				end
			})
		end
	})
	
	-- Customs
	local Custom = {}
	
	-- Settings
	local Dir = "Infinixity/Touch_Football"
	
	local Data = {
		Info = {
			["Version"] = "1.0.0";
		};
		Toggle = {
			["Modify-WalkSpeed"] = true;
		};
		Dropdown = {
		};
		Slider = {
			["Increment-WalkSpeed"] = 0.25;
		};
		Input = {
		};
	}
	
	if isfile(Dir .. "/config.json") then
		local Config = HttpService:JSONDecode(readfile(Dir .. "/config.json"))

		if Config.Info and Config.Info.Version and Config.Info.Version == Data.Info.Version then
			for key, value in pairs(Config) do
				for key2, value2 in pairs(value) do
					if type(Data[key]) == "table" then
						Data[key][key2] = value2
					end
				end
			end
		end
	end
	
	local Interfaces = {}
	
	-- Window
	local Window = Core:CreateWindow({
		Name = "Infinixity",
		Scale = 1
	})
	
	-- Configuration: Tab
	do
		local Configuration = Window:CreateTab({
			Name = "Configuration"
		})

		-- Combat: Section
		do
			Interfaces.Combat = {
				Label = {};
				Paragraph = {};
				Button = {};
				Toggle = {};
				Dropdown = {};
				Slider = {};
				Input = {};
			}
			
			local Combat = Configuration:CreateSection({
				Name = "Combat"
			})
			
			Interfaces.Combat.Toggle["Modify-WalkSpeed"] = Combat:CreateToggle({
				Name = "Modify WalkSpeed";
				Body = "";
				Init = true;
				State = Data.Toggle["Modify-WalkSpeed"];
				Function = function(self, Value)
					Data.Toggle["Modify-WalkSpeed"] = Value
					
					if Signal["Modify-WalkSpeed"] then Signal["Modify-WalkSpeed"]:Disconnect() end
					
					Signal["Modify-WalkSpeed"] = RunService.PreRender:Connect(function(delta)
						local Humanoid = {
							LocalPlayer = Function:GetHumanoid(LocalPlayer.Character);
						}

						if Humanoid.LocalPlayer and Humanoid.LocalPlayer.RootPart and Humanoid.LocalPlayer.MoveDirection.Magnitude > 0 then
							LocalPlayer.Character:TranslateBy(Humanoid.LocalPlayer.MoveDirection * Humanoid.LocalPlayer.WalkSpeed * delta * Data.Slider["Increment-WalkSpeed"])
						end
					end)
				end;
			})

			Interfaces.Combat.Slider["Increment-WalkSpeed"] = Combat:CreateSlider({
				Name = "Increment WalkSpeed";
				Body = "";
				Init = true;
				Min = 0;
				Max = 3;
				Increment = 0.05,
				Value = Data.Slider["Increment-WalkSpeed"];
				Function = function(self, Value)
					Data.Slider["Increment-WalkSpeed"] = Value
					
				end;
			})
		end

		-- Macro: Section
		do
			Interfaces.Macro = {
				Label = {};
				Paragraph = {};
				Button = {};
				Toggle = {};
				Dropdown = {};
				Slider = {};
				Input = {};
			}
			
			local Macro = Configuration:CreateSection({
				Name = "Macro"
			})

		end

		-- Settings: Section
		do
			Interfaces.Settings = {
				Label = {};
				Paragraph = {};
				Button = {};
				Toggle = {};
				Dropdown = {};
				Slider = {};
				Input = {};
			}
			
			local Settings = Configuration:CreateSection({
				Name = "Settings"
			})

			local Data_Cache

			Interfaces.Settings.Button["Save-Configuration"] = Settings:CreateButton({
				Name = "Save-Configuration",
				Body = "Save chosen configuration",
				Function = function(self) -- : Nil
					if Data_Cache then
						if not isfolder("Infinixity") then
							makefolder("Infinixity")
						end
						
						if not isfolder(Dir) then
							makefolder(Dir)
						end

						writefile(Dir .. "/config.json", HttpService:JSONEncode(Data_Cache))
					end
				end
			})

			local Table = {}
			for key, value in pairs(Data) do
				for key2, value2 in pairs(value) do
					Table[#Table + 1] = key2
				end
			end

			Interfaces.Settings.Dropdown["Options"] = Settings:CreateDropdown({
				Name = "Options",
				Body = "Choose configuration to be saved",
				Init = false,
				State = false,
				Text = "",
				Table = Table,
				Selected = {}, -- If defined the dropdown becomes a multi
				Function = function(self, Value, Input) -- : Table -- Input is Dropdown still open or not : Boolean
					Data_Cache = {}

					for key, value in pairs(Data) do
						for key2, value2 in pairs(value) do
							if table.find(Value, key2) then
								Data_Cache[key] = value
							end
						end
					end
				end
			})
			
			Interfaces.Settings.Toggle["Hide-Button"] = Settings:CreateToggle({
				Name = "Hide Button",
				Body = "";
				Init = true,
				State = false,
				Function = function(self, Value)
					--ArrayField.UniButton.ImageTransparency = Value and 1 or not Value and 0
				end
			})
			
			Interfaces.Settings.Toggle["Debug-Mode"] = Settings:CreateToggle({
				Name = "Debug-Mode",
				Body = "";
				Init = true,
				State = Data.Toggle["Debug-Mode"],
				Function = function(self, Value)
					Data.Toggle["Debug-Mode"] = Value
					
				end
			})
			
			Interfaces.Settings.Toggle["Unlock-FPS"] = Settings:CreateToggle({
				Name = "Unlock FPS",
				Body = "";
				Init = true,
				State = Data.Toggle["Unlock-FPS"],
				Function = function(self, Value)
					if setfpscap then
						--print(Value and math.huge or not Value and 60)
						--setfpscap(Value and math.huge or not Value and 60)
					end
				end
			})

			--[[
			Interfaces.Settings.Slider["Walk-Speed"] = Settings:CreateSlider({
				Name = "Walk Speed",
				Body = "";
				Init = true,
				Min = 16;
				Max = 160;
				Increment = 1,
				Value = Function:GetHumanoid(LocalPlayer.Character).WalkSpeed,
				Function = function(self, Value)
					Function:GetHumanoid(LocalPlayer.Character).WalkSpeed = Value
					
				end
			})
			--]]
		end
	end
end
