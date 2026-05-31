# GM Command Reference — TurtleWoW 1181 (Capybara)
*TortoiseMangos / MaNGOS-based server. Your ADMIN account is rank 3 — all commands available.*
*Commands are hardcoded in mangosd.exe; there is no `command` table in the database.*
*Type `.help` in-game to see available commands at your current level.*

---

## Quick Reference — Most Useful Commands

| Command | What it does |
|---------|-------------|
| `.gm on` | Enter GM mode (invisible, immune to damage) |
| `.gm off` | Leave GM mode |
| `.gm fly on` | Enable fly mode |
| `.gm fly off` | Disable fly mode |
| `.tele [name]` | Teleport to a named location |
| `.go xyz #x #y #z [#mapID]` | Teleport to exact coordinates |
| `.additem #itemID [#count]` | Add item to your inventory |
| `.levelup [#levels]` | Level up by N levels (default: 1) |
| `.revive` | Resurrect your target (or self) |
| `.npc add #creatureID` | Spawn a creature at your position |
| `.gobject add #gameobjectID` | Spawn a game object at your position |
| `.lookup item [name]` | Search for an item by name → get ID |
| `.lookup creature [name]` | Search for a creature by name → get ID |
| `.lookup spell [name]` | Search for a spell by name → get ID |
| `.pinfo` | Show info about your target player |
| `.modify morph #displayID` | Change your visual model |
| `.modify speed all #rate` | Change movement speed (1.0 = normal) |
| `.balance [account] [amount]` | Add token balance (TurtleWoW specific) |

---

## Account & Security

```
.account                                   — Show your account info
.account create $account $password         — Create a new account
.account delete $account                   — Delete an account
.account onlinelist                        — List online accounts
.account password $old $new $new          — Change password
.account set addon #level [$account]       — Set addon access (0-2)
.account set gmlevel [$account] #level [#realmID]  — Set GM rank (0-3)
```

---

## GM Mode

```
.gm on/off              — Toggle GM mode (invisible to players, immune to damage)
.gm fly on/off          — Toggle flight (walk on air)
.gm chat on/off         — Show/hide GM tag in chat
.gm visible on/off      — Toggle visibility to other players
.gm list                — List all online GMs
```

---

## Teleportation

```
.tele [location]                        — Teleport to a named location
.tele add $name                         — Save current position as a tele point
.tele del $name                         — Delete a saved tele point
.tele group $location                   — Teleport your whole group
.tele name $charName $location          — Teleport another player to a location

.go xy #x #y [#mapID]                   — Go to x,y coordinates
.go xyz #x #y #z [#mapID]              — Go to x,y,z coordinates
.go xyzo #x #y #z #o [#mapID]          — Go to x,y,z + orientation
.go zonexy #x #y [#zoneID]             — Zone-relative coordinates
.go creature #guid                      — Go to creature by GUID
.go object #guid                        — Go to game object by GUID
.go graveyard #graveyardID             — Go to a graveyard
.go grid #gridX #gridY [#mapID]        — Go to a map grid
.go taxinode #nodeID                    — Go to a flight path node
.go ticket #ticketID                    — Go to a GM ticket location
.go trigger #areaTriggerID             — Go to an area trigger
.go quest #questID                      — Go to quest giver

.recall [$playerName]                   — Return to your previous location
```

---

## Character Modification

```
.levelup [#levels]                      — Level up by N (default: 1)
.addmoney #copper                       — Add money (10000 = 1 gold)
.removemoney #copper                    — Remove money

.modify hp #amount                      — Set max HP
.modify mana #amount                    — Set max mana
.modify energy #amount                  — Set energy
.modify rage #amount                    — Set rage
.modify xp #xp                          — Add XP
.modify rep #factionID #value          — Set reputation value
.modify honor #points                   — Add honor points
.modify morph #displayID               — Change model/appearance
.modify mount #displayID               — Apply a mount transform
.modify gender male/female              — Change gender
.modify drunk #value                    — Set drunk level (0-100)
.modify speed all #rate                 — Set all movement speeds (1.0 = normal)
.modify speed walk #rate                — Walk speed
.modify speed run #rate                 — Run speed
.modify speed swim #rate                — Swim speed
.modify speed fly #rate                 — Fly speed
.modify speed backwalk #rate            — Backpedal speed

.setskill #skillID #level [#maxlevel]  — Set a skill level
.addspell #spellID                      — Learn a spell
.removespell #spellID                  — Forget a spell
.aura #spellID                          — Apply a buff/aura
.unaura #spellID                        — Remove a buff/aura

.cast #spellID [triggered]              — Cast a spell on your target
.cast self #spellID [triggered]         — Target casts on itself
.cast back #spellID [triggered]         — Cast facing away from target
.cast dist #spellID #dist [triggered]  — Cast at a specific distance

.showarea #areaID                       — Reveal area on minimap
.hidearea #areaID                       — Hide area on minimap
```

