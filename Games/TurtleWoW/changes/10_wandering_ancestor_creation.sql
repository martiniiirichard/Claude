-- ============================================================
-- HEARTHSTONE COMPANION NPC — "The Wandering Ancestor"
-- Entry 65022 | Gossip teleport menu | 29 Horde destinations
-- ============================================================
USE tw_world;

-- ============================================================
-- 1. NPC TEMPLATE
-- ============================================================
INSERT INTO creature_template (
  entry, name, subname,
  level_min, level_max,
  display_id1,
  faction, npc_flags, unit_flags,
  rank,
  health_min, health_max,
  dmg_min, dmg_max, armor,
  scale, speed_walk, speed_run
) VALUES (
  65022, 'The Wandering Ancestor', 'Spirit Guide',
  60, 60,
  4306,          -- Tauren Elder model; change with .modify morph #id
  35,            -- Faction 35 (friendly, no auto-aggro)
  1,             -- npc_flags: GOSSIP only
  2,             -- unit_flags: non-attackable
  0,             -- rank: normal
  5000, 5000,
  0, 0, 0,
  1.0, 1.0, 1.14286
);

-- ============================================================
-- 2. NPC TEXT (dialog header for each menu page)
-- ============================================================
-- Main menu
INSERT INTO npc_text (ID, BroadcastTextID0, Probability0)
VALUES (2600001, 0, 1.0);
-- Kalimdor sub-menu
INSERT INTO npc_text (ID, BroadcastTextID0, Probability0)
VALUES (2600002, 0, 1.0);
-- Eastern Kingdoms sub-menu
INSERT INTO npc_text (ID, BroadcastTextID0, Probability0)
VALUES (2600003, 0, 1.0);
-- Starting Zones sub-menu
INSERT INTO npc_text (ID, BroadcastTextID0, Probability0)
VALUES (2600004, 0, 1.0);

-- ============================================================
-- 3. GOSSIP MENU (links NPC entry → npc_text header)
-- ============================================================
-- Main: NPC 65022 shows text 2600001
INSERT INTO gossip_menu (entry, text_id) VALUES (65022, 2600001);
-- Sub-menus (entry = action_menu_id used in parent option)
INSERT INTO gossip_menu (entry, text_id) VALUES (65023, 2600002);
INSERT INTO gossip_menu (entry, text_id) VALUES (65024, 2600003);
INSERT INTO gossip_menu (entry, text_id) VALUES (65025, 2600004);

-- ============================================================
-- 4. GOSSIP MENU OPTIONS
-- option_id=1 (GOSSIP), npc_option_npcflag=1 (requires gossip flag)
-- action_menu_id>0  → open sub-menu
-- action_script_id>0 → run teleport script
-- ============================================================

-- MAIN MENU (menu_id = 65022)
INSERT INTO gossip_menu_option (menu_id, id, option_icon, option_text, option_id, npc_option_npcflag, action_menu_id, action_script_id) VALUES
(65022, 0, 0, 'Kalimdor',          1, 1, 65023, 0),
(65022, 1, 0, 'Eastern Kingdoms',  1, 1, 65024, 0),
(65022, 2, 0, 'Starting Zones',    1, 1, 65025, 0),
(65022, 3, 0, 'Farewell.',         1, 1, 0,     0);

-- KALIMDOR SUB-MENU (menu_id = 65023)
INSERT INTO gossip_menu_option (menu_id, id, option_icon, option_text, option_id, npc_option_npcflag, action_menu_id, action_script_id) VALUES
(65023,  0, 0, 'Orgrimmar',           1, 1, 0,     6200001),
(65023,  1, 0, 'Thunder Bluff',       1, 1, 0,     6200002),
(65023,  2, 0, 'The Crossroads',      1, 1, 0,     6200003),
(65023,  3, 0, 'Camp Taurajo',        1, 1, 0,     6200004),
(65023,  4, 0, 'Ratchet',             1, 1, 0,     6200005),
(65023,  5, 0, 'Brackenwall Village', 1, 1, 0,     6200006),
(65023,  6, 0, 'Mudsprocket',         1, 1, 0,     6200007),
(65023,  7, 0, 'Camp Mojache',        1, 1, 0,     6200008),
(65023,  8, 0, 'Shadowprey Village',  1, 1, 0,     6200009),
(65023,  9, 0, 'Stonetalon Peak',     1, 1, 0,     6200010),
(65023, 10, 0, 'Splintertree Post',   1, 1, 0,     6200011),
(65023, 11, 0, 'Zoram''gar Outpost',  1, 1, 0,     6200012),
(65023, 12, 0, 'Freewind Post',       1, 1, 0,     6200013),
(65023, 13, 0, 'Gadgetzan',           1, 1, 0,     6200014),
(65023, 14, 0, 'Everlook',            1, 1, 0,     6200015),
(65023, 15, 0, 'Cenarion Hold',       1, 1, 0,     6200016),
(65023, 16, 0, '< Back',              1, 1, 65022, 0);

