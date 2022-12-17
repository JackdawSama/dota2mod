-- Generated from template

if CAddonTemplateGameMode == nil then
	CAddonTemplateGameMode = class({})
end

require("game_setup")

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
end

require("game_setup")

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = CAddonTemplateGameMode()
	GameRules.AddonTemplate:InitGameMode()
end

function CAddonTemplateGameMode:InitGameMode()
	print( "Template addon is loaded." )
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )

	GameSetup : init()

	--CreateUnitByName("npc_dota_hero_lina", Vector(1800, 1800, 0), true, nil, nil, DOTA_TEAM_BADGUYS)
end

-- Evaluate the state of the game
function CAddonTemplateGameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

-- sets the player to level 3 and enables all abilities
ListenToGameEvent("npc_spawned", function(event)
    local unit = EntIndexToHScript(event.entindex)
    --only want to apply levels on first spawn
    if event.is_respawn == 1 then return end
    if unit and unit:IsRealHero() and unit:GetTeam() == DOTA_TEAM_GOODGUYS then
        while unit:GetLevel() < 3 do 						--hard coding level here
            --true/false to play level up sound and particle
            unit:HeroLevelUp(false)
        end
        --level up their abilities
        --index 0 thru 5 are q,w,e,d,f,r
        for i=0,4 do
            local abil = unit:GetAbilityByIndex(i)
            if abil then
                abil:SetLevel(1)
            end
        end
        --remove their excess ability points gotten from forced leveling up
        unit:SetAbilityPoints(0)
    end
end, nil)

-- lose state. You lose when you die
ListenToGameEvent("entity_killed", function(event)
    local unit = EntIndexToHScript(event.entindex_killed)
    if unit and unit:IsRealHero() and unit:GetTeam() == DOTA_TEAM_GOODGUYS then
        --local enemyTeam = unit:GetOpposingTeamNumber()
        GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
    end
end, nil)

ListenToGameEvent("dota_player_gained_level", function(event)
	print("LEVEL UP")
	local unit = EntIndexToHScript(event.hero_entindex)
		if unit and unit:GetLevel() == 16 then
			GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
		end
end, nil)

ENEMY_MAX_LVL = 3
ABILITY_MAX_LEVEL = 1

-- spawn enemies every 15s
require("timers")

Timers:CreateTimer( 40.0, function()
	for i = 0, 5 do
		print( "Creep Spawned.")
		CreateUnitByName("npc_dota_creature_skeletons", Vector(960, 820, 0)+ RandomVector(100), true, nil, nil, DOTA_TEAM_BADGUYS)
	end
	return 8
end
)

Timers:CreateTimer( 60.0, function()
	ABILITY_MAX_LEVEL = ABILITY_MAX_LEVEL + 1
	return nil
end
)

Timers:CreateTimer( 240.0, function()
	ABILITY_MAX_LEVEL = ABILITY_MAX_LEVEL + 1
	return nil
end
)

Timers:CreateTimer( 360.0, function()
	ABILITY_MAX_LEVEL = ABILITY_MAX_LEVEL + 1
	return nil
end
)

Timers:CreateTimer( 480.0, function()
	ABILITY_MAX_LEVEL = ABILITY_MAX_LEVEL + 1
	return nil
end
)

--first instance of enemy LUNA
Timers:CreateTimer( 75.0, function()
	print( "LUNA!!")
	CreateUnitByName("npc_dota_hero_luna", Vector(190, 1, 0), true, nil, nil, DOTA_TEAM_BADGUYS)

	ListenToGameEvent("npc_spawned", function(event)
		local unit = EntIndexToHScript(event.entindex)
		--only want to apply levels on first spawn
		if event.is_respawn == 1 then return end
		if unit and unit:IsRealHero() then --and unit:GetTeam() == DOTA_TEAM_BADGUYS
			while unit:GetLevel() < ENEMY_MAX_LVL do 						--hard coding level here
				--true/false to play level up sound and particle
				unit:HeroLevelUp(false)
			end
			--level up their abilities
			--index 0 thru 5 are q,w,e,d,f,r
			for i=0,5 do
				local abil = unit:GetAbilityByIndex(i)
				if abil then
					abil:SetLevel(ABILITY_MAX_LEVEL)
				end
			end
			--remove their excess ability points gotten from forced leveling up
			unit:SetAbilityPoints(0)
			unit:SetRespawnsDisabled(true)
		end
	end, nil)

	ENEMY_MAX_LVL = ENEMY_MAX_LVL + 2;
	return nil
end
)

