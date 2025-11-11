-- Script init
local Z
-- Get module
local function GetModule(name,url)
	local m = _G[name]
	if not m then
		warn("	Failed from direct.")
		local s,r = pcall(function()
			loadstring(game:HttpGet(url))()
		end)
		if s then
			m = _G[name]
			return m
		else
			warn("	Failed from url:",r)
			return
		end
	end
	return m
end
local UniService = GetModule("JaysUniService","https://github.com/UnofficialJay3/Jays-Stash-of-Scripts-2/raw/refs/heads/main/JaysUniService.lua")
local FlyService = GetModule("JaysFlyinService","https://github.com/UnofficialJay3/Jays-Stash-of-Scripts-2/raw/refs/heads/main/JaysFlyinService.lua")
--Self init
local ModuleName = "JaysClientCmds"
local M = {}
_G[ModuleName] = M
UniService.InitModule(M,ModuleName)
local Conns = M.Tasks
local Tasks = M.Conns
local Configs = M.Configs



-- Configuration
M.Keybind = "Semicolon" -- Needs capilization pls
M.OldSchool = true -- The "Old school" way of the bar.
M.Debugwebug = false -- Gotta debug what's a webug!
M.EmoteOnCmd = true -- If no other command works than try to use it as a emote I guess.
M.ChatPrefixes = {";",":","!",".","/"}
M.AllowNoChatPrefix = false -- If true, then the player can use commands without the prefixes in ChatPrefixes.



-- Main init
-- Services
--[[Z = UniService.Services]]
local CAS, RunService, UIS, Players, Lighting = -- Just so that I can get the.
	game:GetService("ContextActionService"),
	game:GetService("RunService"),
	game:GetService("UserInputService"),
	game:GetService("Players"),
	game:GetService("Lighting")

-- Variables
local player, plrgui, char, hum, root = UniService.GetChar(game.Players.LocalPlayer,true)
local BarActive = false
local BIS = UniService.BIS
local AnimService = UniService.AnimService
local CLS = UniService.CLS
M.Cmds = {}
local cam = workspace.CurrentCamera
M.Gui = nil
M.Button = nil
-- Main gui (No old school)
M.Bar = nil
M.Title = nil

