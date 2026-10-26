-- Open-space freighters.
-- This file runs at the end of designersdefs.lua, before ai.FixupEntityDefs,
-- so an explicit field on the def wins over inherit.
--
-- Quest freighters only: cruise speed 170 m/s.
-- CargoShip.max_lin_speed is 10 m/s. The SC-120288 leaves set 7 m/s.
-- Escort fighters (names with Escort or Guard) are left alone.
-- Maneuverability is the stock CargoShip turn rate, 10 deg/s, times 2.2
-- (22 deg/s). The SC-120288 value of 7 is that stock rate reduced, so it
-- is not the base. At 170 m/s and 22 deg/s the route radius is about 440 m.
-- Stock radius at 10 m/s and 10 deg/s is about 57 m.
--
-- Any freighter, quest or not: one location equipment container on kill.
-- Location containers are DedicatedServerServices_SetIterativeLoot.
-- Each map's entry [1] is that map's LootCrate (modules from Loot_*_ranks_*).
-- dropCounter is 1 point. loot_increments[1] is how many points a kill adds
-- for the player who gets credit. 1 point always crosses the threshold,
-- so the kill drops exactly one container from the current location pool.
-- A freighter is a def whose inherit chain reaches CargoShip, or whose
-- object_tag is TRANSPORT. Index [2] is left as authored.

local QUEST_TRANSPORT_SPEED = 170
local CARGO_ROT_SPEED = 10
local QUEST_TRANSPORT_ROT_MUL = 2.2
local TRANSPORT_LOOT_POINTS = 1

local function isQuestTransport(name)
	if type(name) ~= "string" then
		return false
	end
	if not string.find(name, "Quest", 1, true) then
		return false
	end
	if not string.find(name, "Transport", 1, true) then
		return false
	end
	if string.find(name, "Escort", 1, true) then
		return false
	end
	if string.find(name, "Guard", 1, true) then
		return false
	end
	return true
end

local cargoMemo = {}

local function isCargoDef(name, def)
	local cached = cargoMemo[name]
	if cached ~= nil then
		return cached
	end
	cargoMemo[name] = false
	local yes = false
	if type(def) == "table" then
		if def.class == "CargoShip" or def.object_tag == ai.ObjectTag.TRANSPORT then
			yes = true
		elseif type(def.inherit) == "string" then
			local parent = Def[def.inherit]
			if type(parent) == "table" and isCargoDef(def.inherit, parent) then
				yes = true
			end
		end
	end
	cargoMemo[name] = yes
	return yes
end

local function giveLocationContainer(def)
	if type(def.loot_increments) ~= "table" then
		def.loot_increments = {}
	end
	def.loot_increments[1] = TRANSPORT_LOOT_POINTS
end

local speedCount = 0
local lootCount = 0
for name, def in pairs(Def) do
	if type(def) == "table" then
		if isQuestTransport(name) then
			def.max_lin_speed = QUEST_TRANSPORT_SPEED
			def.max_rot_speed = CARGO_ROT_SPEED * QUEST_TRANSPORT_ROT_MUL
			speedCount = speedCount + 1
		end
		if isCargoDef(name, def) then
			giveLocationContainer(def)
			lootCount = lootCount + 1
		end
	end
end

if sys and sys.out then
	sys.out("ow quest transport speed %d m/s, rot %g deg/s on %d defs, location container on %d transports", QUEST_TRANSPORT_SPEED, CARGO_ROT_SPEED * QUEST_TRANSPORT_ROT_MUL, speedCount, lootCount)
end
