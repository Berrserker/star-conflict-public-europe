// Welcome setup for the public server: a login notification with links, plus a golden welcome
// letter (10 years of premium + community links) that every account receives once.
// Run ONCE: mongo.exe 127.0.0.1/cosmosim_<WindowsUser> welcome.js   (mongodump first)
if (db.adminMail.count({"attachments.1.type":8}) > 0) { print("ABORT: welcome letter already exists"); quit(1); }
var TG='[link href="https://t.me/star_conflict_europe" text="Telegram"]';
var SITE='[link href="https://star-conflict-eu-server.mak17.workers.dev/" text="star-conflict-eu-server.mak17.workers.dev"]';
var RD='[link href="https://www.reddit.com/r/StarConflict/comments/1x1t1fm/unofficial_server_eu_star_conflict_server_with/" text="Reddit"]';
var ST='[link href="https://steamcommunity.com/app/212070/discussions/0/582810614213135484/" text="Steam"]';
var body =
 "Добро пожаловать на неофициальный сервер Star Conflict Europe!|" +
 "В подарок — премиум на 10 лет, заберите его из этого письма.||" +
 "Новости и перезапуски: " + TG + "|" +
 "Сайт и FAQ: " + SITE + "|" +
 "Обсуждение: " + RD + " · " + ST + "||" +
 "Не используйте здесь пароль от аккаунта Gaijin.||" +
 "— — —||" +
 "Welcome to the Star Conflict Europe Unofficial Server!|" +
 "Here is 10 years of premium as a gift, claim it from this letter.||" +
 "News and restarts: " + TG + "|" +
 "Website & FAQ: " + SITE + "|" +
 "Discussion: " + RD + " · " + ST + "||" +
 "Do not use your Gaijin password here.";
var amid = db.counters.findAndModify({query:{_id:"amid"}, update:{$inc:{c:NumberLong(1)}}, new:true}).c;
var now = new Date(), exp = new Date(now.getTime() + 10*365*24*3600*1000);
db.adminMail.insert({amid:amid, sender:NumberLong(0), sentAt:now, expTime:exp, important:1, source:2, goldCost:0,
  attachments:{"0":{type:2, content:{subject:"Добро пожаловать! / Welcome!", body:body}},
               "1":{type:8, content:{premiumTime:NumberInt(315360000)}}}});
print("welcome adminMail amid " + amid + ", expires " + exp.toISOString() + ", body length " + body.length);
db.welcomeMsg.remove({lang:"ru"}); db.welcomeMsg.insert({lang:"ru", message:"Добро пожаловать на неофициальный сервер Star Conflict! Новости: [link href=\"https://t.me/star_conflict_europe\" text=\"Telegram\"] · Сайт: [link href=\"https://star-conflict-eu-server.mak17.workers.dev/ru/\" text=\"star-conflict-eu-server\"]"});
db.welcomeMsg.remove({lang:"en"}); db.welcomeMsg.insert({lang:"en", message:"Welcome to the Star Conflict Unofficial Server! News: [link href=\"https://t.me/star_conflict_europe\" text=\"Telegram\"] · Website: [link href=\"https://star-conflict-eu-server.mak17.workers.dev/\" text=\"star-conflict-eu-server\"]"});
db.welcomeMsg.find({},{_id:0}).forEach(function(d){print(d.lang+": "+d.message)});
