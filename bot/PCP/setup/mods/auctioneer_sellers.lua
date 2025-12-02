-- AUCTIONEER REVEAL SELLERS MOD
-- MADE BY DANSKI

local mod = {}

mod.onLoad = function()
	print('Revealing AH sellers.')
	uiGetglobal("layWorld.frBuyAll.frBuyBrowes.lbBuyItem1.lbBuyPlayer1"):Show();
	uiGetglobal("layWorld.frBuyAll.frBuyBrowes.lbBuyItem2.lbBuyPlayer2"):Show();
	uiGetglobal("layWorld.frBuyAll.frBuyBrowes.lbBuyItem3.lbBuyPlayer3"):Show();
	uiGetglobal("layWorld.frBuyAll.frBuyBrowes.lbBuyItem4.lbBuyPlayer4"):Show();
	uiGetglobal("layWorld.frBuyAll.frBuyBrowes.lbBuyItem5.lbBuyPlayer5"):Show();
	uiGetglobal("layWorld.frBuyAll.frBuyBrowes.lbBuyItem6.lbBuyPlayer6"):Show();
	uiGetglobal("layWorld.frBuyAll.frBuyBrowes.lbBuyItem7.lbBuyPlayer7"):Show();
	uiGetglobal("layWorld.frBuyAll.frBuyBrowes.lbBuyItem8.lbBuyPlayer8"):Show();
end


return mod