/*
	NTech squad manager gui

GUI EDITOR
$[
	1.063,
	["SM",[[0,0,1,1],0.025,0.04,"GUI_GRID"],0,0,0],
	[1800,"ntech_squadmanager_frame",[2,"",["4 * GUI_GRID_W + GUI_GRID_X","1 * GUI_GRID_H + GUI_GRID_Y","32 * GUI_GRID_W","16 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[2200,"ntech_squadmanager_bg",[2,"",["4 * GUI_GRID_W + GUI_GRID_X","1 * GUI_GRID_H + GUI_GRID_Y","32 * GUI_GRID_W","16 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[2700,"ntech_squadmanager_btn_x",[2,"[X]",["34 * GUI_GRID_W + GUI_GRID_X","1 * GUI_GRID_H + GUI_GRID_Y","2 * GUI_GRID_W","1 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1000,"ntech_squadmanager_hdr_txt",[2,"Squad Manager",["4 * GUI_GRID_W + GUI_GRID_X","1 * GUI_GRID_H + GUI_GRID_Y","30 * GUI_GRID_W","1 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[2100,"",[2,"grpbox",["5 * GUI_GRID_W + GUI_GRID_X","3 * GUI_GRID_H + GUI_GRID_Y","8 * GUI_GRID_W","1 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1500,"",[2,"",["5 * GUI_GRID_W + GUI_GRID_X","5 * GUI_GRID_H + GUI_GRID_Y","8 * GUI_GRID_W","11 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[2101,"grptransfer",[2,"",["24 * GUI_GRID_W + GUI_GRID_X","7 * GUI_GRID_H + GUI_GRID_Y","11 * GUI_GRID_W","1 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[2102,"loadout",[2,"",["24 * GUI_GRID_W + GUI_GRID_X","15 * GUI_GRID_H + GUI_GRID_Y","11 * GUI_GRID_W","1 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1400,"",[2,"Callsign",["27 * GUI_GRID_W + GUI_GRID_X","3 * GUI_GRID_H + GUI_GRID_Y","8 * GUI_GRID_W","1 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1600,"",[2,"Set Callsign:",["22 * GUI_GRID_W + GUI_GRID_X","3 * GUI_GRID_H + GUI_GRID_Y","5 * GUI_GRID_W","1 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1601,"cache",[2,"Cache/Load",["15 * GUI_GRID_W + GUI_GRID_X","3 * GUI_GRID_H + GUI_GRID_Y","5 * GUI_GRID_W","1 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1200,"primary",[2,"#(argb,8,8,3)color(1,1,1,1)",["15 * GUI_GRID_W + GUI_GRID_X","5 * GUI_GRID_H + GUI_GRID_Y","7 * GUI_GRID_W","2 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1201,"secondary",[2,"#(argb,8,8,3)color(1,1,1,1)",["15 * GUI_GRID_W + GUI_GRID_X","8 * GUI_GRID_H + GUI_GRID_Y","7 * GUI_GRID_W","2 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1202,"hgun",[2,"#(argb,8,8,3)color(1,1,1,1)",["15 * GUI_GRID_W + GUI_GRID_X","11 * GUI_GRID_H + GUI_GRID_Y","7 * GUI_GRID_W","2 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1203,"trait",[2,"#(argb,8,8,3)color(1,1,1,1)",["15 * GUI_GRID_W + GUI_GRID_X","14 * GUI_GRID_H + GUI_GRID_Y","7 * GUI_GRID_W","2 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1602,"",[2,"Add unit to new group",["24 * GUI_GRID_W + GUI_GRID_X","5 * GUI_GRID_H + GUI_GRID_Y","11 * GUI_GRID_W","1 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1501,"skills",[2,"",["24 * GUI_GRID_W + GUI_GRID_X","9 * GUI_GRID_H + GUI_GRID_Y","11 * GUI_GRID_W","5 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]]
]
*/
class ntech_squadmanager
{
	idd = 4210; //-1 to disable // no need for the whole dialog to be referenced at any time.
	move=false;
	movingEnable = false; //not moving
	moving = 1; // who the hell knows what this does????????
	onLoad = ""; //code to run when it loads
	onUnload = ""; //code to run when its closed
	controls[] = {
		ntech_squadmanager_btn_x,
		ntech_squadmanager_grpbox,
		ntech_squadmanager_unitlb,
		ntech_squadmanager_grptransferbox,
		ntech_squadmanager_loadoutbox,
		ntech_squadmanager_edit,
		ntech_squadmanager_setcallsign,
		ntech_squadmanager_cache,
		ntech_squadmanager_newgrp,
		ntech_squadmanager_skills
	}; //anything that doesn't fit into the category below
	controlsBackground[] = {
		ntech_squadmanager_frame,
		ntech_squadmanager_bg,
		ntech_squadmanager_hdr_txt,
		ntech_squadmanager_primary,
		ntech_squadmanager_secondary,
		ntech_squadmanager_hgun,
		ntech_squadmanager_trait
	}; //background things that can’t be interacted with

