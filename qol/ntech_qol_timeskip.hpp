/* TimeSkip Dialog
$[
	1.063,
	["ntech_qol_timeskip",[[0,0,1,1],0.025,0.04,"GUI_GRID"],0,0,0],
	[1800,"ntech_qol_timeskip_frame",[2,"",["0 * GUI_GRID_W + GUI_GRID_X","6 * GUI_GRID_H + GUI_GRID_Y","40 * GUI_GRID_W","14.5 * GUI_GRID_H"],[-1,-1,-1,-1],[1,1,1,1],[-1,-1,-1,-1],"","-1"],[]],
	[2200,"ntech_qol_timeskip_bg",[2,"",["1 * GUI_GRID_W + GUI_GRID_X","6.5 * GUI_GRID_H + GUI_GRID_Y","38.5 * GUI_GRID_W","13.5 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1900,"ntech_qol_timeskip_slider",[2,"",["1 * GUI_GRID_W + GUI_GRID_X","13.5 * GUI_GRID_H + GUI_GRID_Y","38 * GUI_GRID_W","2 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1600,"ntech_qol_timeskip_btnCancel",[2,"Cancel",["4 * GUI_GRID_W + GUI_GRID_X","16 * GUI_GRID_H + GUI_GRID_Y","12.5 * GUI_GRID_W","3.5 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1100,"ntech_qol_timeskip_title",[2,"",["1 * GUI_GRID_W + GUI_GRID_X","7 * GUI_GRID_H + GUI_GRID_Y","38 * GUI_GRID_W","2 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1101,"ntech_qol_timeskip_currenttime",[2,"",["4 * GUI_GRID_W + GUI_GRID_X","10 * GUI_GRID_H + GUI_GRID_Y","31 * GUI_GRID_W","3 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1601,"ntech_qol_timeskip_btnOK",[2,"OK",["22.5 * GUI_GRID_W + GUI_GRID_X","16 * GUI_GRID_H + GUI_GRID_Y","12.5 * GUI_GRID_W","3.5 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]]
]
*/
class ntech_qol_timeskip
{
	idd = 4210; //no need for the whole dialog to be referenced at any time.
	move=false;
	movingEnable = false; //not moving
	moving = 1; // who the hell knows what this does????????
	onLoad = ""; //code to run when it loads
	onUnload = ""; //code to run when its closed
	controls[] = {
		ntech_qol_timeskip_slider,
		ntech_qol_timeskip_btnCancel,
		ntech_qol_timeskip_btnOK
	}; //anything that doesn't fit into the category below
	controlsBackground[] = {
		ntech_qol_timeskip_frame,
		ntech_qol_timeskip_bg,
		ntech_qol_timeskip_title,
		ntech_qol_timeskip_currenttime
	}; //background things that can’t be interacted with

	class ntech_qol_timeskip_frame: RscFrame
	{
		idc = 4211;
		x = 0 * GUI_GRID_W + GUI_GRID_X;
		y = 6 * GUI_GRID_H + GUI_GRID_Y;
		w = 40 * GUI_GRID_W;
		h = 14.5 * GUI_GRID_H;
		colorBackground[] = {1,1,1,1};
	};
	class ntech_qol_timeskip_bg: IGUIBack
	{
		idc = 4212;
		x = 1 * GUI_GRID_W + GUI_GRID_X;
		y = 6.5 * GUI_GRID_H + GUI_GRID_Y;
		w = 38.5 * GUI_GRID_W;
		h = 13.5 * GUI_GRID_H;
	};
	class ntech_qol_timeskip_slider: RscSlider
	{
		idc = 4213;
		sliderRange[] = {0,1440};
		sliderPosition = 0;
		sliderStep = 5;
		color[] = {1,1,1,0.8};
		// onMouseClick = "systemChat str _this;";
		// onMouseMoving = "systemChat str _this;";
		onSliderPosChanged = "['update', (_this select 1)] execVM 'ntech-qol\timeskip.sqf'";
		x = 1 * GUI_GRID_W + GUI_GRID_X;
		y = 13.5 * GUI_GRID_H + GUI_GRID_Y;
		w = 38 * GUI_GRID_W;
		h = 2 * GUI_GRID_H;
	};
	class ntech_qol_timeskip_btnCancel: RscButton
	{
		idc = 4214;
		text = "Cancel"; //--- ToDo: Localize;
		onButtonClick="closeDialog 2;"; // close the dialog with code: 2 - Cancel
		x = 4 * GUI_GRID_W + GUI_GRID_X;
		y = 16 * GUI_GRID_H + GUI_GRID_Y;
		w = 12.5 * GUI_GRID_W;
		h = 3.5 * GUI_GRID_H;
	};
	class ntech_qol_timeskip_title: RscStructuredText
	{
		idc = 4215;
		x = 1 * GUI_GRID_W + GUI_GRID_X;
		y = 7 * GUI_GRID_H + GUI_GRID_Y;
		w = 38 * GUI_GRID_W;
		h = 2 * GUI_GRID_H;
	};
	class ntech_qol_timeskip_currenttime: RscStructuredText
	{
		idc = 4216;
		x = 4 * GUI_GRID_W + GUI_GRID_X;
		y = 10 * GUI_GRID_H + GUI_GRID_Y;
		w = 31 * GUI_GRID_W;
		h = 3 * GUI_GRID_H;
	};
	class ntech_qol_timeskip_btnOK: RscButton
	{
		idc = 4217;
		text = "OK"; //--- ToDo: Localize;
		onButtonClick = "['skip', (sliderPosition 4213)] execVM 'ntech-qol\timeskip.sqf'";
		x = 22.5 * GUI_GRID_W + GUI_GRID_X;
		y = 16 * GUI_GRID_H + GUI_GRID_Y;
		w = 12.5 * GUI_GRID_W;
		h = 3.5 * GUI_GRID_H;
	};
};
