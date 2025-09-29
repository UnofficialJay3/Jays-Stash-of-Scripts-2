-- Scripted by ROBLOX: @IlIl_ILovAltAccsHAHA / ・゠314・一一一非公式ジェイ一一一・・ - Unofficial Jay | GITHUB: @UnofficialJay3
-- This script is highly unstable since this is tested ONLY in studio, sometimes with real clients.

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

local M = ScriptGrabber("JaysMainModule", "https://github.com/UnofficialJay3/Jays-Stash-of-Scripts-2/raw/refs/heads/main/JaysMainModule.lua")
local Fly = ScriptGrabber("JaysFlyin", "https://github.com/UnofficialJay3/Jays-Stash-of-Scripts-2/raw/refs/heads/main/JaysFlyin.lua")
if not M then return end

-- Add script
local C, sKey = M.AddScript("JaysClientCmds")



-- Configurations
C.Key = "semicolon" -- The key to open the prompter
C.AllowCmdChatting = true -- Allow for commands to be runned in the chat.
C.Prefixes = {";", ":", "!", "/"} -- The prefixes for commands in chat.
local PrintCmds = false -- Prints all the commands and also how many commands are there



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

function C.Disconnect(conn)
	if typeof(conn) == "string" then
		local c = C.Connections[conn]
		if c then
			c:Disconnect()
			C.Connections[conn] = nil
		end
		return
	end
	if conn then
		conn:Disconnect()
	end
end
function C.CancelTask(taskOrName)
	local thread

	if typeof(taskOrName) == "string" then
		thread = C.Tasks[taskOrName]
		if thread then
			C.Tasks[taskOrName] = nil
		end
	elseif typeof(taskOrName) == "thread" then
		thread = taskOrName
		for name, t in pairs(C.Tasks) do
			if t == thread then
				C.Tasks[name] = nil
				break
			end
		end
	end

	-- If we got a valid thread, cancel it
	if thread and coroutine.status(thread) ~= "dead" then
		task.cancel(thread)
	end
end

function C.CreateTask(name, func)
	local thread = coroutine.create(func)
	C.Tasks[name] = thread
	task.spawn(thread)
end

-- Reset-tation   
local function Reset2()
	-- Disconnect stuff
	local Z = C.Connections
	local z = C.Tasks

	local function AttemptDisconnect(n)
		pcall(function()
			C.Disconnect(Z[n])
		end)
	end
	local function AttemptCancellation(n)
		pcall(function()
			C.CancelTask(z[n])
		end)
	end

	AttemptCancellation("Test2")
	AttemptDisconnect("Noclip")
	AttemptDisconnect("GeneralFling")
	AttemptDisconnect("CFrameWalk")
	AttemptDisconnect("Respawnation")
	AttemptCancellation("FlingPlayer")
	AttemptDisconnect("TempLoopTo")
	AttemptDisconnect("IntenseSpin")
	AttemptDisconnect("Infjump1")
	AttemptDisconnect("Infjump2")
	AttemptDisconnect("LoopTo")
	AttemptDisconnect("TempLoopTo")
	AttemptDisconnect("Respawnation")
	AttemptDisconnect("Invisible")
	AttemptDisconnect("WalkFling")
	AttemptDisconnect("Invisible")
	AttemptDisconnect("IntenseSpin")

	-- AttemptDisconnect("Connection")
end
local function Reset()
	Z = M.GetLocalCharacter()
	player, char, root, hum = Z.player, Z.char, Z.root, Z.hum
	
	hum.Died:Connect(Reset2)
end

player.CharacterAdded:Connect(Reset)
hum.Died:Connect(Reset2)



-- Did you know that to get to the main lane you gotta 1: Get the JaysMainModule script for utilities, 2: Add the script to _G, 3: Set up the main init and BOOM!



-- Add command function
function C.AddCmd(name, func)
	for _, n in pairs(name) do
		C.Commands[n] = func
	end
	if PrintCmds then
		local function DictCount(dict)
			local c = 0
			for _ in pairs(dict) do
				c += 1
			end
			return c
		end
		print("Added command:", table.concat(name, ", "), "| Cmd counter:", DictCount(C.Commands))
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



