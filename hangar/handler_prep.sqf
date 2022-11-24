/*
	name: handler_prep.sqf for Base Hangar module
	description: this handler is called when the prepare button is clicked.
				0 - unit - trader - the trader
				1 - unit - target - the client
				2 - int - index - IDC # OR IND #, depending on whether you're referencing an the combobox IDC or the index number  
				3 - bool - mode_index - True for index false for idc
*/

private ["_unit", "_index", "_client", "_mode_index"];

_unit=_this select 0;
_client=_this select 1;
_index=_this select 2;
_mode_index=_this select 3;

// mode selection
if  (_mode_index) then {
	_index=_this select 2;
} else {
	_index=parseNumber (lbData [_this select 2, (lbCurSel (_this select 2))]);
};

_create_position=(_unit getVariable "nutils_base_hangar_list_pads") select _index;
_create_direction=(_unit getVariable "nutils_base_hangar_list_paddirections") select _index;

_hangar_hangarUsed=(_unit getVariable "nutils_base_hangar_hangarUsed");
_hangar_vehicleCfgName=(_unit getVariable "nutils_base_hangar_vehicleCfgName");
_hangar_vehicleDisplayName=(_unit getVariable "nutils_base_hangar_vehicleDisplayName");
_hangar_vehicleConfig=(_unit getVariable "nutils_base_hangar_vehicleConfig");
_hangar_vehicleCondition=(_unit getVariable "nutils_base_hangar_vehicleCondition");
_hangar_vehicleInventorySpecial=(_unit getVariable "nutils_base_hangar_vehicleInventorySpecial");
_hangar_vehicleInventory=(_unit getVariable "nutils_base_hangar_vehicleInventory");
_hangar_vehicleFuel=(_unit getVariable "nutils_base_hangar_vehicleFuel");

_hangarUsed=_hangar_hangarUsed  select _index;;
_vehicleCfgName=_hangar_vehicleCfgName  select _index;;
_vehicleDisplayName=_hangar_vehicleDisplayName  select _index;;
_vehicleConfig=_hangar_vehicleConfig  select _index;;
_vehicleCondition=_hangar_vehicleCondition  select _index;;
_vehicleInventorySpecial=_hangar_vehicleInventorySpecial  select _index;;
_vehicleInventory=_hangar_vehicleInventory  select _index;;
_vehicleFuel=_hangar_vehicleFuel  select _index;;

// Check if hangar is used
if (! _hangarUsed) exitWith {
	["Hangar is unused!"] spawn nutils_hint;
};

// create the vehicle
["Preparing %1", _vehicleDisplayName] spawn nutils_hint;
_vehicle=[_vehicleCfgName,
_create_position,
_create_direction,
_vehicleConfig,
_vehicleCondition] call nutils_trade_createVehicle;

// Set vehicle fuel
_vehicle setFuel _vehicleFuel;
// Set vehicle special inventory
// {

// } forEach _vehicleInventorySpecial;
// Set vehicle inventory
{
	// if name is 0, then put straight into the vehicle
	["Inventory: %1", _x] spawn nutils_hint;
	if ((_x select 0) == "") then {
		["Invetory2: %1", _x select 1] spawn nutils_hint;
		{
			// _vehicle addItemCargo [_x select 0, _x select 1];
			["Item: %1", _x] spawn nutils_hint;
		} forEach (_x select 1);
		// {
		// 	_vehicle addWeaponCargo [_x select 0, _x select 1];
		// } forEach ((_x select 1) select 0);
		// {
		// 	_vehicle addMagazineCargo [_x select 0, _x select 1];
		// } forEach ((_x select 1) select 0);
	} 
	else{
		// TODO
		hint "TODO";
	};
} forEach _vehicleInventory;