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
function PCP.gettotargetspot()
	log("relocating")
	PCP.travelPath(gettotarget)
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


function PCP.Dismissteam()
	if Leader == "YES" and YeChun_down() == 1 then
		wait("1s")
    	right(44, 44 )
    	wait("1s")
    	left(84, 159 )
    	wait("1s")
		wait("61s")
	else
		wait("65s")
	end
end

function PCP.attack(attackskills)
	if memory.mount_status() == 1 then
		wait(300)
		send(mountkey)
		wait("2s")
    	end
	while memory.Battle_Status() == 1 do
		send("Tab")
		wait(100)
		send(attackskills)
	end
	wait("2s")
end

function PCP.convertSecondsToTime(seconds)
	local hours = math.floor(seconds/3600)
	local minutes = math.floor((seconds % 3600) / 60)
    	local remainingseconds = seconds % 60 
    	log ("Time Taken to complete this PCP run :",hours,"h",minutes,"m",remainingseconds,"s")
	wait(300)
end



function PCP.start1()
    wait("1s")
    send(Petfood)
    wait("1s")
    starttime=os.time()
    while bot.timerclock1(starttime) < 3000 do
         PCP.outsidePCP()
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

--
function  spector_fish()
	--if image.find_image_target("PCP/specter_fish.bmp") == 1 and image.find_image_target("PCP/TargetHP.bmp") == 0 then 
	if image.find_image_target("PCP/specter_fish.bmp") == 1 and Targethpzero() == 0 then	
		return 1
	else
		return 0 -- you need to tab	
	end
end
function  spector_servant()
	--if image.find_image_target("PCP/specter_servant.bmp") == 1 and image.find_image_target("PCP/TargetHP.bmp") == 0 then 
	if image.find_image_target("PCP/specter_servant.bmp") == 1 and Targethpzero() == 0 then	
		return 1
	else
		return 0 
	end
end
function  spector_shark()
	--if image.find_image_target("PCP/specter_shark.bmp") == 1 and image.find_image_target("PCP/TargetHP.bmp") == 0 then 
	if image.find_image_target("PCP/specter_shark.bmp") == 1 and Targethpzero() == 0 then		
		return 1 
	else
		return 0 
	end
end
function  YeChun()
	--if image.find_image_target("PCP/ICON_YeChun.bmp") == 1 and image.find_image_target("PCP/TargetHP.bmp") == 0 then 
	if image.find_image_target("PCP/ICON_YeChun.bmp") == 1 and Targethpzero() == 0 then
		return 1
	else
		return 0 
	end
end
function  PCP.YeChun()
	--if image.find_image_target("PCP/ICON_YeChun.bmp") == 1 and image.find_image_target("PCP/TargetHP.bmp") == 0 then 
	if image.find_image_target("PCP/ICON_YeChun.bmp") == 1 and Targethpzero() == 0 then
		return 1
	else
		return 0 
	end
end
function  Coral()
	--if image.find_image_target("PCP/ICON_Coral.bmp") == 1 and image.find_image_target("PCP/TargetHP.bmp") == 0 then 
	if image.find_image_target("PCP/ICON_Coral.bmp") == 1 and Targethpzero() == 0 then
		return 1 
	else
		return 0 
	end
end
function  Targethpzero()
--	if image.find_image_target("PCP/TargetHP.bmp") == 1 then 
	if memory.targetHPpercent() == 0 then
		return 1
	else
		return 0 
	end
end
function  PCP.Targethpzero()
--	if image.find_image_target("PCP/TargetHP.bmp") == 1 then 
	if memory.targetHPpercent() == 0 then
		return 1
	else
		return 0 
	end
end
function  YeChun_down()
	if Targethpzero() == 1 and YeChun() == 1 then 
		return 1
	else
		return 0 
	end
end
function  PCP.YeChun_down()
	if Targethpzero() == 1 and YeChun() == 1 then 
		return 1
	else
		 -- log(Targethpzero(),YeChun())
		return 0 
	end