AC({"test"},function()
	print("This is a test!")
end)


C.Tasks.Test2 = nil
AC({"test2"},function()
	local t = C.Tasks.Test2
	if t then
		C.CancelTask(t)
		print("Test2 stopped")
		return
	end
	
	print("Test2 started")
	
	C.CreateTask("Test2",function()
		while task.wait(0.1) do
			print("Test2 is running!")
		end
	end)
end)


-- Speed
C.DefaultSpeed = hum.WalkSpeed
AC({"speed"},function(speed)
	--C.SetSpeed(speed) this ai keeps coming up with random functions. THESE FUNCTIONS DON'T EXIST YET!!!
	hum.WalkSpeed = speed or C.DefaultSpeed
end)


-- Jump
C.DefaultJumpPower = hum.JumpPower
AC({"jump"},function(power)
	-- AppOnceLinVel(part, name, max, vel, timo) reference
	hum.Jump = true
	hum:ChangeState(Enum.HumanoidStateType.Jumping)
	M.AppOnceLinVel(root, "Jump", math.huge, Vector3.new(root.Velocity.X,power or C.DefaultJumpPower,root.Velocity.Z))
end)


-- Sit
AC({"sit"},function()
	hum.Sit = true -- As easy as that.
end)


-- Table of contents for restoring collisions and massless values:
--[[
R6
Head: C true M false
Root: C false M false
Left Arm: C false M false
Left Leg: C false M false
Right Arm: C false M false
Right Leg: C false M false
Torso: C true M false
Root: C false M false

R15
Same for limbs, upper + lower torso have C true M false
Root: C true M false I don't know why this changed.


Universal:
Accessories:
C false M false

]]

-- Restore Collisions + Massless
AC({"restorecollisionmassless", "rcm"},function()
	if C.Connections.Noclip then
		C.Disconnect("Noclip")
	end
	
	for _, v in pairs(char:GetDescendants()) do
		if not v:IsA("BasePart") and not v:IsA("Part") and not v:IsA("MeshPart") then continue end
		-- Reset
		v.CanCollide = false
		v.Massless = false
		
		-- Head
		if v.Name == "Head" then
			v.CanCollide = true
		end
		
		-- Torso
		if v.Name == "Torso" or v.Name == "UpperTorso" or v.Name == "LowerTorso" then
			v.CanCollide = true
		end
		
		-- Root
		if v.Name == "HumanoidRootPart" then
			if hum.RigType == Enum.HumanoidRigType.R15 then
				v.CanCollide = true
			else
				v.CanCollide = false
			end
		end
	end
end)
C.RCMChar = function(charlo)
	for _, v in pairs(charlo:GetDescendants()) do
		if not v:IsA("BasePart") and not v:IsA("Part") and not v:IsA("MeshPart") then continue end
		-- Reset
		v.CanCollide = false
		v.Massless = false

		-- Head
		if v.Name == "Head" then
			v.CanCollide = true
		end

		-- Torso
		if v.Name == "Torso" or v.Name == "UpperTorso" or v.Name == "LowerTorso" then
			v.CanCollide = true
		end

		-- Root
		if v.Name == "HumanoidRootPart" then
			if hum.RigType == Enum.HumanoidRigType.R15 then
				v.CanCollide = true
			else
				v.CanCollide = false
			end
		end
	end
end


-- Noclip/clip
AC({"noclip"},function()
	C.Disconnect("Noclip")
	
	C.Connections.Noclip = RunService.Stepped:Connect(function()
		for _, v in pairs(char:GetDescendants()) do
			if not v:IsA("BasePart") and not v:IsA("Part") and not v:IsA("MeshPart") then continue end
			v.CanCollide = false
		end
	end)
end)
C.NoclipChar = function(charlo)
	C.Disconnect("Noclip")

	C.Connections.Noclip = RunService.Stepped:Connect(function()
		for _, v in pairs(charlo:GetDescendants()) do
			if not v:IsA("BasePart") and not v:IsA("Part") and not v:IsA("MeshPart") then continue end
			v.CanCollide = false
		end
	end)
end

