-- By rbx: @IlIl_ILovAltAccsHAHA / ・゠314・一一一非公式ジェイ一一一・・ - Unofficial Jay | Git: @UnofficialJay3

-- CHECKERS
-- Module key
local key = "__JaysTHEMODULE__"

-- Check if module exists in _G
if _G[key] then
	warn("JaysTHEMODULE already loaded. Attempting to update...")
	--return -- Return so there aren't multiple stuff in _G
end

-- Real initialization
print("JaysScripts - JaysTHEMODULE | Git: UnofficialJay3")

-- Create the table in _G
_G[key] = _G[key] or {}
local M = _G[key]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")



-- This is unofficially a main lane guys! You know when it's the main lane when Jay says it!



-- Store services
M.Services = {
	["Players"] = Players,
	["RunService"] = RunService,
	["TweenService"] = TweenService,
	["TextChatService"] = TextChatService,
	["UserInputService"] = UserInputService,
	["ReplicatedStorage"] = ReplicatedStorage
}



-- Tasks
M.Tasks = {}



-- Add script to _G
function M.AddScript(name)
	local newName = "__" .. name .. "__"
	
	-- Check if the script already exists
	if _G[newName] then
		warn("JaysScripts - A script named '" .. name .. "' already exists in _G! Attempting to update...")
	end
	
	_G[newName] = {}
	local a = _G[newName]
	print("JaysScripts - " .. name .. " | Git: UnofficialJay3")
	return a, newName
end



-- Cleaner for module keys in _G
function M.CleanModule(key)
	local mod = _G[key]
	if not mod then
		warn("No module found for key:", key)
		return
	end

	-- Step 1: disconnect all connections
	if mod.Connections and type(mod.Connections) == "table" then
		for name, conn in pairs(mod.Connections) do
			if typeof(conn) == "RBXScriptConnection" then
				conn:Disconnect()
			elseif type(conn) == "table" and conn.running ~= nil then
				-- If you stored task-loops with a running flag
				conn.running = false
			end
			mod.Connections[name] = nil
		end
	end

	-- Step 2: wipe the module key
	_G[key] = nil

	print("Cleaned module:", key)
end



-- Test function
function M.Test()
    print("JaysTHEMODULE is working!")
end



-- Dump tables in _G or I guess anytable? I've gotten this from chatgpt tbh.
function M.DumpTable(tbl, name, indent, seen)
	indent = indent or ""
	seen = seen or {}

	if seen[tbl] then
		print(indent .. name .. " = <circular>")
		return
	end

	seen[tbl] = true

	if type(tbl) ~= "table" then
		print(indent .. name .. " = " .. tostring(tbl))
		return
	end

	print(indent .. name .. " = {")
	for k, v in pairs(tbl) do
		M.DumpTable(v, tostring(k), indent .. "  ", seen)
	end
	print(indent .. "}")
end



