-- ============================================================
-- FIX 1: NPC gossip_menu_id was never set → no menu appeared
-- ============================================================
USE tw_world;

UPDATE creature_template
SET gossip_menu_id = 65022
WHERE entry = 65022;

-- Verify
SELECT entry, name, gossip_menu_id, npc_flags FROM creature_template WHERE entry = 65022;


-- ============================================================
-- FIX 2: Buff duration 1 hour
--
-- The previous approach set durationIndex=600 which doesn't
-- exist in SpellDuration.dbc → 0ms duration → buff vanishes.
-- Correct approach: revert spell_template back to original
-- DBC-valid indices, then override THOSE existing IDs in
-- spellduration to 3,600,000 ms (1 hour).
-- ============================================================

-- Step A: Revert spell_template entries (durationIndex=600 → original per group)

-- Group: durationIndex was 30
--   MotW, PW:Fortitude, Arcane Intellect, Divine Spirit, Greater Blessings
UPDATE spell_template SET durationIndex = 30
WHERE durationIndex = 600
  AND name IN (
    'Mark of the Wild',
    'Power Word: Fortitude',
    'Arcane Intellect',
    'Divine Spirit',
    'Greater Blessing of Kings',
    'Greater Blessing of Might',
    'Greater Blessing of Wisdom',
    'Greater Blessing of Salvation',
    'Greater Blessing of Sanctuary',
    'Greater Blessing of Light'
  );

-- Group: durationIndex was 42
--   Arcane Brilliance, Gift of the Wild, Prayer of Fortitude/Spirit,
--   Shadow Protection (group/prayer version — trailing space entries)
UPDATE spell_template SET durationIndex = 42
WHERE durationIndex = 600
  AND name IN (
    'Arcane Brilliance',
    'Gift of the Wild',
    'Prayer of Fortitude',
    'Prayer of Spirit',
    'Shadow Protection '    -- trailing space = group/prayer variant
  );

-- Group: durationIndex was 6
--   Regular Blessings, Shadow Protection (standard)
UPDATE spell_template SET durationIndex = 6
WHERE durationIndex = 600
  AND name IN (
    'Blessing of Kings',
    'Blessing of Might',
    'Blessing of Wisdom',
    'Blessing of Salvation',
    'Blessing of Sanctuary',
    'Blessing of Light',
    'Shadow Protection'     -- no trailing space
  );

-- Group: durationIndex was 21
--   Aspects, Trueshot Aura, totem buff auras (the passive/effect spells
--   that apply the actual stat buff to nearby players)
UPDATE spell_template SET durationIndex = 21
WHERE durationIndex = 600
  AND name IN (
    'Trueshot Aura',
    'Aspect of the Hawk',
    'Aspect of the Cheetah',
    'Aspect of the Pack',
    'Aspect of the Monkey',
    'Aspect of the Beast',
    'Aspect of the Wild',
    'Aspect of the Viper',
    'Aspect of the Dragonhawk',
    'Grace of Air',
    'Strength of Earth',
    'Windfury Totem Passive',
    'Flametongue Totem Passive'
  );

-- Group: durationIndex was 40
--   Prayer of Shadow Protection
UPDATE spell_template SET durationIndex = 40
WHERE durationIndex = 600
  AND name = 'Prayer of Shadow Protection';

-- Group: durationIndex was 3
--   Mana Spring Totem (distinct from the other totem indices)
UPDATE spell_template SET durationIndex = 3
WHERE durationIndex = 600
  AND name = 'Mana Spring Totem';

-- Catch-all: anything still at 600 → durationIndex=4
--   (Battle Shout, all placement totems, Commanding Shout, remaining odds)
UPDATE spell_template SET durationIndex = 4
WHERE durationIndex = 600;


-- Step B: Override the existing DBC duration IDs to 3,600,000 ms
-- These IDs ARE in SpellDuration.dbc so MaNGOS will pick them up on next restart.
-- BaseDuration = MaximumDuration = 3,600,000 ms (1 hour); PerLevel = 0

-- ID 3  → was ~1 min (Mana Spring Totem)
INSERT INTO spellduration (ID, BaseDuration, PerLevel, MaximumDuration)
VALUES (3, 3600000, 0, 3600000)
ON DUPLICATE KEY UPDATE BaseDuration=3600000, PerLevel=0, MaximumDuration=3600000;

-- ID 4  → was ~2 min (Battle Shout, most placement totems)
INSERT INTO spellduration (ID, BaseDuration, PerLevel, MaximumDuration)
VALUES (4, 3600000, 0, 3600000)
ON DUPLICATE KEY UPDATE BaseDuration=3600000, PerLevel=0, MaximumDuration=3600000;

-- ID 6  → was ~5 min (regular Blessings, Shadow Protection)
INSERT INTO spellduration (ID, BaseDuration, PerLevel, MaximumDuration)
VALUES (6, 3600000, 0, 3600000)
ON DUPLICATE KEY UPDATE BaseDuration=3600000, PerLevel=0, MaximumDuration=3600000;

-- ID 21 → was permanent/0 or very long (Aspects, Trueshot Aura, totem buff auras)
INSERT INTO spellduration (ID, BaseDuration, PerLevel, MaximumDuration)
VALUES (21, 3600000, 0, 3600000)
ON DUPLICATE KEY UPDATE BaseDuration=3600000, PerLevel=0, MaximumDuration=3600000;

-- ID 30 → was 30 min (Mark of Wild, PW:F, Arcane Intellect, Greater Blessings)
INSERT INTO spellduration (ID, BaseDuration, PerLevel, MaximumDuration)
VALUES (30, 3600000, 0, 3600000)
ON DUPLICATE KEY UPDATE BaseDuration=3600000, PerLevel=0, MaximumDuration=3600000;

-- ID 40 → was 30 min (Prayer of Shadow Protection)
INSERT INTO spellduration (ID, BaseDuration, PerLevel, MaximumDuration)
VALUES (40, 3600000, 0, 3600000)
ON DUPLICATE KEY UPDATE BaseDuration=3600000, PerLevel=0, MaximumDuration=3600000;

-- ID 42 → was 30 min (Arcane Brilliance, Gift of Wild, Prayer buffs)
INSERT INTO spellduration (ID, BaseDuration, PerLevel, MaximumDuration)
VALUES (42, 3600000, 0, 3600000)
ON DUPLICATE KEY UPDATE BaseDuration=3600000, PerLevel=0, MaximumDuration=3600000;


-- Step C: Verify — confirm no durationIndex=600 rows remain
SELECT COUNT(*) AS remaining_600 FROM spell_template WHERE durationIndex = 600;

-- Confirm spellduration rows
SELECT ID, BaseDuration, MaximumDuration FROM spellduration ORDER BY ID;

-- Spot-check a few spells
SELECT entry, name, durationIndex FROM spell_template
WHERE name IN ('Mark of the Wild','Battle Shout','Blessing of Kings','Arcane Brilliance','Mana Spring Totem','Prayer of Shadow Protection')
  AND durationIndex > 0
ORDER BY name, entry
LIMIT 20;
