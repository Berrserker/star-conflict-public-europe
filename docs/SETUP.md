# Setting up a server

## Requirements
- **Windows.** All server processes are 32-bit Windows programs. They need no extra VC++ or DirectX runtimes. Tested on Windows Server 2025 (VPS) and Windows 10 (home PC).
- **Star Conflict installed through Steam** on the same machine. The server files ship with the game.
- **Hardware.** The services use about 1.2 GB of RAM idle, and each running battle adds about 250 MB. A 4-core, 8 GB VPS handles a few hundred players comfortably.
- **A public IPv4 address.** For a home server, the router needs port forwarding and must not sit behind CGNAT.
- **Node.js** (LTS), only for the restart-with-countdown tool.

## Ports
| Port | Service | Expose |
|---|---|---|
| 3801 TCP | LoadBalancer: clients connect here | open |
| 3802 TCP | Shard | open |
| 3815 TCP | ChatServer | open |
| 35000–35050 UDP | Battle servers, one port per battle | open |
| 3850 TCP | Hub (internal) | **block** |
| 9001 TCP | Hub HTTP/JSONP interface | **block** |
| 2222 TCP | Battle server SSH | **block** |
| 2224 TCP | Hub SSH console (if enabled for restarts) | **block** |
| 27017 TCP | MongoDB (binds 127.0.0.1) | **block** |

Hub listens on `0.0.0.0`, so the firewall is what actually protects the internal ports. If your host has its own network firewall (OVH, Hetzner and others do), open the same ports there.

## Install
1. **Harden remote access first** (VPS):
   - set a long admin password and enable NLA;
   - allow RDP only from your IP, or use a VPN such as WireGuard;
   - install Windows updates.
2. Install Steam, log in and install Star Conflict.
3. Copy the `deploy` folder to the machine, for example `C:\SC\deploy`.
4. Run as Administrator:
   ```powershell
   cd C:\SC\deploy
   powershell -ExecutionPolicy Bypass -File setup.ps1 -PublicIp <your public IPv4>
   ```
   The script does the following:
   - copies the game from the Steam folder to `C:\SC\server`. **Never run the server from the Steam folder**: Steam updates and file verification would overwrite the changes;
   - copies `deploy\files` over it;
   - writes your public IP into `cloud\data\cloud.xml` (default `127.0.0.1`). The server hands this address to clients;
   - creates firewall rules: opens the client ports, blocks the internal ones;
   - registers a daily MongoDB backup at 05:00 into `C:\SC\backups` and keeps the last 14.

   Optional parameters: `-SteamGameDir`, `-ServerDir`, `-DbDir`, `-BackupDir`.
5. Start the server:
   ```powershell
   powershell -ExecutionPolicy Bypass -File C:\SC\deploy\start.ps1
   ```
   After about 30 s you should see about 19 processes from `C:\SC\server\cloud`.
6. Connect from a client: on the login screen switch `localhost` → `server`, enter your address and port `3801`, then a new login and password. Accounts are created on first login.

## Welcome message and premium (optional)
`deploy\welcome.js` creates a login notification with links and a one-time golden letter with 10 years of premium for every account, new ones included. **Edit the links and texts at the top of the file first**, they point to our community. Then run it once while the server is running:
```powershell
& "C:\SC\server\cloud\mongodb\mongo.exe" 127.0.0.1/cosmosim_<WindowsUser> C:\SC\deploy\welcome.js
```
The database name ends with the Windows user that runs the server, for example `cosmosim_Administrator`. `welcome-msg.js` only updates the login notification and is safe to re-run.

## Stop
Always use `stop.ps1`. It stops the services and shuts MongoDB down cleanly. Killing `mongod` or rebooting without it can corrupt the database.
```powershell
powershell -ExecutionPolicy Bypass -File C:\SC\deploy\stop.ps1
```
On a VPS, disconnect from RDP instead of signing out: signing out ends the session and kills the processes started in it.

## Restart with a countdown
One-time setup (as Administrator, then restart the server once):
```powershell
powershell -ExecutionPolicy Bypass -File C:\SC\deploy\maintenance\setup-console.ps1
cd C:\SC\deploy\maintenance; npm install
```
This enables Hub's built-in SSH console on port 2224 with a random password stored next to the server (`server\cloud\hub_console.pw`) and blocks the port in the firewall. Then:
```powershell
powershell -ExecutionPolicy Bypass -File C:\SC\deploy\maintenance\restart.ps1 -Minutes 10           # countdown, backup, stop, start
powershell -ExecutionPolicy Bypass -File C:\SC\deploy\maintenance\restart.ps1 -Minutes 10 -NoStart  # leave stopped (e.g. before a reboot)
powershell -ExecutionPolicy Bypass -File C:\SC\deploy\maintenance\restart.ps1 -Cancel               # cancel a countdown
```

## Applying config changes
- `cloud\data\default_platform_config.lua` and `cloud\data\shard.cfg` are read when the server starts. Edit them, then restart.
- Most other xml files in `cloud\data` are **generated** from the lua files in `data\gamedata`. Edit the lua, then regenerate (see [ADMIN.md](ADMIN.md#regenerating-game-data)) and restart. Do not edit the generated xml by hand.
- Lua files are cp1251 with CRLF line endings. Keep the encoding and a backup copy.
- Diff before you copy: `git diff --no-index --text <server file> <new file>`.

## Logs
- Service logs: `%LOCALAPPDATA%\Targem\StarConflict\cloud\Hub\logs\` (`*_shard_*.log`, `*_matchmaker_*.log`, …), plus one folder per day with a `dediserver*.log` per battle.
- Crash dumps: `C:\SC\server\cloud\Exceptions`.

## Troubleshooting
- **Clients can't connect.** Check `cloud.xml` (it must hold the public IP), the Windows firewall and your host's network firewall. From outside, `Test-NetConnection <ip> -Port 3801` must succeed.
- **Login works but battles never start.** UDP 35000–35050 is closed somewhere.
- **"There is no my node in xml" on start (home server behind a router).** Hub checks that the address in `cloud.xml` belongs to one of the machine's own network adapters. Behind NAT the public IP doesn't, so use a VPS, or a VM or tunnel that owns the public address.
- **A service keeps crashing.** Read its log and check `Exceptions`. MongoDB dying under memory pressure: give Windows a bigger pagefile (we use 8–16 GB on an 8 GB VPS).
- **`cloud\mongodb\launch.bat` fails under cmd.** Start `mongod.exe` directly, as `start.ps1` does.

## Rules worth repeating to players
- The login becomes the public in-game nickname, so players should not use an e-mail address as the login.
- Players should never reuse their Gaijin or e-mail password. The stock server does not store passwords in a strong way.
- The server stores player IPs, hardware fingerprints and system info (`accountsStats`). In the EU that means GDPR: publish a privacy notice.
