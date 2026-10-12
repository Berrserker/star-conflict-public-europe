// Send one command to the Hub SSH console and print what the console answered.
// Usage: node hubcmd.js <port> <password-file> "<console command>"
// The Hub's SSH server is old: it only speaks diffie-hellman-group14-sha1 / ssh-rsa / hmac-sha1,
// and the first handshake sometimes fails ("signature verification failed"), so we retry.
const { Client } = require("ssh2");
const fs = require("fs");

const [port, pwFile, command] = process.argv.slice(2);
if (!port || !pwFile || !command) {
  console.error('usage: node hubcmd.js <port> <password-file> "<command>"');
  process.exit(2);
}
const password = fs.readFileSync(pwFile, "utf8").trim();

function attempt() {
  return new Promise((resolve, reject) => {
    const conn = new Client();
    conn.on("ready", () => {
      conn.shell((err, stream) => {
        if (err) return reject(err);
        let out = "";
        stream.on("data", (d) => (out += d.toString()));
        setTimeout(() => stream.write(command + "\r"), 1500);
        setTimeout(() => { conn.end(); resolve(out); }, 5000);
      });
    })
      .on("error", reject)
      .connect({
        host: "127.0.0.1", port: Number(port), username: "admin", password, readyTimeout: 10000,
        algorithms: {
          serverHostKey: ["ssh-rsa"],
          kex: ["diffie-hellman-group14-sha1", "diffie-hellman-group1-sha1"],
          cipher: ["aes128-ctr", "aes256-ctr", "aes128-cbc", "aes256-cbc"],
          hmac: ["hmac-sha1"],
        },
      });
  });
}

(async () => {
  for (let i = 1; i <= 5; i++) {
    try {
      const out = await attempt();
      // Strip terminal escape codes and the character-by-character echo of the typed command.
      const lines = out.replace(/\x1b\[[0-9;]*[A-Za-z]/g, "").split(/\r?\n/)
        .filter((l) => l.trim() && !command.startsWith(l.trim().slice(-command.length)));
      console.log([...new Set(lines)].slice(-20).join("\n"));
      return;
    } catch (e) {
      console.error(`attempt ${i} failed: ${e.message}`);
    }
  }
  process.exit(1);
})();
