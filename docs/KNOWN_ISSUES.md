# Known issues and open questions

## Bots always fly T1 ships and barely fight
**Symptom.** In PvP and vs-AI battles, bots use T1 ships at any player rank. They don't fire missiles, almost never use modules and don't evade under fire.

**Cause.** Every battle applies `AiPreset.Default` (`Applying AiPreset.Default for bots` in the battle log, with `botPresetName` empty in `games`). It uses `PreparedVessels` (T1), `use_rockets = false`, `modules_can_use_percentage = 0.01` and `use_evasion_on_damage = false`. Better presets exist in `data\gamedata\shared\ai_settings.lua`: `BotsT1`…`BotsT5` have missiles, modules (33–75%) and evasion, and their ships match the tier.

**Tried, without effect** (`botPresetName` stays empty):
- `botPresetByTier` in a queue's `special`;
- `botPresetName` in `special` and at the queue's top level;
- a `botPresetNames` table by rank;
- `botPresetByTier` filled with one preset;
- `sv_botPresetType = 1` (MIRROR);
- `botPresetType = bpt_mirror` in the queue.

`botPresetByTier` is only used next to the sector/universe code in the MatchMaker.

**Hypotheses.**
- The tier for the preset may come from `mmValue`, which is 0 on fresh servers (see below).
- Or the original servers fed bots "adaptive presets" stored in the database (`sv_numAdaptivePresetsInDB`, `sv_rangeRankAdaptivePresets`, modes ADAPTIVE and MIRROR_AND_SAVE), which a fresh database doesn't have.

**Fallback idea.** Edit `AiPreset.Default` itself: enable missiles, modules and evasion. It is also used for NPCs, so check where else it applies first.

If you crack this, please open an issue.

## `mmValue` is 0 for every player
Shard computes a per-player matchmaking rating (`effModMmValue`, `kpmMmValue`, `winLoseMmValue`, …; the scale is `mmValueToRankRange` in `ui_properties.lua`). On a fresh server every player has `mmValue=0` in the battle logs, while bots get normal values. Stock low-online queues are split by `mmValue`, which is why we split them by ship rank instead ([CHANGES.md](CHANGES.md)). The root cause is unknown.

## No join-in-progress
Players never join a battle that is already running. On our server, out of 1093 PvP battles with humans in one day, 84% had a single human. The latest a human ever joined was 32 s after the start, still inside the loading window. `Kick excessive bot` only fires at the start, when humans take pre-spawned bots' places. `sv_dbgJoinInProgress` exists but is unused. With few players, the queue wait and a single region pool are the only levers ([CHANGES.md](CHANGES.md)).

## Detonation mode with bots
A bot that picks up the bomb stands still and only shoots, so the match can stall until it dies. It is stock AI behaviour. Remove mode 11 from the low-online arcade `levelsDesc` if it bothers your players. We haven't found a way to forbid bots from picking up the bomb.

## Party PvP queue
Players report endless matchmaking when queueing for PvP as a party. We haven't verified it since the queues were split by rank. The arcade template has `maxSquadTimeInQueue = 0x7FFFFFFF`.

## Missions and Special Ops are hard for small groups
They are balanced for full groups. PvE missions now allow parties of up to 4 ([CHANGES.md](CHANGES.md)), but Special Ops remain very hard with few players.

## Missing epic loot tables
The loot config references `NeodiumDrop` (rank 8) and `LezortiumDrop` (rank 11), which don't exist in the game data. The stock config is like that.

## Players from Russia can't connect
Many players from Russia log in and get disconnected about 20 s later (Shard: `OnDisconnect … reasoned 5`), or can't connect at all. Players from Belarus, Ukraine and Kazakhstan, who share the same server region, connect fine. Russian ISP filtering (TSPU) freezes TCP connections to foreign hosting after about 16–20 KB, so the large initial player-data reply never arrives. Through a VPN it works. This cannot be fixed on the server side.

## Stock quirks worth knowing
- Hub needs the `cloud.xml` address to exist on a local network adapter ("there is no my node in xml"), see [SETUP.md](SETUP.md#troubleshooting).
- The old MatchMaker logs FATAL "undeleted shared strings" while shutting down. That is a leak report on exit, not a runtime error.
- The premium timer overflows at about 68 years.
- About 547 ships on one account crash Shard.
- `TradingLimits.minAccountRank = 6` in `data\gamedata\trade.lua` seems to apply to trade adverts, not to mail.