	class ntech_squadmanager_frame: RscFrame
	{
		idc = 1800;
		x = 4 * GUI_GRID_W + GUI_GRID_X;
		y = 1 * GUI_GRID_H + GUI_GRID_Y;
		w = 32 * GUI_GRID_W;
		h = 16 * GUI_GRID_H;
	};
	class ntech_squadmanager_bg: IGUIBack
	{
		idc = 2200;
		x = 4 * GUI_GRID_W + GUI_GRID_X;
		y = 1 * GUI_GRID_H + GUI_GRID_Y;
		w = 32 * GUI_GRID_W;
		h = 16 * GUI_GRID_H;
	};
	class ntech_squadmanager_btn_x: RscButton
	{
		idc=2202;
		text = "[X]"; //--- ToDo: Localize;
		x = 34 * GUI_GRID_W + GUI_GRID_X;
		y = 1 * GUI_GRID_H + GUI_GRID_Y;
		w = 2 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
		onButtonClick="closeDialog 0";
	};
	class ntech_squadmanager_hdr_txt: RscText
	{
		idc = 1000;
		text = "Squad Manager"; //--- ToDo: Localize;
		x = 4 * GUI_GRID_W + GUI_GRID_X;
		y = 1 * GUI_GRID_H + GUI_GRID_Y;
		w = 30 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
	};
	class ntech_squadmanager_grpbox: RscCombo
	{
		idc = 2100;
		// text = "grpbox"; //--- ToDo: Localize;
		x = 5 * GUI_GRID_W + GUI_GRID_X;
		y = 3 * GUI_GRID_H + GUI_GRID_Y;
		w = 8 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
		onLBSelChanged="['updgrp',(_this select 1)] execVM 'sqmngr.sqf'";
	};
	class ntech_squadmanager_unitlb: RscListbox
	{
		idc = 1500;
		x = 5 * GUI_GRID_W + GUI_GRID_X;
		y = 5 * GUI_GRID_H + GUI_GRID_Y;
		w = 8 * GUI_GRID_W;
		h = 11 * GUI_GRID_H;
		onLBSelChanged="['updunit',(_this select 1)] execVM 'sqmngr.sqf'";
	};
	class ntech_squadmanager_grptransferbox: RscCombo
	{
		idc = 2101;
		x = 24 * GUI_GRID_W + GUI_GRID_X;
		y = 7 * GUI_GRID_H + GUI_GRID_Y;
		w = 11 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
		onLBSelChanged="['swgrp',(_this select 1)] execVM 'sqmngr.sqf'";

	};
	class ntech_squadmanager_loadoutbox: RscCombo
	{
		idc = 2102;
		x = 24 * GUI_GRID_W + GUI_GRID_X;
		y = 15 * GUI_GRID_H + GUI_GRID_Y;
		w = 11 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
		onLBSelChanged="['setldt',(_this select 1)] execVM 'sqmngr.sqf'";
	};
	class ntech_squadmanager_edit: RscEdit
	{
		idc = 1400;
		text = "Callsign"; //--- ToDo: Localize;
		x = 27 * GUI_GRID_W + GUI_GRID_X;
		y = 3 * GUI_GRID_H + GUI_GRID_Y;
		w = 8 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
	};
	class ntech_squadmanager_setcallsign: RscButton
	{
		idc = 1600;
		text = "Set Callsign:"; //--- ToDo: Localize;
		x = 22 * GUI_GRID_W + GUI_GRID_X;
		y = 3 * GUI_GRID_H + GUI_GRID_Y;
		w = 5 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
		onButtonClick="['setcallsign'] execVM 'sqmngr.sqf'";
	};
	class ntech_squadmanager_cache: RscButton
	{
		idc = 1601;
		text = "Cache/Load"; //--- ToDo: Localize;
		x = 15 * GUI_GRID_W + GUI_GRID_X;
		y = 3 * GUI_GRID_H + GUI_GRID_Y;
		w = 5 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
	};
	class ntech_squadmanager_primary: RscPicture
	{
		idc = 1200;
		text = "#(argb,8,8,3)color(1,1,1,1)";
		x = 15 * GUI_GRID_W + GUI_GRID_X;
		y = 5 * GUI_GRID_H + GUI_GRID_Y;
		w = 7 * GUI_GRID_W;
		h = 2 * GUI_GRID_H;
	};
	class ntech_squadmanager_secondary: RscPicture
	{
		idc = 1201;
		text = "#(argb,8,8,3)color(1,1,1,1)";
		x = 15 * GUI_GRID_W + GUI_GRID_X;
		y = 8 * GUI_GRID_H + GUI_GRID_Y;
		w = 7 * GUI_GRID_W;
		h = 2 * GUI_GRID_H;
	};
	class ntech_squadmanager_hgun: RscPicture
	{
		idc = 1202;
		text = "#(argb,8,8,3)color(1,1,1,1)";
		x = 15 * GUI_GRID_W + GUI_GRID_X;
		y = 11 * GUI_GRID_H + GUI_GRID_Y;
		w = 7 * GUI_GRID_W;
		h = 2 * GUI_GRID_H;
	};
	class ntech_squadmanager_trait: RscPicture
	{
		idc = 1203;
		text = "#(argb,8,8,3)color(1,1,1,1)";
		x = 15 * GUI_GRID_W + GUI_GRID_X;
		y = 14 * GUI_GRID_H + GUI_GRID_Y;
		w = 7 * GUI_GRID_W;
		h = 2 * GUI_GRID_H;
	};
	class ntech_squadmanager_newgrp: RscButton
	{
		idc = 1602;
		text = "Add unit to new group"; //--- ToDo: Localize;
		x = 24 * GUI_GRID_W + GUI_GRID_X;
		y = 5 * GUI_GRID_H + GUI_GRID_Y;
		w = 11 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
		onButtonClick="['newgrp'] execVM 'sqmngr.sqf'";
	};
	class ntech_squadmanager_skills: RscListbox
	{
		idc = 1501;
		x = 24 * GUI_GRID_W + GUI_GRID_X;
		y = 9 * GUI_GRID_H + GUI_GRID_Y;
		w = 11 * GUI_GRID_W;
		h = 5 * GUI_GRID_H;
	};
};
