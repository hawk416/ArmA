NT_fnc_spawngroup={
	params["_side", "_pool", "_leaders", "_spoint", "_sradius", "_callsign"];
	private["_select", "_grp", "_safepos", "_dir","_success"];
    _select=selectRandom _pool;
    _success=true;
    if ((typeName _select) isEqualTo "ARRAY") then {
        _grp=createGroup _side;
        {
			// hint format["Data: %1", _x];
			_classname=_x select 0;
			if !((typeName _spoint) isEqualTo "ARRAY") then {_dir=getDir _spoint; _spoint=getPos _spoint};
			if (isNil "_dir") then {_dir=random 359;};
			//ALTERNATIVE: center findEmptyPosition [radius, maxDistance, vehicleType]
			_safepos=_spoint findEmptyPosition [0, _sradius, _classname];
			if ((count _safepos) == 0) exitWith {_success=false};
			// _safepos=[_classname, _spoint, _sradius] call nt_hal_fnc_findsafeposition;
            if (_classname isKindOf "Man") then {
                // _unit=_classname createUnit [_safepos, _grp];
                // Using newer syntax
				_unit=_grp createUnit [_classname, _safepos, [], 1, "NONE"];
				if (isNull _unit) exitWith {_success=false};
                _unit setUnitLoadout (_x select 1);
	            [_unit] joinSilent _grp;
            } else {
            	_loadouts= _x select 1;
            	_units=_x select 2;
            	_unknown=_x select 3; // TODO: Figure out what this is and why it isn't vehicle cosmetics
                // _veh=([_safepos,_dir,_classname,_grp] call BIS_fnc_spawnVehicle) select 0;
               	// deleteVehicleCrew _veh;
                _veh=createVehicle [_classname, _safepos];
				if (isNull _veh) exitWith {_success=false};
                _veh setDir _dir;
               	// systemChat format["Pos: %1 dir: %2", _spoint, _dir];
               	for "_i" from 0 to ((count _units) -1) do {
					_unit=_grp createUnit [(_units select _i), _safepos, [], 1, "NONE"];
					if (isNull _unit) exitWith {_success=false};
	                _unit setUnitLoadout (_loadouts select _i);
		            _unit moveInAny _veh;
		            [_unit] joinSilent _grp;               		
               	};
            };
        } foreach _select;
    } else {
    	_safepos=[_spoint,0,_sradius,10] call BIS_fnc_findSafePos;
        _grp=[_safepos,_side,_select] call BIS_fnc_spawnGroup;
    };
    // Setup Group
    _grp deleteGroupWhenEmpty true;
	if !(isNil "_callsign") then {_grp setGroupId _callsign};
    // Check for success
    if !(_success) then {
		// Cleanup
    	systemChat format["NTHAL SPAWN: Error spawning: %1", _grp];
    	_veharray=[];
    	{
    		_veh=vehicle _x;
			if ((_veh != _x) and !(_veh in _veharray)) then { _veharray append _veh };
			deleteVehicle _x;
    	} forEach (units _grp);
    	{
    	  deleteVehicle _x;
    	} forEach _veharray;
    	deleteGroup _grp;
    };
    // return
    _grp;
};