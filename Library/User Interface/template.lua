local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Hosvile/InfiniX/main/Library/User%20Interface/main.lua", true))("Infinixity")

-- Template
local Core = Library:Init({
	Name = "Infinixity";
	--Parent = LocalPlayer.PlayerGui;
	Theme = {
		Primary = { -- 7
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
			{
				Color = Color3.fromRGB(0, 0, 0);
				Gradient = Color3.fromRGB(0, 0, 0);
			}
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
--]]
-- Template