end
function  team_dismissied()
	if image.find_image("PCP/team.bmp") == 0 then 
		return 1
	else
		return 0 
	end
end
function PCP.sendtab()
	local targetX = 270--283
    local targetY = -24---30
    local tolerance = 15
	if not Boss.isInToleranceArea(targetX, targetY, tolerance) then
		log("Not in area, navigating to PCP combat area (non-strict)")
		wait(500)
		right(872, 89)
		Boss.gettotargetspot_notstrict(targetX, targetY, tolerance)
		if YeChun_down() == 0 then
			send("TAB")
		else
			PCP.Dismissteam()
		end
	else
		if YeChun_down() == 0 then
			send("TAB")
		else
			PCP.Dismissteam()
		end
	end
end
 
--

function PCP.Waitteam()
	log("entered waitteam function")
	wait("2s")
	while not ( memory.getLocation_cords(0) == "-717" and memory.getLocation_cords(1) == "691" ) do
		log("Verify Character ENTRY COORDS")
		wait("1s")
		if memory.getLocation() == "Cloud Palace" then 
			log("Moving Char to ENTRY COORDS")
			left(751, 254)
			wait("1s")
		end
	end
	if memory.getLocation_cords(0) == "-717" and memory.getLocation_cords(1) == "691" then
		log("At ENTRY COORDS")
		wait("2s")
		if Leader == "NO" then
			log("Im Not Leader of the team ")
    		while (not (image.count_image("PCP/team.bmp") + 1 == teamcount ) ) do
        		log("waiting for teammembers")
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
    		end
    		log("Total team = ",image.count_image("PCP/team.bmp") + 1)
		else
    		wait("30s")
        	left(745, 745)
        	wait("1s")
		-- SSC.Viewreset()
			if image.find_image("PCP/foelist.bmp") == 0 then
				log("Opening FoeList")
        		--left(745, 745)
        		wait("1s")
				left(628, 192)
				wait("1s")
				left(628, 192)
				wait("1s")
			end   	
      		if teamcount >= 2 then
           		right(563, 270 )
           		wait("1s")
            	left(604, 406 )
            	wait("1s")
        	end
        	if teamcount >= 3 then
            	right(568, 284 )
            	wait("1s")
            	left(605, 420 )
            	wait("1s")
        	end
        	if teamcount >= 4 then
            	right(565, 296 )
            	wait("1s")
            	left(594, 429 )
            	wait("1s")
        	end
        	if teamcount >= 5 then
           		right(567, 308 )
            	wait("1s")
            	left(592, 443 )
            	wait("1s")
        	end
			if image.find_image("PCP/foelist.bmp") == 1 then
        		left(745, 745)
        		wait("1s")
			end	
        	while (not (image.count_image("PCP/team.bmp") + 1 == teamcount ) ) do
            	log("waiting for teammembers to join team")
        		wait(500)
			end
			bot.clearscreen()
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
		while not ( memory.getLocation_cords(0) == "351" and memory.getLocation_cords(1) == "-60" ) do
			log("Trying to enter cave")
			if image.find_image_target("PCP/ICON_SFD.bmp") then
				log("Target SFD Selected")
				while image.find_image("PCP/PCPDialogue.bmp") == 0 do
					log("Opening SFD DIALOGUE BOX")
					wait(30)
					double_right(636, 230 ) -- NPC Soul of Flood Dragon
					wait(30)
					--double_right(513, 410)
					wait(30)
				end
				if image.find_image("PCP/PCPDialogue.bmp") == 1 then
					log("Opened SFD DIALOGUE BOX and enter cave attempted")
					wait(300)
					left(316, 512) -- NPC Soul of Flood Dragon Dialogue box line "Enter Purple Cloud Palace"
					wait("2s")			
				end
				wait("3s")
			end
		end
	end
	if memory.getLocation_cords(0) == "351" and memory.getLocation_cords(1) == "-60" then
		log("Entered Cave")
	end
	wait("2s")
	--break
