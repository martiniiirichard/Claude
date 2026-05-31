-- Delete dead Mulgore creature entries so server respawns them immediately
DELETE cr FROM tw_char.creature_respawn cr
JOIN tw_world.creature c ON cr.guid = c.guid
WHERE c.map = 1
AND c.position_x BETWEEN -4500 AND -400
AND c.position_y BETWEEN -2750 AND 1200;

SELECT ROW_COUNT() AS rows_deleted;

-- Confirm none remain
SELECT COUNT(*) AS still_dead
FROM tw_char.creature_respawn cr
JOIN tw_world.creature c ON cr.guid = c.guid
WHERE c.map = 1
AND c.position_x BETWEEN -4500 AND -400
AND c.position_y BETWEEN -2750 AND 1200;
