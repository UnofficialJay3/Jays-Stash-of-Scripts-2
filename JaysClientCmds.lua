-- By rbx: @IlIl_ILovAltAccsHAHA / ・゠314・一一一非公式ジェイ一一一・・ - Unofficial Jay | Git: @UnofficialJay3

-- Script initialization
-- Module grabber
local M = _G["__JaysTHEMODULE__"]
if not M then warn("JaysScripts - The module 'JaysTHEMODULE' is not loaded!")return end

-- Add JaysClientCmds
local C, modulekey = M.AddScript("JaysClientCmds")



-- Configuration
C.Key = "semicolon" -- Use this for the keybind to open the command bar.
C.Connections = {} -- This is used for getting connections and ofcourse turning them off when you want to.



-- Main initialization
-- Services
local Z = M.Services -- Shorter name.
local RunService, UserInputService = Z.RunService, Z.UserInputService

-- Variables
Z = M.GetLocalCharacter()
local player, char, root, hum = Z.player, Z.char, Z.root, Z.hum
local cam = workspace.CurrentCamera
local PlayerModule = player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")
local ControlModule = require(PlayerModule:WaitForChild("ControlModule"))
C.Commands = {} -- Listes all the names, functions for each command.

local function Reset_Tation()
	if C.Connections.loopto then
		print("Disconnected loopto.")
		C.Connections.loopto:Disconnect()
		C.Connections.loopto = nil
	end
	
	if C.Connections.cfw then
		print("Disconnected cframe walk.")
		C.Connections.cfw:Disconnect()
		C.Connections.cfw = nil
	end
end

-- On character spawn, get back character stuff
C.Connections.CharAdded = player.CharacterAdded:Connect(function()
	Z = M.GetLocalCharacter()
	player, char, root, hum = Z.player, Z.char, Z.root, Z.hum
	PlayerModule = player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")
	ControlModule = require(PlayerModule:WaitForChild("ControlModule"))
	hum.Died:Connect(Reset_Tation)
end)
hum.Died:Connect(Reset_Tation)



-- Unironically the main lane (What does ironic/unironic mean again?)



-- Add command function
function C.AddCmd(name, func)
	--print("Added command!: " .. name)
	if typeof(name) == "string" then
		name = name:lower()
		C.Commands[name] = func
	elseif typeof(name) == "table" then
		for _, v in pairs(name) do
			v = v:lower()
			C.Commands[v] = func
		end
	end
	
	
end




-- Run command function
function C.RunCmd(name, ...)
	name = name:lower()
	local cmd = C.Commands[name] -- make sure it uses your C.Commands table
	if cmd then
		cmd(...) -- pass all arguments to the command function
	else
		warn("Command not found:", name)
	end
end



-- Command handler
function C.HandleCmdText(text)
	local c, a = M.GetCmd(text)
	if C.Commands[c] then
		C.RunCmd(c, table.unpack(a))
	end
end



-- Prompter Handler
function C.Prompter()
	local b = M.ThePrompter()
	C.Connections.BoxFocusLost = b.FocusLost:Connect(function(ep)
		if ep then
			local text = b.Text:match("^%s*(.-)%s*$")
			C.HandleCmdText(text)
		end
	end)
end



-- Input handler
C.Connections.InputHandler = UserInputService.InputBegan:Connect(function(inp, gp)
	if gp then return end
	inp = inp.KeyCode.Name:lower()

	if inp == C.Key then
		C.Prompter()
	end
end)



--



-- THE COMMANDS

-- Best programmer of all time B) Test command
C.AddCmd("test", function(a,b)
	print("Test command.")
	print("a,b values:",a,b)
end)

C.AddCmd("test0", function(...)
	print("Works 👍")
	print(...)
end)



-- Speed cmd
local defaultSpeed = hum.WalkSpeed

C.AddCmd("speed", function(value)
	if value and tonumber(value) then
		hum.WalkSpeed = tonumber(value)
	else
		hum.WalkSpeed = defaultSpeed
	end
end)


-- Re command
C.AddCmd({"re", "respawn"}, function()
	-- ZERO
	pcall(function()
		player:LoadCharacter() -- This is 100% server-sided by why not?
	end)
	-- ONE
	if hum then
		hum.Health = -math.huge-- + 1 UH OH!!!
	end
	-- TWO
	local h = char:FindFirstChild("Head")
	if h then h:Destroy() end
end)


