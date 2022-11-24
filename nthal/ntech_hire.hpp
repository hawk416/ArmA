import RscXSliderH;
class ntech_hire
{
	idd = 4210; //-1 to disable // no need for the whole dialog to be referenced at any time.
	move=false;
	movingEnable = false; //not moving
	moving = 1; // who the hell knows what this does????????
	onLoad = ""; //code to run when it loads
	onUnload = ""; //code to run when its closed
	controls[] = {
		ntech_hire_lbgroup,
		ntech_hire_lbtrait,
		ntech_hire_lbloadout,
		ntech_hire_cancel,
		ntech_hire_ok,
		ntech_hire_exit,
		ntech_hire_skill_general,
		ntech_hire_skill_accuracy,
		ntech_hire_skill_shake,
		ntech_hire_skill_reload,
		ntech_hire_skill_spotdist,
		ntech_hire_skill_courage,
		ntech_hire_skill_aimspeed,
		ntech_hire_skill_command,
		ntech_hire_skill_spottime
	}; //anything that doesn't fit into the category below
	controlsBackground[] = {
		ntech_hire_frame,
		ntech_hire_bg,
		ntech_hire_header,
		ntech_hire_txtgrp,
		ntech_hire_txtskills,
		ntech_hire_txttrait,
		ntech_hire_txtldt,
		ntech_hire_txtgnrl,
		ntech_hire_txtacc,
		ntech_hire_txtshake,
		ntech_hire_txtspeed,
		ntech_hire_txtrld,
		ntech_hire_txtsptdist,
		ntech_hire_txtspttime,
		ntech_hire_txtcrg,
		ntech_hire_txtcmd
	}; //background things that can’t be interacted with

