-- ============================================================
-- LOOT RATE CHANGES
-- 1. Quest items: set all to 100% drop chance
-- 2. Rare+ ungrouped: set to 100%
-- 3. Rare+ grouped (blue/purple): break out of group, set to 100%
-- ============================================================

USE tw_world;

-- Step 1: Quest item drops -> 100%
-- ChanceOrQuestChance is negative for quest items; -100 = 100% chance
UPDATE creature_loot_template
SET ChanceOrQuestChance = -100
WHERE ChanceOrQuestChance < 0;

-- Step 2: Rare+ items not in a loot group -> 100%
UPDATE creature_loot_template clt
JOIN item_template it ON it.entry = clt.item
SET clt.ChanceOrQuestChance = 100
WHERE it.quality >= 3
  AND clt.ChanceOrQuestChance > 0
  AND clt.groupid = 0;

-- Step 3: Rare+ items in a loot group -> break out, 100%
-- groupid=0 means they now roll independently at 100%
UPDATE creature_loot_template clt
JOIN item_template it ON it.entry = clt.item
SET clt.ChanceOrQuestChance = 100,
    clt.groupid = 0
WHERE it.quality >= 3
  AND clt.groupid > 0;