AC({"clip"},function()
	-- Turn off connection
	C.Disconnect("Noclip")
	
	-- Use RCM to restore collisions
	C.RunCmd("rcm")
end)
C.ClipChar = function(charlo)
	C.Disconnect("Noclip")
	C.RCMChar(charlo)
end


-- General fling/stop gfling
local flingvel = nil
local flingatt = nil
AC({"generalfling","gfling"},function(intensity)
	C.Disconnect("GeneralFling")
	intensity = intensity or 1e31
	
	if flingvel then flingvel:Destroy() flingvel = nil end
	if flingatt then flingatt:Destroy() flingatt = nil end
	
	if not C.Connections.CFrameWalk then
		cam.CameraSubject = root
	end
	

	flingvel, flingatt = M.AppModAngVel(root, "GeneralFling", math.huge, Vector3.one*intensity)
	-- AppModAngVel(part, name, max, vel) Reference
	C.Connections.GeneralFling = RunService.Stepped:Connect(function()
		for _, v in pairs(char:GetDescendants()) do
			if not v:IsA("BasePart") and not v:IsA("Part") and not v:IsA("MeshPart") then continue end
			v.CanCollide = false
			v.Massless = true
		end
	end)
end)

AC({"ungeneralfling","ungfling"},function()
	root.Anchored = true
	C.Disconnect("GeneralFling")
	flingvel.AngularVelocity = Vector3.zero
	cam.CameraSubject = hum
	root.Velocity = Vector3.zero
	root.AssemblyAngularVelocity = Vector3.zero
	task.wait(0.1)
	root.Anchored = false
	flingvel:Destroy()
	flingatt:Destroy()
	flingvel = nil
	flingatt = nil
	C.RunCmd("rcm")
end)


-- Fly, unfly, sfly/fly2, cfly, ffly
-- Regular fly/unfly
C.DefaultFlySpeed = 50
AC({"fly"},function(speedo)
	if speedo then C.DefaultFlySpeed = speedo end
	Fly.UpdateSettings({
		speed = speedo or C.DefaultFlySpeed,
		cf = false
	})

	Fly.Connect()
end)

-- Unfly
AC({"unfly"},function()
	if C.Connections.GeneralFling then
		C.RunCmd("ungfling")
		task.wait(0.1)
		Fly.Disconnect()
	else
		Fly.Disconnect()
	end
end)

-- Sit fly
AC({"sfly","fly2","sitfly"},function(speedo)
	if speedo then C.DefaultFlySpeed = speedo end
	Fly.UpdateSettings({
		speed = speedo or C.DefaultFlySpeed,
		cf = false,
		plat = false -- So you can sit
	})

	Fly.Connect()
end)

-- Cframe fly
AC({"cfly","cframefly"},function(speedo)
	if speedo then C.DefaultFlySpeed = speedo end
	Fly.UpdateSettings({
		speed = speedo or C.DefaultFlySpeed,
		cf = true
	})
	
	Fly.Connect()
end)

-- Fling fly
AC({"ffly","flingfly"},function(speedo, intensity)
	if speedo then C.DefaultFlySpeed = speedo end
	Fly.UpdateSettings({
		speed = speedo or C.DefaultFlySpeed,
		cf = true,
		anim = false,
		plat = true,
		ang = false,
		camrot = false
	})
	
	Fly.Connect()
	
	C.RunCmd("gfling", intensity)
end)


-- CFrame walk
C.DefaultCFWalkSpeed = 32
C.TempDefaultWalkSpeed = 0
AC({"cfwalk","cframewalk","cfw"}, function(speedo)
	if speedo then C.DefaultCFWalkSpeed = speedo end
	C.TempDefaultWalkSpeed = hum.WalkSpeed
	hum.WalkSpeed = 0
	C.Disconnect("CFrameWalk")

	C.Connections.CFrameWalk = RunService.Heartbeat:Connect(function(dt)
		local moveVec = M.GetMoveVector(1,0,1)
		if moveVec.Magnitude > 0 then
			local finalPos = root.Position + moveVec * C.DefaultCFWalkSpeed * dt
			root.CFrame = CFrame.new(finalPos) * (root.CFrame - root.CFrame.Position)
		end
		
		-- Horizontal snap
		local pos = root.Position
		local look = root.CFrame.LookVector
		local flatDir = Vector3.new(look.X, 0, look.Z)
		if flatDir.Magnitude > 0 then
			flatDir = flatDir.Unit
			root.CFrame = CFrame.new(pos, pos + flatDir)
		end
	end)
end)

