/*
	Init.sqf for Campaign: Operation Valkyre - Mission 1 - The Call

	Description:
		- Select random Civilian groups and change their side to OPFOR, joining a hold position waypoint
		- Select a random Civilian group and change their side to OPFOR, joining a GTFO waypoint

	Requirements:
		CivGrp_TGT_N: Array of civilian groups for insurgents:
			Create civilians, add them to groups, name the groups, create waypoints. example: CivGrp_1_3
		SynGrp_TGT_N: Array of OPFOR groups for insurgent waypoints
			Create OPFOR groups, set presence to 0, name groups, create waypoints. example: SynGrp_3_2
		
		CivGrp_TGT_Syn: Array of civilian groups for escape
			Create civilians, add them to groups, name the groups, create waypoints. example: CivGrp_1_3
		SynGrp_TGT_Syn: Array of OPFOR groups for escape waypoints
			Create OPFOR units, set presence to 0, create waypoints, create waypoints. example: SynGrp_3_2

	Weapons potential:
		PM 09: hgun_Pistol_01_F - 9mm-10rnd: "10Rnd_9x21_Mag"
		Rook 40: hgun_Rook40_F	- 9mm-16rnd: "16Rnd_9x21_Mag" //technically "30Rnd_9x21_Mag"
		Protector: SMG_05_F 	- 9mm-30rnd: "30Rnd_9x21_Mag_SMG_02"	

	Animations:
		Surrender - Animation -	AmovPercMstpSnonWnonDnon_AmovPercMstpSsurWnonDnon
		Surrender - Standing - AmovPercMstpSsurWnonDnon
		Falling - Standing - ApanPercMstpSnonWnonDnon_ApanPpneMstpSnonWnonDnon
		Crouch panic - Standing - ApanPercMstpSnonWnonDnon_ApanPknlMstpSnonWnonDnon
		Lie down panic - kneel - ApanPknlMstpSnonWnonDnon_ApanPpneMstpSnonWnonDnon
		Covering head prone - prone - ApanPpneMstpSnonWnonDnon_G01

*/


/*
	STATIC VARIABLES
*/
// Civilian and Syndicate groups
//CivGrp_1=[CivGrp_1_1, CivGrp_1_2, CivGrp_1_3, CivGrp_1_4, CivGrp_1_5, CivGrp_1_6];
CivGrp_2=[CivGrp_2_1, CivGrp_2_2, CivGrp_2_3, CivGrp_2_4, CivGrp_2_5, CivGrp_2_6];
//CivGrp_3=[CivGrp_3_1, CivGrp_3_2, CivGrp_3_3, CivGrp_3_4, CivGrp_3_5, CivGrp_3_6];
//SynGrp_1=[SynGrp_1_1, SynGrp_1_2, SynGrp_1_3, SynGrp_1_4, SynGrp_1_5, SynGrp_1_6];
SynGrp_2=[SynGrp_2_1, SynGrp_2_2, SynGrp_2_3, SynGrp_2_4, SynGrp_2_5, SynGrp_2_6];
//SynGrp_3=[SynGrp_3_1, SynGrp_3_2, SynGrp_3_3, SynGrp_3_4, SynGrp_3_5, SynGrp_3_6];

// Civilian and Syndicate groups - escape
//CivEscGrp_1=[CivEscGrp_1_1, CivEscGrp_1_2, CivEscGrp_1_3, CivEscGrp_1_4, CivEscGrp_1_5, CivEscGrp_1_6];
CivEscGrp_2=[CivEscGrp_2_1, CivEscGrp_2_2, CivEscGrp_2_3, CivEscGrp_2_4, CivEscGrp_2_5, CivEscGrp_2_6];
//CivEscGrp_3=[CivEscGrp_3_1, CivEscGrp_3_2, CivEscGrp_3_3, CivEscGrp_3_4, CivEscGrp_3_5, CivEscGrp_3_6];
//SynEscGrp_1=[SynEscGrp_1_1, SynEscGrp_1_2, SynEscGrp_1_3, SynEscGrp_1_4, SynEscGrp_1_5, SynEscGrp_1_6];
//SynEscGrp_2=[SynEscGrp_2_1, SynEscGrp_2_2, SynEscGrp_2_3, SynEscGrp_2_4, SynEscGrp_2_5, SynEscGrp_2_6];
//SynEscGrp_3=[SynEscGrp_3_1, SynEscGrp_3_2, SynEscGrp_3_3, SynEscGrp_3_4, SynEscGrp_3_5, SynEscGrp_3_6];

