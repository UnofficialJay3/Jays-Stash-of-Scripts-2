-- Script init
-- Self creditor
_G.Z = _G.Z or function()
	print([[

░░░░░██╗░█████╗░██╗░░░██╗░██████╗  ░██████╗░█████╗░██████╗░██╗██████╗░████████╗░██████╗
░░░░░██║██╔══██╗╚██╗░██╔╝██╔════╝  ██╔════╝██╔══██╗██╔══██╗██║██╔══██╗╚══██╔══╝██╔════╝
░░░░░██║███████║░╚████╔╝░╚█████╗░  ╚█████╗░██║░░╚═╝██████╔╝██║██████╔╝░░░██║░░░╚█████╗░
██╗░░██║██╔══██║░░╚██╔╝░░░╚═══██╗  ░╚═══██╗██║░░██╗██╔══██╗██║██╔═══╝░░░░██║░░░░╚═══██╗
╚█████╔╝██║░░██║░░░██║░░░██████╔╝  ██████╔╝╚█████╔╝██║░░██║██║██║░░░░░░░░██║░░░██████╔╝
░╚════╝░╚═╝░░╚═╝░░░╚═╝░░░╚═════╝░  ╚═════╝░░╚════╝░╚═╝░░╚═╝╚═╝╚═╝░░░░░░░░╚═╝░░░╚═════╝░ 
—————————————————————————————————————————————————————————————————————————————————————————
Made with Joy, made by Jay.

Thank you]],game.Players.LocalPlayer.DisplayName,[[for using Jays Scripts.]])
	_G.Z = function()end
end
_G.Z()

-- The whole service
local C = {}
_G.JaysUniService = C -- Jays Universal Service - Having the necessary tools.