end
function PCP.convert_epoch_to_normal()
	epoch_time = os.time()
	return os.date("%Y-%m-%d %H:%M:%S", epoch)
end

function PCP.calculate_time_difference(epoch1, epoch2)
	return epoch2 - epoch1
end

function PCP.convertSecondsToTime(seconds)
	local hours = math.floor(seconds/3600)
	local minutes = math.floor((seconds % 3600) / 60)
    	local remainingseconds = seconds % 60 
    	log ("Time Taken to complete this BC run :",hours,"h",minutes,"m",remainingseconds,"s")
	wait(300)
end

function PCP.mobattack()
	if image.find_image("PCP/norevok.bmp") == 1 then
		wait(300)
        left(515, 468)
		wait("1s")
		--if memory.getLocation_cords(0) == "351" and memory.getLocation_cords(1) == "-60" then
			right(872, 89)
			wait("1s")
			send (attackskills)
			wait("1s")
		--end
    else
		if ((image.find_image("PCP/specter_fish.bmp") == 1 or image.find_image("PCP/specter_shark.bmp") == 1 or image.find_image("PCP/specter_servant.bmp") == 1) and (image.find_image_target("PCP/TargetHP.bmp") == 0)) then
			wait(100)
      		send (attackskills)
		else
			if (image.find_image_target("PCP/TargetHP.bmp") == 1) then
				send("TAB")
				wait(100)
			else
				send("TAB")
				wait(100)		
			end
		end
	end
end

function PCP.inside()
	if not (( memory.getLocation_cords(0) == "283" and memory.getLocation_cords(1) == "-30" ))  then -- or (image.find_image_target("PCP/TargetHP.bmp") == 1 )
		--if memory.getLocation_cords(0) == "351" and memory.getLocation_cords(1) == "-60" then
		right(872, 89)
		wait("1s")
		send (attackskills)
		wait("1s")
		--end
        Boss.gettotargetspot(tonumber("283"),tonumber("-30"))
    end
--		while ((image.find_image("PCP/deadbox.bmp") == 0))
	while (image.find_image_target("PCP/TargetHP.bmp") == 0 ) do 
		PCP.mobattack()
	end
	
end
function PCP.allattack1()
	--while (image.find_image_target("PCP/TargetHP.bmp") == 0 ) do 

		send (attackskills)
		--send("TAB")
	   	log("Attacking mob")
		if image.find_image("PCP/norevok.bmp") == 1 or image.find_image_target("PCP/notarget.bmp") == 0 then
			log("Attacking mob1")
			if image.find_image_target("PCP/notarget.bmp") == 0 then 
				send("TAB")
			end
			send (attackskills)
			wait(300)
        	left(515, 468)
			wait("1s")
		--if memory.getLocation_cords(0) == "351" and memory.getLocation_cords(1) == "-60" then
		--	right(872, 89)
			wait("1s")
			send (attackskills)
			wait("1s")
		end
   		while (image.find_image_target("PCP/specter_fish.bmp") == 0 and image.find_image_target("PCP/specter_shark.bmp") == 0 and image.find_image_target("PCP/specter_servant.bmp") == 0 and image.find_image_target("PCP/TargetHP.bmp") == 1) do
        	log("TAB 1")
			send("TAB")
        	wait(100)
    	end
    	while (image.find_image_target("PCP/specter_fish.bmp") == 1 or image.find_image_target("PCP/specter_shark.bmp") == 1 or image.find_image_target("PCP/specter_servant.bmp") == 1) and (image.find_image_target("PCP/TargetHP.bmp") == 0) and (image.find_image("PCP/norevok.bmp") == 0) do
          	log("Attacking mob2")
			send(attackskills)
    	end


	--end
