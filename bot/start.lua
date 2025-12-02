--lua
log 'clear' log 'mode compact'
local bot = require("Bot/bot")
attackskills = "p5"
CHAR_NAME = "NorLand"
pet="9"
bot.verifyclient()
bot.verifypet()
while true do
bot.auto_attack_on_rev1()
end
