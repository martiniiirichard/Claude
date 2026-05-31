USE tw_world;

DROP TEMPORARY TABLE IF EXISTS quest_creature_entries;
CREATE TEMPORARY TABLE quest_creature_entries AS
SELECT DISTINCT ref AS entry FROM (
  SELECT ABS(ReqCreatureOrGOId1) AS ref FROM quest_template WHERE ReqCreatureOrGOId1 > 0
  UNION ALL SELECT ABS(ReqCreatureOrGOId2) FROM quest_template WHERE ReqCreatureOrGOId2 > 0
  UNION ALL SELECT ABS(ReqCreatureOrGOId3) FROM quest_template WHERE ReqCreatureOrGOId3 > 0
  UNION ALL SELECT ABS(ReqCreatureOrGOId4) FROM quest_template WHERE ReqCreatureOrGOId4 > 0
  UNION ALL
  SELECT DISTINCT clt.entry
  FROM creature_loot_template clt
  WHERE clt.ChanceOrQuestChance < 0
    AND clt.item IN (
      SELECT ReqItemId1 FROM quest_template WHERE ReqItemId1 > 0
      UNION ALL SELECT ReqItemId2 FROM quest_template WHERE ReqItemId2 > 0
      UNION ALL SELECT ReqItemId3 FROM quest_template WHERE ReqItemId3 > 0
      UNION ALL SELECT ReqItemId4 FROM quest_template WHERE ReqItemId4 > 0
    )
  UNION ALL
  SELECT id FROM creature_questrelation
  UNION ALL
  SELECT id FROM creature_involvedrelation
) AS all_refs;

SELECT
    ct.entry,
    ct.name,
    ct.rank,
    ct.level_min,
    ct.level_max,
    COUNT(DISTINCT c.guid) AS spawns,
    ROUND(AVG(c.position_x), 0) AS avg_x,
    ROUND(AVG(c.position_y), 0) AS avg_y
FROM creature c
JOIN creature_template ct ON c.id = ct.entry
LEFT JOIN quest_creature_entries qce ON ct.entry = qce.entry
WHERE c.map = 1
  AND qce.entry IS NULL
  AND (ct.npc_flags & (4|128|512|1024|2048|4096|8192)) = 0
  AND (
        (c.position_x BETWEEN -4500 AND -400  AND c.position_y BETWEEN -1700 AND 1200)
     OR (c.position_x BETWEEN -4700 AND -2500 AND c.position_y BETWEEN -2750 AND -1700)
  )
GROUP BY ct.entry, ct.name, ct.rank, ct.level_min, ct.level_max
HAVING spawns <= 5
ORDER BY ct.rank DESC, ct.level_min, ct.name;