-- Setup default props for lighting
local DefaultLightingProps = {}
--for p,v in pairs(Lighting) do -- :( It doesn't work.
--	pcall(function()
--		DefaultLightingProps[p] = v
--	end)
--end

--local function AddProp(n)
--	if Lighting[n] then
--		DefaultLightingProps[n] = Lighting[n]
--	end
--end
--AddProp("Ambient")AddProp("Brightness")AddProp("ColorShift")


-- GUI
local function Gui()
	-- 2 buttons 1 gui.
	local ApplyDrag = UniService.ApplyDrag
	
	local gui = Instance.new("ScreenGui",plrgui)
	M.Gui = gui
	gui.IgnoreGuiInset = true
	gui.Name = "JCC_GUI"..UniService.RandomString(20.67)
	
	local TTU = UniService.TTU
	M.Button = Instance.new("TextButton",gui)
	local btn = M.Button
	btn.AnchorPoint = Vector2.new(0.5,0.5)
	btn.Position = TTU({0.909, 0},{0.301, 0})
	btn.Size = TTU({0, 100},{0, 30})
	btn.Text = "Jay's Cmds"
	--local p = Instance.new("UIDragDetector",M.Button)
	ApplyDrag(btn)
	UniService.JaysUIStyle(btn)
	
	
	M.ShowConsole = Instance.new("TextButton",gui)
	local showcon = M.ShowConsole
	showcon.AnchorPoint = Vector2.new(0.5,0.5)
	showcon.Position = TTU({0.709, 0},{0.301, 0})
	showcon.Size = TTU({0, 100},{0, 30})
	showcon.Text = "Console"
	UniService.JaysUIStyle(showcon)
	ApplyDrag(showcon)
	--p = Instance.new("UIDragDetector",showcon)
	
	
	
	Conns.JaysClientCmds_ShowBarBtn = btn.Activated:Connect(function()M.OpenCloseBar()end)
	
	Conns.JaysClientCmds_ShowConsoleBtn = showcon.Activated:Connect(function()
		UniService.ShowConsole()
	end)
	
	
	
	-- Main gui
	if M.OldSchool then return end -- If we usin' old school then what's the point of makin' alla this?
	local bar = Instance.new("TextBox",gui)
	M.Bar = bar
	bar.AnchorPoint = Vector2.new(0.5,0.5)
	bar.Position = TTU({0.5, 0},{0.107, 0})
	bar.Size = TTU({0.975, 0},{0.06, 0})
	bar.PlaceholderText = "Type a command here."
	UniService.JaysUI2(bar)
	title.Visible = false
	
	local title = Instance.new("TextLabel",gui)
	M.Title = title
	title.AnchorPoint = Vector2.new(0.5,0.5)
	title.Position = TTU({0.5, 0},{0.037, 0})
	title.Size = TTU({0.232, 0},{0.053, 0})
	title.Text = "Jay's Client Cmds"
	UniService.JaysUI2(title)
	title.Visible = false
end

-- On died
local function OnDied()
	local D = M.Disconn
	D(Conns.SitFlyConn)
	D(Conns.JumpConn)
	D(Conns.InfWalkSpeed)
	D(Conns.CFrameWalkConn)
	M.Disconn(Conns.NoclipConns[char.Name])
	D(Conns.FlingConn)
	--D(Conns.GravityConn)
	--M.GravityVF = nil
	--M.GravityA = nil
end

-- On char
local function OnChar()
	player, plrgui, char, hum, root = UniService.GetChar(game.Players.LocalPlayer,true)
	hum.Died:Connect(OnDied)
	Gui()
end
player.CharacterAdded:Connect(OnChar)
hum.Died:Connect(OnDied)
Gui()



-- The main lane is back yet again.



-- Open close bar thinggy
function M.OpenCloseBar(_,state)
	if state then
		if state ~= Enum.UserInputState.Begin then return end
	end
	
	BarActive = not BarActive
	if M.OldSchool then -- Easy, UniService got my back, but just not GOOD!
		if M.Debugwebug then print("Bar activated from OldSchool.") end
		if BarActive then
			BarActive = true
			local box = BIS.Start("JS - Jays Client Cmds", "JaysScripts - Old school box which is bad and for testing.", "Type a command, type help for help!")
			box.FocusLost:Connect(function(ep)
				if not ep then BarActive = false return end
				local str = box.Text
				if str ~= "" then
					M.RunString(str)
				end
				BarActive = false
			end)
		end
		return
	else
		
	end
end

CAS:BindAction("OpenCloseBar",M.OpenCloseBar,false,Enum.KeyCode[M.Keybind])



-- Update force quit
function M.ForceQuit()
	warn("Force quitted module",ModuleName)
	-- Initiate shutdown other stuff
	for _,c in pairs(M.Conns) do
		M.Disconn(c)
	end
	for _,t in pairs(M.Tasks) do
		M.CloseTask(t)
	end
	-- Unbind OpenClsoeBar acrtion
	CAS:UnbindAction("OpenCloseBar")
	-- Initiate real shutdown
	_G[ModuleName] = nil
end



-- Find command
function M.FindCmd(n)
	local q = 0
	local origname
	local aliases
	if M.Debugwebug then print("Searching command",n.."...") end
	n = n:lower()
	local cmd = M.Cmds[n] -- Search directly
	if not cmd then -- If fails then look at aliases
		if M.Debugwebug then print("	Failed but searching aliases...") end
		for i,v in pairs(M.Cmds) do
			if table.find(v.a,n) then
				if M.Debugwebug then print("Found command!",i,"with alias",n) end
				cmd = M.Cmds[i]
				origname = i
				aliases = v.a
				break
			end
			if M.Debugwebug then print("	Current cmd:",i,"aliases:",table.concat(v.a,", ")) end
			q += #v.a + 1
		end
		if M.Debugwebug then print("Total searches:",q) end
		if not cmd then
			if M.Debugwebug then warn("Failed to find command with name",n) end
			if M.EmoteOnCmd then pcall(function() AnimService.PlayEmote(tostring(n))end) end
			return
		end
	else
		origname = n
		aliases = cmd.a
		if M.Debugwebug then print("	Found directly!") end
	end
	if M.Debugwebug then
		print("	Original name:",origname)
		print("	Aliases:",table.concat(aliases,", "))
	end
	
	return cmd, origname, aliases, cmd.d, cmd.f
end

-- Run command
function M.RunCmd(n,...)
	local cmd = M.FindCmd(n)
	if not cmd then return end
	if M.Debugwebug then print("Ran command",n) end
	cmd.f(...)
end

-- Run string
function M.RunString(str)
	local cmd, args = UniService.GetCmd(str)
	M.RunCmd(cmd,unpack(args))
end



-- Chat commands
local PlayerChatEvent = CLS.HookPlayer(player)
PlayerChatEvent.Event:Connect(function(msg, player)
	local foundPrefix = nil
	for _, prefix in ipairs(M.ChatPrefixes) do
		if string.sub(msg, 1, #prefix) == prefix then
			foundPrefix = prefix
			break
		end
	end
	
	if foundPrefix then
		msg = string.sub(msg, #foundPrefix + 1)
		M.RunString(msg)
	else
		if not M.AllowNoChatPrefix then return end
		M.RunString(msg)
	end
end)





--



-- THEE COMMANDS...
M.Cmds = {
	test = {
		a = {"test","testlol","testerm","what"}, -- Aliases yes you have to put the original name at the start.
		d = "This is a description", -- Description
		f = function(...) -- Function
			print("Test command ran SUCCESSFULLY!!!")
			print(table.concat({...}," "))
		end
	},
	template = {
		a = {"template67"}, -- Aliases yes you have to put the original name at the start.
		d = "This is a template", -- Description
		f = function(...) -- Function
			print("Test command ran SUCCESSFULLY!!!")
			print(table.concat({...}," "))
		end
	},
	print = {
		a = {}, -- Aliases yes you have to put the original name at the start.
		d = "Prints something in console.", -- Description
		f = function(...) -- Function
			print(table.concat({...}," "))
		end
	},
	kill = {
		a = {"oof","die","kms","re"},
		d = "Oofs you...",
		f = function()
			hum.Health = -math.huge
			local head = char:FindFirstChild("Head")
			if head then head:Destroy() end
		end
	},
	velocity = {
		a = {},
		d = "Flings you around! with corresponding Vector3",
		f = function(x,y,z)
			x = tonumber(x) or 0
			y = tonumber(y) or 0
			z = tonumber(z) or 0
			UniService.OnceLinVel(root,Vector3.new(x,y,z))
			UniService.OnceAngVel(root,Vector3.new(-z,y,-x))
		end
	},
	localfling = {
		a = {},
		d = "Flings you around! with corresponding Vector3",
		f = function()
			hum.PlatformStand = true
			local x = math.random(-300,300)
			local y = math.random(-100,100)
			local z = math.random(-300,300)
			M.RunCmd("velocity",tostring(x),tostring(y),tostring(z))
		end
	},
	respawnposition = {
		a = {"respawnp","rep"}, -- Aliases yes you have to put the original name at the start.
		d = "Respawns you and teleports you back where you respawned.", -- Description
		f = function() -- Function
			local pos = root.Position
			M.RunCmd("re")
			M.Conns.RespawnPosition = player.CharacterAdded:Connect(function(char)
				wait(0)
				UniService.GetChar().root.CFrame = CFrame.new(pos)
				M:Disconn(M.Conns.RespawnPosition)
			end)
		end
	},
	globaltable = {
		a = {"gtable","gb"}, -- Aliases yes you have to put the original name at the start.
		d = "Dumps the whole _G / global table into console.", -- Description
		f = function(...) -- Function
			UniService.DumpTable(_G,"_G")
		end
	},
	fly = {
		a = {},
		d = "Enables you to fly!",
		f = function(speed)
			FlyService.ChangeSettings({
				Speed = speed or FlyService.DefaultSpeed or 50,
				CF = false,
				Plat = true,
				Anim = true,
				Ang = true,
				Rot = true
			})
			if speed then
				FlyService.DefaultSpeed = speed
			end
			FlyService.Activate()
		end
	},
	unfly = {
		a = {},
		d = "Disables you to fly.",
		f = function()
			if Conns.FlingConn then
				M.RunCmd("unfling")
			end
			
			M.Disconn(Conns.SitFlyConn)
			FlyService.Deactivate()
		end
	},
	cframefly = {
		a = {"cffly","cfly"},
		d = "Makes you fly using CFrame instead of velocity.",
		f = function(speed)
			FlyService.ChangeSettings({
				Speed = speed or FlyService.DefaultSpeed or 50,
				CF = true,
				Plat = true,
				Anim = true,
				Ang = true,
				Rot = true
			})
			if speed then
				FlyService.DefaultSpeed = speed
			end
			FlyService.Activate()
		end
	},
	vehiclefly = {
		a = {"vfly"},
		d = "Makes you fly a vehicle if some conditions are right.",
		f = function(speed)
			FlyService.ChangeSettings({
				Speed = speed or FlyService.DefaultSpeed or 50,
				CF = false,
				Plat = false,
				Anim = false,
				Ang = true,
				Rot = true
			})
			if speed then
				FlyService.DefaultSpeed = speed
			end
			FlyService.Activate()

			-- Handle when you seated on vehicle seat
			M.Disconn(Conns.SitFlyConn)
			local seat = hum.SeatPart
			if seat then
				task.wait(0)
				workspace.CurrentCamera.CameraSubject = hum
			end
			Conns.SitFlyConn = hum:GetPropertyChangedSignal("SeatPart"):Connect(function()
				--print("Sitted!")
				task.wait(0)
				workspace.CurrentCamera.CameraSubject = hum
			end)
		end
	},
	sitfly = {
		a = {"sfly","fly2"},
		d = "Makes you sit while flying. Why not?",
		f = function(speed)
			M.RunCmd("vehiclefly")
			hum.Sit = true
		end
	}, -- Haven't made the hello world command yet.
	walkspeed = { -- Incredible 🥲
		a = {"speed"},
		d = "Sets your walkspeed to a value.",
		f = function(value)
			--if value then
			--	M.DefaultWalkSpeed = value
			--else
			--	value = M.DefaultWalkSpeed or 16
			--end
			hum.WalkSpeed = value or M.DefaultWalkSpeed
		end,
	},
	jump = {
		a = {},
		d = "Jumps u. What else?",
		f = function()
			hum.UseJumpPower = true -- YES!!!
			hum.Jump = true
			hum:ChangeState(Enum.HumanoidStateType.Jumping)
			UniService.OnceLinVel(root,Vector3.new(root.Velocity.X,hum.JumpPower,root.Velocity.Z))
		end,
	},
	infinitejump = {
		a = {"infjump","ijump"},
		d = "Makes you infinitely jump! IT CAN GET GLITCHY WITH DIFFERENT DEVICES...",
		f = function()
			if UIS.TouchEnabled then
				local TouchGui = plrgui:FindFirstChild("TouchGui")
				if not TouchGui then warn("No TouchGui founded.") return end
				local TouchControlFrame = TouchGui:WaitForChild("TouchControlFrame")
				local JumpButton = TouchControlFrame:WaitForChild("JumpButton")
				JumpButton.Visible = true
				M.Disconn(Conns.JumpConn)
				Conns.JumpConn = JumpButton.MouseButton1Click:Connect(function()
					M.RunCmd("jump")
				end)
			else
				Conns.JumpConn = UIS.InputBegan:Connect(function(inp,gp)
					if gp then return end
					inp = inp.KeyCode.Name:lower()
					if inp == "space" then
						M.RunCmd("jump")
					end
				end)
			end
		end,
	},
	uninfinitejump = {
		a = {"uninfjump","uinfjump","uijump"},
		d = "Makes you NOT infinitely jump.",
		f = function()
			M.Disconn(Conns.JumpConn)
		end,
	},
	infinitewalkspeed = {
		a = {"infwalkspeed","iwalkspeed","ispeed","infspeed"},
		d = "Infinitely and definiately sets your walkspeed to a value.",
		f = function(value)
			M.Disconn(Conns.InfWalkSpeed)
			Conns.InfWalkSpeed = RunService.RenderStepped:Connect(function()
				hum.WalkSpeed = value
			end)
		end,
	},
	uninfinitewalkspeed = {
		a = {"uninfwalkspeed","uniwalkspeed","uiws","uispeed","uninfspeed"}, -- Names are insane 😭
		d = "Makes you NOT infinitely set your walkspeed",
		f = function()
			M.Disconn(Conns.InfWalkSpeed)
		end,
	},
	cmdinfodeprecated0 = {
		a = {},
		d = "DEPRECATED COMMAND. PLEASE DO NOT USE!",
		f = function(cmd)
			local name = cmd
			cmd = table.find(M.Cmds,cmd)
			if not cmd then warn("No command found.") return end
			print("Command info:",name,"= {")
			if cmd.a[1] then
				print("	Aliases:",table.concat(cmd.a,", "))
			else
				print("	Aliases: None")
			end
			print("	Description:",cmd.d)
			print("	Function:",cmd.f)
			print("}")
		end,
	},
	cframewalk = {
		a = {"cfwalk","cwalk","cfw"},
		d = "Moves your character by using CFrame instead of velocity. Horizontally sadly.",
		f = function(value)
			if not value then
				M.CFrameWalkDefaultSpeed = value
			end
			value = value or M.CFrameWalkDefaultSpeed or 32
			M.Disconn(Conns.CFrameWalkConn)
			hum.WalkSpeed = 0
			Conns.CFrameWalkConn = RunService.Heartbeat:Connect(function(dt)
				local moveVect = UniService.GetMoveVectorCam(Vector3.new(1,0,1))
				if moveVect.Magnitude > 0 then
					root.CFrame += moveVect * value * dt
				end
			end)
		end,
	},
	uncframewalk = {
		a = {"uncfwalk","uncwalk","ucwalk","ucw","ucfw"},
		d = "Makes you stop CFrame walk.",
		f = function()
			M.Disconn(Conns.CFrameWalkConn)
			hum.WalkSpeed = M.DefaultWalkSpeed
		end,
	},
	restorecollisionsmasslessdeprecated0 = {
		a = {},
		d = "DEPRECATED COMMAND. PLEASE DO NOT USE!",
		f = function(playername)
			if not playername then playername = player.Name end
			local target = UniService.SinglePlayerType(player, playername)
			if not target then return end
			for _,v in pairs(char:GetDescendants()) do
				local n = v.Name
				if not v:IsA("BasePart") and not v:IsA("Part") and not v:IsA("MeshPart") then continue end
				v.CanCollide = false
				v.Massless = false
				if n == "Head" or n == "Torso" or n == "LowerTorso" or n == "UpperTorso" then
					if n == "Head" and UniService.RigType == "r15" then continue end
					v.CanCollide = true
				end
			end
		end,
	},
	noclipdeprecated0 = {
		a = {},
		d = "DEPRECATED COMMAND. PLEASE DO NOT USE!",
		f = function(playername)
			if not playername then playername = player.Name end
			local target = UniService.SinglePlayerType(player, playername)
			if not target then return end
			M.Disconn(Conns.NoclipConn)
			Conns.NoclipConn = RunService.Stepped:Connect(function()
				for _,v in pairs(char:GetDescendants()) do
					if not v:IsA("BasePart") and not v:IsA("Part") and not v:IsA("MeshPart") then continue end
					v.CanCollide = false
				end
			end)
		end,
	},
	clipdeprecated0 = {
		a = {},
		d = "DEPRECATED COMMAND. PLEASE DO NOT USE!",
		f = function()
			M.Disconn(Conns.NoclipConn)
			M.RunCmd("rcm")
		end,
	},
	fakerdeprecated0 = {
		a = {},
		d = "DEPRECATED COMMAND. PLEASE DO NOT USE!",
		f = function()
			if M.Faker.Active then return end
			M.Faker.Active = true
			-- Store originals
			local Faker = M.Faker
			Faker.root = root
			Faker.hum = hum
			Faker.char = char

			-- Noclip orig character
			M.Disconn(Conns.FakerConn)
			M.Disconn(Conns.FakerConn0)
			Conns.FakerConn = RunService.Stepped:Connect(function()
				for _,v in pairs(Faker.char:GetDescendants()) do
					if not v:IsA("BasePart") and not v:IsA("Part") and not v:IsA("MeshPart") then continue end
					v.CanCollide = false
				end
			end)

			-- New character
			char.Archivable = true -- To clone of course!
			char = char:Clone()
			char.Name = "Fake_" .. char.Name
			root = char:WaitForChild("HumanoidRootPart")
			hum = char:WaitForChild("Humanoid")
			char.Parent = workspace
			Conns.FakerConn0 = hum.Died:Connect(function()
				M.RunCmd("unfaker")
				M.Disconn(Conns.FakerConn0)
			end)

			-- Setting up stuff
			cam.CameraSubject = hum
			player.Character = char

			-- Make orig character opaque
			for _,v in pairs(Faker.char:GetDescendants()) do
				if v:IsA("BasePart") or v:IsA("Part") or v:IsA("MeshPart") then
					v.Transparency = 0.5
				end
			end

			-- a
			M.RunCmd("clip")
			M.Disconn("FakerConn1")
			Conns.FakerConn1 = char.ChildRemoved:Connect(function(child)
				local cf = root.CFrame
				if child:IsA("BasePart") then
					M.RunCmd("unfaker")
				end
				M.RunCmd("re")
			end)
		end,
	},
	unfakerdeprecated0 = {
		a = {},
		d = "DEPRECATED COMMAND. PLEASE DO NOT USE!",
		f = function()
			M.Faker.Active = false
			M.Disconn(Conns.FakerConn)
			M.Disconn("FakerConn0")
			M.Disconn("FakerConn1")	
			local Faker = M.Faker
			Faker.root.CFrame = root.CFrame
			char:Destroy()
			player.Character = Faker.char
			char = Faker.char
			root = Faker.root
			hum = Faker.hum
			Faker.char = nil
			Faker.root = nil
			Faker.hum = nil
			cam.CameraSubject = hum
			for _,v in pairs(char:GetDescendants()) do
				if v:IsA("BasePart") or v:IsA("Part") or v:IsA("MeshPart") then
					if v.Name == "HumanoidRootPart" then v.Transparency = 1 continue end
					v.Transparency = 0
				end
			end
			M.RunCmd("clip")
		end,
	},
	invisibledeprecated0 = {
		a = {},
		d = "DEPRECATED COMMAND. PLEASE DO NOT USE!",
		f = function(farintensity)
			if M.Faker.Active then return end
			local origcf = root.CFrame
			local Oroot = root
			farintensity = tonumber(farintensity) or 1e3
			M.Disconn(Conns.InvisibleConn)
			local lv, a = UniService.ApplyLinVel(root, Vector3.zero)
			local av, a2 = UniService.ApplyAngVel(root, Vector3.zero)
			a2:Destroy()
			av.Attachment0 = a
			M.InvisibleLV = lv
			M.InvisibleAV = av
			Conns.InvisibleConn = RunService.RenderStepped:Connect(function()
				local froot = nil
				pcall(function()
					froot = workspace:FindFirstChild("Fake_"..player.Name).HumanoidRootPart
				end)
				if froot then
					Oroot.CFrame = CFrame.new(Vector3.one*farintensity+froot.Position)
				else
					Oroot.CFrame = CFrame.new(Vector3.one*farintensity)
				end
			end)
			task.delay(0.15,function()
				M.RunCmd("faker")
				task.wait(0)
				root.CFrame = origcf
				local lv, av = root:FindFirstChildOfClass("LinearVelocity"), root:FindFirstChildOfClass("AngularVelocity")
				if lv and av then
					lv:Destroy()
					av:Destroy()
				end
			end)
		end,
	},
	visibledeprecated0 = {
		a = {},
		d = "DEPRECATED COMMAND. PLEASE DO NOT USE!",
		f = function()
			M.Disconn(Conns.InvisibleConn)
			M.RunCmd("unfaker")
			M.InvisibleLV:Destroy()
			M.InvisibleAV:Destroy()
		end,
	},
	spectate = {
		a = {"view","spec"},
		d = "Makes you view a selected player.",
		f = function(target)
			target = target or player.Name
			target = UniService.SinglePlayerType(player,target)
			if not target then return end
			local hum2 = UniService.GetChar(target).hum
			if not hum2 then return end
			cam.CameraSubject = hum2
		end,
	},
	unspectate = { -- Why am I making this? No reason.
		a = {"unview","unspec"},
		d = "Unspectates the player your spectating. You can literally do this by inputting nothing.",
		f = function()
			cam.CameraSubject = hum
		end,
	},
	flingdeprecated0 = {
		a = {},
		d = "DEPRECATED COMMAND. PLEASE DO NOT USE!",
		f = function(intensity)
			if M.Faker.Active then return end
			intensity = intensity or 1e35
			local Oroot = root

			M.RunCmd("faker")
			M.Disconn(Conns.FlingConn)

			--M.Disconn(Conns.FlingConn0)
			--Conns.FlingConn0 = RunService.Stepped:Connect(function()

			--end)
			for _,v in pairs(M.Faker.char:GetDescendants()) do
				if not v:IsA("BasePart") and not v:IsA("Part") and not v:IsA("MeshPart") then continue end
				v.CanCollide = false
				v.Massless = true
			end

			local safeCF = Oroot.CFrame
			Conns.FlingConn = RunService.RenderStepped:Connect(function()
				local froot = nil
				pcall(function()
					froot = workspace:FindFirstChild("Fake_"..player.Name).HumanoidRootPart
				end)
				if froot then
					Oroot.CFrame = CFrame.new(froot.Position) * (Oroot.CFrame - Oroot.Position)
					--av.AngularVelocity = Vector3.one*intensity
					M.Faker.hum.PlatformStand = true
					M.Faker.hum:ChangeState(Enum.HumanoidStateType.PlatformStanding)
				end

				-- If things get out of hand!
				local lmag = froot.AssemblyLinearVelocity.Magnitude
				local amag = froot.AssemblyAngularVelocity.Magnitude
				if lmag <= 100 then
					safeCF = Oroot.CFrame
				end
				if lmag > 100 then
					warn("Went back to safe CFrame.")
					froot.CFrame = safeCF
					froot.AssemblyLinearVelocity = Vector3.zero
				end
				if amag > 50 then
					froot.AssemblyAngularVelocity = Vector3.zero
				end
			end)
			
			local a = function(v)
				for _,v2 in pairs(v.Character:GetDescendants()) do
					pcall(function()
					v2.CanCollide = false
					end)
				end
			end

			M.Disconn(Conns.FlingConn1)
			for _,v in pairs(Players:GetPlayers()) do
				if v.Name == player.Name then continue end
				--print(v.Name,123)
				a(v)
				v.CharacterAdded:Connect(function()
					a(v)
					--print(v.Name,6767)
				end)
			end
			Conns.FlingConn1 = Players.PlayerAdded:Connect(function(v)
				if v.Name == player.Name then return end
				--print(v.Name,123)
				a(v)
				v.CharacterAdded:Connect(function()
					task.wait(0)
					a(v)
					--print(v.Name,6767)
				end)
			end)

			task.delay(0,function()
				local lv, a = UniService.ApplyLinVel(Oroot, Vector3.zero)
				local av, a2 = UniService.ApplyAngVel(Oroot, Vector3.one*intensity)
				a2:Destroy()
				av.Attachment0 = a
				M.InvisibleLV = lv
				M.InvisibleAV = av
			end)
		end,
	},
	unflingdeprecated0 = {
		a = {},
		d = "DEPRECATED COMMAND. PLEASE DO NOT USE!",
		f = function()
			local lv = M.InvisibleLV
			local av = M.InvisibleAV
			if not lv and not av then return end
			lv.VectorVelocity = Vector3.zero
			av.AngularVelocity = Vector3.zero
			task.delay(0.1,function()
				lv:Destroy()
				av:Destroy()
				M.Disconn(Conns.FlingConn0)
				M.Disconn(Conns.FlingConn)
				M.Disconn(Conns.FlingConn1)
				M.RunCmd("unfaker")
				hum.PlatformStand = false
			end)
		end,
	},
	playanim = {
		a = {},
		d = "Plays an animation by an Id.",
		f = function(id)
			local orig = id
			id = tonumber(id) or nil
			if id == nil then
				if UniService.RigType == "r6" then
					for i,v in pairs(M.GenericAnimations.r6) do
						if i ~= orig then continue end
						id = v
						break
					end
				end
			end
			AnimService.PlayAnim(id)
		end,
	},
	unplayanim = {
		a = {"undance","und","unanim"},
		d = "Plays an animation by an Id.",
		f = function(id)
			AnimService.Stop()
		end,
	},
	playdance = {
		a = {},
		d = "Plays an dance from the DancesIds table.",
		f = function(index)
			index = tonumber(index) or 1
			if UniService.RigType == "r15" then
				AnimService.PlayAnim(M.DanceIds.r15[index])
			else
				AnimService.PlayAnim(M.DanceIds.r6[index])
			end
		end,
	},
	dance1={a={"d1"},d="Plays dances 1 from r6 and r15.",f=function()M.RunCmd("playdance","1")end},
	dance2={a={"d2"},d="Plays dances 2 from r6 and r15.",f=function()M.RunCmd("playdance","2")end},
	dance3={a={"d3"},d="Plays dances 3 from r6 and r15.",f=function()M.RunCmd("playdance","3")end},
	
	playemote = {
		a = {},
		d = "Plays an emote. Why a difference between animations and emotes? Don't know.",
		f = function(id)
			id = tonumber(id) or 126683101367289
			AnimService.PlayEmote(id)
			AnimService.PlayEmote(id)
		end,
	},
	commandsdeprecated0 = {
		a = {"cmds","viewcmds"},
		d = "DEPRECATED COMMAND. PLEASE DO NOT USE!",
		f = function()
			print("COMMANDS:")
			for cmd,info in pairs(M.Cmds) do
				print("	"..cmd,"= {")
				if info.a[1] then
					print("		Aliases:",table.concat(info.a,", "))
				else
					print("		Aliases: None")
				end
				print("		Description:",info.d)
				print("		Function:",info.f)
				print("	}")
			end
		end,
	},
	spin = {
		a = {},
		d = "Spins your character horizontally on the Y-axis.",
		f = function(value)
			if M.SpinAV and M.SpinA then
				M.SpinAV:Destroy()
				M.SpinA:Destroy()
				M.SpinAV = nil
				M.SpinA = nil
			end
			value = tonumber(value) or 5
			local av, a = UniService.ApplyAngVel(root, Vector3.new(0,value,0))
			M.SpinAV = av
			M.SpinA = a
		end,
	},
	unspin = {
		a = {},
		d = "Stops spinning your character horizontally on the Y-axis.",
		f = function()
			if M.SpinAV and M.SpinA then
				M.SpinAV:Destroy()
				M.SpinA:Destroy()
				M.SpinAV = nil
				M.SpinA = nil
			end
		end,
	},
	massless = {
		a = {"nomass","antimass"},
		d = "Sets all your characters parts to massless. To set it to normal do rcm - Restore Collisions & Massless (Properties)",
		f = function()
			for _,v in pairs(char:GetDescendants()) do
				if v:IsA("BasePart") then
					v.Massless = true
				end
			end
		end,
	},
	debugwebug = {
		a = {"debug"},
		d = "Prints out useless debug info.",
		f = function(state)
			if state == "true" or state == "1" then
				state = true
			elseif state == "false" or state == "0" then
				state = false
			else
				state = not M.Debugwebug
			end
			M.Debugwebug = state
			print("Debugging:",M.Debugwebug)
		end,
	},
	globalmodification = {
		a = {"glomod"},
		d = "Sets a value from the global table, _G. Very buggy.",
		f = function(...) -- Example: glomod JaysClientCmds.DanceIds.r6.1 = 6767
			--[[ -- Since everything is seperated by spaces...
			[1] = DanceIds.r6.1
			[2] = "="
			[3] = 6767
			]]
			local info = {...}
			local path = info[1]
			local equal = info[2]
			local value = info[3]

			if path and equal == "=" and value then -- This is from chatgpt ngl.
				local pathinfo = path:split(".")

				local current = _G -- Start from your main module table!

				-- Go through the path until the last item
				for i = 1, #pathinfo - 1 do
					local key = pathinfo[i]
					current = current[key]
					if not current then
						warn("Invalid path:", path)
						return
					end
				end

				local finalKey = pathinfo[#pathinfo]

				-- Convert value types
				local numVal = tonumber(value)
				if numVal ~= nil then
					value = numVal
				elseif value == "true" then
					value = true
				elseif value == "false" then
					value = false
				elseif value == "nil" then
					value = nil
				end

				current[finalKey] = value
				print("Set", path, "to", value)
			else
				warn("Invalid syntax. Example: modmod DanceIds.r6.1 = 6767. I know luau is hard.")
			end
		end,
	},
	modulemodification = {
		a = {"modmod"},
		d = "Can modify the modules variables given a value. Go inside tables with .'s or something. Kinda like luau.",
		f = function(...)
			local a = table.concat({...}, " ")
			M.RunString("glomod "..ModuleName.."."..a)
		end,
	},
	globalfunctionrun = {
		a = {"glorun"},
		d = "Runs a function from the global table (_G) with optional arguments.",
		f = function(...)
			-- Example: glorun JaysClientCmds.DoStuff 123 hello true
			local info = {...}
			local path = info[1]

			if not path then
				warn("Invalid syntax. Example: glorun Table.FunctionName args...")
				return
			end

			-- Split path & collect arguments
			local pathinfo = path:split(".")
			local args = {}
			for i = 2, #info do
				local v = info[i]
				local num = tonumber(v)
				if num ~= nil then
					v = num
				elseif v == "true" then
					v = true
				elseif v == "false" then
					v = false
				elseif v == "nil" then
					v = nil
				end
				table.insert(args, v)
			end

			local current = _G
			for i = 1, #pathinfo - 1 do
				local key = pathinfo[i]
				current = current[key]
				if not current then
					warn("Invalid path:", path)
					return
				end
			end

			local finalKey = pathinfo[#pathinfo]
			local func = current[finalKey]

			if typeof(func) == "function" then
				print("🌀 Running global function:", path)
				func(unpack(args))
			else
				warn("Path is not a function:", path)
			end
		end,
	},
	modulefunctionrun = {
		a = {"modrun"},
		d = "Runs a function from the main module (M) with optional arguments.",
		f = function(...)
			local a = table.concat({...}, " ")
			M.RunString("glorun " .. ModuleName .. "." .. a)
		end,
	},
	to = {
		a = {"teleportto"},
		d = "Makes you teleport to a player with a given username.",
		f = function(target)
			target = UniService.SinglePlayerType(player, target)
			local root2 = UniService.GetChar(target).root
			
			if not root or not root2 then return end
			
			root.CFrame = root2.CFrame
		end,
	},
	nigthvision = {
		a = {"nv"},
		d = "Gives you night vision like vision! Makes dark places look brighter! NO reverting.",
		f = function()
			if M.NVActive then
				M.NVActive = false
				
				-- Reset lighting props
				for p,v in pairs(DefaultLightingProps) do
					pcall(function()
						Lighting[p] = v
					end)
				end
				
				return "¯\_(ツ)_/¯" -- Why not ¯\_(ツ)_/¯
			end
			
			M.NVActive = true
			
			Lighting.Ambient = Color3.new(1,1,1)
			Lighting.Brightness = 3
			Lighting.EnvironmentDiffuseScale = 1
			Lighting.GlobalShadows = false
			Lighting.OutdoorAmbient = Color3.new(1,1,1)
		end,
	},
	fieldofview = {
		a = {"fov"},
		d = "Changes your FOV. I don't know why the original name is abreviated.",
		f = function(value)
			value = tonumber(value) or 70
			cam.FieldOfView = value
		end,
	},
	highzoom = {
		a = {},
		d = "Makes your max zoom, well, really high! Well infinately.",
		f = function()
			player.CameraMaxZoomDistance = math.huge
		end,
	},
	trippyzoom = {
		a = {},
		d = "Sets your fpv low and your highzoom, well, high!",
		f = function()
			cam.FieldOfView = -math.huge
			player.CameraMaxZoomDistance = math.huge
		end,
	},
	loopto = {
		a = {"lto","lt"},
		d = "Makes you loop teleport to a person.",
		f = function(target)
			if Conns.LoopToConn then
				M.Disconn(Conns.LoopToConn)
			end
			Conns.LoopToConn = RunService.Heartbeat:Connect(function()
				M.RunCmd("to",target)
			end)
		end,
	},
	unloopto = {
		a = {"ult"},
		d = "Makes you stop loop teleporting to a player.",
		f = function()
			M.Disconn(Conns.LoopToConn)
		end,
	},
	loopcommand = {
		a = {"lcmd"},
		d = "With a given commands, loops that command with the amount argument. Default is 5.",
		f = function(loops, ...)
			print(...)
			loops = tonumber(loops) or 5
			for i = 1, loops do
				--print(table.concat({...}," "))
				M.RunString(table.concat({...}," "))
				task.wait(0.01)
			end
		end,
	},
	rcm = {
		a = {"restorecollisionsmassless"},
		d = "Restores the original values of collisions and massless properties.",
		f = function(TARGET)
			if not TARGET then
				TARGET = char
			end
			
			for _,v in pairs(TARGET:GetDescendants()) do
				local n = v.Name
				if not v:IsA("BasePart") then continue end
				v.CanCollide = false
				v.Massless = false
				if n == "Head" and UniService.RigType == "r15" then continue end
				if n == "Head" or n == "Torso" or n == "LowerTorso" or n == "UpperTorso" then
					v.CanCollide = true
				end
			end
		end,
	},
	noclip = {
		a = {},
		d = "Makes you pass through walls with no care!",
		f = function(TARGET)
			if not TARGET then
				TARGET = char
			end
			
			if Conns.NoclipConns[TARGET.Name] then M.Disconn(Conns.NoclipConns[TARGET.Name]) end
			
			Conns.NoclipConns[TARGET.Name] = RunService.Stepped:Connect(function()
				for _,v in pairs(TARGET:GetDescendants()) do
					if not v:IsA("BasePart") then continue end
					v.CanCollide = false
				end
			end)
		end,
	},
	clip = {
		a = {},
		d = "Makes you DON'T pass through wall. With care. :(",
		f = function(TARGET)
			if not TARGET then
				TARGET = char
			end
			
			M.Disconn(Conns.NoclipConns[TARGET.Name])
			
			M.RunCmd("rcm", TARGET)
		end,
	},
	faker = {
		a = {"clone"},
		d = "The new faker cmd. Makes a clone of yourself and your real character stays there. VERY UNSTABLE!!! Say in chat unfaker or ;unfaker to revert if anything goes wrong.",
		f = function()
			local Faker = M.Faker
			-- If faker already active
			if Faker.char then
				M.RunCmd("unfaker")
				task.wait(0)
			end
			
			-- INIT
			-- Set variables
			Faker.Rchar = char
			Faker.Rroot = root
			Faker.Rhum = hum
			char.Archivable = true -- Set archivable
			
			-- Cloning
			char = char:Clone()
			char.Name = "Faker_"..player.Name
			char.Parent = workspace
			root = char:WaitForChild("HumanoidRootPart")
			hum = char:WaitForChild("Humanoid")
			Faker.char = char
			Faker.root = root
			Faker.hum = hum
			
			-- Initing clone
			player.Character = char -- New character
			cam.CameraSubject = hum
			
			-- Make real char opaque
			for _,v in pairs(Faker.Rchar:GetDescendants()) do
				if not v:IsA("BasePart") then continue end
				v.Transparency = 0.5
			end
			
			-- Make real char noclippable
			M.RunCmd("noclip", Faker.Rchar)
			
			-- Make animate script re-alived
			local animate = char:WaitForChild("Animate")
			animate.Enabled = false
			animate.Enabled = true
			
			
			
			for _,v in pairs(Faker.Conns) do
				M.Disconn(v)
				v = nil
			end
			-- BACK UP METHODS (When something is wrong with the fake char)
			-- When char dies
			Faker.Conns[1] = hum.Died:Connect(function()
				warn("Faker - BACK UP INITIATED! Faker char died.")
				M.RunCmd("unfaker")
			end)
			
			-- When REAL char dies
			Faker.Conns[2] = Faker.Rhum.Died:Connect(function()
				warn("Faker - BACK UP INITIATED! Real char died.")
				M.RunCmd("unfaker")
			end)
			
			-- When char disappears
			Faker.Conns[3] = char.AncestryChanged:Connect(function(_, p)
				if p then return end
				warn("Faker - BACK UP INITIATED! Faker char disappeared.")
				M.RunCmd("unfaker")
			end)
		end,
	},
	unfaker = {
		a = {"unclone"},
		d = "Deletes your clone and brings you back to your real character.",
		f = function()
			local Faker = M.Faker
			if not Faker.char then return end
			
			-- Disconnect stuff
			
			M.RunCmd("clip", Faker.Rchar)
			for _,v in pairs(Faker.Conns) do
				M.Disconn(v)
				v = nil
			end
			
			-- Init real chor
			char = Faker.Rchar
			root = Faker.Rroot
			hum = Faker.Rhum
			player.Character = char
			cam.CameraSubject = hum
			root.CFrame = Faker.root.CFrame
			
			-- Reverse opaque-isy
			for _,v in pairs(char:GetDescendants()) do
				if not v:IsA("BasePart") then continue end
				v.Transparency = 0
				if v.Name ~= "HumanoidRootPart" then continue end
				v.Transparency = 1
			end
			
			-- Delete clone
			Faker.char:Destroy()
			
			Faker.char = nil
			Faker.Rchar = nil
			Faker.root = nil
			Faker.Rroot = nil
			Faker.hum = nil
			Faker.Rhum = nil
		end,
	},
	antifling = {
		a = {"nofling"},
		d = "Disables everyones character collisions so you can't get flinged!",
		f = function() -- Truely a disaster.
			M.AntiFlingChars = {}

			for i,target in pairs(Players:GetPlayers()) do
				if target == player then continue end
				local char = target.Character
				if not char then continue end
				M.AntiFlingChars[i] = char
			end

			M.AntiFlingConn = RunService.Stepped:Connect(function()
				for _,v in pairs(M.AntiFlingChars) do
					for _,v in pairs(v:GetDescendants()) do
						if not v:IsA("BasePart") then continue end
						v.CanCollide = false
					end
				end
			end)
		end,
	},
	unantifling = {
		a = {"unofling"},
		d = "I AM TIRED OKAY? I AM A SLAVE FOR THIS BASEMENT. YOu got toget m o t . Mylcation is aPstr",
		f = function()
			if M.AntiFlingConn then
				M.Disconn(M.AntiFlingConn)
				M.AntiFlingConn = nil

				for _,v in pairs(M.AntiFlingChars) do
					M.RunCmd("rcm", v)
				end
			end
		end,
	},
	help = {
		a = {},
		d = "Says general information to what to do.",
		f = function()
			UniService.ShowConsole(true)
print([[








Welcome to the help section!:
You can open the command bar by pressing the ";" key, or the "Jay's Cmds" button.

You can use chat commands by having a prefix
available prefixes (default if not modified): "; : ! . /"
you can use a chat command by doing: !cmd ha ha ha argument
If "AllowNoChatPrefix" is true then you can use
commands without a prefix like: "cmd arg1 arg2 haha"

USEFUL COMMANDS:
cmd: Shows 1 command with it's information.
cmds: Shows all commands with information.







]])
		end,
	},
	cmd = {
		a = {"command"},
		d = "Shows information of a singular command.",
		f = function(cmd)
			if not cmd then
				cmd = "cmd"
			end
			local _,cmd,aliases,desc,func = M.FindCmd(cmd)
			if not cmd then warn("No command found.") return end
			local info = string.format([[

Original Command: %s
Aliases: %s
Description: %s
Function: %s
]], cmd, table.concat(aliases, ", "), desc, tostring(func))

			print(info)
			UniService.ShowConsole(true)
		end,
	},
	cmds = {
		a = {"commands"},
		d = "Shows all commands information.",
		f = function()
			for i,v in pairs(M.Cmds) do
				M.RunCmd("cmd", i)
			end
		end,
	},
	invisible = {
		a = {"invis"},
		d = "Makes your character invisible, server replication by moving your real character far far away. VERY UNSTABLE!",
		f = function(farintensity)
			farintensity = tonumber(farintensity) or 1e3
			local Faker = M.Faker
			if Faker.char then return end
			Faker.Rroot = root
			Faker.Rhum = hum
			Faker.Rchar = char
			local cf = root.CFrame
			
			-- Moves character FAR FAR AWAY!
			-- Initiation
			M.InvisLV, M.InvisA = UniService.ApplyLinVel(root, Vector3.zero)
			M.InvisAV, M.TempOHAHA = UniService.ApplyAngVel(root, Vector3.zero)
			M.TempOHAHA:Destroy()
			M.InvisAV.Attachment0 = M.InvisA
			
			-- Far far away.
			M.Disconn(Conns.InvisConn)
			Conns.InvisConn = RunService.RenderStepped:Connect(function()
				if Faker.root then
					Faker.Rroot.CFrame = CFrame.new((Vector3.one * farintensity) + Faker.root.Position)
					return
				end
				Faker.Rroot.CFrame = CFrame.new(Vector3.one * farintensity)
			end)
			
			task.wait(0.3) -- Wait so it can replicate through the server.
			
			M.RunCmd("faker")
			
			root.CFrame = cf
			
			for _,v in pairs(root:GetChildren()) do
				if not v:IsA("LinearVelocity") and not v:IsA("AngularVelocity") then continue end
				v:Destroy()
			end
		end,
	},
	visible = {
		a = {"vis"},
		d = "Makes you visible.",
		f = function()
			if not Conns.InvisConn then return end
			local cf = root.CFrame
			M.Disconn(Conns.InvisConn)
			M.RunCmd("unfaker")
			for _,v in pairs(root:GetChildren()) do
				if not v:IsA("LinearVelocity") and not v:IsA("AngularVelocity") then continue end
				v:Destroy()
			end
			root.CFrame = cf
		end,
	},
	jumpscare = {
		a = {"scare","jp"},
		d = "Jumpscares people! Make sure you have invis on. VERY UNSTABLE AND DO NOT SPAM!!!",
		f = function()
			M.RunCmd("visible")
			task.wait(0.35)
			M.RunCmd("invisible")
		end,
	},
	fling = {
		a = {},
		d = "Makes your character go FLING FLING and objects go BYE BYE! VERY UNSTABLE!!!",
		f = function(intensity)
			intensity = tonumber(intensity) or 1e30 -- Woah!
			local Faker = M.Faker
			if Faker.root then
				M.RunCmd("unfling")
				task.wait(0.15)
			end
			M.RunCmd("massless")
			M.RunCmd("faker")
			M.RunCmd("rcm")
			local char = Faker.Rchar
			local root = Faker.Rroot
			local hum = Faker.Rhum
			
			--M.RunCmd("noclip", Faker.char)
			M.RunCmd("antifling")
			M.Disconn(Conns.FlingConn)
			--M.Disconn("FlingConn0")
			M.FlingLV, M.FlingA = UniService.ApplyLinVel(root, Vector3.zero)
			M.FlingAV, M.TempOHAHAo = UniService.ApplyAngVel(root, Vector3.zero)
			M.TempOHAHAo:Destroy()
			M.FlingAV.Attachment0 = M.FlingA
			
			Conns.FlingConn = RunService.RenderStepped:Connect(function()
				root.CFrame = CFrame.new(Faker.root.Position) * (root.CFrame - root.Position)
			end)
			
			--for _,v in pairs(char:GetDescendants()) do
			--	if not v:IsA("BasePart") then continue end
			--	v.CanCollide = false
			--	v.Massless = true
			--end
			
			task.delay(0.1,function()
				M.FlingAV.AngularVelocity = Vector3.one * intensity
			end)
		end,
	},
	unfling = {
		a = {},
		d = "Unflings. I am tired. This is at 11 PM bro-n-vro.",
		f = function()
			local Faker = M.Faker
			local cf = Faker.root.CFrame
			M.FlingAV.AngularVelocity = Vector3.zero
			task.delay(0.2,function()
				M.RunCmd("unfaker")
				M.FlingAV:Destroy()
				M.FlingAV = nil
				M.FlingLV:Destroy()
				M.FlingLV = nil
				M.FlingA:Destroy()
				M.FlingA = nil
				
				M.RunCmd("clip")
				M.RunCmd("unantifling")
				M.Disconn(Conns.FlingConn)
				hum.PlatformStand = false
				hum:ChangeState(Enum.HumanoidStateType.GettingUp)
			end)
		end,
	},
	horizontalfling = {
		a = {"hfling"},
		d = "I don't feel like it, but meh. It flings objects also but you spin horizontally. Boom, I said it. You happy?",
		f = function(intensity)
			intensity = tonumber(intensity) or 1e30 -- Woah!
			local Faker = M.Faker
			if Faker.root then
				M.RunCmd("unfling")
				task.wait(0.15)
			end
			M.RunCmd("massless")
			M.RunCmd("faker")
			M.RunCmd("rcm")
			local char = Faker.Rchar
			local root = Faker.Rroot
			local hum = Faker.Rhum

			M.RunCmd("noclip", Faker.char)
			M.RunCmd("antifling")
			M.Disconn(Conns.FlingConn)
			--M.Disconn("FlingConn0")
			M.FlingLV, M.FlingA = UniService.ApplyLinVel(root, Vector3.zero)
			M.FlingAV, M.TempOHAHAo = UniService.ApplyAngVel(root, Vector3.zero)
			M.TempOHAHAo:Destroy()
			M.FlingAV.Attachment0 = M.FlingA

			Conns.FlingConn = RunService.RenderStepped:Connect(function()
				root.CFrame = CFrame.new(Faker.root.Position) * (root.CFrame - root.Position)
			end)

			--for _,v in pairs(char:GetDescendants()) do
			--	if not v:IsA("BasePart") then continue end
			--	v.CanCollide = false
			--	v.Massless = true
			--end

			task.delay(0.1,function()
				M.FlingAV.AngularVelocity = Vector3.new(0,1,0) * intensity
			end)
		end,
	},
	cmdcount = {
		a = {},
		d = "Shows all the commands without their information and how many commands are there. (Help me)",
		f = function()
			local count = 0
			local c0 = 0
			for i,v in pairs(M.Cmds) do
				count += 1
				c0 += 1
				print("Cmd:",i,"Aliases:",table.concat(v.a, ", "))
				c0 += #v.a
			end
			print("Command count:",count)
			print("Total commands (Cmds + Aliases):",c0)
			UniService.ShowConsole(true)
		end,
	},
	keybind = {
		a = {},
		d = "Changes the keybind to open the command bar. MAKE SURE THAT IT IS ASCII CHARACTERS. YES FANCY I KNOW.",
		f = function(bind)
			warn("Make sure you input the keybind correctly and properly! I am not saying that it is wrong, just letting you know.")
			M.Keybind = bind
			print("Keybind:",M.Keybind)
			CAS:UnbindAction("OpenCloseBar")
			CAS:BindAction("OpenCloseBar",M.OpenCloseBar,false,Enum.KeyCode[M.Keybind])
			local a = Enum.KeyCode.Quo
		end,
	},
	allownochatprefix = {
		a = {"nochatprefix","ancp"},
		d = "When enabled, allows you to ",
		f = "Unfinished :/"
	},
	flyfling = {
		a = {},
		d = "You fly, you fling.",
		f = function(speed, intensity)
			M.RunCmd("fling")
			task.wait(0.1)
			FlyService.ChangeSettings({
				Speed = speed or FlyService.DefaultSpeed or 50,
				CF = false,
				Plat = true,
				Anim = true,
				Ang = true,
				Rot = true
			})
			if speed then
				FlyService.DefaultSpeed = speed
			end
			FlyService.Activate()
		end,
	},
	gravity = {
		a = {},
		d = "You can change your characters gravity.",
		f = function(targetGrav)
			local function remove()
				if not M.GravityVF then return end
				M.Disconn(Conns.GravityConn)
				M.GravityVF:Destroy()
				M.GravityVF = nil
				M.GravityA:Destroy()
				M.GravityA = nil
			end
			
			targetGrav = tonumber(targetGrav) or nil
			if not targetGrav then
				remove()
				return
			end
			
			remove()
			
			M.GravityVF = Instance.new("VectorForce",root)
			M.GravityA = Instance.new("Attachment",root)
			M.GravityVF.Attachment0 = M.GravityA
			
			Conns.GravityConn = RunService.Heartbeat:Connect(function()
				local mass = root.AssemblyMass
				local worldGrav = workspace.Gravity
				local gravDiff = worldGrav - targetGrav
				local force = Vector3.new(0, mass * gravDiff, 0)
				M.GravityVF.Force = force
				if M.GravityVF and M.GravityVF.Force then
					local v = M.GravityVF.Force
				end
			end)
		end,
	},
	sit = {
		a = {},
		d = "Makes you sit. That's all!",
		f = function()
			hum.Sit = true
		end,
	},
	freeze = {
		a = {},
		d = "Makes you freeze! A cold command isn't it? (I don't get the joke too bro.)",
		f = function()
			for _,v in pairs(char:GetDescendants()) do
				if not v:IsA("BasePart") then continue end
				v.Anchored = true
			end
		end,
	},
	unfreeze = {
		a = {},
		d = "Makes you pretty warm so you heat down the coldness of the freeze (Insert_Word)",
		f = function()
			for _,v in pairs(char:GetDescendants()) do
				if not v:IsA("BasePart") then continue end
				v.Anchored = false
			end
		end,
	},
	becomelight = {
		a = {},
		d = "I SHALL BECOME LIGHT!",
		f = function()
			for _,v in pairs() do
				
			end
		end,
	},
	plat = {
		a = {},
		d = "Makes you platform stand",
		f = function()
			hum.PlatformStand = true
		end,
	}
}

-- Print out commands if debugwebug
if M.Debugwebug then
	M.RunCmd("cmds")
end

-- Start up commands [If REAlLY needed] - And also other sih.
-- Stuff

M.DefaultWalkSpeed = hum.WalkSpeed
--local Faker = {} DEPRECATED
--M.Faker = Faker
--Faker.char = nil -- Even though it's not gonna be in the table. Why not?
--Faker.root = nil -- These are meant to be the real characters parts not the fake.
--Faker.hum = nil
--Faker.Active = false

M.DanceIds = {
	r6 = {
		[1] = 182435998,
		[2] = 182436842,
		[3] = 182436935
	},
	r15 = {
		[1] = 507771019,
		[2] = 507776043,
		[3] = 507777268
	},
}
M.GenericAnimations = {
	r6 = {
		idle = 180435571,
		walk = 180426354,
		jump = 125750702,
		fall = 180436148,
		climb = 180436334,
		sit = 178130996,
		toolnone = 182393478,
		toolslash = 129967390,
		toollunge = 129967478,
		wave = 128777973,
		point = 128853357,
		-- Already dance ids.
		-- MEHHHH
		dance1 = 182435998,
		dance2 = 182436842,
		dance3 = 182436935,
		laugh = 129423131,
		cheer = 129423030,
	}
}
Conns.NoclipConns = {}
Conns.GravityConns = {}
-- Faker serivce?
local Faker = {}
M.Faker = Faker

-- Variables & expected variables.
--Faker.Active = false
Faker.Rchar = nil -- R for real.
Faker.Rroot = nil
Faker.Rhum = nil
Faker.char = nil -- The fakers parts
Faker.root = nil
Faker.hum = nil
Faker.Conns = {}

task.wait(0.1) -- Command start up