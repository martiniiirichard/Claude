USE tw_world;

-- Set green drop rate to 0% for non-named mobs.
-- Named mob proxy: any creature whose loot entry contains at least one blue+ item (quality >= 3).
-- Non-named = greens with no blue+ items anywhere in their loot table.

UPDATE creature_loot_template clt
JOIN item_template it ON it.entry = clt.item
SET clt.ChanceOrQuestChance = 0
WHERE it.quality = 2
  AND clt.entry NOT IN (
    SELECT named.entry FROM (
      SELECT DISTINCT clt2.entry
      FROM creature_loot_template clt2
      JOIN item_template it2 ON it2.entry = clt2.item
      WHERE it2.quality >= 3
    ) AS named
  );
