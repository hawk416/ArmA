/*
	ICS AI Controller

	Handles:
		- Position updates for units and their markers
		- Fetches the current command (Direct Action Marker)
*/

/*---------------------------------------------------------------------------
FUNCTIONS
---------------------------------------------------------------------------*/
// Get units index for selecting
ICS_fnc_getUnitIndex = {
	/* Find the unit GUI ID
	// Taken from BI Forums: https://forums.bohemia.net/forums/topic/185059-how-to-retrieve-the-actual-number-of-a-squad-member/
	// Credits to: terox
	// Description : Returns the Unit's group number as seen in the command gui
	// removes the first 2 elements from that array and then recompiles as a string
	*/
	// _unit_index = parseNumber(([[
	// str _x,
	// count(toArray(str group _x))+1
	// ] call BIS_fnc_trimString, " "
	// ] call BIS_fnc_splitString) select 0);
	// BI Wiki Alternative in case it's needed: https://community.bistudio.com/wiki/joinAs
	private ["_vvn", "_str"];
	_vvn = vehicleVarName _this;
	_this setVehicleVarName "";
	_str = str _this;
	_this setVehicleVarName _vvn;
	parseNumber (_str select [(_str find ":") + 1])
};

// Initialize player group
ICS_fnc_init_playergroup = {
	private ["_markername","_marker","_damname","_dam","_unit_index","_ics_playergroup"];
	_ics_playergroup = [];
		{
			// Get the unit index
			_unit_index = _x call ICS_fnc_getUnitIndex;
			// Create the unit marker
		 //    _markername = format["ICS_PCU_%1", _unit_index];
			// deleteMarkerLocal _markername;
		 //    _marker = createMarkerLocal [_markername, _x];
		 //    _markername setMarkerShapeLocal "ICON";
		 //    _markername setMarkerTypeLocal "selector_selectable";

		    // TODO: Set size, color, text
			// "markPlace" setMarkerColor "ColorRed";
			// "markPlace" setMarkerText "Place";

			// Create the units Direct Action Marker
			// _damname = format["ICS_PCU_%1_DAM", _unit_index];
			// deleteMarkerLocal _damname;
			// _dam = createMarkerLocal [_damname, _x];
			// _damname setMarkerShapeLocal "ICON";
			// _damname setMarkerTypeLocal "mil_dot_noShadow";

			// get units team
			_team = assignedTeam _x;
			switch ( _team ) do { 
				case "MAIN" : {  // Team White
					_team = getArray ( configfile >> "CfgMarkerColors" >> "ColorWhite" >> "color" );
					}; 
				case "RED" : {
					_team = getArray ( configfile >> "CfgMarkerColors" >> "ColorRed" >> "color" );
					}; 
				case "GREEN" : {
					_team = getArray ( configfile >> "CfgMarkerColors" >> "ColorGreen" >> "color" );
					}; 
				case "BLUE" : {
					_team = getArray ( configfile >> "CfgMarkerColors" >> "ColorBlue" >> "color" );
					}; 
				case "YELLOW" : {
					_team = getArray ( configfile >> "CfgMarkerColors" >> "ColorYellow" >> "color" );
					}; 
				default {
					_team = getArray ( configfile >> "CfgMarkerColors" >> "ColorBlack" >> "color" );
					}; 
			};
			// Set Color
		    // _markername setMarkerColorLocal _team;
		    // append object, marker, waypoints
		    _ics_playergroup append [[_x, _unit_index, "a3\ui_f\data\map\groupicons\selector_selected_ca.paa", currentCommand _x, expectedDestination _x, _team, [] ]];
		    // systemChat format["Adding %1", _markername];
		    // systemChat format["%1", [_x, _unit_index, _marker, _markername, _dam, _damname]];
		 } forEach (units (group player)) - [player];
		 // Create the player marker
		deleteMarkerLocal "ICS_P1";
		createMarkerLocal ["ICS_P1", player];
		"ICS_P1" setMarkerShapeLocal "ICON";
		"ICS_P1" setMarkerTypeLocal "mil_triangle_noShadow";
	// Return the new group
	_ics_playergroup;
};
/* END FUNCTIONS*/

/*---------------------------------------------------------------------------
INIT
---------------------------------------------------------------------------*/
systemChat "ICS Init ...";
_ics_logic = localNamespace getVariable "ics_logic";

_ics_units = _ics_logic getVariable ["ics_units", []]; // list of all units running the ai command
_ics_playergroup = _ics_logic getVariable ["ics_playergroup", []]; // list of units in players current group
_ics_hcgroup = _ics_logic getVariable ["ics_hcgroup", []];
_ics_selected = _ics_logic getVariable ["ics_selected", []];
_ics_other = []; // TODO: Implement tracking of other things

_player_grp = group player;
/*
	Initialize ICS
*/
// TODO: Re-Init check

