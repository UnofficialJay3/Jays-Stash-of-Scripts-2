-- Script init
local Z
-- Get module
local function GetModule(name,url)
	print("Searching module",name..":")
	print("	Searching module directly...")
	local m = _G[name]
	if not m then
		warn("	Failed from direct.")
		print("	Searching module with url...")
		local s,r = pcall(function()
			loadstring(game:HttpGet(url))()
		end)
		if s then
			print("Success from url!\n")
			m = _G[name]
			return m
		else
			warn("	Failed from url:",r)
			return
		end
	end
	print("Success from direct!\n")
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



-- Configuration
M.Keybind = "Semicolon" -- Needs capilization pls
M.OldSchool = true -- The "Old school" way of the bar.
M.Debugwebug = false -- Gotta debug what's a webug!
M.EmoteOnCmd = true -- If no other command works than try to use it as a emote I guess.



-- Main init
-- Services
Z = UniService.Services
local CAS, RunService, UIS, Players  = Z.CAS, Z.RunService, Z.UIS, Z.Players

-- Variables
local player, plrgui, char, hum, root = UniService.GetChar(game.Players.LocalPlayer,true)
local BarActive = false
local BIS = UniService.BIS
local AnimService = UniService.AnimService
M.Cmds = {}
local cam = workspace.CurrentCamera

local function OnDied()
	local D = M.Disconn
	D(Conns.SitFlyConn)
	D(Conns.JumpConn)
	D(Conns.InfWalkSpeed)
	D(Conns.CFrameWalkConn)
	D(Conns.NoclipConn)
	D(Conns.InvisibleConn)
	D(Conns.FakerConn)
	D(Conns.FlingConn0)
	D(Conns.FlingConn)
	--D(Conns.FlingConn1)
	M.SpinAV = nil
	M.SpinA = nil
end
local function OnChar()
	player, plrgui, char, hum, root = UniService.GetChar(game.Players.LocalPlayer,true)
	hum.Died:Connect(OnDied)
end
player.CharacterAdded:Connect(OnChar)
hum.Died:Connect(OnDied)




-- The main lane is back yet again.



-- Open close bar thinggy
local function OpenCloseBar(_,state)
	if state ~= Enum.UserInputState.Begin then return end
	BarActive = not BarActive
	if M.OldSchool then -- Easy, UniService got my back, but just not GOOD!
		if M.Debugwebug then print("Bar activated from OldSchool.") end
		if BarActive then
			BarActive = true
			local box = BIS.Start("JS - Jays Client Cmds", "JaysScripts - Old school box which is bad and for testing.", "Type a command.")
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
	end
end

CAS:BindAction("OpenCloseBar",OpenCloseBar,false,Enum.KeyCode[M.Keybind])

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
		_G[ModuleName] = nil -- WOW!
	end



-- Run command
function M.RunCmd(n,...)
	local q = 0
	if M.Debugwebug then print("Searching command",n.."...") end
	n = n:lower()
	local cmd = M.Cmds[n] -- Search directly
	if not cmd then -- If fails then look at aliases
		if M.Debugwebug then print("	Failed but searching aliases...") end
		for i,v in pairs(M.Cmds) do
			if table.find(v.a,n) then
				if M.Debugwebug then print("Found command!",i,"with alias",n) end
				cmd = M.Cmds[i]
				break
			end
			if M.Debugwebug then print("	Current cmd:",i,"aliases:",table.concat(v.a,", ")) end
			q += #v.a + 1
		end
		if M.Debugwebug then print("Total searches:",q) end
		if not cmd then
			warn("Failed to find command with name",n)
			if M.EmoteOnCmd then pcall(function() AnimService.PlayEmote(tostring(n))end) end
			return
		end
	else
		if M.Debugwebug then print("	Found directly!") end
	end
	if M.Debugwebug then print("Ran command",n) end
	cmd.f(...)
end

-- Run string
function M.RunString(str)
	local cmd, args = UniService.GetCmd(str)
	M.RunCmd(cmd,unpack(args))
end



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
	cmdinfo = {
		a = {},
		d = "Views an commands info.",
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
	restorecollisionsmassless = {
		a = {"rcm"},
		d = "Restores characters properties like CanCollide and Massless.",
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
	noclip = {
		a = {},
		d = "Disables your collisions but hipheight saves you from falling.",
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
	clip = {
		a = {"unnoclip"},
		d = "Un-noclips you so you can collide stuff.",
		f = function()
			M.Disconn(Conns.NoclipConn)
			M.RunCmd("rcm")
		end,
	},
	faker = {
		a = {"clone"},
		d = "Makes a fake character that you control, but your real character stays still. VERY UNSTABLE (I THINK...)",
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
		end,
	},
	unfaker = {
		a = {"unclone"},
		d = "Makes you go back to your normal character and destroys the clone.",
		f = function()
			M.Faker.Active = false
			M.Disconn(Conns.FakerConn)
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
	invisible = {
		a = {"invis"},
		d = "Makes you invisible. Uses faker command (Does auto) and moves the real character far away.",
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
	visible = {
		a = {"vis"},
		d = "Makes you visible.",
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
	fling = {
		a = {},
		d = "Flings anything that is unachored! On contact to your local player. VERY UNSTABLE...",
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
	unfling = {
		a = {},
		d = "Makes you stop flinging stuff.",
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
			id = tonumber(id) or 182435998
			AnimService.PlayAnim(id)
		end,
	},
	unplayanim = {
		a = {"undance","und"},
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
	commands = {
		a = {"cmds","viewcmds"},
		d = "Views all of the commands with the commands info",
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
	}
}

-- Print out commands if debugwebug
if M.Debugwebug then
	M.RunCmd("cmds")
end

-- Start up commands [If REAlLY needed] - And also other sih.
-- Stuff

M.DefaultWalkSpeed = hum.WalkSpeed
local Faker = {}
M.Faker = Faker
Faker.char = nil -- Even though it's not gonna be in the table. Why not?
Faker.root = nil -- These are meant to be the real characters parts not the fake.
Faker.hum = nil
Faker.Active = false

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



task.wait(0.1) -- Command start up