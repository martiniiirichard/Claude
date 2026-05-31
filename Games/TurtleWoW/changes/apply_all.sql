-- Apply All Changes — Turtle WoW Private Server
-- Run against a fresh TurtleServer_en.rar restore
-- Order matters — run sequentially
-- Last updated: 2026-05-30

-- Usage:
-- C:\TurtleWoW\server\mysql\bin\mysql.exe -u root -proot < apply_all.sql

SOURCE changes/01_respawn_10yr.sql;
SOURCE changes/02_repop_mulgore.sql;
SOURCE changes/03_loot_fix.sql;
SOURCE changes/04_loot_group_fix.sql;
SOURCE changes/05_green_loot_fix.sql;
SOURCE changes/06_green_trash_zero.sql;
-- 07 is SUPERSEDED — do not run (broken buff duration attempt)
SOURCE changes/08_fix_gossip_and_buffs.sql;
SOURCE changes/09_thornmantle_buff.sql;
SOURCE changes/10_wandering_ancestor_creation.sql;
SOURCE changes/11_wandering_ancestor_bank.sql;
SOURCE changes/12_wandering_ancestor_trainer.sql;
SOURCE changes/13_wandering_ancestor_survival.sql;
SOURCE changes/14_find_resources.sql;
SOURCE changes/15_swift_stride_db.sql;

-- After running SQL: patch Spell.dbc manually
-- Run: C:\TurtleWoW\patches\patch_swift_stride_dbc.ps1