// Init ICS groups
_ics_playergroup = [] call ICS_fnc_init_playergroup;
_ics_logic setVariable ["ics_playergroup", _ics_playergroup];
systemChat "ICS Init OK";

/*---------------------------------------------------------------------------
MAIN LOOP
---------------------------------------------------------------------------*/
while {_ics_logic getVariable "ics_run"} do {
	/*
	// 30 Second loop / 5 Second Resolution
	*/
	// for "_i" from 0 to 6 do {
		// Check if player is still part of original group
		if ((group player) != _player_grp) then {
			systemChat "Player changed groups, re-initilizing";
			_player_grp = group player;
			{
			  deleteMarkerLocal (_x select 3); // Delete the position marker
			  deleteMarkerLocal (_x select 5); // Delete the DA marker
			} forEach _ics_playergroup;
			// Re-Init Team
			_ics_playergroup = [] call ICS_fnc_init_playergroup;
			_ics_logic setVariable ["ics_playergroup", _ics_playergroup];
		};

		/*
		// 5 Second Loop / 1 Second Resolution
		// Updates:
		//		- Player Group
		//
		*/
		for "_i" from 0 to 5 do {

			/*
			// 1 Second Loop / .5 Resolution
			// Updates: 
			//		- Player Unit Markers
			//		- Player Unit Direct Action Markers
			*/
			for "_i" from 0 to 10 do {
				_player_selected = groupSelectedUnits player;
				//update Player Group Markers
				{
					// Update unit marker position
					_markername = (_x select 2);
					// _damname = (_x select 5);
					_unit = (_x select 0);
					// _markername setMarkerPos (_unit);
					// _markername setMarkerDirLocal (direction _unit);
					// systemChat format["%1 : %2", _unit, direction _unit];
					// Update DAM Marker
					_dam_cmd = currentCommand _unit;
					// TODO: Update DAM type on command change
					// if ( (_unit distance ((expectedDestination _unit) select 0)) < 5 ) then {
						// Do something
					// };
					_dam_pos = (expectedDestination _unit) select 0;
					// _damname setMarkerPos ((expectedDestination _unit) select 0);
					// systemChat format["%1\n%2\n%3", _unit, _markername, _damname];
					_selectID = _player_selected findIf { _x == _unit };
					if ( _selectID == -1) then { _selectID = _ics_selected findIf { _x == _unit } };
					if ( _selectID != -1) then {
						// TODO: Change this to: "a3\ui_f\data\map\groupicons\selector_selected_ca.paa" once custom markers are defined
						_markername = "a3\ui_f\data\map\groupicons\selector_selected_ca.paa";
					} else {
						_markername = "a3\ui_f\data\map\groupicons\selector_selectable_ca.paa";
					};


					// hintSilent format["Selected units: %1\nUnit: %2\nIndex: %3", _player_selected, _unit, _selectID];					
					_ics_playergroup set [_forEachIndex, [_unit, _x select 1, _markername, _dam_cmd, _dam_pos, _x select 5, _x select 6]];
				} forEach _ics_playergroup;
				// hintSilent format["Waypoint:\n%1\n\n%2\n\n%3", (_ics_playergroup select 0) select 6, (_ics_playergroup select 1) select 6, (_ics_playergroup select 2) select 6];
				// hintSilent format["Selected units: %1", groupSelectedUnits player];
				// Update player marker
				"ICS_P1" setMarkerPos (player);
				"ICS_P1" setMarkerDirLocal (direction player);
				// Finally Sleep zZz
				sleep 0.1;
			};	
		};
	// };
};
/*---------------------------------------------------------------------------
CLEANUP
---------------------------------------------------------------------------*/
systemChat "ICS Shutdown ...";
systemChat "ICS Shutdown OK";


/*---------------------------------------------------------------------------
DEV/DEBUG
---------------------------------------------------------------------------*/
  // Get actual current command (e.g. what is the ai doing)
  /* can be of following types
  	"WAIT"	"	ATTACK" 	"HIDE"
	"MOVE"		"HEAL" 		"REPAIR"
	"REFUEL"	"REARM"		"SUPPORT"
	"JOIN"		"GET IN"	"FIRE"
	"GET OUT"	"STOP"		"EXPECT"
	"ACTION"	"ATTACKFIRE"	"Suppress"
  */
  // _actual_cmd = currentCommand _unit;
  // _actual_dest = (expectedDestination _unit) select 0;
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
	// _actual_cmd = currentCommand _unit;
 //    _dam_name setMarkerPos ((expectedDestination _unit) select 0);
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
  // if !(_unit getVariable "iac_controlled") then {
  // 	break;
  // };
  // Update current command queue
  // _wps = _unit getVariable "iac_command_queue";
  // hint format["wps left: %1", (count _wps)];
  // sleep 1;
// };


