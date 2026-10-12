// Login notification (welcomeMsg, ru/en). Safe to re-run: replaces both documents.
// Run: mongo.exe 127.0.0.1/cosmosim_<WindowsUser> deploy\welcome-msg.js
var TG = "[link href=\"https://t.me/star_conflict_europe\" text=\"Telegram\"]";
var DC = "[link href=\"https://discord.gg/83YkbJbwxx\" text=\"Discord\"]";
var SITE_RU = "[link href=\"https://star-conflict-eu-server.mak17.workers.dev/ru/\" text=\"star-conflict-eu-server\"]";
var SITE_EN = "[link href=\"https://star-conflict-eu-server.mak17.workers.dev/\" text=\"star-conflict-eu-server\"]";
db.welcomeMsg.remove({lang:"ru"}); db.welcomeMsg.insert({lang:"ru", message:"Добро пожаловать на неофициальный сервер Star Conflict! Новости и общение: " + TG + " · " + DC + " · Сайт: " + SITE_RU});
db.welcomeMsg.remove({lang:"en"}); db.welcomeMsg.insert({lang:"en", message:"Welcome to the Star Conflict Unofficial Server! News and chat: " + TG + " · " + DC + " · Website: " + SITE_EN});
db.welcomeMsg.find({},{_id:0}).forEach(function(d){print(d.lang+": "+d.message)});
