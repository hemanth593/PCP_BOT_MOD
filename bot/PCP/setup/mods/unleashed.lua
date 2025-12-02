-- TALISMAN UNLEASHED v0.02
-- MADE BY HEMANTH Credit goes to Danski
local mod = {}

-- Teleport destinations
local TeleportDestinations = {
    {name = "BC", id = 8},--8
    {name = "SSC", id = 15},--15
    {name = "PCP", id = 45},--45
    {name = "PRS", id = 34},--45  
    {name = "HH", id = 3},
    {name = "FP", id = 4},
    {name = "LC", id = 6},    
    {name = "BC:L", id = 500},--8
    {name = "SSC:L", id = 501},--15
    {name = "PCP:L", id = 502},--45    
    {name = "PRS:L", id = 503},--45 
    {name = "HH:L", id = 504},
    {name = "FP:L", id = 505},
    {name = "LC:L", id = 506},       
	{name = "GUILD", id = 507},
    {name = "MAIL", id = 508},
    {name = "G-Cont", id = 509}, --doesnt work
	{name = "BC-1", id = 510},
    {name = "sell", id = 511},

    --doesnt work
    -- Add more destinations as needed
}

mod.onLoad = function()
	print("TO MOD")
	
	uiGetglobal("layWorld.frmMiniMapEx.btCalendar"):SetNormalImage(SAPI.GetImage('ic_gemstone3'))
	
	_G.uiNpcDialogCheckDistance = function() --override distance checks
		return true;
	end 
end

mod.onTick = function() --runs on every ui frame
	_G.uiNpcDialogCheckDistance = function() --override distance checks
		return true;
	end 
end

-- override calendar
function layWorld_frmCalendar_OnShow(self)
    uiClientMsg("UNLEASHED Teleport Menu", true)
    
    local BUTTON_WIDTH = 55
    local BUTTON_HEIGHT = 50
    local BUTTON_SPACING_X = 1
    local BUTTON_SPACING_Y = 5
    local START_X = 5
    local START_Y = 5
    
    local lbCalendarMonth = SAPI.GetChild(self, "lbCalendarMonth")
    if lbCalendarMonth then
        local destIndex = 1
        
        for weekId = 1, 6 do
            local lbCalendarWeek = SAPI.GetChild(lbCalendarMonth, "lbCalendarWeek" .. weekId)
            if lbCalendarWeek then
                for dayId = 1, 7 do
                    local cbCalendarDay = SAPI.GetChild(lbCalendarWeek, "cbCalendarDay" .. dayId)
                    if cbCalendarDay then
                        if TeleportDestinations[destIndex] then
                            local dest = TeleportDestinations[destIndex]
                            
                            local col = (dayId - 1)
							local posX = START_X + col * (BUTTON_WIDTH + BUTTON_SPACING_X)
							local posY = START_Y
                            
                            cbCalendarDay:MoveTo(posX, posY)
                            cbCalendarDay:SetSize(BUTTON_WIDTH, BUTTON_HEIGHT)
                            
                            cbCalendarDay:SetChecked(false)
                            
                            local lbDayInMonth = SAPI.GetChild(cbCalendarDay, "lbDayInMonth")
                            if lbDayInMonth then
								lbDayInMonth:SetText(dest.name)
								lbDayInMonth:MoveTo(-20, 15)
								lbDayInMonth:SetSize(BUTTON_WIDTH + 20, 20)
							end
                            
                            for i = 1, 3 do
                                local lbShortcut = SAPI.GetChild(cbCalendarDay, "lbShortcut" .. i)
                                if lbShortcut then
                                    lbShortcut:Hide()
                                end
                            end
                            
                            local btUserEvent = SAPI.GetChild(cbCalendarDay, "btUserEvent")
                            if btUserEvent then
                                btUserEvent:Hide()
                            end
                            
                            -- Store destination data
                            cbCalendarDay.TeleportId = dest.id
                            cbCalendarDay.TeleportName = dest.name
                            
                            cbCalendarDay:Show()
                            destIndex = destIndex + 1
                        else
                            cbCalendarDay:Hide()
                        end
                    end
                end
            end
        end
    end
    
    local btNextMonth = SAPI.GetChild(self, "btNextMonth")
    if btNextMonth then btNextMonth:Hide() end
    
    local btPreMonth = SAPI.GetChild(self, "btPreMonth")
    if btPreMonth then btPreMonth:Hide() end
   
    
    local btMonthText = SAPI.GetChild(self, "btMonthText")
    if btMonthText then 
        btMonthText:SetText("UNLEASHED v0.2")
		btMonthText:SetSize(200, 20);
    end
    
    local btCreateUserEvent = SAPI.GetChild(self, "btCreateUserEvent")
    if btCreateUserEvent then
        btCreateUserEvent:Hide()
    end
    
    self:Show()
end

function layWorld_wtCalendarManager_OnUpdate(self)
  local btMonthText = SAPI.GetChild(self, "btMonthText")
    if btMonthText then 
        btMonthText:SetText("UNLEASHED v0.2")
		btMonthText:SetSize(200, 20);
    end
end

--click handlers
function frmCalendar_TemplateCalendarDay_OnLClick(self)
    if self.TeleportId then
        self:SetChecked(false)
		if self.TeleportId >= 500 then
            if self.TeleportId == 500 then
				uiPost("RequestLeaveEctype:NA?id=8")
			end
            if self.TeleportId == 501 then
				uiPost("RequestLeaveEctype:NA?id=15")
			end
            if self.TeleportId == 502 then
				uiPost("RequestLeaveEctype:NA?id=45")
			end
            if self.TeleportId == 503 then
				uiPost("RequestLeaveEctype:NA?id=34")
			end
            if self.TeleportId == 504 then
				uiPost("RequestLeaveEctype:NA?id=3")
			end
            if self.TeleportId == 505 then
				uiPost("RequestLeaveEctype:NA?id=4")
			end
            if self.TeleportId == 506 then
				uiPost("RequestLeaveEctype:NA?id=6")
			end
            if self.TeleportId == 507 then
				uiPost("guildterrenter:NA?NA=0")
			end
            if self.TeleportId == 508 then
				uiPost("mail:NA?NA=0") 
			end
            if self.TeleportId == 509 then
				uiPost("guildterrcontribute:NA?NA=0") 
			end
            if self.TeleportId == 510 then
				uiPost("traffic:Station?from=27&to=28")
			end
            if self.TeleportId == 511 then
				--uiPost("npc_shop:sale?owner_table_id=3102&owner_object_id=1051826")
                uiPost("npc_shop:sale?owner_table_id=7318&owner_object_id=7425131")
			end
			return nil
		end
        
        uiClientMsg("Teleporting to " .. self.TeleportName .. "...", false)
        --uiPost("RequestIntoEctype:UNLEASHED?id=" .. self.TeleportId)
        uiPost("RequestIntoEctype:NA?id=" .. self.TeleportId)
    end
end

return mod