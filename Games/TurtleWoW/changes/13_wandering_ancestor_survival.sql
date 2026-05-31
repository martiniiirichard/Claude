-- Patch: Add Survival profession to The Wandering Ancestor (entry 65022)
-- Applied: 2026-05-25
-- Source: Sylvan Gemcrafter (entry 22220) -- the only Survival trainer in the DB.
-- Spell 30219 = Apprentice Survival (reqskill 0, reqskillvalue 0) -- skill unlock
-- Spell 30223 = Journeyman Survival (reqskillvalue 50)
-- Spell 30225 = Expert Survival      (reqskillvalue 125)
-- Spell 30227 = Artisan Survival     (reqskillvalue 200)

INSERT IGNORE INTO npc_trainer
  (entry, spell, spellcost, reqskill, reqskillvalue, reqlevel)
SELECT
  65022,
  nt.spell,
  nt.spellcost,
  nt.reqskill,
  nt.reqskillvalue,
  nt.reqlevel
FROM npc_trainer nt
WHERE nt.entry = 22220;
