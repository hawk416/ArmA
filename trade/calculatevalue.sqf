/*
	NTech Unit/Vehicle cost calculator
*/
params["_unit"];
private["_inventory", "_value", "_itemclass"];
private _itemcost=compile preprocessFileLineNumbers "ntech-trade\itemprice.sqf";
private _save_vehicle=compile preprocessFileLineNumbers "ntech\ntech_fnc_garage_save.sqf";
/*
	MAIN
*/
_inventory=[];
_value=[0,0,0];
switch (true) do { 
	case (typeName _this == "ARRAY") : {};
	case (_this isKindOf "Man") : {
	_loadout=getUnitLoadout _this;
	if (count(_loadout select 0) > 0) then {
		_inventory append [(_loadout select 0) select 0]; // primary weapon
		_inventory append [(_loadout select 0) select 1]; // primary suppressor
		_inventory append [(_loadout select 0) select 2]; // primary pointer
		_inventory append [(_loadout select 0) select 3]; // primary optic
		_magazine=(_loadout select 0) select 4; // primary magazine: [mag, ammo] -> needs to become [mag, 1, ammo]; 
		if (count _magazine > 0) then {	_inventory append [[_magazine select 0, 1, _magazine select 1]] };
		_magazine=(_loadout select 0) select 5; // primary magazine2: [mag, ammo] -> needs to become [mag, 1, ammo];
		if (count _magazine > 0) then {	_inventory append [[_magazine select 0, 1, _magazine select 1]] };
		_inventory append [(_loadout select 0) select 6]; // Primary Bipod
	};
	if (count(_loadout select 1) > 0) then {
		_inventory append [(_loadout select 1) select 0]; // Secondary weapon
		_inventory append [(_loadout select 1) select 1]; // Secondary suppressor
		_inventory append [(_loadout select 1) select 2]; // Secondary pointer
		_inventory append [(_loadout select 1) select 3]; // Secondary optic
		_magazine=(_loadout select 1) select 4; // Secondary magazine: [mag, ammo] -> needs to become [mag, 1, ammo]; 
		if (count _magazine > 0) then {	_inventory append [[_magazine select 0, 1, _magazine select 1]] };
		_magazine=(_loadout select 1) select 5; // Secondary magazine2: [mag, ammo] -> needs to become [mag, 1, ammo];
		if (count _magazine > 0) then {	_inventory append [[_magazine select 0, 1, _magazine select 1]] };
		_inventory append [(_loadout select 1) select 6]; // Secondary Bipod
	};
	if (count(_loadout select 2) > 0) then {
		_inventory append [(_loadout select 2) select 0]; // Handgun weapon
		_inventory append [(_loadout select 2) select 1]; // Handgun suppressor
		_inventory append [(_loadout select 2) select 2]; // Handgun pointer
		_inventory append [(_loadout select 2) select 3]; // Handgun optic
		_magazine=(_loadout select 2) select 4; // Handgun magazine: [mag, ammo] -> needs to become [mag, 1, ammo]; 
		if (count _magazine > 0) then {	_inventory append [[_magazine select 0, 1, _magazine select 1]] };
		_magazine=(_loadout select 2) select 5; // Handgun magazine2: [mag, ammo] -> needs to become [mag, 1, ammo];
		if (count _magazine > 0) then {	_inventory append [[_magazine select 0, 1, _magazine select 1]] };
		_inventory append [(_loadout select 2) select 6]; // Handgun Bipod
	};
	if (count (_loadout select 3) > 0) then {
		_inventory append [((_loadout select 3) select 0)]; // uniform itself
		_inventory append ((_loadout select 3) select 1); // uniform items
	};
	if (count (_loadout select 4) > 0) then {
		_inventory append [((_loadout select 4) select 0)]; // vest itself
		_inventory append ((_loadout select 4) select 1); // vest items
	};
	if (count (_loadout select 5) > 0) then {
		_inventory append [((_loadout select 5) select 0)]; // backpack itself
		_inventory append ((_loadout select 5) select 1); // backpack items
	};
	_inventory append [(_loadout select 6)]; // headgear
	_inventory append [(_loadout select 7)]; // facewear/goggles
	_inventory append (_loadout select 8); // binoculars
	_inventory append (_loadout select 9); // assigneditems
};
	default {  hint "Default"; _inventory=_this call _save_vehicle }; 
};
// Calculate the cost
if !(player diarySubjectExists "NTCost") then {player createDiarySubject ["NTCost", "NTCOST"]};
_diaryname=format["Cost: %1", [daytime] call BIS_fnc_timeToString];
player createDiaryRecord["NTCost", [_diaryname, "------------"]];

{
	if (!(_x isEqualTo "") and !(_x isEqualTo [])) then {
		_cost=_x call _itemcost;
		player createDiaryRecord["NTCost", [_diaryname, format["%1 : %2", _x, _cost]]];
		_value=_value vectorAdd _cost;
	};

} forEach _inventory;
player createDiaryRecord["NTCost", [_diaryname, format["Total Cost: %1", _value]]];

// hint format["inv: %1", _inventory];

