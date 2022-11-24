/*
	NTECH Vehicle Customization script
	
	Summary: Opens up configuration of selected vehicle
	Description: Provided an existing vehicle, the script will collect
				information regarding the available textures and modifications
				and presents a UI allowing to select the texture + modifications
	Parameters: 
	0 - _vehicle - Vehicle to customize
*/
/*
	TODO:
		- Add check for vehicle existance
*/
/*
	IDC's
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
	Variables
*/
private _vehicle=_this select 0;
private _data=[];
/*
	Main Function
*/
// Collect information
private _vehicle_cfg=typeOf _vehicle;
//// Collect Textures
private _vehicle_textures="true" configClasses (configfile >> "CfgVehicles" >> _vehicle_cfg >> "TextureSources");
{
	_vehicle_textures set [_forEachIndex, [(getText (_x >> "DisplayName")), (configName _x)]];
} forEach _vehicle_textures;
//// Collect Modifications
private _vehicle_mods=[_vehicle] call BIS_fnc_getVehicleCustomization;
private _current_texture=(_vehicle_mods select 0) select 0;
// find the current texture in vehicle textures
{
	if (_current_texture isEqualTo (_x select 1)) then {
		_current_texture=_forEachIndex;
	};
} forEach _vehicle_textures;
_vehicle_mods=(_vehicle_mods select 1);
private _current_mods=[];
private _vehicle_mods_data=[];
for "_i" from 0 to (count _vehicle_mods) -1 step 2 do {
	_vehicle_mods_data pushBack [(getText (configfile >> "CfgVehicles" >> _vehicle_cfg >> "AnimationSources" >> _vehicle_mods select _i >> "DisplayName")),(_vehicle_mods select _i)];
	_current_mods pushBack (_vehicle_mods select (_i +1));
};
/*
	UI Setup
*/
// Open the garage UI
createDialog "ntech_garage";
// Hide the nonfunctional stuff
ctrlEnable [_idc_ntech_garage_listvehicle,false];
ctrlEnable [_idc_ntech_garage_description,false];
ctrlEnable [_idc_ntech_garage_button_left,false];
ctrlShow [_idc_ntech_garage_listvehicle,false];
ctrlShow [_idc_ntech_garage_description,false];
ctrlShow [_idc_ntech_garage_button_left,false];
ctrlShow [_idc_ntech_garage_listvehicle_bg,false];
ctrlShow [_idc_ntech_garage_description_bg,false];
ctrlSetText [_idc_ntech_garage_button_right, "Done"];
((findDisplay _idd_ntech_garage) displayCtrl _idc_ntech_garage_button_right) ctrlAddEventHandler["MouseButtonClick",{closeDialog 0}];
/*
	Orbital Camera Setup
*/
waitUntil {dialog};
private _camera_condition={dialog};
[{getPos _vehicle}, _camera_condition, [], [100,100,[180, 5, 5]] execVM "ntech-gui\ntech_gui_camera_orbitalctrl.sqf";
/*
	Garage UI Setup
*/
//// Setup lists
[_idc_ntech_garage_listtextures, _vehicle_textures] call ntech_gui_setList;
[_idc_ntech_garage_listmods, _vehicle_mods_data] call ntech_gui_setList;
// Initialize the selection with current texture
lbSetCurSel [_idc_ntech_garage_listtextures, _current_texture];
// Initialize the selection with current mods
private _displayctrl_mods=((findDisplay _idd_ntech_garage) displayCtrl _idc_ntech_garage_listmods);
{
	if (_x == 0) then {
		_displayctrl_mods lbSetSelected [_forEachIndex,false];
	} else {
		_displayctrl_mods lbSetSelected [_forEachIndex,true];
	}
} foreach _current_mods;
/*
	Main loop
*/
// While dialog is open
while {dialog} do {
	// Update the vehicle config
	_current_texture=[_idc_ntech_garage_listtextures] call ntech_gui_getCurrentSelection;
	_current_mods=lbSelection _displayctrl_mods;
	_data=[];
	{	
		_data pushBack (_x select 1);
		if (_forEachIndex in _current_mods) then {
			_data pushBack 1;			
		} else {
			_data pushBack 0;
		};
	} foreach _vehicle_mods_data;
	[_vehicle,[(_current_texture select 1),1],_data,nil] call BIS_fnc_initVehicle;
	sleep 0.5;
};
