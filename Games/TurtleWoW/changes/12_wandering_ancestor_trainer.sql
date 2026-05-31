-- Patch: Add all-profession trainer to The Wandering Ancestor (entry 65022)
-- Applied: 2026-05-25
-- NPC already has: gossip (1) + banker (256) = npc_flags 257.
-- This adds UNIT_NPC_FLAG_TRAINER (16) -> new total: 273.
-- Sources used per profession:
--   Alchemy       -> World Alchemy Trainer    (5032)
--   Blacksmithing -> Brikk Keencraft          (2836)  -- artisan incl.
--   Enchanting    -> World Enchanting Trainer  (5038)
--   Engineering   -> World Engineering Trainer (5037)
--   Herbalism     -> Alma Jainrose             (812)   -- artisan incl.
--   Leatherworking-> World Leatherworking Trainer (5040)
--   Mining        -> Krunn                     (3175)  -- artisan incl.
--   Skinning      -> Jayla                     (6288)  -- artisan incl.
--   Tailoring     -> World Tailoring Trainer   (5041)
--   Cooking       -> Gremlock Pilsnor          (1699)
--   First Aid     -> Thamner Pol               (2326)
--   Fishing       -> Lee Brown                 (1651)  -- journeyman max (artisan is a book)

-- ---------------------------------------------------------------
-- Step 1: Grant trainer flag and set trainer type
-- ---------------------------------------------------------------
UPDATE creature_template
SET npc_flags    = npc_flags | 16,
    trainer_type = 2
WHERE entry = 65022;

-- ---------------------------------------------------------------
-- Step 2: Add "Train me." gossip option (slot 5)
-- ---------------------------------------------------------------
INSERT INTO gossip_menu_option
  (menu_id, id, option_icon, option_text, option_id, npc_option_npcflag)
VALUES
  (65022, 5, 3, 'Train me.', 5, 16);

-- ---------------------------------------------------------------
-- Step 3: Copy all profession spells into npc_trainer for entry 65022
-- INSERT IGNORE skips any duplicate (spell, entry) pairs
-- ---------------------------------------------------------------
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
WHERE nt.entry IN (
  5032,   -- World Alchemy Trainer
  5038,   -- World Enchanting Trainer
  5037,   -- World Engineering Trainer
  5040,   -- World Leatherworking Trainer
  5041,   -- World Tailoring Trainer
  2836,   -- Brikk Keencraft       (Blacksmithing, incl. Artisan)
  812,    -- Alma Jainrose         (Herbalism,     incl. Artisan)
  3175,   -- Krunn                 (Mining,        incl. Artisan)
  6288,   -- Jayla                 (Skinning,      incl. Artisan)
  2326,   -- Thamner Pol           (First Aid,     incl. Artisan)
  1699,   -- Gremlock Pilsnor      (Cooking,       Apprentice-Artisan)
  1651    -- Lee Brown             (Fishing,       Apprentice+Journeyman)
);
