/*
	AI Initialization script
*/

private [];
_unit = _this select 0;

// Add units variables
// _unit setVariable ["iac_command_queue", [true]]; // Array: [marker1, marker2], actual objects not just names
_unit setVariable ["iac_controlled", true]; // Boolean: true only when controlled by IAC
// Create unit's Direct Action marker
// _markername = format["IAC POU %1 DAM", name _unit];
// deleteMarker _markername;
// _marker = createMarker [_markername, _unit];
// _markername setMarkerShape "ICON";
// _markername setMarkerType "mil_circle_noShadow";
// _unit setVariable ["iac_unit_DAM", [_marker, _markername]];