// Vehicles
Vehicles_1=[Vehicle_1_1,Vehicle_1_2,Vehicle_1_3,Vehicle_1_4];

// Weapons and magazines
SynWeapons=[
	["hgun_Pistol_01_F", "10Rnd_9x21_Mag"],
	["hgun_Rook40_F", "16Rnd_9x21_Mag"],
	["SMG_05_F", "30Rnd_9x21_Mag_SMG_02"]
];

// Group numbers, used to count fallen
CivGrpNum_1=0;
CivGrpNum_2=0;
CivGrpNum_3=0;
SynGrpNum_1=0;
SynGrpNum_2=0;
SynGrpNum_3=0;

// Group numbers, used to count fallen (escape)
CivEscGrpNum_1=0;
CivEscGrpNum_2=0;
CivEscGrpNum_3=0;
SynEscGrpNum_1=0;
SynEscGrpNum_2=0;
SynEscGrpNum_3=0;

/*
	FUNCTIONS
*/

/*
	NTECH_fnc_searchvehicle
*/
NTECH_fnc_searchvehicle={
	{
		[ 	_x,																				// Object to attach action to
			"Search Vehicle", 																// Title of action
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",             	// Idle icon shown on screen
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",                	// Progress icon shown on screen
			"true",                                                  						// Condition for the action to be shown
			"true",                                                							// Condition for the action to progress
			{hint "Search started"},                                                       	// Code executed when action starts
			{hint format["Search tick: %1", _this select 4]},                               // Code executed on every progress tick (0-24)
			{hint "Search complete"},                                              			// Code executed on completion
			{hint "Search interrupted"},                                                    // Code executed on interrupted
			[],                                                                            	// Arguments passed to the scripts as _this select 3
			12,                                                                            	// Action duration [s]
			0,                                                                             	// Priority
			true,                                                                          	// Remove on completion
			false                                                                          	// Show in unconscious state 
		] call BIS_fnc_holdActionAdd;
	} forEach _this;
};

/*
	description: Function to switch a units animation to the captured animation
	example: this addAction["Capture", {_this call NTECH_fnc_capture}];
*/
NTECH_fnc_capture={
		_unit=_this select 0; 
		_id=_this select 2;
		// remove the action from this unit
		_unit removeAction _id;
		// play the surrender animation
		_unit playmove "AmovPercMstpSnonWnonDnon_AmovPercMstpSsurWnonDnon";
		_unit playmove "ApanPercMstpSnonWnonDnon_ApanPknlMstpSnonWnonDnon";
		_unit playmove "ApanPknlMstpSnonWnonDnon_ApanPpneMstpSnonWnonDnon";
		_unit playmove "ApanPpneMstpSnonWnonDnon_G01";
};

/*
	description: Arm group, by default 3 magazines and 2 first aid kits are added
	arguments:
		- _grp - group to arm
		- _weap - Array of weapons and magazines to choose from, example ["hgun_Pistol_01_F", "10Rnd_9x21_Mag"]
*/
NTECH_fnc_armgroup={
	_grp= _this select 0;
	_weap = _this select 1;

	hint format["Group: %1\nWeap: %2", _grp, _weap];
	// Loop through each unit and add a weapon 
	{
		_weapon = selectRandom _weap;
		_x addMagazine (_weapon select 1);
		_x addWeapon (_weapon select 0);
		_x addMagazine (_weapon select 1);
		_x addMagazine (_weapon select 1);
		_x additem "FirstAidKit";
		_x additem "FirstAidKit";
	} forEach units _grp;

};