-- UnCFrame walk
AC({"uncfwalk","uncframewalk","uncfw", "ucfw"}, function()
	C.Disconnect("CFrameWalk")
	hum.WalkSpeed = C.TempDefaultWalkSpeed
end)


-- Respawn
AC({"respawn","re"},function()
	local h = char:FindFirstChild("Head")
	if h then h:Destroy() end
	hum.Health = -math.huge
end)


-- Respawn position
AC({"respawnpos","rpos","rp","repos", "rep"},function()
	local pos = root.Position
	C.RunCmd("re")
	C.Connections.Respawnation = player.CharacterAdded:Connect(function()
		RunService.Heartbeat:Wait()
		root.CFrame = CFrame.new(pos)
		C.Disconnect("Respawnation")
	end)
end)


-- fcfw - fling cframe walk
AC({"fcfw","flingcframewalk"}, function(speedo, intensity)
	C.RunCmd("cfw", speedo)
	C.RunCmd("gfling", intensity)
end)

-- unfcfw - unfling cframe walk
AC({"unfcfw","unflingcframewalk", "ufcfw"}, function()
	C.RunCmd("ungfling")
	task.wait(0.1)
	C.RunCmd("uncfw")
end)


-- Spin
local spinatt = nil
local spinvel = nil
C.DefaultSpinSpeed = 15
AC({"spin"}, function(speedo)
	if speedo then C.DefaultSpinSpeed = speedo end
	speedo = tonumber(speedo) or C.DefaultSpinSpeed
	if spinvel then spinvel:Destroy() spinvel = nil end
	if spinatt then spinatt:Destroy() spinatt = nil end
	
	spinvel, spinatt = M.AppModAngVel(root, "Spinnin", math.huge, Vector3.yAxis * C.DefaultSpinSpeed)
end)

-- UnSpin
AC({"unspin"}, function()
	spinvel:Destroy()
	spinatt:Destroy()
	spinvel = nil
	spinatt = nil
end)


-- view/spectate
AC({"view","spectate","watch"}, function(plr)
	if not plr then
		cam.CameraSubject = hum
		return
	end
	
	local target = M.GetPlayerByType(player, plr)
	if target[2] then return end
	target = target[1]
	cam.CameraSubject = M.GetCharacter(target).hum
end)

AC({"unview", "unspectate", "unwatch"},function()
	cam.CameraSubject = hum
end)


-- To
AC({"to"},function(target)
	if not target then return end
	target = M.GetPlayerByType(player, target)
	if target[2] then return end
	target = target[1]
	--local targetroot = M.GetRoot(target) THERE IS NO GETROOT IN MAIN MODULE!!!
	local rootB = M.GetCharacter(target).root
	root.CFrame = CFrame.new(rootB.Position) * (root.CFrame - root.CFrame.Position)
end)



AC({"fling","flingperson","flingplayer"}, function(target, timo, predict) -- new new! Prediction stuff by chatgpt gluh.
	if not target then return end
	local pos = root.Position
	target = M.GetPlayerByType(player, target)

	C.RunCmd("ffly")

	task.spawn(function()
		for _, v in pairs(target) do
			if v == player then continue end

			local targetRoot = v.Character and v.Character:FindFirstChild("HumanoidRootPart")
			if not targetRoot then continue end

			-- how much prediction time to add (tweak this)
			local predictionTime = tonumber(predict) or 0.43 -- I'll be honest I don't know if this prediction thing would work.
			-- Note2 I think it works welly I guess...?

			C.Connections.TempLoopTo = RunService.Heartbeat:Connect(function()
				if not targetRoot.Parent then return end

				-- predict where they’ll be
				local predicted = targetRoot.Position + targetRoot.AssemblyLinearVelocity * predictionTime
				local predictedCF = CFrame.new(predicted, predicted + targetRoot.CFrame.LookVector)

				-- lock onto that spot
				root.CFrame = predictedCF
			end)

			task.wait(tonumber(timo) or 1.5)
			C.Disconnect("TempLoopTo")
		end
		
		C.RunCmd("unfly")
		-- meh
		root.CFrame = CFrame.new(pos)
	end)
end)



