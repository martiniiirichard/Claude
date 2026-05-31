USE tw_world;

-- Step 1: Set ALL creature spawns to 10 years (315,360,000 seconds)
UPDATE creature
SET spawntimesecsmin = 315360000,
    spawntimesecsmax = 315360000;

-- Step 2: Restore escort NPCs (script_waypoint entries) to 5 minutes (300 seconds)
-- These need to respawn normally so escort quests remain completable
UPDATE creature
SET spawntimesecsmin = 300,
    spawntimesecsmax = 300
WHERE id IN (SELECT entry FROM script_waypoint);