-- Math...
C.AddCmd("math", function(sign, ...)
	local nums = {...}
	for i = 1, #nums do
		nums[i] = tonumber(nums[i]) -- Conversion to real numbers.
	end
	
	local result
	if sign == "+" then
		result = 0
		for _, n in ipairs(nums) do
			result += n
		end

	elseif sign == "-" then
		result = nums[1]
		for i = 2, #nums do
			result -= nums[i]
		end

	elseif sign == "*" then
		result = 1
		for _, n in ipairs(nums) do
			result *= n
		end

	elseif sign == "/" then
		result = nums[1]
		for i = 2, #nums do
			result /= nums[i]
		end
	else
		warn("Unknown operator:", sign)
		return
	end

	print("Math: Result:", result)
end)


-- Useless
C.AddCmd("impossiblemath", function()
	return math.huge + 1, print("If you see this then this doesn't work. I can't math.huge+1 to crash :(")
end)


-- Get player
C.AddCmd("getplayer", function(text)
	local playuhs = M.GetPlayers(player, text or "me")
	print("Players founded:")
	for i, v in ipairs(playuhs) do
		print(i,":"..v.Name)
	end
end)


-- To player
C.AddCmd("to", function(player)
	player = M.GetSinglePlayer(player)
	if player then
		local rootB = M.GetCharacter(player.Name).root
		root.CFrame = CFrame.new(rootB.Position, root.CFrame.LookVector)
	end
end)


-- Loop to player
C.AddCmd({"lto", "loopto"}, function(player)
	if C.Connections.loopto then
		C.Connections.loopto:Disconnect()
		C.Connections.loopto = nil
		return
	end
	
	player = M.GetSinglePlayer(player)
	if not player then return end
	C.Connections.loopto = RunService.Heartbeat:Connect(function()
		local rootB = M.GetCharacter(player.Name).root
		root.CFrame = CFrame.new(rootB.Position)
	end)
end)


-- Test1
C.AddCmd("test1", function()
	if M.Tasks["test1"] then
		M.StopTask("test1")
	end
	
	M.StartTask("test1", function(info)
		while info.running do
			print("test1")
			task.wait(0)
		end
	end)
end)


-- Inside _G
C.AddCmd({"globaltable", "dumpg", "dumpglobal", "dg"}, function()
	M.DumpTable(_G, "_G")
end)