-- Loop to (Yes I literally made this after I really needed to use.)
AC({"loopto", "lto", "lt"},function(target)
	if not target then return end
	target = M.GetPlayerByType(player, target)
	if target[2] then return end
	target = target[1]
	
	C.Connections.LoopTo = RunService.Heartbeat:Connect(function()
		C.RunCmd("to", target.Name)
	end)
end)

AC({"unloopto","unlto","ulto","unlt","ult"},function()
	C.Disconnect("LoopTo")
end)


-- Infinite jump
AC({"infinitejump","infjump","infj"},function()
	C.Disconnect("Infjump1")
	C.Disconnect("Infjump2")

	local debounce = false

	-- When jump is requested (works for space & mobile tap)
	C.Connections.Infjump1 = UserInputService.JumpRequest:Connect(function()
		if debounce then return end
		debounce = true
		C.RunCmd("jump")
	end)

	-- When the jump input is released (spacebar or mobile lift)
	C.Connections.Infjump2 = UserInputService.InputEnded:Connect(function(input, gpe)
		if gpe then return end
		if input.KeyCode == Enum.KeyCode.Space or input.UserInputType == Enum.UserInputType.Touch then
			debounce = false
		end
	end)
end)


-- Intense spin - Turns on massless for all limbs except for your root. This allows you to not get flinged by your center of mass.
AC({"intensespin","ispin"},function(speedo)
	speedo = tonumber(speedo) or 1e5
	C.Disconnect("IntenseSpin")
	
	C.Connections.IntenseSpin = RunService.Stepped:Connect(function()
		for _, v in pairs(char:GetDescendants()) do
			if not v:IsA("BasePart") and not v:IsA("Part") and not v:IsA("MeshPart") then continue end
			v.CanCollide = false
			v.Massless = true
		end
	end)
	
	C.RunCmd("spin", speedo)
end)

AC({"unintensespin","unispin","unisp","uispin"},function()
	C.Disconnect("IntenseSpin")
end)


-- Dump global table
AC({"dumpglobaltable","dumpg","dg","dump"},function()
	M.DumpTable(_G, "_G")
end)


-- Fake character
local storedTransparencies = {}
local realChar = player.Character or player.CharacterAdded:Wait()
local fakeChar = nil
AC({"fakecharacter","fakechar","faker"},function()
	char.Archivable = true -- So you can CLONE!
	realChar = player.Character or player.CharacterAdded:Wait()
	fakeChar = char:Clone()
	fakeChar.Parent = workspace
	fakeChar.Name = "FakeChar"
	
	-- Remove useless stuff
	for _, obj in ipairs(fakeChar:GetChildren()) do
		if not obj:IsA("Humanoid") 
			and not obj:IsA("Part") 
			and not obj:IsA("MeshPart") 
			and obj.Name ~= "HumanoidRootPart" then
			obj:Destroy()
		end
	end
	
	local fakeRoot = fakeChar:FindFirstChild("HumanoidRootPart")
	fakeRoot.CFrame = root.CFrame
	
	-- Transparency
	for _, part in ipairs(char:GetDescendants()) do
		if part:IsA("BasePart") or part:IsA("Decal") then
			if not storedTransparencies[part] then
				storedTransparencies[part] = part.Transparency
			end
			part.Transparency = 0.75
		end
	end
	
	-- Restore transp
	--[[
	for part, oldValue in pairs(storedTransparencies) do
		if part and part.Parent then
			part.Transparency = oldValue
		end
	end
	storedTransparencies = {}
	]]
	
	player.Character = fakeChar
	cam.CameraSubject = fakeChar:WaitForChild("Humanoid")
	
	C.NoclipChar(realChar)
end)

