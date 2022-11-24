/*
	NTECH Garage Storage script

	Summary: Opens up configuration of selected vehicle
	Description: Provided an existing vehicle, the script will collect
				information regarding the available textures and modifications
				and presents a UI allowing to select the texture + modifications
	Parameters: 
	0 - _mechanic - Object to load/store from
*/
/*
	STATIC
*/
private _idd_ntech_garage=4110;
private _idc_ntech_garage_listvehicle_bg=4111;
private _idc_ntech_garage_description_bg=4112;
private _idc_ntech_garage_listtextures_bg=4113;
private _idc_ntech_garage_listmods_bg=4114;
private _idc_ntech_garage_listvehicle=4115;
private _idc_ntech_garage_listtextures=4116;
private _idc_ntech_garage_listmods=4117;
private _idc_ntech_garage_description=4118;
private _idc_ntech_garage_button_left=4119;
private _idc_ntech_garage_button_right=4120;
/*
	VARIABLES
*/
private _mechanic=_this;
private _bays=_mechanic getVariable["ntech_garage_bays", [[],[],[]] ]; // [ ["config", ["BIS_fnc_getVehicleCustomization - VISUAL"], ["BIS_fnc_getVehicleCustomization - MODS"], [Inventory], [Fuel], [Ammunition], [Cargo Fuel, Cargo Ammo, Repair Cargo] ]
private _mode=_mechanic getVariable["ntech_garage_mode", true ]; // Boolean mode of operation: Single Spawn (true)/Multi Spawn
private _bay_pos=_mechanic getVariable["ntech_garage_bay_pos", (getPosATL player) ]; // Either array of positions or single position argument depending on mode
private _allowed=_mechanic getVariable["ntech_garage_allowed", ["Car"] ]; // Vehicle types  allowed to be stored
private _bis_save=_mechanic getVariable["ntech_garage_bis_save", [] ]; // Place to save BIS variables to
private _ui_list=[];
private _currentVeh=objNull;
/*
	FUNCTIONS
*/
// PreProcess and Compile file to function 
private _save_vehicle=compile preprocessFileLineNumbers "ntech\ntech_fnc_garage_save.sqf";
private _load_vehicle=compile preprocessFileLineNumbers "ntech\ntech_fnc_garage_load.sqf";
/*
	summary: Creates a preview of the vehicle with textures/mods and damage
	params:  0 - position - position where to spawn the vehicle
			 1 - int - precision e.g. how far away to look for a suitable place
			 2 - config - Vehicle config to load in format ["config", "texture", [mods], [hitpoints]]
*/
private _preview_vehicle={
	private _position=_this select 0;
	private _precision=_this select 1;
	private _config=_this select 2;
	private _vehcfg=_config select 0;
	private _return=objNull;
	_position=_position findEmptyPosition [0,_precision,_vehcfg];
	if (count _position > 0) then {
		_return=_vehcfg createVehicle  _position;
		if (_return != objNull) then {
			// Load the visual config
			[_return,[(_config select 1),1],(_config select 2),nil] call BIS_fnc_initVehicle;
			// Load the damage/hitpoints
			{
				_return setHitIndex [_forEachIndex, _x, false];
			} forEach (_config select 3);
		};
	};
	_return;
};
/*
	description: gets the DisplayNames of vehicle types/classes
	params: 0 - Array - Array of Vehicle Configs
	return: Array of [["name","config"],["name","config"]]
*/
private _get_config_names={
	private _vehicle_config_data=[];
	{
		if (_x isEqualType "string") then {
			_vehicle_config_data pushBack ([getText (configfile >> "CfgVehicles" >> _x >> "DisplayName"), _x]);
		} else {
			_vehicle_config_data pushBack ["<EMPTY>", "<EMPTY>"];
		};
	} foreach _this;
	_vehicle_config_data;
};

