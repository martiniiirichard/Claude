USE tw_world;

-- Step A: Ungrouped greens -> 100%
UPDATE creature_loot_template clt
JOIN item_template it ON it.entry = clt.item
SET clt.ChanceOrQuestChance = 100
WHERE it.quality = 2
  AND clt.groupid = 0
  AND clt.ChanceOrQuestChance > 0;

-- Step B: Break grouped greens out of loot groups -> independent 100% drops
INSERT INTO creature_loot_template
  (entry, item, ChanceOrQuestChance, groupid, mincountOrRef, maxcount, condition_id)
SELECT
  clt.entry,
  clt.item,
  100,
  0,
  clt.mincountOrRef,
  clt.maxcount,
  clt.condition_id
FROM creature_loot_template clt
JOIN item_template it ON it.entry = clt.item
WHERE it.quality = 2
  AND clt.groupid > 0
ON DUPLICATE KEY UPDATE
  ChanceOrQuestChance = 100;

-- Step C: Delete the now-replaced grouped rows
DELETE clt FROM creature_loot_template clt
JOIN item_template it ON it.entry = clt.item
WHERE it.quality = 2
  AND clt.groupid > 0;