AC({"unfakecharacter","unfakechar","unfaker"},function()
	player.Character = realChar
	cam.CameraSubject = realChar:WaitForChild("Humanoid")
	C.ClipChar(realChar)
	
	for part, oldValue in pairs(storedTransparencies) do
		if part and part.Parent then
			part.Transparency = oldValue
		end
	end
	storedTransparencies = {}
	
	realChar.HumanoidRootPart.CFrame = fakeChar.HumanoidRootPart.CFrame
	
	fakeChar:Destroy()
end)


-- Invisible | The best and worst programmer ME >B)
AC({"invisible","invis"},function()
	C.Disconnect("Invisible")
	--C.RunCmd("unfaker")
	local cf = realChar:FindFirstChild("HumanoidRootPart").CFrame

	realChar:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(Vector3.one*1e3)
	
	task.wait(0.1)
	
	realChar:FindFirstChild("HumanoidRootPart").Anchored = true -- I keep ignoring this.
	print("INVISIBLE COMMAND IS VERY BUGGY!!! USE AT YOUR OWN RISK HERE BUDDY!")
	
	C.RunCmd("faker")
	
	fakeChar:WaitForChild("HumanoidRootPart").CFrame = cf
	
	
	for _, v in pairs(fakeChar:WaitForChild("HumanoidRootPart"):GetChildren()) do
		if not v:IsA("LinearVelocity") and not v:IsA("AngularVelocity") then continue end
		v:Destroy()
	end
	
	fakeChar:FindFirstChild("HumanoidRootPart").Anchored = false
end)

AC({"visible","vis"},function()
	C.Disconnect("Invisible")
	C.RunCmd("unfaker")
	realChar:FindFirstChild("HumanoidRootPart").Anchored = false
end)


-- Walkfling
local wflingatt
local wflinglv
local wflingav
AC({"walkfling","wfling"},function(intensity)
	C.RunCmd("af")
	C.Disconnect("WalkFling")
	C.RunCmd("faker")
	C.NoclipChar(realChar)
	C.NoclipChar(fakeChar)
	
	wflingatt = Instance.new("Attachment",realChar:FindFirstChild("HumanoidRootPart"))
	wflinglv = Instance.new("LinearVelocity",realChar:FindFirstChild("HumanoidRootPart"))
	wflingav = Instance.new("AngularVelocity",realChar:FindFirstChild("HumanoidRootPart"))

	wflinglv.Attachment0 = wflingatt
	wflingav.Attachment0 = wflingatt

	wflinglv.MaxForce = math.huge
	wflinglv.VectorVelocity = Vector3.zero

	wflingav.MaxTorque = math.huge
	wflingav.AngularVelocity = Vector3.one*(intensity or 1e35)
	
	C.Connections.WalkFling = RunService.Stepped:Connect(function()
		local rooto = realChar:FindFirstChild("HumanoidRootPart")
		rooto.AssemblyLinearVelocity = Vector3.zero
		rooto.CFrame = CFrame.new(fakeChar.HumanoidRootPart.CFrame.Position) * (rooto.CFrame - rooto.CFrame.Position)
		for _, v in pairs(realChar:GetDescendants()) do
			if v:IsA("BasePart") or v:IsA("Part") or v:IsA("MeshPart") then
				v.CanCollide = false
				v.Massless = true
			end
		end
	end)
end)

AC({"unwalkfling","unwfling","uwfling"},function()
	C.RunCmd("uaf")
	C.Disconnect("WalkFling")
	wflingav.AngularVelocity = Vector3.zero
	wflinglv.VectorVelocity = Vector3.zero
	task.wait(0.1)
	C.ClipChar(realChar)
	C.RunCmd("unfaker")
	wflingatt:Destroy()
	wflinglv:Destroy()
	wflingav:Destroy()
	wflingatt = nil
	wflinglv = nil
	wflingav = nil
end)


