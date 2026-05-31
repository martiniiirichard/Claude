-- Patch: Add bank service to The Wandering Ancestor (entry 65022)
-- Applied: 2026-05-25
-- NPC already has fast travel (gossip_menu_id 65022, options 0-3).
-- This adds UNIT_NPC_FLAG_BANKER and a new gossip option (id 4).

-- Step 1: Grant the NPC the banker flag (256 = UNIT_NPC_FLAG_BANKER)
UPDATE creature_template
SET npc_flags = npc_flags | 256
WHERE entry = 65022;

-- Step 2: Add the bank gossip option as slot 4 in the existing menu
--   option_icon 6 = money bag icon
--   option_id   9 = GOSSIP_OPTION_BANKER (opens the bank window)
--   npc_option_npcflag 256 = only shown when NPC has BANKER flag
INSERT INTO gossip_menu_option
  (menu_id, id, option_icon, option_text, option_id, npc_option_npcflag)
VALUES
  (65022, 4, 6, 'I would like to check my deposit box.', 9, 256);