---

## Item Commands

```
.additem #itemID [#count]               — Add item to your inventory
.additem #itemID #count #enchantID     — Add with enchant
.additemset #itemsetID                  — Add all items in an item set
.removeitem #itemID [#count]           — Remove item from inventory

.lookup item $namepart                  — Search items by name → get ID
.lookup itemset $namepart              — Search item sets by name
```

---

## Quest Commands

```
.quest add #questID                     — Add a quest to player's log
.quest complete #questID               — Complete a quest (flags as complete)
.quest remove #questID                 — Remove quest from player's log
.quest reward #questID                 — Grant quest rewards without turn-in

.lookup quest $namepart                 — Search quests by name → get ID
```

---

## NPC (Creature) Commands

```
.npc add #creatureID                    — Spawn creature at your position
.npc addtemp #creatureID               — Spawn temporary creature (disappears on server restart)
.npc delete [#guid]                     — Delete target creature
.npc info                               — Show info about target NPC
.npc move [#guid]                       — Move NPC to your position
.npc aiinfo                             — Show AI info of target

.npc name $name                         — Change NPC name
.npc subname $subname                   — Change NPC subname (title)
.npc faction #factionID                — Change NPC faction
.npc flag #npcflag                      — Change NPC flags
.npc changelevel #level                — Change NPC level
.npc changeentry #entryID              — Change NPC entry/type
.npc setmodel #displayID               — Change NPC model

.npc additem #itemID [#count [#incrtime [#extcost]]] — Add item to NPC vendor
.npc delitem #itemID                    — Remove item from NPC vendor

.npc follow                             — Make NPC follow you
.npc follow stop                        — Stop NPC following you
.npc playemote #emoteID                — Make NPC play an emote
.npc setmove #guid #moveType           — Set movement type (0=stationary, 1=random, 2=waypoint)
.npc addmove #guid [#waittime]         — Add a waypoint to NPC movement
.npc tame                               — Tame target creature as pet

.npc allowmove                          — Toggle NPC movement on/off

.lookup creature $namepart              — Search creatures by name → get ID
```

---

## Game Object Commands

```
.gobject add #gameobjectID             — Spawn game object at your position
.gobject delete [#guid]                — Delete game object
.gobject info [#guid]                  — Show info about game object
.gobject move [#guid] [#x #y #z]      — Move game object
.gobject turn [#guid] [#z [#y [#x]]]  — Rotate game object
.gobject near [#distance]              — List nearby game objects
.gobject target [#gameobjectID]        — Select nearest matching game object

.lookup object $namepart               — Search game objects by name → get ID
```

---

## Pet Commands

```
.pet create                             — Create a pet for your target
.pet learn #spellID                    — Teach pet a spell
.pet unlearn #spellID                  — Remove pet spell
```

---

## Send Commands (Mail System)

```
.send mail $charName $subject $text                         — Send mail to player
.send money $charName $subject $text #copper               — Send mail with money
.send items $charName $subject $text #itemID[:count] ...   — Send mail with items
.send message $charName $message                           — Send system message to player
```

---

## Player Info & Management

```
.pinfo [$playerName]                    — Show account/IP/mute/ban info
.getdistance [#guid]                   — Distance to target
.revive                                 — Resurrect target (or self if no target)
.save                                   — Force-save your character
.saveall                                — Force-save all characters
.dismount                               — Dismount target
.whispers on/off                        — Allow/block whispers
```

---

## Lookup Commands

```
.lookup area $namepart                  — Search areas by name
.lookup creature $namepart             — Search creatures by name → entryID
.lookup item $namepart                 — Search items by name → itemID
.lookup itemset $namepart             — Search item sets
.lookup object $namepart              — Search game objects
.lookup quest $namepart               — Search quests
.lookup player account $accountName   — Find player by account name
.lookup player email $email           — Find player by email
.lookup player ip $ip                  — Find player by IP address
.lookup skill $namepart               — Search skills
.lookup spell $namepart               — Search spells
.lookup taxinode $namepart            — Search flight path nodes
.lookup tele $namepart                — Search saved teleport locations
.lookup title $namepart               — Search titles
.lookup map $namepart                  — Search maps
```

