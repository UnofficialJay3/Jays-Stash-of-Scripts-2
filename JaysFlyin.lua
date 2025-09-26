-- Scripted by ROBLOX: @IlIl_ILovAltAccsHAHA / ・゠314・一一一非公式ジェイ一一一・・ - Unofficial Jay | GITHUB: @UnofficialJay3
-- Might be the worst script ever made. I've even gotten a previous script exactly the same but I still ended up on 10 hours on this.
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
if not M then return end

-- Add script
local C, sKey = M.AddScript("JaysFlyin")



-- Configurations
C.Connection = nil -- The connection for your flight to a JET2 HOLIDAY!!! (Not sponsered)
C.speed = 50 -- The speed for your flight
C.cf = false -- If true, you would be using CFrame for your movement instead of velocity
C.ang = true -- If true, in your flight there would be a angular velocity stopping you move angularly.
C.camrot = true -- If !false then your root will be having the same lookvector as the camera. Complex words right?
C.plat = true -- If 1 (true DON'T SET IT 1 OR 0) then you will be platform standing the whole time in your flight of your JET2 HOLIDAY!!!
C.anim = true -- If not false then you are putted into the animation of idle-ness.
local aR6 = 130025294780390
local aR15 = 121812367375506



-- Main init
-- Services
local Z = M.Services
local RunService = Z.RunService

-- Variables
Z = M.GetLocalCharacter()
local player, char, root, hum = Z.player, Z.char, Z.root, Z.hum
C.Connections = {} -- The connections table
local cam = workspace.CurrentCamera
local att = nil
local lv = nil
local av = nil
local flyAnim = nil
local FlyTrack = nil

local function PlayFlyAnimation()
	if FlyTrack then FlyTrack:Stop() end

	if hum.RigType == Enum.HumanoidRigType.R6 then
		flyAnim = Instance.new("Animation")
		flyAnim.AnimationId = "rbxassetid://" .. aR6
	else
		flyAnim = Instance.new("Animation")
		flyAnim.AnimationId = "rbxassetid://" .. aR15
	end

	FlyTrack = hum:LoadAnimation(flyAnim)
	FlyTrack.Priority = Enum.AnimationPriority.Action4
	FlyTrack:Play()
	FlyTrack.Looped = true
end

-- Stop animation
local function StopFlyAnimation()
	if FlyTrack then
		FlyTrack:Stop()
		FlyTrack = nil
	end
end

function C.DisconnConn(conn)
	conn:Disconnect()
	conn = nil
end

local function Reset2()
	-- Disconnect stuff
	local Z = C.Connections
	if Z.Connection then
		C.DisconnConn(Z.Connection)
	end
end

local function Reset()
	Z = M.GetLocalCharacter()
	player, char, root, hum = Z.player, Z.char, Z.root, Z.hum
	
	hum.Died:Connect(Reset2)
end
hum.Died:Connect(Reset2)

player.CharacterAdded:Connect(Reset)


-- What da MAAAAAAAAAAAIN LAEAEAEAEAEAEA-AAAAAAAAAANNNNNNNEEE-YYYYIIIIIIAAAAOOOOOOOOOOOOOO



-- Update fly settings
function C.UpdateSettings(t)
	if not t then return end

	local function UpdateSetting(n)	
		if t[n] ~= nil then
			local value = t[n]
			C[n] = value
		end
	end

	UpdateSetting("speed")
	UpdateSetting("cf")
	UpdateSetting("camrot")
	UpdateSetting("anim")
	UpdateSetting("plat")
	UpdateSetting("ang")

	if C.Connections.Connection then
		C.Connect()
	end
end



-- Get settings
function C.GetSettings()
	local t = {}
	t.speed = C.speed
	t.cf = C.cf
	t.camrot = C.camrot
	t.anim = C.anim
	t.plat = C.plat
	t.ang = C.ang
	return t
end



-- Disconnect
function C.Disconnect(state)
	C.DisconnConn(C.Connections.Connection)
	C.Connections.Connection = nil
	att:Destroy()
	lv:Destroy()
	pcall(function()
		av:Destroy()
	end)
	att = nil
	lv = nil
	av = nil
	
	if state then return end
	
	if C.anim then
		StopFlyAnimation()
	end
	task.wait()
	hum:ChangeState(Enum.HumanoidStateType.GettingUp)
end



-- Connect fly
function C.Connect()
	-- Check if connection
	if C.Connections.Connection then
		C.Disconnect(true)
	end
	
	if C.anim then
		PlayFlyAnimation()
	end
	
	-- Set up lv and av
	if not att then
		att = Instance.new("Attachment",root)
	end
	
	if not lv then
		lv = Instance.new("LinearVelocity",root)
		lv.MaxForce = math.huge
		lv.Attachment0 = att
	end
	
	if not av and C.ang then
		av = Instance.new("AngularVelocity",root)
		av.MaxTorque = math.huge
		av.Attachment0 = att
	end
	
	C.Connections.Connection = RunService.Heartbeat:Connect(function(dt)
		-- Get move vector
		local moveVec = M.GetMoveVector(1,1,1)
		
		-- Up/down move vector on pc
		if M.IsKeyDown("Space") or M.IsKeyDown("E") then
			moveVec += Vector3.new(0,1,0)
		end
		if M.IsKeyDown("LeftControl") or M.IsKeyDown("Q") then
			moveVec += Vector3.new(0,-1,0)
		end
		
		if moveVec.Magnitude > 0 then
			if C.cf then
				lv.VectorVelocity = Vector3.zero
				local finalPos = root.Position + moveVec * C.speed * dt
				root.CFrame = CFrame.new(finalPos) * (root.CFrame - root.CFrame.Position)
			else
				lv.VectorVelocity = moveVec * C.speed
			end
			
		else
			lv.VectorVelocity = Vector3.zero
		end
		
		if C.plat then
			pcall(function()
				hum.PlatformStand = true
				hum:ChangeState(Enum.HumanoidStateType.PlatformStanding)
			end)	
		end
		if C.camrot then
			root.CFrame = CFrame.new(root.Position, root.Position + cam.CFrame.LookVector)
		end
	end)
end