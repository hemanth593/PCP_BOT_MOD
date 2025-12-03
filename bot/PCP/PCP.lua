--[[ Reading game memory --]]
local PCP = {}
--local bot = require("Bot/bot")
local cred = require("Bot/cred")
local memory = require("Bot/memory")
local image = require("Bot/image")
local cords = require("Bot/cords")
local bot = require("Bot/bot")
local travel = require("Bot/travel")
local Boss = require("Boss/Boss")
--local cave = require("PCP/InsidePCP")
local getX = memory.getX
local getY = memory.getY
--local cave = require("PCP/InsidePCP")
--times
MS = 200
M = 500
S = 1000
SS = 2000
SSS = 3000
local path = {
    {xY = {}, via = {}},
	{xY = {}, via = {}}	
}
local gettotarget = {
        --{xY = {1411,353}, via = {0, 0}},
      --  {xY = {1410,342}, via = {918, 133}},
        {xY = {1411,330}, via = {920, 135}},
}
function PCP.cleanfile_allcsv()
	local path = [[PCP\]]  -- folder where CSVs are stored
	local resultarray, count = dir(path)

	if count and count > 0 then
	    for i = 1, #resultarray do
        	local filename = resultarray[i][1]

        	-- check if the file ends with .csv
        	if string.match(filename, "%.csv$") then
            	filedelete(filename)
            	log("Deleted: " .. filename)
        	end
    	end
	else
	    log("No files found.")
	end
end
function PCP.cleanfiles()
			wait(200)
    		filedelete([[PCP\]] .. Team1 .. [[.csv]])
			wait(200)
			filedelete([[PCP\]] .. Team2 .. [[.csv]])
			wait(200)
			filedelete([[PCP\]] .. Team3 .. [[.csv]])
			wait(200)
			filedelete([[PCP\]] .. Team4 .. [[.csv]])
			wait(200)
			filedelete([[PCP\]] .. LeaderName .. [[.csv]])
			wait(200)
   			filedelete([[PCP\]] .. Team1 .. [[cave.csv]])
			wait(200)
			filedelete([[PCP\]] .. Team2 .. [[cave.csv]])
			wait(200)
			filedelete([[PCP\]] .. Team3 .. [[cave.csv]])
			wait(200)
			filedelete([[PCP\]] .. Team4 .. [[cave.csv]])
			wait(200)
			filedelete([[PCP\]] .. LeaderName .. [[cave.csv]])
			wait(200)
end
function PCP.test()
	local targetX = 345  
	local targetY = 101   
	local tolerance = 5
	if memory.getLocation() == "Guild Demesne" then
		Boss.gettotargetspot_notstrict(targetX, targetY, tolerance)
	end
end
function PCP.gettotargetspot()
	log("relocating")
	PCP.travelPath(gettotarget)
end
function PCP.removedice()
	if image.find_image_center("dice.bmp") == 1 then
        send("ESCAPE")
        wait("1s")
        log("Cleared Screen")
    else
            log("Screen Clear")
            wait("1s")
    end	
end
function PCP.Guild()
	while memory.getLocation() ~= "Guild Demesne" do
		PCP.calendaropen()
		wait("1s")
		if memory.getLocation() == "Shark Sea" then  
			wait("1s")
			left(378, 328 )
			wait("1s")
		end 
		if memory.getLocation() == "Peacock River's Sorrow" then  
			wait("1s")
			left(378, 328 )
			wait("1s")
		end 
		if memory.getLocation() ~= "Peacock River's Sorrow" or memory.getLocation() ~= "Shark Sea" then
			left(217, 388)
			wait("2s")
		end
		PCP.calendarclose()
		wait("1s")

	end
	if Leader == "NO" then
			wait("1s")
			filedelete([[PCP\]] .. CHAR_NAME .. [[.csv]])
			log("Deleted file :".. CHAR_NAME)
			wait("1s")
	end
