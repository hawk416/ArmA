/*
	NTech Garage save

	Description:
	Arguments:
		0 - Mode - one of: Init, Update, Save
		0 - Position
		1 - Radius
*/
params["_mode", "_pos", "_rad"];
private["_vehicles"];
private _idd=4110;
private _idc_box=2100;
private _idc_btn=1600;

switch (_mode) do { 
	case "init" : {
		// Collect all empty vehicles in area
		NTECH_GARAGE_LIST=[];
		{
			if ( (_x isKindOf "Car") or (_x isKindOf "Tank") or (_x isKindOf "Ship") or (_x isKindOf "Air") ) then {
				if ({alive (_x select 0)} count (fullCrew _x) == 0) then {
					systemChat format["Empty vehicle: %1", _x];
					NTECH_GARAGE_LIST append [_x];
				};
			};
		} forEach (_pos nearObjects _rad);
		// Setup Dialog
		createDialog "ntech_garagesave";
		waitUntil {dialog};
		// Fill vehicle box
		{
		  _indx=lbAdd [_idc_box, getText (configFile >> "CfgVehicles" >> typeOf _x >> "DisplayName")];
		  lbSetValue [_idc_box, _indx, _indx];
		} forEach NTECH_GARAGE_LIST;
		NTECH_GARAGE_SELECTED=0;
		lbSetCurSel [_idc_box, 0];
		// Initialize camera
		// Cam Options
		// 0 - _centercmd - Code to execute to receive position
		// 1 - _condition - Code to execute as condition: {}
		// 2 - _args: array - Arguments to send to center and condition 
		// *3 - _limit: array - Limit of altitude and distance [_alt, _dist];
		// *4 - _args: array - Optional: initial values: [_rotation,_altitude,_distance]
		[{if (count NTECH_GARAGE_LIST > 0) then { getPos (NTECH_GARAGE_LIST select NTECH_GARAGE_SELECTED)} else {getPos player} }, {dialog}, []] spawn ntech_fnc_orbitCamera
	};
	/* UPDATE */
	case "update" : { NTECH_GARAGE_SELECTED=_this select 1 }; 
	/* UPDATE */
	case "save" : {
		_cur=NTECH_GARAGE_LIST select NTECH_GARAGE_SELECTED;
		NTECH_GARAGE append [typeOf _cur, _cur call ntech_fnc_vehicleSave];
		NTECH_GARAGE_LIST deleteAt NTECH_GARAGE_SELECTED;
		deleteVehicle _cur;
		lbDelete[_idc_box, NTECH_GARAGE_SELECTED];
		lbSetCurSel[_idc_box,0]
	}; 
};
