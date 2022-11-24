/*
	Init file for SP HAL Demo Mission

	Docs & Resources:
	- https://forums.bohemia.net/forums/topic/220327-nr6-pack-hal-artificial-leader-evolved/
*/

/*
	Imports
*/

/*
	Functions
*/
NT_HAL_CONSTREINF=[];
nt_hal_fnc_constreinf_loop={
	private ["_respawn"];
	_respawn=[];
	while {true} do {
		{
			if ((units _x) findIf {alive _x} == -1) then {
				// get data
				_data=_x getVariable "NT_HAL_CONSTREINF_DATA";
				_ttr=_data select 6;
				// Remove grp from dead check and append to respawn check
				NT_HAL_CONSTREINF=NT_HAL_CONSTREINF - [_x];
				_respawn append [[time+_ttr, _data]];
				// Remove from leaders
				[_x, _data select 2] call nt_hal_fnc_remFromHQ;
				systemChat format["%1 is down!", _x];
				deleteGroup _x;
			};
		} forEach NT_HAL_CONSTREINF;
		{
			_tor=_x select 0;
			_data=_x select 1;
			if (_tor < time) then {
				// Respawn
				_newgrp=_data call nt_hal_fnc_constreinf;
				if ((count (units _newgrp)) > 0) then {
					systemChat format["Respawned: %2", _grp, _newgrp];
					// Remove from respawn
					_respawn=_respawn - [_x];
				};
			};
		} forEach _respawn;
		sleep 5;
	};
};
nt_hal_fnc_getVehSize={
	params ["_classname"];
	private ["_sizes"];
	// Create vehicle
	_veh = _classname createVehicleLocal [0,0,0];
	_veh allowDamage false;
	hideObject _veh;
	// Measure it and delete
	(boundingBoxReal _veh) params ["_arg1","_arg2"];
	_width = abs ((_arg2 select 0) - (_arg1 select 0));
	_length = abs ((_arg2 select 1) - (_arg1 select 1));
	_height = abs ((_arg2 select 2) - (_arg1 select 2));
	_sizes=[_width,_length,_height];
	deleteVehicle _veh;
	// Return
	(_sizes)
};
nt_hal_fnc_findsafeposition={
	params["_classname", "_center", "_radius"];
	private ["_safepos", "_sizes"];
	// Get sizes [width, length, height]
	_sizes=_classname call nt_hal_fnc_getVehSize;
	// find bigger between width and height
	_objsize=(_sizes select 0) max (_sizes select 1);
	// [center, minDist, maxDist, objDist, waterMode, maxGrad, shoreMode, blacklistPos, defaultPos] call BIS_fnc_findSafePos
	if (_classname isKindOf "Man") then {_safepos=[_center, 0, _radius, _objsize, 0, 0, 0] call BIS_fnc_findSafePos};
	if (_classname isKindOf "Car") then {_safepos=[_center, 0, _radius, _objsize, 0, 0.75, 0] call BIS_fnc_findSafePos};
	if (_classname isKindOf "Armor") then {_safepos=[_center, 0, _radius, _objsize, 0, 0.5, 0] call BIS_fnc_findSafePos};
	if (_classname isKindOf "Air") then {_safepos=[_center, 0, _radius, _objsize, 0, 0.25, 0] call BIS_fnc_findSafePos};
	if (_classname isKindOf "Boat") then {_safepos=[_center, 0, _radius, _objsize, 2, 0, 0] call BIS_fnc_findSafePos};
	// check safepos
	if ((count _safepos) == 3) then {_safepos=nil};
	// systemChat format["Found space for: %1 of size: %2 at: %3", _classname, _objsize, _safepos ];
	//return
	_safepos;
};
nt_hal_fnc_spawngroup={
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
nt_hal_fnc_constreinf={
	params["_side", "_pool", "_leaders", "_spoint", "_sradius", "_rpoint", "_ttr", "_code", "_callsign"];
	// Create group and append to watcher
	_grp=[_side, _pool, _leaders, _spoint, _sradius, _callsign] call nt_hal_fnc_spawngroup;
	if ((count (units _grp)) < 1) exitWith {systemChat "NTHAL ConstReinf: Could not spawn units";deleteGroup _grp; nil};
    _grp setVariable["NT_HAL_CONSTREINF_DATA", [_side, _pool, _leaders, _spoint, _sradius, _rpoint, _ttr, _code, _callsign] ];
    NT_HAL_CONSTREINF append [_grp];
    // Add group to leaders
    [_grp, _leaders] call nt_hal_fnc_addToHQ;
    // Set up group
    if !(isNil "_rpoint") then {_grp addWaypoint [_rpoint,10]};
    if !(isNil "_code") then {_grp call _code};
    // Return
    _grp;
};
/*  Description: Adds group to HQ Leader
	Params:
		0 - _grp - Group or Unit
		1 - _leaders - Array of strings, (HQA-HQH): HAL HQ Leaders array
*/
nt_hal_fnc_addToHQ={
	params["_grp", "_leaders"];
	private["_included","_leadergrp", "_varname"];
	{
		if (_x == "HQA") then {
			_varname="RydHQ_Included";
			_leadergrp=(group (missionNamespace getVariable "LeaderHQ"));
		} else {
			_varname=format["Ryd%1_Included", _x];
			_leadergrp=(group (missionNamespace getVariable format["Leader%1",_x]));
		};
		_included=(missionNamespace getVariable [_varname, []]);
		_included pushBack _grp;
		_leadergrp setvariable ["RydHQ_Included",_included];
	    missionNamespace setVariable [_varname, _included, true];
	} forEach _leaders;
};
nt_hal_fnc_remFromHQ={
	params["_grp", "_leaders"];
	private["_included","_leadergrp", "_varname"];
	{
		if (_x == "HQA") then {
			_varname="RydHQ_Included";
			_leadergrp=(group (missionNamespace getVariable "LeaderHQ"));
		} else {
			_varname=format["Ryd%1_Included", _x];
			_leadergrp=(group (missionNamespace getVariable format["Leader%1",_x]));
		};
		_included=(missionNamespace getVariable [_varname,[]]);
		_included - [_grp];
		_leadergrp setvariable ["RydHQ_Included",_included];
	    missionNamespace setVariable [_varname, _included, true];
	} forEach _leaders;	
};

NT_HAL_baseMngr={
	params["_side", "_center", "_radius", "_patrol_num", "_garison_num", "_owntime", "_rspwntime",
	"_blu_patrol_pool", "_blu_static_pool", "_blu_garison_pool",
	"_opf_patrol_pool", "_opf_static_pool", "_opf_garison_pool",
	"_ind_patrol_pool", "_ind_static_pool", "_ind_garison_pool"];

	private["_patrols", "_statics", "_garison", "_since", "_lastspwn", "_patrol_pool", "_static_pool","_garison_pool"];
	_patrols=[];
	_statics=[];
	_garison=[];
	_since=time;
	_lastspwn=time+_rspwntime;
	// TODO: Setup Dynamic Marker
	while {true} do {
		// Determine who owns the base
		// _allunits = _center nearObjects ["Man", _radius];
		_allunits = _pos nearEntities ["AllVehicles", _radius]; 
		_allunits = _allunits select {(alive _x) and !(isObjectHidden _x) and (isDamageAllowed _x)};
		_opf = east countSide _allunits;
		_blu = west countSide _allunits;
		_ind = independent countSide _allunits;
		if ((_blu > (_opf max _ind )) and (_side!=west)) then {_side=west;_since=time+_owntime;_patrol_pool=_blu_patrol_pool;_static_pool=_blu_static_pool;_garison_pool=_blu_garison_pool};
		if ((_opf > (_blu max _ind )) and (_side!=east)) then {_side=east;_since=time+_owntime;_patrol_pool=_opf_patrol_pool;_static_pool=_opf_static_pool;_garison_pool=_opf_garison_pool};
		if ((_ind > (_opf max _blu )) and (_side!=independent)) then {_side=independent;_since=time+_owntime;_patrol_pool=_ind_patrol_pool;_static_pool=_ind_static_pool;_garison_pool=_ind_garison_pool};
		_enemyNum=((units _side) select 0) countEnemy _allunits;
		// Check for time and enemies
		if (_enemyNum > 0) then {_since=time}; // Reset timers if there are enemies
		if ((time > _since) and (_enemyNum == 0)) then {
			systemChat format["patrols: %1 statics: %2 building: %3", _patrols, _statics, _garison];
			// Cleanup dead units
			{
				if ((units _x) findIf {alive _x} == -1) then {_patrols=_patrols -[_x]};
			} forEach _patrols;
			{
			  if !(alive _x) then {_statics -[_x]};
			} forEach _statics;
			{
			  if !(alive _x) then {_garison_pool -[_x]};
			} forEach _garison;
			// Heal a random unit
			_unit=_allunits findif {(damage _x > 0) and (side _x == _side)};
			if (_unit != -1) then {(_allunits select _unit) setDamage 0; systemChat "healing unit"};
			// TODO: Re-Arm units

			// Spawn units if timer passed
			if (time > _lastspwn) then {
				// Create patrols
				if (count _patrols < _patrol_num) then {
					// Spawn patrol
					_grp = [_side, _patrol_pool, [], _center, _radius] call nt_hal_fnc_spawngroup;
					[_grp, _center, _radius] call BIS_fnc_taskPatrol;
					_patrols append [_grp];
					systemChat format["Created patrol: %1", _grp];
				};
				// Rearm a static
				_allstatics = nearestObjects [_center , ["StaticWeapon"], _radius ];
				(selectRandom _allstatics) setVehicleAmmoDef 1;
				// Create unit for statics
				_selectedStatic=_allstatics findIf { _x emptyPositions "Gunner" > 0};
				if (_selectedStatic != -1) then {
					// spawn unit
					_grp = [_side, _static_pool, [], _center, _radius] call nt_hal_fnc_spawngroup;
					// assign to static
					_unit=((units _grp) select 0);
					_unit assignAsGunner (_allstatics select _selectedStatic);
					_unit moveInGunner (_allstatics select _selectedStatic);
					// [_unit] orderGetIn true; // Makes unit move, but sometime it cannot enter;
					systemChat format["Created static unit: %1", name _unit];
				};
				// Create units for buildings
				_allbuildings = nearestObjects [_center , ["House"], _radius ];
				{
					_allpositions = _x buildingPos -1;

				} forEach _allbuildings;
				_lastspwn=time+_rspwntime;
			};
		};
		sleep 1;
	};
};
NT_fnc_findclass={
	params["_item"];
    switch true do
    {
        case(isClass(configFile >> "CfgMagazines" >> _item)): {"CfgMagazines"};
        case(isClass(configFile >> "CfgWeapons" >> _item)): {"CfgWeapons"};
        case(isClass(configFile >> "CfgVehicles" >> _item)): {"CfgVehicles"};
        case(isClass(configFile >> "CfgGlasses" >> _item)): {"CfgGlasses"};
        case(isClass(configFile >> "CfgItems" >> _item)): {"CfgItems"};
    };
};
NT_fnc_findHC={
	params["_leader"];
	private["_return"];
	_return=[];
	{
		if (_leader == (hcLeader _x)) then {_return append [_x]};
	} forEach allGroups;
	_return;
};
/*
	Main
*/
// [] spawn nt_hal_fnc_constreinf_loop;
// [independent, INDEP01, [LeaderHQC], (getMarkerPos INDEP_SPWN), 10, (getMarkerPos INDEP_SPWN)] call nt_hal_fnc_constreinf;
// [independent, INDEP01, [LeaderHQC], (getPos player), 100, (getPos player)] call nt_hal_fnc_constreinf;
// params["_side", "_pool", "_leaders", "_spoint", "_sradius", "_rpoint", "_ttr", "_code"];
// [independent, INDEP01, ["HQC"], INDEP_SPWN, 10, INDEP_SPWN, 30, {hint "spawned!"}, ["Fox 1-1"]] call nt_hal_fnc_constreinf;
// [(getPos player), 20, independent, INDEP01, [LeaderHQC], (getPos player), ""] call SpawnRGroup
// [east, OPFGRP01, ["HQD"], OPF_SPWN, 10, OPF_SPWN, 30, nil, ["Lift 1-1"]] call nt_hal_fnc_constreinf;
// [independent, INDEP01, ["HQC"], INDEP_SPWN, 10, INDEP_SPWN, 30, nil, ["Fox 1-1"]] call nt_hal_fnc_constreinf; 
// [west, getPos player, 200, 0.5, 3, INDEP01, INDEPUNIT01, INDEPUNIT01] call NT_HAL_baseMngr;
// [west, getPos player, 200, 3, 2, 10, 5,
// 	INDEP01, INDEPUNIT01, INDEP01,
// 	INDEP01, INDEPUNIT01, INDEP01,
// 	INDEP01, INDEPUNIT01, INDEP01] spawn NT_HAL_baseMngr;