-- ============================================================
-- MULGORE: Named NPCs not covered by any quest
-- Map=1 (Kalimdor), coordinate bounding box for Mulgore
-- "Named" = rank > 0 (elite/rare/boss) OR has a subname/title
-- Excludes anything referenced as kill target, quest giver,
-- or quest ender in quest_template / quest relation tables.
-- ============================================================
USE tw_world;

SELECT
    ct.entry,
    ct.name,
    ct.subname,
    ct.rank,
    ct.level_min,
    ct.level_max,
    COUNT(DISTINCT c.guid) AS spawn_count,
    ROUND(AVG(c.position_x), 1) AS avg_x,
    ROUND(AVG(c.position_y), 1) AS avg_y
FROM creature c
JOIN creature_template ct ON c.id = ct.entry
WHERE c.map = 1
  AND c.position_x BETWEEN -4500 AND -900
  AND c.position_y BETWEEN -2600 AND 1200
  -- "Named" NPC criteria
  AND (
      ct.rank > 0
      OR (ct.subname IS NOT NULL AND ct.subname != '')
  )
  -- Not a quest kill objective
  AND ct.entry NOT IN (
      SELECT ReqCreatureOrGOId1 FROM quest_template WHERE ReqCreatureOrGOId1 > 0
      UNION ALL
      SELECT ReqCreatureOrGOId2 FROM quest_template WHERE ReqCreatureOrGOId2 > 0
      UNION ALL
      SELECT ReqCreatureOrGOId3 FROM quest_template WHERE ReqCreatureOrGOId3 > 0
      UNION ALL
      SELECT ReqCreatureOrGOId4 FROM quest_template WHERE ReqCreatureOrGOId4 > 0
  )
  -- Not a quest giver
  AND ct.entry NOT IN (
      SELECT id FROM creature_questrelation
  )
  -- Not a quest ender
  AND ct.entry NOT IN (
      SELECT id FROM creature_involvedrelation
  )
GROUP BY ct.entry, ct.name, ct.subname, ct.rank, ct.level_min, ct.level_max
ORDER BY ct.rank DESC, ct.level_min, ct.name;
