# Turtle WoW Private Server — Rebuild Guide

**Server version:** 1181 (Capybara)  
**Last updated:** 2026-05-30

---

## How to Rebuild From Scratch

### Step 1 — Restore the base server
1. Extract `TurtleServer_en.rar` to `C:\TurtleWoW\`
2. This contains pre-compiled binaries, bundled MySQL with full DB loaded, all DBC/map/vmap/mmap data, and Apache for account registration
3. No SQL imports needed — the DB is already pre-loaded

### Step 2 — Restore config files
Copy from `config/` in this repo:
- `mangosd.conf` → `C:\TurtleWoW\server\mangosd.conf`
- `realmd.conf` → `C:\TurtleWoW\server\realmd.conf`

### Step 3 — Apply all DB changes
Start MySQL, then run:
```
C:\TurtleWoW\server\mysql\bin\mysql.exe -u root -proot < changes/apply_all.sql
```
This applies all 15 change scripts in order. See `changes/apply_all.sql` for the sequence.

> **Skip `07_buff_duration_initial_SUPERSEDED.sql`** — this was the broken first attempt at buff durations. `apply_all.sql` already excludes it.

### Step 4 — Patch Spell.dbc
Run the DBC patch to inject Swift Stride spells into both client and server:
```powershell
C:\TurtleWoW\patches\patch_swift_stride_dbc.ps1
```
The script is idempotent — safe to run multiple times.

### Step 5 — Start the server
```
Double-click: C:\TurtleWoW\PLAY.bat
```
Or use `START SERVER.bat` + launch `WoW.exe` separately.

> ⚠️ **Docker must be fully loaded before starting the server.** Docker binds to port 3306 on startup and will block bundled MySQL if it starts first.

---

## Key Paths
| Item | Path |
|---|---|
| Server | `C:\TurtleWoW\server\` |
| Client | `C:\Users\marti\OneDrive\Desktop\Games\twmoa_1181_cn\twmoa_1181\WoW.exe` |
| MySQL | `C:\TurtleWoW\server\mysql\bin\mysql.exe -u root -proot` |
| Databases | `tw_logon`, `tw_world`, `tw_char`, `tw_logs` |

---

## Change Summary (25 changes as of 2026-05-30)

| # | Category | What |
|---|---|---|
| 01 | System | All creature respawn timers → 10 years (solo play) |
| 02 | System | Repop Mulgore — clear pending respawn timers |
| 03-06 | Loot | Quest 100%, Rare+ 100%, Named greens 100%, Trash greens 0% |
| 07 | Spell | Buff duration initial attempt — SUPERSEDED by 08 |
| 08 | Spell | Buff durations 1hr (corrected) + gossip_menu_id fix |
| 09 | NPC | Thornmantle family elite/boss rank buff |
| 10 | NPC | Wandering Ancestor creation + teleport destinations (29 locations) |
| 11 | NPC | Wandering Ancestor — Banker service |
| 12 | NPC | Wandering Ancestor — All Professions trainer |
| 13 | NPC | Wandering Ancestor — Survival trainer |
| 14 | Spell | Find Resources custom spell (Herbs + Minerals + Trees) |
| 15 | Spell | Swift Stride 12-rank speed buff (DB side) |
| DBC | DBC | Swift Stride Spell.dbc patch (client + server) |

Full details: see `docs/changes_original.csv` or `CHANGELOG.md`

---

## If Something Breaks
See `docs/README_FOR_AI.md` for full troubleshooting guide.

Quick checks:
1. All 4 processes running: `tasklist | findstr "mysqld apache mangosd realmd"`
2. All 4 ports listening: 80, 3306, 3724, 8085
3. Docker not stealing port 3306: `netstat -ano | findstr ":3306"`
4. Check `C:\TurtleWoW\server\logs\Server.log` for crash details
