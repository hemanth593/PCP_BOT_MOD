layWorld_frmBlendEx_OnLoad = function(self)
	-- reveal AH sellers
	uiGetglobal("layWorld.frBuyAll.frBuyBrowes.lbBuyItem1.lbBuyPlayer1"):Show();
	uiGetglobal("layWorld.frBuyAll.frBuyBrowes.lbBuyItem2.lbBuyPlayer2"):Show();
	uiGetglobal("layWorld.frBuyAll.frBuyBrowes.lbBuyItem3.lbBuyPlayer3"):Show();
	uiGetglobal("layWorld.frBuyAll.frBuyBrowes.lbBuyItem4.lbBuyPlayer4"):Show();
	uiGetglobal("layWorld.frBuyAll.frBuyBrowes.lbBuyItem5.lbBuyPlayer5"):Show();
	uiGetglobal("layWorld.frBuyAll.frBuyBrowes.lbBuyItem6.lbBuyPlayer6"):Show();
	uiGetglobal("layWorld.frBuyAll.frBuyBrowes.lbBuyItem7.lbBuyPlayer7"):Show();
	uiGetglobal("layWorld.frBuyAll.frBuyBrowes.lbBuyItem8.lbBuyPlayer8"):Show();
end

-- on queue close button click
__laySelectChar_frmGameWatting_btWattingClose_OnLClick = function(self)
	--close queue window
	uiGetglobal("laySelectChar.frmGameWatting"):Hide();
	
	--show char selection ui
	uiGetglobal("laySelectChar.lbLayerSelectChar2"):Show();
	
	--show and enable enter game btn
	local btEnterGame = uiGetglobal("laySelectChar.lbLayerSelectChar2.lbContainer.btEnterGame");
	btEnterGame:Show();
	btEnterGame:Enable();
	
	UpdateRoleList() --populate chars
	uiCharSelectCharacter(0) --select first char
	uiCharEnterGame() --enter game
end

-- internet ping credits hint
layWorld_frmSystemButtonEx_lbNetStatus_OnHint = function(self)
   local ping = uiNetGetData()
   local hint_text = string.format(LAN("net_status_hint1"), ping)
   hint_text = hint_text .. '\nMade by Hemanth :)'
   self:SetHintText(hint_text)
end