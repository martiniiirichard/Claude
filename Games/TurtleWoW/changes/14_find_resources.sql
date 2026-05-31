-- Patch: Add "Find Resources" combined tracking buff
-- Applied: 2026-05-25
-- Spell 62000 applies SPELL_AURA_TRACK_RESOURCES (45) three times simultaneously:
--   effectMiscValue1 = 2  -> Herbs   (same as Find Herbs,     spell 2383)
--   effectMiscValue2 = 3  -> Minerals (same as Find Minerals, spell 2580)
--   effectMiscValue3 = 20 -> Trees   (same as Find Trees,     spell 52917)
-- All three effects land atomically, so the engine's "remove other trackers" pass
-- fires once before the spell lands -- it never cancels its own effects.
-- durationIndex 21 = permanent until cancelled (right-click buff to remove).

-- ---------------------------------------------------------------
-- Step 1: Create the combined tracking spell in spell_template
-- ---------------------------------------------------------------
INSERT INTO spell_template
  (entry, name, nameSubtext,
   durationIndex,
   effect1, effectApplyAuraName1, effectMiscValue1, effectImplicitTargetA1,
   effect2, effectApplyAuraName2, effectMiscValue2, effectImplicitTargetA2,
   effect3, effectApplyAuraName3, effectMiscValue3, effectImplicitTargetA3)
VALUES
  (62000, 'Find Resources', 'Passive',
   21,
   6, 45, 2, 1,
   6, 45, 3, 1,
   6, 45, 20, 1);

-- ---------------------------------------------------------------
-- Step 2: Add it to The Wandering Ancestor's trainer (entry 65022)
-- reqskill=0, reqskillvalue=0 -> learnable from the start, free
-- ---------------------------------------------------------------
INSERT IGNORE INTO npc_trainer
  (entry, spell, spellcost, reqskill, reqskillvalue, reqlevel)
VALUES
  (65022, 62000, 0, 0, 0, 0);