end
function PCP.allattack()
 
	while team_dismissied() == 0 do
		send (attackskills)
	   	log("Attacking mob")
		if (image.find_image("PCP/norevok.bmp") == 1 or image.find_image_target("PCP/notarget.bmp") == 0) then
			log("Attacking mob1")
			if image.find_image_target("PCP/notarget.bmp") == 0 then 
				--send("TAB")
				PCP.sendtab()
			else
				send (attackskills)
				wait(300)
        		left(515, 468)
				
		--if memory.getLocation_cords(0) == "351" and memory.getLocation_cords(1) == "-60" then
				wait("1s")
				right(872, 89)
				wait("1s")
				send (attackskills)
				wait("1s")
			end
		end
   		while (spector_fish() == 0 and spector_shark() == 0 and spector_servant() == 0 and YeChun() == 0 and Coral() == 0 and Targethpzero() == 1 and (team_dismissied() == 0) and (YeChun_down() == 0) )  do 
			--image.find_image_target("PCP/ICON_YeChun.bmp") == 0 and image.find_image_target("PCP/ICON_Coral.bmp") == 0 and image.find_image_target("PCP/specter_fish.bmp") == 0 and image.find_image_target("PCP/specter_shark.bmp") == 0 and image.find_image_target("PCP/specter_servant.bmp") == 0 and image.find_image_target("PCP/TargetHP.bmp") == 1) do
        	log("TAB 1")
			--send("TAB")
			PCP.sendtab()
        	wait(100)
    	end
    	while (spector_fish() == 1 or spector_shark() == 1 or spector_servant() == 1 or YeChun() == 1 or Coral() == 1) and (Targethpzero() == 0) and (image.find_image("PCP/norevok.bmp") == 0) and (team_dismissied() == 0) and (YeChun_down() == 0) do
			--image.find_image_target("PCP/specter_fish.bmp") == 1 or image.find_image_target("PCP/specter_shark.bmp") == 1 or image.find_image_target("PCP/specter_servant.bmp") == 1) and (image.find_image_target("PCP/TargetHP.bmp") == 0) and (image.find_image("PCP/norevok.bmp") == 0) do
          	log("Attacking mob2")
			
--			if YeChun_down() == 1 then 
--				if Leader == "YES" then
--					PCP.Dismissteam()
--					wait("61s")
--				else
--					wait("61s")
--				end
--			else
--				if team_dismissied() == 0 or YeChun_down() == 0 then			
					send(attackskills)
--				end
--			end
    	end
		if YeChun_down() == 1 then 
			PCP.Dismissteam()
		else
			if team_dismissied() == 0 or YeChun_down() == 0 then			
				send(attackskills)
			end
		end
		if (image.find_image("PCP/norevok.bmp") == 1 or image.find_image_target("PCP/notarget.bmp") == 0) then
			log("Attacking mob1")
			if image.find_image_target("PCP/notarget.bmp") == 0 then 
				--send("TAB")
				PCP.sendtab()
			else
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
	end
end

function PCP.inside2()
	local targetX = 270--283
    local targetY = -24---30
    local tolerance = 15