end
function PCP.sellitem()
	if memory.getLocation() == "Peacock River's Sorrow" then
		wait("1s")
		left(435, 387) --click on sell from minimap
		wait("1s")
		for i = 1, 10 do
			wait(200) 
    		left(455, 296)
   			wait(200)   -- optional delay
		end
		wait("1s")
		left(484, 713) --sellitem
	end
end
function PCP.removeapprenticedialogue()
	if image.find_image("appreok.bmp") == 1 then
		image.clickimage("appreok.bmp")
	end
end
function PCP.leaderteam()
	log("Trying to Team the members listed")
	while (not (image.count_image("PCP/team.bmp") + 1 == teamcount ) ) do
		local timeout = 60  -- seconds
    	local start = os.time()
		while (os.difftime(os.time(), start) < timeout) and (image.count_image("PCP/team.bmp") + 1 ~= teamcount ) do
    		wait("3s")
        	left(745, 745)
        	wait("1s")
				wait(100)
			write([[PCP\]] .. Team1 .. [[.csv]])
			wait(100)
			write([[PCP\]] .. Team2 .. [[.csv]])
			wait(100)
			write([[PCP\]] .. Team3 .. [[.csv]])
			wait(100)
			write([[PCP\]] .. Team4 .. [[.csv]])
			wait(100)
			if image.find_image("PCP/foelist.bmp") == 0 then
				log("Opening FoeList")
        		--left(745, 745)
        		wait("1s")
				left(628, 192)
				wait("1s")
				left(628, 192)
				wait("1s")
			end   
			PCP.removeapprenticedialogue()	
      		if teamcount >= 2 then
           		right(563, 270 )
           		wait("1s")
            	left(604, 406 )
            	wait("1s")
        	end
			PCP.removeapprenticedialogue()
        	if teamcount >= 3 then
            	right(568, 284 )
            	wait("1s")
            	left(605, 420 )
            	wait("1s")
        	end
			PCP.removeapprenticedialogue()
        	if teamcount >= 4 then
            	right(565, 296 )
            	wait("1s")
            	left(594, 429 )
            	wait("1s")
        	end
			PCP.removeapprenticedialogue()
        	if teamcount >= 5 then
           		right(567, 308 )
            	wait("1s")
            	left(592, 443 )
            	wait("1s")
        	end
			PCP.removeapprenticedialogue()
			if image.find_image("PCP/foelist.bmp") == 1 then
        		left(745, 745)
        		wait("1s")
				log("Closed FoeList")
			end	
        	while (not (image.count_image("PCP/team.bmp") + 1 == teamcount ) ) and (os.difftime(os.time(), start) < timeout) do
            	log("waiting for teammembers to join team")
        		wait(500)
			end
		--	bot.clearscreen()
			if Leader == "YES" then
				log("Leader yes but lets see what happens here")
				wait(500)
				right(50, 49)--(42, 40 )
				wait(500)
				right(90, 143)--(106, 112 )
				wait(500)
				left(235, 186)--(229, 119 )
				wait(500)
			end
		end
	end
end
function PCP.team()
		wait("2s")
		if Leader == "NO" then
		log("Im Not Leader of the team ")
			--PCP.Guild()
			while fileexists([[PCP\]] .. CHAR_NAME .. [[.csv]]) == "0" do 
				wait("1s")
			end	
    		--while (not (image.count_image("PCP/team.bmp") + 1 == teamcount ) ) and ( fileexists([[PCP\]] .. CHAR_NAME .. [[.csv]]) == "0" ) do
			while (not (image.count_image("PCP/team.bmp") + 1 == teamcount ) ) do 
--        		log("waiting for teammembers")
        		wait(500)
        		if image.count_image("PCP/exclamationon.bmp") == 1 then
					log("Click on Exclamation mark")
					wait(500)
            		left(14, 494 )
            		wait(1000)
        		end
				if image.find_image("PCP/teamreq.bmp") == 1 then
					log("Click on Team Request mark")
             		wait(500)
             		left(446, 331 )
              		wait(500)
            	end
				wait("2s")
				PCP.verifyleader()
    		end
    		log("Total team = ",image.count_image("PCP/team.bmp") + 1)
		else
			PCP.leaderteam()
		end
