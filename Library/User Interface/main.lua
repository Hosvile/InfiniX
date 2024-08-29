
local cloneref = cloneref or function(...)
	return ...
end

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

local Duration = 0.2
local Tween_Info = TweenInfo.new(Duration, 1, 0, 0)

--Main
-- Utility
local Utility = {}
Utility.__index = Utility

function Utility.Assert(self, Condition, Message)
	if not Condition then return error(Message) end
end

function Utility.Await(self, Duration, Callback)
	task.spawn(function()
		task.wait(Duration)
		Callback()
	end)
end

function Utility.ReverseTable(self, Table)
	for i = 1, math.floor(#Table/2) do
		local j = #Table - i + 1
		Table[i], Table[j] = Table[j], Table[i]
	end

	return Table
end

function Utility.Create(self, Data)
	local Instances = {}

	for _, v in pairs(Data) do Instances[v[1]] = Instance.new(v[2]) end

	for _, v in pairs(Data) do
		local Instance, Parent
		for Property, Value in pairs(v[3]) do
			if Property ~= "Parent" then
				if type(Value) == "table" then
					print(Property)
					Instances[v[1]][Property] = Instances[Value[1]]
				else
					Instances[v[1]][Property] = Value
				end
			else
				Instance = Instances[v[1]]
				Parent = typeof(Value) == "table" and Instances[Value[1]] or Value
			end
		end
		if Instance and Parent then
			Instance.Parent = Parent
		end
	end

	return Instances[1]
end -- Utility:Create({Parent: number/table, Class: string, Properties: table})

function Utility.InputBegan(self, Input)
	if (Input.UserInputState == Enum.UserInputState.Begin) then
		return true
	end

	return false
end

function Utility.Input(self, Input, Move)
	if Input and (Input.UserInputType == Enum.UserInputType.Touch or Input.UserInputType == Enum.UserInputType.MouseButton1 or (Move and Input.UserInputType == Enum.UserInputType.MouseMovement)) then
		return true
	end

	return false
end

function Utility.Hover(self, Object, Size)
	local Hover = {}

	Object.InputBegan:Connect(function(Input, Processed)
		for key, value in pairs(Hover) do
			value:Destroy()
			rawset(Hover, key, nil)
		end

		if Utility:Input(Input) then
			if #Hover < 1 then
				Hover.Frame = Utility:Create({
					{1, "Frame", {Name = "Highlight", Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(1, 0, 1, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.8, Parent = Object}};
				})

				if Object:FindFirstChildWhichIsA("UIGradient") then
					Object:FindFirstChildWhichIsA("UIGradient"):Clone().Parent = Hover.Frame
				end

				if Object:FindFirstChildWhichIsA("UICorner") then
					Object:FindFirstChildWhichIsA("UICorner"):Clone().Parent = Hover.Frame
				end

				--[[
				Hover.UIScale = Utility:Create({
					{1, "UIScale", {Scale = 1.1, Parent = Object}};
				})
				]]

				Hover.UIStroke = Utility:Create({
					{1, "UIStroke", {Color = Color3.fromRGB(255, 255, 255), Thickness = 1, Transparency = 0.5, Parent = Object}};
				})

				Object.Size = UDim2.new(Size.X * 1.1, 0, Size.Y * 1.1, 0)
			end
		else
			if #Hover < 1 then
				Hover.Frame = Utility:Create({
					{1, "Frame", {Name = "Darklight", Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(1, 0, 1, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 0.8, Parent = Object}};
				})

				if Object:FindFirstChildWhichIsA("UIGradient") then
					Object:FindFirstChildWhichIsA("UIGradient"):Clone().Parent = Hover.Frame
				end

				if Object:FindFirstChildWhichIsA("UICorner") then
					Object:FindFirstChildWhichIsA("UICorner"):Clone().Parent = Hover.Frame
				end

				--[[
				Hover.UIScale = Utility:Create({
					{1, "UIScale", {Scale = 1.1, Parent = Object}};
				})
				]]

				Hover.UIStroke = Utility:Create({
					{1, "UIStroke", {Color = Color3.fromRGB(0, 0, 0), Thickness = 1, Transparency = 0.5, Parent = Object}};
				})

				Object.Size = UDim2.new(Size.X * 1.1, 0, Size.Y * 1.1, 0)
			end
		end
	end)

	Object.InputEnded:Connect(function(Input, Processed)
		for key, value in pairs(Hover) do
			value:Destroy()
			rawset(Hover, key, nil)
		end

		Object.Size = UDim2.new(Size.X, 0, Size.Y, 0)
	end)
end

function Utility.Dragify(self, Receiver, Object, Outline, Singular)
	local Start, ObjectPosition, Dragging, CurrentPosition

	UserInputService.InputBegan:Connect(function(Input)
		if Utility:Input(Input) then
			Conducting = Conducting + 1
			TouchingPoints[Conducting] = Input
		end
		if Utility:Input(Input) and not HasDragged and Outline and Outline.Visible == true then
			Outline.Visible = false; HasDragged = true
		end
	end)

	local DragInput
	Receiver.InputBegan:Connect(function(Input)
		if Utility:Input(Input) then
			Dragging = true
			DragInput = Input
			Start = Input.Position
			if Outline then
				Outline.Visible = true
			end
			ObjectPosition = Object.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(Input)
		if Utility:Input(Input) and Dragging then
			if Singular then
				Input = DragInput
			end
			CurrentPosition = UDim2.new(ObjectPosition.X.Scale, ObjectPosition.X.Offset + (Input.Position - Start).X, ObjectPosition.Y.Scale, ObjectPosition.Y.Offset + (Input.Position - Start).Y)
			if Outline then
				Outline.Position = CurrentPosition
			end
		end
	end)

	UserInputService.InputEnded:Connect(function(Input)
		if Utility:Input(Input) and Dragging then
			Dragging = false
			DragInput = nil
			if Outline then
				Outline.Visible = false
			end
			Object.Position = CurrentPosition
		end
	end)

	local Signal; Signal = UserInputService.InputEnded:Connect(function(Input)
		if Utility:Input(Input) then
			TouchingPoints[Conducting] = nil
			Conducting = Conducting - 1
		end
	end)
end -- Utility:Dragify(Receiver: Instance, Object: Instance, Outline: Instance, Singular: Boolean)

function Utility.InputObject(self, Object)
	if Mouse.X >= Object.AbsolutePosition.X and Mouse.X <= Object.AbsolutePosition.X + Object.AbsoluteSize.X
		and Mouse.Y >= Object.AbsolutePosition.Y and Mouse.Y <= Object.AbsolutePosition.Y + Object.AbsoluteSize.Y then
		return true
	end

	return false
end

function Utility.OnClick(self, Object, Callback)
	local Began, Received = false, false
	Object.InputBegan:Connect(function(Input, Processed)
		if Utility:Input(Input) then
			if not Began then
				Received = true
			end
		end
	end)

	UserInputService.InputBegan:Connect(function(Input, Processed)
		if Utility:Input(Input) then
			Began = true
		end
	end)

	UserInputService.InputEnded:Connect(function(Input, Processed)
		if Utility:Input(Input) then
			Began = false

			if Utility:InputObject(Object) and Received then
				Callback()
			end

			Received = false
		end
	end)
end -- Utility:OnClick(Object: Instance, Callback: function
-- Utility

-- Library
local Library = {}
Library.__index = Library

Library.Theme = {
	Primary = { -- 7
		{
			Color = Color3.fromRGB(173, 254, 151);
			Gradient = Color3.fromRGB(173, 254, 151);
		};
		{
			Color = Color3.fromRGB(131, 193, 115);
			Gradient = Color3.fromRGB(131, 193, 115);
		};
		{
			Color = Color3.fromRGB(86, 181, 141);
			Gradient = Color3.fromRGB(86, 181, 141);
		};
		{
			Color = Color3.fromRGB(117, 254, 162);
			Gradient = Color3.fromRGB(117, 254, 162);
		};
		{
			Color = Color3.fromRGB(0, 254, 151);
			Gradient = Color3.fromRGB(0, 254, 151);
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
			Color = Color3.fromRGB(60, 88, 52);
			Gradient = Color3.fromRGB(132, 193, 115);
		};
		{
			Color = Color3.fromRGB(51, 72, 59);
			Gradient = Color3.fromRGB(57, 78, 68);
		};
		{
			Color = Color3.fromRGB(50, 56, 50);
			Gradient = Color3.fromRGB(50, 56, 50);
		};
		{
			Color = Color3.fromRGB(44, 44, 44);
			Gradient = Color3.fromRGB(97, 97, 97);
		};
		{
			Color = Color3.fromRGB(39, 42, 39);
			Gradient = Color3.fromRGB(45, 48, 45);
		};
		{
			Color = Color3.fromRGB(38, 38, 38);
			Gradient = Color3.fromRGB(47, 47, 47);
		};
	};
}

function Library.Init(self, Data)
	Utility:Assert(typeof(Data) == "table", "Expecting table")

	Library.Theme = Data.Theme or Library.Theme

	local Core = {}
	Core.__index = Core

	Core.Table = setmetatable({
		Data = Data;
		Parent = self;
		Windows = {};
		Destroy = function(self)
			for _, obj in pairs(self.Windows) do
				if obj.Destroy then
					obj:Destroy()
				end
			end

			for _, obj in pairs(self.Objects) do
				if obj.Destroy then
					obj:Destroy()
				end
			end
		end;
	}, Core)

	Data.self = Core.Table

	Core.Objects = {}

	Core.Objects.Folder = Utility:Create({
		{1, "Folder", {Name = Data.Name, Parent = Data.Parent or CoreGui}};
	})

	Core.Objects.Main = Utility:Create({
		{1, "ScreenGui", {Name = "Main", DisplayOrder = 2147483645, ZIndexBehavior = 1, Parent = Core.Objects.Folder}};
	})

	Core.Objects.Windows = Utility:Create({
		{1, "Folder", {Name = "Windows", Parent = Core.Objects.Main}};
	})

	Core.Objects.Appliciations = Utility:Create({
		{1, "Folder", {Name = "Applications", Parent = Core.Objects.Main}};
	})

	Core.Objects.Prompt = Utility:Create({
		{1, "ScreenGui", {Name = "Prompt", DisplayOrder = 2147483646, ZIndexBehavior = 1, ScreenInsets = Enum.ScreenInsets.None, Parent = Core.Objects.Folder}};
	})

	Core.Objects.Prompts = Utility:Create({
		{1, "Folder", {Name = "Prompts", Parent = Core.Objects.Prompt}};
	})

	Core.Objects.Notification = Utility:Create({
		{1, "ScreenGui", {Name = "Notification", DisplayOrder = 2147483647, ZIndexBehavior = 1, ScreenInsets = Enum.ScreenInsets.None, Parent = Core.Objects.Folder}};
	})

	Core.Objects.Notifications = Utility:Create({
		{1, "ScrollingFrame", {Name = "Box", Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(175/1143.503, 0, 441/513.318, 0), AnchorPoint = Vector2.new(0, 0), Position = UDim2.new(939/1143.503, 0, 50/513.318, 0), BackgroundColor3 = Library.Theme.Primary[6].Color, BackgroundTransparency = 1, CanvasSize = UDim2.new(0, 0, 0, 0), VerticalScrollBarInset = 0, HorizontalScrollBarInset = 0, ScrollingDirection = 2, ScrollBarThickness = 1, ScrollingEnabled = false, ElasticBehavior = 0, Parent = Core.Objects.Notification}};
		{2, "UIListLayout", {Padding = UDim.new(0, 6), VerticalAlignment = Enum.VerticalAlignment.Bottom, FillDirection = Enum.FillDirection.Vertical, SortOrder = 2, Parent = {1}}};
		{3, "UIPadding", {PaddingBottom = UDim.new(0, 1), PaddingLeft = UDim.new(0, 1), PaddingRight = UDim.new(0, 1), PaddingTop = UDim.new(0, 1), Parent = {1}}};
		--{3, "UIPadding", {PaddingLeft = UDim.new(0, 0), Parent = {1}}};
	})

	Core.Objects.Notifications.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		Core.Objects.Notifications.CanvasSize = UDim2.new(0, 0, 0, Core.Objects.Notifications.UIListLayout.AbsoluteContentSize.Y + 1)
	end)

	-- Create
	Library.Create = {}
	Library.Create.__index = Library.Create

	function Library.Create.Pager(self, Parent, Data, Size)
		local Option_Interface = {}
		Option_Interface.__index = Option_Interface

		Option_Interface.Table = setmetatable({
			Data = Data;
			Parent = self;
			Destroy = function(self)
				for _, obj in pairs(self.Objects) do
					if obj.Destroy then
						obj:Destroy()
					end
				end
			end;
		}, Option_Interface)

		Data.self = Option_Interface.Table

		Option_Interface.Objects = {}

		local SizeX = (Size.X / Size.XX)
		local SizeY = (Size.Y / Size.XX)

		Option_Interface.Objects.Pager = Utility:Create({
			{1, "TextButton", {Name = "Pager_" .. Data.Name, AutoButtonColor = false, Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXX, Size = UDim2.new(SizeX, 0, SizeY, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 0, 0, 0), BackgroundColor3 = Library.Theme.Primary[3].Color, BackgroundTransparency = 0, Text = "", Parent = Parent}};
			{2, "ImageButton", {Name = "Box", AutoButtonColor = false, Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeYY, Size = UDim2.new(1, 0, 1, 0), AnchorPoint = Vector2.new(0, 0), Position = UDim2.new(0, 0, 0, 0), BackgroundColor3 = Library.Theme.Primary[6].Color, BackgroundTransparency = 0, Image = Data.Asset or "", Parent = {1}}};
			{3, "Frame", {Name = "Icon", Active = false, Rotation = 0, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(15/25, 0, 15/25, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundColor3 = Library.Theme.Primary[6].Color, BackgroundTransparency = 0, Parent = {2}}};
			{4, "ImageLabel", {Name = "Glow", Visible = false, Active = false, Rotation = -45, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(3, 0, 3, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundColor3 = Library.Theme.Primary[7].Color, BackgroundTransparency = 1, Image = "rbxassetid://15578039991", ImageTransparency = 0.75, Parent = {3}}};
		})

		Utility:Create({
			{1, "UIGradient", {Name = "Pager_Gradient", Rotation = -45, Offset = Vector2.new(SizeY*1.5, 0), Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1 - SizeY - 0.001, 0), NumberSequenceKeypoint.new(1 - SizeY, 1), NumberSequenceKeypoint.new(1, 1)}), Parent = Option_Interface.Objects.Pager}};
			{2, "UIGradient", {Name = "Box_Gradient", Rotation = math.deg(math.atan2((Option_Interface.Objects.Pager.Box.AbsolutePosition - (Option_Interface.Objects.Pager.Box.AbsolutePosition + Option_Interface.Objects.Pager.Box.AbsoluteSize/2)).Y, (Option_Interface.Objects.Pager.Box.AbsolutePosition - (Option_Interface.Objects.Pager.Box.AbsolutePosition + Option_Interface.Objects.Pager.Box.AbsoluteSize/2)).X)) + 90, Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Library.Theme.Secondary[4].Gradient), ColorSequenceKeypoint.new(0.5, Library.Theme.Secondary[4].Gradient), ColorSequenceKeypoint.new(0.5001, Library.Theme.Secondary[4].Color), ColorSequenceKeypoint.new(1, Library.Theme.Secondary[4].Color)}), Parent = Option_Interface.Objects.Pager.Box}};
		})

		Utility:Create({
			{1, "Frame", {Name = "TitleContainer", Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(68/92, 0, 17/20, 0), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), BackgroundColor3 = Library.Theme.Secondary[3].Color, BackgroundTransparency = 1, Parent = Option_Interface.Objects.Pager}};
			{2, "TextLabel", {Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(1, 0, 1, 0), AnchorPoint = Vector2.new(0, 0), Position = UDim2.new(0, 0, 0, 0), BackgroundColor3 = Library.Theme.Primary[7].Color, BackgroundTransparency = 1, Font = 36, TextScaled = true, TextWrapped = true, TextXAlignment = 0, Text = tostring(Data.Name), TextSize = 18, TextColor3 = Library.Theme.Primary[6].Color, Parent = {1}}};
		})

		Option_Interface.Objects.TextLabel = Option_Interface.Objects.Pager.TitleContainer.TextLabel

		Option_Interface.Selected = false
		function Option_Interface.select(self)
			TweenService:Create(Option_Interface.Objects.Pager, Tween_Info, {BackgroundColor3 = Library.Theme.Primary[4].Color}):Play(); Option_Interface.Objects.Pager.Box.Icon.Glow.Visible = true; TweenService:Create(Option_Interface.Objects.Pager.Box.Icon.Glow, Tween_Info, {Rotation = -45}):Play(); TweenService:Create(Option_Interface.Objects.Pager.Box.Icon, Tween_Info, {Rotation = -45}):Play(); Option_Interface.Objects.Pager.Box.Box_Gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Library.Theme.Secondary[1].Gradient), ColorSequenceKeypoint.new(0.5, Library.Theme.Secondary[1].Gradient), ColorSequenceKeypoint.new(0.5001, Library.Theme.Secondary[1].Color), ColorSequenceKeypoint.new(1, Library.Theme.Secondary[1].Color)}); Option_Interface.Objects.Pager.Pager_Gradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 0)})

			Option_Interface.Selected = true
		end

		function Option_Interface.unselect(self)
			TweenService:Create(Option_Interface.Objects.Pager, Tween_Info, {BackgroundColor3 = Library.Theme.Primary[3].Color}):Play(); TweenService:Create(Option_Interface.Objects.Pager.Box.Icon.Glow, Tween_Info, {Rotation = 0}):Play(); Option_Interface.Objects.Pager.Box.Icon.Glow.Visible = false; TweenService:Create(Option_Interface.Objects.Pager.Box.Icon, Tween_Info, {Rotation = 0}):Play(); Option_Interface.Objects.Pager.Box.Box_Gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Library.Theme.Secondary[4].Gradient), ColorSequenceKeypoint.new(0.5, Library.Theme.Secondary[4].Gradient), ColorSequenceKeypoint.new(0.5001, Library.Theme.Secondary[4].Color), ColorSequenceKeypoint.new(1, Library.Theme.Secondary[4].Color)}); Option_Interface.Objects.Pager.Pager_Gradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1 - SizeY - 0.001, 0), NumberSequenceKeypoint.new(1 - SizeY, 1), NumberSequenceKeypoint.new(1, 1)})

			Option_Interface.Selected = false
		end

		return Option_Interface.Table
	end -- Create:Pager(Parent: Instance, Data: Table, Size: Table)

	local IsPrompted = false
	function Library.Create.Prompt(self, Data)
		local Option_Interface = {}
		Option_Interface.__index = Option_Interface

		Option_Interface.Table = setmetatable({
			Data = Data;
			Parent = self;
			Get = function(self)
				return IsPrompted
			end;
			Set = function(self, Value)
				IsPrompted = Value
			end;
			Destroy = function(self)
				for _, obj in pairs(self.Objects) do
					if obj.Destroy then
						obj:Destroy()
					end
				end
			end;
		}, Option_Interface)

		Data.self = Option_Interface.Table

		Option_Interface.Objects = {}

		Option_Interface.Objects.Prompt = Utility:Create({
			{1, "Folder", {Name = "Prompt_" .. Data.Name, Parent = Core.Objects.Prompts}};
		})

		return Option_Interface.Table
	end
	-- Create

	function Core.Notify(self, Data)
		local Notification = {}
		Notification.__index = Notification

		Notification.Table = setmetatable({
			Data = Data;
			Parent = self;
			Destroy = function(self)
				for _, obj in pairs(self.Objects) do
					obj:Destroy()
				end
			end;
		}, Notification)

		Data.self = Notification.Table

		Notification.Objects = {}

		Notification.Objects.Frame = Utility:Create({
			{1, "Frame", {Name = "Notification_" .. Data.Name, LayoutOrder = #Core.Objects.Notifications:GetChildren(), Active = false, ClipsDescendants = false, SizeConstraint = Enum.SizeConstraint.RelativeXX, Size = UDim2.new(175/175, 0, 110/175, 0), AnchorPoint = Vector2.new(0, 0), Position = UDim2.new(939/1143.503, 0, 391/513.318, 0), BorderSizePixel = 1, BorderColor3 = Color3.fromRGB(126, 126, 126), BackgroundColor3 = Library.Theme.Secondary[2].Color, BackgroundTransparency = 0.125, Parent = Core.Objects.Notifications}};
			{2, "UIScale", {Scale = Data.Scale or 1, Parent = {1}}};
		})

		Notification.Objects.TextLabel = Utility:Create({
			{1, "Frame", {Name = "TitleContainer", Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(145/175, 0, 17/110, 0), AnchorPoint = Vector2.new(0, 0), Position = UDim2.new(5/175, 0, 5/110, 0), BackgroundColor3 = Library.Theme.Secondary[3].Color, BackgroundTransparency = 1, Parent = Notification.Objects.Frame}};
			{2, "TextLabel", {Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(1, 0, 1, 0), AnchorPoint = Vector2.new(0, 0), Position = UDim2.new(0, 0, 0, 0), BackgroundColor3 = Library.Theme.Primary[7].Color, BackgroundTransparency = 1, Font = Enum.Font.TitilliumWeb, TextScaled = true, TextWrapped = true, TextXAlignment = 0, Text = " " .. Data.Title, TextSize = 18, TextColor3 = Library.Theme.Primary[6].Color, Parent = {1}}};
			{3, "Frame", {Name = "BodyContainer", Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(160/175, 0, 50/110, 0), AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 22/110, 0), BackgroundColor3 = Library.Theme.Secondary[3].Color, BackgroundTransparency = 1, Parent = Notification.Objects.Frame}};
			{4, "TextLabel", {Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(1, 0, 1, 0), AnchorPoint = Vector2.new(0, 0), Position = UDim2.new(0, 0, 0, 0), BackgroundColor3 = Library.Theme.Primary[7].Color, BackgroundTransparency = 1, Font = Enum.Font.TitilliumWeb, TextScaled = false, TextWrapped = true, TextXAlignment = 0, TextYAlignment = 0, Text = "\t" .. Data.Body, TextSize = 15, TextColor3 = Library.Theme.Primary[1].Color, Parent = {3}}};
		})

		if Data.Buttons then
			local Buttons = Utility:ReverseTable(Data.Buttons)
			for Index, Button in ipairs(Buttons) do
				local Interface = {}
				Interface.__index = Interface

				Interface.Table = setmetatable({
					Data = Button;
					Parent = self;
					Call = function(self)
						Button.Function(Button)
					end;
					Destroy = function(self)
						for _, obj in pairs(self.Objects) do
							if obj.Destroy then
								obj:Destroy()
							end
						end
					end;
				}, Notification)

				Button.self = Interface.Table

				Interface.Objects = {}

				Interface.Objects.Receiver = Utility:Create({
					{1, "ImageButton", {Name = "Input_" .. Button.Name, AutoButtonColor = false, Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(50/175, 0, 20/110, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new((175/175) - (((50 + 10)/175)/2) - ((50 + 5)/175) * (Index - 1), 0, (95)/110, 0), BackgroundColor3 = Library.Theme.Primary[3].Color, BackgroundTransparency = 0, Parent = Notification.Objects.Frame}};
					{2, "UICorner", {CornerRadius = UDim.new(0.15, 0), Parent = {1}}};
				})

				Interface.Objects.TextLabel = Utility:Create({
					{1, "Frame", {Name = "TitleContainer", Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(50/50, 0, 10/20, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundColor3 = Library.Theme.Secondary[3].Color, BackgroundTransparency = 1, Parent = Interface.Objects.Receiver}};
					{2, "TextLabel", {Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(1, 0, 1, 0), AnchorPoint = Vector2.new(0, 0), Position = UDim2.new(0, 0, 0, 0), BackgroundColor3 = Library.Theme.Primary[7].Color, BackgroundTransparency = 1, Font = Enum.Font.TitilliumWeb, TextScaled = true, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Center, Text = Button.Name or "", TextSize = 18, TextColor3 = Library.Theme.Primary[6].Color, Parent = {1}}};
				})

				Utility:Hover(Interface.Objects.Receiver, {X = 50/175, Y = 20/110})

				Utility:OnClick(Interface.Objects.Receiver, function()
					Button.Function(Button)
				end)
			end
		end

		Core.Objects.Notifications.CanvasPosition = Vector2.new(0, math.huge)

		game:GetService("Debris"):AddItem(Notification.Objects.Frame, Data.Duration or 60)

		return Notification.Table
	end

	function Core.Validate(self, Data)
		local Validate = {}
		Validate.__index = Validate

		Validate.Table = setmetatable({
			Data = Data;
			Parent = self;
			Get = function(self)
				return Data
			end;
			Set = function(self, Index, Value)
				if Index == "Text" then
					Data.Text = Value
					Validate.Objects.Receiver.TitleContainer.TextLabel.Text = Value
				else
					Data[Index] = Value
				end
			end;
			Call = function(self)
				Data.Function(Data, Data.Text, false)
			end;
			Destroy = function(self)
				for _, obj in pairs(self.Objects) do
					if obj.Destroy then
						obj:Destroy()
					end
				end
			end;
		}, Core)

		Data.self = Validate.Table

		Validate.Objects = {}

		Validate.Objects.Folder = Utility:Create({
			{1, "Folder", {Name = "Validate", Parent = Core.Objects.Appliciations}};
		})

		Validate.Objects.Canvas = Utility:Create({
			{1, "Frame", {Name = "Validate_" .. Data.Name, Active = true, ClipsDescendants = true, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(300/1143.503, 0, 200/513.318, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundColor3 = Library.Theme.Secondary[2].Color, BackgroundTransparency = 1, Parent = Validate.Objects.Folder}};
			{2, "UIScale", {Scale = Data.Scale or 1, Parent = {1}}};
		})

		Validate.Objects.Main = Utility:Create({
			{1, "Frame", {Name = "Main", Active = true, ClipsDescendants = true, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(300/300, 0, 164/200, 0), AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 0), BackgroundColor3 = Library.Theme.Secondary[4].Color, BackgroundTransparency = 0.125, Parent = Validate.Objects.Canvas}};
		})

		Utility:Create({
			{1, "UIGradient", {Rotation = -45, Offset = Vector2.new(0.25, 0), Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1 - 164/200 - 0.001, 0), NumberSequenceKeypoint.new(1 - 164/200, 1), NumberSequenceKeypoint.new(1, 1)}), Parent = Validate.Objects.Main}};
		})

		Utility:Create({
			{1, "Frame", {Name = "TitleContainer", Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(80/300, 0, 40/164, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.25, 0), BackgroundColor3 = Library.Theme.Secondary[3].Color, BackgroundTransparency = 1, Parent = Validate.Objects.Main}};
			{2, "TextLabel", {Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(1, 0, 0.75, 0), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0), BackgroundColor3 = Library.Theme.Primary[7].Color, BackgroundTransparency = 1, Font = 36, TextScaled = true, TextWrapped = true, TextXAlignment = 2, Text = Data.Name, TextSize = 18, TextStrokeTransparency = 0.8, TextColor3 = Library.Theme.Primary[6].Color, Font = Enum.Font.Sarpanch, Parent = {1}}};
		})

		Validate.Objects.Logo = Utility:Create({
			{1, "ImageButton", {Name = "Logo", AutoButtonColor = false, Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXX, Size = UDim2.new(20/300, 0, 20/300, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(280/300, 0, 16/200, 0), BackgroundColor3 = Library.Theme.Primary[6].Color, BackgroundTransparency = 1, Image = "rbxassetid://15573193338", Parent = Validate.Objects.Main}};
		})

		Utility:Hover(Validate.Objects.Logo, {X = 20/300, Y = 20/300})

		Validate.Objects.Logo.MouseButton1Click:Connect(function()
			for _, obj in pairs(Validate.Objects) do
				if obj.Destroy then
					obj:Destroy()
				end
			end
		end)

		Validate.Objects.Receiver = Utility:Create({
			{1, "ImageButton", {Name = "Input_" .. Data.Name, AutoButtonColor = false, Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(200/300, 0, 45/200, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundColor3 = Library.Theme.Secondary[5].Color, BackgroundTransparency = 0, Parent = Validate.Objects.Main}};
			--{2, "UICorner", {CornerRadius = UDim.new(0.2, 0), Parent = {1}}};
		})

		Utility:Create({
			{1, "UIGradient", {Rotation = -45, Offset = Vector2.new(0.25, 0), Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1 - 45/200 - 0.001, 0), NumberSequenceKeypoint.new(1 - 45/200, 1), NumberSequenceKeypoint.new(1, 1)}), Parent = Validate.Objects.Receiver}};
		})

		Validate.Objects.Input = Utility:Create({
			{1, "Frame", {Name = "TitleContainer", Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(67/96, 0, 17/20, 0), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(8/96, 0, 0.5, 0), BackgroundColor3 = Library.Theme.Secondary[3].Color, BackgroundTransparency = 1, Parent = Validate.Objects.Receiver}};
			{2, "Frame", {Name = "TextCursor", Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeYY, Size = UDim2.new(3/17, 0, 12/17, 0), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(-6/86, 0, 0.5, 0), BackgroundColor3 = Library.Theme.Primary[2].Color, BackgroundTransparency = 0, Parent = {1}}};
			{3, "TextLabel", {Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(1, 0, 0.75, 0), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0), BackgroundColor3 = Library.Theme.Primary[7].Color, BackgroundTransparency = 1, Font = 36, TextScaled = true, TextWrapped = true, TextXAlignment = 0, Text = Data.Text or "", TextSize = 18, TextColor3 = Library.Theme.Primary[6].Color, Parent = {1}}};
		})
		
		Validate.Objects.Placeholder = Utility:Create({
			{1, "TextLabel", {Name = "Placeholder", Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(1, 0, 0.75, 0), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0), BackgroundColor3 = Library.Theme.Primary[7].Color, BackgroundTransparency = 1, Font = 36, TextScaled = true, TextWrapped = true, TextXAlignment = 0, Text = Data.Placeholder or "", TextSize = 18, TextColor3 = Library.Theme.Primary[6].Color, TextTransparency = 0.5, Parent = Validate.Objects.Input}};
		})
		
		if Data.Text and Data.Text ~= "" then
			Validate.Objects.Placeholder.Visible = false
		else
			Validate.Objects.Placeholder.Visible = true
		end

		Validate.Objects.Login = (Library.Create:Pager(Validate.Objects.Main, Data, {XX = 300, X = 150, Y = 25})).Objects.Pager

		Validate.Objects.Login.TitleContainer.TextLabel.Text = ""

		Validate.Objects.Login.AnchorPoint = Vector2.new(0.5, 0.5)
		Validate.Objects.Login.Position = UDim2.new(0.55, 0, 0.75, 0)

		Utility:Hover(Validate.Objects.Login, {X = 150/300, Y = 25/300})

		Utility:OnClick(Validate.Objects.Login, function()
			Data.Function(Data, Data.Text, true)
		end)

		Validate.Objects.Bar = Utility:Create({
			{1, "Frame", {Name = "Bar", Active = true, ClipsDescendants = true, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(300/300, 0, 35/200, 0), AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 165/200, 0), BackgroundColor3 = Library.Theme.Secondary[5].Color, BackgroundTransparency = 0.125, Parent = Validate.Objects.Canvas}};
			{3, "UIPadding", {PaddingLeft = UDim.new(5/300, 0), Parent = {1}}};
		})

		Utility:Create({
			{1, "UIGradient", {Rotation = -45, Offset = Vector2.new(0.25, 0), Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1 - 35/200 - 0.001, 0), NumberSequenceKeypoint.new(1 - 35/200, 1), NumberSequenceKeypoint.new(1, 1)}), Parent = Validate.Objects.Bar}};
		})

		Validate.Objects.Buttons = Utility:Create({
			{1, "Folder", {Name = "Buttons", Parent = Validate.Objects.Bar}};
			{2, "UIListLayout", {Padding = UDim.new(5/300, 0), VerticalAlignment = Enum.VerticalAlignment.Center, FillDirection = Enum.FillDirection.Horizontal, SortOrder = 2, Parent = {1}}};
		})
		
		Validate.Objects.Description = Utility:Create({
			{1, "Frame", {Name = "Container", Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeYY, Size = UDim2.new(35/35, 0, 27.5/35, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 0, 0, 0), BackgroundColor3 = Library.Theme.Secondary[5].Color, BackgroundTransparency = 1, ZIndex = 2, Parent = Validate.Objects.Buttons}};
			--{2, "UIStroke", {Color = Library.Theme.Primary[3].Color, Thickness = 1, Transparency = 0.5, Parent = {1}}};
			{3, "TextLabel", {Active = false, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Font = Enum.Font.TitilliumWeb, Text = "Get Key:", TextColor3 = Library.Theme.Primary[6].Color, TextScaled = true, Parent = {1}}};
		})

		for _, Button in ipairs(Data.Buttons) do
			local Interface = {}
			Interface.__index = Interface

			Interface.Table = setmetatable({
				Data = Button;
				Parent = self;
				Call = function(self)
					Button.Function(Button)
				end;
				Destroy = function(self)
					for _, obj in pairs(self.Objects) do
						if obj.Destroy then
							obj:Destroy()
						end
					end
				end;
			}, Validate)

			Data.self = Interface.Table

			Interface.Objects = {}

			Interface.Objects.Container = Utility:Create({
				{1, "Frame", {Name = "Container", Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeYY, Size = UDim2.new(27.5/35, 0, 27.5/35, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 0, 0, 0), BackgroundColor3 = Library.Theme.Secondary[5].Color, BackgroundTransparency = 0, ZIndex = 2, Parent = Validate.Objects.Buttons}};
				{2, "UIStroke", {Color = Library.Theme.Primary[3].Color, Thickness = 1, Transparency = 0.5, Parent = {1}}};
			})

			Interface.Objects.Receiver = Utility:Create({
				{1, "ImageButton", {Name = "Input_" .. Data.Name, AutoButtonColor = false, Active = false, BorderSizePixel = 1, SizeConstraint = Enum.SizeConstraint.RelativeYY, Size = UDim2.new(27.5/27.5, 0, 27.5/27.5, 0), AnchorPoint = Vector2.new(0, 0), Position = UDim2.new(0, 0, 0, 0), BackgroundColor3 = Library.Theme.Secondary[5].Color, BackgroundTransparency = 0, Image = Button.Image or "", ZIndex = 2, Parent = Interface.Objects.Container}};
				{2, "UICorner", {CornerRadius = UDim.new(0.25, 0), Parent = {1}}};
				{3, "UIStroke", {Color = Library.Theme.Primary[7].Color, Thickness = 1, Transparency = 0.5, Parent = {1}}};
			})

			if Data.Tutorial then
				task.spawn(function()
					while Interface.Objects.Container do
						Interface.Objects.Container.BackgroundColor3 = Library.Theme.Primary[4].Color
						task.wait(0.5)

						Interface.Objects.Container.BackgroundColor3 = Library.Theme.Secondary[5].Color
						task.wait(0.5)
					end
				end)
			end

			--[[
			Interface.Objects.ButtonsHighlight = Utility:Create({
				{1, "Frame", {Name = "Highlight", Active = true, BorderSizePixel = 2, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0), BorderColor3 = Library.Theme.Primary[5].Color, BackgroundColor3 = Library.Theme.Primary[5].Color, BackgroundTransparency = 0.5, ZIndex = 1, Parent = Interface.Objects.Receiver}};
			})
			]]

			Utility:Hover(Interface.Objects.Container, {X = 27.5/35, Y = 27.5/35})

			Utility:OnClick(Interface.Objects.Receiver, function()
				Button.Function(Button)
			end)
		end
		
		if Data.Tutorial then
			--[[
			Core:Notify({
				Name = "Infinixity";
				Title = "Get Key";
				Body = "To get key click the highlighted flashing buttons.";
				Duration = 25;
				Buttons = {
					{
						Name = "Got it!";
						Function = function(self)
							self.self:Destroy()
						end;
					};
				}
			})

			Core:Notify({
				Name = "Infinixity";
				Title = "Validate Key";
				Body = "To validate key click the textbox with a horizontal bar on it.";
				Duration = 25;
				Buttons = {
					{
						Name = "Got it!";
						Function = function(self)
							self.self:Destroy()
						end;
					};
				}
			})
			--]]
		end

		local function Callback()
			if Data.Function then
				local Prompt = Library.Create:Prompt(Data)

				if not Prompt:Get() then
					Prompt:Set(true)

					Prompt.Objects.Darkness = Utility:Create({
						{1, "Frame", {Name = "Darkness", Active = true, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Library.Theme.Primary[7].Color, BackgroundTransparency = 0.5, Parent = Prompt.Objects.Prompt}};
					})

					Prompt.Objects.Blur = Utility:Create({
						{1, "BlurEffect", {Enabled = true, Size = math.huge, Parent = service.Lighting}};
					})

					Prompt.Objects.Frame = Utility:Create({
						{1, "Frame", {Name = "Frame", Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(609/1253.503, 0, 50/550.318, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 486.85/550.318, 0), BackgroundColor3 = Library.Theme.Primary[6].Color, BackgroundTransparency = 0, ZIndex = 2, Parent = Prompt.Objects.Prompt}};
						{2, "UICorner", {CornerRadius = UDim.new(0.2, 0), Parent = {1}}};
					})

					Utility:Create({
						{1, "UIGradient", {Rotation = -45, Offset = Vector2.new(-0.355, 0), Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.951, 0 or 0.05), NumberSequenceKeypoint.new(0.998, 0 or 1), NumberSequenceKeypoint.new(1, 0)}), Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Library.Theme.Secondary[6].Gradient), ColorSequenceKeypoint.new(0.02, Library.Theme.Secondary[6].Gradient), ColorSequenceKeypoint.new(0.021, Library.Theme.Secondary[6].Color), ColorSequenceKeypoint.new(0.15, Library.Theme.Secondary[6].Color), ColorSequenceKeypoint.new(1, Library.Theme.Secondary[6].Color)}), Parent = Prompt.Objects.Frame}};
					})

					Prompt.Objects.Receiver = Utility:Create({
						{1, "TextBox", {Name = "Input_" .. Data.Name, Active = true, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXX, Size = UDim2.new(609/609, 0, 50/609, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundColor3 = Library.Theme.Secondary[5].Color, BackgroundTransparency = 1, ClearTextOnFocus = false, PlaceholderText = Data.Placeholder or "", TextScaled = false, TextWrapped = true, TextColor3 = Library.Theme.Primary[6].Color, Text = Data.ClearTextOnFocus and "" or Data.Text or "", Parent = Prompt.Objects.Frame}};
						--{2, "UICorner", {CornerRadius = UDim.new(0.2, 0), Parent = {1}}};
					})

					Prompt.Objects.Receiver.FocusLost:Connect(function(Enter)
						if Enter then
							Data.Function(Data, Data.Text, Enter)
						end
					end)

					Prompt.Objects.Receiver:GetPropertyChangedSignal(Data.ContentText and "ContentText" or "Text"):Connect(function()
						local Text = Data.ContentText and Prompt.Objects.Receiver.ContentText or Prompt.Objects.Receiver.Text
						Data.Text = Text
						Validate.Objects.Receiver.TitleContainer.TextLabel.Text = Text
						
						if Data.Text and Data.Text ~= "" then
							Validate.Objects.Placeholder.Visible = false
						else
							Validate.Objects.Placeholder.Visible = true
						end
						
						Data.Function(Data, Text, false)
					end)

					local Began, Received = false, false
					Prompt.Objects.Receiver.InputBegan:Connect(function(Input)
						if Utility:Input(Input) then
							Received = true
							Input.Changed:Connect(function()
								if not Utility:InputBegan(Input) then
									Received = false
								end
							end)
						end
					end)

					UserInputService.InputBegan:Connect(function(Input, Processed)
						if Utility:Input(Input) then
							if not Received and not Utility:InputObject(Prompt.Objects.Receiver) then
								Prompt:Set(false)

								Prompt.Objects.Blur:Destroy()

								Prompt.Objects.Prompt:Destroy()
							end
						end
					end)
				else
					Prompt:Destroy()
				end
			else
				error("Core.Validate > Missing Data.Function")
			end
		end

		if Data.Init then
			Data.Function(Data, Data.Text, true)
		else
			Callback()
		end

		Validate.Objects.Receiver.MouseButton1Click:Connect(Callback)

		return Validate.Table
	end

	function Core.CreateWindow(self, Data) -- Window
		local Window = {}
		Window.__index = Window
		--/Window/
		Window.Table = setmetatable({
			Data = Data;
			Parent = self;
			Selected = {};
			Tabs = {};
			Destroy = function(self)
				for _, obj in pairs(self.Tabs) do
					if obj.Destroy then
						obj:Destroy()
					end
				end

				for _, obj in pairs(self.Objects) do
					if obj.Destroy then
						obj:Destroy()
					end
				end
			end;
		}, Window)

		Data.self = Window.Table

		Window.Objects = {}

		Window.Objects.Folder = Utility:Create({
			{1, "Folder", {Name = "Window", Parent = Core.Objects.Windows}};
		})

		Window.Objects.Control = Utility:Create({
			{1, "Folder", {Name = "Control", Parent = Window.Objects.Folder}};
		})

		Window.Objects.Canvas = Utility:Create({
			{1, "Frame", {Name = "Window_" .. Data.Name, Active = true, ClipsDescendants = true, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(609/1143.503, 0, 437/513.318, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundColor3 = Library.Theme.Primary[7].Color, BackgroundTransparency = 0.975, Parent = Window.Objects.Folder}};
			{2, "UIScale", {Scale = Data.Scale or 1, Parent = {1}}};
			{3, "Frame", {Name = "Container", Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(609/609, 0, 381/437, 0), AnchorPoint = Vector2.new(0, 0), Position = UDim2.new(0, 0, 0, 0), BackgroundColor3 = Library.Theme.Primary[7].Color, BackgroundTransparency = 1, Parent = {1}}};
			{4, "UICorner", {CornerRadius = UDim.new(0.02, 0), Parent = {1}}};
		})

		Window.Objects.Window = Window.Objects.Canvas.Container

		Window.Objects.Tabs = Utility:Create({
			{1, "Folder", {Name = "Tabs", Parent = Window.Objects.Window}};
		})

		Window.Objects.Maximize = Utility:Create({
			{1, "Frame", {Name = "Maximize_" .. Data.Name, Visible = false, Active = true, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(50/1143.503, 0, 50/513.318, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 450/513.318, 0), BackgroundColor3 = Library.Theme.Primary[7].Color, BackgroundTransparency = 0.5, Parent = Window.Objects.Control}};
			{2, "TextButton", {AutoButtonColor = false, Active = true, ZIndex = 2, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(1, 0, 1, 0), AnchorPoint = Vector2.new(0, 0), Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1, BackgroundColor3 = Library.Theme.Primary[7].Color, Text = "", Parent = {1}}};
			{3, "ImageButton", {AutoButtonColor = false, Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeYY, Size = UDim2.new(0.24, 0, 0.24, 0), AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0.24, 0), BackgroundColor3 = Library.Theme.Primary[1].Color, Parent = {1}}};
			--{3, "UICorner", {CornerRadius = UDim.new(0.1, 0), Parent = {1}}};
			--{4, "UIStroke", {Color = Library.Theme.Primary[6].Color, Thickness = 0.5, Transparency = 0, Parent = {2}}};
		})

		Utility:Create({
			{1, "TextLabel", {SizeConstraint = Enum.SizeConstraint.RelativeXY, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0.25, 0), AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 0.84, 0), Text = "Maximize", TextSize = Window.Objects.Maximize.AbsoluteSize.Y/10, TextColor3 = Library.Theme.Primary[1].Color, Parent = Window.Objects.Maximize}};
		})

		Window.Objects.Minimize = Utility:Create({
			{1, "Frame", {Name = "Minimize", Active = true, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(50/609, 0, 50/381, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(578/609, 0, 412/381, 0), BackgroundColor3 = Library.Theme.Primary[7].Color, BackgroundTransparency = 1, Parent = Window.Objects.Window}};
			{2, "TextButton", {AutoButtonColor = false, Active = true, ZIndex = 2, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(1, 0, 1, 0), AnchorPoint = Vector2.new(0, 0), Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1, BackgroundColor3 = Library.Theme.Primary[7].Color, Text = "", Parent = {1}}};
			{3, "ImageButton", {Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(0.24, 0, 0.24, 0), AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0.24, 0), BackgroundColor3 = Library.Theme.Primary[1].Color, Parent = {1}}};
			--{3, "UICorner", {CornerRadius = UDim.new(0.1, 0), Parent = {1}}};
			--{4, "UIStroke", {Color = Library.Theme.Primary[6].Color, Thickness = 0.5, Transparency = 0, Parent = {2}}};
		})

		Utility:Create({
			{1, "TextLabel", {Active = false, SizeConstraint = Enum.SizeConstraint.RelativeXY, BackgroundTransparency = 1, Size = UDim2.new(0.8, 0, 0.225, 0), AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 0.84, 0), Text = "Minimize", TextScaled = true, TextSize = Window.Objects.Minimize.AbsoluteSize.Y/10, TextColor3 = Library.Theme.Primary[1].Color, Parent = Window.Objects.Minimize}};
		})

		Window.Objects.Widget = Utility:Create({
			{1, "Frame", {Name = "WidgetBar", Active = true, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(30/609, 0, 365/381, 0), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(571/609, 0, 0.5, 0), BackgroundColor3 = Library.Theme.Secondary[3].Color, BackgroundTransparency = 0, Parent = Window.Objects.Window}};
			{2, "UICorner", {CornerRadius = UDim.new(0.2, 0), Parent = {1}}};
		})

		Window.Objects.Frame = Utility:Create({
			{1, "Frame", {Name = "Dock", Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(181/609, 0, 381/381, 0), AnchorPoint = Vector2.new(0, 0), Position = UDim2.new(0, 0, 0, 0), BackgroundColor3 = Library.Theme.Primary[6].Color, BackgroundTransparency = 0, Parent = Window.Objects.Window}};
		})

		Utility:Create({
			{1, "UIGradient", {Rotation = math.deg(math.atan2((Window.Objects.Frame.AbsolutePosition - (Window.Objects.Frame.AbsolutePosition + Window.Objects.Frame.AbsoluteSize/2)).Y, (Window.Objects.Frame.AbsolutePosition - (Window.Objects.Frame.AbsolutePosition + Window.Objects.Frame.AbsoluteSize/2)).X)) + 90, Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Library.Theme.Secondary[2].Gradient), ColorSequenceKeypoint.new(0.5, Library.Theme.Secondary[2].Gradient), ColorSequenceKeypoint.new(0.501, Library.Theme.Secondary[2].Color), ColorSequenceKeypoint.new(1, Library.Theme.Secondary[2].Color)}, Parent = Window.Objects.Frame}};
		})

		Window.Objects.Logo = Utility:Create({
			{1, "ImageButton", {Name = "Logo", AutoButtonColor = false, Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXX, Size = UDim2.new(20/181, 0, 20/181, 0), AnchorPoint = Vector2.new(0, 0), Position = UDim2.new(18/181, 0, 6/181, 0), BackgroundColor3 = Library.Theme.Primary[6].Color, BackgroundTransparency = 1, Image = "rbxassetid://15573193338", Parent = Window.Objects.Frame}};
		})

		Window.Objects.Service = Utility:Create({
			{1, "TextLabel", {Active = false, SizeConstraint = Enum.SizeConstraint.RelativeXY, BackgroundTransparency = 1, Size = UDim2.new(0.5, 0, 0.05, 0), Position = UDim2.new(0.5, 0, 0.055, 0), AnchorPoint = Vector2.new(0.5, 0.5), Font = Enum.Font.Sarpanch, Text = Data.Name, TextXAlignment = Enum.TextXAlignment.Left, TextScaled = true, TextSize = Window.Objects.Frame.AbsoluteSize.Y/10, TextColor3 = Library.Theme.Primary[1].Color, Parent = Window.Objects.Frame}};
		})

		Window.Objects.Separator = Utility:Create({
			{1, "Folder", {Name = "Separators", Parent = Window.Objects.Frame}};
			{2, "Frame", {Name = "Separator", Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXX, Size = UDim2.new(0.80110497238, 0, 0.00552486188, 0), AnchorPoint = Vector2.new(0, 0), Position = UDim2.new(0.09944751381, 0, 0.11049723757, 0), BackgroundColor3 = Library.Theme.Primary[6].Color, BackgroundTransparency = 0, Parent = {1}}};
			{3, "Frame", {Name = "Separator", Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeYY, Size = UDim2.new(1/381, 0, 279/381, 0), AnchorPoint = Vector2.new(0, 0), Position = UDim2.new(381/381, 0, 51/381, 0), BackgroundColor3 = Library.Theme.Primary[6].Color, BackgroundTransparency = 0, Parent = {1}}};
		})

		Window.Objects.Box = Utility:Create({
			{1, "ScrollingFrame", {Name = "Box", BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(158/181, 0, 318/381, 0), AnchorPoint = Vector2.new(0, 0), Position = UDim2.new(12/181, 0, 51/381, 0), BackgroundColor3 = Library.Theme.Primary[6].Color, BackgroundTransparency = 0.975, CanvasSize = UDim2.new(0, 0, 0, 0), VerticalScrollBarInset = 0, HorizontalScrollBarInset = 0, ScrollingDirection = 2, ScrollBarThickness = 2, ElasticBehavior = 0, Parent = Window.Objects.Frame}};
			{2, "UIListLayout", {Padding = UDim.new(0, 6), VerticalAlignment = Enum.VerticalAlignment.Top, FillDirection = Enum.FillDirection.Vertical, SortOrder = 2, Parent = {1}}};
			--{3, "UIPadding", {PaddingLeft = UDim.new(0, 0), Parent = {1}}};
		})

		local CanvasPosition = Vector2.new(0, 0)
		Window.Objects.Box.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			Window.Objects.Box.CanvasSize = UDim2.new(0, 0, 0, Window.Objects.Box.UIListLayout.AbsoluteContentSize.Y / Window.Table.Data.Scale)
			Window.Objects.Box.CanvasPosition = CanvasPosition
		end)

		Window.Objects.Box:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
			if Window.Active ~= false then CanvasPosition = Window.Objects.Box.CanvasPosition end
			Window.Objects.Box.CanvasPosition = CanvasPosition
		end)

		-- Receiver
		Utility:Hover(Window.Objects.Maximize, {X = 50/1143.503, Y = 50/513.318})

		Utility:Hover(Window.Objects.Minimize, {X = 50/609, Y = 50/381})

		local Body
		Utility:OnClick(Window.Objects.Maximize.TextButton, function()
			Window.Objects.Canvas.Position = UDim2.new(0.5, 0, 0.5, 0)

			Body = TweenService:Create(Window.Objects.Canvas.UIScale, Tween_Info, {Scale = Data.Scale or 1.000})

			Body.Completed:Connect(function()
				Window.Objects.Canvas.Position = UDim2.new(0.5, 0, 0.5, 0)
				Window.Objects.Maximize.Visible = false

				Window.Active = true
			end); Body:Play()

			TweenService:Create(Window.Objects.Maximize, Tween_Info, {BackgroundTransparency = 0.5}):Play()
			TweenService:Create(Window.Objects.Maximize, Tween_Info, {Position = UDim2.new(0.5, 0, 475/513.318, 0)}):Play()

			Window.Objects.Maximize.Visible = false
		end)

		Utility:OnClick(Window.Objects.Minimize.TextButton, function()
			Window.Active = false

			Body = TweenService:Create(Window.Objects.Canvas.UIScale, Tween_Info, {Scale = 0.01})

			Body.Completed:Connect(function()
				Window.Objects.Maximize.Visible = true
				Window.Objects.Canvas.Position = UDim2.new(0.5, 0, 1.01, 0)
			end); Body:Play()

			Window.Objects.Maximize.Visible = true

			TweenService:Create(Window.Objects.Maximize, Tween_Info, {Position = UDim2.new(0.5, 0, 515/513.318, 0)}):Play()
			TweenService:Create(Window.Objects.Maximize, Tween_Info, {BackgroundTransparency = 1}):Play()
		end)
		-- Receiver


		function Window.CreateTab(self, Data) -- Tab
			Data = Data or {}
			Data.Name = Data.Name or "Tab"
			Data.Body = Data.Body or "Body"
			Data.Default = Data.Default or 1

			local Tab = {}
			Tab.__index = Tab
			--/Window/Tab/

			Tab.Table = setmetatable({
				Data = Data;
				Parent = self;
				Selected = {};
				Sections = {};
				Disabled = {};
				Destroy = function(self)
					for _, obj in pairs(self.Sections) do
						if obj.Destroy then
							obj:Destroy()
						end
					end

					for _, obj in pairs(self.Objects) do
						if obj.Destroy then
							obj:Destroy()
						end
					end
				end;
			}, Tab)

			Data.self = Tab.Table

			Tab.Objects = {}

			Tab.Objects.Folder = Utility:Create({
				{1, "Folder", {Name = "Tab", Parent = Window.Objects.Tabs}};
			})

			Tab.Objects.Pager = Utility:Create({
				{1, "TextButton", {Name = "Pager_" .. Data.Name, AutoButtonColor = false, Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXX, Size = UDim2.new(158/158, 0, 25/158, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 0, 0, 0), BackgroundColor3 = Library.Theme.Primary[3].Color, BackgroundTransparency = 0, Text = "", Parent = Window.Objects.Box}};
				{2, "ImageButton", {Name = "Box", AutoButtonColor = false, Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeYY, Size = UDim2.new(1, 0, 1, 0), AnchorPoint = Vector2.new(0, 0), Position = UDim2.new(0, 0, 0, 0), BackgroundColor3 = Library.Theme.Primary[6].Color, BackgroundTransparency = 0, Image = Data.Asset or "", Parent = {1}}};
				{3, "Frame", {Name = "Icon", Active = false, Rotation = 0, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(15/25, 0, 15/25, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundColor3 = Library.Theme.Primary[6].Color, BackgroundTransparency = 0, Parent = {2}}};
				{4, "ImageLabel", {Name = "Glow", Visible = false, Active = false, Rotation = -45, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(3, 0, 3, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundColor3 = Library.Theme.Primary[7].Color, BackgroundTransparency = 1, Image = "rbxassetid://15578039991", ImageTransparency = 0.75, Parent = {3}}};
			})

			Utility:Create({
				{1, "UIGradient", {Name = "Pager_Gradient", Rotation = -45, Offset = Vector2.new(25/158 * 1.5, 0), Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1 - 25/158 - 0.01, 0), NumberSequenceKeypoint.new(1 - 25/158, 1), NumberSequenceKeypoint.new(1, 1)}), Parent = Tab.Objects.Pager}};
				{2, "UIGradient", {Name = "Box_Gradient", Rotation = math.deg(math.atan2((Tab.Objects.Pager.Box.AbsolutePosition - (Tab.Objects.Pager.Box.AbsolutePosition + Tab.Objects.Pager.Box.AbsoluteSize/2)).Y, (Tab.Objects.Pager.Box.AbsolutePosition - (Tab.Objects.Pager.Box.AbsolutePosition + Tab.Objects.Pager.Box.AbsoluteSize/2)).X)) + 90, Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Library.Theme.Secondary[4].Gradient), ColorSequenceKeypoint.new(0.5, Library.Theme.Secondary[4].Gradient), ColorSequenceKeypoint.new(0.501, Library.Theme.Secondary[4].Color), ColorSequenceKeypoint.new(1, Library.Theme.Secondary[4].Color)}), Parent = Tab.Objects.Pager.Box}};
			})

			Utility:Create({
				{1, "Frame", {Name = "TitleContainer", Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(128/158, 0, 22/25, 0), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), BackgroundColor3 = Library.Theme.Secondary[3].Color, BackgroundTransparency = 1, Parent = Tab.Objects.Pager}};
				{2, "TextLabel", {Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(1, 0, 1, 0), AnchorPoint = Vector2.new(0, 0), Position = UDim2.new(0, 0, 0, 0), BackgroundColor3 = Library.Theme.Primary[7].Color, BackgroundTransparency = 1, Font = 36, TextScaled = true, TextWrapped = true, TextXAlignment = 0, Text = tostring(Data.Name), TextSize = 18, TextColor3 = Library.Theme.Primary[6].Color, Parent = {1}}};
			})

			Utility:Hover(Tab.Objects.Pager, {X = 158/158, Y = 25/158})

			Tab.Objects.Frame = Utility:Create({
				{1, "Frame", {Name = "Tab_" .. Data.Name, Visible = false, Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(44/609, 0, 437/437, 0), AnchorPoint = Vector2.new(0, 0), Position = UDim2.new(564/609, 0, 0, 0), BackgroundColor3 = Library.Theme.Primary[6].Color, BackgroundTransparency = 0, Parent = Tab.Objects.Folder}};
			})

			Tab.Objects.Container = Utility:Create({
				{1, "Frame", {Name = "Container", Visible = false, Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(44/44, 0, 437/437, 0), AnchorPoint = Vector2.new(0, 0), Position = UDim2.new(0, 0, 0, 0), BackgroundColor3 = Library.Theme.Primary[7].Color, BackgroundTransparency = 1, Parent = Tab.Objects.Frame}};
			})

			Utility:Create({
				{1, "UIGradient", {Rotation = math.deg(math.atan2(Tab.Objects.Frame.AbsolutePosition.Y - (Tab.Objects.Frame.AbsolutePosition.Y + Window.Objects.Window.AbsoluteSize.Y*(381/381)/2), Tab.Objects.Frame.AbsolutePosition.X - (Tab.Objects.Frame.AbsolutePosition.X + Window.Objects.Window.AbsoluteSize.X*(429/609)/2))) + 90, Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Library.Theme.Secondary[5].Gradient), ColorSequenceKeypoint.new(0.5, Library.Theme.Secondary[5].Gradient), ColorSequenceKeypoint.new(0.501, Library.Theme.Secondary[5].Color), ColorSequenceKeypoint.new(1, Library.Theme.Secondary[5].Color)}), Parent = Tab.Objects.Frame}};
			})

			Tab.Objects.SearchBar = Utility:Create({
				{1, "Frame", {Name = "SearchBar", Visible = false, Active = true, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(377/429, 0, 30/381, 0), AnchorPoint = Vector2.new(0, 0), Position = UDim2.new(8/429, 0, 8/381, 0), BackgroundColor3 = Library.Theme.Secondary[3].Color, BackgroundTransparency = 0, Parent = Tab.Objects.Frame}};
				{2, "UICorner", {CornerRadius = UDim.new(0.2, 0), Parent = {1}}};
			})

			Tab.Objects.Navigation = Utility:Create({
				{1, "Frame", {Name = "Navigation", Visible = false, Active = true, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(225/609, 0, 50/381, 0), AnchorPoint = Vector2.new(0, 0), Position = UDim2.new(383/609, 0, 387/381, 0), BackgroundColor3 = Library.Theme.Primary[6].Color, BackgroundTransparency = 0, Parent = Tab.Objects.Folder}};
				{2, "Frame", {Name = "Sections", Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(221/225, 0 , 50/50, 0), AnchorPoint = Vector2.new(0, 0), Position = UDim2.new(0, 0, 0, 0), BackgroundColor3 = Library.Theme.Secondary[6].Color, BackgroundTransparency = 1, Parent = {1}}};
				{3, "UIListLayout", {Padding = UDim.new(0, 0), VerticalAlignment = Enum.VerticalAlignment.Center, FillDirection = Enum.FillDirection.Horizontal, SortOrder = 2, Parent = {2}}};
				{4, "UIPadding", {PaddingLeft = UDim.new(0, 9), Parent = {2}}};
				--{5, "UICorner", {CornerRadius = UDim.new(0.2, 0), Parent = {1}}};
			})

			Utility:Create({
				{1, "UIGradient", {Rotation = -45 or math.deg(math.atan2((Tab.Objects.Navigation.AbsolutePosition - Tab.Objects.Navigation.AbsoluteSize).Y, (Tab.Objects.Navigation.AbsolutePosition - Tab.Objects.Navigation.AbsoluteSize).X)) + 90, Offset = Vector2.new(-0.38, 0), Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Library.Theme.Secondary[6].Gradient), ColorSequenceKeypoint.new(0.02, Library.Theme.Secondary[6].Gradient), ColorSequenceKeypoint.new(0.021, Library.Theme.Secondary[6].Color), ColorSequenceKeypoint.new(1, Library.Theme.Secondary[6].Color)}), Parent = Tab.Objects.Navigation}};
			})

			local Children = {Tab.Objects.SearchBar, Tab.Objects.Container}

			local Duration = 0.2
			local Tween_Info = TweenInfo.new(Duration, 1, 0, 0)

			local function unselect()
				local Body

				local Self = false

				for Index, Objects in pairs(self.Selected) do
					if (Objects.Frame == Tab.Objects.Frame and not Objects.self) then Self = true end

					Body = TweenService:Create(Objects.Frame, Tween_Info, {Size = UDim2.new(44/609, 0, 1, 0)})

					local function hide()
						for _, Child in pairs(Children) do
							Child.Visible = false
						end

						if not Self then
							TweenService:Create(Objects.Frame, Tween_Info, {Position = UDim2.new(564/609, 0, 0, 0)}):Play()
							Objects.Frame.Visible = false
							Objects.Navigation.Visible = false
							TweenService:Create(Objects.Navigation, Tween_Info, {Position = UDim2.new(383/609, 0, 387/381, 0)}):Play()
						end
					end

					if Objects.self then
						hide()
					end

					Body.Completed:Connect(function()
						if not Objects.self then
							hide()
						end
					end); Body:Play()

					TweenService:Create(Objects.Navigation, Tween_Info, {Size = UDim2.new(225/609, 0, 50/381, 0)}):Play()

					Objects.Navigation.Sections.Visible = false
					Objects.Children[1].Visible = false
					Objects.Children[2].Visible = false

					TweenService:Create(Objects.Pager, Tween_Info, {BackgroundColor3 = Library.Theme.Primary[3].Color}):Play(); TweenService:Create(Objects.Pager.Box.Icon.Glow, Tween_Info, {Rotation = 0}):Play(); Objects.Pager.Box.Icon.Glow.Visible = false; TweenService:Create(Objects.Pager.Box.Icon, Tween_Info, {Rotation = 0}):Play(); Objects.Pager.Box.Box_Gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Library.Theme.Secondary[4].Gradient), ColorSequenceKeypoint.new(0.5, Library.Theme.Secondary[4].Gradient), ColorSequenceKeypoint.new(0.501, Library.Theme.Secondary[4].Color), ColorSequenceKeypoint.new(1, Library.Theme.Secondary[4].Color)}); Objects.Pager.Pager_Gradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1-25/158-0.01, 0), NumberSequenceKeypoint.new(1-25/158, 1), NumberSequenceKeypoint.new(1, 1)})
					table.remove(self.Selected, Index)
				end

				return Self
			end

			local function max(Cache)
				Tab.Active = true

				Tab.Objects.Frame.Visible = true
				Tab.Objects.Navigation.Visible = true

				local Body

				--Tab.Objects.Frame.Size = UDim2.new(429/609, 0, 1, 0)
				--Tab.Objects.Navigation.Size = UDim2.new(609/609, 0, 50/609, 0)

				Body = TweenService:Create(Window.Objects.Frame, Tween_Info, {Position = UDim2.new(0, 0, 0, 0)})

				Body.Completed:Connect(function()
					TweenService:Create(Tab.Objects.Pager, Tween_Info, {BackgroundColor3 = Library.Theme.Primary[4].Color}):Play(); Tab.Objects.Pager.Box.Icon.Glow.Visible = true; TweenService:Create(Tab.Objects.Pager.Box.Icon.Glow, Tween_Info, {Rotation = -45}):Play(); TweenService:Create(Tab.Objects.Pager.Box.Icon, Tween_Info, {Rotation = -45}):Play(); Tab.Objects.Pager.Box.Box_Gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Library.Theme.Secondary[1].Gradient), ColorSequenceKeypoint.new(0.5, Library.Theme.Secondary[1].Gradient), ColorSequenceKeypoint.new(0.501, Library.Theme.Secondary[1].Color), ColorSequenceKeypoint.new(1, Library.Theme.Secondary[1].Color)}); Tab.Objects.Pager.Pager_Gradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 0)})

					Body = TweenService:Create(Tab.Objects.Frame, Tween_Info, {Size = UDim2.new(429/609, 0, 1, 0)})

					Body.Completed:Connect(function()
						for _, Child in pairs(Children) do
							Child.Visible = true
						end

						Tab.Objects.Frame.Visible = true
						Tab.Objects.Navigation.Visible = true

						Tab.Extended = true
						Tab.Active = true
					end); Body:Play()

					TweenService:Create(Window.Objects.Widget, Tween_Info, {Position = UDim2.new(571/609, 0, 0.5, 0)}):Play()
					TweenService:Create(Tab.Objects.Navigation, Tween_Info, {Size = UDim2.new(609/609, 0, 50/381, 0)}):Play()
					TweenService:Create(Window.Objects.Minimize, Tween_Info, {Position = UDim2.new(578/609, 0, 412/381, 0)}):Play()

					Tab.Objects.Navigation.Sections.Visible = true
				end); Body:Play()

				TweenService:Create(Tab.Objects.Frame, Tween_Info, {Position = UDim2.new(181/609, 0, 0, 0)}):Play()
				TweenService:Create(Window.Objects.Widget, Tween_Info, {Position = UDim2.new(189/609, 0, 0.5, 0)}):Play()
				TweenService:Create(Window.Objects.Minimize, Tween_Info, {Position = UDim2.new(194/609, 0, 412/381, 0)}):Play()
				TweenService:Create(Tab.Objects.Navigation, Tween_Info, {Position = UDim2.new(0, 0, 387/381, 0)}):Play()
			end

			local function min(Cache)
				Tab.Active = false

				Tab.Objects.Frame.Visible = true
				Tab.Objects.Navigation.Visible = true

				local Body = nil

				TweenService:Create(Tab.Objects.Frame, Tween_Info, {Position = UDim2.new(181/609, 0, 0, 0)}):Play()
				TweenService:Create(Tab.Objects.Navigation, Tween_Info, {Position = UDim2.new(0, 0, 387/381, 0)}):Play()
				TweenService:Create(Window.Objects.Minimize, Tween_Info, {Position = UDim2.new(194/609, 0, 412/381, 0)}):Play()

				Body = TweenService:Create(Window.Objects.Widget, Tween_Info, {Position = UDim2.new(189/609, 0, 0.5, 0)})

				Body.Completed:Connect(function()
					for _, Objects in pairs(Cache.Selected) do
						Objects.Frame.Visible = false
						Objects.Navigation.Visible = false
					end

					Tab.Objects.Frame.Visible = true
					Tab.Objects.Navigation.Visible = true

					TweenService:Create(Tab.Objects.Frame, Tween_Info, {Position = UDim2.new(564/609, 0, 0, 0)}):Play()
					TweenService:Create(Window.Objects.Frame, Tween_Info, {Position = UDim2.new(383/609, 0, 0, 0)}):Play()
					TweenService:Create(Window.Objects.Widget, Tween_Info, {Position = UDim2.new(571/609, 0, 0.5, 0)}):Play()
					TweenService:Create(Window.Objects.Minimize, Tween_Info, {Position = UDim2.new(578/609, 0, 412/381, 0)}):Play()
					TweenService:Create(Tab.Objects.Navigation, Tween_Info, {Position = UDim2.new(383/609, 0, 387/381, 0)}):Play()

					Tab.Extended = false
					Tab.Active = false
				end); Body:Play()
			end

			local function select()
				if self.SelectDebounce then return end

				local Cache = self

				local Self = unselect()

				if Self then
					min(self)
				elseif not Self then
					max(self)
				end

				local function SetState(self, bool)
					Tab.Active = bool
				end

				delay(Duration, function() self.SelectDebounce = false end); self.SelectDebounce = true

				table.insert(self.Selected, setmetatable({Navigation = Tab.Objects.Navigation, Pager = Tab.Objects.Pager, Frame = Tab.Objects.Frame, Children = Children, Hide = Hide, SetState = SetState, self = Self}, {}))
			end

			if Data.Default == #self.Tabs+1 then
				select()
			end

			Utility:OnClick(Tab.Objects.Pager, select)

			function Tab.CreateSearch(self, Data)
				local Interface = {}
				Interface.__index = Interface
				--/Window/Tab/Section/Label/

				Interface.Table = setmetatable({
					Data = Data;
					Parent = self;
					Destroy = function(self)
						for _, obj in pairs(self.Objects) do
							if obj.Destroy then
								obj:Destroy()
							end
						end
					end;
				}, Interface)

				Data.self = Interface.Table

				Interface.Objects = {}

				Interface.Objects.Receiver = Utility:Create({
					{1, "ImageButton", {Name = "Input_" .. Data.Name, AutoButtonColor = false, Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(345/377, 0, 25/30, 0), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(357/377, 0, 0.5, 0), BackgroundColor3 = Library.Theme.Secondary[5].Color, BackgroundTransparency = 1, Parent = Tab.Objects.SearchBar}};
					--{2, "UICorner", {CornerRadius = UDim.new(0.2, 0), Parent = {1}}};
				})

				Utility:Create({
					--{1, "UIGradient", {Rotation = -45, Offset = Vector2.new(0.25, 0), Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1 - 45/200 - 0.001, 0), NumberSequenceKeypoint.new(1 - 45/200, 1), NumberSequenceKeypoint.new(1, 1)}), Parent = Interface.Objects.Receiver}};
				})

				Utility:Create({
					{1, "Frame", {Name = "TitleContainer", Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(345/345, 0, 25/25, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundColor3 = Library.Theme.Secondary[3].Color, BackgroundTransparency = 1, Parent = Interface.Objects.Receiver}};
					{2, "Frame", {Name = "TextCursor", Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeYY, Size = UDim2.new(3/25, 0, 20/25, 0), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(-6/377, 0, 0.5, 0), BackgroundColor3 = Library.Theme.Primary[2].Color, BackgroundTransparency = 0, Parent = {1}}};
					{3, "TextLabel", {Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(1, 0, 0.75, 0), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0), BackgroundColor3 = Library.Theme.Primary[7].Color, BackgroundTransparency = 1, Font = 36, TextScaled = true, TextWrapped = true, TextXAlignment = 0, Text = Data.Text or "", TextSize = 18, TextColor3 = Library.Theme.Primary[6].Color, Parent = {1}}};
				})

				local function Callback()
					if Data.Function then
						local Prompt = Library.Create:Prompt(Data)

						if not Prompt:Get() then
							Prompt:Set(true)

							Prompt.Objects.Darkness = Utility:Create({
								{1, "Frame", {Name = "Darkness", Active = true, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Library.Theme.Primary[7].Color, BackgroundTransparency = 0.5, Parent = Prompt.Objects.Prompt}};
							})

							Prompt.Objects.Blur = Utility:Create({
								{1, "BlurEffect", {Enabled = true, Size = math.huge, Parent = service.Lighting}};
							})

							Prompt.Objects.Frame = Utility:Create({
								{1, "Frame", {Name = "Frame", Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(609/1253.503, 0, 50/550.318, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 486.85/550.318, 0), BackgroundColor3 = Library.Theme.Primary[6].Color, BackgroundTransparency = 0, ZIndex = 2, Parent = Prompt.Objects.Prompt}};
								{2, "UICorner", {CornerRadius = UDim.new(0.2, 0), Parent = {1}}};
							})

							Utility:Create({
								{1, "UIGradient", {Rotation = -45, Offset = Vector2.new(-0.355, 0), Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.951, 0 or 0.05), NumberSequenceKeypoint.new(0.998, 0 or 1), NumberSequenceKeypoint.new(1, 0)}), Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Library.Theme.Secondary[6].Gradient), ColorSequenceKeypoint.new(0.02, Library.Theme.Secondary[6].Gradient), ColorSequenceKeypoint.new(0.021, Library.Theme.Secondary[6].Color), ColorSequenceKeypoint.new(0.15, Library.Theme.Secondary[6].Color), ColorSequenceKeypoint.new(1, Library.Theme.Secondary[6].Color)}), Parent = Prompt.Objects.Frame}};
							})

							Prompt.Objects.Receiver = Utility:Create({
								{1, "TextBox", {Name = "Input_" .. Data.Name, Active = true, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXX, Size = UDim2.new(609/609, 0, 50/609, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundColor3 = Library.Theme.Secondary[5].Color, BackgroundTransparency = 1, ClearTextOnFocus = false, TextScaled = false, TextWrapped = true, TextColor3 = Library.Theme.Primary[6].Color, Text = Data.ClearTextOnFocus and "" or Data.Text or "", Parent = Prompt.Objects.Frame}};
								--{2, "UICorner", {CornerRadius = UDim.new(0.2, 0), Parent = {1}}};
							})

							Prompt.Objects.Receiver.FocusLost:Connect(function(Enter)
								if Enter then
									Data.Function(Data, Data.Text, Enter)
								end
							end)

							Prompt.Objects.Receiver:GetPropertyChangedSignal(Data.ContentText and "ContentText" or "Text"):Connect(function()
								local Text = Data.ContentText and Prompt.Objects.Receiver.ContentText or Prompt.Objects.Receiver.Text
								Data.Text = Text
								Interface.Objects.Receiver.TitleContainer.TextLabel.Text = Text
								Data.Function(Data, Text, false)
							end)

							local Began, Received = false, false
							Prompt.Objects.Receiver.InputBegan:Connect(function(Input)
								if Utility:Input(Input) then
									Received = true
									Input.Changed:Connect(function()
										if not Utility:InputBegan(Input) then
											Received = false
										end
									end)
								end
							end)

							UserInputService.InputBegan:Connect(function(Input, Processed)
								if Utility:Input(Input) then
									if not Received and not Utility:InputObject(Prompt.Objects.Receiver) then
										Prompt:Set(false)

										Prompt.Objects.Blur:Destroy()

										Prompt.Objects.Prompt:Destroy()
									end
								end
							end)
						else
							Prompt:Destroy()
						end
					else
						error("Section.CreateSlider > Missing Data.Function")
					end
				end

				Interface.Objects.Receiver.MouseButton1Click:Connect(Callback)

				return Interface.Table
			end

			Tab:CreateSearch({
				Name = "Search";
				Function = function(self, Value, Input)
					for _, Section in ipairs(Tab.Table.Sections) do
						for _, obj in ipairs(Section.Table.Interfaces) do
							local Template = obj.Objects.Template
							local Title = Template and Template.Title
							Title = Title and Title.TitleContainer and Title.TitleContainer.TextLabel
							local Body = Template and Template.Body
							Body = Body and Body.BodyContainer and Body.BodyContainer.TextLabel
							if Title and Body then
								if not Tab.Table.Disabled[Template] and not (string.lower(Title.Text):match(string.lower(Value)) or string.lower(Body.Text):match(string.lower(Value))) then
									Tab.Table.Disabled[Template] = {Template = Template, Parent = Template.Parent}
									Template.Parent = nil
								elseif Tab.Table.Disabled[Template] and (string.lower(Title.Text):match(string.lower(Value)) or string.lower(Body.Text):match(string.lower(Value))) then
									Tab.Table.Disabled[Template].Template.Parent = Tab.Table.Disabled[Template].Parent
									Tab.Table.Disabled[Template] = nil
								end
							end
						end
					end
				end;
			})

			function Tab.CreateSection(self, Data) -- Section
				local Section = {}
				Section.__index = Section
				--/Window/Tab/Section/

				Utility:Assert(#self.Sections < 15, "Cannot create more than 14 sections")

				Section.Table = setmetatable({
					Data = Data;
					Parent = self;
					Spacings = {};
					Labels = {};
					Paragraphs = {};
					Buttons = {};
					Interfaces = {};
					Destroy = function(self)
						for _, obj in pairs(self.Objects) do
							if obj.Destroy then
								obj:Destroy()
							end
						end
					end;
				}, Section)

				Data.self = Section.Table

				Section.Objects = {}

				Section.Objects.Button = Utility:Create({
					{1, "Frame", {Name = "Section_" .. Data.Name, Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeYY, Size = UDim2.new(40/50, 0, 50/50, 0), AnchorPoint = Vector2.new(0, 0), Position = UDim2.new(0, 0, 0, 0), BackgroundColor3 = Color3.fromRGB(255, 254, 150), BackgroundTransparency = 1, Parent = Tab.Objects.Navigation.Sections}};
					{2, "ImageButton", {AutoButtonColor = false, Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeYY, Size = UDim2.new(12/50, 0, 12/50, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.4, 0), BackgroundColor3 = Library.Theme.Primary[5].Color, Parent = {1}}};
					--{3, "UICorner", {CornerRadius = UDim.new(0.179, 0), Parent = {2}}};
					--{4, "UIStroke", {Color = Library.Theme.Primary[6].Color, Thickness = 0.5, Transparency = 0, Parent = {2}}};
				})

				Utility:Create({
					{1, "TextLabel", {Active = false, SizeConstraint = Enum.SizeConstraint.RelativeXY, BackgroundTransparency = 1, Size = UDim2.new(0.9, 0, 0.25, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.725, 0), Text = Data.Name, TextScaled = true, TextSize = Section.Objects.Button.AbsoluteSize.Y/10, TextColor3 = Library.Theme.Primary[1].Color, Parent = Section.Objects.Button}};
					--{6, "UIStroke", {Color = Color3.fromRGB(173, 254, 151), Thickness = 0.5, Transparency = 0.75, Parent = {5}}}
				})

				local function OnClick()
					for _, Section in pairs(self.Sections) do
						Section.Objects.Box.Visible = false
					end

					Section.Objects.Box.Visible = true
				end

				Utility:Hover(Section.Objects.Button, {X = 40/50, Y = 50/50})

				Utility:OnClick(Section.Objects.Button, OnClick)

				Utility:OnClick(Section.Objects.Button.ImageButton, OnClick)

				Section.Objects.Box = Utility:Create({
					{1, "ScrollingFrame", {Name = "Section_" .. Data.Name, Visible = #self.Sections == 0, Active = true, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(369/429, 0, 318/381, 0), AnchorPoint = Vector2.new(0, 0), Position = UDim2.new(18/429, 0, 43/381, 0), BackgroundColor3 = Library.Theme.Primary[6].Color, BackgroundTransparency = 1, CanvasSize = UDim2.new(0, 0, 0, 0), VerticalScrollBarInset = 0, HorizontalScrollBarInset = 0, ScrollingDirection = 2, ScrollBarThickness = 2, ElasticBehavior = 0, Parent = Tab.Objects.Container}};
					{2, "UIGridLayout", {SortOrder = 2, CellSize = UDim2.new(117/369, 0, 132/318, 0), CellPadding = UDim2.new(8/369, 0, 0, 8), VerticalAlignment = Enum.VerticalAlignment.Top, FillDirection = Enum.FillDirection.Horizontal, FillDirectionMaxCells = 3, Parent = {1}}};
					{3, "UIAspectRatioConstraint", {AspectRatio = 1, AspectType = 0, DominantAxis = 1, Parent = {2}}};
					--{3, "UIPadding", {PaddingLeft = UDim.new(0, 0), Parent = {1}}};
				})

				local CanvasPosition = Vector2.new(0, 0)
				Section.Objects.Box.UIGridLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
					Section.Objects.Box.CanvasSize = UDim2.new(0, 0, 0, Section.Objects.Box.UIGridLayout.AbsoluteContentSize.Y / Window.Table.Data.Scale)
					Section.Objects.Box.CanvasPosition = CanvasPosition
				end)

				Section.Objects.Box:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
					if Window.Active ~= false and Tab.Objects.Container.Visible then CanvasPosition = Section.Objects.Box.CanvasPosition end
					Section.Objects.Box.CanvasPosition = CanvasPosition
				end)

				function Section.CreateSpacing(self, Data) -- Spacing
					local Interface = {}
					Interface.__index = Interface
					--/Window/Tab/Section/Label/

					Interface.Table = setmetatable({
						Data = Data;
						Parent = self;
						Destroy = function(self)
							for _, obj in pairs(self.Objects) do
								if obj.Destroy then
									obj:Destroy()
								end
							end
						end;
					}, Interface)

					Data.self = Interface.Table

					Interface.Objects = {}



					table.insert(self.Interfaces, Interface)
					return Interface.Table
				end

				function Section.CreateTemplate(self, Data) -- Label
					Data = Data or {}
					Data.Name = Data.Name or "Template"
					Data.Body = Data.Body or "Body"

					local Interface = {}
					Interface.__index = Interface
					--/Window/Tab/Section/Label/

					Interface.Table = setmetatable({
						Data = Data;
						Parent = self;
						Destroy = function(self)
							for _, obj in pairs(self.Objects) do
								if obj.Destroy then
									obj:Destroy()
								end
							end
						end;
					}, Interface)

					Data.self = Interface.Table

					Interface.Objects = {}

					Interface.Objects.Template = Utility:Create({
						{1, "Frame", {Name = Data.Name, Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXX, Size = UDim2.new(117/369, 0, 132/369, 0), AnchorPoint = Vector2.new(0, 0), Position = UDim2.new(0, 0, 0, 0), BackgroundColor3 = Library.Theme.Secondary[3].Color, BackgroundTransparency = 0, Parent = Section.Objects.Box}};
						{2, "Frame", {Name = "Title", Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXX, Size = UDim2.new(346/369, 0, 63/369, 0), AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 12/369, 0), BackgroundColor3 = Library.Theme.Primary[3].Color, BackgroundTransparency = 0, Parent = {1}}};
						{3, "Frame", {Name = "Body", Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXX, Size = UDim2.new(346/369, 0, 283/369, 0), AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 75/369, 0), BackgroundColor3 = Library.Theme.Secondary[2].Color, BackgroundTransparency = 0, Parent = {1}}};
						{4, "UICorner", {CornerRadius = UDim.new(0.05, 0), Parent = {1}}};
					})

					Utility:Create({
						{1, "Frame", {Name = "TitleContainer", Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(330/346, 0, 63/63, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundColor3 = Library.Theme.Secondary[3].Color, BackgroundTransparency = 0.95, Parent = Interface.Objects.Template.Title}};
						{2, "TextLabel", {Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(1, 0, 1, 0), AnchorPoint = Vector2.new(0, 0), Position = UDim2.new(0, 0, 0, 0), BackgroundColor3 = Library.Theme.Primary[7].Color, BackgroundTransparency = 1, Font = 36, TextScaled = true, TextWrapped = true, TextXAlignment = 0, Text = " " .. Data.Name, TextSize = 18, TextColor3 = Library.Theme.Primary[6].Color, Parent = {1}}};
						{3, "Frame", {Name = "BodyContainer", Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(330/346, 0, 82.5/90, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundColor3 = Library.Theme.Secondary[3].Color, BackgroundTransparency = 0.95, Parent = Interface.Objects.Template.Body}};
						{4, "TextLabel", {Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(1, 0, 1, 0), AnchorPoint = Vector2.new(0, 0), Position = UDim2.new(0, 0, 0, 0), BackgroundColor3 = Library.Theme.Primary[7].Color, BackgroundTransparency = 1, Font = 36, TextScaled = false, TextWrapped = true, TextXAlignment = 0, TextYAlignment = 0, Text = "\t" .. Data.Body, TextSize = 15, TextColor3 = Library.Theme.Primary[1].Color, Parent = {3}}};
					})

					table.insert(self.Interfaces, Interface)
					return Interface.Table
				end

				function Section.CreateLabel(self, Data) -- Label
					local Interface = self:CreateTemplate(Data)
					--/Window/Tab/Section/Label/

					Interface.Table = setmetatable({
						Data = Data;
						Parent = self;
					}, Interface)

					Data.self = Interface.Table

					table.insert(self.Labels, Interface)
					table.insert(self.Interfaces, Interface)
					return Interface.Table
				end

				function Section.CreateParagraph(self, Data) -- Paragraph
					local Interface = self:CreateTemplate(Data)
					--/Window/Tab/Section/Label/

					Interface.Table = setmetatable({
						Data = Data;
						Parent = self;
					}, Interface)

					Data.self = Interface.Table

					table.insert(self.Interfaces, Interface)
					return Interface.Table
				end

				function Section.CreateButton(self, Data) -- Button
					local Interface = self:CreateTemplate(Data)
					--/Window/Tab/Section/Label/

					Interface.Table = setmetatable({
						Data = Data;
						Parent = self;
						Call = function(self, ...)
							if Data.Function then
								Data.Function(Data, ...)
							else
								error("Section.CreateButton > Missing Data.Function")
							end
						end;
						Destroy = function(self)
							for _, obj in pairs(self.Objects) do
								if obj.Destroy then
									obj:Destroy()
								end
							end
						end;
					}, Interface)

					Data.self = Interface.Table

					Interface.Objects.Template.Body.Size = UDim2.new(346/369, 0, 189/369, 0)

					Interface.Objects.Receiver = (Library.Create:Pager(Interface.Objects.Template, Data, {XX = 369, X = 302, Y = 63})).Objects.Pager

					Interface.Objects.Receiver.TitleContainer.TextLabel.Text = ""

					Interface.Objects.Receiver.AnchorPoint = Vector2.new(0.5, 0)
					Interface.Objects.Receiver.Position = UDim2.new(0.5, 0, 283/369, 0)

					Utility:Hover(Interface.Objects.Receiver, {X = 302/369, Y = 63/369})

							--[[Utility:Create({
								{1, "ImageButton", {Name = "Button_" .. Data.Name, Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXX, Size = UDim2.new(96/117, 0, 20/117, 0), AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 90/117, 0), BackgroundColor3 = Library.Theme.Primary[2].Color, BackgroundTransparency = 0, Parent = Interface.Objects.Template}};
								{2, "UICorner", {CornerRadius = UDim.new(0.2, 0), Parent = {1}}};
							})]]

					local function Callback()
						if Data.Function then
							Data.Function(Data)
						else
							error("Section.CreateButton > Missing Data.Function")
						end
					end

					if Data.Init then Callback() end

					Interface.Objects.Receiver.MouseButton1Click:Connect(Callback)

					table.insert(self.Interfaces, Interface)
					return Interface.Table
				end

				function Section.CreateToggle(self, Data) -- Toggle
					local Interface = self:CreateTemplate(Data)
					--/Window/Tab/Section/Label/

					local Callback = nil

					Interface.Table = setmetatable({
						Data = Data;
						Parent = self;
						Get = function(self)
							return Data
						end;
						Set = function(self, Index, Value)
							if Index == "State" then
								Data.State = Value
								Callback()
							else
								Data[Index] = Value
							end
						end;
						Call = function(self)
							Data.Function(Data, Data.State)
						end;
						Destroy = function(self)
							for _, obj in pairs(self.Objects) do
								if obj.Destroy then
									obj:Destroy()
								end
							end
						end;
					}, Interface)

					Data.self = Interface.Table

					Interface.Objects.Template.Body.Size = UDim2.new(110/117, 0, 60/117, 0)

					Interface.Objects.Receiver = Utility:Create({
						{1, "ImageButton", {Name = "Toggle_" .. Data.Name, AutoButtonColor = false, Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXX, Size = UDim2.new(96/117, 0, 20/117, 0), AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 90/117, 0), BackgroundColor3 = Library.Theme.Secondary[5].Color, BackgroundTransparency = 0, Parent = Interface.Objects.Template}};
						--{2, "UICorner", {CornerRadius = UDim.new(0.2, 0), Parent = {1}}};
					})

					Interface.Objects.Bar = Utility:Create({
						{1, "Frame", {Name = "Bar", Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(78/96, 0, 3/20, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundColor3 = Library.Theme.Secondary[3].Color, BackgroundTransparency = 0, Parent = Interface.Objects.Receiver}};
						--{2, "UICorner", {CornerRadius = UDim.new(0.2, 0), Parent = {1}}};
						{3, "Frame", {Name = "Pointer", Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeYY, Size = UDim2.new(9/3, 0, 9/3, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 0, 0.5, 0), BackgroundColor3 = Library.Theme.Secondary[3].Color, BackgroundTransparency = 0, Parent = {1}}};
						--{4, "UICorner", {CornerRadius = UDim.new(0.2, 0), Parent = {3}}};
					})

					Callback = function()
						if Data.Function then
							Data.Function(Data, Data.State)
							if Data.State then
								TweenService:Create(Interface.Objects.Bar, Tween_Info, {BackgroundColor3 = Library.Theme.Primary[4].Color}):Play()
								TweenService:Create(Interface.Objects.Bar.Pointer, Tween_Info, {BackgroundColor3 = Library.Theme.Primary[4].Color, Position = UDim2.new(1, 0, 0.5, 0)}):Play()
							else
								TweenService:Create(Interface.Objects.Bar, Tween_Info, {BackgroundColor3 = Library.Theme.Secondary[3].Color}):Play()
								TweenService:Create(Interface.Objects.Bar.Pointer, Tween_Info, {BackgroundColor3 = Library.Theme.Secondary[3].Color, Position = UDim2.new(0, 0, 0.5, 0)}):Play()
							end
							Data.State = not Data.State
						else
							error("Section.CreateToggle > Missing Data.Function")
						end
					end

					if Data.Init or Data.State then Callback() end

					Interface.Objects.Receiver.MouseButton1Click:Connect(Callback)

					table.insert(self.Interfaces, Interface)
					return Interface.Table
				end

				function Section.CreateDropdown(self, Data) -- Dropdown
					local Interface = self:CreateTemplate(Data)
					--/Window/Tab/Section/Label/

					local Callback = nil

					Interface.Table = setmetatable({
						Data = Data;
						Parent = self;
						Get = function(self)
							return Data
						end;
						Set = function(self, Index, Value)
							Data[Index] = Value
						end;
						Call = function(self)
							if Data.Selected then
								Data.Function(Data, Data.Selected)
							else
								Callback()
							end
						end;
						Destroy = function(self)
							for _, obj in pairs(self.Objects) do
								if obj.Destroy then
									obj:Destroy()
								end
							end
						end;
					}, Interface)

					Data.self = Interface.Table

					Interface.Objects.Template.Body.Size = UDim2.new(110/117, 0, 60/117, 0)

					Interface.Objects.Receiver = Utility:Create({
						{1, "ImageButton", {Name = "Dropdown_" .. Data.Name, AutoButtonColor = false, Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXX, Size = UDim2.new(96/117, 0, 20/117, 0), AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 90/117, 0), BackgroundColor3 = Library.Theme.Secondary[5].Color, BackgroundTransparency = 0, Parent = Interface.Objects.Template}};
						{2, "UICorner", {CornerRadius = UDim.new(0.2, 0), Parent = {1}}};
					})

					Interface.Objects.Box = Utility:Create({
						{1, "Frame", {Name = "Box", Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeYY, Size = UDim2.new(20/20, 0, 20/20, 0), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0), BackgroundColor3 = Library.Theme.Primary[2].Color, BackgroundTransparency = 0, Parent = Interface.Objects.Receiver}};
						{2, "UICorner", {CornerRadius = UDim.new(0.2, 0), Parent = {1}}};
						{3, "TextLabel", {Name = "Pointer", Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeYY, Size = UDim2.new(20/20, 0, 20/20, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.25, 0), BackgroundColor3 = Library.Theme.Primary[6].Color, BackgroundTransparency = 1, Rotation = 180, Text = "^", TextSize = 16, TextColor3 = Library.Theme.Primary[6].Color, Parent = {1}}};
					})

					Interface.Objects.TextLabel = Utility:Create({
						{1, "Frame", {Name = "TitleContainer", Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(73/96, 0, 17/20, 0), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(23/96, 0, 0.5, 0), BackgroundColor3 = Library.Theme.Secondary[3].Color, BackgroundTransparency = 1, Parent = Interface.Objects.Receiver}};
						{2, "TextLabel", {Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(1, 0, 0.75, 0), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0), BackgroundColor3 = Library.Theme.Primary[7].Color, BackgroundTransparency = 1, Font = 36, TextScaled = true, TextWrapped = true, TextXAlignment = 0, Text = type(Data.Text) == "string" and Data.Text or type(Data.Text) == "table" and table.concat(Data.Text, ", ") or "", TextSize = 18, TextColor3 = Library.Theme.Primary[6].Color, Parent = {1}}};
					})

					Data.IsClosing = false
					local Signals = {}
					Callback = function()
						if Data.Function then
							local function close()
								Interface.Objects.Box.Pointer.Position = UDim2.new(0.5, 0, 0.3, 0)
								Interface.Objects.Box.Pointer.Rotation = 180

								if Interface.Objects.List then
									local Body = TweenService:Create(Interface.Objects.List, Tween_Info, {Size = UDim2.new(96/96, 0, 0/20, 0)})
									Body:Play()

									Body.Completed:Connect(function()
										Interface.Objects.Template.ZIndex = 1

										if Interface.Objects.List then
											Interface.Objects.List:Destroy()
											Interface.Objects.List = nil

											for Index, Signal in ipairs(Signals) do
												Signal:Disconnect()
												Signals[Index] = nil
											end
										end
									end)

									if Data.Selected then
										Data.Text = type(Data.Selected) == "table" and table.concat(Data.Selected, ", ") or ""
										Interface.Objects.TextLabel.TextLabel.Text = Data.Text
										Data.Function(Data, Data.Selected, false)
									end
								end
							end

							local Body = TweenService:Create(Interface.Objects.Box.Pointer, Tween_Info, {TextSize = 0})

							Body:Play()

							if Data.State then
								Data.IsClosing = true
							else
								Data.IsClosing = false
							end

							Body.Completed:Connect(function()
								if Data.State then
									Data.IsClosing = true
									close()
								else
									Data.IsClosing = false

									Interface.Objects.Box.Pointer.Position = UDim2.new(0.5, 0, 0.7, 0)
									Interface.Objects.Box.Pointer.Rotation = 0

									Interface.Objects.Template.ZIndex = 2

									Interface.Objects.List = Utility:Create({
										{1, "ScrollingFrame", {Name = "Box", BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(96/96, 0, 96/20, 0), AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 21/20, 0), BackgroundColor3 = Library.Theme.Secondary[5].Color, BackgroundTransparency = 0.25, CanvasSize = UDim2.new(0, 0, 0, 0), VerticalScrollBarInset = 0, HorizontalScrollBarInset = 0, ScrollingDirection = 2, ScrollBarThickness = 2, ElasticBehavior = 0, Parent = Interface.Objects.Receiver}};
										{2, "UIListLayout", {Padding = UDim.new(0, 4), VerticalAlignment = Enum.VerticalAlignment.Top, FillDirection = Enum.FillDirection.Vertical, SortOrder = 2, Parent = {1}}};
										{3, "UIPadding", {PaddingTop = UDim.new(0, 4), PaddingLeft = UDim.new(4/96, 0), PaddingRight = UDim.new(4/96, 0), Parent = {1}}};
									})

									local function Reposition()
										local Section = Section.Objects.Box
										local List = Interface.Objects.List
										if (List.AbsoluteSize.Y + List.AbsolutePosition.Y) > (Section.AbsoluteSize.Y + Section.AbsolutePosition.Y) then
											List.Position = UDim2.new(0.5, 0, -97/20, 0)
										end
									end; Reposition()

									Interface.Objects.List.Size = UDim2.new(96/96, 0, 0/20, 0)

									local Tween = TweenService:Create(Interface.Objects.List, Tween_Info, {Size = UDim2.new(96/96, 0, 96/20, 0)})

									Tween:Play()
									Tween.Completed:Connect(Reposition)

									local Options = 0

									local CanvasPosition = Vector2.new(0, 0)
									Signals[#Signals + 1] = Interface.Objects.List.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
										Interface.Objects.List.CanvasSize = UDim2.new(0, 0, 0, Interface.Objects.List.UIListLayout.AbsoluteContentSize.Y / Window.Table.Data.Scale + 8)
										Interface.Objects.List.CanvasPosition = CanvasPosition
									end)

									Signals[#Signals + 1] = Interface.Objects.List:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
										if Window.Active ~= false and Tab.Objects.Container.Visible then CanvasPosition = Interface.Objects.List.CanvasPosition end
										Interface.Objects.List.CanvasPosition = CanvasPosition
									end)

									for Index, Option in pairs(type(Data.Table) == "function" and Data.Table() or Data.Table) do
										local Option_Interface = Library.Create:Pager(Interface.Objects.List, Data, {XX = 96, X = 96, Y = 20})

										Utility:Hover(Option_Interface.Objects.Pager, {X = 96/96, Y = 20/96})

										Option_Interface.Objects.TextLabel.Text = tostring(Option)

										Signals[#Signals + 1] = Option_Interface.Objects.Pager.MouseButton1Click:Connect(function()
											if not Data.IsClosing then
												if not Option_Interface.Selected then
													Option_Interface:select()

													if not Data.Selected then
														local Body = TweenService:Create(Interface.Objects.Box.Pointer, Tween_Info, {TextSize = 0})

														Body:Play()

														Data.IsClosing = true

														Body.Completed:Connect(function()
															close()

															TweenService:Create(Interface.Objects.Box.Pointer, Tween_Info, {TextSize = 16}):Play()

															Data.State = not Data.State
														end)

														Data.Text = type(Option) == "string" and Option or type(Option) == "function" and tostring(Index)
														Interface.Objects.TextLabel.TextLabel.Text = Data.Text

														if typeof(Option) == "string" then
															Data.Function(Data, Option)
														elseif typeof(Option) == "function" then
															Data.Function(Data, Option())
														end
													else
														if not table.find(Data.Selected, Option) then
															table.insert(Data.Selected, Option)
														end

														Data.Text = type(Data.Selected) == "table" and table.concat(Data.Selected, ", ") or ""
														Interface.Objects.TextLabel.TextLabel.Text = Data.Text

														Data.Function(Data, Data.Selected, true)
													end
												elseif Option_Interface.Selected and type(Data.Selected) == "table" then
													Option_Interface:unselect()

													if Data.Selected and type(Data.Selected) == "table" then
														table.remove(Data.Selected, table.find(Data.Selected, Option))

														Data.Text = type(Data.Selected) == "table" and table.concat(Data.Selected, ", ") or ""
														Interface.Objects.TextLabel.TextLabel.Text = Data.Text

														Data.Function(Data, Data.Selected, true)
													else
														Data.IsClosing = false
													end
												end
											end
										end)

										if Data.Selected and table.find(Data.Selected, Option) and type(Data.Selected) == "table" then
											Option_Interface:select()

											Interface.Objects.TextLabel.TextLabel.Text = type(Data.Selected) == "table" and table.concat(Data.Selected, ", ") or ""

											Data.Function(Data, Data.Selected, false)
										end

										Options = Options + 1
									end
								end

								TweenService:Create(Interface.Objects.Box.Pointer, Tween_Info, {TextSize = 16}):Play()

								Data.State = not Data.State
							end)
						else
							error("Section.CreateDropdown > Missing Data.Function")
						end
					end

					if Data.Init and Data.Text then
						Data.Function(Data, Data.Selected and (type(Data.Text) == "string" and string.split(Data.Text, ", ") or type(Data.Text) == "table" and Data.Text) or type(Data.Text) == "table" and table.concat(Data.Text, ", ") or Data.Text or "", false)
						Callback()
					end

					Interface.Objects.Receiver.MouseButton1Click:Connect(Callback)

					table.insert(self.Interfaces, Interface)
					return Interface.Table
				end

				function Section.CreateSlider(self, Data) -- Slider
					local Interface = self:CreateTemplate(Data)
					--/Window/Tab/Section/Label/

					Interface.Table = setmetatable({
						Data = Data;
						Parent = self;
						Get = function(self)
							return Data
						end;
						Set = function(self, Index, Value)
							if Index == "Value" then
								Data.Value = Value
								Interface.Objects.Bar.Pointer.Visual.Value.Text = Value
								Interface.Objects.Bar.Pointer.Position = UDim2.new(math.clamp((Value - Data.Min) / (Data.Max - Data.Min), 0, 1), 0, 0.5, 0)
							else
								Data[Index] = Value
							end
						end;
						Call = function(self)
							Data.Function(Data, Data.Value, false)
						end;
						Destroy = function(self)
							for _, obj in pairs(self.Objects) do
								if obj.Destroy then
									obj:Destroy()
								end
							end
						end;
					}, Interface)

					Data.self = Interface.Table

					Interface.Objects.Template.Body.Size = UDim2.new(110/117, 0, 60/117, 0)

					Interface.Objects.Receiver = Utility:Create({
						{1, "ImageButton", {Name = "Slider_" .. Data.Name, AutoButtonColor = false, Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXX, Size = UDim2.new(96/117, 0, 20/117, 0), AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 90/117, 0), BackgroundColor3 = Library.Theme.Secondary[5].Color, BackgroundTransparency = 0, Parent = Interface.Objects.Template}};
						--{2, "UICorner", {CornerRadius = UDim.new(0.2, 0), Parent = {1}}};
					})

					Interface.Objects.Bar = Utility:Create({
						{1, "Frame", {Name = "Bar", Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(80/96, 0, 3/20, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundColor3 = Library.Theme.Secondary[3].Color, BackgroundTransparency = 0, Parent = Interface.Objects.Receiver}};
						--{2, "UICorner", {CornerRadius = UDim.new(0.2, 0), Parent = {1}}};
						{3, "Frame", {Name = "Pointer", Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeYY, Size = UDim2.new(9/5, 0, 9/5, 0), AnchorPoint = Vector2.new(0.5, 0.5), Rotation = 45, Position = UDim2.new(0, 0, 0.5, 0), BackgroundColor3 = Library.Theme.Primary[2].Color, BackgroundTransparency = 0, Parent = {1}}};
						--{4, "UICorner", {CornerRadius = UDim.new(0.2, 0), Parent = {3}}};
					})

					Interface.Objects.Visual = Utility:Create({
						{1, "ImageLabel", {Name = "Visual", Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(300/96, 0, 75/20, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(-1, 0, -1, 0), BackgroundColor3 = Library.Theme.Secondary[5].Color, BackgroundTransparency = 1, Rotation = -45, Image = "rbxassetid://12080467938", Parent = Interface.Objects.Bar.Pointer}};
						--{2, "UICorner", {CornerRadius = UDim.new(0.2, 0), Parent = {1}}};
						{3, "TextLabel", {Name = "Value", Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeYY, Size = UDim2.new(1, 0, 1, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.425, 0), BackgroundColor3 = Library.Theme.Primary[6].Color, BackgroundTransparency = 1, Rotation = 0, Font = 36, Text = Data.Value, TextSize = 12, TextColor3 = Library.Theme.Primary[6].Color, Parent = {1}}};
						--{4, "UICorner", {CornerRadius = UDim.new(0.2, 0), Parent = {3}}};
					})

					Data.Min = Data.Range and Data.Range[1] or Data.Min
					Data.Max = Data.Range and Data.Range[2] or Data.Max

					Interface.Objects.Bar.Pointer.Visual.Value.Text = Data.Value
					Interface.Objects.Bar.Pointer.Position = UDim2.new((Data.Value - Data.Min) / (Data.Max - Data.Min), 0, 0.5, 0)

					local Signals = {}
					local function Callback()
						if Data.Function then
							local Prompt = Library.Create:Prompt(Data)

							if not Prompt:Get() then
								Prompt:Set(true)

								Prompt.Objects.Darkness = Utility:Create({
									{1, "Frame", {Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Library.Theme.Primary[7].Color, BackgroundTransparency = 0.5, Parent = Prompt.Objects.Prompt}};
								})

								Prompt.Objects.Blur = Utility:Create({
									{1, "BlurEffect", {Enabled = true, Size = math.huge, Parent = service.Lighting}};
								})

								Prompt.Objects.Frame = Utility:Create({
									{1, "Frame", {Active = true, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(609/1253.503, 0, 50/550.318, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 486.85/550.318, 0), BackgroundColor3 = Library.Theme.Primary[6].Color, BackgroundTransparency = 0, Parent = Prompt.Objects.Prompt}};
									{2, "UICorner", {CornerRadius = UDim.new(0.2, 0), Parent = {1}}};
								})

								Utility:Create({
									{1, "UIGradient", {Rotation = -45, Offset = Vector2.new(-0.355, 0), Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Library.Theme.Secondary[6].Gradient), ColorSequenceKeypoint.new(0.02, Library.Theme.Secondary[6].Gradient), ColorSequenceKeypoint.new(0.021, Library.Theme.Secondary[6].Color), ColorSequenceKeypoint.new(1, Library.Theme.Secondary[6].Color)}), Parent = 
										Prompt.Objects.Frame}};
								})

								Prompt.Objects.Receiver = Utility:Create({
									{1, "ImageButton", {Name = "Slider_" .. Data.Name, AutoButtonColor = false, Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXX, Size = UDim2.new(609/609, 0, 50/609, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundColor3 = Library.Theme.Secondary[5].Color, BackgroundTransparency = 1, Parent = Prompt.Objects.Frame}};
									--{2, "UICorner", {CornerRadius = UDim.new(0.2, 0), Parent = {1}}};
								})

								Prompt.Objects.Bar = Utility:Create({
									{1, "Frame", {Name = "Bar", Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(559/609, 0, 50/609, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundColor3 = Library.Theme.Secondary[3].Color, BackgroundTransparency = 0, Parent = Prompt.Objects.Receiver}};
									{2, "UICorner", {CornerRadius = UDim.new(0.2, 0), Parent = {1}}};
									{3, "Frame", {Name = "Pointer", Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeYY, Size = UDim2.new(125/50, 0, 125/50, 0), AnchorPoint = Vector2.new(0.5, 0.5), Rotation = 45, Position = UDim2.new(0, 0, 0.5, 0), BackgroundColor3 = Library.Theme.Primary[2].Color, BackgroundTransparency = 0, Parent = {1}}};
									--{4, "UICorner", {CornerRadius = UDim.new(0.2, 0), Parent = {3}}};
								})

								Prompt.Objects.Visual = Utility:Create({
									{1, "ImageLabel", {Name = "Visual", Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(450/125, 0, 450/125, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(2.5, 0, 2.5, 0), BackgroundColor3 = Library.Theme.Secondary[5].Color, BackgroundTransparency = 1, Rotation = -45 + 180, Image = "rbxassetid://12080467938", Parent = Prompt.Objects.Bar.Pointer}};
									--{2, "UICorner", {CornerRadius = UDim.new(0.2, 0), Parent = {1}}};
									{3, "TextLabel", {Name = "Value", Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeYY, Size = UDim2.new(1, 0, 1, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.45, 0), BackgroundColor3 = Library.Theme.Primary[6].Color, BackgroundTransparency = 1, Rotation = 180, Font = 36, Text = Data.Value, TextSize = 18, TextColor3 = Library.Theme.Primary[6].Color, Parent = {1}}};
									--{4, "UICorner", {CornerRadius = UDim.new(0.2, 0), Parent = {3}}};
								})

								Prompt.Objects.Bar.Pointer.Position = UDim2.new((Data.Value - Data.Min) / (Data.Max - Data.Min), 0, 0.5, 0)

								local Slide, InputBegan = false, nil
								local function Callback(Input)
									if InputBegan and Prompt.Objects.Visual and Prompt.Objects.Visual:FindFirstChild("Value") then
										local Position = math.clamp(InputBegan.Position.X - Prompt.Objects.Bar.AbsolutePosition.X, Data.Min, Prompt.Objects.Bar.AbsoluteSize.X)
										Position = Position / Prompt.Objects.Bar.AbsoluteSize.X

										local Value = math.clamp(Position * (Data.Max - Data.Min) + Data.Min, Data.Min, Data.Max)
										Value = Data.Increment and math.floor(Value / Data.Increment + 0.5) * (Data.Increment * 10000000) / 10000000 or Value
										Data.Value = Value

										Prompt.Objects.Visual.Value.Text = tostring(Value)
										Prompt.Objects.Bar.Pointer.Position = UDim2.new(math.clamp((Value - Data.Min) / (Data.Max - Data.Min), 0, 1), 0, 0.5, 0)

										Data.Function(Data, Value, Input)
									end
								end

								local Began, Received = false, false
								Signals[#Signals + 1] = Prompt.Objects.Receiver.InputBegan:Connect(function(Input)
									if Utility:Input(Input) then
										Received = true
										Input.Changed:Connect(function()
											if not Utility:InputBegan(Input) then
												Received = false
											end
										end)
										if not Began then
											InputBegan = Input
											Slide = true
											Section.Objects.Box.ScrollingEnabled = false
											Callback(false)
										end
									end
								end)

								Signals[#Signals + 1] = UserInputService.InputBegan:Connect(function(Input, Processed)
									if Utility:Input(Input) then
										if not Processed then
											Began = true
											Input.Changed:Connect(function()
												if not Utility:InputBegan(Input) then
													Began = false
													InputBegan = nil
													Slide = false
													Section.Objects.Box.ScrollingEnabled = true
												end
											end)
										end
										if not Received and not Utility:InputObject(Prompt.Objects.Receiver) then
											InputBegan = nil 
											Began = false
											Slide = false
											Section.Objects.Box.ScrollingEnabled = true

											Prompt:Set(false)

											Prompt.Objects.Blur:Destroy()

											Interface.Objects.Bar.Pointer.Visual.Value.Text = Data.Value
											Interface.Objects.Bar.Pointer.Position = UDim2.new((Data.Value - Data.Min) / (Data.Max - Data.Min), 0, 0.5, 0)

											Prompt.Objects.Prompt:Destroy()

											for Index, Signal in ipairs(Signals) do
												Signal:Disconnect()
												Signals[Index] = nil
											end
										end
									end
								end)

								Signals[#Signals + 1] = UserInputService.InputChanged:Connect(function(Input)
									if Utility:Input(Input, true) then
										if Slide then
											if Input.UserInputType == Enum.UserInputType.MouseMovement and Received then
												InputBegan = Input
											elseif Input.UserInputType ~= Enum.UserInputType.Touch then
												InputBegan = nil 
												Began = false
												Slide = false
												Section.Objects.Box.ScrollingEnabled = true
											end
											Callback(true)
										end
									end
								end)
							else
								Prompt:Destroy()
							end
						else
							error("Section.CreateSlider > Missing Data.Function")
						end
					end

					if Data.Init then Data.Function(Data, Data.Value, false) end

					Interface.Objects.Receiver.MouseButton1Click:Connect(Callback)

					table.insert(self.Interfaces, Interface)
					return Interface.Table
				end

				function Section.CreateInput(self, Data) -- Input
					local Interface = self:CreateTemplate(Data)
					--/Window/Tab/Section/Label/

					Interface.Table = setmetatable({
						Data = Data;
						Parent = self;
						Get = function(self)
							return Data
						end;
						Set = function(self, Index, Value)
							if Index == "Text" then
								Data.Text = Value
								Interface.Objects.Receiver.TitleContainer.TextLabel.Text = Value
							else
								Data[Index] = Value
							end
						end;
						Call = function(self)
							Data.Function(Data, Data.Text, false)
						end;
						Destroy = function(self)
							for _, obj in pairs(self.Objects) do
								if obj.Destroy then
									obj:Destroy()
								end
							end
						end;
					}, Interface)

					Data.self = Interface.Table

					Interface.Objects.Template.Body.Size = UDim2.new(110/117, 0, 60/117, 0)

					Interface.Objects.Receiver = Utility:Create({
						{1, "ImageButton", {Name = "Input_" .. Data.Name, AutoButtonColor = false, Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXX, Size = UDim2.new(96/117, 0, 20/117, 0), AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 90/117, 0), BackgroundColor3 = Library.Theme.Secondary[5].Color, BackgroundTransparency = 0, Parent = Interface.Objects.Template}};
						--{2, "UICorner", {CornerRadius = UDim.new(0.2, 0), Parent = {1}}};
					})

					Utility:Create({
						{1, "Frame", {Name = "TitleContainer", Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(86/96, 0, 17/20, 0), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), BackgroundColor3 = Library.Theme.Secondary[3].Color, BackgroundTransparency = 1, Parent = Interface.Objects.Receiver}};
						{2, "Frame", {Name = "TextCursor", Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeYY, Size = UDim2.new(3/17, 0, 12/17, 0), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(-6/86, 0, 0.5, 0), BackgroundColor3 = Library.Theme.Primary[2].Color, BackgroundTransparency = 0, Parent = {1}}};
						{3, "TextLabel", {Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(1, 0, 1, 0), AnchorPoint = Vector2.new(0, 0), Position = UDim2.new(0, 0, 0, 0), BackgroundColor3 = Library.Theme.Primary[7].Color, BackgroundTransparency = 1, Font = 36, TextScaled = true, TextWrapped = true, TextXAlignment = 0, Text = Data.Text, TextSize = 18, TextColor3 = Library.Theme.Primary[6].Color, Parent = {1}}};
					})

					local Signals = {}
					local function Callback()
						if Data.Function then
							local Prompt = Library.Create:Prompt(Data)

							if not Prompt:Get() then
								Prompt:Set(true)

								Prompt.Objects.Darkness = Utility:Create({
									{1, "Frame", {Name = "Frame", Active = true, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Library.Theme.Primary[7].Color, BackgroundTransparency = 0.5, Parent = Prompt.Objects.Prompt}};
								})

								Prompt.Objects.Blur = Utility:Create({
									{1, "BlurEffect", {Enabled = true, Size = math.huge, Parent = service.Lighting}};
								})

								Prompt.Objects.Frame = Utility:Create({
									{1, "Frame", {Name = "Frame", Active = false, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXY, Size = UDim2.new(609/1253.503, 0, 50/550.318, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 486.85/550.318, 0), BackgroundColor3 = Library.Theme.Primary[6].Color, BackgroundTransparency = 0, Parent = Prompt.Objects.Prompt}};
									{2, "UICorner", {CornerRadius = UDim.new(0.2, 0), Parent = {1}}};
								})

								Utility:Create({
									{1, "UIGradient", {Rotation = -45, Offset = Vector2.new(-0.355, 0), Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Library.Theme.Secondary[6].Gradient), ColorSequenceKeypoint.new(0.02, Library.Theme.Secondary[6].Gradient), ColorSequenceKeypoint.new(0.021, Library.Theme.Secondary[6].Color), ColorSequenceKeypoint.new(1, Library.Theme.Secondary[6].Color)}), Parent = 
										Prompt.Objects.Frame}};
								})

								Prompt.Objects.Receiver = Utility:Create({
									{1, "TextBox", {Name = "Input_" .. Data.Name, Active = true, BorderSizePixel = 0, SizeConstraint = Enum.SizeConstraint.RelativeXX, Size = UDim2.new(609/609, 0, 50/609, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundColor3 = Library.Theme.Secondary[5].Color, BackgroundTransparency = 1, ClearTextOnFocus = false, TextColor3 = Library.Theme.Primary[6].Color, Text = Data.ClearTextOnFocus and "" or Data.Text, PlaceholderText = Data.PlaceholderText or "", Parent = Prompt.Objects.Frame}};
									--{2, "UICorner", {CornerRadius = UDim.new(0.2, 0), Parent = {1}}};
								})

								local Signals = {}

								Signals[#Signals + 1] = Prompt.Objects.Receiver.FocusLost:Connect(function(Enter)
									if Enter then
										Data.Function(Data, Data.Text, Enter)
									end
								end)

								Signals[#Signals + 1] = Prompt.Objects.Receiver:GetPropertyChangedSignal(Data.ContentText and "ContentText" or "Text"):Connect(function()
									local Text = Data.ContentText and Prompt.Objects.Receiver.ContentText or Prompt.Objects.Receiver.Text
									Data.Text = Text
									Interface.Objects.Receiver.TitleContainer.TextLabel.Text = Text
									Data.Function(Data, Text, false)
								end)

								local Began, Received = false, false
								Signals[#Signals + 1] = Prompt.Objects.Receiver.InputBegan:Connect(function(Input)
									if Utility:Input(Input) then
										Received = true
										Input.Changed:Connect(function()
											if not Utility:InputBegan(Input) then
												Received = false
											end
										end)
									end
								end)

								Signals[#Signals + 1] = UserInputService.InputBegan:Connect(function(Input, Processed)
									if Utility:Input(Input) then
										if not Received and not Utility:InputObject(Prompt.Objects.Receiver) then
											Prompt:Set(false)

											Prompt.Objects.Blur:Destroy()

											Prompt.Objects.Prompt:Destroy()

											for Index, Signal in ipairs(Signals) do
												Signal:Disconnect()
												Signals[Index] = nil
											end
										end
									end
								end)
							else
								Prompt:Destroy()
							end
						else
							error("Section.CreateInput > Missing Data.Function")
						end
					end

					if Data.Init then Data.Function(Data, Data.Text, false) end

					Interface.Objects.Receiver.MouseButton1Click:Connect(Callback)

					table.insert(self.Interfaces, Interface)
					return Interface.Table
				end

				function Section.CreateKeybind(self, Data) -- Keybind
					local Interface = self:CreateTemplate(Data)
					--/Window/Tab/Section/Label/

					Interface.Table = setmetatable({
						Data = Data;
						Parent = self;
					}, Interface)

					Data.self = Interface.Table

					table.insert(self.Interfaces, Interface)
					return Interface.Table
				end

				function Section.CreateColorPicker(self, Data) -- ColorPicker
					local Interface = self:CreateTemplate(Data)
					--/Window/Tab/Section/Label/

					Interface.Table = setmetatable({
						Data = Data;
						Parent = self;
					}, Interface)

					Data.self = Interface.Table

					table.insert(self.Interfaces, Interface)
					return Interface.Table
				end

				table.insert(self.Sections, Section)
				return Section.Table
			end

			table.insert(self.Tabs, Tab)
			return Tab.Table
		end

		task.spawn(function()
			while false and task.wait(1) do
				local Duration = 1
				local TweenInfo = TweenInfo.new(Duration, 1, 0, 0)

				TweenService:Create(Window.Objects.Canvas.UIScale, TweenInfo, {Scale = math.random(0, 150)/100}):Play()
			end
		end)

		table.insert(self.Windows, Window)
		return Window.Table
	end

	return Core.Table
end
-- Library

-- Template
--[[
local Core = Library:Init({
	Name = "Infinixity";
	Parent = LocalPlayer.PlayerGui;
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

Core:Validate({
	Name = "Infinixity";
	Tutorial = true;
	Validate = "abc";
	Text = "";
	Placeholder = "Key here!";
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

return Library
