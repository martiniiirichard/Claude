# Turtle WoW Private Server — Setup Guide for AI/LLM
*Written 2026-05-23. Describes exactly how this working setup was achieved.*

---

## What This Is

A fully working **Turtle WoW private server** running natively on Windows.
- Server version: **1181 (Capybara)**
- Source: `TurtleServer_en.rar` (extracted to `C:\Users\marti\Desktop\TurtleServer`)
- Client: `C:\Users\marti\OneDrive\Desktop\Games\twmoa_1181_cn\twmoa_1181\WoW.exe`

---

## The Working Setup — Files That Matter

```
C:\Users\marti\Desktop\TurtleServer\     ← THE SERVER (do not move or rename)
    START SERVER.bat                      ← One-click launch (start here)
    STOP SERVER.bat                       ← One-click shutdown
    mangosd.exe                           ← World server binary
    mangosd.conf                          ← World server config
    realmd.exe                            ← Login server binary
    realmd.conf                           ← Login server config (DB: localhost:3306, user: root/root)
    ace.dll / libcrypto / libssl / libmySQL  ← Required DLLs
    mysql\                                ← Bundled MySQL 5.7 (self-contained, port 3306)
    mysql\data\                           ← Pre-loaded game databases (tw_logon, tw_world, tw_char, tw_logs)
    apache\  (inside website\)            ← Web server for account registration
    data\dbc\                             ← Game data files (DBC)
    data\maps\                            ← Map data
    data\vmaps\                           ← Visual map collision data
    data\mmaps\                           ← Movement map data

C:\Users\marti\OneDrive\Desktop\Games\twmoa_1181_cn\twmoa_1181\
    WoW.exe                               ← THE CLIENT (launch this to play)
    realmlist.wtf                         ← Already set to: set realmlist 127.0.0.1
```

---

## How to Start the Server

> ⚠️ **IMPORTANT — Docker must be running first.**
> Docker Desktop binds to port 3306 during startup. If Docker hasn't fully initialized before the server launches, it will steal port 3306 from the bundled MySQL and mangosd/realmd will fail to connect.
> **Always wait for Docker Desktop to finish loading before running START SERVER.bat.**

**Then double-click `START SERVER.bat`** (or `PLAY.bat` for one-click server + client)

It starts all 4 services in this order (with delays between each):
1. **MySQL** — database engine, port 3306
2. **Apache** — web registration UI, port 80
3. **Mangosd** — world server, port 8085
4. **Realmd** — login server, port 3724

Required ports: **80, 3306, 3724, 8085** — all must be free.

To stop everything: double-click `STOP SERVER.bat`

---

## How to Play

1. Run `START SERVER.bat`
2. Wait ~15 seconds for all servers to initialize
3. To create an account: open browser → `http://127.0.0.1`
4. Launch `WoW.exe` from the 1181 client folder
5. Log in with your registered username and password

---

## Database Credentials

| Service | Host | Port | User | Password | Databases |
|---------|------|------|------|----------|-----------|
| MySQL (bundled) | localhost | 3306 | root | root | tw_logon, tw_world, tw_char, tw_logs |

Connect via: `mysql\bin\mysql.exe -u root -proot`

---

## How This Setup Was Found / Built

### What Was Tried First (Did NOT Work Well)
A compile-from-source approach was attempted:
- Cloned `https://github.com/Penqle/tortoise-wow.git` to `OneDrive\Documents\New project\tortoise-wow`
- Built with CMake + Visual Studio on Windows
- **Critical flag required:** `-DALLOW_TURTLE_ADDONS=ON` (without it, client crashes with "game interface files corrupt")
- The build compiled but the database had a missing table: `tw_char.character_inventory_copy`
- That table was created manually but the approach was abandoned in favor of the RAR package

### What Actually Works
The **pre-packaged `TurtleServer_en.rar`** contains:
- Pre-compiled binaries (mangosd.exe, realmd.exe) built 2026-05-22
- Bundled MySQL with the full database already loaded (no SQL imports needed)
- All DBC/map/vmap/mmap data files pre-extracted
- Apache + PHP website for account registration

This is far simpler than building from source. Use this approach.

---

## Key Lessons Learned / Errors to Avoid

### 1. WSL Default Distro Was docker-desktop, Not Ubuntu
When running `wsl` commands, the default was `docker-desktop` (BusyBox).
Always target Ubuntu explicitly: `wsl -d Ubuntu -e bash -c '...'`

