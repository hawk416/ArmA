/*
	NTech Garage load
$[
	1.063,
	["ntech_garage_load",[[0,0,1,1],0.025,0.04,"GUI_GRID"],0,0,0],
	[2100,"ntech_garageload_box",[2,"",["6 * GUI_GRID_W + GUI_GRID_X","-9.5 * GUI_GRID_H + GUI_GRID_Y","21 * GUI_GRID_W","1.5 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1600,"ntech_garageload_loadbtn",[2,"load",["28 * GUI_GRID_W + GUI_GRID_X","-9.5 * GUI_GRID_H + GUI_GRID_Y","6 * GUI_GRID_W","1.5 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]]
]
*/
class ntech_garageload
{
	idd = 4110; //no need for the whole dialog to be referenced at any time.
	move=false;
	movingEnable = false; //not moving
	moving = 1; // who the hell knows what this does????????
	onLoad = ""; //code to run when it loads
	onUnload = "if !(isNull NTECH_GARAGE_SELECTED) then {deleteVehicle NTECH_GARAGE_SELECTED}"; //code to run when its closed

	controls[] = {
		ntech_garageload_box,
		ntech_garageload_loadbtn
	}; //anything that doesn't fit into the category below
	controlsBackground[] = {
	}; //background things that can’t be interacted with


	class ntech_garageload_box: RscCombo
	{
		idc = 2100;
		x = 6 * GUI_GRID_W + GUI_GRID_X;
		y = -9.5 * GUI_GRID_H + GUI_GRID_Y;
		w = 21 * GUI_GRID_W;
		h = 1.5 * GUI_GRID_H;
		onLBSelChanged="['update', (_this select 1)] call ntech_fnc_garageload";
	};
	class ntech_garageload_loadbtn: RscButton
	{
		idc = 1600;
		text = "load"; //--- ToDo: Localize;
		x = 28 * GUI_GRID_W + GUI_GRID_X;
		y = -9.5 * GUI_GRID_H + GUI_GRID_Y;
		w = 6 * GUI_GRID_W;
		h = 1.5 * GUI_GRID_H;
		onMouseButtonClick="['load'] call ntech_fnc_garageload";
	};
};
