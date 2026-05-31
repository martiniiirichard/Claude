USE tw_world;

-- Step 3: Break grouped rare+ items (blue/purple/legendary) out of loot groups
-- and set them to 100% independent drops.
-- Uses INSERT...ON DUPLICATE KEY to handle cases where a groupid=0 row
-- already exists for the same (entry, item) — avoids PK collision.

-- 3a: Insert ungrouped 100% rows (or update if already exists ungrouped)
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
WHERE it.quality >= 3
  AND clt.groupid > 0
ON DUPLICATE KEY UPDATE
  ChanceOrQuestChance = 100;

-- 3b: Delete the now-replaced grouped rows for rare+ items
DELETE clt FROM creature_loot_template clt
JOIN item_template it ON it.entry = clt.item
WHERE it.quality >= 3
  AND clt.groupid > 0;