end
function PCP.verifyleader()
	--log(memory.getTeam1Name(),LeaderName )
	if memory.getTeam1Name() ~= LeaderName then
	--	log(memory.getTeam1Name()  )
		wait(1000)
		right(25, 196)
		wait(1000)
		left( 117, 329)
		wait(1000)
		right(40, 38)
		wait(1000)
		left(88, 89)
		wait(1000)
	end
end
function PCP.calendaropen()
	while image.find_image("calendar.bmp") == 0 do
		log("Click on minimap calendar")
        wait(500)
        left(841, 116 )
        wait(500)
    end
end
function PCP.calendarclose()
	while image.find_image("calendar.bmp") == 1 do
		log("Close calendar")
        wait(500)
        left( 595, 173 ) --Close calendar
        wait(500)
    end
end
function PCP.dead()
	local name = memory.charName()
	local CHARDEAD = "b"
	local hp = memory.get_current_HP()
	if hp < 1 then
	wait(S) 
	log(name.." is Dead!")
	wait(S)
	if CHARDEAD ~= nil then
		for i = 1, #CHARDEAD
		do
		log("Trying to use Jackstraw")
		left(cords.revive.jackstrawok[1], cords.revive.jackstrawok[2]) wait("3s")
		end
		end
        local hpn = memory.get_current_HP()
		if hpn < 1 then
			log("Jackstraw not found, Reviving normal...")
            left(cords.revive.okbutton[1], cords.revive.okbutton[2]) wait("3s")
            end
        log(name.." is Live Again !")
		--PCP.start()
	end
end
function convert_epoch_to_normal()
	epoch_time = os.time()
	return os.date("%Y-%m-%d %H:%M:%S", epoch)
end
function calculate_time_difference(epoch1, epoch2)
	return epoch2 - epoch1
end
function convertSecondsToTime(seconds)
	local hours = math.floor(seconds/3600)
    	local minutes = math.floor((seconds % 3600) / 60)
    	local remainingseconds = seconds % 60 
    	log ("Time Take to complete this PCP run in minutes :",hours,"h",minutes,"m",remainingseconds,"s")
end
function PCP.rev()
	if image.find_image("PCP/norevok.bmp") == 1 then
		send (attackskills)
		wait(300)
        left(515, 468)
		wait("1s")
		right(872, 89)
		wait("1s")
		send (attackskills)
		wait("1s")
	end	
end
function PCP.Dismissteam()
	log("readytodismiss")
	PCP.rev()
	while memory.Battle_Status() == 1 and memory.getLocation() == "Shark Sea" and PCP.team_dismissied() == 0 do
		PCP.rev()
		send("TAB")
		send(attackskills)
	end
	PCP.calendaropen()
		wait("1s")
	while memory.getLocation() == "Shark Sea" do
		PCP.rev()
		left(384, 271 ) -- PRS
	--	left(547, 265) -- LC
		wait("1s")
	end
	log("Left PCP to other cave")
	--log("sell item") 
	--if memory.getLocation() == "Peacock River's Sorrow" then
	--PCP.sellitem()
	--end
	while memory.getLocation() == "Lotus Cave" or memory.getLocation() == "Peacock River's Sorrow" do
		PCP.rev()
		wait("1s")
		left(378, 328) -- PRS
	--	left(547, 331) -- LC
		wait("1s")
	end
	log("Left PRS/LC")
	--if memory.getLocation() == "Green Scarp" then
	--	wait("1s")
	--	bot.surrounding("Qing")
	--	wait("5s")
	--	PCP.sellitem()
	--	log("Sold Items")
	--end
	
	while not ( memory.getLocation() == "Guild Demesne") do
		PCP.rev()
		left(217, 388)
		wait("1s")
	end
	log("In Guild")
	PCP.calendarclose()
	if Leader == "YES"  then
		local teams = {Team1, Team2, Team3, Team4}
		for i = 1, tonumber(teamcount) - 1 do
    		local filename = [[PCP\]] .. teams[i] .. [[cave.csv]]
			--log(filename)
    		if fileexists(filename) == "1" then
			--	log("inside fileexists loop : "..filename)
				filedelete(filename)
        		wait("1s")
    		end
		end
	end
	if Leader == "YES"  then
		local teams = {Team1, Team2, Team3, Team4}
		for i = 1, tonumber(teamcount) - 1 do
    		local filename = [[PCP\]] .. teams[i] .. [[.csv]]
			--log(filename)
    		while fileexists(filename) == "1" do
			--	log("inside fileexists loop : "..filename)
        		wait("1s")
    		end
		end
		
		wait("1s")
    	right(44, 44 )
    	wait("1s")
    	left(84, 159 )
    	wait("1s")
		log("Dismissed Team")
	else
		while memory.getLocation() ~= "Guild Demesne" do 
			PCP.Guild()
		end
	end
