/*
	Initialize and control the IAC UI
	params: none
*/
// open map
openMap [true, false];
_selectedUnits = groupSelectedUnits player;
_cursor_item = str ctrlMapMouseOver (findDisplay 12 displayCtrl 51);

/*---------------------------------------------------------------------------
FUNCTIONS / EVENT HANDLERS
---------------------------------------------------------------------------*/
// Register the on map click event
[] onMapSingleClick {
	// INIT
	_ics_logic = localNamespace getVariable "ics_logic";
	// plan: [[unit,[marker, cmd, cmd-opt,opt-en-route, opt-arrival], ...]
	_ics_plan = _ics_logic getVariable ["ics_plan", []]; // list of all units running the ai command
	_ics_playergroup = _ics_logic getVariable ["ics_playergroup", []]; // list of units in players current group
	_ics_selected = _ics_logic getVariable ["ics_selected", []]; // Unit selection
	_ics_hcgroup = _ics_logic getVariable ["ics_hcgroup", []]; // List of units in players HC Group
	_ics_markers = _ics_logic getVariable ["ics_markers", []]; // markers not in other arrays
	_searchdist = 5;

	// Get Nearby things of interest
	_nearestPCU = [((units (group player)) - [player]), _pos] call BIS_fnc_nearestPosition;
	_nearestPCUPoint = (position _nearestPCU);
	_nearestWP = [0,0,0];
	_nearestWPUnit = objNull;
	_nearestWPDist = 0;
	{
	  _wp = _x select 6;
	  _unit = _x select 0;
	  {
		  if (((_x select 0) distance2D _pos) < _nearestWPDist) then {
		  	_nearestWP = (_x select 0);
		  	_nearestWPUnit = _unit;
		  };
	  } forEach _wp;
	} forEach _ics_playergroup;

	_nearestICSPoint = [[_nearestPCUPoint, _nearestWP], _pos] call BIS_fnc_nearestPosition;
	// hintSilent format["Found nearby:\nUnit: %1\n%WP: %2", _nearestPCU, _nearestWP];
	if ((_nearestICSPoint distance2D _pos) < _searchdist) then {
		switch (_nearestICSPoint) do { 
			case _nearestPCUPoint : {  [_nearestPCU, _alt, _shift] spawn ICS_fnc_clickedPCU; }; 
			case _nearestWP : {  [_nearestPCU, _alt, _shift] call ICS_fnc_clickedWP; }; 
			default {  /* Should Never happen */ }; 
		};
	} else {
		// TODO: No ICS control clicked
	};
};

ICS_fnc_clickedPCU = {
	_unit = _this select 0;
	_alt = _this select 1;
	_shift = _this select 2;
	_ics_logic = localNamespace getVariable "ics_logic";
	_ics_playergroup = _ics_logic getVariable "ics_playergroup";
	_ics_selected = _ics_logic getVariable ["ics_selected", []];

	switch ( true) do { 
		case _alt : {  /*...code...*/ }; 
		case _shift : {
			// Shift clicked a unit - Select/Deselect from ICS
			_unitIndex = _ics_selected findIf {_x == _unit};
			if ( _unitIndex > -1) then {
				_ics_selected deleteAt _unitIndex;
			} else {
				_ics_selected append [_unit];
			};
			hintSilent format["selected: %1", _ics_selected];
		}; 
		default {
			// No command click - Just select unit and open default menu
			_unit spawn {
				showCommandingMenu "RscGroupRootMenu";
				waitUntil {commandingMenu == "RscGroupRootMenu"};
				player groupSelectUnit [_this, true];
			};
		}; 
	};
};

ICS_fnc_clickedWP = {
	
};

