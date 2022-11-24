/* #Wyvyry
 GUI Edit for Garage UI

$[
	1.063,
	["ntech_garage",[[0,0,1,1],0.025,0.04,"GUI_GRID"],1,0,0],
	[4111,"ntech_garage_listvehicle_bg",[1,"",["0.00499997 * safezoneW + safezoneX","0.0160275 * safezoneH + safezoneY","0.118594 * safezoneW","0.472973 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[4112,"ntech_garage_description_bg",[1,"",["0.00499997 * safezoneW + safezoneX","0.5 * safezoneH + safezoneY","0.118594 * safezoneW","0.395978 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[4113,"ntech_garage_listtextures_bg",[1,"",["0.876406 * safezoneW + safezoneX","0.0160275 * safezoneH + safezoneY","0.118594 * safezoneW","0.472973 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[4114,"ntech_garage_listmods_bg",[1,"",["0.876406 * safezoneW + safezoneX","0.5 * safezoneH + safezoneY","0.118594 * safezoneW","0.384978 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[4115,"ntech_garage_listvehicle",[1,"",["0.0101562 * safezoneW + safezoneX","0.0270268 * safezoneH + safezoneY","0.108281 * safezoneW","0.450974 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[4116,"ntech_garage_listtextures",[1,"",["0.881562 * safezoneW + safezoneX","0.0270268 * safezoneH + safezoneY","0.108281 * safezoneW","0.450974 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[4117,"ntech_garage_listmods",[1,"",["0.881563 * safezoneW + safezoneX","0.510999 * safezoneH + safezoneY","0.108281 * safezoneW","0.362979 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[4118,"ntech_garage_description",[1,"",["0.0101562 * safezoneW + safezoneX","0.510999 * safezoneH + safezoneY","0.108281 * safezoneW","0.373979 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[4119,"ntech_garage_button_left",[1,"OK",["0.00499997 * safezoneW + safezoneX","0.917976 * safezoneH + safezoneY","0.118594 * safezoneW","0.0659963 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[4120,"ntech_garage_button_right",[1,"Cancel",["0.876406 * safezoneW + safezoneX","0.917976 * safezoneH + safezoneY","0.118594 * safezoneW","0.0659963 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]]
]
*/
class ntech_garage
{
	idd = 4110; //no need for the whole dialog to be referenced at any time.
	move=false;
	movingEnable = false; //not moving
	moving = 1; // who the hell knows what this does????????
	onLoad = ""; //code to run when it loads
	onUnload = ""; //code to run when its closed

	controls[] = {
		ntech_garage_listvehicle,
		ntech_garage_listtextures,
		ntech_garage_listmods,
		ntech_garage_description,
		ntech_garage_button_left,
		ntech_garage_button_right
	}; //anything that doesn't fit into the category below
	controlsBackground[] = {
		ntech_garage_listvehicle_bg,
		ntech_garage_description_bg,
		ntech_garage_listtextures_bg,
		ntech_garage_listmods_bg
	}; //background things that can’t be interacted with


	class ntech_garage_listvehicle_bg: IGUIBack
	{
		idc = 4111;
		x = 0.00499997 * safezoneW + safezoneX;
		y = 0.0160275 * safezoneH + safezoneY;
		w = 0.118594 * safezoneW;
		h = 0.472973 * safezoneH;
	};
	class ntech_garage_description_bg: IGUIBack
	{
		idc = 4112;
		x = 0.00499997 * safezoneW + safezoneX;
		y = 0.5 * safezoneH + safezoneY;
		w = 0.118594 * safezoneW;
		h = 0.395978 * safezoneH;
	};
	class ntech_garage_listtextures_bg: IGUIBack
	{
		idc = 4113;
		x = 0.876406 * safezoneW + safezoneX;
		y = 0.0160275 * safezoneH + safezoneY;
		w = 0.118594 * safezoneW;
		h = 0.472973 * safezoneH;
	};
	class ntech_garage_listmods_bg: IGUIBack
	{
		idc = 4114;
		x = 0.876406 * safezoneW + safezoneX;
		y = 0.5 * safezoneH + safezoneY;
		w = 0.118594 * safezoneW;
		h = 0.384978 * safezoneH;
	};
	class ntech_garage_listvehicle: RscListbox
	{
		idc = 4115;
		x = 0.0101562 * safezoneW + safezoneX;
		y = 0.0270268 * safezoneH + safezoneY;
		w = 0.108281 * safezoneW;
		h = 0.450974 * safezoneH;
	};
	class ntech_garage_listtextures: RscListbox
	{
		idc = 4116;
		x = 0.881562 * safezoneW + safezoneX;
		y = 0.0270268 * safezoneH + safezoneY;
		w = 0.108281 * safezoneW;
		h = 0.450974 * safezoneH;
	};
	class ntech_garage_listmods: RscListbox
	{
		idc = 4117;
		style=LB_MULTI;
		x = 0.881563 * safezoneW + safezoneX;
		y = 0.510999 * safezoneH + safezoneY;
		w = 0.108281 * safezoneW;
		h = 0.362979 * safezoneH;
	};
	class ntech_garage_description: RscStructuredText
	{
		idc = 4118;
		x = 0.0101562 * safezoneW + safezoneX;
		y = 0.510999 * safezoneH + safezoneY;
		w = 0.108281 * safezoneW;
		h = 0.373979 * safezoneH;
	};
	class ntech_garage_button_left: RscButton
	{
		idc = 4119;
		text = "OK"; //--- ToDo: Localize;
		x = 0.00499997 * safezoneW + safezoneX;
		y = 0.917976 * safezoneH + safezoneY;
		w = 0.118594 * safezoneW;
		h = 0.0659963 * safezoneH;
	};
	class ntech_garage_button_right: RscButton
	{
		idc = 4120;
		text = "Cancel"; //--- ToDo: Localize;
		x = 0.876406 * safezoneW + safezoneX;
		y = 0.917976 * safezoneH + safezoneY;
		w = 0.118594 * safezoneW;
		h = 0.0659963 * safezoneH;
	};
};