end
function PCP.attackmobs(X, Y)
	while (( memory.getLocation_cords(0) == X and memory.getLocation_cords(1) == Y and memory.dead() == 0 )) do
    	if image.find_image_center("PCP/specter_fish.bmp") == 1 or image.find_image_center("PCP/specter_shark.bmp") or image.find_image_center("PCP/specter_servant.bmp") then
       		if image.find_image_center("PCP/TargetHP.bmp") == 0 then
            	send(attackskills)
       		else
            	send("Tab")
       		end
    	end
	end
	if memory.dead() == 1 then
		PCP.dead()
	end
	while not (( memory.getLocation_cords(0) == X and memory.getLocation_cords(1) == Y )) do
            Boss.gettotargetspot(tonumber(X),tonumber(Y))
    end
end
function PCP.lurefirst(X, Y)
 --   X = a
  --  Y = b
	log(memory.getLocation_cords(0),memory.getLocation_cords(1))
    while not ((memory.getLocation_cords(0) == X and memory.getLocation_cords(1) == Y)) do
        Boss.gettotargetspot(tonumber(X), tonumber(Y))
    end
end
function  PCP.Targethpzero()
	if memory.targetHPpercent() == 0 then
		return 1
	else
		return 0 
	end
end
function  PCP.spector_fish()
	if image.find_image_target("PCP/specter_fish.bmp") == 1  then	
		return 1
	else
		return 0 
	end
end
function PCP.spector_fish_down()
	if PCP.Targethpzero() == 1 and PCP.spector_fish() == 1 then 
		return 1
	else
		return 0 
	end	
end
function  PCP.spector_shark()
	--if image.find_image_target("PCP/specter_servant.bmp") == 1 and image.find_image_target("PCP/TargetHP.bmp") == 0 then 
	if image.find_image_target("PCP/specter_shark.bmp") == 1  then	
		return 1 --not dead 
	else
		return 0 -- doesnt mean dead either
	end
end
function PCP.spector_shark_down()
	if PCP.Targethpzero() == 1 and PCP.spector_shark() == 1 then 
		return 1
	else
		return 0 
	end	
end
function  PCP.spector_servant()
	--if image.find_image_target("PCP/specter_servant.bmp") == 1 and image.find_image_target("PCP/TargetHP.bmp") == 0 then 
	if image.find_image_target("PCP/specter_servant.bmp") == 1 then	
		return 1
	else
		return 0 
	end
end
function PCP.spector_servant_down()
	if PCP.Targethpzero() == 1 and PCP.spector_servant() == 1 then 
		return 1
	else
		return 0 
	end	
end
function  PCP.Coral()
	--if image.find_image_target("PCP/ICON_Coral.bmp") == 1 and image.find_image_target("PCP/TargetHP.bmp") == 0 then 
	if image.find_image_target("PCP/ICON_Coral.bmp") == 1 then
		return 1 
	else
		return 0 
	end
end
function PCP.Coral_down()
	if PCP.Targethpzero() == 1 and PCP.Coral() == 1 then 
		return 1
	else
		return 0 
	end	
