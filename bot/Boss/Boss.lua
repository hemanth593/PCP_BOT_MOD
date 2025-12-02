--[[ Reading game memory --]]



local Boss = {}
--local bot = require("Bot/bot")
local cred = require("Bot/cred")
local memory = require("Bot/memory")
local image = require("Bot/image")
local cords = require("Bot/cords")
local bot = require("Bot/bot")
local travel = require("Bot/travel")



local getX = memory.getX
local getY = memory.getY
--local cave = require("BC/InsideBC")

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

function Boss.gettotargetspot(x,y)
	log("relocating")
	local gettotarget = {
        {xY = {x,y}, via = {920, 135}},
	}
	Boss.travelPath(gettotarget)
end

local north = {
    {xY = {304, -452}, via = {941, 95}},
    {xY = {317, -476}, via = {940, 154 }},
    {xY = {290, -480}, via = {875, 122 }}
}

function Boss.DRspot()
	log("relocating")
	Boss.travelPath(north)
end

 local DR2= {
    {xY = {1096, 1710}, via = {922, 142 }},
    {xY = {1086,1701}, via = {903, 130 }},
    {xY = {1075,1703}, via = {901, 111 }},
    {xY = {1058,1701}, via = {892, 118 }},
    {xY = {1048,1705}, via = {902, 109 }},
    {xY = {1041,1723}, via = {907, 85 }},
    {xY = {1048,1736}, via = {930, 94 }},
    {xY = {1064,1736}, via = {945, 115 }},
    {xY = {1082,1728}, via = {948, 128 }},
    {xY = {1087,1734}, via = {927, 105 }},
    {xY = {1095,1724}, via = {932, 131 }}
}

function Boss.DR2spot()
	log("relocating")
	Boss.travelPath(DR2)
end


  local DR4= {
    {xY = {631,2396}, via = {891, 102  }},
    {xY = {636,2411}, via = {927, 90 }},
    {xY = {657,2411}, via = {953, 115 }},
    {xY = {665,2400}, via = {932, 133 }},
    {xY = {656,2387}, via = {904, 136 }},
    {xY = {648, 2388}, via = {905, 114}}
}


function Boss.DR4spot()
	log("relocating")
	Boss.travelPath(DR4)
end


  local DR5= {
    {xY = {631,2396}, via = {891, 102  }},
    {xY = {636,2411}, via = {927, 90 }},
    {xY = {657,2411}, via = {953, 115 }},
    {xY = {665,2400}, via = {932, 133 }},
    {xY = {656,2387}, via = {904, 136 }},
    {xY = {648, 2388}, via = {905, 114}}
}


function Boss.DR5spot()
	log("relocating")
	Boss.travelPath(DR5)
end







function Boss.travelPath(path)
    for i, step in ipairs(path) do
        local xY = step.xY
        local via = step.via

        local travelX = memory.getX()
        local travelY = memory.getY()

        if travelX ~= xY[1] or travelY ~= xY[2] then
            local attempt = 1
            local maxAttempts = 10
            local stepSize = 1
            local direction = 1 
            
            while attempt <= maxAttempts do
                local adjustedVia = {via[1] + (direction * stepSize), via[2]}
                travel.miniMap(xY, adjustedVia)
                if memory.getX() == xY[1] and memory.getY() == xY[2] then
                    break 
                else
                    direction = -direction
                    attempt = attempt + 1
                end
            end
            local newTravelX = memory.getX()
            local newTravelY = memory.getY()
        else
	    log("Out1")
            travel.miniMap(xY)
        end
    end
    log("Out")
end


function Boss.dead()
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
		Boss.start()
	end
end





function Boss.verifyBoss()
	if image.find_image("boss.bmp") == 1 then 
		return 1
	else
		log("Courage Badges not exceeded in inventory")
		return 0
	end
end


function Boss.attack(attackskills)
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

function Boss.attackBlazeSkullMarshal()
    log("Inside the loop attackBlazeSkullMarshal")
    if Fairy == "NO" then 
        bot.unmount()
        clock1= os.time()
        while memory.Battle_Status() == 1 do
            --log("Inside the loop attackBlazeSkullMarshal : while ")
            while not (bot.calculate_time_difference(clock1, os.time()) >= 20) do
                    --log(Boss.calculate_time_difference(clock1, os.time()))
                        wait(100)
                        send(aoe)
                        wait(100)
                    send("Tab")
                    wait(100)
                end
                if memory.targetHPpercent() > 0 then
                --log("Inside the loop attackBlazeSkullMarshal : if ")
                clock10= os.time()
                while memory.targetHPpercent() > 0 and bot.calculate_time_difference(clock10, os.time()) <= 20 do
                    --log("Inside the loop attackBlazeSkullMarshal : if/while ")
                        wait(30)
                            send(attackskills)
                            wait(30)
                end
                        wait(30)
                    send("Tab")
                        wait(30)
                else
                --log("Inside the loop attackBlazeSkullMarshal : if/else")
                        wait(30)
                    send("Tab")
                        wait(30)
                end
            end
    else
        bot.unmount()
        clock1= os.time()
        while memory.Battle_Status() == 1 do
            while not (bot.calculate_time_difference(clock1, os.time()) >= 20) do
                    --log(Boss.calculate_time_difference(clock1, os.time()))
                        wait(100)
                        send(aoe)
                        wait(100)
                    send("Tab")
                    wait(100)
                end
            if memory.CharHPpercent() > 35 then
                    if memory.targetHPpercent() > 0 then
                        wait(100)
                            send(attackskills)
                            wait(100)
                    else
                            wait(100)
                        send("Tab")
                            wait(100)
                    end
            else
                wait(100)
                send("F1")
                wait(100)
                while memory.CharHPpercent() < 95 do 
                    wait(100)
                    send(healskill)
                    wait(100)
                end
                        wait(100)
                    send("Tab")
                        wait(100)
            end
            end
    end
    