AC({"disconnectconnections","disconns"},function()
	local Z = C.Connections
	local z = C.Tasks
	
	local function AttemptDisconnect(n)
		pcall(function()
			C.Disconnect(Z[n])
		end)
	end
	local function AttemptCancellation(n)
		pcall(function()
			C.CancelTask(z[n])
		end)
	end

	AttemptCancellation("Test2")
	AttemptDisconnect("Noclip")
	AttemptDisconnect("GeneralFling")
	AttemptDisconnect("CFrameWalk")
	AttemptDisconnect("Respawnation")
	AttemptCancellation("FlingPlayer")
	AttemptDisconnect("TempLoopTo")
	AttemptDisconnect("IntenseSpin")
	AttemptDisconnect("Infjump1")
	AttemptDisconnect("Infjump2")
	AttemptDisconnect("LoopTo")
	AttemptDisconnect("TempLoopTo")
	AttemptDisconnect("Respawnation")
	AttemptDisconnect("Invisible")
	AttemptDisconnect("WalkFling")
	AttemptDisconnect("Invisible")
	AttemptDisconnect("IntenseSpin")
end)


-- Print commands
AC({"printcmds","pcmds","cmds","viewcmds"},function()
	print("JS - JaysClientCmds - LIST OF COMMANDS:")
	for name, func in pairs(C.Commands) do
		print("Cmd",name,"|",func)
	end
end)


-- JUMPSCARE! - Have invis on
AC({"jumpscare","js"},function()
	C.RunCmd("vis")
	task.wait(0.5)
	C.RunCmd("invis")
end)


-- Test anti-fling
AC({"testantifling"},function()
	local cf = root.CFrame
	local lv, att = M.AppModLinVel(root, "TestFling", math.huge, Vector3.zero)
	
	C.Connections.TestAntiFling = RunService.Stepped:Connect(function()
		root.CFrame = cf
		root.AssemblyLinearVelocity = Vector3.zero
		
		for _, v in pairs(char:GetDescendants()) do
			if not v:IsA("BasePart") and not v:IsA("Part") and not v:IsA("MeshPart") then continue end
			v.CanCollide = false
			v.Massless = true
		end
	end)
end)


-- Test anti-fling 2
AC({"testantifling2"},function()
	root.Anchored = true -- Hmmm
end)


-- Antifling
AC({"antifling","noplrcollisions","npc","af"},function()
	if C.Connections.AntiFling then
		C.Disconnect("AntiFling")
	end
	
	C.Connections.AntiFling = RunService.Stepped:Connect(function()
		for _, v in pairs(Players:GetPlayers()) do
			if v == Players.LocalPlayer then continue end
			local charlo = v.character
			if not charlo then continue end
			for _, v in pairs(charlo:GetDescendants()) do
				if not v:IsA("BasePart") and not v:IsA("Part") and not v:IsA("MeshPart") then continue end
				v.CanCollide = false
			end
		end
	end)
end)


-- Unantifling
AC({"unantifling","uantifling","uaf","plrcollisions","pc"},function()
	if C.Connections.AntiFling then
		C.Disconnect("AntiFling")
	end
	
	for _, v in pairs(Players:GetPlayers()) do
		if v == Players.LocalPlayer then continue end
		local charlo = v.character
		if not charlo then continue end
		C.ClipChar(charlo)
	end
end)



-- TEST To direction
AC({"ttd","ttod","ttodirection"}, function(dir, offset, index)
	local part = workspace.PEAK
	local basePos = part.Position
	local distance = (offset or 4) * (index or 1)

	-- Get direction vector relative to part
	local dir = string.lower(dir or "f")
	local vec
	if dir == "f" or dir == "forward" then
		vec = part.CFrame.LookVector
	elseif dir == "b" or dir == "backward" then
		vec = -part.CFrame.LookVector
	elseif dir == "r" or dir == "right" then
		vec = part.CFrame.RightVector
	elseif dir == "l" or dir == "left" then
		vec = -part.CFrame.RightVector
	elseif dir == "u" or dir == "up" then
		vec = part.CFrame.UpVector
	elseif dir == "d" or dir == "down" then
		vec = -part.CFrame.UpVector
	else
		vec = part.CFrame.LookVector -- default forward
	end

	-- Offset relative to rotation
	local targetPos = basePos + (vec * distance)

	root.CFrame = CFrame.new(targetPos, targetPos + part.CFrame.LookVector)
end)