ICS_fnc_oldMapSingleClick = {

	// Get the nearest marker
	// hintSilent format["pos: %1 \nunits: %2\nshift: %3\nalt: %4\nmouseover: %5",_pos, _units, _shift, _alt, str ctrlMapMouseOver (findDisplay 12 displayCtrl 51)];
	_nearestMarker = [allMapMarkers, _pos] call BIS_fnc_nearestPosition;
	// Check if distance is low enough
	if ((_pos distance2D (getMarkerPos _nearestMarker)) < 3) then {
		// Check if the marker is actually long enough
		_markerData = [_nearestMarker, "_"] call BIS_fnc_splitString;
		if ((count _markerData) >= 3) then {
			_unitIndex = _markerData select 2;		// Unit index number, used to identify it
			_unitType = _markerData select 1; 		// "PCS/HC/ICS"
			_unitControl = _markerData select 0;	// "ICS"
			// Check if unit control type is correct
			if (_unitControl == "ICS") then {
				// Switch through unit types
				switch (_unitType) do { 
					case "PCU" : {
						// find the unit in player group
						_unit = player; // sane default
						{
							if ((_x select 1) == (parseNumber _unitIndex)) then {
			 					_unit = _x select 0;
			 					break;
							};
						} forEach _ics_playergroup;
						// Go through options and pick
						switch (true) do { 
							case _alt : {  /*...code...*/ }; 
							case _shift : {
								_unitID =_ics_selected findIf {_unit == _x};
								if (_unitID == -1) then {
									_ics_selected append [_unit];
								} else {
									_ics_selected deleteAt _unitID;
								};
								_ics_logic setVariable ["ics_selected",_ics_selected];
							}; 
							default {
								_unit spawn {
									showCommandingMenu "RscGroupRootMenu";
									waitUntil {commandingMenu == "RscGroupRootMenu"};
									player groupSelectUnit [_this, true];
								};
							};
						};
						hintSilent format["marker: %1\nCtrl: %2\nType: %3\n%Index: %4\nSelected: %5", _nearestMarker, _unitControl, _unitType, _unitIndex, _ics_selected];
					}; // END CASE PCU
					default {  /*...code...*/ }; 
				};
			} else {
				// IGNORE the command
			};
		} else {
			// This is not an ICS marker
			hintSilent format["marker: %1\nUnit: %2\nCount: %3", _nearestMarker, _unit, count _unit];
		};
		// _ics_logic = localNamespace getVariable "_ics_logic";
		// _ics_playergroup = _ics_logic getVariable "_ics_playergroup";
		// {
		  
		// } forEach _ics_playergroup;
		// [_nearestMarker, "_"] call BIS_fnc_splitString;
		// _unitIndex = _nearestMarker setVariable ["ics_unitIndex", objNull];
	} else {
		// if units are selected open menu on location
		if (count _ics_selected > 0) then {
			// plan: [[unit,[marker, cmd, cmd-opt,opt-en-route, opt-arrival], ...]
			// Process selected units
			{
				// Find the unit in ics_selected if available
				_unit = _x;
				_index = _ics_plan findIf {  (_x select 0) == _unit };
				_markername = "ICS_WP_ERR";
				// If found append
				if (_index > -1) then {
					_old_plan = _ics_plan select _index;
					_old_plan = _old_plan select 1;

					_markername = format["ICS_WP_%1_%2", _unit, count _old_plan];
					deleteMarkerLocal _markername;
					_marker = createMarkerLocal [_markername, _pos];

					_old_plan append [[_markername,""]];
					_ics_plan deleteAt _index;					
					_ics_plan append [ [_unit,_old_plan] ];

					// Create the marker line if not first marker
					// _markername setMarkerPolyline [source1,source1,dest2,dest2];
					_linename = format ["%1_LINE", _markername];
					// _prev_wp = getMarkerPos ((_old_plan select ((count _old_plan)-2)) select 0); //select previous element
					deleteMarkerLocal _linename;
					// createMarkerLocal [_linename, _pos];
					// _linename setMarkerPolylineLocal [_prev_wp select 0, _prev_wp select 1, _pos select 0, _pos select 1];
					// _linename setMarkerSizeLocal [1, 1]; // No effect visible??

				} else {
					// If not found add new
					_markername = format["ICS_WP_%1_0", _r];
					deleteMarkerLocal _markername;
					_marker = createMarkerLocal [_markername, _pos];
					_ics_plan append [ [_r, [[_markername, "MOVE"]] ] ];
				};
				// Create the marker
				_markername setMarkerShapeLocal "ICON";
				_markername setMarkerTypeLocal "mil_dot_noShadow";
			} forEach _ics_selected;

			// Append locally and push
			_ics_logic setVariable ["ics_plan", _ics_plan];
			// showCommandingMenu "RscGroupRootMenu";
		};
	};
	hintSilent format["Plan:\n%1", _ics_plan];
};

