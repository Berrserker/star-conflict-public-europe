# Contributing

Thanks for helping. Issues, ideas and pull requests are welcome.

## Why most game files are not here
This repo has only the files we changed (`deploy/files`) plus our scripts. Everything else ships with the game: install Star Conflict from Steam, and the server files are in `steamapps\common\star conflict\cloud` and `data`. Gaijin allows running and modifying them, but not redistributing them, so we don't re-upload the stock files.

## Changing a file that is already in `deploy/files`
Edit it and open a pull request. Explain what the change does and why, and how you tested it.

## Changing a stock file that is not in the repo yet
1. Copy the file from your game install into the same path under `deploy/files`. For example, `cloud\data\special_values.xml` goes to `deploy/files/cloud/data/special_values.xml`. `setup.ps1` copies everything under `deploy/files` over the stock install.
2. Commit the **unchanged stock file first**, then your edit in a second commit. That way the PR shows exactly what you changed.
3. Keep the original encoding and line endings: game lua files are cp1251 with CRLF.

## Generated files
Most xml files in `cloud/data` are generated from the lua sources in `data/gamedata`. Change the lua source, not the xml. Mention in the PR that the data has to be regenerated (see [docs/ADMIN.md](docs/ADMIN.md#regenerating-game-data)).

## Testing
Test on a local server before proposing a change: run the kit on your own PC and connect to `localhost`. For gameplay changes, say what you checked, for example "a rank 17 PvP battle shows `got common loot table ...` in the battle log".

## Scope
This kit aims at the **original progression** for public servers: fixes and low-population tuning are welcome, "everything unlocked" changes are not (anyone can build that locally). No monetization of any kind; Gaijin's terms forbid it.