-- REAL to direction
AC({"td","tod","todirection"}, function(target, dir, offset, index)
	if not target then return end
	target = M.GetPlayerByType(player, target)
	if target[2] then return end
	target = target[1]
	target = target.Character or target.CharacterAdded:Wait()
	local rootB = target:WaitForChild("HumanoidRootPart")
	if not rootB then return end
	
	local part = rootB
	local basePos = part.Position
	local distance = (offset or 4) * (index or 1)

	-- Get direction vector relative to part
	local dir = string.lower(dir or "f")
	local vec
	if dir == "f" or dir == "forward" then
		vec = part.CFrame.LookVector
	elseif dir == "b" or dir == "backward" then
		vec = -part.CFrame.LookVector
	elseif dir == "r" or dir == "right" then
		vec = part.CFrame.RightVector
	elseif dir == "l" or dir == "left" then
		vec = -part.CFrame.RightVector
	elseif dir == "u" or dir == "up" then
		vec = part.CFrame.UpVector
	elseif dir == "d" or dir == "down" then
		vec = -part.CFrame.UpVector
	else
		vec = part.CFrame.LookVector -- default forward
	end

	-- Offset relative to rotation
	local targetPos = basePos + (vec * distance)

	root.CFrame = CFrame.new(targetPos, targetPos + part.CFrame.LookVector)
end)


-- Loop to direction
local LTDLV = nil
local LTDATT = nil
AC({"ltd","ltod","ltodirection"},function(target,dir,offset,index)
	if C.Connections.LoopToDirection then
		C.Disconnect("LoopToDirection")
		pcall(function()
			LTDLV:Destroy()
			LTDLV = nil
			LTDATT:Destroy()
			LTDATT = nil
		end)
	end
	
	LTDLV, LTDATT = M.AppModLinVel(root, "LTD", math.huge, Vector3.zero)

	C.Connections.LoopToDirection = RunService.Heartbeat:Connect(function()
		local cmdStr = string.format("td %s %s %s %s", target or "", dir or "f", offset or "4", index or "1")
		C.RunCmdStr(cmdStr)
	end)
end)



-- Unloop to direction
AC({"ultd","ultod","ultodirection"},function()
	C.Disconnect("LoopToDirection")
	pcall(function()
		LTDLV:Destroy()
		LTDLV = nil
		LTDATT:Destroy()
		LTDATT = nil
	end)
end)


-- Dances system -- If it looks ai-ed then it is because I am too lazy to search for the dances.
local DanceTracks = {} -- store current tracks

-- Animation IDs for R6 and R15
local Dances = {
	R6 = {
		[1] = 182435998,   -- dance1 R6
		[2] = 182436842,   -- dance2 R6
		[3] = 182436935,   -- dance3 R6
	},
	R15 = {
		[1] = 507771019,   -- dance1 R15
		[2] = 507776043,   -- dance2 R15
		[3] = 507777268,   -- dance3 R15
	},
}

-- Helper to get humanoid + rig type
local function GetHumanoidAndRig()
	local char = player.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	local rig = hum.RigType == Enum.HumanoidRigType.R15 and "R15" or "R6"
	return hum, rig
end

-- Play dance
local function PlayDance(i)
	local hum, rig = GetHumanoidAndRig()
	if not hum then return end

	-- stop current if one is playing
	if DanceTracks[hum] then
		DanceTracks[hum]:Stop()
		DanceTracks[hum] = nil
	end

	local animId = Dances[rig][i]
	if not animId then return end

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://" .. animId

	local track = hum:LoadAnimation(anim)
	track.Priority = Enum.AnimationPriority.Action
	track.Looped = true
	track:Play()

	DanceTracks[hum] = track
end

-- Stop dance
local function StopDance()
	local hum, _ = GetHumanoidAndRig()
	if not hum then return end
	if DanceTracks[hum] then
		DanceTracks[hum]:Stop()
		DanceTracks[hum] = nil
	end
end

-- Commands
AC({"d1","dance1"}, function() PlayDance(1) end)
AC({"d2","dance2"}, function() PlayDance(2) end)
AC({"d3","dance3"}, function() PlayDance(3) end)
AC({"und","undance"}, function() StopDance() end)