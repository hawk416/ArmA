/*
	name: handler_store.sqf for Base Hangar module
	description: this handler is called when the store button is clicked.
	arguments: 	0 - unit - unit - the trader unit
				1 - unit - target - the client
				2 - int - index - IDC # OR IND #, depending on whether you're referencing an the combobox IDC or the index number  
				3 - bool - mode_index - True for index false for idc
*/

private ["_unit", "_target","_index", "_mode_index", "_search_range", "_search_position", "_search_result", "_tmp_array", "_hangarUsed", "_vehicleCfgName", "_vehicleDisplayName", "_vehicleConfig", "_vehicleStatus", "_vehicleCondition", "_vehicleInventory", "_vehicleFuel"];

_unit=_this select 0;
_target=_this select 1;
_index=_this select 2;
_mode_index=_this select 3;
// mode selection
if  (_mode_index) then {
	_index=_this select 2;
} else {
	_index=parseNumber (lbData [_this select 2, (lbCurSel (_this select 2))]);
};

// Get the position to search in and search the area
_search_position=(_unit getVariable "nutils_base_hangar_list_pads") select _index;
_search_filter=(_unit getVariable "nutils_base_hangar_list_filter") select _index;
_search_range=(_unit getVariable "nutils_base_hangar_search_range");
_search_result=[];

//Get the hangar and vehicle arrays
_hangarUsed=(_unit getVariable "nutils_base_hangar_hangarUsed");
_vehicleCfgName=(_unit getVariable "nutils_base_hangar_vehicleCfgName");
_vehicleDisplayName=(_unit getVariable "nutils_base_hangar_vehicleDisplayName");
_vehicleConfig=(_unit getVariable "nutils_base_hangar_vehicleConfig");
_vehicleCondition=(_unit getVariable "nutils_base_hangar_vehicleCondition");
_hangar_vehicleInventorySpecial=(_unit getVariable "nutils_base_hangar_vehicleInventorySpecial");
_hangar_vehicleInventory=(_unit getVariable "nutils_base_hangar_vehicleInventory");
_vehicleFuel=(_unit getVariable "nutils_base_hangar_vehicleFuel");

if (_hangarUsed select _index) exitWith {
	["Cannot store vehicle, hangar %1 is in use.", (_unit getVariable "nutils_base_hangar_list_hangarDisplayName") select _index] spawn nutils_hint;
};

if (_search_filter == "All") then {
	_search_result=_search_position nearEntities _search_range;
} else {
	_search_result=_search_position nearEntities [_search_filter, _search_range];
};

// Parse the list of objects checking if the owner is the same client
if (_unit getVariable "nutils_base_hangar_check_owner") then {
	_tmp_array=[];
	{
		if ((_x getVariable "nutils_owner" == _target)) then {
			_tmp_array=_tmp_array + [_x];
		};
	} forEach _search_result;
	_search_result=_tmp_array;
};

// If more then one vehicle is found error
if ((count _search_result) > 1) exitWith {
	["There are multiple vehicles near, please move all except the one you want to store"] spawn nutils_hint;
};

// If no vehicle is found error
if ((count _search_result) == 0) exitWith {
	["No suitable vehicles found for storing.\nThis hangar is for: %1 type vehicles", _search_filter] spawn nutils_hint;
};
_search_result=(_search_result select 0); // as there is only one, no point in having it an array

//Move everyone out
if (count (crew _search_result) > 0) then {
	["Moving crew out"] spawn nutils_hint;
	{moveOut _x} forEach (crew _search_result);
	//wait for everyone to get out
	waitUntil {(count (crew _search_result) == 0)};
};
// Lock the vehicle
_search_result setVehicleLock "LOCKED";
_search_result lockCargo true;
// disable damage and simulation
_search_result enableSimulation false;
_search_result allowDamage false;

// Grab the special inventory types, Ammo, Repair, Fuel
_vehicleInventorySpecial=[[getFuelCargo _search_result,
getAmmoCargo _search_result,
getRepairCargo _search_result]];

// Get the vehicle inventory
_vehicleInventory=[_search_result] call nutils_util_getVehicleInventory;
// Set the hangar to used
_hangarUsed set [_index, true];
// Set the vehicle config name, display name and looks
_vehicleCfgName set [_index, format["%1", (typeOf _search_result)]];
_vehicleDisplayName set [_index, (configfile >> "cfgVehicles" >> (typeOf _search_result) >> "displayName") call BIS_fnc_getCfgData];
_vehicleConfig set [_index, ([_search_result] call BIS_fnc_getVehicleCustomization)];
// Set the vehicle condition and fuel
_vehicleCondition set [_index, (getAllHitPointsDamage _search_result)];
_vehicleFuel set [_index, (fuel _search_result)];
// Save the inventory and inventory special in the right spot
_hangar_vehicleInventory set [_index, _vehicleInventory];
_hangar_vehicleInventorySpecial set [_index, _vehicleInventorySpecial];

// Save all values
_unit setVariable ["nutils_base_hangar_hangarUsed", _hangarUsed];
_unit setVariable ["nutils_base_hangar_vehicleCfgName", _vehicleCfgName];
_unit setVariable ["nutils_base_hangar_vehicleDisplayName", _vehicleDisplayName];
_unit setVariable ["nutils_base_hangar_vehicleConfig", _vehicleConfig];
_unit setVariable ["nutils_base_hangar_vehicleFuel", _vehicleFuel];
_unit setVariable ["nutils_base_hangar_vehicleCondition", _vehicleCondition];
_unit setVariable ["nutils_base_hangar_vehicleInventory", _hangar_vehicleInventory];
_unit setVariable ["nutils_base_hangar_vehicleInventorySpecial", _hangar_vehicleInventorySpecial];
// Remove the original
deleteVehicle _search_result;
sleep 1;
// Place the ambient model
_search_result=[_vehicleCfgName select _index,
(_unit getVariable "nutils_base_hangar_list_hangars") select _index,
(_unit getVariable "nutils_base_hangar_list_hangardirections") select _index,
((_unit getVariable "nutils_base_hangar_vehicleConfig") select _index),
((_unit getVariable "nutils_base_hangar_vehicleCondition") select _index)] call nutils_trade_createVehicle;

// Set models special attributes
// Lock the vehicle
_search_result setVehicleLock "LOCKED";
_search_result lockCargo true;
// disable damage and simulation
_search_result enableSimulation false;
_search_result allowDamage false;