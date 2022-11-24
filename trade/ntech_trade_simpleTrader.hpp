class ntech_trade_simpleTrader: ntech_gui_large 
{

	idd = 4300; //no need for the whole dialog to be referenced at any time.
	movingEnable = false; //not moving
	moving = 1; // who the hell knows what this does????????
	onLoad = ""; //code to run when it loads
	onUnload = ""; //code to run when its closed
	controls[] = {
		ntech_gui_large_close,
		ntech_gui_large_menu_default_ok,
		ntech_gui_large_menu_default_cancel,
		ntech_gui_large_menu_trade_pricetxt,
		ntech_gui_large_menu_trade_pricetype,
		ntech_gui_large_menu_trade_pricevalue,
		ntech_trade_picture,
		ntech_trade_description,
		ntech_trade_itemlist
	}; //anything that doesn't fit into the category below
	controlsBackground[] = {
		ntech_gui_large_frame,
		ntech_gui_large_background,
		ntech_gui_large_header 
	}; //background things that can’t be interacted with


	class ntech_trade_picture: RscPicture
	{
		idc = 4301;
		text = "#(argb,8,8,3)color(1,1,1,1)";
		x = 21 * GUI_GRID_W + GUI_GRID_X;
		y = 2 * GUI_GRID_H + GUI_GRID_Y;
		w = 18 * GUI_GRID_W;
		h = 8 * GUI_GRID_H;
	};
	class ntech_trade_description: RscStructuredText
	{
		idc = 4302;
		x = 21 * GUI_GRID_W + GUI_GRID_X;
		y = 10 * GUI_GRID_H + GUI_GRID_Y;
		w = 18 * GUI_GRID_W;
		h = 10 * GUI_GRID_H;
	};
	class ntech_trade_itemlist: RscListbox
	{
		idc = 4303;
		x = 1 * GUI_GRID_W + GUI_GRID_X;
		y = 2 * GUI_GRID_H + GUI_GRID_Y;
		w = 16 * GUI_GRID_W;
		h = 22.5 * GUI_GRID_H;
	};
};