end
function  PCP.YeChun()
	--if image.find_image_target("PCP/ICON_Coral.bmp") == 1 and image.find_image_target("PCP/TargetHP.bmp") == 0 then 
	if image.find_image_target("PCP/ICON_YeChun.bmp") == 1 then
		return 1 
	else
		return 0 
	end
end
function PCP.YeChun_down()
	if PCP.Targethpzero() == 1 and PCP.YeChun() == 1 then 
		return 1
	else
		return 0 
	end	
end
function  PCP.team_dismissied()
	if image.find_image("PCP/team.bmp") == 0 then 
		return 1
	else
		return 0 
	end
end
function  PCP.team_count_met()
	if image.count_image("PCP/team.bmp") > 2 then
		return 1
	else
		return 0 
	end
end
function PCP.convert_epoch_to_normal()
	epoch_time = os.time()
	return os.date("%Y-%m-%d %H:%M:%S", epoch)
end
function PCP.calculate_time_difference(epoch1, epoch2)
	return epoch2 - epoch1
end
function PCP.convertSecondsToTime2(seconds)
	local hours = math.floor(seconds/3600)
	local minutes = math.floor((seconds % 3600) / 60)
    	local remainingseconds = seconds % 60 
    	log ("Time Taken to Enter PCP ^:",hours,"h",minutes,"m",remainingseconds,"s")
	wait(300)
end
function PCP.convertSecondsToTime1(seconds)
	local hours = math.floor(seconds/3600)
	local minutes = math.floor((seconds % 3600) / 60)
    	local remainingseconds = seconds % 60 
    	log ("Total Time in Cave ^:",hours,"h",minutes,"m",remainingseconds,"s")
	wait(300)
end
function PCP.allattackaoe()
	--while memory.getLocation() == "Shark Sea" and PCP.team_dismissied() == 0  and PCP.YeChun_down() == 0 do
	while memory.getLocation() == "Shark Sea" and PCP.team_dismissied() == 0 and PCP.team_count_met() == 1 and memory.CharHPpercent() > 1 and image.find_image("PCP/norevok.bmp") == 0 and image.find_image_target("PCP/notarget.bmp") == 1 and (PCP.Targethpzero() == 0) and (PCP.YeChun_down() == 0) do
			send (aoe)
	end
	PCP.rev()
	if PCP.YeChun_down() == 1  then 
		if team == "1" then
			wait(200)
	 		filedelete ([[PCP\]] .. LeaderName .. [[cave.csv]])
		end
		if team == "2" then
			wait(400)
	 		filedelete ([[PCP\]] .. LeaderName .. [[cave.csv]])
		end
		if team == "3" then
			wait(600)
	 		filedelete ([[PCP\]] .. LeaderName .. [[cave.csv]])
		end
		if team == "4" then
			wait(800)
	 		filedelete ([[PCP\]] .. LeaderName .. [[cave.csv]])
		end
		if team == "5" then
			wait(100)
	 		filedelete ([[PCP\]] .. LeaderName .. [[cave.csv]])
		end
		
		--PCP.setFlag(0) 
		PCP.Dismissteam()

	end
	if image.find_image_target("PCP/notarget.bmp") == 0 then 
		send("TAB")
		wait(200)
	end
	if PCP.Targethpzero() == 1 then
		send("TAB")
	end
