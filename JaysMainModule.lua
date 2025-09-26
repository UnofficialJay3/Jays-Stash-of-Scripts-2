-- Scripted by ROBLOX: @IlIl_ILovAltAccsHAHA / ・゠314・一一一非公式ジェイ一一一・・ - Unofficial Jay | GITHUB: @UnofficialJay3

--[[ Table of contents:

C = Current - The current script for _G
M = Main - The JaysMainModule script for _G

]]

-- Script init
-- Crediter cuz I NEED CREDIT!!!
_G.Useless = _G.Useless or function()
	print("Scripted by ROBLOX: @IlIl_ILovAltAccsHAHA / ・゠314・一一一非公式ジェイ一一一・・ - Unofficial Jay | GITHUB: @UnofficialJay3")
	_G.Useless = function()end
end
_G.Useless()

-- Add script function
local a = function(name)
	-- Check if script already exists
	if _G[name] then
		warn("You attempted to execute another script! Now be updating?")
	end

	-- Add script to _G
	local scripto = {}
	_G[name] = scripto
	print("JaysScript - " .. name .. " Git: @UnofficialJay3")

	return scripto, name
end
_G.AddScript = a

-- Add itself to _G using AddScript()
local C, ScriptKey = _G.AddScript("JaysMainModule")

-- Re-parent the AddScript to JaysMainModule
_G.AddScript = nil
C.AddScript = a



-- Main init
-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TextChatService = game:GetService("TextChatService")
local SoundService = game:GetService("SoundService")

-- Variables
C.Connections = {}
C.Tasks = {}



-- The first main lane of today!



-- Services table
C.Services = {
	["Players"] = Players,
	["ReplicatedStorage"] = ReplicatedStorage,
	["UserInputService"] = UserInputService,
	["RunService"] = RunService,
	["TextChatService"] = TextChatService,
	["SoundService"] = SoundService
}



-- Test
function C.Test(...)
	print("This is a test!")
	print(...)
end



-- Play sound
function C.PlaySound(id, t)
	local s = Instance.new("Sound")
	s.SoundId = "rbxassetid://" .. id
	s.Parent = SoundService
	
	-- Settable properties
	if t.speed ~= nil then s.PlaybackSpeed = t.speed end
	if t.volume ~= nil then s.Volume = t.volume end
	
	s:Play()
	s.PlayOnRemove = true
	s:Destroy()
end



-- Dump tables in _G or I guess anytable? I've gotten this from chatgpt tbh.
function C.DumpTable(tbl, name, indent, seen)
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
		C.DumpTable(v, tostring(k), indent .. "  ", seen)
	end
	print(indent .. "}")
end



-- Get character
function C.GetCharacter(player)
	-- Get player from instance or name
	if typeof(player) == "Instance" then
		player = player.Name
	end
	
	local player = Players:FindFirstChild(player)
	local playergui = player:FindFirstChild("PlayerGui")
	local char = player.Character or player.CharacterAdded:Wait()
	local root = char:WaitForChild("HumanoidRootPart")
	local hum = char:WaitForChild("Humanoid")
	return {
		["player"] = player,
		["playergui"] = playergui,
		["char"] = char,
		["root"] = root,
		["hum"] = hum,
	}
end



-- Get local player
function C.GetLocalCharacter()
	return C.GetCharacter(Players.LocalPlayer)
end



-- Get player by name - Shorten + gets user+display name
function C.GetPlayerBySearch(input)
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



--[[ Get player/s by type
TYPES: "all" gets all players
"others" gets all players except the one who called it
"me" gets your player
"random" gets a random player
none? gets the player by the type of the input, if no founds then return nil
]]

