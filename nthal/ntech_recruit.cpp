/*
	NTECH Recruit UI

GUI EDITOR:
$[
	1.063,
	["HR",[[0,0,1,1],0.025,0.04,"GUI_GRID"],0,0,0],
	[1800,"ntech_recruit_frame",[2,"",["3 * GUI_GRID_W + GUI_GRID_X","1 * GUI_GRID_H + GUI_GRID_Y","34 * GUI_GRID_W","16 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[2200,"ntech_recruit_bg",[2,"",["3 * GUI_GRID_W + GUI_GRID_X","1 * GUI_GRID_H + GUI_GRID_Y","34 * GUI_GRID_W","16 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1500,"ntech_recruit_lb_unit",[2,"",["4 * GUI_GRID_W + GUI_GRID_X","3 * GUI_GRID_H + GUI_GRID_Y","11 * GUI_GRID_W","13 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1501,"ntech_recruit_lb_ldt",[2,"",["28 * GUI_GRID_W + GUI_GRID_X","3 * GUI_GRID_H + GUI_GRID_Y","8 * GUI_GRID_W","6 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1502,"ntech_recruit_lbgrp",[2,"",["28.5 * GUI_GRID_W + GUI_GRID_X","10 * GUI_GRID_H + GUI_GRID_Y","7.5 * GUI_GRID_W","3 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[2700,"ntech_recruit_btn_x",[2,"[X]",["35 * GUI_GRID_W + GUI_GRID_X","1 * GUI_GRID_H + GUI_GRID_Y","2 * GUI_GRID_W","1 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[2600,"ntech_recruit_btn_ok",[2,"Hire",["32 * GUI_GRID_W + GUI_GRID_X","14 * GUI_GRID_H + GUI_GRID_Y","4 * GUI_GRID_W","2 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1000,"ntech_recruit_hdr_txt",[2,"Hire Unit",["3 * GUI_GRID_W + GUI_GRID_X","1 * GUI_GRID_H + GUI_GRID_Y","32 * GUI_GRID_W","1 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1001,"ntech_recruit_txt_unit",[2,"Name",["4 * GUI_GRID_W + GUI_GRID_X","2 * GUI_GRID_H + GUI_GRID_Y","4 * GUI_GRID_W","1 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1002,"ntech_recruit_txt_skills",[2,"Skills",["18 * GUI_GRID_W + GUI_GRID_X","2 * GUI_GRID_H + GUI_GRID_Y","4 * GUI_GRID_W","1 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1003,"ntech_recruit_txtldt",[2,"Loadout",["28 * GUI_GRID_W + GUI_GRID_X","2 * GUI_GRID_H + GUI_GRID_Y","4 * GUI_GRID_W","1 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1004,"ntech_recruit_txtgrp",[2,"group",["28 * GUI_GRID_W + GUI_GRID_X","9 * GUI_GRID_H + GUI_GRID_Y","4 * GUI_GRID_W","1 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1503,"ntech_recruit_lb_skills",[2,"",["17 * GUI_GRID_W + GUI_GRID_X","3 * GUI_GRID_H + GUI_GRID_Y","9 * GUI_GRID_W","10 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1100,"ntech_recruit_sttxt_trait",[2,"",["17 * GUI_GRID_W + GUI_GRID_X","14 * GUI_GRID_H + GUI_GRID_Y","9 * GUI_GRID_W","2 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]]
]
*/
import RscXSliderH;
class ntech_recruit
{
	idd = 4210; //-1 to disable // no need for the whole dialog to be referenced at any time.
	move=false;
	movingEnable = false; //not moving
	moving = 1; // who the hell knows what this does????????
	onLoad = ""; //code to run when it loads
	onUnload = ""; //code to run when its closed
	controls[] = {
		ntech_recruit_lb_unit,
		ntech_recruit_lb_ldt,
		ntech_recruit_lbgrp,
		ntech_recruit_btn_x,
		ntech_recruit_btn_ok,
		ntech_recruit_lb_skills
	}; //anything that doesn't fit into the category below
	controlsBackground[] = {
		ntech_recruit_frame,
		ntech_recruit_bg,
		ntech_recruit_hdr_txt,
		ntech_recruit_txt_unit,
		ntech_recruit_txt_skills,
		ntech_recruit_txtldt,
		ntech_recruit_txtgrp,
		ntech_recruit_sttxt_trait
	}; //background things that can’t be interacted with

