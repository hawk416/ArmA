/*
	init.sqf for Integrated Advanced Command

*/

if (isDedicated) exitwith {};
//waituntil {!isnil "bis_fnc_init"};
if (is3den) exitwith {};
waituntil {!is3den};
waituntil {alive player};

player addAction["ICS Plan", "iac_hud.sqf"];
player addAction["ICS Start", "ai_controller.sqf"];
player addAction["ICS Stop", {(localNamespace getVariable ["ics_logic", objNull]) setVariable ["ics_run", false]}];
player addAction["ICS Restart", {(localNamespace getVariable ["ics_logic", objNull]) setVariable ["ics_run", true]}];
// player addAction["ICS Go", { {[_x] execVM "unit_controller.sqf"} forEach ((units (group player)) - [player]) }];
// player addAction["ICS Stop", { {_x setVariable ["iac_controlled", false]} forEach ((units (group player)) - [player]) }];
// player addAction["ICS Init", { {[_x] execVM "ai_init.sqf"} forEach ((units (group player)) - [player]) }];

/*
	Initialize ICS Logic
*/
_ics_logic = localNamespace getVariable ["ics_logic", objNull];
hint format["entity: %1\nValue: %2", _ics_logic, (isNull _ics_logic) ];
if (isNull _ics_logic) then {
	hint "ICS Setup ...";
	_ics_logic = "logic" createVehicleLocal [0,0,0];
	localNamespace setVariable ["ics_logic", _ics_logic];

	_ics_logic setVariable ["ics_plan", []]; // list of all units running the ai command
	_ics_logic setVariable ["ics_playergroup", []]; // list of units in players current group
	_ics_logic setVariable ["ics_selected", []]; // markers not in other arrays
	_ics_logic setVariable ["ics_hcgroup", []]; // List of units in players HC Group
	_ics_logic setVariable ["ics_markers", []]; // markers not in other arrays


	_ics_logic setVariable ["ics_run", true]; // for debugging purpouses, to stop all ICS
	hint "ICS Setup OK";
};
/*
	Create the ABCD and My Mark triggers
*/
