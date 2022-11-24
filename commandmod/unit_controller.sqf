/*
	AI Control script for IAC
*/
private ["_wps"];
_unit = _this select 0;

// Initialize and run
_wps = _unit getVariable "iac_command_queue";
_dam = _unit getVariable "iac_unit_DAM";
_dam_name = _dam select 1;
_dam = _dam select 0;
/**/
while {(count _wps) > 0} do {
  // Get actual current command (e.g. what is the ai doing)
  /* can be of following types
  	"WAIT"	"	ATTACK" 	"HIDE"
	"MOVE"		"HEAL" 		"REPAIR"
	"REFUEL"	"REARM"		"SUPPORT"
	"JOIN"		"GET IN"	"FIRE"
	"GET OUT"	"STOP"		"EXPECT"
	"ACTION"	"ATTACKFIRE"	"Suppress"
  */
  _actual_cmd = currentCommand _unit;
  _actual_dest = (expectedDestination _unit) select 0;
  // if ((expectedDestination _unit) select 1)  
  // Get expected/next command
  // _curr_cmd = (_wps select 0) getVariable "iac_cmd";
  // _curr_dest = getMarkerPos (name (_wps select 0));
  // Check current command and position have not changed
  // hint format["%1\n%2\n%3\n%4", _actual_cmd, (getPos _unit), _actual_dest, ((getPos _unit) distance2D _actual_dest)];
  // if (((getPos _unit) distance2D _actual_dest) < 5 )then {
  // if ((_curr_cmd != _actual_cmd) || (_curr_dest != _actual_dest)) then {
    // Get info
    // Create command at position
    // _markername = format["IAC POU %1 %2", name _unit, (count _wps)];
    _dam_name setMarkerPos ((expectedDestination _unit) select 0);
    // _marker = createMarker [_markername, _actual_dest];
    // hint format["marker: %1", _marker];
    // _markername setMarkerShape "ICON";
    // _markername setMarkerType "mil_circle_noShadow";
    // hint format["making: %1", _markername];
    // pushBack onto queue
    // _wps pushBack _marker;
	// };
	// Update unit
	// _unit setVariable ["iac_command_queue", _wps];
  // };
  /*
  	Setup complete, run the actual command
  */
  // On Success: Delete from Queue
  // On Failure: ???
  /* Rinse and repeat */
  // Check if we are still actively controlling this AI
  if !(_unit getVariable "iac_controlled") then {
  	break;
  };
  // Update current command queue
  _wps = _unit getVariable "iac_command_queue";
  // hint format["wps left: %1", (count _wps)];
  sleep 1;
};
/*
	Final
*/
// All done, cleanup
if ((count _wps) > 0 ) then {
	_unit groupChat format["Finished IAC Command Queue"];
} else {
	_unit groupChat format["IAC Terminated - WPs Left: %1", (count _wps)];	
};
