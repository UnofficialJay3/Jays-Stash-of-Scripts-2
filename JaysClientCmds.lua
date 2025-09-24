-- Scripted by ROBLOX: @IlIl_ILovAltAccsHAHA / ・゠314・一一一非公式ジェイ一一一・・ - Unofficial Jay | GITHUB: @UnofficialJay3

-- Script init
-- Script grabber
local function ScriptGrabber(name, link)
	local scipt = _G[name]
	
	if not scipt then
		local s = pcall(function()
			loadstring(game:HttpGet(link))()
		end)
		if s then
			scipt = _G[name]
		else
			warn("Can't find and get " .. name .. " will now be exitting...")
			return
		end
	end
	
	print("Fetched script " .. name .. "!")
	return scipt
end

local M = ScriptGrabber("JaysMainModule", "https://raw.githubusercontent.com/UnofficialJay3/Jays-Stash-of-Scripts-2/refs/heads/main/JaysMainModule.lua")
local Fly = ScriptGrabber("JaysFlyin", "https://raw.githubusercontent.com/UnofficialJay3/Jays-Stash-of-Scripts-2/refs/heads/main/JaysFlyin.lua")
if not M then return end

-- Add script
local C, sKey = M.AddScript("JaysClientCmds")



-- Configurations
C.Key = "semicolon" -- The key to open the prompter
C.AllowCmdChatting = true -- Allow for commands to be runned in the chat.
C.Prefixes = {";", ":", "!", "/"} -- The prefixes for commands in chat.



-- Main init
-- Services
local Z = M.Services
local UserInputService, RunService, TextChatService, Players = Z.UserInputService, Z.RunService, Z.TextChatService, Z.Players

-- Variables
Z = M.GetLocalCharacter()
local player, char, root, hum = Z.player, Z.char, Z.root, Z.hum
C.Connections = {} -- The connections table
C.Tasks = {} -- The tasks table like task.spawn()
C.Commands = {} -- The table that stores the commands name and the function
local cam = workspace.CurrentCamera

function C.DisconnConn(conn)
	conn:Disconnect()
	conn = nil
end
function C.CancelTask(name)
	local thread = C.Tasks[name]
	if thread and coroutine.status(thread) ~= "dead" then
		task.cancel(thread)
		C.Tasks[name] = nil
	end
end
function C.CreateTask(name, func)
	local thread = coroutine.create(func)
	C.Tasks[name] = thread
	task.spawn(thread)
end

local function Reset()
	Z = M.GetLocalCharacter()
	player, char, root, hum = Z.player, Z.char, Z.root, Z.hum
	
	-- Disconnect stuff
	local Z = C.Connections
	local z = C.Tasks
	if z.Test1 then
		task.cancel(z.Test1)
	end
	if Z.InfJumpConn then
		C.DisconnConn(Z.InfJumpConn)
	end
	if Z.InfJumpReleaseConn then
		C.DisconnConn(Z.InfJumpReleaseConn)
	end
	if Z.CFWConn then
		C.DisconnConn(Z.CFWConn)
	end
end

player.CharacterAdded:Connect(Reset)



-- Did you know that to get to the main lane you gotta 1: Get the JaysMainModule script for utilities, 2: Add the script to _G, 3: Set up the main init and BOOM!



-- Add command function
function C.AddCmd(name, func)
	for _, n in pairs(name) do
		C.Commands[n] = func
	end
end
local AC = C.AddCmd -- Shorter because YEEEESSS!



-- Run command function
function C.RunCmd(name, ...)
	name = name:lower()
	local cmd = C.Commands[name]
	
	if cmd then
		cmd(...)
	end
end



-- Run command with string
function C.RunCmdStr(str)
	local cmd, args = M.GetCmd(str)
	C.RunCmd(cmd, unpack(args))
end



-- Prompter
function C.Prompter()
	local box = M.Prompter("JS - JaysClientCmds")
	task.wait()
	box.FocusLost:Connect(function(ep)
		if ep then
			local text = box.Text:match("^%s*(.-)%s*$")
			C.RunCmdStr(text)
		end
	end)
end



-- Input handler
UserInputService.InputBegan:Connect(function(inp, gp)
	if gp then return end
	inp = inp.KeyCode.Name:lower()
	
	if inp == C.Key then
		C.Prompter()
	end
end)



