-- ============================================================
-- STAT-BUFF SPELLS → 1 HOUR DURATION
-- All classes: Druid, Priest, Mage, Paladin, Warrior,
--              Hunter, Shaman (buffs + totems)
-- Uses a new spellduration ID = 600 (safely above max 557)
-- Only rows with durationIndex > 0 are changed; durationIndex=0
-- rows are instant/trigger effects and left untouched.
-- ============================================================
USE tw_world;

-- Step 1: Register the 1-hour duration slot
-- BaseDuration and MaximumDuration both = 3,600,000 ms (1 hr)
-- PerLevel = 0 (no scaling)
INSERT INTO spellduration (ID, BaseDuration, PerLevel, MaximumDuration)
VALUES (600, 3600000, 0, 3600000)
ON DUPLICATE KEY UPDATE
  BaseDuration     = 3600000,
  PerLevel         = 0,
  MaximumDuration  = 3600000;

-- ============================================================
-- Step 2: Update every stat-buff spell entry that has an
-- explicit (non-zero) durationIndex in spell_template.
-- ============================================================

-- DRUID: Mark of the Wild, Gift of the Wild
UPDATE spell_template
SET durationIndex = 600
WHERE name IN ('Mark of the Wild', 'Gift of the Wild')
  AND durationIndex > 0;

-- PRIEST: PW:Fortitude, Prayer of Fortitude,
--         Divine Spirit, Prayer of Spirit,
--         Shadow Protection, Prayer of Shadow Protection
UPDATE spell_template
SET durationIndex = 600
WHERE name IN (
  'Power Word: Fortitude',
  'Prayer of Fortitude',
  'Divine Spirit',
  'Prayer of Spirit',
  'Shadow Protection',
  'Shadow Protection ',      -- trailing-space variant in DB
  'Prayer of Shadow Protection'
) AND durationIndex > 0;

-- MAGE: Arcane Intellect, Arcane Brilliance
UPDATE spell_template
SET durationIndex = 600
WHERE name IN ('Arcane Intellect', 'Arcane Brilliance')
  AND durationIndex > 0;

-- PALADIN: Standard Blessings
UPDATE spell_template
SET durationIndex = 600
WHERE name IN (
  'Blessing of Kings',
  'Blessing of Might',
  'Blessing of Wisdom',
  'Blessing of Salvation',
  'Blessing of Sanctuary',
  'Blessing of Light'
) AND durationIndex > 0;

-- PALADIN: Greater Blessings
UPDATE spell_template
SET durationIndex = 600
WHERE name IN (
  'Greater Blessing of Kings',
  'Greater Blessing of Might',
  'Greater Blessing of Wisdom',
  'Greater Blessing of Salvation',
  'Greater Blessing of Sanctuary',
  'Greater Blessing of Light'
) AND durationIndex > 0;

-- WARRIOR: Battle Shout, Commanding Shout
UPDATE spell_template
SET durationIndex = 600
WHERE name IN ('Battle Shout', 'Commanding Shout')
  AND durationIndex > 0;

-- HUNTER: Aspects and Trueshot Aura
UPDATE spell_template
SET durationIndex = 600
WHERE name IN (
  'Trueshot Aura',
  'Aspect of the Hawk',
  'Aspect of the Cheetah',
  'Aspect of the Pack',
  'Aspect of the Monkey',
  'Aspect of the Beast',
  'Aspect of the Wild',
  'Aspect of the Viper',
  'Aspect of the Dragonhawk'
) AND durationIndex > 0;

-- SHAMAN: Totem placement spells and their buff auras
-- Grace of Air
UPDATE spell_template
SET durationIndex = 600
WHERE name IN ('Grace of Air Totem', 'Grace of Air')
  AND durationIndex > 0;

-- Strength of Earth
UPDATE spell_template
SET durationIndex = 600
WHERE name IN ('Strength of Earth Totem', 'Strength of Earth')
  AND durationIndex > 0;

-- Stoneskin Totem
UPDATE spell_template
SET durationIndex = 600
WHERE name = 'Stoneskin Totem'
  AND durationIndex > 0;

-- Windfury Totem + passive aura
UPDATE spell_template
SET durationIndex = 600
WHERE name IN ('Windfury Totem', 'Windfury Totem Passive')
  AND durationIndex > 0;

-- Flametongue Totem + passive aura
UPDATE spell_template
SET durationIndex = 600
WHERE name IN ('Flametongue Totem', 'Flametongue Totem Passive')
  AND durationIndex > 0;

-- Mana Spring Totem
UPDATE spell_template
SET durationIndex = 600
WHERE name = 'Mana Spring Totem'
  AND durationIndex > 0;

-- Resistance Totems
UPDATE spell_template
SET durationIndex = 600
WHERE name IN (
  'Fire Resistance Totem',
  'Frost Resistance Totem',
  'Nature Resistance Totem'
) AND durationIndex > 0;

-- ============================================================
-- Step 3: Verify — show before/after summary
-- ============================================================
SELECT
  name,
  COUNT(*) AS affected_entries,
  GROUP_CONCAT(DISTINCT durationIndex ORDER BY durationIndex) AS duration_indices
FROM spell_template
WHERE name IN (
  'Mark of the Wild','Gift of the Wild',
  'Power Word: Fortitude','Prayer of Fortitude',
  'Arcane Intellect','Arcane Brilliance',
  'Divine Spirit','Prayer of Spirit',
  'Shadow Protection','Shadow Protection ',
  'Prayer of Shadow Protection',
  'Battle Shout','Commanding Shout',
  'Trueshot Aura',
  'Blessing of Kings','Blessing of Might','Blessing of Wisdom',
  'Blessing of Salvation','Blessing of Sanctuary','Blessing of Light',
  'Greater Blessing of Kings','Greater Blessing of Might',
  'Greater Blessing of Wisdom','Greater Blessing of Salvation',
  'Greater Blessing of Sanctuary','Greater Blessing of Light',
  'Grace of Air Totem','Grace of Air',
  'Strength of Earth Totem','Strength of Earth',
  'Stoneskin Totem','Windfury Totem','Windfury Totem Passive',
  'Flametongue Totem','Flametongue Totem Passive',
  'Mana Spring Totem',
  'Fire Resistance Totem','Frost Resistance Totem',
  'Nature Resistance Totem',
  'Aspect of the Hawk','Aspect of the Cheetah','Aspect of the Pack',
  'Aspect of the Monkey','Aspect of the Beast','Aspect of the Wild',
  'Aspect of the Viper','Aspect of the Dragonhawk'
)
GROUP BY name
ORDER BY name;
