/*
	name: initHangarMaster.sqf 
	description: Initiates the hangar master
	arguments: 	0 - unit - unit - The hangar master unit
				1 - array - list_pads - Array of pads, positions where the vehicle is created
				2 - array - list_paddirections - Array of directions for how the vehicle is to be orientated on the pad
				3 - array - list_hangars - Array of Hangars, positions where to store vehicles
				4 - array - list_hangardirection - List of directions the Vehicle should face in the hangar
				5 - array - list_hangarDisplayName - List of Display names for hangars
				6 - array - list_filters - Entity filter: Air, Car, Tank, Man. Special cases: All - will skip filter.
				7 - bool - check_owner - Check for vehicle ownership
				8 - int - search_range - The search range to look for vehicles around the position
	note: The lists must match in size, as they will be cross-referenced for storing/spawning
*/

private ["_unit"];

_unit=_this select 0;

// sanity check - check if array pads and hangars is the same length
if ( ((count (_this select 1)) == (count (_this select 2))) && ((count (_this select 3)) == (count (_this select 4))) && ((count (_this select 1)) == (count (_this select 3))) ) then {
	// set the base variables
	_unit setVariable ["nutils_base_hangar_hangarMaster", true];
	_unit setVariable ["nutils_base_hangar_list_hangars", _this select 1];
	_unit setVariable ["nutils_base_hangar_list_paddirections", _this select 2];
	_unit setVariable ["nutils_base_hangar_list_pads", _this select 3];
	_unit setVariable ["nutils_base_hangar_list_hangardirections", _this select 4];
	_unit setVariable ["nutils_base_hangar_list_hangarDisplayName", _this select 5];
	_unit setVariable ["nutils_base_hangar_list_filter", _this select 6];
	_unit setVariable ["nutils_base_hangar_check_owner", _this select 7];
	_unit setVariable ["nutils_base_hangar_search_range", _this select 8];

	// initialize/zero the remaining arrays
	_unit setVariable ["nutils_base_hangar_hangarUsed", []];
	_unit setVariable ["nutils_base_hangar_vehicleCfgName", []];
	_unit setVariable ["nutils_base_hangar_vehicleDisplayName", []];
	_unit setVariable ["nutils_base_hangar_vehicleConfig", []];
	_unit setVariable ["nutils_base_hangar_vehicleCondition", []];
	_unit setVariable ["nutils_base_hangar_vehicleInventorySpecial", []];
	_unit setVariable ["nutils_base_hangar_vehicleInventory", []];
	_unit setVariable ["nutils_base_hangar_vehicleFuel", []];

	// fill the remaining arrays
	{
		_unit setVariable ["nutils_base_hangar_hangarUsed", (_unit getVariable "nutils_base_hangar_hangarUsed") + [false]];
		_unit setVariable ["nutils_base_hangar_vehicleCfgName", (_unit getVariable "nutils_base_hangar_vehicleCfgName") + ["false"]];
		_unit setVariable ["nutils_base_hangar_vehicleDisplayName", (_unit getVariable "nutils_base_hangar_vehicleDisplayName") + ["false"]];
		_unit setVariable ["nutils_base_hangar_vehicleConfig", (_unit getVariable "nutils_base_hangar_vehicleConfig") + [false]]; // TODO: Add special statuses
		_unit setVariable ["nutils_base_hangar_vehicleCondition", (_unit getVariable "nutils_base_hangar_vehicleCondition") + [false]];
		_unit setVariable ["nutils_base_hangar_vehicleInventorySpecial", (_unit getVariable "nutils_base_hangar_vehicleInventorySpecial") + [false]];
		_unit setVariable ["nutils_base_hangar_vehicleInventory", (_unit getVariable "nutils_base_hangar_vehicleInventory") + [false]];
		_unit setVariable ["nutils_base_hangar_vehicleFuel", (_unit getVariable "nutils_base_hangar_vehicleFuel") + [false]];
	} forEach (_this select 1);
	
	["Created: %1 hangars", count (_unit getVariable "nutils_base_hangar_vehicleFuel")] spawn nutils_hint;
	_unit addAction ["Hangar", "nutils-base\hangar\initdialog.sqf"];

} else {
	["Error! Could not create Hangar Master"] spawn nutils_hint;
};
