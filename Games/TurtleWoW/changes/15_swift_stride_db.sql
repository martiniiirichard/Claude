-- Patch: Swift Stride -- 12-rank speed buff trained by The Wandering Ancestor
-- Applied: 2026-05-25
-- Spell IDs 62010-62021 (Ranks 1-12)
-- +5% run speed per rank, one rank per 5 levels (5, 10, 15 ... 60)
-- effectApplyAuraName1 = 31 (SPELL_AURA_MOD_INCREASE_SPEED)
-- effectBasePoints1    = desired_pct - 1  (confirmed from Dash=49 -> +50%)
-- durationIndex        = 21 (permanent until right-clicked off)
-- effectImplicitTargetA1 = 1 (TARGET_UNIT_CASTER)

-- ---------------------------------------------------------------
-- Step 1: spell_template -- 12 ranks
-- ---------------------------------------------------------------
INSERT INTO spell_template
  (entry, name, nameSubtext, durationIndex,
   effect1, effectApplyAuraName1, effectBasePoints1, effectImplicitTargetA1)
VALUES
  (62010, 'Swift Stride', 'Rank 1',  21, 6, 31,  4, 1),  -- +5%
  (62011, 'Swift Stride', 'Rank 2',  21, 6, 31,  9, 1),  -- +10%
  (62012, 'Swift Stride', 'Rank 3',  21, 6, 31, 14, 1),  -- +15%
  (62013, 'Swift Stride', 'Rank 4',  21, 6, 31, 19, 1),  -- +20%
  (62014, 'Swift Stride', 'Rank 5',  21, 6, 31, 24, 1),  -- +25%
  (62015, 'Swift Stride', 'Rank 6',  21, 6, 31, 29, 1),  -- +30%
  (62016, 'Swift Stride', 'Rank 7',  21, 6, 31, 34, 1),  -- +35%
  (62017, 'Swift Stride', 'Rank 8',  21, 6, 31, 39, 1),  -- +40%
  (62018, 'Swift Stride', 'Rank 9',  21, 6, 31, 44, 1),  -- +45%
  (62019, 'Swift Stride', 'Rank 10', 21, 6, 31, 49, 1),  -- +50%
  (62020, 'Swift Stride', 'Rank 11', 21, 6, 31, 54, 1),  -- +55%
  (62021, 'Swift Stride', 'Rank 12', 21, 6, 31, 59, 1);  -- +60%

-- ---------------------------------------------------------------
-- Step 2: spell_chain -- supersession chain (learning Rank 2
--         automatically removes Rank 1, etc.)
-- ---------------------------------------------------------------
INSERT INTO spell_chain
  (spell_id, prev_spell, first_spell, rank, req_spell)
VALUES
  (62010,     0, 62010,  1, 0),
  (62011, 62010, 62010,  2, 0),
  (62012, 62011, 62010,  3, 0),
  (62013, 62012, 62010,  4, 0),
  (62014, 62013, 62010,  5, 0),
  (62015, 62014, 62010,  6, 0),
  (62016, 62015, 62010,  7, 0),
  (62017, 62016, 62010,  8, 0),
  (62018, 62017, 62010,  9, 0),
  (62019, 62018, 62010, 10, 0),
  (62020, 62019, 62010, 11, 0),
  (62021, 62020, 62010, 12, 0);

-- ---------------------------------------------------------------
-- Step 3: npc_trainer -- all 12 ranks on The Wandering Ancestor
--         reqlevel gates each rank to its 5-level bracket
--         spellcost 0 = free (quality-of-life NPC)
-- ---------------------------------------------------------------
INSERT IGNORE INTO npc_trainer
  (entry, spell, spellcost, reqskill, reqskillvalue, reqlevel)
VALUES
  (65022, 62010, 0, 0, 0,  5),
  (65022, 62011, 0, 0, 0, 10),
  (65022, 62012, 0, 0, 0, 15),
  (65022, 62013, 0, 0, 0, 20),
  (65022, 62014, 0, 0, 0, 25),
  (65022, 62015, 0, 0, 0, 30),
  (65022, 62016, 0, 0, 0, 35),
  (65022, 62017, 0, 0, 0, 40),
  (65022, 62018, 0, 0, 0, 45),
  (65022, 62019, 0, 0, 0, 50),
  (65022, 62020, 0, 0, 0, 55),
  (65022, 62021, 0, 0, 0, 60);
