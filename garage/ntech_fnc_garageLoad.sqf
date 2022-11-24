/*
	NTech Garage save

	Description:
	Arguments:
		0 - Mode - one of: init, update, load
		1 - Position
		2 - Radius
*/
params["_mode", "_pos", "_rad"];
private["_vehicles"];
private _idd=4110;
private _idc_box=2100;
private _idc_btn=1600;

switch (_mode) do { 
	case "init" : {
		// check if are can spawn vehicle
		_pos=_pos findEmptyPosition [0, _rad];
		if (count _pos == 0) exitWith {
			systemChat "NTGarage: Error! No Space found for spawning";
		};
		// Setup Dialog
		createDialog "ntech_garageload";
		waitUntil {dialog};
		// Fill vehicle box
		for "_i" from 0 to (count NTECH_GARAGE)-2 step 2 do {
		  _indx=lbAdd [_idc_box, getText (configFile >> "CfgVehicles" >> NTECH_GARAGE select _i >> "DisplayName")];
		  lbSetValue [_idc_box, _indx, _i];
		};
		NTECH_GARAGE_SELECTED=objNull;
		NTECH_GARAGE_LIST=_pos;
		NTECH_GARAGE_INDEX=-1;
		lbSetCurSel [_idc_box, 0];
		// Initialize camera
		// Cam Options
		// 0 - _centercmd - Code to execute to receive position
		// 1 - _condition - Code to execute as condition: {}
		// 2 - _args: array - Arguments to send to center and condition 
		// *3 - _limit: array - Limit of altitude and distance [_alt, _dist];
		// *4 - _args: array - Optional: initial values: [_rotation,_altitude,_distance]
		[{if (isNull NTECH_GARAGE_SELECTED) then {getPos player} else {getPos NTECH_GARAGE_SELECTED} }, {dialog}, []] spawn ntech_fnc_orbitCamera
	};
	/* UPDATE */
	case "update" : { 
		if (count NTECH_GARAGE == 0) exitWith {systemchat "NTGarage: Garage is Empty"};
		_indx=lbValue [_idc_box, _this select 1];
		NTECH_GARAGE_INDEX=_indx;
		_cur=NTECH_GARAGE select _indx;
		_loadout=NTECH_GARAGE select (_indx+1);
		_pos=NTECH_GARAGE_LIST findEmptyPosition [0, 20, _cur];
		if (count _pos == 0) exitWith {systemChat "NTGarage: No space to spawn!"};
		// NTECH_GARAGE_LIST=_pos;
		if (NTECH_GARAGE_SELECTED != objNull) then {
			deleteVehicle NTECH_GARAGE_SELECTED;
		};
		NTECH_GARAGE_SELECTED=_cur createVehicle _pos;
		[NTECH_GARAGE_SELECTED, _loadout] call ntech_fnc_vehicleLoad;
	}; 
	/* UPDATE */
	case "load" : {
		NTECH_GARAGE_SELECTED=objNull;
		if (count NTECH_GARAGE > 0) then {
			// Delete twice the same to delete index + 1
			NTECH_GARAGE deleteAt NTECH_GARAGE_INDEX;
			NTECH_GARAGE deleteAt NTECH_GARAGE_INDEX;
		};
		closeDialog 0;
	};
};