--	end
end
function PCP.allattack()
	--while memory.getLocation() == "Shark Sea" and PCP.team_dismissied() == 0  and PCP.YeChun_down() == 0 do
	while memory.getLocation() == "Shark Sea" and PCP.team_dismissied() == 0 and PCP.team_count_met() == 1 and memory.CharHPpercent() > 1 and image.find_image("PCP/norevok.bmp") == 0 and image.find_image_target("PCP/notarget.bmp") == 1 and (PCP.Targethpzero() == 0) and (PCP.YeChun_down() == 0) do
			send (attackskills)
	end
	PCP.rev()
	if PCP.YeChun_down() == 1  then 
		if team == "1" then
			wait(200)
	 		filedelete ([[PCP\]] .. LeaderName .. [[cave.csv]])
			wait("1s")
			filedelete([[PCP\]] .. CHAR_NAME .. [[cave.csv]])
			wait("1s")
		end
		if team == "2" then
			wait(200)
	 		filedelete ([[PCP\]] .. LeaderName .. [[cave.csv]])
			wait("1s")
			filedelete([[PCP\]] .. CHAR_NAME .. [[cave.csv]])
			wait("1s")
		end
		if team == "3" then
			wait(200)
	 		filedelete ([[PCP\]] .. LeaderName .. [[cave.csv]])
			wait("1s")
			filedelete([[PCP\]] .. CHAR_NAME .. [[cave.csv]])
			wait("1s")
		end
		if team == "4" then
			wait(200)
	 		filedelete ([[PCP\]] .. LeaderName .. [[cave.csv]])
			wait("1s")
			filedelete([[PCP\]] .. CHAR_NAME .. [[cave.csv]])
			wait("1s")
		end
		if team == "5" then
			wait(200)
	 		filedelete ([[PCP\]] .. LeaderName .. [[cave.csv]])
			wait("1s")
		end
		
		--PCP.setFlag(0) 
		PCP.Dismissteam()

	end
	if image.find_image_target("PCP/notarget.bmp") == 0 then 
		send("TAB")
		wait(200)
	end
	if PCP.Targethpzero() == 1 then
		send("TAB")
	end
--	end
end
function PCP.inside1()
	local targetX = 270 
    local targetY = -24 
    local tolerance = 15
	log("inside script")
	epoch15 = os.time()
	resettime = 150
	wait("1s")
	write([[PCP\]] .. CHAR_NAME .. [[cave.csv]])
	wait("1s")
	 while (fileexists([[PCP\]] .. CHAR_NAME .. [[cave.csv]]) == "1") do  ---PCP.team_dismissied() == 0  do  --PCP.YeChun_down() == 1	
		if not Boss.isInToleranceArea(targetX, targetY, tolerance) then
			wait("1s")
			right(872, 89)
			wait("1s")
			if (memory.getLocation() == "Shark Sea") and (fileexists([[PCP\]] .. CHAR_NAME .. [[cave.csv]]) == "1") then
			Boss.gettotargetspot_notstrict(targetX, targetY, tolerance)
			end
	--		if (PCP.team_dismissied() == 0) and (PCP.YeChun_down() == 0) then
	--			if bot.timerclock1(epoch15) <= resettime then
	--				PCP.allattackaoe()
	--			else
	--				PCP.allattack()
	--			end		
	--		end
			wait(500)
    	else
			if bot.timerclock1(epoch15) <= resettime then
				PCP.allattackaoe()
			else
				PCP.allattack()
			end		
    	end
	end
	log("finished inside")
	if  memory.getLocation() == "Shark Sea" then 
		PCP.Dismissteam()
	end
end
function PCP.inside3()
	local targetX = 270 
    local targetY = -24 
    local tolerance = 15
	log("inside script")
	epoch15 = os.time()
	resettime = 150
	wait("1s")
	write([[PCP\]] .. CHAR_NAME .. [[cave.csv]])
	wait("1s")
	 while (PCP.YeChun_down() == 0 or PCP.team_dismissied() == 0 ) and (memory.getLocation() == "Shark Sea") and (fileexists([[PCP\]] .. CHAR_NAME .. [[cave.csv]]) == "1") do  ---PCP.team_dismissied() == 0  do  --PCP.YeChun_down() == 1	
		if not Boss.isInToleranceArea(targetX, targetY, tolerance) then
			wait("1s")
			right(872, 89)
			wait("1s")
			if memory.getLocation() == "Shark Sea" then
			Boss.gettotargetspot_notstrict(targetX, targetY, tolerance)
			end
	--		if (PCP.team_dismissied() == 0) and (PCP.YeChun_down() == 0) then
	--			if bot.timerclock1(epoch15) <= resettime then
	--				PCP.allattackaoe()
	--			else
	--				PCP.allattack()
	--			end		
	--		end
			wait(500)
    	else
			if bot.timerclock1(epoch15) <= resettime then
				PCP.allattackaoe()
			else
				PCP.allattack()
			end		
    	end
	end
	log("finished inside")
	if  memory.getLocation() == "Shark Sea" then 
		PCP.Dismissteam()
	end
