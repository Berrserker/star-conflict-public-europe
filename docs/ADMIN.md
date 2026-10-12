# Administration

All database commands run in the MongoDB shell shipped with the game:
```powershell
& "C:\SC\server\cloud\mongodb\mongo.exe" 127.0.0.1/cosmosim_<WindowsUser>
```
**Back up first** (`deploy\backup.ps1` or `mongodump`). MongoDB is 2.6.12. Keep it bound to `127.0.0.1`: anyone who can write to the database can run admin commands.

## Restarts
Never restart with players online without warning. `deploy\maintenance\restart.ps1 -Minutes 10` shows the built-in in-game countdown (`SN_MAINTENANCE_COUNTDOWN`), disconnects players at zero, backs up, then stops and starts the server. Under the hood it sends `/enterMaintenanceMode N` and `/leaveMaintenanceMode` to Hub's SSH console. The Windows `ssh.exe` hangs with that console, so the kit uses Node.js with `ssh2`. See [SETUP.md](SETUP.md#restart-with-a-countdown).

## Messages to players

### Login notification (`welcomeMsg`)
Shown once per login. One document per client language.
```js
db.welcomeMsg.remove({lang:"en"}); db.welcomeMsg.insert({lang:"en", message:"Welcome! News: [link href=\"https://example.org\" text=\"our site\"]"});
db.welcomeMsg.remove({lang:"ru"}); db.welcomeMsg.insert({lang:"ru", message:"Добро пожаловать!"});
```
Without a document, Shard shows "Welcome back!". `deploy\welcome-msg.js` sets both languages and is safe to re-run.

### Message of the day (`MOTD`)
```js
db.MOTD.insert({lang:"en", message:"Message of the day"});
```
Shard caches it. A change is guaranteed to show only after a restart.

### Text formatting
- Links: `[link href="https://…" text="label"]`.
- Line break: `|`.

### Mail to one player (`mailbox`)
```js
var now = new Date(), exp = new Date(now.getTime() + 30*24*3600*1000);
db.mailbox.insert({mailId:NumberLong("900000000000001"), amid:NumberLong(0), state:1, sender:NumberLong(0),
  receiver:NumberLong(<uid>), sentAt:now, expTime:exp, important:0, source:2, goldCost:0,
  attachments:{"0":{type:2, content:{subject:"Subject", body:"Text"}}}});
```
- **Subject and body must be non-empty.** An empty subject breaks the client: the letter can't be opened or deleted, and only removing it from the database helps.
- **Use your own high `mailId` range** (`9000000000000xx`). Shard reserves IDs from `counters.mailId` in blocks, so taking one from that counter by hand causes `E11000 duplicate key` later.
- `important: 1` makes it a golden letter.
- `expTime` must be an `ISODate`.

### Broadcast to everyone (`adminMail`)
```js
var amid = db.counters.findAndModify({query:{_id:"amid"}, update:{$inc:{c:NumberLong(1)}}, new:true}).c;
var now = new Date(), exp = new Date(now.getTime() + 30*24*3600*1000);
db.adminMail.insert({amid:amid, sender:NumberLong(0), sentAt:now, expTime:exp, important:1, source:2, goldCost:0,
  attachments:{"0":{type:2, content:{subject:"Gift", body:"Text"}},
               "1":{type:5, content:{defName:"ship_part_Ship_Race1_M_T1_Premium", amount:40}}}});
```
- On login, Shard delivers every `adminMail` with `amid > accounts.lastAdminMailId` and `expTime > now`, and Shard assigns the mail IDs itself.
- **Accounts created later also receive every broadcast that hasn't expired.** That makes broadcasts a convenient welcome gift, but set a sensible `expTime` on announcements.
- `expTime` must be an `ISODate`. A number is never matched.
- Cancel before delivery: `db.adminMail.remove({amid:NumberLong(<n>)})`.
- Remove from everyone after delivery: `db.mailbox.remove({amid:NumberLong(<n>)})`.

### Attachment types (`attachments."N".type`)
| type | content | notes |
|---|---|---|
| 1 | `{stringId:"ExtraItems"}` | game message (localization key) |
| 2 | `{subject, body}` | text, required as the first attachment |
| 3 | `{credits:n}` | credits |
| 5 | `{defName, amount}` | item, crafting resource or ship parts. Ship parts have a `maxAmount` (for example 40), and the excess becomes `extraResource` |
| 6 | `{tokenCredits, shouldIgnoreCaps}` | personal iridium |
| 7 | `{vesselExpPool:n}` | free synergy |
| 8 | `{premiumTime:seconds}` | premium. Keep it under ~60 years total (the client overflows at ~68) |
| 11–18 | `{defName}` | title, talents, clan resource, aura, autogen, custom element, avatar, motto |

## Admin tasks (`adminTasks`)
Shard polls this collection every ~5 s and executes the tasks itself, bumping the account's `ver`. Players can stay online.
```js
db.adminTasks.insert({cmd:"give", uid:NumberLong(<uid>), value:"credits", amount:1000000, reason:"compensation",
  serviceType:NumberInt(2), pickedBy:NumberLong(0), requestedByService:"gaijin_gdpr"});
```
- `pickedBy: 0` must be set explicitly, otherwise the task is never picked up. `reason` is required.
- `requestedByService:"gaijin_gdpr"` passes the privilege check. Without a requester you get `Failed to GetFields for uid 0`.
- `give` / `set`: `value` = `credits`, `goldCredits`, `factionRep`, … `setStat`: `value` = `antibotCounter` or `machineAntibotCounter` (battles counted for the mail threshold).
- **Queue one task per account at a time.** Parallel tasks for the same account overwrite each other.
- Shard writes the result into the document: `success`, `errMsg`, `finishedAt`. Clean up with `db.adminTasks.remove({success:{$exists:true}})`.
- Other commands exist in Shard but are untested: `ban`, `mute`, `changeNickName`, `resetAccount`, `enterMMode`, …

## Editing accounts directly
- Collection `accounts`: currencies, `vessels`, `items`, `craftResources` (map defName → amount), `premiumTill` (ms), `raceRep`, `admRole`, `ver`. The `auth` collection clashes with a shell method, so use `db.getCollection("auth")`.
- Edit only while the player is offline, ideally with the server stopped. Shard saves with "set if version", so bump `ver`.
- **About 547 ships on one account crash Shard** (`FixedArray m_size < TMaxSize`).
- Prefer admin tasks for currencies. They are safe while players are online.

## Regenerating game data
Most xml files in `cloud\data` (store, limits, …) are generated from `data\gamedata\*.lua`. After editing the lua, with MongoDB running, run from `C:\SC\server\cloud`:
```powershell
.\DedicatedServer.exe -logFileName prepare_shared.log -nullCon -prepareSharedData -ds datasources_defs_build.txt
```
It takes about 5 s. It also writes the Atlas and Autogen tables into the database, so back up first. Diff `cloud\data` before and after. On one machine `prepare_shared.bat` run through `cmd /c` silently did nothing, so call the exe directly.

## Matchmaker notes
- `mm_lowOnlineLo = 250` / `mm_lowOnlineHi = 300`: below 250 players online the `queuesConfigLo` block applies, at 300 and above the normal one.
- Arcade PvP holds at most 24 players (12v12).
- Every battle's parameters are visible at the top of its `dediserver*.log` and in the `games_<user>.games` collection: `botsCount`, `gold_reward`, `rate_cred`, players with `mmRank` / `mmValue`.