--first instance of enemy MIRANA
Timers:CreateTimer( 150.0, function()
	print( "MIRANA!!")
	CreateUnitByName("npc_dota_hero_mirana", Vector(190, 1, 0), true, nil, nil, DOTA_TEAM_BADGUYS)

	ListenToGameEvent("npc_spawned", function(event)
		local unit = EntIndexToHScript(event.entindex)
		--only want to apply levels on first spawn
		if event.is_respawn == 1 then return end
		if unit and unit:IsRealHero() and unit:GetTeam() == DOTA_TEAM_BADGUYS then
			while unit:GetLevel() < ENEMY_MAX_LVL do 						--hard coding level here
				--true/false to play level up sound and particle
				unit:HeroLevelUp(false)
			end
			--level up their abilities
			--index 0 thru 5 are q,w,e,d,f,r
			for i=0,5 do
				local abil = unit:GetAbilityByIndex(i)
				if abil then
					abil:SetLevel(ABILITY_MAX_LEVEL)
				end
			end
			--remove their excess ability points gotten from forced leveling up
			unit:SetAbilityPoints(0)
			unit:SetRespawnsDisabled(true)
		end
	end, nil)
	
	ENEMY_MAX_LVL = ENEMY_MAX_LVL + 1;
	return nil
end
)

--first instance of enemy DK
Timers:CreateTimer( 420.0, function()
	print( "DRAGON KNIGHT!!")
	CreateUnitByName("npc_dota_hero_dragon_knight", Vector(190, 1, 0), true, nil, nil, DOTA_TEAM_BADGUYS)

	ListenToGameEvent("npc_spawned", function(event)
		local unit = EntIndexToHScript(event.entindex)
		--only want to apply levels on first spawn
		if event.is_respawn == 1 then return end
		if unit and unit:IsRealHero() and unit:GetTeam() == DOTA_TEAM_BADGUYS then
			while unit:GetLevel() < ENEMY_MAX_LVL do 						--hard coding level here
				--true/false to play level up sound and particle
				unit:HeroLevelUp(false)
			end
			--level up their abilities
			--index 0 thru 5 are q,w,e,d,f,r
			for i=0,5 do
				local abil = unit:GetAbilityByIndex(i)
				if abil then
					abil:SetLevel(ABILITY_MAX_LEVEL)
				end
			end
			--remove their excess ability points gotten from forced leveling up
			unit:SetAbilityPoints(0)
			--sets respawn to false
			unit:SetRespawnsDisabled(true)
		end
	end, nil)
	
	ENEMY_MAX_LVL = ENEMY_MAX_LVL + 2;
	return nil
end
)

--second instance of enemy LUNA
Timers:CreateTimer( 600.0, function()
	print( "LUNA!!")
	CreateUnitByName("npc_dota_hero_luna", Vector(190, 1, 0), true, nil, nil, DOTA_TEAM_BADGUYS)

	ListenToGameEvent("npc_spawned", function(event)
		local unit = EntIndexToHScript(event.entindex)
		--only want to apply levels on first spawn
		if event.is_respawn == 1 then return end
		if unit and unit:IsRealHero() and unit:GetTeam() == DOTA_TEAM_BADGUYS then
			while unit:GetLevel() < ENEMY_MAX_LVL do 						--hard coding level here
				--true/false to play level up sound and particle
				unit:HeroLevelUp(false)
			end
			--level up their abilities
			--index 0 thru 5 are q,w,e,d,f,r
			for i=0,5 do
				local abil = unit:GetAbilityByIndex(i)
				if abil then
					abil:SetLevel(ABILITY_MAX_LEVEL)
				end
			end
			--remove their excess ability points gotten from forced leveling up
			unit:SetAbilityPoints(0)

			unit:SetRespawnsDisabled(true)
		end
	end, nil)

	ENEMY_MAX_LVL = ENEMY_MAX_LVL + 3;
	return nil
end
)

