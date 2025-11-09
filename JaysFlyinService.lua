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
--Self init
local ModuleName = "JaysFlyinService"
local M = {}
_G[ModuleName] = M
UniService.InitModule(M,ModuleName)
local Conns = M.Tasks
local Tasks = M.Conns



-- Main init



-- Configuration
M.EnableKeybind = true -- Let's you enable and disable the fly service by a keybind. Using M.Keybind
M.Keybind = "f" -- PLEASE LOWWER CASE!!!
M.Speed = 50 -- Speed of flight
--M.DefaultSpeed = 50 -- When you actiavte fly service again it will set it to default speed.
M.CF = false -- In your flight you will be using CFrame instead of velocity to be moving.
M.Plat = true -- In your flight you will be platform standing. (Feels good
M.Anim = true -- In your flight it will play a default animation for better... It's just good.
M.Ang = true -- In your flight your angular velocity will be setted to 0
M.Rot = true -- In your flight your root will be oriented the same as the lookvector of the camera.
local animR6 = 130025294780390
local animR15 = 121812367375506




-- Main init
-- Services
Z = UniService.Services
local UIS, RunService = Z.UIS, Z.RunService

-- Variables
local player, plrgui, char, hum, root = UniService.GetChar(game.Players.LocalPlayer,true)
local lv = nil
local av = nil
local a = nil
local AnimService = UniService.AnimService

local function OnDied()
	local D = UniService.Disconn
	D(Conns.Conn)
	D(Conns.Conn67)
end
local function OnChar()
	player, plrgui, char, hum, root = UniService.GetChar(game.Players.LocalPlayer,true)
	hum.Died:Connect(OnDied)
end
player.CharacterAdded:Connect(OnChar)
hum.Died:Connect(OnDied)



-- The main lane!



-- Change settings with EASE?
function M.ChangeSettings(t)
	local function ChangeSetting(s)
		if t[s] ~= nil then
			local value = t[s]
			M[s] = value
		end
	end
	
	ChangeSetting("Keybind")
	ChangeSetting("Speed")
	ChangeSetting("CF")
	ChangeSetting("Plat")
	ChangeSetting("Anim")
	ChangeSetting("Ang")
	ChangeSetting("Rot")
	
	-- Activate so it updates settings
	if Conns.Conn then
		M.Activate()
	end
end

-- Default settings
function M.DefaultSettings()
	M.ChangeSettings({
		Keybind = "f",
		Speed = 50,
		CF = false,
		Plat = true,
		Anim = true,
		Ang = true,
		Rot = true
	})
end

-- Fling preset
function M.FlingSettings() -- This preset is for when you want to fling, like setting ang vel to a insane number. To fling things.
	M.ChangeSettings({
		CF = false,
		Plat = true,
		Anim = true,
		Ang = false,
		Rot = false
	})
end
--M.FlingSettings()



-- Unactivate
function M.Deactivate()
	--print("JaysFlyinService - Deactivated!")
	if not Conns.Conn then return end
	M.Disconn(Conns.Conn)
	M.Disconn(Conns.Conn67)
	a:Destroy()
	lv:Destroy()
	av:Destroy()
	a = nil
	lv = nil
	av = nil
	hum.PlatformStand = false
	hum:ChangeState(Enum.HumanoidStateType.Freefall)
	Conns.Conn = nil -- Why.
	AnimService.Stop()
end



-- Activate
function M.Activate()
	if not root then return end
	--print("JaysFlyinService - Activated!")
	if Conns.Conn then
		M.Disconn(Conns.Conn)
		M.Disconn(Conns.Conn67)
	end
	
	if M.Anim then
		if UniService.RigType == "r15" then
			AnimService.PlayAnim(animR15)
		else
			AnimService.PlayAnim(animR6)
		end
	end
	
	if not lv and not av and not a then
		local a2 = nil
		lv, a = UniService.ApplyLinVel(root, Vector3.zero)
		av, a2 = UniService.ApplyAngVel(root, Vector3.zero)
		a2:Destroy()
		av.Attachment0 = a
	end
	
	Conns.Conn = RunService.Heartbeat:Connect(function(dt)
		local moveVect = UniService.GetMoveVectorCam()
		if typeof(moveVect) ~= "Vector3" then warn("Not a vector3.") return end
		
		-- Up and down
		if UIS:IsKeyDown(Enum.KeyCode.Space) or UIS:IsKeyDown(Enum.KeyCode.E) then
			moveVect += Vector3.new(0,1,0)
		end
		if UIS:IsKeyDown(Enum.KeyCode.LeftControl) or UIS:IsKeyDown(Enum.KeyCode.Q) then
			moveVect += Vector3.new(0,-1,0)
		end
		
		if moveVect.Magnitude > 0 then
			if M.CF then
				root.CFrame += moveVect * M.Speed * dt
				lv.VectorVelocity = Vector3.zero
			else
				lv.VectorVelocity = moveVect * M.Speed
			end
			
		else
			lv.VectorVelocity = Vector3.zero
		end
		
		if M.Plat then
			hum.PlatformStand = true
			hum:ChangeState(Enum.HumanoidStateType.PlatformStanding)
		else
			hum.PlatformStand = false
		end
		
		if M.Ang then
			av.MaxTorque = math.huge
		else
			av.MaxTorque = 0
		end
	end)
	
	Conns.Conn67 = RunService.RenderStepped:Connect(function()
		if M.Rot then
			root.CFrame = CFrame.new(root.Position, root.Position + workspace.CurrentCamera.CFrame.LookVector --[[Good I know]])
		end
	end)
end



-- Input
Conns.What = UIS.InputBegan:Connect(function(inp, gp)
	if gp then return end
	inp = inp.KeyCode.Name:lower()
	if M.Keybind == inp and M.EnableKeybind then
		if Conns.Conn then
			M.Deactivate()
		else
			M.Activate()
		end
	end
	--if inp == "e" or inp == "space" and Conns.Conn then
		
	--end
end)