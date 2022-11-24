/*
	NTech Utilities init.sqf

	Description:
		This init script will initialize the utilities functions
*/

/*
	Config Utilities
*/
/*
	1: config
	2: side
	3: string
	4: variations
*/
ntech_config_search = {
	private["_config", "_side", "_string", "_variations", "_return"];
	_return=false;
	// _config=_this select 1;
	// _side=_this select 2;
	// _string=_this select 3;
	// _variations=_this select 4;
	// // get the array
	// _data = ( configfile >> _config ) call BIS_fnc_getCfgDataArray;
	// Hint format["The data: %1", _data];
	Hint format["%1", ( configfile >> "cfgWeapons" ) call BIS_fnc_getCfgDataArray];
};

ntech_config_getDisplayName = {

};

ntech_config_getDescription = {
	private["_config", "_item", "_data", "_description"];
	_config=_this select 0;
	_item=_this select 1;
	_description="";
	switch (toLower _config) do
	{
		case ("cfgvehicles") : {
			// cfgVehicles
			// armor, author, cost, displayName, features (non-display info), fuelCapacity, fuelConsumptionRate, icon, magazines, maxGForce, maximumLoad, maxSpeed, picture, slingLoadMaxCargoMass, slingLoadMinCargoMass, vehicleClass, weapons,
			// fuelCapacity, icon, picture, vehicleClass, transportMaxBackpacks, transportMaxMagazines, transportAmmo,  transportFuel, transportMaxWeapons, transportRepair, transportSoldier, transportVehiclesCount, transportVehiclesMass, weapons, weaponSlots, typicalCargo, cost exits
			_data=[_config, _item, ["author", "displayName", "vehicleClass", "armor", "maxSpeed", "fuelCapacity", "fuelConsumptionRate", "transportSoldier", "transportMaxBackpacks", "transportMaxMagazines"]] call ntech_config_getAttributes;
			_description=format["Author: %1 <br />Name: %2 <br />Class: %3<br />Armor Rating: %4 <br />Maximum speed: %5 km/h<br />Fuel capacity: %6 Consumption rate: %7 <br />Cargo: %8 People, %9 backpacks, %10 magazines<br />",
			_data select 0, _data select 1, _data select 2, _data select 3, _data select 4, _data select 5, _data select 6, _data select 7, _data select 8, _data select 9];
			// "transportAmmo", "magazines", "maxGForce", "maximumLoad",  "picture", "slingLoadMaxCargoMass", "slingLoadMinCargoMass", "weapons",  "transportFuel", "transportMaxWeapons", "transportRepair",  "transportVehiclesCount", "transportVehiclesMass", "weaponSlots", "typicalCargo"

			// Hint format["%1", _description];
		};
		// case ("cfgWeapons")  : {};
	};
	_description;
};

ntech_config_getDescriptionLong = {

};

ntech_config_getAttributes={
	private["_config", "_item", "_attributeList", "_data", "_return"];
	_config=_this select 0;
	_item=_this select 1;
	_attributeList=_this select 2;
	_return=[];
	// Hint format["%1", _attributeList];
	{
		_data = ( configfile >> _config >> _item >> _x ) call BIS_fnc_getCfgData;
		_return = _return + [_data];
	} forEach _attributeList;
	_return;
};