--second instance of enemy DK
Timers:CreateTimer( 780.0, function()
	print( "DRAGON KNIGHT!!")
	CreateUnitByName("npc_dota_hero_dragon_knight", Vector(190, 1, 0), true, nil, nil, DOTA_TEAM_BADGUYS)

	ListenToGameEvent("npc_spawned", function(event)
		local unit = EntIndexToHScript(event.entindex)
		--only want to apply levels on first spawn
		if event.is_respawn == 1 then return end
		if unit and unit:IsRealHero() and unit:GetTeam() == DOTA_TEAM_BADGUYS then
			while unit:GetLevel() < ENEMY_MAX_LVL do 						--hard coding level here
				--true/false to play level up sound and particle
				unit:HeroLevelUp(false)
			end
			--level up their abilities
			--index 0 thru 5 are q,w,e,d,f,r
			for i=0,5 do
				local abil = unit:GetAbilityByIndex(i)
				if abil then
					abil:SetLevel(ABILITY_MAX_LEVEL)
				end
			end
			--remove their excess ability points gotten from forced leveling up
			unit:SetAbilityPoints(0)

			unit:SetRespawnsDisabled(true)
		end
	end, nil)
	
	ENEMY_MAX_LVL = ENEMY_MAX_LVL + 3;
	return nil
end
)

Timers:CreateTimer( 1080.0, function()
	print( "MIRANA!!")
	CreateUnitByName("npc_dota_hero_mirana", Vector(190, 1, 0), true, nil, nil, DOTA_TEAM_BADGUYS)

	ListenToGameEvent("npc_spawned", function(event)
		local unit = EntIndexToHScript(event.entindex)
		--only want to apply levels on first spawn
		if event.is_respawn == 1 then return end
		if unit and unit:IsRealHero() and unit:GetTeam() == DOTA_TEAM_BADGUYS then
			while unit:GetLevel() < ENEMY_MAX_LVL do 						--hard coding level here
				--true/false to play level up sound and particle
				unit:HeroLevelUp(false)
			end
			--level up their abilities
			--index 0 thru 5 are q,w,e,d,f,r
			for i=0,5 do
				local abil = unit:GetAbilityByIndex(i)
				if abil then
					abil:SetLevel(ABILITY_MAX_LEVEL)
				end
			end
			--remove their excess ability points gotten from forced leveling up
			unit:SetAbilityPoints(0)

			unit:SetRespawnsDisabled(true)
		end
	end, nil)
	
	ENEMY_MAX_LVL = ENEMY_MAX_LVL + 4;
	return nil
end
)

Timers:CreateTimer( 1200.0, function()
	print( "LUNA!!")
	CreateUnitByName("npc_dota_hero_luna", Vector(190, 1, 0), true, nil, nil, DOTA_TEAM_BADGUYS)

	ListenToGameEvent("npc_spawned", function(event)
		local unit = EntIndexToHScript(event.entindex)
		--only want to apply levels on first spawn
		if event.is_respawn == 1 then return end
		if unit and unit:IsRealHero() and unit:GetTeam() == DOTA_TEAM_BADGUYS then
			while unit:GetLevel() < ENEMY_MAX_LVL do 						--hard coding level here
				--true/false to play level up sound and particle
				unit:HeroLevelUp(false)
			end
			--level up their abilities
			--index 0 thru 5 are q,w,e,d,f,r
			for i=0,5 do
				local abil = unit:GetAbilityByIndex(i)
				if abil then
					abil:SetLevel(ABILITY_MAX_LEVEL)
				end
			end
			--remove their excess ability points gotten from forced leveling up
			unit:SetAbilityPoints(0)

			unit:SetRespawnsDisabled(true)
		end
	end, nil)

	ENEMY_MAX_LVL = ENEMY_MAX_LVL + 5;
	return nil
end
)

Timers:CreateTimer( 1380.0, function()
	print( "DRAGON KNIGHT!!")
	CreateUnitByName("npc_dota_hero_dragon_knight", Vector(190, 1, 0), true, nil, nil, DOTA_TEAM_BADGUYS)

	ListenToGameEvent("npc_spawned", function(event)
		local unit = EntIndexToHScript(event.entindex)
		--only want to apply levels on first spawn
		if event.is_respawn == 1 then return end
		if unit and unit:IsRealHero() and unit:GetTeam() == DOTA_TEAM_BADGUYS then
			while unit:GetLevel() < ENEMY_MAX_LVL do 						--hard coding level here
				--true/false to play level up sound and particle
				unit:HeroLevelUp(false)
			end
			--level up their abilities
			--index 0 thru 5 are q,w,e,d,f,r
			for i=0,5 do
				local abil = unit:GetAbilityByIndex(i)
				if abil then
					abil:SetLevel(ABILITY_MAX_LEVEL)
				end
			end
			--remove their excess ability points gotten from forced leveling up
			unit:SetAbilityPoints(0)

			unit:SetRespawnsDisabled(true)
		end
	end, nil)
	
	ENEMY_MAX_LVL = ENEMY_MAX_LVL + 6;
	return nil
end
)