/*
	description: Function to change and arm group from random selection
	arguments: 
		- CivArray: Array of civilian groups
		- SynArray: Array of syndikate groups
		- GrpAmount: Number of groups to switch
	returns:
		- Amount of civilians left?
		- Amount of civilians switched?
*/
NTECH_fnc_switchsides={
	// Parse the arguments
	_CivArray=(_this select 0);
	_SynArray=(_this select 1);
	_GrpAmount=(_this select 2);

	//hint format["Civ: %1\nSyn: %2\nGrpAmount: %3", _CivArray, _SynArray, _GrpAmount];
	// Numbers for return
	_numberCiv=0;
	_numberSyn=0;

	// run the loop _GrpAmount times
	_a=0;
	while {
		_a = _a+1;
		_a <= _GrpAmount;
	}
	do {
		// choose a group at random
		_randomGrp = selectRandom _CivArray;
		// remove the group from civilian array
		_CivArray deleteAt (_CivArray find _randomGrp);
	//	hint format["Civ: %1\nGrp: %2", _CivArray, _randomGrp];
		//assign weapons
		[_randomGrp, SynWeapons] call NTECH_fnc_armgroup;
		//Loop through the units and attach them to a random _SynArray group
		{
			[_x] joinSilent (selectRandom _SynArray);
			_numberSyn = _numberSyn + 1;
		} forEach units _randomGrp;

	};

	// Loop and count units in _CivArray and _SynArray
	{
		_numberCiv = _numberCiv + (count units _x);
	} forEach _CivArray;

	// Return
	hint format["Civilians: %1\nSyndikate: %2", _numberCiv, _numberSyn];
	[_numberCiv, _numberSyn];
};

/* 
	MAIN
*/

/* /// OLD \\\ */

//Create civilian groups
civGrp1 = createGroup civilian;

// Remove weapons from groups
{removeAllWeapons _x;} forEach units synGrp1;

//Add groups to civilian groups, aka faction change
{[_x] joinSilent civGrp1;} forEach units synGrp1;

/*
 Choose a group
*/
synGrp = selectRandom [civGrp1];

// Add search function to vehicles
Vehicles_1 call NTECH_fnc_searchvehicle;

/*{
	_weapon = selectRandom [
							["hgun_Pistol_01_F", "10Rnd_9x21_Mag"],
							["hgun_Rook40_F", "16Rnd_9x21_Mag"],
							["SMG_05_F", "30Rnd_9x21_Mag_SMG_02"]
						];
	// add the weapon
	_x addWeapon (_weapon select 0);

	// add magazines
	_x additem (_weapon select 1);
	_x additem (_weapon select 1);
	_x additem (_weapon select 1);

	// add first aid kits
	_x additem "FirstAidKit";
	_x additem "FirstAidKit";

} forEach units synGrp;
*/
// {moveOut _x} forEach crew VehIntroSyn;
// {_x setCaptive true; _x playMove "AmovPercMstpSnonWnonDnon_AmovPercMstpSsurWnonDnon"; _x disableAI "ANIM";} forEach units GrpIntroCiv2;
// {_x disableAI "AUTOTARGET"; _x disableAI "AUTOCOMBAT"; _x disableAI "TARGET";} forEach [UnitIntroBlu_1_1, UnitIntroBlu_1_2];
// {_x doWatch UnitCivIntro_2_1; _x doTarget UnitCivIntro_2_1; _wp = group _x addWaypoint [position UnitCivIntro_2_1, 0]} forEach [UnitIntroBlu_1_1]; 
// {_x doWatch UnitCivIntro_2_1; _x doTarget UnitCivIntro_2_2; _wp = group _x addWaypoint [position UnitCivIntro_2_2, 0]} forEach [UnitIntroBlu_1_2]; 
