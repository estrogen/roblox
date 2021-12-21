local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Boku No Roblox by ally#0234 | Feminine on V3R", "Midnight")
local Main = Window:NewTab("Farming")
local MainSection = Main:NewSection("Auto Farm")
local Auto = Window:NewTab("Auto")
local AutoSection = Auto:NewSection("Auto Stats")
local Misc = Window:NewTab("Misc")
local MiscSection = Misc:NewSection("Miscellaneous")

-- Configuration
getgenv().SelectedEnemy = ""
getgenv().xDistance = 30
getgenv().zDistance = 0
getgenv().Delay = 0.5
getgenv().AutoFarm = false
getgenv().AutoQuest = false
getgenv().DisableTeleport = false

-- Quests
local Quests = {
	-- Defeat Villains
	["Criminal"] = {"Injured Man", "15/15"},
	["Weak Villain"] = {"Aizawa", "15/15"},
	["Villain"] = {"Hero", "15/15"},
	["Weak Nomu 1"] = {"Jeanist", "15/15"},
	["Weak Nomu 2"] = {"Jeanist", "15/15"},
	["Weak Nomu 3"] = {"Jeanist", "15/15"},
	["Weak Nomu 4"] = {"Jeanist", "15/15"},
	["High End 1"] = {"Mirko", "15/15"},
	["High End 2"] = {"Mirko", "15/15"},

	-- Defeat Heros
	["Police"] = {"Gang Member", "15/15"},
	["UA Student"] = {"Suspicious Character", "15/15"},
	["UA Student 2"] = {"Suspicious Character", "15/15"},
	["UA Student 3"] = {"Suspicious Character", "15/15"},
	["UA Student 4"] = {"Suspicious Character", "15/15"},
	["UA Student 5"] = {"Suspicious Character", "15/15"},
	["Forest Beast"] = {"Twice", "15/15"},
	["Pro Hero 1"] = {"Toga", "15/15"},
	["Pro Hero 2"] = {"Toga", "15/15"},
	["Pro Hero 3"] = {"Toga", "15/15"},
}

-- Selected Abilities
local Keys = {
	Q = false,
	Z = false,
	X = false,
	C = false,
	V = false,
	F = false,
	E = false,
}

-- Selected Auto Stats
local Stats = {
	Str = false,
	Agi = false,
	Dur = false,
}

-- Npc Storage
local AllNPCS = {
	Villains = {},
	Heros = {},
	All = {}
}

function contains(table, key)
    for _, value in pairs(table) do
        if value == key then return true end
    end
    return false
end

-- Dynamically Get NPCS START

for _, npc in pairs(game.Workspace.NPCs:GetChildren()) do
	local fame = game.Workspace.NPCs[npc.Name].Fame.Value
	if fame > 0 then
		if not contains(AllNPCS.Heros, npc.Name) then
			table.insert(AllNPCS.Heros, npc.Name)
		end
	else
		if not contains(AllNPCS.Villains, npc.Name) then
			table.insert(AllNPCS.Villains, npc.Name)
		end
	end
end

for _, v in pairs({"Villains", "Heros"}) do
    table.insert(AllNPCS.All, "-- "..v.." --")
    for _, npc in pairs(AllNPCS[v]) do
        table.insert(AllNPCS.All, npc)
    end
end

-- Dynamically Get NPCS END

-- Questing Functions START

function AcceptQuest(args)
	game.ReplicatedStorage.Remotes.Quest.AcceptQuest:FireServer(unpack(args))
end

function CompleteQuest(args)
	game.ReplicatedStorage.Remotes.Quest.CompleteQuest:FireServer(unpack(args))
end

function AbortQuest(args)
	game.ReplicatedStorage.Remotes.Quest.CancelQuest:FireServer("CancelQuestScript")
end

-- Questing Functions END

-- Auto Farm Functions START

function GetCooldown(Key)
	local cooldown = game.Players.LocalPlayer.PlayerGui.CooldownGui.Main[Key].Timer.Text
	return (cooldown) and cooldown or "0.0s"
end

function UseSkill(Key, Enemy)
	local descendants = game.Players.LocalPlayer.Character:GetDescendants()
	for _, descendant in pairs(descendants) do
		if descendant.Name == Key then
			if Key == "E" then
				descendant:FireServer()
				wait(0.1)
			else
				if contains({"0.0s", "0.1s"}, GetCooldown(Key)) then
					descendant:FireServer(Vector3.new(Enemy.x, Enemy.y, Enemy.z))
				end
			end
		end
	end
	wait(0.3)
end

function AutoFarm(NpcCFrame)
	if not getgenv().DisableTeleport then
		local EnemyPosition = Vector3.new(NpcCFrame.x, NpcCFrame.y, NpcCFrame.z)
		local NewCFrame = CFrame.new(EnemyPosition + Vector3.new(getgenv().xDistance, 1, getgenv().zDistance), EnemyPosition)
		local tween = game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(getgenv().Delay), {CFrame = NewCFrame})
		tween:Play()
		tween.Completed:Wait(_)
	end
	for key, bool in pairs(Keys) do
		if bool then
			UseSkill(key, NpcCFrame)
		end
	end
