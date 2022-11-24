/*
	NTech Garage Drop
*/
params["_mode", "_pos"];
private["_veh", "_indx"];
private _idc_box=1500;

switch (_mode) do { 
	case "init" : {
		createDialog "ntech_garagedrop";
		waitUntil {dialog};
		for "_i" from 0 to (count NTECH_GARAGE)-2 step 2 do {
			_indx=lbAdd [_idc_box, getText (configFile >> "CfgVehicles" >> NTECH_GARAGE select _i >> "DisplayName")];
			lbSetValue [_idc_box, _indx, _i];
		};
	}; 
	case "drop": {
		_cur=lbCurSel _idc_box;
		_cur=lbValue [_idc_box, _cur];
		_pos=_pos findEmptyPosition[0,1000,(NTECH_GARAGE select _cur)];
		if (count _pos == 0) exitWith {systemChat "NTGarage Drop Error: No Space to spawn found"};
		_pos=_pos vectorAdd [0,0,200];
		_veh=(NTECH_GARAGE select _cur) createVehicle _pos;
		_veh setPosATL _pos;
		[_veh, (NTECH_GARAGE select _cur+1)] call ntech_fnc_vehicleLoad;
		[objnull, _veh] call BIS_fnc_curatorobjectedited;
		NTECH_GARAGE deleteAt _cur;
		NTECH_GARAGE deleteAt _cur;
	}; 
};

