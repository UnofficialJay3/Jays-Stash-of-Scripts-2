-- By rbx: @IlIl_ILovAltAccsHAHA / ・゠314・一一一非公式ジェイ一一一・・ - Unofficial Jay | Git: @UnofficialJay3

-- Script initialization
-- Module grabber
local M = _G["__JaysTHEMODULE__"]
if not M then warn("JaysScripts - The module 'JaysTHEMODULE' is not loaded! Attempting to add...")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/UnofficialJay3/Jays-Stash-of-Scripts-2/refs/heads/main/JaysTHEMODULE.lua"))()
end

-- Add JaysClientCmds
local C, modulekey = M.AddScript("JaysFlyin")



-- Configuration
C.key = "f" -- The keybind for your fly key.
C.speed = 50 -- The speed for your flight on a JET2 HOLIDAY!!! [Not sponsered]
C.cf = false -- Determines if your flight on a JET2 HOLIDAY!!! Using CFrame or velocity for movement.
C.anim = true -- In your flight on a JET2 HOLIDAY!!! the r6 and r15 animations will play.
C.Connections = {} -- The connection table for general connections.
C.plat = true -- In your current flight, you will be FORCED to be in platform standing!
C.camrot = true -- Your character will look towards the lookvector of your camera
C.ang = true -- In the flight you angular velocity is updating if THAT is true, if that's not then you will move around crazy if not controlled.
local r6anim = 130025294780390 -- Animation for your flight (not making that joke because that's a hoke!) in r6.
local r15anim = 121812367375506 -- The animation for r15.



-- Main initialization
-- Services
local Z = M.Services
local UserInputService, RunService = Z.UserInputService, Z.RunService

-- Variables
Z = M.GetLocalCharacter()
local player, char, root, hum = Z.player, Z.char, Z.root, Z.hum
local cam = workspace.CurrentCamera
local PlayerModule = player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")
local ControlModule = require(PlayerModule:WaitForChild("ControlModule"))

local function Reset()
	C.Connections.Died = hum.Died:Connect(function()
		if C.Connections.FlyConn then
			C.Connections.FlyConn:Disconnect()
			C.Connections.FlyConn = nil
		end
	end)
end

player.CharacterAdded:Connect(function()
	Z = M.GetLocalCharacter()
	player, char, root, hum = Z.player, Z.char, Z.root, Z.hum
	PlayerModule = player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")
	ControlModule = require(PlayerModule:WaitForChild("ControlModule"))
	Reset()
end)
Reset()



-- Officially Unofficialized main lane!



-- Add the velocity modifiers on the root
function C.AddVel(state)
	local function useless()
		if C.att then
			C.att:Destroy()
			C.att = nil
		end
		if C.lv then
			C.lv:Destroy()
			C.lv = nil
		end
		if C.av then
			C.av:Destroy()
			C.av = nil
		end
	end
	
	if not state then
		useless()
		return
	end
	useless()
	
	
	
	-- Add instances to _G to disable them whenever.
	C.att = Instance.new("Attachment", root)
	C.lv = Instance.new("LinearVelocity", root)
	C.av = Instance.new("AngularVelocity", root)
	local a,b = C.lv, C.av -- Reference them shorter
	
	a.Attachment0 = C.att
	a.MaxForce = math.huge
	b.Attachment0 = C.att
	b.MaxTorque = math.huge
end



-- Update fly settings
function C.UpdateSettings(t)
	if not t then return end
	
	local function UpdateSetting(n)	
		if t[n] ~= nil then
			local value = t[n]
			C[n] = value
		end
	end
	
	UpdateSetting("key")
	UpdateSetting("speed")
	UpdateSetting("cf")
	UpdateSetting("camrot")
	UpdateSetting("anim")
	UpdateSetting("plat")
	UpdateSetting("ang")
	
	if C.Connections.FlyConn then
		C.Connect()
	end
end



-- Get settings
function C.GetSettings()
	local t = {}
	t.key = C.key
	t.speed = C.speed
	t.cf = C.cf
	t.camrot = C.camrot
	t.anim = C.anim
	t.plat = C.plat
	t.ang = C.ang
	return t
end



-- Disconnect FlyConn
function C.Disconnect(update)
	if C.Connections.FlyConn then
		C.Connections.FlyConn:Disconnect()
		if update then return end
		C.Connections.FlyConn = nil
		hum.PlatformStand = false
		hum:ChangeState(Enum.HumanoidStateType.Freefall)
		C.AddVel(false)
	end
end



-- Connect FlyConn
function C.Connect()
	-- If connected, disconnect but still keep everything da same.
	C.Disconnect(true)

	-- Add velocity if haven't.
	C.AddVel(true)

	-- The connection(tm)
	C.Connections.FlyConn = RunService.Heartbeat:Connect(function(dt)
		-- Re-fetch root + hum if missing
		if not root or not root.Parent then
			local Z = M.GetLocalCharacter()
			player, char, root, hum = Z.player, Z.char, Z.root, Z.hum
			if not root then return end -- skip this frame until we got a root
		end

		-- Get cam
		local camCF = cam.CFrame
		local f = camCF.LookVector
		local r = camCF.RightVector
		local u = (camCF.UpVector * Vector3.new(0,1,0)).Unit

		-- Get moveVec
		local moveVec = Vector3.zero

		-- Mobile moveVec
		local mobileVec = ControlModule:GetMoveVector()
		if mobileVec.Magnitude > 0 then
			local forward = camCF.LookVector.Unit
			local right = camCF.RightVector.Unit
			moveVec += (forward * -mobileVec.Z + right * mobileVec.X)
		end

		-- Movement
		if moveVec.Magnitude > 0 then
			moveVec = moveVec.Unit
			if C.cf then
				local finalPos = root.Position + moveVec * C.speed * dt
				root.CFrame = CFrame.new(finalPos) * (root.CFrame - root.CFrame.Position)
			else
				C.lv.VectorVelocity = moveVec * C.speed
			end
		else
			C.lv.VectorVelocity = Vector3.zero
		end

		if C.plat then
			pcall(function()
				hum.PlatformStand = true
				hum:ChangeState(Enum.HumanoidStateType.PlatformStanding)
			end)
		end

		if C.ang then
			C.av.MaxTorque = math.huge
		else
			C.av.MaxTorque = 0
		end

		if C.camrot then
			root.CFrame = CFrame.new(root.Position, root.Position + f)
		end
	end)
end



-- Self destruct
function C.Destroy()
	print("Rest in peace JaysFlyin'...")
	C.Disconnect(false)
	task.wait(1)
	M.CleanModule(modulekey)
end