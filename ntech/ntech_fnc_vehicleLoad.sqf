/*
	summary: Loads the vehicle from data gathered with ntech_fnc_garage_save
	params: 0 - Vehicle - The vehicle to customize
			1 - Array - Configuration array from save function
				[ ["config", "Texture", [Visual Customizations], [Hitpoints], [Inventory], [Fuel], [Ammunition], [Cargo Fuel, Cargo Ammo, Repair Cargo] ]
	return: None
*/
private _vehicle=_this select 0;
private _config=_this select 1;
// Set the vehicle textures and mods
[_vehicle,[(_config select 1),1],(_config select 2),nil] call BIS_fnc_initVehicle;
// Load the damage/hitpoints
{
	_vehicle setHitIndex [_forEachIndex, _x, false];
} forEach (_config select 3);
// Clear the vehicle Inventory
clearMagazineCargo _vehicle;
clearWeaponCargo _vehicle;
clearItemCargo _vehicle;
clearBackpackCargo _vehicle;
// Inventory - weapon, item, magazine
// Weapons
{
	if ((count _x) > 0) then {
		_vehicle addWeaponWithAttachmentsCargo [_x,1];
	};
} forEach ((_config select 4) select 0); 
// Items
// [[name],[count]]
{
	_vehicle addItemCargo [_x, (((_config select 4) select 1) select 1) select _forEachIndex];
} foreach (((_config select 4) select 1) select 0);
// Magazines
{
	_vehicle addMagazineAmmoCargo [(_x select 0),1,(_x select 1)];
} forEach ((_config select 4) select 2); 
// BackPacks
// [[name],[count]]
{
	_vehicle addBackpackCargo [_x,(((_config select 4) select 3) select 1) select _forEachIndex];
} forEach (((_config select 4) select 3) select 0); 
// Fuel
_vehicle setFuel (_config select 5);
// Ammunition
// Clear Ammunition from vehicle
{
	_vehicle removeMagazinesTurret[_x select 0, _x select 1];
} forEach (magazinesAllTurrets _vehicle);
// Load ammunition
{
	_vehicle addMagazineTurret [_x select 0,_x select 1, _x select 2];
} foreach (_config select 6);
// Special Cargo
_vehicle setFuelCargo((_config select 7) select 0);
_vehicle setAmmoCargo((_config select 7) select 1);
_vehicle setRepairCargo((_config select 7) select 2);