--	while image.find_image("PCP/team.bmp") == 1 do 
	while team_dismissied() == 0 and YeChun_down() == 0 do 
		if (spector_fish() == 1 or spector_shark() == 1 or spector_servant() == 1 or YeChun() == 1 or Coral() == 1 ) and (memory.dead() == 0) and (team_dismissied() == 0) and (YeChun_down() == 0)  then 
			log("Inside loop1")
			if YeChun() == 0 and (team_dismissied() == 0) and (YeChun_down() == 0) then
				log("Inside loop1.1")

				if not Boss.isInToleranceArea(targetX, targetY, tolerance) then
        			log("Not in area, navigating to PCP combat area (non-strict)")
					wait("1s")
					right(872, 89)
					wait("1s")
					Boss.gettotargetspot_notstrict(targetX, targetY, tolerance)
					if (team_dismissied() == 0) and (YeChun_down() == 0) then
						PCP.allattack()
					end
					wait(500)
    			else
        			log("Already in combat area, starting combat")
					PCP.allattack()
    			end
			else
				log("Inside loop1.2")
				PCP.allattack()
				if team_dismissied() == 0 and YeChun_down() == 0 and Leader == "YES" then
					PCP.Dismissteam()
				end
			end
		else
			log("Inside loop2")
			if memory.dead() == 1  then 
				log("Inside loop2.1")
				PCP.dead()
				wait("1s")
			else
				if not Boss.isInToleranceArea(targetX, targetY, tolerance) then
        		log("Not in area, navigating to PCP combat area (non-strict)")
				wait("1s")
				right(872, 89)
				wait("1s")
				Boss.gettotargetspot_notstrict(targetX, targetY, tolerance)
				if (team_dismissied() == 0) and (YeChun_down() == 0) then
				PCP.allattack()
				end
				        wait(500)
    			else
        		log("Already in combat area, starting combat")
				if (team_dismissied() == 0) and (YeChun_down() == 0) then
				PCP.allattack()
				end
    			end
			end
		end
	end
end
function PCP.inside3()
    -- Navigate to combat area first
    local targetX = 283
    local targetY = -30
    local tolerance = 50
    
    log("Navigating to PCP combat area")
	right(871, 87)
	wait("1s")
    Boss.gettotargetspot(tonumber(targetX), tonumber(targetY))
    wait(500)
    
    -- Helper function to check if in combat area
    local function inCombatArea()
        local currentX = tonumber(memory.getLocation_cords(0))
        local currentY = tonumber(memory.getLocation_cords(1))
        
        if currentX and currentY then
            local xInRange = math.abs(currentX - targetX) <= tolerance
            local yInRange = math.abs(currentY - targetY) <= tolerance
            return xInRange and yInRange
        end
        return false
    end
    
    -- Helper function to check for valid target
    local function hasValidTarget()
        -- Check if any valid target icon is visible
        if image.find_image_target("PCP/ICON_Coral.bmp") == 1 then
            return true, "Coral"
        elseif image.find_image_target("PCP/ICON_YeChun.bmp") == 1 then
            return true, "YeChun"
        elseif image.find_image_target("PCP/specter_fish.bmp") == 1 then
            return true, "Fish"
        elseif image.find_image_target("PCP/specter_shark.bmp") == 1 then
            return true, "Shark"
        elseif image.find_image_target("PCP/specter_servant.bmp") == 1 then
            return true, "Servant"
        end
        return false, nil
    end
    
    -- Main combat loop
    while image.find_image("PCP/leader.bmp") == 1 or image.find_image("PCP/team.bmp") == 1 do
        -- Check if character died
        if memory.dead() == 1 then
            log("Character died, handling death...")
            PCP.dead()
            -- Return to combat area after revival
            Boss.gettotargetspot(tonumber(targetX), tonumber(targetY))
            wait(4500)
        end
        
        -- Ensure we're in combat area
        if not inCombatArea() then
            log("Not in combat area, relocating...")
            Boss.gettotargetspot(tonumber(targetX), tonumber(targetY))
            wait(500)
        end
        
        -- Handle revival dialog
        if image.find_image("PCP/norevok.bmp") == 1 then
			log("Handle revival dialog")
            wait(300)
            left(515, 468)
            wait(1000)
            right(872, 89)  -- Reset view
            wait(500)
        end
        
        -- Check target status
        local targetHPVisible = Targethpzero()
        local hasTarget, targetType = hasValidTarget()
        
        -- If we have target HP visible but it's not a valid target, TAB
        if targetHPVisible == 1 and not hasTarget then
            log("Wrong target selected, cycling...")
            send("TAB")
            wait(100)
            goto continue
        end
        
        -- If no target or no HP bar, TAB to find target
        if not hasTarget or targetHPVisible == 0 then
            send("TAB")
            wait(100)
            goto continue
        end
        
        -- Valid target found, check type and act accordingly
        if targetType == "YeChun" then
            -- Boss handling
            if targetHPVisible == 1 then
                -- Boss is dead (HP bar showing = 1 means defeated)
                log("YeChun defeated!")
                if Leader == "YES" then
                    log("Leader dismissing team...")
                    PCP.Dismissteam()
                end
                log("Waiting 60 seconds before leaving...")
                wait(60000)  -- 60 seconds
                return  -- Exit function
            else
                -- Boss is alive, attack
                log("Attacking YeChun...")
                send(attackskills)
                wait(100)
            end
        elseif targetType == "Coral" or targetType == "Fish" or targetType == "Shark" or targetType == "Servant" then
            -- Mob/Coral handling
            if targetHPVisible == 0 then
                -- Target is alive and selected, attack
                log("Attacking " .. targetType)
                send(attackskills)
                wait(100)
            else
                -- Target may be dead or invalid, cycle
                send("TAB")
                wait(100)
            end
        end
        
        -- Fairy mode healing (if enabled)
        if Fairy ~= "NO" then
            if memory.CharHPpercent() < 35 then
                log("HP low, healing...")
                send("F1")
                wait(100)
                while memory.CharHPpercent() < 95 do
                    send(healskill)
                    wait(100)
                end
                send("TAB")  -- Retarget after healing
                wait(100)
            end
        end
        
        ::continue::
        wait(50)  -- Small delay to prevent excessive CPU usage
    end
    
    log("Exited combat loop - team disbanded or left area")