---

## Ban Commands

```
.ban account $account $time $reason     — Ban an account (time: 0=permanent, or "1d", "2h")
.ban character $name $time $reason     — Ban a character
.ban ip $ip $time $reason              — Ban an IP
.unban account $account                — Unban account
.unban character $name                 — Unban character
.unban ip $ip                          — Unban IP
.baninfo account $account              — Show ban info for account
.baninfo character $name              — Show ban info for character
.baninfo ip $ip                        — Show ban info for IP
.banlist account [$filter]             — List banned accounts
.banlist character [$filter]           — List banned characters
.banlist ip [$filter]                  — List banned IPs
```

---

## Kick / Mute

```
.kick [$playerName] [$reason]          — Kick player from server
.mute $playerName #minutes [$reason]   — Mute player for N minutes
.unmute $playerName                    — Unmute player
```

---

## GM Tickets

```
.ticket list                            — List open tickets
.ticket closedlist                      — List closed tickets
.ticket onlinelist                      — List tickets from online players
.ticket assign $ticketID $gmName       — Assign ticket to a GM
.ticket unassign $ticketID             — Unassign ticket
.ticket viewid $ticketID               — View ticket by ID
.ticket viewname $charName             — View player's active ticket
.ticket comment $ticketID $comment     — Add comment to ticket
.ticket response $ticketID $response   — Set resolution response
.ticket close $ticketID                — Close a ticket
.ticket delete $ticketID               — Delete a ticket
.ticket go [#ticketID]                 — Teleport to ticket location
.ticket goname $charName               — Teleport to player with ticket
.ticket reset                           — Reset all ticket data
.ticket togglesystem                   — Enable/disable ticketing system
```

---

## Server Management

```
.server info                            — Show uptime, version, player count
.server motd                            — Show current MOTD
.server set motd $text                 — Set the MOTD
.server plimit [#limit]                — Show/set max player count
.server saveall                         — Save all player data
.server log level #level               — Change log verbosity (0-6)
.server shutdown [#delay]              — Shutdown server after delay (seconds)
.server shutdown cancel                — Cancel scheduled shutdown
.server restart [#delay]               — Restart after delay
.server restart cancel                 — Cancel restart
.server exit                            — Immediately exit the server
.server idleshutdown [#delay]          — Shutdown if no players for X seconds
.server idlerestart [#delay]           — Restart if no players for X seconds
.server corpses                         — Trigger corpse cleanup
```

---

## Debug Commands

```
.debug play sound #soundID             — Play a sound globally
.debug play cinematic #cinematicID     — Play a cinematic
.debug play movie #movieID             — Play a movie
.debug update #field [#value]          — Read/set unit field by index
.debug anim #animID                    — Play an animation on target
.debug setaurastate #state [on/off]    — Set aura state flags
.debug spawnvehicle #entry #guid       — Spawn a vehicle
.debug taxi #nodeID [#nodeID ...]      — Unlock taxi nodes
```

---

## Misc Utility

```
.getdistance                            — Show distance to your current target
.dismount                               — Force-dismount yourself or target
.groupsummon [$playerName]             — Summon all group members to you
.appear $playerName                     — Teleport to a player
.summon $playerName                     — Summon a player to you

.showarea #areaID                       — Reveal an area on the map
.hidearea #areaID                       — Hide an area from the map

.npc info                               — Inspect target NPC's database entry
.pinfo                                  — Inspect target player's account info
```

---

## TurtleWoW-Specific Commands

```
.balance $account #amount              — Add token balance to an account
                                         Example: .balance admin 10000
```

---

## GM Rank Levels

| Rank | Name | Description |
|------|------|-------------|
| 0 | Player | No GM commands |
| 1 | Moderator | Basic moderation (kick, mute, tickets) |
| 2 | Game Master | Full gameplay access (spawn, modify, teleport) |
| 3 | Administrator | All commands including server management |

Your ADMIN account is **rank 3** — all commands above are available.

---

## Tips

- Most commands target the **unit you have selected** (right-click in-game)
- Use `.` prefix for all commands — type directly in chat
- `.help` in-game lists commands at your current level
- `.help $commandname` shows syntax for a specific command
- Add `triggered` to `.cast` commands to bypass cooldowns/costs
- `.lookup creature [partial name]` is the fastest way to find a creature entry ID

---

*Saved: 2026-05-23*