	class ntech_recruit_frame: RscFrame
	{
		idc = 1800;
		x = 3 * GUI_GRID_W + GUI_GRID_X;
		y = 1 * GUI_GRID_H + GUI_GRID_Y;
		w = 34 * GUI_GRID_W;
		h = 16 * GUI_GRID_H;
	};
	class ntech_recruit_bg: IGUIBack
	{
		idc = 2200;
		x = 3 * GUI_GRID_W + GUI_GRID_X;
		y = 1 * GUI_GRID_H + GUI_GRID_Y;
		w = 34 * GUI_GRID_W;
		h = 16 * GUI_GRID_H;
	};
	class ntech_recruit_lb_unit: RscListbox
	{
		idc = 1500;
		x = 4 * GUI_GRID_W + GUI_GRID_X;
		y = 3 * GUI_GRID_H + GUI_GRID_Y;
		w = 11 * GUI_GRID_W;
		h = 13 * GUI_GRID_H;
	};
	class ntech_recruit_lb_ldt: RscListbox
	{
		idc = 1501;
		x = 28 * GUI_GRID_W + GUI_GRID_X;
		y = 3 * GUI_GRID_H + GUI_GRID_Y;
		w = 8 * GUI_GRID_W;
		h = 6 * GUI_GRID_H;
	};
	class ntech_recruit_lbgrp: RscListbox
	{
		idc = 1502;
		x = 28.5 * GUI_GRID_W + GUI_GRID_X;
		y = 10 * GUI_GRID_H + GUI_GRID_Y;
		w = 7.5 * GUI_GRID_W;
		h = 3 * GUI_GRID_H;
	};
	class ntech_recruit_btn_x: RscButtonMenuCancel
	{
		text = "[X]"; //--- ToDo: Localize;
		x = 35 * GUI_GRID_W + GUI_GRID_X;
		y = 1 * GUI_GRID_H + GUI_GRID_Y;
		w = 2 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
	};
	class ntech_recruit_btn_ok: RscButtonMenuOK
	{
		text = "Hire"; //--- ToDo: Localize;
		x = 32 * GUI_GRID_W + GUI_GRID_X;
		y = 14 * GUI_GRID_H + GUI_GRID_Y;
		w = 4 * GUI_GRID_W;
		h = 2 * GUI_GRID_H;
	};
	class ntech_recruit_hdr_txt: RscText
	{
		idc = 1000;
		text = "Hire Unit"; //--- ToDo: Localize;
		x = 3 * GUI_GRID_W + GUI_GRID_X;
		y = 1 * GUI_GRID_H + GUI_GRID_Y;
		w = 32 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
	};
	class ntech_recruit_txt_unit: RscText
	{
		idc = 1001;
		text = "Name"; //--- ToDo: Localize;
		x = 4 * GUI_GRID_W + GUI_GRID_X;
		y = 2 * GUI_GRID_H + GUI_GRID_Y;
		w = 4 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
	};
	class ntech_recruit_txt_skills: RscText
	{
		idc = 1002;
		text = "Skills"; //--- ToDo: Localize;
		x = 18 * GUI_GRID_W + GUI_GRID_X;
		y = 2 * GUI_GRID_H + GUI_GRID_Y;
		w = 4 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
	};
	class ntech_recruit_txtldt: RscText
	{
		idc = 1003;
		text = "Loadout"; //--- ToDo: Localize;
		x = 28 * GUI_GRID_W + GUI_GRID_X;
		y = 2 * GUI_GRID_H + GUI_GRID_Y;
		w = 4 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
	};
	class ntech_recruit_txtgrp: RscText
	{
		idc = 1004;
		text = "group"; //--- ToDo: Localize;
		x = 28 * GUI_GRID_W + GUI_GRID_X;
		y = 9 * GUI_GRID_H + GUI_GRID_Y;
		w = 4 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
	};
	class ntech_recruit_lb_skills: RscListbox
	{
		idc = 1503;
		x = 17 * GUI_GRID_W + GUI_GRID_X;
		y = 3 * GUI_GRID_H + GUI_GRID_Y;
		w = 9 * GUI_GRID_W;
		h = 10 * GUI_GRID_H;
	};
	class ntech_recruit_sttxt_trait: RscStructuredText
	{
		idc = 1100;
		x = 17 * GUI_GRID_W + GUI_GRID_X;
		y = 14 * GUI_GRID_H + GUI_GRID_Y;
		w = 9 * GUI_GRID_W;
		h = 2 * GUI_GRID_H;
	};
};
