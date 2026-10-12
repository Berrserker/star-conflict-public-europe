# Changes against the stock server

All changes are in three files under `deploy/files`, which `setup.ps1` copies over the stock install:
- `cloud/data/default_platform_config.lua` (matchmaker, rewards, loot, trading). Read at start.
- `cloud/data/shard.cfg` (Shard). Read at start.
- `data/gamedata/def/ex/junk.lua` (loot items). The battle server reads it directly, no regeneration needed.

Every change below was tested on a local server before going live. Values are what we run; tune them to your population.

## Loot

### Common loot tables fixed (stock bug)
The per-rank loot config (`DedicatedServcerServices_SetLootRules`, one row per ship rank) points common loot at `CommonRanks_1_3` … `CommonRanks_13_15`. `data\gamedata\shared\loot_tables.lua` only defines them with a `_v3` suffix, so in stock the trophy search after a battle almost never gave common loot. All 15 rows now use `CommonRanks_*_v3`. Check: a battle log shows `got common loot table 'CommonRanks_1_3_v3'`.

### Loot for ranks 16–17
The loot config stopped at rank 15, so rank 16–17 ships got an empty trophy search. We added rows `[16]` and `[17]` as copies of `[15]`.

### One iridium find per battle
- Each battle gives 5 loot attempts. `rare = { iter = {…} }` is a pity counter: after N non-rare attempts the next one is rare. Every rare `iter` value is now `4`, so 4 common attempts and then 1 rare.
- The rare tables (`RareT1`…`RareT5`, `RareT*Mono`) contain `Iridium_Junk_r1`…`r15`. The personal iridium credited (`tokenCredits`, the green gem used for blueprints) is **10% of the junk's `tokenPrice`**.
- In `junk.lua`, `tokenPrice` of all 15 `Iridium_Junk_r*` is ×5: about 16–47 iridium per battle at ranks 1–3 and about 117 at ranks 13–15.
- `SalvageTokenConversion` and `SalvagePremiumTokenConversion` in `special_values.xml` do **not** affect this.
- The stock daily cap still applies: `sv_tokenCreditsDailyLimit = 1000`, plus a 10,000 account cap (`ai.tokens_cap` in `reputation.lua`).
- The same loot rules seem to apply in open-world zones as well (players reported more containers from mob packs).

## Rewards

### GS (Galactic Standards)
- `reward_bonusGoldForWinner = 25` in `ConfigureGRD()` (stock 0): +25 GS for any won battle, in any mode. Winners only.
- **Gold battles 24/7.** A line before `MatchMaker_SetRewardRates( reward_mult )` replaces the stock schedule (Monday 2–5 h +50, Sunday 10–13 h +100) with one 0–24 h slot per day and `goldReward = 50`:
  ```lua
  for d = 0, 6 do reward_mult[ d ] = { { hourBegin = 0, hourEnd = 24, goldReward = 50 } } end
  ```
  The matchmaker passes `gold_reward` to every battle, but only PvP pays it, and only to the winners. A PvP win is therefore +75 GS. The client shows the gold-hours timer as "1–2 days left", because it seems to look only one day ahead. That is cosmetic.
- Revert: `reward_bonusGoldForWinner = 0`, and delete the `for d = 0, 6` line.

### Credits ×2
`cvars.rate_cred = "2,2,…"` (18 values, one per rank; stock all `1`). A battle log shows it as `"rate_cred"`. `cvars.rate_exp` is the same thing for experience; we keep it at 1.

## Matchmaking (low-online queues)
Below `mm_lowOnlineLo = 250` players online, the `queuesConfigLo` block applies. Bots fill the empty slots, `minPlayers = 1`.

### Pools split by ship rank
Stock splits the arcade and coop (vs-AI) queues by `mmValue`, a per-player rating. **On a fresh server `mmValue` is 0 for every player**, so everyone landed in the first queue and T1 met T5. We replaced the 6 + 6 queues with 5 + 5 queues split by ship rank, `mmValue` 0–100:
```lua
InstantiateQueueTemplate( arcadeQueueTemplate, 1, 3, 1, 3, 0, 100, …newbie flags… )
InstantiateQueueTemplate( arcadeQueueTemplate, 4, 6, 4, 6, 0, 100 )
…  7–9, 10–12, 13–17
```
The same goes for `coopQueueTemplate`. Stock coop queues also stopped at rank 15, so rank 16–17 ships could never find a vs-AI battle.

### More bots in PvP
`special = { arcade = 1, botsCount = 7 }` in the low-online arcade template (stock: no `botsCount`), the way the stock `one_against_all` queue does it. A single player now gets 5 bots, about 3v3, instead of 1 bot (1v1). `mm_botsCount` does not affect this. The vs-AI queues ignore `botsCount`.

### One region pool
Every queue had `regionLocalizedTimeInQueue = 10` (training 30): for the first N seconds the matchmaker pairs players only within their region (for example `AR_RU` vs Europe). That matters with several datacenters, but on a single server it just splits the few players you have, and with a 10 s wait, regions never mixed. All 24 occurrences are now `1`, the value the stock sector queues use. A comment there says the default is 120, so we avoid `0`.

### Longer PvP wait
The low-online arcade template has `maxTimeInQueue = 60` (stock 10): the queue waits up to a minute to gather real players before it fills the battle with bots. The vs-AI queues keep 10. There is no join-in-progress (see [KNOWN_ISSUES.md](KNOWN_ISSUES.md)), so this wait is the only way to put players together.

### PvE missions in a party
Both `-- PVE QUEUE` entries have `maxPlayers = 4` (stock 1), so PvE missions can be played in a party.

## Trading (mail)
In both `ConfigureShard()` blocks:
- `shard_minAntibotCounterForMailSending = 10` (stock 50): sending mail with attachments unlocks after 10 battles.
- `shard_is2StepAuthForMailSendingNeeded = 0` (stock unset, which acts as on). Otherwise players whose battles were played from another PC are blocked.

Admins can set a player's counter with the `setStat` admin task (see [ADMIN.md](ADMIN.md)). The trading tax itself is stock: it is progressive, from 0% up to 50% (`data\gamedata\trade.lua` → `TradingTax`, generated into `aux_limits.xml`).

## Flood limit
`shard.cfg`: `sm_reqFreqOverloadLine 5` and `sm_overloadCounterLimit 20`. The stock limit, about 0.8 requests per second, kicks players with "too many messages" while they gather resources in open space. Flood protection stays on, just with headroom.

## Premium as a welcome gift (scripts, not config)
- The tutorial reward is stock: 48 h of premium.
- `deploy/welcome.js` creates a broadcast (`adminMail`) that every account receives once, new ones included. It is a golden letter with 10 years of premium.
- **Never grant premium further than ~60 years ahead.** The client counts the remaining time in 32-bit seconds and overflows at ~68 years, and then shows no premium at all.

## Things we deliberately did not change
- **Progression.** Caps, ranks, faction access and the synergy grind are stock. This kit aims at the original progression, not an "everything unlocked" sandbox. Anyone can build that locally with Gaijin's guide.
- **Account auto-creation on first login** (stock). Disable it with `auth_allowInternalAutoCreate = 0` if you want registration elsewhere.
