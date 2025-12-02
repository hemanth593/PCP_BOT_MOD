--[[ Traveling around the map --]]

local travel = {}

local memory = require("Bot/memory")
local cords = require("Bot/cords")
local getX = memory.getX
local getY = memory.getY

-- Travels to a specific coordinate via mini-map
function travel.miniMap(xY)    

    while getX() ~= xY[1] or getY() ~= xY[2]
    do  
        local x = getX() local y = getY()
        local via = {cords.move.stop[1], cords.move.stop[2]}
        local repos = {x - xY[1], y - xY[2]}

        -- Check the need of repositioning
        if repos[1] ~= 0 or repos[2] ~= 0 then
            -- X axis
            if repos[1] ~= 0 then via[1] = via[1] - repos[1] end
            -- Y axis
            if repos[2] ~= 0 then via[2] = via[2] + repos[2]end
            -- Travel
            right(via[1], via[2]) wait(100) 

            -- While char is moving wait
            while true do
                wait(100)
                if getX() == x and getY() == y then break end
                x = getX() y = getY()
            end
        end
    end
    
    -- Reset cursor
    left(cords.mouseReset[1], cords.mouseReset[2]) wait(MS)
end

return travel

