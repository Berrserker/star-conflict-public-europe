SC Launcher 0.7.0
=================

Purpose
Connects an existing Steam installation of Star Conflict to
Star Conflict Europe - Unofficial Server (57.131.200.242:3801) and installs the
client files that match the server (login screen, recipes, shop, limits).
The launcher is a single exe; launcher-config.ini next to it is optional.

Window mode
Run SC-Launcher.exe without arguments. On start it checks the server preset and
the mod files and installs what is missing or changed. The window has:
- Play: checks again and starts the game (Steam App ID 212070 is passed on);
  if the game is missing, the button becomes INSTALL GAME (steam://install/212070);
- Check for updates: the same check with a result message;
- Website, Discord, news (from the server's news.json);
- RU / UK flags: launcher and game language;
- Settings: install / remove the modification and the Steam launch line.

Steam mode (recommended)
1. Put SC-Launcher.exe in a normal folder (not the game folder).
2. In the launcher: Settings -> "Launch from Steam" -> Copy. This copies a line
   like  "C:\Games\SC-Launcher.exe" %command%
3. Paste it in Steam: Star Conflict -> Properties -> General -> Launch options.
Every Steam launch then runs silently: preset and mod check, then the game with
all of Steam's arguments; the launcher waits for the game and returns its exit
code. If a check fails, the error goes to launcher.log and the game still starts.
The bundled localhost server is suppressed during the launch
(win64\launch_server_and_db.bat is replaced by a stub and restored afterwards,
-launchLocalServer is dropped). Set SuppressLocalServer=false to keep it.

Mods
The manifest https://star-conflict-eu-server.mak17.workers.dev/sc-mods/manifest.txt
is built in (ModManifestUrl= in launcher-config.ini overrides it, an empty value
disables mods). Format, UTF-8, tab-separated, HTTPS only:

SCMOD1
relative/path<TAB>SHA-256<TAB>https://file/address

Every path and hash is validated. The first time a game file is replaced, the
original is saved under
%LOCALAPPDATA%\Targem\StarConflict\community-server-preset\mod-originals
and new files are listed in mod-added.txt, so removal restores the stock game.

News
Built-in feed https://star-conflict-eu-server.mak17.workers.dev/news.json
(NewsFeedUrl= overrides it). Format: {"version":2,"items":[{"id","date":"YYYY-MM-DD",
"url","ru":{"title","summary","url"},"en":{...}}]}; up to 10 items, 256 KB,
HTTPS links only; the last copy is cached for offline use.

Linux (Proton)
The launcher cannot reach the network under Proton (Wine-Mono name resolution).
Use the native script instead, then start the game from Steam as usual:
  curl -fsSL https://star-conflict-eu-server.mak17.workers.dev/linux/sc-mods.sh | bash
Undo: the same command with  bash -s -- --restore

Safety
- No logins, passwords or tokens are asked for or stored.
- Original game files are not included.
- The exe is not code-signed: Windows may show "Unknown publisher".

Removal
1. Remove the launcher line from the Steam launch options.
2. Run SC-Launcher.exe, Settings -> Remove modification. Game files go back to
   stock, the stock localhost / server entries return to the login screen.

Unofficial community utility, not affiliated with Gaijin or StarGem.
Launcher and login screen mod by GoldenCarrots (Discord: SeD0Y, sed0y_no_molod0y). Thank you!
