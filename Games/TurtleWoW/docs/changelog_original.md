# Changelog

## 2026-05-23
- Initial setup: TurtleServer_en.rar extracted and working
- Moved to C:\TurtleWoW\ for isolation
- Created START SERVER.bat and STOP SERVER.bat
- Created folder structure: server\, client\, docs\, backups\
- **Respawn timers**: All creatures set to 10yr respawn; escort NPCs restored to 5min
- **Repop Mulgore**: Cleared creature_respawn for Mulgore (immediate respawn of zone)
- **Loot overhaul**: Quest items 100%; Rare+ (blue+) 100%; green drops 100% on named mobs, 0% on trash
- **Stat buff durations**: All class stat buffs (MotW, PW:F, AI, Blessings, Battle Shout, Aspects, totems, etc.) extended to 1 hour via spellduration table override (IDs 3/4/6/21/30/40/42)
- **Wandering Ancestor (NPC 65022)**: Custom Horde teleport companion — 29 destinations across Kalimdor / Eastern Kingdoms / Starting Zones via gossip menu
- **Thornmantle family**: Chief Sharptusk (8554) → Boss rank +50% stats; Squealer (3229) → Elite rank +25% stats

## 2026-05-25
- **Wandering Ancestor — Banker**: Added bank deposit box service (npc_flags |= 256, gossip option id=4)
- **Wandering Ancestor — All Professions Trainer**: Copied Alchemy, BS, Enchanting, Engineering, Herbalism, LW, Mining, Skinning, Tailoring, Cooking, First Aid, Fishing from 12 trainer NPCs (npc_flags |= 16)
- **Wandering Ancestor — Survival Trainer**: Copied Survival spells from Sylvan Gemcrafter (22220)
- **Find Resources (spell 62000)**: Custom spell tracking Herbs + Minerals + Trees simultaneously; permanent aura; trained free at NPC 65022
- **Swift Stride (spells 62010-62021)**: 12-rank speed buff (+5%/rank, levels 5-60); trained free at NPC 65022; spell_chain supersession wired; Spell.dbc patched on both client and server

## Reference / Diagnostics (not changes)
- tmp_mulgore_named_scan.sql / tmp_mulgore_v2.sql — read-only queries to find named Mulgore NPCs not tied to quests
- tmp_restore_rewxp.sql — original quest XP reference values for recovery if needed
