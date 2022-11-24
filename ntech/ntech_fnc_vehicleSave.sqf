/*
	summary: Saves vehicle information
	params: 0 - Vehicle - Vehicle to be save
	return: array - data array
	[ "config", "Texture", [Visual Customizations], [Hitpoints], [Inventory], [Fuel], [Ammunition], [Cargo Fuel, Cargo Ammo, Repair Cargo] ]

*/
private _vehicle=_this;
private _data=[];
private ["_wpndata","_mgzdata","_itmdata", "_bckdata", "_tmp"];
// Collect information
_data pushBack (typeOf _vehicle);
_tmp=[_vehicle] call BIS_fnc_getVehicleCustomization;
// Get texture
_data pushBack ((_tmp select 0) select 0);
// Get Visual Customizations
_data pushBack (_tmp select 1);
// Get Hitpoints
_data pushBack ((getAllHitPointsDamage _vehicle) select 2);
// Get Inventory
_wpndata=(weaponsItemsCargo _vehicle);
_mgzdata=magazinesAmmoCargo _vehicle;
_itmdata=getItemCargo _vehicle;
_bckdata=getBackpackCargo _vehicle;
// Collect inventory from containers (vest/uniform/backpack) in vehicle storage
{
	_wpndata append (weaponsItemsCargo (_x select 1));
	_mgzdata append (magazinesAmmoCargo (_x select 1));
	_tmp=getItemCargo (_x select 1);
	_itmdata=[(_itmdata select 0)+(_tmp select 0),(_itmdata select 1)+(_tmp select 1)];
	_tmp=getBackpackCargo (_x select 1);
	_bckdata=[(_bckdata select 0)+(_tmp select 0),(_bckdata select 1)+(_tmp select 1)];
} foreach (everyContainer _vehicle);
// Add the collection of inventory items 
_data pushBack [_wpndata, _itmdata, _mgzdata, _bckdata];
// Get Fuel & Fuel Cargo
_data pushBack (fuel _vehicle);
// Get Ammunition
_data pushBack (magazinesAllTurrets _vehicle); 
// Get Special Cargo
_data pushBack [(getFuelCargo _vehicle),(getAmmoCargo _vehicle),(getRepairCargo _vehicle)];
// Return data
_data;