	// Unknown Class RscFrame
	class ntech_hire_frame: RscFrame
	{
		idc = 1800;
		x = 3 * GUI_GRID_W + GUI_GRID_X;
		y = 1 * GUI_GRID_H + GUI_GRID_Y;
		w = 34 * GUI_GRID_W;
		h = 16 * GUI_GRID_H;
	};
	class ntech_hire_bg: IGUIBack
	{
		idc = 2200;
		x = 3 * GUI_GRID_W + GUI_GRID_X;
		y = 1 * GUI_GRID_H + GUI_GRID_Y;
		w = 34 * GUI_GRID_W;
		h = 16 * GUI_GRID_H;
	};
	class ntech_hire_lbgroup: RscListbox
	{
		idc = 1500;
		x = 4 * GUI_GRID_W + GUI_GRID_X;
		y = 3 * GUI_GRID_H + GUI_GRID_Y;
		w = 11 * GUI_GRID_W;
		h = 13 * GUI_GRID_H;
	};
	class ntech_hire_lbtrait: RscListbox
	{
		idc = 1501;
		x = 28 * GUI_GRID_W + GUI_GRID_X;
		y = 3 * GUI_GRID_H + GUI_GRID_Y;
		w = 8 * GUI_GRID_W;
		h = 3 * GUI_GRID_H;
		class Items
		{
			class Item0
			{
				text = "None";
				textRight = "";
				tooltip = "No special trait";
				data = "";
				value = 0;
				// default = 0;
			};
			class Item1
			{
				text = "Medic";
				tooltip = "Ability to treat self and others with medikit";
				data = "";
				// default = 1;
			};
			class Item2
			{
				text = "Engineer";
				tooltip = "Ability to partially repair vehicles with toolkit";
				data = "";
				// default = 1;
			};
			class Item3
			{
				text = "ExplosiveSpecialist";
				tooltip = "Ability to defuse mines with toolkit";
				data = "";
				// default = 1;
			};
			class Item4
			{
				text = "UavHacker";
				tooltip = "Ability to hack drones";
				data = "";
				// default = 1;
			};
		};
	};
	class ntech_hire_lbloadout: RscListbox
	{
		idc = 1502;
		x = 28 * GUI_GRID_W + GUI_GRID_X;
		y = 7 * GUI_GRID_H + GUI_GRID_Y;
		w = 8 * GUI_GRID_W;
		h = 6 * GUI_GRID_H;
	};
	class ntech_hire_cancel: RscButton
	{
		idc = 1600;
		text = "[X]"; //--- ToDo: Localize;
		x = 35 * GUI_GRID_W + GUI_GRID_X;
		y = 1 * GUI_GRID_H + GUI_GRID_Y;
		w = 2 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
		onButtonClick = "closeDialog 0";
	};
	class ntech_hire_ok: RscButton
	{
		idc = 1601;
		text = "Hire"; //--- ToDo: Localize;
		x = 32 * GUI_GRID_W + GUI_GRID_X;
		y = 14 * GUI_GRID_H + GUI_GRID_Y;
		w = 4 * GUI_GRID_W;
		h = 2 * GUI_GRID_H;
	};
	class ntech_hire_exit: RscButton
	{
		idc = 1602;
		text = "Exit"; //--- ToDo: Localize;
		x = 28 * GUI_GRID_W + GUI_GRID_X;
		y = 14 * GUI_GRID_H + GUI_GRID_Y;
		w = 3 * GUI_GRID_W;
		h = 2 * GUI_GRID_H;
		onButtonClick = "closeDialog 0";
	};
	class ntech_hire_header: RscText
	{
		idc = 1000;
		text = "Hire Unit"; //--- ToDo: Localize;
		x = 3 * GUI_GRID_W + GUI_GRID_X;
		y = 1 * GUI_GRID_H + GUI_GRID_Y;
		w = 32 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
	};
	class ntech_hire_skill_general: RscXSliderH
	{
		idc = 1900;
		x = 20 * GUI_GRID_W + GUI_GRID_X;
		y = 3 * GUI_GRID_H + GUI_GRID_Y;
		w = 7 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
		tooltip="50";
		sliderRange[] = {0,100};
		sliderPosition = 50;
		sliderStep = 1;
		onSliderPosChanged = "(_this select 0) ctrlSetTooltip format['%1',(_this select 1)]";
		// onSliderPosChanged = "hint format['ctrl: %1, value: %2', _this select 0, _this select 1]";
	};
	class ntech_hire_skill_accuracy: RscXSliderH
	{
		idc = 1901;
		x = 20 * GUI_GRID_W + GUI_GRID_X;
		y = 4.5 * GUI_GRID_H + GUI_GRID_Y;
		w = 7 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
		tooltip="50";
		sliderRange[] = {0,100};
		sliderPosition = 50;
		sliderStep = 1;
	};
	class ntech_hire_skill_shake: RscXSliderH
	{
		idc = 1902;
		x = 20 * GUI_GRID_W + GUI_GRID_X;
		y = 6 * GUI_GRID_H + GUI_GRID_Y;
		w = 7 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
		tooltip="50";
		sliderRange[] = {0,100};
		sliderPosition = 50;
		sliderStep = 1;
	};
	class ntech_hire_skill_reload: RscXSliderH
	{
		idc = 1903;
		x = 20 * GUI_GRID_W + GUI_GRID_X;
		y = 9 * GUI_GRID_H + GUI_GRID_Y;
		w = 7 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
		tooltip="50";
		sliderRange[] = {0,100};
		sliderPosition = 50;
		sliderStep = 1;
	};
	class ntech_hire_skill_spotdist: RscXSliderH
	{
		idc = 1904;
		x = 20 * GUI_GRID_W + GUI_GRID_X;
		y = 10.5 * GUI_GRID_H + GUI_GRID_Y;
		w = 7 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
		tooltip="50";
		sliderRange[] = {0,100};
		sliderPosition = 50;
		sliderStep = 1;
	};
	class ntech_hire_skill_courage: RscXSliderH
	{
		idc = 1905;
		x = 20 * GUI_GRID_W + GUI_GRID_X;
		y = 13.5 * GUI_GRID_H + GUI_GRID_Y;
		w = 7 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
		tooltip="50";
		sliderRange[] = {0,100};
		sliderPosition = 50;
		sliderStep = 1;
	};
	class ntech_hire_skill_aimspeed: RscXSliderH
	{
		idc = 1906;
		x = 20 * GUI_GRID_W + GUI_GRID_X;
		y = 7.5 * GUI_GRID_H + GUI_GRID_Y;
		w = 7 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
		tooltip="50";
		sliderRange[] = {0,100};
		sliderPosition = 50;
		sliderStep = 1;
	};
	class ntech_hire_skill_command: RscXSliderH
	{
		idc = 1907;
		x = 20 * GUI_GRID_W + GUI_GRID_X;
		y = 15 * GUI_GRID_H + GUI_GRID_Y;
		w = 7 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
		tooltip="50";
		sliderRange[] = {0,100};
		sliderPosition = 50;
		sliderStep = 1;
	};
	class ntech_hire_skill_spottime: RscXSliderH
	{
		idc = 1908;
		x = 20 * GUI_GRID_W + GUI_GRID_X;
		y = 12 * GUI_GRID_H + GUI_GRID_Y;
		w = 7 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
		tooltip="50";
		sliderRange[] = {0,100};
		sliderPosition = 50;
		sliderStep = 1;
	};
	class ntech_hire_txtgrp: RscText
	{
		idc = 1001;
		text = "Group"; //--- ToDo: Localize;
		x = 4 * GUI_GRID_W + GUI_GRID_X;
		y = 2 * GUI_GRID_H + GUI_GRID_Y;
		w = 4 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
	};
	class ntech_hire_txtskills: RscText
	{
		idc = 1002;
		text = "Skills"; //--- ToDo: Localize;
		x = 18 * GUI_GRID_W + GUI_GRID_X;
		y = 2 * GUI_GRID_H + GUI_GRID_Y;
		w = 4 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
	};
	class ntech_hire_txttrait: RscText
	{
		idc = 1003;
		text = "Trait"; //--- ToDo: Localize;
		x = 28 * GUI_GRID_W + GUI_GRID_X;
		y = 2 * GUI_GRID_H + GUI_GRID_Y;
		w = 4 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
	};
	class ntech_hire_txtldt: RscText
	{
		idc = 1004;
		text = "Loadout"; //--- ToDo: Localize;
		x = 28 * GUI_GRID_W + GUI_GRID_X;
		y = 6 * GUI_GRID_H + GUI_GRID_Y;
		w = 4 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
	};
	class ntech_hire_txtgnrl: RscText
	{
		idc = 1005;
		text = "General"; //--- ToDo: Localize;
		x = 15.5 * GUI_GRID_W + GUI_GRID_X;
		y = 3 * GUI_GRID_H + GUI_GRID_Y;
		w = 4 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
	};
	class ntech_hire_txtacc: RscText
	{
		idc = 1006;
		text = "Accuracy"; //--- ToDo: Localize;
		x = 15.5 * GUI_GRID_W + GUI_GRID_X;
		y = 4.5 * GUI_GRID_H + GUI_GRID_Y;
		w = 4 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
	};
	class ntech_hire_txtshake: RscText
	{
		idc = 1007;
		text = "Aim Shake"; //--- ToDo: Localize;
		x = 15.5 * GUI_GRID_W + GUI_GRID_X;
		y = 6 * GUI_GRID_H + GUI_GRID_Y;
		w = 4 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
	};
	class ntech_hire_txtspeed: RscText
	{
		idc = 1008;
		text = "Aim Speed"; //--- ToDo: Localize;
		x = 15.5 * GUI_GRID_W + GUI_GRID_X;
		y = 7.5 * GUI_GRID_H + GUI_GRID_Y;
		w = 4 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
	};
	class ntech_hire_txtrld: RscText
	{
		idc = 1009;
		text = "Reload"; //--- ToDo: Localize;
		x = 15.5 * GUI_GRID_W + GUI_GRID_X;
		y = 9 * GUI_GRID_H + GUI_GRID_Y;
		w = 4 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
	};
	class ntech_hire_txtsptdist: RscText
	{
		idc = 1010;
		text = "Spot Dist"; //--- ToDo: Localize;
		x = 15.5 * GUI_GRID_W + GUI_GRID_X;
		y = 10.5 * GUI_GRID_H + GUI_GRID_Y;
		w = 4 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
	};
	class ntech_hire_txtspttime: RscText
	{
		idc = 1011;
		text = "Spot Time"; //--- ToDo: Localize;
		x = 15.5 * GUI_GRID_W + GUI_GRID_X;
		y = 12 * GUI_GRID_H + GUI_GRID_Y;
		w = 4 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
	};
	class ntech_hire_txtcrg: RscText
	{
		idc = 1012;
		text = "Courage"; //--- ToDo: Localize;
		x = 15.5 * GUI_GRID_W + GUI_GRID_X;
		y = 13.5 * GUI_GRID_H + GUI_GRID_Y;
		w = 4 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
	};
	class ntech_hire_txtcmd: RscText
	{
		idc = 1013;
		text = "Command"; //--- ToDo: Localize;
		x = 15.5 * GUI_GRID_W + GUI_GRID_X;
		y = 15 * GUI_GRID_H + GUI_GRID_Y;
		w = 4 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
	};
};