end

-- Auto Farm Functions END

-- Main Section START

	-- Attack Methods START

	MainSection:NewToggle("Use Q", "Uses Q Skill", function(ref) Keys.Q = ref end)
	MainSection:NewToggle("Use Z", "Uses Z Skill", function(ref) Keys.Z = ref end)
	MainSection:NewToggle("Use X", "Uses X Skill", function(ref) Keys.X = ref end)
	MainSection:NewToggle("Use C", "Uses C Skill", function(ref) Keys.C = ref end)
	MainSection:NewToggle("Use V", "Uses V Skill", function(ref) Keys.V = ref end)
	MainSection:NewToggle("Use F", "Uses F Skill", function(ref) Keys.F = ref end)
	MainSection:NewToggle("Use Melee", "Uses equipped Melee weapon", function(ref) Keys.E = ref end)

	-- Attack Methods END

	-- Auto Farm Config START

	MainSection:NewSlider("X Distance", "Distance from the Npc on X Axis", 250, 0, function(ref) getgenv().xDistance = ref end)
	MainSection:NewSlider("Z Distance", "Distance from the Npc on Z Axis", 250, 0, function(ref) getgenv().zDistance = ref end)
	MainSection:NewSlider("MS Delay", "How long it'll take to tween", 5000, 0, function(ref) getgenv().Delay = ref/1000 end)
	MainSection:NewDropdown("Npcs", "All Npcs you can auto farm", AllNPCS.All, function(ref) getgenv().SelectedEnemy = ref end)
	MainSection:NewToggle("Auto Quest", "Auto accepts Quests while Auto Farming", function(ref) getgenv().AutoQuest = ref end)
	MainSection:NewToggle("Disable Teleport", "Disables Auto Farming teleporting.", function(ref) getgenv().DisableTeleport = ref end)
	MainSection:NewToggle("Auto Farm", "Auto Farms using the choosen skills", function(ref)
		getgenv().AutoFarm = ref
		while wait() and getgenv().AutoFarm do
			local Player = game.Players.LocalPlayer
			if Player.Character ~= nil then
				for _, npc in pairs(game.Workspace.NPCs:GetChildren()) do
					spawn(function()
						if npc.Name == getgenv().SelectedEnemy then
							if npc ~= nil and npc.HumanoidRootPart ~= nil then
								if getgenv().AutoQuest then
									if Quests[getgenv().SelectedEnemy] then
										local QuestObjective = Player.PlayerGui.QuestGui.QuestObjectives.NPCName.Text
										local QuestProgress = Player.PlayerGui.QuestGui.QuestObjectives.KilledAmount.Text
										if QuestProgress == Quests[getgenv().SelectedEnemy][2] then
											CompleteQuest({[1] = Quests[getgenv().SelectedEnemy][1], [2] = "Quest"})
										elseif QuestProgress == "" then
											AcceptQuest({[1] = Quests[getgenv().SelectedEnemy][1], [2] = "Quest"})
										elseif QuestObjective == "" then
											AbortQuest()
										end
									end
								end

								AutoFarm(npc.HumanoidRootPart.CFrame)
							end
						end
					end)
				end
			end
		end
	end)

	-- Auto Farm Config END

-- Main Section END

-- Auto Section START

AutoSection:NewToggle("Auto Strength", "Applies points into Strength Automatically", function(ref) Stats.Str = ref end)
AutoSection:NewToggle("Auto Agility", "Applies points into Agility Automatically", function(ref) Stats.Agi = ref end)
AutoSection:NewToggle("Auto Durability", "Applies points into Durability Automatically", function(ref) Stats.Dur = ref end)
AutoSection:NewToggle("Auto Apply Stats", "Auto Apply Selected Stats", function(ref)
	while wait() and ref do
		spawn(function()
			local points = tonumber(game.Players.LocalPlayer.PlayerGui.MainMenus.StatsPage.AvalPointsFrame.Points.Text)
			if points > 0 then
				if Stats.Str then
					game.ReplicatedStorage.Remotes.Strength:FireServer(1)
				end
				if Stats.Agi then
					game.ReplicatedStorage.Remotes.Agility:FireServer(1)
				end
				if Stats.Dur then
					game.ReplicatedStorage.Remotes.Durability:FireServer(1)
				end
			end
			wait(0.2)
		end)
	end
end)

-- Auto Section END

-- Misc Section START

MiscSection:NewKeybind("Menu Key", "Key to open and close the menu", Enum.KeyCode.RightShift, function() Library:ToggleUI() end)
MiscSection:NewTextBox("Spoof Nametag", "Name you want your nametag to spoof too", function(txt)
	game.Workspace[game.Players.LocalPlayer.Name].Head.OverHead.OverheadBase.nametag.Text = txt
end)

-- Misc Section END

-- Credits
game.Workspace[game.Players.LocalPlayer.Name].Head.OverHead.OverheadBase.nametag.Text = "Boku No Roblox by ally"
print("Boku No Roblox by ally")