end
function PCP.inside2()
 		local targetX = 270 
   		local targetY = -24 
    	local tolerance = 15
	epoch16 = os.time()
	resettime1 = 150
	log("inside script")
	--while (PCP.YeChun_down() == 0 or PCP.team_dismissied() == 0 or image.count_image("PCP/team.bmp") + 1 ~= teamcount ) do  ---PCP.team_dismissied() == 0  do  --PCP.YeChun_down() == 1	
 
		while fileexists([[PCP\]] .. LeaderName .. [[cave.csv]]) == "1" do
 
		local targetX = 270 
   		local targetY = -24 
    	local tolerance = 15
		if not Boss.isInToleranceArea(targetX, targetY, tolerance) then
			wait("1s")
			right(872, 89)
			wait("1s")
			if memory.getLocation() == "Shark Sea" then
			Boss.gettotargetspot_notstrict(targetX, targetY, tolerance)
			end
		--	if (PCP.team_dismissied() == 0) and (PCP.YeChun_down() == 0) then
		--		if bot.timerclock1(epoch16) <= resettime1 then
		--			PCP.allattackaoe()
		--		else
		--			PCP.allattack()
		--		end	
		--	end
			wait(500)
    	else
			if bot.timerclock1(epoch16) <= resettime1 then
				PCP.allattackaoe()
			else
				PCP.allattack()
			end		
    	end
	--	end
	end
	log("finished inside")
	if  memory.getLocation() == "Shark Sea" then 
		PCP.Dismissteam()
	end
	log("verified fileexists")
	while memory.Battle_Status() == 1 and memory.getLocation() == "Shark Sea" do
		send("TAB")
		send(attackskills)
	end
end
function PCP.Waitteam()
	local targetX = -717  
	local targetY = 691   
	local tolerance = 5
	--log("entered waitteam function")
	wait("2s")
	PCP.team()
	wait("2s")
	if Leader == "YES" then
		write([[PCP\]] .. LeaderName .. [[cave.csv]])--write([[PCP\]] .. LeaderName .. [[cave.csv]])
	end
	--PCP.setFlag(1) 
	PCP.calendaropen()
	while not ( memory.getLocation_cords(0) == "351" and memory.getLocation_cords(1) == "-60" ) do
		wait("1s")
		left("322, 267") -- calendar
	end
	if memory.getLocation_cords(0) == "351" and memory.getLocation_cords(1) == "-60" then
		log("Entered Cave")
		PCP.calendarclose()
	end
	wait("2s")
	--break
end
function PCP.start()
    PCP.Guild()
	log("In Guild")
	epoch1 = os.time()
	log("Started PCP time :",PCP.convert_epoch_to_normal())
	--bot.verifypet()
	PCP.removedice()
	bot.Viewreset()
	wait("1s")
    send(Petfood)
    wait("1s")
	image.inventorydelete([[PCP\itemdelete\]])
	wait("1s")
  	PCP.Waitteam()
	bot.Viewreset()
	if memory.getLocation() == "Shark Sea" then 
		epoch2 = os.time()
		log("Entered PCP :", PCP.convert_epoch_to_normal() )
		log(PCP.convertSecondsToTime2(PCP.calculate_time_difference(epoch1, epoch2)))
		if Leader == "YES" then
			PCP.inside2()
		else
			PCP.inside1()
		end
		epoch3 = os.time()
		log("Ended Cave Time :", PCP.convert_epoch_to_normal() )
		log(PCP.convertSecondsToTime1(PCP.calculate_time_difference(epoch2, epoch3))) 
		wait(300)
	end
	epoch4 = os.time()
	--log("Ended PCP Time :", PCP.convert_epoch_to_normal() )
	log(convertSecondsToTime(PCP.calculate_time_difference(epoch1, epoch4))) 
	wait(300)
end
return PCP