private _set_ui_list={
	private _bays=_this;
	private _data=[];
	{
		if (count _x > 0) then {
		  _data pushBack (_x select 0);
		} else {
			_data pushBack objNull;
		};
	} forEach _bays;
	_data=_data call _get_config_names;
	// set list
	[_idc_ntech_garage_listvehicle, _data] call ntech_gui_setList;
};
/*
	MAIN FUNCTION
*/
// Initialize UI
createDialog "ntech_garage";
// Get item names for list
_bays call _set_ui_list;
/*
	Orbital Camera Setup
*/
waitUntil {dialog};
private _camera_condition={dialog};
[_bay_pos, _camera_condition, [180, 5, 5]] execVM "ntech-gui\ntech_gui_camera_orbitalctrl.sqf";
/*
	Event Handlers
*/
((findDisplay _idd_ntech_garage) displayCtrl _idc_ntech_garage_button_left) ctrlAddEventHandler ["MouseButtonClick", {missionNamespace setVariable ["ntech_garage_storage_save",true]} ];
ctrlSetText [_idc_ntech_garage_button_left, "Save Vehicle"];
ctrlEnable [_idc_ntech_garage_button_left,false];
((findDisplay _idd_ntech_garage) displayCtrl _idc_ntech_garage_button_right) ctrlAddEventHandler ["MouseButtonClick", {missionNamespace setVariable ["ntech_garage_storage_load",true]} ];
ctrlSetText [_idc_ntech_garage_button_right, "Load Vehicle"];
// ctrlShow [_idc_ntech_garage_button_left, false]; 
lbSetCurSel [_idc_ntech_garage_listvehicle, 0];
// If we are operating in Multi Bay mode
if !(_mode) then {
	//TODO: Create the vehicles from Bays?
	true;
};
// MAIN LOOP
private _new_selection=[];
private _selected_id=0;
private _selected="";
while {dialog} do {
	/*
		VEHICLE PREVIEW
	*/
	// check if selection changed
	_new_selection=[_idc_ntech_garage_listvehicle] call ntech_gui_getCurrentSelection;
	if ((_new_selection select 2) != _selected_id) then {
		_selected=_new_selection select 1;
		_selected_id=_new_selection select 2;
		deleteVehicle _currentVeh;
		sleep 0.1;
		// if Selected item is empty
		if (_selected=="<EMPTY>") then {
			// Enable Save, Disable Load
			ctrlEnable [_idc_ntech_garage_button_left,true];
			ctrlEnable [_idc_ntech_garage_button_right,false];
		} else {
			// Enable Load, Disable Save
			ctrlEnable [_idc_ntech_garage_button_left,false];
			ctrlEnable [_idc_ntech_garage_button_right,true];
			// show preview
			_currentVeh=[_bay_pos, 1, _bays select _selected_id, _mechanic] call _preview_vehicle;
		};
	};
	/*
		VEHICLE SAVE
	*/
	if (missionNamespace getVariable ["ntech_garage_storage_save",false]) then {
		missionNamespace setVariable ["ntech_garage_storage_save", false];
		_saveVeh=nearestObjects [_bay_pos, _allowed, 5]; // _bay_pos nearObjects [_allowed, 3];
		if (count _saveVeh > 0) then {
			if ((count _saveVeh) == 1) then {
				_saveVeh=_saveVeh select 0;
				_saveData=_saveVeh call _save_vehicle;
				// check if success
				if (count _saveData > 0) then {
					_bays set [_selected_id, _saveData];
					deleteVehicle _saveVeh; 
				};
				_bays call _set_ui_list;
			} else {
				//error message > 1
				hint parseText format["There are multiple vehicles in range. Vehicles found: %1", count _saveVeh];
			};
		} else {
			//error message 0
			 hint parseText format["There are no vehicles in range. Vehicles found: %1", count _saveVeh];
		};
	};
	/*
		VEHICLE LOAD
	*/
	if (missionNamespace getVariable ["ntech_garage_storage_load",false]) then {
		[_currentVeh, (_bays select _selected_id)] call _load_vehicle;
		_bays set [_selected_id, []];
		closeDialog 0;
	};
	sleep 0.5;
};

// Cleanup
if !(missionNamespace getVariable ["ntech_garage_storage_load", false]) then {
	// If we are operating in Single Bay mode clear the showcase model
	if (_mode) then {
		if (_currentVeh != objNull) then {
			deleteVehicle _currentVeh;		
		}
	};
};
// hint format["desc: %1", ((_bays select 2) select 4) select 3];
// sleep 10;
// hint "";
missionNamespace setVariable ["ntech_garage_storage_save", false];
missionNamespace setVariable ["ntech_garage_storage_load", false];
//nearestObjects [(marker1 modelToWorld [0,0,0]), ["Car"], 5]