/*---------------------------------------------------------------------------
INIT
---------------------------------------------------------------------------*/
// INIT
_ics_logic = localNamespace getVariable "ics_logic";
// plan: [[unit,[marker, cmd, cmd-opt,opt-en-route, opt-arrival], ...]
_ics_plan = _ics_logic getVariable ["ics_plan", []]; // list of all units running the ai command
_ics_playergroup = _ics_logic getVariable ["ics_playergroup", []]; // list of units in players current group
_ics_selected = _ics_logic getVariable ["ics_selected", []]; // Unit selection
_ics_hcgroup = _ics_logic getVariable ["ics_hcgroup", []]; // List of units in players HC Group
_ics_markers = _ics_logic getVariable ["ics_markers", []]; // markers not in other arrays

/*---------------------------------------------------------------------------
MAIN LOOP
---------------------------------------------------------------------------*/
// Add Draw event handler
_map = (findDisplay 12 displayCtrl 51);
_drawDAM = _map ctrlAddEventHandler ["Draw",{
	_ics_logic = localNamespace getVariable "ics_logic";
	_ics_playergroup = _ics_logic getVariable ["ics_playergroup", []];
	_ics_plan = _ics_logic getVariable ["ics_plan", []];
	_map = _this select 0;

	{
		// Gather information
		_pos_unit = getPos (_x select 0);
		_pos_dam = (_x select 4);
	    _teamcolor = (_x select 5);
	    // Draw unit icon
	    _map drawIcon [
		(_x select 2), // texture: String - Icon texture. Custom images can also be used: getMissionPath "\myFolder\myIcon.paa"
		_teamcolor, // Color
		_pos_unit, // Position
		24, // Width
		24, // Height
		0, // Rotation
		format["%1",(_x select 1)], // Text (Optional)
		0, // Shadow 0:False 1:For Text 2: Text and Icon (Must be rotation/angle 0)
		0.03, // Text Size
		"TahomaB", // Font
		"right" // Align (right, left, center)
		];
	    // Draw DAM Icon
	    _map drawIcon [
		"a3\ui_f\data\map\groupicons\selector_selected_ca.paa", // texture: String - Icon texture. Custom images can also be used: getMissionPath "\myFolder\myIcon.paa"
		_teamcolor, // Color
		_pos_dam, // Position
		12, // Width
		12, // Height
		0, // Rotation
		format["%1",(_x select 1)], // Text (Optional)
		0, // Shadow 0:False 1:For Text 2: Text and Icon (Must be rotation/angle 0)
		0.03, // Text Size
		"TahomaB", // Font
		"right" // Align (right, left, center)
		];
	    // Draw DAM Line
	    _map drawLine [_pos_unit, _pos_dam, _teamcolor];
	    // Draw Any waypoint left aka the PLAN
	   	{
		} forEach _x select 6;
	} forEach _ics_playergroup;

	// (_this select 0) drawLine [
	// 	getPos player,
	// 	[0,0,0],
	// 	[0,0,1,1]
	// ];
}];

waitUntil {!visibleMap};
while {visibleMap} do {
	hintSilent format["W: %1", _ics_playergroup];
	// _map = (findDisplay 12 displayCtrl 51);
	// _colorDAM = [0,0,1,1];
	// // map drawLine [pos1, pos2, color];
	// {
	// 	_pos_unit = getPos (_x select 0);
	// 	_pos_dam = getMarkerPos (_x select 5);
	//     _map drawLine [_pos_unit, _pos_dam, _colorDAM];
	// } forEach _ics_playergroup;

	// _cursor_item = str ctrlMapMouseOver (findDisplay 12 displayCtrl 51);
	// hintSilent _cursor_item;
	// hint format["selected: %1", groupSelectedUnits player];
	// sleep 0.1;
};

/*---------------------------------------------------------------------------
CLEANUP
---------------------------------------------------------------------------*/
onMapSingleClick "";
_map ctrlRemoveEventHandler ["Draw", _drawDAM];
hint "Cleaup done";

// De-Register the on map click event
// For High-Command
// _marker = createMarker [name _x, _x];

// get units in group
// draw marker on each unit
// openMap [false]
// onEachFrame {hintSilent str ctrlMapMouseOver (findDisplay 12 displayCtrl 51)};

// player addAction ["Force Open Map", {openMap [true, true]];
// player addAction ["Force Open Map", {openMap [false, false]];