-- Chat handler
-- Find/Remove prefix
function C.FindRemovePrefix(str)
	for _, pre in ipairs(C.Prefixes) do
		if str:sub(1, #pre) == pre then
			return str:sub(#pre + 1), pre -- returns message without prefix, also returns which prefix matched
		end
	end
	return nil -- no prefix matched
end

-- Check chat version
if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
	TextChatService.OnIncomingMessage = function(message: TextChatMessage)
		if message.TextSource and message.TextSource.UserId == player.UserId then
			-- Only process real chat messages
			if message.Status == Enum.TextChatMessageStatus.Success and message.TextChannel then
				local msg = C.FindRemovePrefix(message.Text)
				if msg then
					C.RunCmdStr(msg)
				end
			end
		end
	end
else
	-- Legacy	
	player.Chatted:Connect(function(str)
		local msg = C.FindRemovePrefix(str)
		if msg then
			C.RunCmdStr(msg)
		end
	end)
end



-- THE COMMANDS AND COMMAND FUNCTIONS YEEEAAAAAAAHHHH!!!



-- Test0 command
AC({"test0"},function(...)
	print("Test 0 successful")
	print(...)
end)


-- Say/message/chat command
AC({"say", "message", "chat", "msg"},function(...)
	local str = table.concat({...}, " ")
	M.ChatMsg(str)
end)


-- Dump _G table
AC({"dump_g", "dumpglobal", "dumpg", "dg"},function()
	M.DumpTable(_G, "_G")
end)


-- Test1 - Testing task and cancelling tasks
AC({"test1"}, function()
	-- cancel if already exists
	if C.Tasks.Test1 then
		C.CancelTask("Test1")
		return
	end

	-- Create task
	C.CreateTask("Test1", function()
		while task.wait(0.1) do
			print("Test1 task running")
		end
	end)
end)


-- Test2 - Testing the LinVelOnce() function
AC({"test2"}, function()
	local lv, att = M.LinVelOnce(root, Vector3.new(0, 100, 0))
end)


-- THE BASIC FAST COMMANDS
-- Speed
C.defaultWalkSpeed = hum.WalkSpeed
AC({"speed"},function(val)
	hum.WalkSpeed = tonumber(val) or C.defaultWalkSpeed
end)

-- Jump
hum.UseJumpPower = true
AC({"jump"},function()
	local currentJumpHeight = hum.JumpPower
	hum.Jump = true
	hum:ChangeState(Enum.HumanoidStateType.Jumping)
	M.LinVelOnce(root, Vector3.new(root.Velocity.X,currentJumpHeight,root.Velocity.Z))
end)

-- Sit
AC({"sit"},function()
	hum.Sit = true
end)

-- Inf jump
C.InfJumpToggle = false
AC({"infjump", "infj"},function()
	-- Check if connection
	if C.Connections.InfJumpConn then
		C.DisconnConn(C.Connections.InfJumpConn)
		C.DisconnConn(C.Connections.InfJumpReleaseConn)
		return
	end
	
	-- Create connection
	C.Connections.InfJumpConn = UserInputService.JumpRequest:Connect(function()
		if C.InfJumpToggle then return end
		C.InfJumpToggle = true
		C.RunCmd("jump")
	end)

	C.Connections.InfJumpReleaseConn = UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space or input.UserInputType == Enum.UserInputType.Touch and input.UserInputState == Enum.UserInputState.End then
			C.InfJumpToggle = false
		end
	end)
end)


-- Basics ended. Now for more basic + 2 and complex commands
-- CFrame walk
AC({"cframewalk", "cfwalk", "cwalk", "cfw", "walk2", "w2"},function(val)
	-- Check for conn
	if C.Connections.CFWConn then
		C.DisconnConn(C.Connections.CFWConn)
		M.AddLinVel(root, true)
		if not val then return end
	end
	
	val = tonumber(val) or 32
	
	local lv = M.AddLinVel(root)
	lv.ForceLimitMode = Enum.ForceLimitMode.PerAxis
	lv.MaxAxesForce = Vector3.new(1,0,1) * 1e10
	
	C.Connections.CFWConn = RunService.Heartbeat:Connect(function(dt)
		-- Cam
		local cf = cam.CFrame
		
		-- Move vector
		local moveVec = M.GetMoveVector(1,0,1)
		
		if moveVec.Magnitude > 0 then
			moveVec = moveVec.Unit
			root.CFrame = root.CFrame + (moveVec * val * dt)
		end

		local pos = root.CFrame.Position
		local look = root.CFrame.LookVector
		-- Force flat (Y only) rotation
		local flatLook = Vector3.new(look.X, 0, look.Z).Unit
		root.CFrame = CFrame.new(pos, pos + flatLook)
	end)
end)


-- Reset collision + massless
AC({"rcm", "resetcm", "resetcollisionmassless"},function()
	print("WHY ISN'T IT WORKING")
	for _, part in ipairs(char:GetDescendants()) do
		if part:IsA("BasePart") or part:IsA("Part") or part:IsA("MeshPart") then
			-- baseline reset
			part.CanCollide = false
			part.Massless = false

			-- handle accessories
			local acc = part.Parent
			if acc:IsA("Accessory") and part.Name == "Handle" then
				part.Massless = true
				part.CanCollide = false -- stays false anyway
			end

			-- special collision parts
			if part.Name == "Head"
				or part.Name == "Torso"
				or part.Name == "UpperTorso"
				or part.Name == "LowerTorso" then
				part.CanCollide = true
			end
		end
	end
end)


-- Noclip
C.Connections.NoclipConn = nil
AC({"noclip"},function(state)
	-- Checker
	if C.Connections.NoclipConn then
		C.DisconnConn(C.Connections.NoclipConn)
		
		-- Reset collision + massless
		C.RunCmd("rcm")
		return
	end
	
	if C.Connections.NoclipConn then
		C.DisconnConn(C.Connections.NoclipConn)
	end
	
	-- Create connection
	C.Connections.NoclipConn = RunService.Stepped:Connect(function()
		for _, v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") or v:IsA("Part") then
				v.CanCollide = false
			end
		end
	end)
end)


-- Fly, unfly, cfly, sfly, ffly
C.defaultFlySpeed = 50

AC({"fly"},function(val)
	if val then
		C.defaultFlySpeed = val
		Fly.UpdateSettings({
			cf = false,
			plat = true,
			anim = true,
			speed = tonumber(val) or C.defaultFlySpeed
		})
	else
		Fly.UpdateSettings({
			cf = false,
			speed = C.defaultFlySpeed
		})
	end
	
	Fly.Connect()
end)

AC({"unfly"},function()
	Fly.Disconnect()
end)

AC({"cfly", "cffly", "cframefly"},function(val) -- CFrame fly
	C.RunCmd("fly", val)
	Fly.UpdateSettings({
		cf = false
	})
end)

AC({"sfly", "sitfly", "fly2"},function(val) -- Sit fly
	C.RunCmd("fly", val)
	Fly.UpdateSettings({
		plat = false,
		anim = false
	})
	
	-- Make it sit
	C.RunCmd("sit")
end)

local flingflyatt = nil
local flingflyav = nil
C.Connections.FlingFlyConn = nil
AC({"ffly", "fling", "flingfly"},function(val, intensity) -- Fling fly
	C.RunCmd("fly", val)
	Fly.UpdateSettings({
		cf = true,
		plat = true,
		camrot = false,
		ang = false,
		anim = false,
	})
	
	if C.Connections.FlingFlyConn then
		C.Connections.FlingFlyConn:Disconnect()
		flingflyav:Destroy()
		flingflyatt:Destroy()
		flingflyav = nil
		flingflyatt = nil
	end
	
	-- The actual flinging
	-- Set up av
	if not flingflyav or not flingflyatt then
		flingflyatt = Instance.new("Attachment",root)
		flingflyav = Instance.new("AngularVelocity",root)
		flingflyav.Attachment0 = flingflyatt
		flingflyav.MaxTorque = math.huge
		flingflyav.Name = "fuck"
		if not intensity then
			intensity = 1e31 -- Why do I have to do this? Also 1e31 is a safe value.
			-- 1e36 is the highest to go, more further and the physics breaks! In studio I guess.
		end
		flingflyav.AngularVelocity = Vector3.one * intensity --intensity or 1e31
	end
	cam.CameraSubject = root
	C.RunCmd("noclip")
	
	-- Set up connection
	C.Connections.FlingFlyConn = RunService.Stepped:Connect(function()
		for _, v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") or v:IsA("Part") then
				if v.Name == "HumanoidRootPart" then continue end
				v.CanCollide = false
				v.Massless = true
			end
		end
	end)
end)

AC({"unffly", "unflingfly"},function() -- Stop flinging
	-- Disconnect
	if C.Connections.FlingFlyConn then
		C.DisconnConn(C.Connections.FlingFlyConn)
	end
	
	
	-- Calm it down
	flingflyav.AngularVelocity = Vector3.zero
	task.wait(0.1)
	
	-- Init unflingfly
	flingflyav:Destroy()
	flingflyatt:Destroy()
	flingflyav = nil
	flingflyatt = nil
	C.RunCmd("noclip")
	C.RunCmd("rcm")
	Fly.Disconnect()
	cam.CameraSubject = hum
	
	--task.spawn(function()
	--	while task.wait(0.1) do
	--		C.RunCmd("rcm")
	--	end
	--end)

end)
