/*
	Asset Compiler

	Description:
	Takes group and returns array representation of it.

	Arguments:
	0 - Group  - _grp
*/
params["_grp"];
private["_ret","_units", "_leader", "_loadout", "_vehicles"];
private _compile_vehicle={
	// ntech_fnc_garage_save returns
	// [ "config", "Texture", [Visual Customizations], [Hitpoints], [Inventory], [Fuel], [Ammunition], [Cargo Fuel, Cargo Ammo, Repair Cargo] ]
	_vehdata=_this call ntech_fnc_garage_save;
	_vehunits=[];
	{
	  _vehunits append [_x select 0];
	  _vehunits append [getUnitLoadout (_x select 0)];
	} forEach fullCrew _x;
	[typeof _this, _vehdata, _vehunits];
};
if !(player diarySubjectExists "NTCompile") then {player createDiarySubject ["NTCompile", "NTCompile"]};
_diaryname=groupId _grp;
player createDiaryRecord["NTCompile", [_diaryname, "========================"]];

_vehicles=[];
_ret=[];
// Make sure leader is first
_units=units _grp;
_leader=leader _grp;
player createDiaryRecord["NTCompile", [_diaryname, format["Leader: %1 - %2", _leader, name _leader]]];
// If the leader is in a vehicle, put that first
if (vehicle _leader != _leader) then {
	_veh=vehicle _leader;
	_vehdata=_veh call ntech_fnc_garage_save;
	_vehunits=[];
	{
	  _vehunits append [_x select 0];
	  _vehunits append [getUnitLoadout (_x select 0)];
	  _units=_units-[_x select 0];
	} forEach fullCrew _veh;
	_ret append [typeof _veh, [_vehdata, _vehunits]];
	_vehicles append [_veh];
	player createDiaryRecord["NTCompile", [_diaryname, format["Leader Vehicle: %1<br />Data: %2<br />Units: %3", _veh, _vehdata, _vehunits]]];
} else {
	_ret append [typeof _leader];
	_ret append [getUnitLoadout _leader];
	_units=_units-[_leader];
	player createDiaryRecord["NTCompile", [_diaryname, format["Leader: %1<br />Loadout: %2", typeOf _leader, getUnitLoadout _leader]]];
};
// Process the rest
while {count _units > 0} do {
 	_unit=_units select 0;
	if ((vehicle _unit != _unit) and !((vehicle _unit ) in _vehicles)) then {
		_veh=vehicle _unit;
		_vehdata=_veh call ntech_fnc_garage_save;
		_vehunits=[];
		{
		  _vehunits append [_x select 0];
		  _vehunits append [getUnitLoadout (_x select 0)];
		  _units=_units-[_x select 0];
		} forEach fullCrew _veh;
		_ret append [typeof _veh, [_vehdata, _vehunits]];
		_vehicles append [_veh];
		player createDiaryRecord["NTCompile", [_diaryname, format["Vehicle: %1<br />Data: %2<br />Units: %3", _veh, _vehdata, _vehunits]]];
	} else {
		_ret append [typeof _unit];
		_ret append [getUnitLoadout _unit];
		_units=_units-[_unit];
		player createDiaryRecord["NTCompile", [_diaryname, format["Unit: %1<br />Loadout: %2", typeOf _unit, getUnitLoadout _unit]]];
	};
};
_ret;