end
function PCP.inside1()
	if Leader == "NO" then
		if Fairy == "NO" then
        	while image.find_image("PCP/leader.bmp") == 1 do
        		-- SSC.attack(attackskills)
				if image.find_image_target("PCP/TargetHP.bmp") == 1 and image.find_image_target("PCP/ICON_YeChun.bmp") == 1 then 
				if Leader == "YES" then
   					PCP.Dismissteam()
					wait("60s")
				else
					wait("60s")
				end
			else 
				PCP.allattack()
			end
        	end
    	else
        	while image.find_image("PCP/leader.bmp") == 1 do
				--PCP.unmount()
				--PCP.healall(healskill)
        	end
    	end
	else
		while (image.find_image_target("PCP/TargetHP.bmp") == 1 or image.find_image_target("PCP/TargetHP.bmp") == 0) and ( image.find_image("PCP/leader.bmp") == 1) do 
			if image.find_image_target("PCP/TargetHP.bmp") == 1 and image.find_image_target("PCP/ICON_YeChun.bmp") == 1 then 
				if Leader == "YES" then
   					PCP.Dismissteam()
					wait("60s")
				else
					wait("60s")
				end
			else 
				PCP.allattack()
			end
		end
	end
	--After Killing mobs

end

function PCP.start()
	epoch1 = os.time()
	log("Started PCP time :",PCP.convert_epoch_to_normal())
	bot.verifypet()
	--bot.Invisiblemode2()
	wait("1s")
    send(Petfood)
    wait("1s")
 	PCP.Waitteam()
end
function PCP.startext()	
	PCP.inside2()
	if memory.getLocation() == "Shark Sea" then 
		epoch2 = os.time()
		PCP.inside()
		epoch3 = os.time()
		log("Ended Cave Time :", PCP.convert_epoch_to_normal() )
		log(PCP.convertSecondsToTime(PCP.calculate_time_difference(epoch2, epoch3))) 
		wait(300)
	end
	epoch4 = os.time()
	log("Ended PCP Time :", PCP.convert_epoch_to_normal() )
	log(PCP.convertSecondsToTime(PCP.calculate_time_difference(epoch1, epoch4))) 
	wait(300)
end

return PCP