### 2. Package Name Changed: ace-dev → libace-dev
The original instructions say `ace-dev` but on modern Ubuntu it is `libace-dev`.
Correct install command:
```bash
sudo apt install -y git cmake build-essential clang \
  libssl-dev libbz2-dev libreadline-dev libncurses-dev \
  libboost-all-dev libmysqlclient-dev mariadb-server libace-dev
```

### 3. The Compiled Server Used Docker MariaDB on Port 3307
The `mangosd.conf` for the compiled version connects to `127.0.0.1:3307` (Docker).
The TurtleServer RAR uses bundled MySQL on port `3306`.
These are completely separate databases — do not mix them up.

### 4. Missing Table Crash
The compiled server crashed at startup with:
```
[1146] Table 'tw_char.character_inventory_copy' doesn't exist
```
Fix (only needed for the compiled server, not the RAR):
```sql
USE tw_char;
CREATE TABLE IF NOT EXISTS `character_inventory_copy` (
  `guid` int(10) unsigned NOT NULL DEFAULT 0,
  `bag` int(10) unsigned NOT NULL DEFAULT 0,
  `slot` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `item` int(10) unsigned NOT NULL DEFAULT 0,
  `item_template` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`item`) USING BTREE,
  KEY `idx_guid` (`guid`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci ROW_FORMAT=DYNAMIC;
```

### 5. Apache Requires mh.js to Run First
The `2.Start Apache.bat` runs `cscript mh.js` before launching `apache.exe`.
`mh.js` patches `{$PORTABLEROOT}` placeholders in `httpd.conf` and `php.ini` with the actual install path.
If Apache fails to start, check that `mh.js` ran successfully first.

### 6. The Client Version Must Match the Server
- Server version **1181** → use client `twmoa_1181_cn\twmoa_1181\WoW.exe`
- Client `twmoa_1172` is an older version and will **not** work with this server
- The `TurtleWoW` client folder is for the official online Turtle WoW server, not this local one

---

## Other WoW Installations on This Machine (Context)

| Path | What It Is | Size | Status |
|------|-----------|------|--------|
| `Desktop\TurtleServer` | **WORKING private server** | 4.2 GB | ✅ Keep |
| `Games\twmoa_1181_cn` | **WORKING client (1181)** | 9.5 GB | ✅ Keep |
| `Games\TurtleWoW` | Official online Turtle WoW client | 9.3 GB | Keep (different purpose) |
| `Games\twmoa_1172` | Older client v1172, incompatible | 10 GB | Candidate for deletion |
| `Games\SolorCraft` | SoloCraft 1.12 project | ~0 GB | Separate project |
| `Desktop\Wow_HC` | WoW Hardcore Classic (retail) | 23 GB | Separate project |
| `Documents\New project\tortoise-wow` | Failed compile-from-source attempt | 11.4 GB | Candidate for deletion |
| `Desktop\Local-WoW-Sandbox` | Earlier sandbox attempt | 1 GB | Candidate for deletion |
| `Downloads\CAPYBARAWOW_CLIENT_(1-18_TurtleWoW).7z` | Source archive for twmoa_1181_cn | 9.2 GB | Can delete (already extracted) |
| `Downloads\TurtleServer_en.rar` | Source archive for TurtleServer | 1.3 GB | Can delete (already extracted) |
| `Downloads\WOW-Classic-1.14.2.zip` (×2 copies!) | WoW Classic 1.14.2 installer | 7.8 GB ×2 | One is a duplicate |

**Potential disk space recovery if cleaning up candidates: ~40+ GB**

---

## If Something Breaks

### Login screen stuck / can't connect to realm
1. Check all 4 processes are running: `tasklist | findstr "mysqld apache mangosd realmd"`
2. Check all 4 ports are listening: test 80, 3306, 3724, 8085
3. Check `realmlist.wtf` says `set realmlist 127.0.0.1`
4. Check `logs\` folder in TurtleServer for mangosd crash logs

### Mangosd crashes immediately / "disconnected from server" on login
- Look at `logs\Server.log` for the error
- Common cause: port 3306 taken by Docker Desktop before bundled MySQL could bind to it
- Fix: restart Docker Desktop, wait for it to fully load, then run `START SERVER.bat` again
- To confirm: run `netstat -ano | findstr ":3306"` — if PID belongs to `com.docker.backend.exe`, Docker is the culprit

### Apache won't start
- Run `mh.js` manually: open cmd in `website\apache\bin\`, run `cscript mh.js`
- Then run `apache.exe` directly

### Port conflict
- Something else is using port 3306, 3724, 8085, or 80
- Run `netstat -ano | findstr ":3306"` to find what's using it
- Stop the conflicting service or the old Docker container

---

*This README was generated by Claude Sonnet 4.6 on 2026-05-23 based on the actual setup session.*