function C.GetPlayerByType(player, typo)
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
		return {Players:GetPlayers()[math.random(1, #Players:GetPlayers())]}
	else -- Find nothin', then find by name
		local player = C.GetPlayerBySearch(typo)
		if player then
			return {player}
		else
			warn("No player founded in GetPlayerByType.")
			return nil
		end
	end
end



-- The Officialized PROMPTER! T.O.P!
function C.Prompter(titlo, placeholder)
	local playergui = C.GetLocalCharacter().playergui
	if not playergui then return end

	-- Add screen gui
	local gui = Instance.new("ScreenGui", playergui)
	gui.Name = "JaysScripts - T.O.P - The Official Prompter"
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



-- Get args
function C.GetArgs(str, split)
	return string.split(str, split or " ")
end



-- Get cmd
function C.GetCmd(str)
	local args = C.GetArgs(str, " ")
	local cmd = args[1]:lower()
	table.remove(args, 1)
	return cmd, args
end



-- Say/message command
function C.ChatMsg(str)
	if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
		-- Modern chat
		TextChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(str)
	else
		-- Legacy chat
		ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer(str, "All")
	end
end



-- Disconnect connection
function C.DisconnConn(conn)
	conn:Disconnect()
	conn = nil
end



-- Cancel task
function C.CancelTask(name)
	local thread = C.Tasks[name]
	if thread and coroutine.status(thread) ~= "dead" then
		task.cancel(thread)
		C.Tasks[name] = nil
	end
end



-- Create task
function C.CreateTask(name, func)
	local thread = C.Tasks[name]
	thread = coroutine.create(func)
	task.spawn(thread)
end



-- Get move vector
local PlayerModule = Players.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")
local ControlModule = require(PlayerModule:WaitForChild("ControlModule"))

function C.GetMoveVector(x,y,z)
	local cam = workspace.CurrentCamera
	local camCF = cam.CFrame
	local moveVec = Vector3.zero

	local mobileVec = ControlModule:GetMoveVector()
	if mobileVec.Magnitude > 0 then
		local forward = Vector3.new(camCF.LookVector.X * x, camCF.LookVector.Y * y, camCF.LookVector.Z*z).Unit
		local right = Vector3.new(camCF.RightVector.X * x, camCF.RightVector.Y * y, camCF.RightVector.Z*z).Unit
		moveVec += (forward * -mobileVec.Z + right * mobileVec.X)
	end
	
	return moveVec
end



-- Is key hold/down function
function C.IsKeyDown(key)
	if UserInputService.TextBoxFocused then return end
	if not key then warn("Enter in a key buhhh!") return end
	key = Enum.KeyCode[key] or nil
	if not key then return end
	key = UserInputService:IsKeyDown(key)
	return key
end


-- Apply Linear Velocity
function C.AppLinVel(part, name)
	-- Your up to change these on your OWN!
	if not part then return end
	local att = Instance.new("Attachment",part)
	att.Name = name .. "Att"
	local lv = Instance.new("LinearVelocity",part)
	lv.Name = name .. "LinVel"
	lv.Attachment0 = att
	lv.MaxForce = 0
	lv.VectorVelocity = Vector3.zero
	return lv, att
end

-- Apply + modify Linear Velocity
function C.AppModLinVel(part, name, max, vel)
	local lv, att = C.AppLinVel(part, name)
	lv.MaxForce = max
	lv.VectorVelocity = vel
	return lv, att
end

-- Apply Angular Velocity
function C.AppAngVel(part, name)
	if not part then return end
	local att = Instance.new("Attachment",part)
	att.Name = name .. "Att"
	local av = Instance.new("AngularVelocity",part)
	av.Name = name .. "AngVel"
	av.Attachment0 = att
	av.MaxTorque = 0
	av.AngularVelocity = Vector3.zero
	return av, att
end

-- Apply + modify Angular Velocity
function C.AppModAngVel(part, name, max, vel)
	local av, att = C.AppAngVel(part, name)
	av.MaxTorque = max
	av.AngularVelocity = vel
	return av, att
end

-- Apply Linear Velocity ONCE
function C.AppOnceLinVel(part, name, max, vel, timo)
	local lv, att = C.AppModLinVel(part, name, max, vel)
	if timo then
		task.wait(timo)
		lv:Destroy()
		att:Destroy()
		lv = nil
		att = nil
	else
		RunService.Heartbeat:Wait()
		lv:Destroy()
		att:Destroy()
		lv = nil
		att = nil
	end
end

-- Apply Angular Velocity ONCE
function C.AppOnceAngVel(part, name, max, vel, timo)
	local av, att = C.AppModAngVel(part, name, max, vel)
	if timo then
		task.wait(timo)
		av:Destroy()
		att:Destroy()
		av = nil
		att = nil
	else
		RunService.Heartbeat:Wait()
		av:Destroy()
		att:Destroy()
		av = nil
		att = nil
	end
end