-- EASTERN KINGDOMS SUB-MENU (menu_id = 65024)
INSERT INTO gossip_menu_option (menu_id, id, option_icon, option_text, option_id, npc_option_npcflag, action_menu_id, action_script_id) VALUES
(65024,  0, 0, 'Undercity',           1, 1, 0,     6200017),
(65024,  1, 0, 'Brill',               1, 1, 0,     6200018),
(65024,  2, 0, 'The Sepulcher',       1, 1, 0,     6200019),
(65024,  3, 0, 'Tarren Mill',         1, 1, 0,     6200020),
(65024,  4, 0, 'Hammerfall',          1, 1, 0,     6200021),
(65024,  5, 0, 'Revantusk Village',   1, 1, 0,     6200022),
(65024,  6, 0, 'Grom''gol Base Camp', 1, 1, 0,     6200023),
(65024,  7, 0, 'Booty Bay',           1, 1, 0,     6200024),
(65024,  8, 0, 'Stonard',             1, 1, 0,     6200025),
(65024,  9, 0, 'Kargath',             1, 1, 0,     6200026),
(65024, 10, 0, '< Back',              1, 1, 65022, 0);

-- STARTING ZONES SUB-MENU (menu_id = 65025)
INSERT INTO gossip_menu_option (menu_id, id, option_icon, option_text, option_id, npc_option_npcflag, action_menu_id, action_script_id) VALUES
(65025, 0, 0, 'Valley of Trials (Orc/Troll)', 1, 1, 0,     6200027),
(65025, 1, 0, 'Camp Narache (Tauren)',         1, 1, 0,     6200028),
(65025, 2, 0, 'Deathknell (Undead)',           1, 1, 0,     6200029),
(65025, 3, 0, '< Back',                        1, 1, 65022, 0);

-- ============================================================
-- 5. GOSSIP SCRIPTS — command 6 = TELEPORT_TO
--    datalong = map ID | x,y,z,o = destination
-- ============================================================

-- KALIMDOR
INSERT INTO gossip_scripts (id, delay, command, datalong, x, y, z, o, comments) VALUES
(6200001, 0, 6, 1,  1629.36,  -4373.39,  31.26, 3.54839, 'Orgrimmar'),
(6200002, 0, 6, 1, -1277.37,    124.80, 131.29, 5.22274, 'Thunder Bluff'),
(6200003, 0, 6, 1,  -452.84,  -2650.76,  95.52, 0.24108, 'The Crossroads'),
(6200004, 0, 6, 1, -2363.11,  -1913.78,  95.78, 0.16556, 'Camp Taurajo'),
(6200005, 0, 6, 1,  -956.66,  -3754.71,   5.33, 0.99664, 'Ratchet'),
(6200006, 0, 6, 1, -3130.67,  -2908.43,  34.10, 1.42798, 'Brackenwall Village'),
(6200007, 0, 6, 1, -4594.56,  -3208.20,  34.93, 4.64108, 'Mudsprocket'),
(6200008, 0, 6, 1, -4396.70,    224.84,  25.41, 4.93684, 'Camp Mojache'),
(6200009, 0, 6, 1, -1664.79,   3091.67,  30.56, 6.07818, 'Shadowprey Village'),
(6200010, 0, 6, 1,  2678.38,   1497.46, 233.87, 6.26038, 'Stonetalon Peak'),
(6200011, 0, 6, 1,  2270.94,  -2538.19,  93.92, 0.06043, 'Splintertree Post'),
(6200012, 0, 6, 1,  3376.86,   1013.05,   3.34, 3.81699, 'Zoram''gar Outpost'),
(6200013, 0, 6, 1, -5431.78,  -2449.38,  89.28, 2.32854, 'Freewind Post'),
(6200014, 0, 6, 1, -7177.15,  -3785.34,   8.37, 6.10237, 'Gadgetzan'),
(6200015, 0, 6, 1,  6725.69,  -4619.44, 720.91, 4.66802, 'Everlook'),
(6200016, 0, 6, 1, -6818.09,    733.81,  41.57, 2.30820, 'Cenarion Hold');

-- EASTERN KINGDOMS
INSERT INTO gossip_scripts (id, delay, command, datalong, x, y, z, o, comments) VALUES
(6200017, 0, 6, 0,  1584.07,   241.99,  -52.15, 0.04965, 'Undercity'),
(6200018, 0, 6, 0,  2259.25,   290.43,   34.11, 0.98741, 'Brill'),
(6200019, 0, 6, 0,   504.53,  1539.08,  129.50, 1.35812, 'The Sepulcher'),
(6200020, 0, 6, 0,   -34.15,  -923.37,   54.56, 0.15019, 'Tarren Mill'),
(6200021, 0, 6, 0,  -941.01, -3526.66,   70.93, 3.48668, 'Hammerfall'),
(6200022, 0, 6, 0,  -557.23, -4581.27,    9.59, 1.01724, 'Revantusk Village'),
(6200023, 0, 6, 0,-12388.90,   172.58,    2.83, 1.91753, 'Grom''gol Base Camp'),
(6200024, 0, 6, 0,-14297.20,   530.99,    8.78, 3.98863, 'Booty Bay'),
(6200025, 0, 6, 0,-10446.90, -3261.91,   20.18, 5.02142, 'Stonard'),
(6200026, 0, 6, 0, -6692.48, -2175.31,  244.15, 0.42757, 'Kargath');

-- STARTING ZONES
INSERT INTO gossip_scripts (id, delay, command, datalong, x, y, z, o, comments) VALUES
(6200027, 0, 6, 1,  -618.52, -4251.67,  38.72, 0.00000, 'Valley of Trials'),
(6200028, 0, 6, 1, -2917.58,  -257.98,  53.00, 0.00000, 'Camp Narache'),
(6200029, 0, 6, 0,  1676.35,  1677.45, 121.67, 2.70526, 'Deathknell');
