/*
	NTech Garage Drop
$[
	1.063,
	["ntech_garagedrop",[[0,0,1,1],0.025,0.04,"GUI_GRID"],0,0,0],
	[2200,"ntech_garagedrop_bg",[2,"",["7 * GUI_GRID_W + GUI_GRID_X","3 * GUI_GRID_H + GUI_GRID_Y","25 * GUI_GRID_W","19 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1500,"ntech_garagedrop_box",[2,"",["8.5 * GUI_GRID_W + GUI_GRID_X","5 * GUI_GRID_H + GUI_GRID_Y","10 * GUI_GRID_W","15 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1600,"ntech_garagedrop_btnmap",[2,"Drop on Map",["23 * GUI_GRID_W + GUI_GRID_X","15 * GUI_GRID_H + GUI_GRID_Y","7 * GUI_GRID_W","2 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1601,"ntech_garagedrop_btnplayer",[2,"Drop On Player",["23 * GUI_GRID_W + GUI_GRID_X","18 * GUI_GRID_H + GUI_GRID_Y","7 * GUI_GRID_W","2 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]]
]
*/
class ntech_garagedrop
{
	idd = 4110; //no need for the whole dialog to be referenced at any time.
	move=false;
	movingEnable = false; //not moving
	moving = 1; // who the hell knows what this does????????
	onLoad = "for '_i' from 0 to (count NTECH_GARAGE)-2 step 2 do {_indx=lbAdd [1500, getText (configFile >> 'CfgVehicles' >> NTECH_GARAGE select _i >> 'DisplayName')];lbSetValue [1500, _indx, _i]}"; //code to run when it loads
	onUnload = ""; //code to run when its closed
	controls[] = {
		ntech_garagedrop_box,
		ntech_garagedrop_btnmap,
		ntech_garagedrop_btnplayer
	}; //anything that doesn't fit into the category below
	controlsBackground[] = {
		ntech_garagedrop_bg
	}; //background things that can’t be interacted with

	class ntech_garagedrop_bg: IGUIBack
	{
		idc = 2200;
		x = 7 * GUI_GRID_W + GUI_GRID_X;
		y = 3 * GUI_GRID_H + GUI_GRID_Y;
		w = 25 * GUI_GRID_W;
		h = 19 * GUI_GRID_H;
	};
	class ntech_garagedrop_box: RscListbox
	{
		idc = 1500;
		x = 8.5 * GUI_GRID_W + GUI_GRID_X;
		y = 5 * GUI_GRID_H + GUI_GRID_Y;
		w = 10 * GUI_GRID_W;
		h = 15 * GUI_GRID_H;
	};
	class ntech_garagedrop_btnmap: RscButton
	{
		idc = 1600;
		text = "Drop on Map"; //--- ToDo: Localize;
		x = 23 * GUI_GRID_W + GUI_GRID_X;
		y = 15 * GUI_GRID_H + GUI_GRID_Y;
		w = 7 * GUI_GRID_W;
		h = 2 * GUI_GRID_H;
	};
	class ntech_garagedrop_btnplayer: RscButton
	{
		idc = 1601;
		text = "Drop On Player"; //--- ToDo: Localize;
		x = 23 * GUI_GRID_W + GUI_GRID_X;
		y = 18 * GUI_GRID_H + GUI_GRID_Y;
		w = 7 * GUI_GRID_W;
		h = 2 * GUI_GRID_H;
		onMouseButtonClick="['drop', getPos player] call ntech_fnc_garagedrop";
	};
};
