if UnitFactionGroup("player") ~= "Horde" then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("King Grong", 2070, 2325)
if not mod then return end
mod:RegisterEnableMob(147268)
mod.engageId = 2263
--mod.respawnTime = 31

--------------------------------------------------------------------------------
-- Locals
--

local addCount = 1

--------------------------------------------------------------------------------
-- Localization
--

--local L = mod:GetLocale()
--if L then
--
--end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Grong ]]--
		281936, -- Tantrum
		282082, -- Bestial Combo
		{285671, "TANK"}, -- Crushed
		{285875, "TANK"}, -- Rending Bite
		289401, -- Bestial Throw
		282179, -- Reverberating Slam
		285994, -- Ferocious Roar
		--[[ Flying Ape Wranglers  ]]--
		--{282215, "SAY"}, -- Megatomic Seeker Missile
		--[[ Apetaganizer 3000 ]]--
		282247, -- Apetagonizer 3000 Bomb
		282243, -- Apetagonize
		285659, -- Apetagonizer Core
		285660, -- Discharge Apetagonizer Core
	}
end

function mod:OnBossEnable()
	--[[ Grong ]]--
	self:Log("SPELL_CAST_START", "Tantrum", 281936)
	self:Log("SPELL_CAST_SUCCESS", "BestialCombo", 282082)
	self:Log("SPELL_AURA_APPLIED", "CrushedApplied", 285671)
	self:Log("SPELL_AURA_APPLIED_DOSE", "CrushedApplied", 285671)
	self:Log("SPELL_AURA_APPLIED", "RendingBiteApplied", 285875)
	self:Log("SPELL_AURA_APPLIED_DOSE", "RendingBiteApplied", 285875)
	self:Log("SPELL_CAST_SUCCESS", "BestialThrow", 289401)
	self:Log("SPELL_CAST_SUCCESS", "BestialThrowTarget", 289307)
	self:Log("SPELL_CAST_SUCCESS", "ReverberatingSlam", 282179)
	self:Log("SPELL_CAST_START", "FerociousRoar", 285994)

	--[[ Flying Ape Wranglers  ]]--
	--self:Log("SPELL_CAST_SUCCESS", "MegatomicSeekerMissile", 282215) XXX Check what we can do with this
	--[[ Apetaganizer 3000 ]]--
	self:Log("SPELL_CAST_SUCCESS", "Apetagonizer3000Bomb", 282247)
	self:Log("SPELL_CAST_START", "Apetagonize", 282243)
	self:Log("SPELL_AURA_APPLIED", "ApetagonizerCore", 285659)
	self:Log("SPELL_CAST_START", "DischargeApetagonizerCore", 285660)
end

function mod:OnEngage()
	addCount = 1
	self:Bar(282179, 13.1) -- Reverberating Slam
	self:Bar(282247, 16.8, CL.count:format(CL.add, addCount)) -- Apetagonizer 3000 Bomb, Add
	self:Bar(282082, 22)	-- Bestial Combo
	self:Bar(285994, 37.5) -- Ferocious Roar
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Tantrum(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
	self:CastBar(args.spellId, 5) -- 1s + 4s Channel
end

function mod:BestialCombo(args)
	self:Bar(args.spellId, 30.5)
end

function mod:CrushedApplied(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "purple")
	self:PlaySound(args.spellId, "alarm", nil, args.destName)
end

function mod:RendingBiteApplied(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "purple")
	self:PlaySound(args.spellId, "alert", nil, args.destName)
end

function mod:BestialThrow(args)
	self:Bar(args.spellId, 30.5)
end

function mod:BestialThrowTarget(args)
	self:TargetMessage2(289401, "purple", args.destName)
	self:PlaySound(289401, "alarm")
end

function mod:ReverberatingSlam(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 29)
end

function mod:FerociousRoar(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
	self:Bar(args.spellId, 36.5)
end

--function mod:MegatomicSeekerMissile(args)
--	self:TargetMessage2(args.spellId, "orange", args.destName)
--	self:PlaySound(args.spellId, "alarm")
--	if self:Me(args.destGUID) then
--		self:Say(args.spellId)
--	end
--	self:Bar(args.spellId, 23.1)
--end

function mod:Apetagonizer3000Bomb(args)
	self:Message2(args.spellId, "yellow", CL.incoming:format(CL.count:format(CL.add, addCount)))
	self:PlaySound(args.spellId, "long")
	addCount = addCount + 1
	self:Bar(args.spellId, 60.5, CL.count:format(CL.add, addCount))
end

function mod:Apetagonize(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
end

function mod:ApetagonizerCore(args)
	self:TargetMessage2(args.spellId, "green", args.destName, args.spellName)
end

function mod:DischargeApetagonizerCore(args)
	self:Message2(args.spellId, "green")
	self:PlaySound(args.spellId, "info")
end