-- Get player by search
function M.GetSinglePlayer(input)
	if typeof(input) ~= "string" then
		warn("Expected string, got:", typeof(input))
		return nil
	end

	input = input:lower()

	for _, player in ipairs(Players:GetPlayers()) do
		local username = player.Name:lower()
		local displayName = player.DisplayName:lower()

		if username:sub(1, #input) == input or displayName:sub(1, #input) == input then
			return player
		end
	end

	return nil
end



-- Get player/s by type | TYPES: all: Gets all players, others: Gets all players except for you, me: Gets your local player, random: Gets a random player, no type: Check player by GetSinglePlayer func or return nil.
function M.GetPlayers(player, typo) -- Typo means the type but can also mean the player name if your attempting to use their name.
	if typo == "all" then
		return Players:GetPlayers()
	elseif typo == "others" then
		local playuhs = Players:GetPlayers()
		local i = table.find(playuhs, player)
		table.remove(playuhs, i)
		return playuhs
	elseif typo == "me" then
		return {player}
	elseif typo == "random" then
		return {Players:GetPlayers()[math.random(1,#Players:GetPlayers())]}
	else -- No matches, check if the player is in the server.
		local playuh = M.GetSinglePlayer(typo)
		if playuh then
			return {playuh}
		else
			warn("The player you provided doesn't exist in Players.")
			return nil
		end
	end
end



-- Get character stuff by name
function M.GetCharacter(name)
	local player = M.GetSinglePlayer(name)
	if not player then return end
	
	local playerGui = player:FindFirstChild("PlayerGui")
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChild("Humanoid")
	
	return {
		["player"] = player,
		["playergui"] = playerGui,
		["char"] = char,
		["root"] = root,
		["hum"] = hum
	}
end



-- Get local character
function M.GetLocalCharacter()
	return M.GetCharacter(Players.LocalPlayer.Name)
end



-- Get args
function M.GetArgs(text, splitter)
	return string.split(text or "", splitter or " ")
end



-- Get cmd
function M.GetCmd(text, cmd)
	local args = M.GetArgs(text)
	local cmd = args[1]:lower()
	table.remove(args, 1)
	return cmd, args
end



-- The Officialized PROMPTER! T.O.P!
function M.ThePrompter(titlo, placeholder)
	local playergui = M.GetLocalCharacter().playergui
	if not playergui then return end
	
	-- Add screen gui
	local gui = Instance.new("ScreenGui", playergui)
	gui.Name = "T.O.P - The Officialized Prompter"
	gui.IgnoreGuiInset = true
	
	-- The box!
	local box = Instance.new("TextBox", gui)
	box.AnchorPoint = Vector2.new(0.5, 0.5)
	box.Position = UDim2.new(0.5, 0, 0.5, 0)
	box.Size = UDim2.new(0, 829, 0, 377) -- {0, 829},{0, 377}
	box.BackgroundColor3 = Color3.fromRGB(0,0,0)
	box.BackgroundTransparency = 0.75
	box.PlaceholderText = placeholder or "Type a command."
	box.TextColor3 = Color3.fromRGB(255,255,255)
	box.MultiLine = false
	box:CaptureFocus()
	task.delay(0,function()
		box.Text = ""
	end)
	box.TextScaled = true
	-- Instance modifiers for box(tm)
	local con = Instance.new("UIAspectRatioConstraint", box)
	con.AspectRatio = 1.75
	con.AspectType = Enum.AspectType.ScaleWithParentSize
	local corner = Instance.new("UICorner", box)
	corner.CornerRadius = UDim.new(0.15, 0)
	local pad = Instance.new("UIPadding", box)
	pad.PaddingLeft = UDim.new(0, 0)
	pad.PaddingRight = UDim.new(0, 0)
	pad.PaddingTop = UDim.new(0.02, 0)
	pad.PaddingBottom = UDim.new(0.02, 0)
	local context, border = Instance.new("UIStroke", box), Instance.new("UIStroke", box)
	context.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
	context.Thickness = 5
	border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	border.Thickness = 5
	
	-- Title
	local title = Instance.new("TextLabel", box)
	title.BackgroundTransparency = 1
	title.Size = UDim2.new(1, 0, 0.2, 0)
	title.Text = titlo or "JaysScripts - T.O.P"
	title.TextColor3 = Color3.fromRGB(255,255,255)
	title.TextScaled = true
	-- Instance modifiers
	context = Instance.new("UIStroke", title)
	context.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
	context.Thickness = 5
	
	
	
	box.FocusLost:Connect(function(ep)
		gui:Destroy()
	end)
	
	return box
end



-- Stop task
function M.StopTask(name)
	if M.Tasks[name] then
		M.Tasks[name].running = false
		M.Tasks[name] = nil
	end
end

-- Start task | Thank you chatgpt
function M.StartTask(n, f)
	if M.Tasks[n] then
		M.StopTask(n)
	end
	local taskInfo = {running = true}
	M.Tasks[n] = taskInfo

	task.spawn(function()
		f(taskInfo)
	end)
end



-- Self destruct.
function M.SelfDestruct()
	for _, v in pairs(game:GetDescendants()) do  
		pcall(function()
			v:Destroy()
		end)
	end
end



-- Is key held by key and if gp is enabled
function M.IsHeld(key, z)
	z = z or true
	key = Enum.KeyCode[key]
	if UserInputService:GetFocusedTextBox() and z then
		return false
	end
	return UserInputService:IsKeyDown(key)
end



-- Message
function M.Message(message)
	local TextChatService = game:GetService("TextChatService")

	if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
		-- Modern chat
		TextChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(message)
	else
		-- Legacy chat
		ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer(message, "All")
	end
end