-- Main init
-- Services + other bs
local Players = game:GetService("Players")
local SoundsService = game:GetService("SoundService")
local UIS = game:GetService("UserInputService")
local CAS = game:GetService("ContextActionService")
local TCS = game:GetService("TextChatService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StartGui = game:GetService("StarterGui")
local cam = workspace.CurrentCamera
local Lighting = game:GetService("Lighting")



-- The MAIN LANE the 4th time!



-- Services
C.Services = {
	Players = Players,
	SoundsService = SoundsService,
	UIS = UIS,
	CAS = CAS,
	TCS = TCS,
	TweenService = TweenService,
	RunService = RunService,
	ReplicatedStorage = ReplicatedStorage, -- I don't know why I abreviate services with 3 words. Just don't tell me.
	Lighting = Lighting
}



-- Chat version
if TCS.ChatVersion == Enum.ChatVersion.TextChatService then
	C.ChatVersion = "Modern"
else
	C.ChatVersion = "Legacy"
end



-- Test function - Testing
function C.Test()
	print("Jays Universl Service is working!")
end



-- Add module - Gives the module starter utilities and variables.
function C.InitModule(module, modulename) -- PLEASE DO NOT MULTI RUN THIS FUNCTION!!!
	print("Module",modulename,"added and initated!")
	module.Conns = {} -- Connections
	module.Tasks = {} -- Coroutines
	function module.Disconn(conn)
		pcall(function()
		conn:Disconnect()
		conn = nil
		end)
	end
	function module.CreateTask(f)
		pcall(function()
		local t = coroutine.create(f)
		coroutine.resume(t)
		module.Tasks[t] = nil
		return t end)
	end
	function module.CloseTask(t)
		pcall(function()
		coroutine.close(t)
		module.Tasks[t] = nil end)
	end
	function module.ForceQuit()
		warn("Force quitted module",modulename)
		-- Initiate shutdown other stuff
		for _,c in pairs(module.Conns) do
			module.Disconn(c)
		end
		for _,t in pairs(module.Tasks) do
			module.CloseTask(t)
		end
		-- Initiate real shutdown
		_G[modulename] = nil -- WOW!
	end
end
C.InitModule(C,"JaysUniService")



-- Dump table - Dumps a given table into print, includes elements.
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



-- Get character - Gets the player and the characters parts packaged in a array or a table with keys.
function C.GetChar(target: string | Player,  arrayed: boolean?)
	if not target then
		target = Players.LocalPlayer
	else
		if typeof(target) == "string" then
			target = C.PlayerSearch(target)
			if not target then return end
		end
	end
	
	local player = target
	local plrgui = player:FindFirstChild("PlayerGui")
	local char = player.Character or player.CharacterAdded:Wait()
	local hum = char:WaitForChild("Humanoid")
	local root = char:WaitForChild("HumanoidRootPart")
	local animator = hum:WaitForChild("Animator")
	local humdesc = hum:WaitForChild("HumanoidDescription")
	if arrayed then
		return player, plrgui, char, hum, root, animator, humdesc
	end
	return {
		player = player,
		plrgui = plrgui,
		char = char,
		hum = hum,
		root = root,
		animator = animator,
		humdesc = humdesc
	}
end
local player, plrgui, char, hum, root, animator, humdesc = C.GetChar(game.Players.LocalPlayer,true)

local PlayerModule = Players.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")
local ControlModule = require(PlayerModule:WaitForChild("ControlModule"))

local function OnChar()
	player, plrgui, char, hum, root, animator, humdesc = C.GetChar(game.Players.LocalPlayer,true)
	C.RigType = "r6"
	if char:FindFirstChild("UpperTorso") then
		C.RigType = "r15"
	end
end
player.CharacterAdded:Connect(OnChar)
C.RigType = "r6"
if char:FindFirstChild("UpperTorso") then
	C.RigType = "r15"
end



-- Player by search - Looks into Players service and can find a player with a small input as a string.
function C.PlayerSearch(inp: string)
	inp = inp:lower()

	for _, target in ipairs(Players:GetPlayers()) do
		local name = target.Name:lower()
		local disName = target.DisplayName:lower()

		if name:sub(1, #inp) == inp or disName:sub(1, #inp) == inp then
			return target
		end
	end

	return nil
end



-- Player by type - Returns an array of players based on the type. Types are 1: all 2. others 3: me 4: random 5: nearest 6: farthest
function C.PlayerType(lplayer: Player, inp: string | number)
	inp = inp:lower()
	if inp == "all" or inp == 1 then
		return Players:GetPlayers()
	elseif inp == "others" or inp == "other" or inp == 2 then
		local players = Players:GetPlayers()
		table.remove(players, table.find(players, lplayer))
		return players
	elseif inp == "me" or inp == 3 then
		return {lplayer}
	elseif inp == "random" or inp == 4 then
		return Players:GetPlayers()[math.random(1,#Players:GetChildren())]
	elseif inp == "nearest" or inp == "near" or inp == 5 then
		local nearest = nil
		local nearestDistance = math.huge
		for _, player in ipairs(Players:GetPlayers()) do
			if player == lplayer then continue end
			local distance = (player.Character.HumanoidRootPart.Position - lplayer.Character.HumanoidRootPart.Position).Magnitude
			if distance < nearestDistance then
				nearest = player
				nearestDistance = distance
			end
		end
		return {nearest}
	elseif inp == "farthest" or inp == "far" or inp == 6 then
		local farthest = nil
		local farthestDistance = 0
		for _, player in ipairs(Players:GetPlayers()) do
			if player == lplayer then continue end
			local distance = (player.Character.HumanoidRootPart.Position - lplayer.Character.HumanoidRootPart.Position).Magnitude
			if distance > farthestDistance then
				farthest = player
				farthestDistance = distance
			end
		end
		return {farthest}
	else -- If all fails try to find a player with the name
		local target = C.PlayerSearch(inp)
		if target then
			return {target}
		end
		warn("Get player by type: No player founded by type/target:",inp)
		return nil
	end
end

-- Get single player type
function C.SinglePlayerType(lplayer: Player, inp: string)
	return C.PlayerType(lplayer,inp)[1]
end



-- UniQuit - Universal Quit makes every module in _G quit, and this module.
function C.UniQuit()
	warn("	FORCE QUITTING EVERYTHING!!!")
	for _, module in pairs(_G) do
		pcall(function()
			module.ForceQuit()
		end)
	end
	warn("	Ended :)")
end



-- Get args - Returns the args from a string with a given seperator.
function C.GetArgs(str: string, seperator: string)
	return str:split(seperator or " ")
end

-- Get command - Returns the command and args.
function C.GetCmd(str: string)
	local args = C.GetArgs(str)
	local cmd = args[1]
	table.remove(args,1)
	return cmd, args
end



-- Chat - Makes your local player chat in modern or legacy chat.
function C.Chat(msg: string)
	if C.ChatVersion == "Modern" then
		TCS.ChatInputBarConfiguration.TargetTextChannel:SendAsync(msg) -- Holy 1 liner?
	elseif C.ChatVersion == "Legacy" then
		ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
	end
end



-- Jays UI style 1
function C.JaysUIStyle(ui: Instance)
	--if not ui:IsA("Frame") then return end -- for thing.
	-- UI properties
	ui.BackgroundColor3 = Color3.new(0,0,0)
	ui.BackgroundTransparency = 0.15
	ui.BorderSizePixel = 0
	
	-- Modifiers
	local m = Instance.new("UICorner",ui)
	m.CornerRadius = UDim.new(0.1,0)
	
	m = Instance.new("UIStroke",ui)
	m.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	m.Color = Color3.new(1,1,1)
	m.Thickness = 3
	
	-- Text stuff
	if ui:IsA("TextLabel") or ui:IsA("TextBox") or ui:IsA("TextButton") then
		ui.TextColor3 = Color3.new(1,1,1)
		ui.TextScaled = true
		ui.Font = Enum.Font.SourceSans
		m = Instance.new("UIStroke",ui)
		m.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
		m.Color = Color3.new(0,0,0)
		m.Thickness = 3
	end
end
-- Test example and also how to use it I guess.
--local ui = C:GetChar().plrgui:WaitForChild("TestGui"):WaitForChild("Template0")
--C:JaysUIStyle(ui)



-- Random string generator
function C.RandomString(length: number)
	length = math.floor(length) -- Yes.
	local str = {}
	for i = 1, length do
		str[i] = string.char(math.random(33,126))
	end
	return table.concat(str)
end
--print(C:RandomString(100))
-- Random
local function TTU(a,b) -- Table To UDim2
	return UDim2.new(a[1],a[2],b[1],b[2])
end
C.TTU = TTU



-- BIS - Basic Input Service
local BIS = {}
C.BIS = BIS

-- Stuff
BIS.Active = false
BIS.Gui = nil
BIS.Box = nil



-- Methods
-- BIS - Stop - Stops the instance of BIS.
function BIS.Stop()
	if not BIS.Active then return end
	BIS.Active = false
	BIS.Gui:Destroy()
end

-- BIS - Start - Starts Basic Input Service by creating the frame and the textbox for basic input.
function BIS.Start(title: string, description: string, textplaceholder: string)
	if BIS.Active then
		BIS.Gui:Destroy()
	end
	title = title or "JS - Basic Input Service"
	description = description or "JaysScripts - Basic Input Service. A service for basic input."
	textplaceholder = textplaceholder or "Type something!"
	
	BIS.Active = true
	local gui = Instance.new("ScreenGui",C.GetChar().plrgui)
	BIS.Gui = gui
	gui.IgnoreGuiInset = true
	gui.Name = "BIS "..C.RandomString(20.67)
	
	local frame = Instance.new("Frame",gui)
	frame.AnchorPoint = Vector2.new(0.5,0.5)
	frame.Position = TTU({0.5, 0},{0.5, 0})
	frame.Size = TTU({0.6, 0},{0.6, 0})
	C.JaysUIStyle(frame)
	local m = Instance.new("UIAspectRatioConstraint",frame)
	m.AspectRatio = 1.8
	m.AspectType = Enum.AspectType.ScaleWithParentSize
	
	local titleIns = Instance.new("TextLabel",frame)
	titleIns.Position = TTU({0, 0},{0, 0})
	titleIns.Size = TTU({1, 0},{0.12, 0})
	C.JaysUIStyle(titleIns)
	titleIns:WaitForChild("UIStroke"):Destroy()
	titleIns:WaitForChild("UICorner"):Destroy()
	titleIns.BackgroundTransparency = 1
	titleIns.Text = title
	titleIns.TextScaled = true
	titleIns.TextColor3 = Color3.new(1,1,1)
	
	local desc = Instance.new("TextLabel",frame)
	desc.Position = TTU({0, 0},{0.119, 0})
	desc.Size = TTU({1, 0},{0.057, 0})
	C.JaysUIStyle(desc)
	desc:WaitForChild("UIStroke"):Destroy()
	desc:WaitForChild("UICorner"):Destroy()
	desc.BackgroundTransparency = 1
	desc.Text = description
	desc.TextScaled = true
	desc.TextColor3 = Color3.new(1,1,1)
	
	local box = Instance.new("TextBox",frame)
	box.Position = TTU({0, 0},{0.174, 0})
	box.Size = TTU({1, 0},{0.826, 0})
	C.JaysUIStyle(box)
	box:WaitForChild("UIStroke"):Destroy()
	box:WaitForChild("UICorner"):Destroy()
	box.BackgroundTransparency = 1
	box.PlaceholderText = textplaceholder
	task.delay(0,function()
		box.Text = ""
	end)
	box.TextScaled = true
	box.TextColor3 = Color3.new(1,1,1)
	
	box:CaptureFocus()
	box.FocusLost:Connect(function()
		BIS.Stop()
	end)
	
	return box, gui
end



-- Apply linear velocity (Forever has the velocity modifier until you delete it manually)
function C.ApplyLinVel(instonce: Instance, velocity: Vector3)
	local a = Instance.new("Attachment",instonce)
	local v = Instance.new("LinearVelocity",instonce)
	v.MaxForce = math.huge
	v.VectorVelocity = velocity
	v.Attachment0 = a
	return v, a
end

-- Once Linear Velocity
function C.OnceLinVel(instonce: Instance, velocity: Vector3)
	local v,a = C.ApplyLinVel(instonce,velocity)
	RunService.Heartbeat:Wait()
	a:Destroy()
	v:Destroy()
end

-- Apply angular velocity
function C.ApplyAngVel(instonce: Instance, velocity: Vector3)
	local a = Instance.new("Attachment",instonce)
	local v = Instance.new("AngularVelocity",instonce)
	v.MaxTorque = math.huge
	v.AngularVelocity = velocity
	v.Attachment0 = a
	return v, a
end

-- Once angular Velocity
function C.OnceAngVel(instonce: Instance, velocity: Vector3)
	local v,a = C.ApplyLinVel(instonce,velocity)
	RunService.Heartbeat:Wait()
	a:Destroy()
	v:Destroy()
end



-- Get movement vector
function C.GetMoveVector(vect: Vector3)
	vect = vect or Vector3.one
	vect *= ControlModule:GetMoveVector()
	return vect
end

--C.Conns.asd = RunService.Heartbeat:Connect(function()
--	if not ControlModule then return end
--	print(C:GetMoveVector(Vector3.new(0,0,1)))
--end)

-- Get movement vector camera - Combines GMV but with multiplied with camera.
function C.GetMoveVectorCam(vect: Vector3)
	local camCF = cam.CFrame
	local moveVect = C.GetMoveVector(vect)
	vect = vect or Vector3.one
	local f = Vector3.new(camCF.LookVector.X * vect.X, camCF.LookVector.Y * vect.Y,camCF.LookVector.Z*vect.Z).Unit
	local r = Vector3.new(camCF.RightVector.X*vect.X, camCF.RightVector.Y*vect.Y, camCF.RightVector.Z*vect.Z).Unit
	moveVect = (f * -moveVect.Z + r * moveVect.X)
	return moveVect	
end

-- Is key hold/down function
function C.IsKeyDown(key)
	if UIS.TextBoxFocused then return end
	if not key then warn("Enter in a key buhhh!") return end
	key = Enum.KeyCode[key] or nil
	if not key then return end
	key = UIS:IsKeyDown(key)
	return key
end



-- Animation
local AnimService = {}
C.AnimService = AnimService

AnimService.Track = nil



-- Stop animation
function AnimService.Stop()
	if AnimService.Track then
		AnimService.Track:Stop()
		AnimService.Track:Destroy()
		AnimService.Track = nil
	end
end

-- Play animation
function AnimService.PlayAnim(id: number)
	AnimService.Stop()
	
	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://" .. id
	
	AnimService.Track = animator:LoadAnimation(anim)
	AnimService.Track.Priority = Enum.AnimationPriority.Action4
	AnimService.Track:Play()
end

-- Play emote
function AnimService.PlayEmote(id: number) -- Why is there even a difference?
	-- Check if emote is already added
	if humdesc:GetEmotes()[tostring(id)] then
		hum:PlayEmote(tostring(id))
		return
	end
	
	-- Add emote
	humdesc:AddEmote(tostring(id),id)
	hum:PlayEmote(tostring(id))
end


-- Console
function C.ShowConsole()
	-- Check if the console is visible.
	local s, is = pcall(function()
		return StartGui:GetCore("DevConsoleVisible")
	end)
	
	-- Toggle visibility
	if s and is then
		StartGui:SetCore("DevConsoleVisible", false)
		return
	end
	StartGui:SetCore("DevConsoleVisible", true)
end



-- Apply Drag function
function C.ApplyDrag(guiObject)
	local dragging = false
	local dragInput, dragStart, startPos

	local function update(input)
		local delta = input.Position - dragStart
		guiObject.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end

	guiObject.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = guiObject.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	guiObject.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement 
			or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end



-- Jays UI Style 2
function C.JaysUI2(obj)
	--if typeof(obj)~="Frame"then warn("Given object is not a frame!")return end-- Force type checker!
	-- Standerd
	local m = nil
	obj.BackgroundColor3 = Color3.fromRGB(7,0,23)
	obj.BackgroundTransparency = 0.15
	m = Instance.new("UICorner",obj)
	m.CornerRadius = UDim.new(1,0)
	m = Instance.new("UIStroke",obj)
	m.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	m.Color = Color3.new(1,1,1)
	m.Thickness = 3
	m.Transparency = 0.1
	
	-- Texts
	if obj.Text ~= nil then
		obj.TextColor3 = Color3.new(1,1,1)
		obj.TextScaled = true
		obj.Font = Enum.Font.SourceSans
		m = Instance.new("UIStroke",obj)
		m.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
		m.Color = Color3.new(1,1,1)
		m.Thickness = 2
		m.Transparency = 0.9
	end
end



-- UI... (For the future. Seperate project!)
--local UIService = {}
--C.UIService = UIService

--function UIService.init_instance(obj)
--	local self = {}
--	self.Instance = obj
--	self.
--end



local CLS = {} -- Chat Listener
C.CLS = CLS
CLS.Folder = nil
CLS.PlayersHooked = {} -- Has Bindable events so other scripts can use!!! And a connection to that player.
CLS.HookedAllConn = nil
--[[
CLS.PlayersHooked.MrBeast = {
	b = BindableEvent
	c = Connection
}
]]



-- Methods!!!

function CLS.HandleFolderment()
	if not CLS.Folder then
		CLS.Folder = Instance.new("Folder",ReplicatedStorage)
		CLS.Folder.Name = "CLS_HPS_Events"
	end
	return CLS.Folder
end

--[[ Hook player - Will listen for when the player chats in, the chat.
Returns a BindableEvent that you can use.
Also the bindable events are in a folder called "CLS_HPS_Events" in repli-storage
]]
function CLS.HookPlayer(player)
	local fold = CLS.HandleFolderment()
	
	-- Check if the player already exists in HookedPlayers, therefore do nothing.
	if CLS.PlayersHooked[player] then return end
	
	-- The main stuff, bindables
	local b = Instance.new("BindableEvent",fold)
	local c = nil
	local c0 = nil
	b.Name = player.Name
	
	-- Firing the bindable event
	if C.ChatVersion == "Modern" then
		c = TCS.MessageReceived:Connect(function(i)
			local target = Players:GetPlayerByUserId(i.TextSource.UserId) or nil
			if not i.TextSource or target ~= player then return end
			local msg = i.Text
			b:Fire(msg,target)
		end)
	else
		c = player.Chatted:Connect(function(msg)
			b:Fire(msg,player)
		end)
	end
	
	-- When player leaves disconnect any connections
	c0 = Players.PlayerRemoving:Connect(function(player)
		if player.Name ~= b.Name then return end
		b:Destroy()
		c:Disconnect()
		c0:Disconnect()
	end)
	
	-- Store the player in HookedPlayers
	CLS.PlayersHooked[player] = {
		b = b,
		c = c,
		c0 = c0
	}
	
	return b, c, fold
end

--[[ Unhook player - Unhooks the player and disconnects all connections.
Deletes the bindable event and deletes the player from HookedPlayers.
]]
function CLS.UnhookPlayer(player)
	local fold = CLS.HandleFolderment()
	
	if not CLS.PlayersHooked[player] then return end
	
	local b = CLS.PlayersHooked[player].b
	local c = CLS.PlayersHooked[player].c
	local c0 = CLS.PlayersHooked[player].c0
	
	b:Destroy()
	c:Disconnect()
	c0:Disconnect()
end



--[[ Hooks every player and bundles all messages into 1 bindable event.]]
function CLS.HookAll()
	local fold = CLS.HandleFolderment()
	
	if CLS.HookedAllConn then return end
	
	local b = Instance.new("BindableEvent",fold)
	b.Name = "HookedAll"
	
	if C.ChatVersion == "Modern" then
		CLS.HookedAllConn = TCS.MessageReceived:Connect(function(i)
			local target = Players:GetPlayerByUserId(i.TextSource.UserId)
			if not i.TextSource or not Players:FindFirstChild(target.Name) then return end
			local msg = i.Text
			
			b:Fire(msg,target)
			
			--print("Message:",msg)
			--print("Player:",target.Name)
		end)
	else
		CLS.HookedAllConn = {} -- Contains all connections for each player
		-- Loop all players
		for _, player in pairs(Players:GetPlayers()) do
			CLS.HookedAllConn[player.Name] = player.Chatted:Connect(function(msg)
				b:Fire(msg,player)
			end)
		end
		
		-- Add new players and remove players if leaves
		Players.PlayerAdded:Connect(function(player)
			CLS.HookedAllConn[player.Name] = player.Chatted:Connect(function(msg)
				b:Fire(msg,player)
			end)
		end)
		Players.PlayerRemoving:Connect(function(player)
			CLS.HookedAllConn[player.Name]:Disconnect()
			CLS.HookedAllConn[player.Name] = nil
		end)
	end
	
	return b, CLS.HookedAllConn, fold
end


--local bind = CLS.HookPlayer(player)

--bind.Event:Connect(function(msg, player)
--	print("Message:",msg)
--	print("Player:",player.Name)
--end)