end







function Boss.attackBlazeSkullMarshal()
	log("Inside the loop attackBlazeSkullMarshal")
	if Fairy == "NO" then 
		bot.unmount()
		clock1= os.time()
		while memory.Battle_Status() == 1 do
			--log("Inside the loop attackBlazeSkullMarshal : while ")
			while not (bot.calculate_time_difference(clock1, os.time()) >= 20) do
	    			--log(bot.calculate_time_difference(clock1, os.time()))
            			wait(100)
            			send(aoe)
            			wait(100)
	    			send("Tab")
	    			wait(100)
        		end
        		if memory.targetHPpercent() > 0 then
				--log("Inside the loop attackBlazeSkullMarshal : if ")
				clock10= os.time()
				while memory.targetHPpercent() > 0 and bot.calculate_time_difference(clock10, os.time()) <= 20 do
					--log("Inside the loop attackBlazeSkullMarshal : if/while ")
           		 		wait(30)
            				send(attackskills)
            				wait(30)
				end
            			wait(30)
        			send("Tab")
            			wait(30)
        		else
				--log("Inside the loop attackBlazeSkullMarshal : if/else")
            			wait(30)
        			send("Tab")
            			wait(30)
        		end
    		end
	else
		bot.unmount()
		clock1= os.time()
		while memory.Battle_Status() == 1 do
			while not (bot.calculate_time_difference(clock1, os.time()) >= 20) do
	    			--log(bot.calculate_time_difference(clock1, os.time()))
            			wait(100)
            			send(aoe)
            			wait(100)
	    			send("Tab")
	    			wait(100)
        		end
			if memory.CharHPpercent() > 35 then
        			if memory.targetHPpercent() > 0 then
           				wait(100)
            				send(attackskills)
            				wait(100)
        			else
            				wait(100)
        				send("Tab")
            				wait(100)
        			end
			else
				wait(100)
				send("F1")
				wait(100)
				while memory.CharHPpercent() < 95 do 
					wait(100)
					send(healskill)
					wait(100)
				end
            			wait(100)
        			send("Tab")
            			wait(100)
			end
    		end
	end
	
end

function Boss.auto_attack_on_rev1()
    if image.find_image("ok.bmp") == 1 then
        wait(300)
        left(429, 338)
        wait(300)
    else
                wait(100)
                send (attackskills)
    end
end

function Boss.pcp_suwan1()
    if image.find_image("norevok.bmp") == 1 then
        wait(300)
        left(515, 468)
        wait(500)
    else
         if image.find_image("suwan.bmp") == 1 or image.find_image("sanyu.bmp") == 1 or image.find_image("lusalon.bmp") == 1 or image.find_image("Lauhuan.bmp") == 1 then

                wait(100)
                send (attackskills)
        else
                send("TAB")
                wait(100)
        end

    end
end

function Boss.isInToleranceArea(targetX, targetY, tolerance)
    tolerance = tolerance or 10
    
    local currentX = memory.getX()
    local currentY = memory.getY()
    
    local xInRange = math.abs(currentX - targetX) <= tolerance
    local yInRange = math.abs(currentY - targetY) <= tolerance
    
    if xInRange and yInRange then
       -- log("Already in tolerance area: Current(" .. currentX .. ", " .. currentY .. ") Target(" .. targetX .. ", " .. targetY .. ")")
        return true
    else
      --  log("Outside tolerance area: Current(" .. currentX .. ", " .. currentY .. ") Target(" .. targetX .. ", " .. targetY .. ")")
        return false
    end
end

-- Simplified gettotargetspot_notstrict (removes duplicate check)
function Boss.gettotargetspot_notstrict(x, y, tolerance)
    tolerance = tolerance or 10
  --  log("relocating (non-strict, tolerance: " .. tolerance .. ")")
    
    local gettotarget = {
        {xY = {x, y}, via = {920, 135}},
    }
    Boss.travelPath_notstrict(gettotarget, tolerance)
end

function Boss.travelPath_notstrict(path, tolerance)
    tolerance = tolerance or 10
    
    for i, step in ipairs(path) do
        local xY = step.xY
        local via = step.via
        local travelX = memory.getX()
        local travelY = memory.getY()
        
        local xInRange = math.abs(travelX - xY[1]) <= tolerance
        local yInRange = math.abs(travelY - xY[2]) <= tolerance
        
        if not (xInRange and yInRange) then
            local attempt = 1
            local maxAttempts = 10
            local stepSize = 1
            local direction = 1
            
            while attempt <= maxAttempts and memory.dead() == 0 do
                local adjustedVia = {via[1] + (direction * stepSize), via[2]}
                travel.miniMap(xY, adjustedVia)
                
                local newX = memory.getX()
                local newY = memory.getY()
                
                if math.abs(newX - xY[1]) <= tolerance and math.abs(newY - xY[2]) <= tolerance then
                   -- log("Reached area: (" .. newX .. ", " .. newY .. ")")
                    break
                else
                    direction = -direction
                    attempt = attempt + 1
                end
            end
        else
       --     log("In range: (" .. travelX .. ", " .. travelY .. ")")
        end
    end
  --  log("Travel complete")
end
return Boss
