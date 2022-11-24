/*
	NTECH Garage Trader Script
	
	Summary: Opens up trading in vehicle list
	Description: Given a list of vehicle configs and prices,
				Creates and populates a buying UI
	Parameters: 
	0 - _spawn - position - Spawn/Trade point
	1 - _list_vehicles - array - List of vehicles (config)
	2 - _list_prices - array - List of prices (integer)
*/
/*
	TODO:
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
private _spawn=_this select 0;
private _list_vehicles=_this select 1;
private _list_prices=_this select 2;
private _payed=false;
/*
	FUNCTIONS
*/
/*
	function: _get_texture_sources
	params: 0 - config - Vehicle Config
	returns: Array of [["name","config"],["name","config"]]
*/
private _get_texture_sources={
	private _vehicle_textures="true" configClasses (configfile >> "CfgVehicles" >> _this >> "TextureSources");
	private _vehicle_textures_data=[];
	{
		_vehicle_textures_data pushBack ([getText (_x >> "DisplayName"),(configName _x)]);
	} forEach _vehicle_textures;	
	_vehicle_textures_data;
};
/*
	function: _get_mods_sources
	params: 0 - existing vehicle - Vehicle
	returns: Array of [["name","config"],["name","config"]]
*/
private _get_mod_sources={
	private _vehicle_mods=[_this] call BIS_fnc_getVehicleCustomization;
	private _vehicle_cfg=typeOf _this;
	private _vehicle_mods_data=[];
	private ["_vehicle_mod", "_name"];
	for "_i" from 0 to count (_vehicle_mods select 1) -1 step 2 do {
		_vehicle_mod=(_vehicle_mods select 1) select _i;
		_name = getText (configfile >> "CfgVehicles" >> _vehicle_cfg >> "AnimationSources" >> _vehicle_mod >> "DisplayName"); 
		_vehicle_mods_data pushBack ([_name, (_vehicle_mods select 1) select _i]);
	};
	_vehicle_mods_data;
};
/*
	description:
	params: 0 - Array - Array of Vehicle Configs
	return: Array of [["name","config"],["name","config"]]
*/
private _get_config_sources={
	private _vehicle_config_data=[];
	{
		_vehicle_config_data pushBack ([getText (configfile >> "CfgVehicles" >> _x >> "DisplayName"), _x]);
	} foreach _this;
	_vehicle_config_data;
};
/*
	description:
	params: 0 - String - item to search for
			1 - Array - Array to search in
	return: 
*/
private _get_index_of={
	private _item=_this select 0;
	private _array=_this select 1;
	private _return=[];
	for "_i" from 0 to count _array - 1 do {
		if (_item == _array select _i) then {
			_return=_i;
		};
	};
	_return;
};
/*
	MAIN FUNCTION
*/
// Collect config information
private _vehicle_configs=_list_vehicles call _get_config_sources;
// Collect Textures
private _vehicle_textures=(_list_vehicles select 0) call _get_texture_sources;
// initialize first vehicle
private _current_vehicle=(_list_vehicles select 0) createVehicle (getPosATL _spawn);
// Collect Modifications
private _vehicle_mods=_current_vehicle call _get_mod_sources;
/*
	Garage UI Setup
*/
// Open the garage UI
createDialog "ntech_garage";
// Hide the nonfunctional stuff
// ctrlEnable [_idc_ntech_garage_listvehicle,false];
// ctrlEnable [_idc_ntech_garage_description,false];
// ctrlEnable [_idc_ntech_garage_button_left,false];
// ctrlShow [_idc_ntech_garage_listvehicle,false];
// ctrlShow [_idc_ntech_garage_description,false];
// ctrlShow [_idc_ntech_garage_button_left,false];
// ctrlShow [_idc_ntech_garage_listvehicle_bg,false];
// ctrlShow [_idc_ntech_garage_description_bg,false];
// ctrlSetText [_idc_ntech_garage_button_right, "Done"];
//// Setup lists
[_idc_ntech_garage_listvehicle, _vehicle_configs] call ntech_gui_setList;
[_idc_ntech_garage_listtextures, _vehicle_textures] call ntech_gui_setList;
[_idc_ntech_garage_listmods, _vehicle_mods] call ntech_gui_setList;
((findDisplay _idd_ntech_garage) displayCtrl _idc_ntech_garage_button_left) ctrlAddEventHandler ["MouseButtonClick", {missionNamespace setVariable ["ntech_garageTrader_buy",true]} ];
((findDisplay _idd_ntech_garage) displayCtrl _idc_ntech_garage_button_right) ctrlAddEventHandler ["MouseButtonClick", {closeDialog 0} ];
// Setup initial price
ctrlSetText [_idc_ntech_garage_button_left, format["Buy for: %1", _list_prices select 0]];
((findDisplay _idd_ntech_garage) displayCtrl _idc_ntech_garage_description) ctrlSetStructuredText (parseText (["cfgVehicles", _list_vehicles select 0] call ntech_config_getDescription));
// Initialize a selection
lbSetCurSel [_idc_ntech_garage_listvehicle, 0];
lbSetCurSel [_idc_ntech_garage_listtextures, 0];
lbSetCurSel [_idc_ntech_garage_listmods, 0];
/*
	Orbital Camera Setup
*/
waitUntil {dialog};
private _camera_condition={dialog};
[{_args}, _camera_condition, getPos _spawn, [100, 100], [180, 5, 5]] execVM "ntech-gui\ntech_gui_camera_orbitalctrl.sqf";
/*
	Main loop
*/
// While dialog is open
private ["_selection_vehicle","_selection_texture","_selection_mods", "_data","_cfg","_cfgs","_found"];
while {dialog} do {
	// check if current vehicle is same as selected one
	_selection_vehicle=[_idc_ntech_garage_listvehicle] call ntech_gui_getCurrentSelection;
	_selection_vehicle=_selection_vehicle select 1;
	if (_selection_vehicle != typeOf _current_vehicle) then {
		deleteVehicle _current_vehicle;
		sleep 0.1;
		_current_vehicle=(_selection_vehicle) createVehicle  (getPosATL _spawn);
		// Collect Texture
		_vehicle_textures=_selection_vehicle call _get_texture_sources;
		[_idc_ntech_garage_listtextures, _vehicle_textures] call ntech_gui_setList;
		// Collect Modifications
		_vehicle_mods=_current_vehicle call _get_mod_sources;
		[_idc_ntech_garage_listmods, _vehicle_mods] call ntech_gui_setList;
		// Set the buy text
		ctrlSetText [_idc_ntech_garage_button_left, format["Buy for: %1", _list_prices select ([_selection_vehicle, _list_vehicles] call _get_index_of)]];
		((findDisplay _idd_ntech_garage) displayCtrl _idc_ntech_garage_description) ctrlSetStructuredText (parseText (["cfgVehicles", _selection_vehicle] call ntech_config_getDescription));
	};
	// Update the vehicle config
	_selection_texture=[_idc_ntech_garage_listtextures] call ntech_gui_getCurrentSelection;
	_selection_mods=lbSelection ((findDisplay _idd_ntech_garage) displayCtrl _idc_ntech_garage_listmods);
	_data=[];
	for "_i" from 0 to count _vehicle_mods -1 do {
		_cfg=(_vehicle_mods select _i) select 1;
		_found=false;
		_data pushBack _cfg;
		{
  			_cfgs = lbData[_idc_ntech_garage_listmods, _x];
			if ( _cfg isEqualTo _cfgs ) then {
				_found=true;
			};
		} forEach _selection_mods;
		if (_found) then {
			_data pushBack 1;			
		} else {
			_data pushBack 0;
		};	
	};
	[_current_vehicle,[(_selection_texture select 1),1],_data,nil] call BIS_fnc_initVehicle;
	sleep 0.5;
	// Check for intention to pay
	if (missionNamespace getVariable ["ntech_garageTrader_buy", false]) then {
		//buy
		_payed=[player, objNull, _list_prices select ([_selection_vehicle, _list_vehicles] call _get_index_of)] call ntech_trade_transaction;
		if (!_payed) then {
			 hint parseText format["Insuficient credits available <br /> Available: %1 <br /> Required: %2", player getVariable ["credits", 0],_list_prices select ([_selection_vehicle, _list_vehicles] call _get_index_of)];
		} else {
			//close the dialog
			closeDialog 0;
		};
		missionNamespace setVariable ["ntech_garageTrader_buy", false];
	};
};
// check if vehicle has been payed for
if (!_payed) then {
	deleteVehicle _current_vehicle;
};
