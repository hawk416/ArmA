/*
	teleport.sqf

	Script to teleport player and his current group including any vehicles they are currently in.

	Setup:
	unit addAction["Teleport", {_this execVM "ntech_dev\teleport.sqf"}];

	Development Notes:
	onMapSingleClick Description:
	Define action performed when user clicks in map by executing command string. the string receives 5 (localised in scope) variables:
		_this: Anything - Params passed to onMapSingleClick
		_pos: Array - Clicked position
		_units: Array - Units which were selected (via function keys) before opening the map (may be non-functional in Arma)
		_shift: Boolean - Whether <Shift> was pressed when clicking on the map
		_alt: Boolean - Whether <Alt> was pressed when clicking on the map
*/
_target = _this select 0;
_caller = _this select 1;
_id = _this select 2;

// open the map
openMap [true, false];
hint "Press ALT and click on the map to be teleported there";

// Add the map click handler
_target onMapSingleClick {
	_target=_this;
	// if alt is pressed at the same time
	if (_alt) then {
		// move all units to new position
		[_target, _pos] call 
		{
			_target=_this select 0;
			_pos=_this select 1;
			_veh_array=[];
			{
				// check if the unit is in a vehicle
				if (vehicle _x != _x) then {
					// check if the vehicle has been moved yet
					if ((_veh_array find (vehicle _x)) < 0) then {
						_veh_array set [(count _veh_array), vehicle _x];
						_x = vehicle _x;
					} else {
						// break;
						_x = objNull;
					}
				};
				if !(isNull _x) then{
					// find a suitable spot for the vehicle type
					_spot = _pos findEmptyPosition [0, 100, typeOf _x];
					// check if spot has been returned
					if (count _spot > 0) then {
						if (isTouchingGround _x) then {
							_x setVehiclePosition [_spot, [], 0, "NONE"];
						} else {
							_x setVehiclePosition [_spot, [], 0, "FLY"];
						};
					} else {
						hint format["Cannot teleport unit: %1", _x];
					};
				};
			// sleep a little to give time for the engine to process the move
			// sleep 0.1;
			} forEach units (group _target);	
		};
		// remove handler
		onMapSingleClick "";
		openMap [false, false];
	};
};