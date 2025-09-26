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
local C, sKey = M.AddScript("JaysFlyinLoader")



-- Configuration
C.Key = "f" -- Toggle for your flight
C.DefaultFlySpeed = 50 -- Default speed for the flight, also when you change your speed and don't provide a value next flight then it will be setted to DefaultFlySpeed
C.cf = false
C.ang = true
C.camrot = true
C.plat = true
C.anim = true



-- Main init
-- Services
local Z = M.Services
local UserInputService, Players = Z.UserInputService, Z.Players

-- Variables
Z = M.GetLocalCharacter()
local player, char, root, hum = Z.player, Z.char, Z.root, Z.hum
C.Connections = {}



-- Unofficially but officialized-ally a main lane gois!


-- Command handler
function C.CmdHandler(text)
	local cmd, args = M.GetCmd(text)
	
	local function A(n, v)
		print("Fly setting",n,"changed to",v)
		if v then
			if v == "t" then
				v = true
			elseif v == "f" then
				v = false
			end
			C[n] = v
		else
			C[n] = not C[n]
		end
		
		Fly.UpdateSettings({
			[n] = v
		})
	end
	
	if cmd == "fly" then
		Fly.Connect()
	elseif cmd == "unfly" then
		Fly.Disconnect()
	elseif cmd == "speed" then
		local speedo = tonumber(args[1])
		if not speedo then return end
		Fly.UpdateSettings({
			speed = speedo
		})
	elseif cmd == "cf" then
		A("cf", args[1])
	elseif cmd == "ang" then
		A("ang", args[1])
	elseif cmd == "camrot" then
		A("camrot", args[1])
	elseif cmd == "plat" then
		A("plat", args[1])
	elseif cmd == "anim" then
		A("anim", args[1])
	elseif cmd == "reset" then
		A("cf", false)
		A("ang", true)
		A("camrot", true)
		A("plat",true)
		A("anim",true)
		Fly.UpdateSettings({
			speed = C.DefaultFlySpeed,
			cf = false,
			ang = true,
			camrot = true,
			anim = true,
			plat = true,
		})
	elseif cmd == "fling" then -- The fling preset, doesn't fling stuff unless you actiavte it somewhere else.
		A("cf", false)
		A("ang", false)
		A("camrot", false)
		A("plat",true)
		A("anim",true)
		Fly.UpdateSettings({
			speed = C.DefaultFlySpeed,
			cf = false,
			ang = false,
			camrot = false,
			anim = true,
			plat = true,
		})
		
		Fly.Connect()
	end
end



-- Prompter
function C.Prompter()
	local box = M.Prompter("JS - JaysFlyinLoader")
	task.wait()
	box.FocusLost:Connect(function(ep)
		if ep then
			local text = box.Text:match("^%s*(.-)%s*$")
			C.CmdHandler(text)
		end
	end)
end


-- Input handler
UserInputService.InputBegan:Connect(function(inp,gp)
	if gp then return end
	inp = inp.KeyCode.Name:lower()
	
	if inp == C.Key then
		Fly.UpdateSettings({
			speed = C.DefaultFlySpeed,
			cf = C.cf,
			ang = C.ang,
			camrot = C.camrot,
			plat = C.plat,
			anim = C.anim
		})
		
		if Fly.Connections.Connection then
			Fly.Disconnect()
		else
			Fly.Connect()
		end
	elseif inp == "l" then
		-- Chatgpt but in roblox stop giving me suggestions other than the PROMPTER!!!
		-- I'm sorry
		C.Prompter()
	end
end)