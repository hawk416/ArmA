class ntech_revive_unitswitch
{
	idd = 4390; //no need for the whole dialog to be referenced at any time.
	move=true;
	movingEnable = true; //not moving
	moving = 1; // who the hell knows what this does????????
	onLoad = ""; //code to run when it loads
	onUnload = ""; //code to run when its closed
	controls[] = {
		ntech_revive_unitswitch_list,
		ntech_revive_unitswitch_button
	}; //anything that doesn't fit into the category below
	controlsBackground[] = {
	}; //background things that can’t be interacted with



	class ntech_revive_unitswitch_list: RscCombo
	{
		idc = 4391;
		x = 5 * GUI_GRID_W + GUI_GRID_X;
		y = -9.5 * GUI_GRID_H + GUI_GRID_Y;
		w = 25 * GUI_GRID_W;
		h = 2 * GUI_GRID_H;
		type=CT_COMBO;
		// style=ST_SINGLE;
		onLBSelChanged="localNamespace setVariable ['ntech_revive_goat', _this select 1]";
		// onLBSelChanged="systemchat format['%1 : %2', time, _this]";
		// colorSelection[] = {0,0,0,1};
		// colorText[] = {1,1,1,1};
		colorPicture[] = {1,1,1,1};
		colorPictureSelected[] = {1,1,1,1};
		colorPictureDisabled[] = {1,1,1,0.25};
		colorPictureRight[] = {1,1,1,1};
		colorPictureRightSelected[] = {1,1,1,1};
		colorPictureRightDisabled[] = {1,1,1,0.25};
		class ComboScrollBar
		{
			color[] = {1,1,1,1};
			colorActive[] = {1,1,1,1};
			colorDisabled[] = {1,1,1,0.3};
			thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
			arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
			arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
			border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
			shadow = 0;
			scrollSpeed = 0.06;
			width = 0;
			height = 0;
			autoScrollEnabled = 0;
			autoScrollSpeed = -1;
			autoScrollDelay = 5;
			autoScrollRewind = 0;
		};
	};
	class ntech_revive_unitswitch_button: RscButton
	{
		idc=4392;
		text = "Switch"; //--- ToDo: Localize;
		x = 30.5 * GUI_GRID_W + GUI_GRID_X;
		y = -9.5 * GUI_GRID_H + GUI_GRID_Y;
		w = 4 * GUI_GRID_W;
		h = 2 * GUI_GRID_H;
		onButtonClick="closeDialog 1"; // Close dialog with OK (1)
	};
};




	// class ntech_revive_unitswitch_list // Xbox combo box, cannot be controlled with mouse
	// {
	// 	access = 0; // Control access (0 - ReadAndWrite, 1 - ReadAndCreate, 2 - ReadOnly, 3 - ReadOnlyVerified)
	// 	idc = 4391 //CT_XCOMBO; // Control identification (without it, the control won't be displayed)
	// 	type = CT_XCOMBO; // Type is 44
	// 	style = ST_LEFT + LB_TEXTURES; // Style
	// 	default = 0; // Control selected by default (only one within a display can be used)
	// 	blinkingPeriod = 0; // Time in which control will fade out and back in. Use 0 to disable the effect.

	// 	x = 0 * GUI_GRID_W + GUI_GRID_X;
	// 	y = -9.5 * GUI_GRID_H + GUI_GRID_Y;
	// 	w = 40.5 * GUI_GRID_W;
	// 	h = 2 * GUI_GRID_H;
	// 	// x = 12 * GUI_GRID_CENTER_W + GUI_GRID_CENTER_X; // Horizontal coordinates
	// 	// y = 22 * GUI_GRID_CENTER_H + GUI_GRID_CENTER_Y; // Vertical coordinates
	// 	// w = 10 * GUI_GRID_CENTER_W; // Width
	// 	// h = 1 * GUI_GRID_CENTER_H; // Height

	// 	colorSelectBackground2[] = {0,0,0,1}; // Selected fill color (oscillates between this and List >> colorSelectBackground)

	// 	colorBorder[] = {1,0,1,1}; // arrow color
	// 	colorSelectBorder[] = {1,1,1,1}; // Selected arrow color
	// 	colorDisabledBorder[] = {0,1,1,1}; // arrow color when disabled

	// 	sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1.5)"; // text size
	// 	// sizeEx = GUI_GRID_CENTER_H; // Text size
	// 	// font = GUI_FONT_NORMAL; // Font from CfgFontFamilies
	// 	font = "PuristaMedium";
	// 	shadow = 0; // Shadow (0 - none, 1 - N/A, 2 - black outline)
	// 	colorText[] = {1,1,1,1}; // Text color
	// 	colorSelect[] = {1,1,1,1}; // Selected text color
	// 	colorSelect2[] = {1,1,1,1}; // Selected text color (oscillates between this and colorSelect)
	// 	colorDisabled[] = {1,1,1,0.5}; // Disabled text color

	// 	tooltip = "CT_XCOMBO"; // Tooltip text
	// 	tooltipColorShade[] = {0,0,0,1}; // Tooltip background color
	// 	tooltipColorText[] = {1,1,1,1}; // Tooltip text color
	// 	tooltipColorBox[] = {1,1,1,1}; // Tooltip frame color

	// 	soundExpand[] = {"\A3\ui_f\data\sound\RscCombo\soundExpand",0.1,1}; // Sound played when the list is expanded
	// 	soundCollapse[] = {"\A3\ui_f\data\sound\RscCombo\soundCollapse",0.1,1}; // Sound played when the list is collapsed
	// 	soundSelect[] = {"\A3\ui_f\data\sound\RscCombo\soundSelect",0.1,1}; // Sound played when an item is selected

	// 	// List title (not moved when display is dragged)
	// 	class Title
	// 	{
	// 		text = "CT_XCOMBO";
	// 		x = 12 * GUI_GRID_CENTER_W + GUI_GRID_CENTER_X; // Horizontal coordinates
	// 		y = 21 * GUI_GRID_CENTER_H + GUI_GRID_CENTER_Y; // Vertical coordinates
	// 		w = 10 * GUI_GRID_CENTER_W; // Width
	// 		h = 1 * GUI_GRID_CENTER_H; // Height

	// 		colorBackground[] = {0.2,0.2,0.2,1}; // Fill color
	// 		colorSelectBackground[] = {1,0.5,0,1}; // Selected item fill color

	// 		colorBorder[] = {0,0,0,1}; // Border color
	// 		colorSelectBorder[] = {0,0,0,1}; // Selected border color
	// 		colorDisabledBorder[] = {1,1,1,1}; // Disabled border color

	// 		font = GUI_FONT_NORMAL; // Font from CfgFontFamilies
	// 		size = GUI_GRID_CENTER_H; // Text size
	// 		colorText[] = {1,1,1,1}; // Text color
	// 		colorSelect[] = {1,1,1,1}; // Selected text color
	// 		colorDisabled[] = {1,1,1,0.5}; // Disabled text color
	// 	};
	// 	// Item list displayed when arrow right is pressed while the control is in focus (not moved when display is dragged)
	// 	class List
	// 	{
	// 		idc=4392
	// 		x = 22 * GUI_GRID_CENTER_W + GUI_GRID_CENTER_X; // Horizontal coordinates
	// 		y = 22 * GUI_GRID_CENTER_H + GUI_GRID_CENTER_Y; // Vertical coordinates
	// 		w = 10 * GUI_GRID_CENTER_W; // Width
	// 		h = 5 * GUI_GRID_CENTER_H; // Height

	// 		colorBackground[] = {0.2,0.2,0.2,1}; // List fill color
	// 		colorSelectBackground[] = {1,0.5,0,1}; // Selected item fill color (oscillates between this and colorSelectBackground2 in control root)

	// 		colorBorder[] = {1,1,1,1}; // List scrollbar color (combined with Scrollbar >> color)

	// 		rowHeight = 1 * GUI_GRID_CENTER_H; // Row height
	// 		sizeEx = GUI_GRID_CENTER_H; // Text size
	// 		colorText[] = {1,1,1,1}; // Text color
	// 		colorSelect[] = {1,1,1,1}; // Selected text color (oscillates between this and colorSelect2 in control root)
	// 	};
	// 	// Scrollbar configuration (applied only when LB_TEXTURES style is used)
	// 	class ScrollBar
	// 	{
	// 		width = 0; // width of scrollBar
	// 		height = 0; // height of scrollbar
	// 		scrollSpeed = 0.01; // speed of scroll bar

	// 		arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";	// Arrow
	// 		arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";		// Arrow when clicked on
	// 		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";			// Slider background (stretched vertically)
	// 		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";				// Dragging element (stretched vertically)

	// 		color[] = {1,1,1,1}; // Scrollbar color (combined with List >> colorBorder)
	// 	};

	// 	// onCanDestroy = "systemChat str ['onCanDestroy',_this]; true";
	// 	// onDestroy = "systemChat str ['onDestroy',_this]; false";
	// 	// onMouseEnter = "systemChat str ['onMouseEnter',_this]; false";
	// 	// onMouseExit = "systemChat str ['onMouseExit',_this]; false";
	// 	// onSetFocus = "systemChat str ['onSetFocus',_this]; false";
	// 	// onKillFocus = "systemChat str ['onKillFocus',_this]; false";
	// 	// onKeyDown = "systemChat str ['onKeyDown',_this]; false";
	// 	// onKeyUp = "systemChat str ['onKeyUp',_this]; false";
	// 	// onMouseButtonDown = "systemChat str ['onMouseButtonDown',_this]; false";
	// 	// onMouseButtonUp = "systemChat str ['onMouseButtonUp',_this]; false";
	// 	// onMouseButtonClick = "systemChat str ['onMouseButtonClick',_this]; false";
	// 	// onMouseButtonDblClick = "systemChat str ['onMouseButtonDblClick',_this]; false";
	// 	// onMouseZChanged = "systemChat str ['onMouseZChanged',_this]; false";
	// 	// onMouseMoving = "";
	// 	// onMouseHolding = "";

	// 	onLBSelChanged = "systemChat str ['onLBSelChanged',_this]; false";
	// 	onLBDblClick = "systemChat str ['onLBDblClick',_this]; false";
	// 	onLBListSelChanged = "systemChat str ['onLBListSelChanged',_this]; false";
	// };






	// class ntech_revive_unitswitch_list: RscXListBox
	// {
	// 	access = 0; // Control access (0 - ReadAndWrite, 1 - ReadAndCreate, 2 - ReadOnly, 3 - ReadOnlyVerified)
	// 	idc = 4391;
	// 	x = 0 * GUI_GRID_W + GUI_GRID_X;
	// 	y = -9.5 * GUI_GRID_H + GUI_GRID_Y;
	// 	w = 40.5 * GUI_GRID_W;
	// 	h = 2 * GUI_GRID_H;
	// 	// x = 0 * GUI_GRID_W + GUI_GRID_X;
	// 	// y = 0 * GUI_GRID_H + GUI_GRID_Y;
	// 	// w = 40 * GUI_GRID_W;
	// 	// h = 25 * GUI_GRID_H;
	// 	type = CT_XLISTBOX;
	// 	style = ST_CENTER + LB_TEXTURES + SL_HORZ;
	// 	shadow = 2;
	// 	arrowEmpty = "\A3\ui_f\data\gui\cfg\slider\arrowEmpty_ca.paa";
	// 	arrowFull = "\A3\ui_f\data\gui\cfg\slider\arrowFull_ca.paa";
	// 	border = "\A3\ui_f\data\gui\cfg\slider\border_ca.paa";
	// 	color[] = {1,1,1,0.6};
	// 	colorActive[] = {1,1,1,1};
	// 	// colorDisabled[] = {1,1,1,0.5};
	// 	// colorSelect[] = {0.95,0.95,0.95,1};
	// 	// colorText[] = {1,1,1,1};
	// 	sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1.5)"; // text size
	// 	// font = GUI_FONT_NORMAL; // Font from CfgFontFamilies
	// 	colorText[] = {1,1,1,1}; // Text color
	// 	colorSelect[] = {1,0.5,0,1}; // Selected text color
	// 	colorDisabled[] = {1,1,1,0.5}; // Disabled text color
	// 	onLBSelChanged = "localNamespace setVariable ['ntech_revive_goat', _this select 1]"; // "systemChat format['this: %1', _this]"; // systemChat str ['onLBSelChanged',_this]; false";
	// 	// onLBSelChanged = "systemChat str ['onLBSelChanged',_this]; false";
	// 	// onLBDblClick = "systemChat str ['onLBDblClick',_this]; false";
	// };

	// class ntech_revive_unitswitch_list
	// {
	//   access = 0; // Control access (0 - ReadAndWrite, 1 - ReadAndCreate, 2 - ReadOnly, 3 - ReadOnlyVerified)
	//   idc = CT_XLISTBOX; // Control identification (without it, the control won't be displayed)
	//   type = CT_XLISTBOX; // Type is 42
	//   style = SL_HORZ + ST_CENTER + LB_TEXTURES; // Style
	//   default = 0; // Control selected by default (only one within a display can be used)
	//   blinkingPeriod = 0; // Time in which control will fade out and back in. Use 0 to disable the effect.

	//   x = 12 * GUI_GRID_CENTER_W + GUI_GRID_CENTER_X; // Horizontal coordinates
	//   y = 17 * GUI_GRID_CENTER_H + GUI_GRID_CENTER_Y; // Vertical coordinates
	//   w = 10 * GUI_GRID_CENTER_W; // Width
	//   h = 1 * GUI_GRID_CENTER_H; // Height

	//   color[] = {1,1,1,1}; // Arrow color
	//   colorActive[] = {1,0.5,0,1}; // Selected arrow color

	//   sizeEx = GUI_GRID_CENTER_H; // Text size
	//   font = GUI_FONT_NORMAL; // Font from CfgFontFamilies
	//   shadow = 0; // Shadow (0 - none, 1 - N/A, 2 - black outline)
	//   colorText[] = {1,1,1,1}; // Text color
	//   colorSelect[] = {1,0.5,0,1}; // Selected text color
	//   colorDisabled[] = {1,1,1,0.5}; // Disabled text color

	//   tooltip = "CT_XLISTBOX"; // Tooltip text
	//   tooltipColorShade[] = {0,0,0,1}; // Tooltip background color
	//   tooltipColorText[] = {1,1,1,1}; // Tooltip text color
	//   tooltipColorBox[] = {1,1,1,1}; // Tooltip frame color

	//   arrowEmpty = "\A3\ui_f\data\gui\cfg\slider\arrowEmpty_ca.paa"; // Arrow
	//   arrowFull = "\A3\ui_f\data\gui\cfg\slider\arrowFull_ca.paa"; // Arrow when clicked on
	//   border = "\A3\ui_f\data\gui\cfg\slider\border_ca.paa"; // Fill texture

	//   soundSelect[] = {"\A3\ui_f\data\sound\RscListbox\soundSelect",0.09,1}; // Sound played when an item is selected

	//   onCanDestroy = "systemChat str ['onCanDestroy',_this]; true";
	//   onDestroy = "systemChat str ['onDestroy',_this]; false";
	//   onSetFocus = "systemChat str ['onSetFocus',_this]; false";
	//   onKillFocus = "systemChat str ['onKillFocus',_this]; false";
	//   onKeyDown = "systemChat str ['onKeyDown',_this]; false";
	//   onKeyUp = "systemChat str ['onKeyUp',_this]; false";
	//   onMouseButtonDown = "systemChat str ['onMouseButtonDown',_this]; false";
	//   onMouseButtonUp = "systemChat str ['onMouseButtonUp',_this]; false";
	//   onMouseButtonClick = "systemChat str ['onMouseButtonClick',_this]; false";
	//   onMouseButtonDblClick = "systemChat str ['onMouseButtonDblClick',_this]; false";
	//   onMouseZChanged = "systemChat str ['onMouseZChanged',_this]; false";
	//   onMouseMoving = "";
	//   onMouseHolding = "";

	// onLBSelChanged = "systemChat str ['onLBSelChanged',_this]; false";
	// onLBDblClick = "systemChat str ['onLBDblClick',_this]; false";
	// };
