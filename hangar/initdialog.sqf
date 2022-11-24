/*
	name: initDialog.sqf for Base Hangar module
	description: This script is called as the hangar action
*/

private ["_unit", "_target", "_action""_nutils_base_hangar_hangarmaster", "_nutils_base_hangar_hangarmaster_frame", "_nutils_base_hangar_hangarmaster_background", "_nutils_base_hangar_hangarmaster_header", "_nutils_base_hangar_hangarmaster_header_close", "_nutils_base_hangar_hangarmaster_hangar_text", "_nutils_base_hangar_hangarmaster_hangar", "_nutils_base_hangar_hangarmaster_picture", "_nutils_base_hangar_hangarmaster_inventory", "_nutils_base_hangar_hangarmaster_inventory_text", "_nutils_base_hangar_hangarmaster_used_text", "_nutils_base_hangar_hangarmaster_status", "_nutils_base_hangar_hangarmaster_vehicle_fuel_text", "_nutils_base_hangar_hangarmaster_vehicle_fuel", "_nutils_base_hangar_hangarmaster_hangar_vehicle_text", "_nutils_base_hangar_hangarmaster_vehicle_damage_text", "_nutils_base_hangar_hangarmaster_hangar_vehicle", "_nutils_base_hangar_hangarmaster_vehicle_damage", "_nutils_base_hangar_hangarmaster_description", "_nutils_base_hangar_hangarmaster_prepare", "_nutils_base_hangar_hangarmaster_store", "_nutils_base_hangar_hangarmaster_vehicle_status"];

_nutils_base_hangar_hangarmaster=4310;
_nutils_base_hangar_hangarmaster_frame=4311;
_nutils_base_hangar_hangarmaster_background=4312;
_nutils_base_hangar_hangarmaster_header=4313;
_nutils_base_hangar_hangarmaster_header_close=4314;
_nutils_base_hangar_hangarmaster_hangar_text=4315;
_nutils_base_hangar_hangarmaster_hangar=4316;
_nutils_base_hangar_hangarmaster_picture=4317;
_nutils_base_hangar_hangarmaster_inventory=4318;
_nutils_base_hangar_hangarmaster_inventory_text=4319;
_nutils_base_hangar_hangarmaster_used_text=4320;
_nutils_base_hangar_hangarmaster_status=4321;
_nutils_base_hangar_hangarmaster_vehicle_fuel_text=4322;
_nutils_base_hangar_hangarmaster_vehicle_fuel=4323;
_nutils_base_hangar_hangarmaster_hangar_vehicle_text=4324;
_nutils_base_hangar_hangarmaster_vehicle_damage_text=4325;
_nutils_base_hangar_hangarmaster_hangar_vehicle=4326;
_nutils_base_hangar_hangarmaster_vehicle_damage=4327;
_nutils_base_hangar_hangarmaster_description=4328;
_nutils_base_hangar_hangarmaster_prepare=4329;
_nutils_base_hangar_hangarmaster_store=4330;
_nutils_base_hangar_hangarmaster_vehicle_status=4331;

_unit = _this select 0;
// _target = _this select 1;
_target="player"; // TODO: Figure out why passing on the target doesn't work.
_action = _this select 2;

//create the dialog and wait for it to fully load.
createDialog "nutils_base_hangar_hangarmaster";
waitUntil {(! isNull (findDisplay _nutils_base_hangar_hangarmaster))};

//set header
ctrlSetText [_nutils_base_hangar_hangarmaster_header, format["%1", (name _unit)]];

//set onButtonClick handlers
_display=findDisplay _nutils_base_hangar_hangarmaster;
_combobox=(_display displayCtrl _nutils_base_hangar_hangarmaster_hangar);
_combobox ctrlSetEventHandler ["LBSelChanged", format["[%1] execVM 'nutils-base\hangar\handler_itemchanged.sqf'", _unit]];
(_display displayCtrl _nutils_base_hangar_hangarmaster_store) ctrlSetEventHandler ["MouseButtonClick", format["[%1, %2, %3, %4] execVM 'nutils-base\hangar\handler_store.sqf'", _unit, _target, _nutils_base_hangar_hangarmaster_hangar, false]];
(_display displayCtrl _nutils_base_hangar_hangarmaster_prepare) ctrlSetEventHandler ["MouseButtonClick", format["[%1, %2, %3, %4] execVM 'nutils-base\hangar\handler_prep.sqf'", _unit, _target, _nutils_base_hangar_hangarmaster_hangar, false]];

_i_tmp=0;
//fill the list
{
	_index = _combobox lbAdd _x;
	_combobox lbSetData [_index, format["%1",_i_tmp]];
	_i_tmp=_i_tmp + 1;
} foreach (_unit getVariable "nutils_base_hangar_list_hangarDisplayName");

// //set first element
_combobox lbSetCurSel 0;

//set exit handlers
//wait for the user to close the dialog
waitUntil {isNull (findDisplay _nutils_base_hangar_hangarmaster)};
//cleanup
if (NUTILS_DEBUG) then {
	["DEBUG: Dialog closed"] spawn nutils_hint;
};