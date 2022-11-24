class ntech_gui_large
{
	move=false;
	movingEnable = false; //not moving
	moving = 1; // who the hell knows what this does????????
	onLoad = ""; //code to run when it loads
	onUnload = ""; //code to run when its closed

	class ntech_gui_large_frame: RscFrame
	{
		idc = 4051;
		x = 0 * GUI_GRID_W + GUI_GRID_X;
		y = 0 * GUI_GRID_H + GUI_GRID_Y;
		w = 40 * GUI_GRID_W;
		h = 25 * GUI_GRID_H;
	};
	class ntech_gui_large_background: IGUIBack
	{
		idc = 4052;
		x = 0 * GUI_GRID_W + GUI_GRID_X;
		y = 0 * GUI_GRID_H + GUI_GRID_Y;
		w = 40 * GUI_GRID_W;
		h = 25 * GUI_GRID_H;
	};
	class ntech_gui_large_header: RscStructuredText
	{
		idc = 4053;
		text = header;
		x = 0 * GUI_GRID_W + GUI_GRID_X;
		y = 0 * GUI_GRID_H + GUI_GRID_Y;
		w = 38 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
	};
	class ntech_gui_large_close: RscButton
	{
		idc = 4054;
		text = "[X]"; //--- ToDo: Localize;
		onButtonClick = "closeDialog 0";
		x = 38 * GUI_GRID_W + GUI_GRID_X;
		y = 0 * GUI_GRID_H + GUI_GRID_Y;
		w = 2 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
	};
	// Default menu for large window
	class ntech_gui_large_menu_default_ok: RscButton
	{
		idc = 4055;
		text = "Ok"; //--- ToDo: Localize;
		x = 32 * GUI_GRID_W + GUI_GRID_X;
		y = 22 * GUI_GRID_H + GUI_GRID_Y;
		w = 7 * GUI_GRID_W;
		h = 2 * GUI_GRID_H;
	};
	class ntech_gui_large_menu_default_cancel: RscButton
	{
		idc = 4056;
		text = "Cancel"; //--- ToDo: Localize;
		x = 23 * GUI_GRID_W + GUI_GRID_X;
		y = 22 * GUI_GRID_H + GUI_GRID_Y;
		w = 7 * GUI_GRID_W;
		h = 2 * GUI_GRID_H;
	};
	// trade menu
	class ntech_gui_large_menu_trade_pricetxt: RscStructuredText
	{
		idc = 4057;
		text = "Price:"; //--- ToDo: Localize;
		x = 23 * GUI_GRID_W + GUI_GRID_X;
		y = 20 * GUI_GRID_H + GUI_GRID_Y;
		w = 5 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
	};
	class ntech_gui_large_menu_trade_pricetype: RscStructuredText
	{
		idc = 4058;
		text = "Credits"; //--- ToDo: Localize;
		x = 34 * GUI_GRID_W + GUI_GRID_X;
		y = 20 * GUI_GRID_H + GUI_GRID_Y;
		w = 5 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
	};
	class ntech_gui_large_menu_trade_pricevalue: RscText
	{
		idc = 4059;
		text = "000.000.000"; //--- ToDo: Localize;
		x = 28 * GUI_GRID_W + GUI_GRID_X;
		y = 20 * GUI_GRID_H + GUI_GRID_Y;
		w = 6 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
	};
};