-- Exit script
C.AddCmd({"exitscript", "es", "escript"} --[[Don't think about it]],function()
	print("Rest in peace JaysClientCmds...")
	task.wait(1)
	M.CleanModule(modulekey)
end)


-- Respawn position | Respawns at the point you oofed?
C.AddCmd({"rep", "repos"}, function()
	local oldCF = root.CFrame
	C.RunCmd("re")
	C.Connections.RANDOMLOL = player.CharacterAdded:Connect(function()
		wait(0)
		local root = M.GetLocalCharacter().root
		root.CFrame = oldCF
		C.Connections.RANDOMLOL:Disconnect()
		C.Connections.RANDOMLOL = nil
	end)
end)


-- loop dumpg
C.AddCmd("ldg",function()
	RunService.Heartbeat:Connect(function()
		C.RunCmd("dg")
	end)
end)


-- Loop cmd
C.AddCmd({"loopcmd", "lc"}, function(times, ...)
	times = tonumber(times)
	if not times or times < 1 then
		warn("Invalid times:", times)
		return
	end

	-- Combine the rest into a single string command
	local cmdText = table.concat({...}, " ")
	if cmdText == "" then
		warn("No command provided to loop.")
		return
	end

	-- Loop n times
	for i = 1, times do
		C.HandleCmdText(cmdText)
	end
end)


-- Self destruct.
C.AddCmd("selfdestruct",function()
	task.delay(1,function()
		M.SelfDestruct()
	end)
	print("Rest in peace. You successfully destroyed the game.")
	warn("Rest in peace. You successfully destroyed the game.")
	error("Rest in peace. You successfully destroyed the game.")
end)


-- CFrame walk
C.AddCmd({"cfw", "cframewalk", "cfwalk", "cwalk"},function(value)
	if not value and C.Connections.cfw then
		C.Connections.cfw:Disconnect()
		C.Connections.cfw = nil
		hum.WalkSpeed = defaultSpeed
		return
	end
	
	if C.Connections.cfw then
		C.Connections.cfw:Disconnect()
	end
	
	hum.WalkSpeed = -math.huge + math.huge -- Awesome math to calculate 0
	
	if tonumber(value) then
		value = tonumber(value)
	else return
	end
	
	C.Connections.cfw = RunService.Heartbeat:Connect(function(dt)
		local camCF = cam.CFrame

		local moveVec = Vector3.zero
		
		-- Mobile moveVec
		local mobileVec = ControlModule:GetMoveVector()
		if mobileVec.Magnitude > 0 then
			local forward = Vector3.new(camCF.LookVector.X, 0, camCF.LookVector.Z).Unit
			local right = Vector3.new(camCF.RightVector.X, 0, camCF.RightVector.Z).Unit
			moveVec += (forward * -mobileVec.Z + right * mobileVec.X)
		end

		if moveVec.Magnitude > 0 then
			moveVec = moveVec.Unit
			root.CFrame = root.CFrame + (moveVec * value * dt)
		end

		local pos = root.CFrame.Position
		local look = root.CFrame.LookVector
		-- Force flat (Y only) rotation
		local flatLook = Vector3.new(look.X, 0, look.Z).Unit
		root.CFrame = CFrame.new(pos, pos + flatLook)
	end)
end)



-- Fly
local Fly = _G["__JaysFlyin__"]

C.AddCmd("fly",function(value)
	Fly.UpdateSettings({
		speed = value or 50,
		cf = false
	})
	
	Fly.Connect()
end)

C.AddCmd("unfly",function()
	Fly.Disconnect(false)
end)

C.AddCmd("cfly",function(value)
	Fly.UpdateSettings({
		speed = value or 50,
		cf = true
	})
	
	Fly.Connect()
end)

C.AddCmd("destroyfly",function()
	Fly.Destroy()
end)


-- Say/message
C.AddCmd({"say", "message"},function(text)
	if text then
		M.Message(text)
	else
		M.Message("Buddy, include text bro.")
	end
end)


-- Spawn points
C.SpawnPoints = {}
--[[ Examples
SpawnPoints = {
	1 = Vector3.new(0, 0, 0),
	2 = Vector3.new(10, 0, 0),
}
]]

C.AddCmd({"savepoint", "sp"},function()
	local index = #C.SpawnPoints+1
	local cf = root.CFrame
	print("Added point! Index:",index,string.format("Position -> X: %.2f, Y: %.2f, Z: %.2f", cf.Position.X, cf.Position.Y, cf.Position.Z))
	C.SpawnPoints[index] = cf
end)

C.AddCmd({"loadpoint", "lp"},function(index)
	if tonumber(index) then
		index = tonumber(index)
		if C.SpawnPoints[index] then
			local cf = C.SpawnPoints[index]
			print("Loaded point from index:",index,string.format("Position -> X: %.2f, Y: %.2f, Z: %.2f", cf.Position.X, cf.Position.Y, cf.Position.Z))
			root.CFrame = cf
		end
	else
		warn("No index for points.")
	end
end)

C.AddCmd({"deletepoint", "dp"},function(index)
	if tonumber(index) then
		index = tonumber(index)
		if C.SpawnPoints[index] then
			C.SpawnPoints[index] = nil
			print("Deleted point from index:",index)
		end
	else
		if index == "all" then
			C.SpawnPoints = {} -- I've tried using a for loop but I realized...
			print("Deleted all points.")
		else
			warn("No index for points.")
		end
	end
end)

C.AddCmd({"printpoints", "prp"},function() -- I am not naming print points to pp.
	if #C.SpawnPoints == 0 then warn("No points saved.") return end -- If the table is empty then return.
	
	print("Spawn points:")
	for i, v in pairs(C.SpawnPoints) do
		local cf = v
		print("Index:",i,string.format("Position -> X: %.2f, Y: %.2f, Z: %.2f", cf.Position.X, cf.Position.Y, cf.Position.Z))
	end
end)


-- Loadstring
C.AddCmd("loadstring",function(str)
	local s, r = pcall(function()
		return loadstring(str)()
	end)
	
	if s then
		print("Loadstring success!")
	else
		warn("Loadstring error:",r)
	end
end)