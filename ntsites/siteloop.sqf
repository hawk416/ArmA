NTSITES_fnc_siteloop={
	NTSITES_KEEPALIVE=true;
	while {NTSITES_KEEPALIVE} do {
	  {
	  	/*
	  		Side selection
	  	*/
	  	// Get site info
	  	_side=flagSide _x;
	  	_center=_x getVariable["NTSITES_CENTER",false];
	  	_radius=_x getVariable["NTSITES_RADBASE",false];
	  	_radcon=_x getVariable["NTSITES_RADCON",false];
	  	_marker=_x getVariable ["NTSITES_MARKER", ""];
		_owntime=_x getVariable ["NTSITES_OWNTIME", 0];
		_name=_x getVariable ["NTSITES_NAME", format["Unknown Base at %1", _center]];
		_time=time;
		_ftime=time+5;
		_dtime=daytime;
	    // Check if site is contested
		_allunits = _center nearEntities [["Man","Car", "Tank", "Ship", "Air", "StaticWeapon"], _radcon]; 
		_allunits = _allunits select {(alive _x) and !(isObjectHidden _x) and (isDamageAllowed _x) and (side _x in [east,west,independent])};
		// Skip if area is abandoned
		if (count _allunits == 0) then {
			if (flagSide _x != civilian) then {
				_x setFlagSide civilian;
				_x setVariable["NTSITES_TIMER",_time+_owntime]
			};
			if ((_owntime < _time) and (flagTexture _x != "A3\Data_F\Flags\Flag_WHITE_CO.paa")) then {
				player createDiaryRecord["NTSites", ["Sites",format["%1: %2", [_dtime] call BIS_fnc_timeToString, format["%1 has been abandoned",_name]]]];
				_x setFlagTexture "\A3\Data_F\Flags\Flag_WHITE_CO.paa";
				_marker setMarkerColor "ColorWhite";
			};
			continueWith 0;
		};
		// find most powerfull side
		_newside=civilian;
		_opf={side _x == east} count _allunits;
		_blu={side _x == west} count _allunits;
		_ind={side _x == independent} count _allunits;
		_flagclass="Flag_WHITE_CO.paa";
		switch (selectMax [_opf,_blu,_ind]) do { 
			case _opf : {_flagclass="Flag_RED_CO.paa";_newside=east};
			case _blu : {_flagclass="Flag_BLUE_CO.paa";_newside=west};
			case _ind : {_flagclass="Flag_GREEN_CO.paa";_newside=independent};
		};
		// Find enemies of most powerfull side
		// OLD VERSION
		// _enemysides=[east,west,independent];
		// if ([_newside, independent] call BIS_fnc_sideIsFriendly) then {_enemysides=_enemysides-[independent]};
		// if ([_newside, east] call BIS_fnc_sideIsFriendly) then {_enemysides=_enemysides-[east]};
		// if ([_newside, west] call BIS_fnc_sideIsFriendly) then {_enemysides=_enemysides-[west]};
		_enemysides=_side call BIS_fnc_enemySides;
		_enemies=_allunits findif {side _x in _enemysides};
		/* ALT Enemy detection
		// _enemies=_allunits findIf {
		// 	_enemy=_x findNearestEnemy _center;
		// 	// _ret=false;
		// 	if (!(isNull(_enemy)) and (_enemy distance2D _center < _radcon)) then {continueWith true};
		// 	false;
		// 	};
		// Mode 3
		// Options: BIS_fnc_enemyTargets, knowsAbout, nearTargets, combatMode, findNearestEnemy, BIS_fnc_enemyDetected
		{
			if(_x call BIS_fnc_enemyDetected) then {_enemies=-1;break};
		} forEach _allDefnders;
		*/
		// skip if area is contested
		if (_enemies != -1) then {
			if (flagTexture _x != toLower "a3\signs_f\signspecial\data\checker_flag_co.paa") then {
				_x setFlagTexture "\a3\signs_f\signspecial\data\checker_flag_co.paa";
				_marker setMarkerColor "ColorOrange";
				player createDiaryRecord["NTSites", ["Sites",format["%1: %2 is under attack", [_dtime] call BIS_fnc_timeToString, _name]]];
			};
			continue;
		};
		// Timers
		_prodtime=_x getVariable ["NTSITES_PRODTIME",0];
		_reinftime=_x getVariable ["NTSITES_REINFTIME",0];
		_healtime=_x getVariable ["NTSITES_HEALTIME",0];
		_repairtime=_x getVariable ["NTSITES_REPAIRTIME",0];
		_rearminftime=_x getVariable ["NTSITES_REARMINFTIME",0];
		_rearmstatime=_x getVariable ["NTSITES_REARMSTATIME",0];
		_rearmvehtime=_x getVariable ["NTSITES_REARMVEHTIME",0];
		_refueltime=_x getVariable ["NTSITES_REFUELTIME",0];
		// Check if side has changed
		if (_side != _newside) then {
			_x setVariable["NTSITES_TIMER",_time+_owntime];
			_x setFlagSide _newside;
			player createDiaryRecord["NTSites", ["Sites",format["%1: %2 has taken %4 from %3", [_dtime] call BIS_fnc_timeToString, _newside, _side, _name]]];
			// _x setVariable ["NTSITES_PRODNEXT", _time+_prodtime];
			_x setVariable ["NTSITES_REINFNEXT", _time+_reinftime];
			_x setVariable ["NTSITES_HEALNEXT", _time+_healtime];
			_x setVariable ["NTSITES_REPAIRNEXT",_time+_repairtime];
			_x setVariable ["NTSITES_REARMINFNEXT", _time+_rearminftime];
			_x setVariable ["NTSITES_REARMSTANEXT", _time+_rearmstatime];
			_x setVariable ["NTSITES_REARMVEHNEXT", _time+_rearmvehtime];
			_x setVariable ["NTSITES_REFUELNEXT", _time+_refueltime];
		};
		/*
			Base Operations
		*/
		// Check for time owned and execute base operations
		if (_x getVariable ["NTSITES_TIMER",_ftime] < _time) then {
			// Next time
			_prodlast=_x getVariable ["NTSITES_PRODNEXT", _ftime];
			_reinflast=_x getVariable ["NTSITES_REINFNEXT", _ftime];
			_heallast=_x getVariable ["NTSITES_HEALNEXT", _ftime];
			_repairlast=_x getVariable ["NTSITES_REPAIRNEXT", _ftime];
			_rearminflast=_x getVariable ["NTSITES_REARMINFNEXT", _ftime];
			_rearmstalast=_x getVariable ["NTSITES_REARMSTANEXT", _ftime];
			_rearmvehlast=_x getVariable ["NTSITES_REARMVEHNEXT", _ftime];
			_refuellast=_x getVariable ["NTSITES_REFUELNEXT", _ftime];
			// Setup flag
			if (flagTexture _x != format["A3\Data_F\Flags\%1", _flagclass]) then {
				_x setFlagTexture format["\A3\Data_F\Flags\%1", _flagclass];
				_marker setMarkerColor format["Color%1",_side];
				player createDiaryRecord["NTSites", ["Sites",format["%1: %2 is operational", [_dtime] call BIS_fnc_timeToString, _name]]];
			};
			// Process production
			if (_prodlast < _time) then {
			 	_prod=_x getVariable["NTSITES_PROD",[0,0,0]];
				[_side, _prod] call NTSITES_fnc_modrsc;
				_x setVariable["NTSITES_PRODNEXT",_time + (_x getVariable ["NTSITES_PRODTIME",60])];
			};
			/*
				Reinforcements
			*/
			// Get all statics
			_allstatics = nearestObjects [_center , ["StaticWeapon"], _radius];
			if (_reinflast < _time) then {
			 	_patrols=_x getVariable["NTSITES_PATROLLIST",[]];
			 	_patrolmax=_x getVariable["NTSITES_PATROLMAX",0];
			 	_patrolnum=0;
				// Cleanup unit lists
				{
					_patrolnum=_patrolnum+({alive _x} count (units _x));
					if ((units _x) findIf {alive _x} == -1) then {_patrols=_patrols -[_x]; deleteGroup _x};
				} forEach _patrols;
				if (_patrolnum < _patrolmax) then {
					// Spawn patrol
					_grp=grpNull;
					switch (_side) do { 
						case east : {_grp=[_side, PATROLPOOL_RED, [], _center, _radius] call nt_fnc_spawngroup};
						case west : {_grp=[_side, PATROLPOOL_BLU, [], _center, _radius] call nt_fnc_spawngroup};
						case independent : {_grp=[_side, PATROLPOOL_GRN, [], _center, _radius] call nt_fnc_spawngroup};
					};
					// if (random 1 > 0.90) then {} // chance to become a garison
					[_grp, _center, random [_radius,_radcon-_radius,_radcon]] call NTSITES_fnc_taskPatrol;
					_patrols append [_grp];
					_x setVariable["NTSITES_PATROLLIST", _patrols];
					player createDiaryRecord["NTSites", ["Sites",format["%1: %4 received patrol (%3 units): %2 ", [_dtime] call BIS_fnc_timeToString, _grp, count (units _grp), _name]]];
				};
				// Create unit for statics
				_selectedStatic=_allstatics findIf { _x emptyPositions "Gunner" > 0};
				if (_selectedStatic != -1) then {
					// spawn unit
					_grp=grpNull;
					switch (_side) do { 
						case east : {_grp=[_side, STATICPOOL_RED, [], _center, _radius] call nt_fnc_spawngroup};
						case west : {_grp=[_side, STATICPOOL_BLU, [], _center, _radius] call nt_fnc_spawngroup};
						case independent : {_grp=[_side, STATICPOOL_GRN, [], _center, _radius] call nt_fnc_spawngroup};
					};
					// assign to static
					_selectedStatic=(_allstatics select _selectedStatic);
					_unit=((units _grp) select 0);
					_unit assignAsGunner _selectedStatic;
					_unit moveInGunner _selectedStatic;
					// [_unit] orderGetIn true; // Makes unit move, but sometime it cannot enter;
					player createDiaryRecord["NTSites", ["Sites",format["%1: %4 manned static: %2 - %3 ",
																[_dtime] call BIS_fnc_timeToString,
																getText(configfile >> "CfgVehicles" >> typeOf _selectedStatic >> "DisplayName"),
																name _unit, _name]]];
				};
				_x setVariable["NTSITES_REINFNEXT",_time + _reinftime];
			};
			/*
				Heal/Rearm/Refuel
			*/
			// Rearm static
			// if (_rearmstalast < _time) then {
			// 	_static=_allstatics findIf {!(someAmmo _x)};
			// 	(selectRandom _allstatics) setVehicleAmmoDef 1;
			// 	_x setVariable["NTSITES_REARMSTANEXT",_time + _rearmstatime];
			// };
			// Collect man inside the base
			_allunits = _center nearEntities [["Man","Car", "Tank", "Ship", "Air", "StaticWeapon"], _radius]; 
			_allunits = _allunits select {(alive _x) and !(isObjectHidden _x) and (isDamageAllowed _x) and (side _x == _side)};
			_allman=_allunits;
			// Get the actual soldier
			{
			  if !(_x isKindOf "Man") then {
			  	_allman=_allman - [_x];
			  	// filted dead ones
			  	{
				  	if (alive _x) then {_allman append [_x]};
			  	} forEach (crew _x);
			  };
			} forEach _allman;
			hint format["allman: %1", _allman];
			// Heal own units
			if (_heallast < _time) then {
				_unit=_allman findif {damage _x > 0};
				if (_unit != -1) then {
					_unit=(_allman select _unit);
					_unit setDamage 0;
					systemChat format["healing unit: %1 %2", _unit, name _unit];
					_x setVariable["NTSITES_HEALNEXT",_time + _healtime];
				};
			};
			// Rearm unit
			if (_rearminflast < _time) then {
				_unit=_allman findif {!(someAmmo _x)};
				if (_unit != -1) then {
					_unit=(_allman select _unit);
					_unit setAmmo 1;
					systemChat format["Rearming unit: %1 %2", _unit, name _unit];
					_x setVariable["NTSITES_REARMINFNEXT",_time + _rearminftime];
				};
			};
			// Get all vehicles
			_allveh=_allunits select{!(_x isKindOf "Man")};
			// Refuel Vehicle
			if (_refuellast < _time) then {
				_veh=_allveh findif {fuel _x < 0.9};
				if (_veh != -1) then {
					_veh=(_allveh select _veh);
					_veh setFuel 1;
					systemChat format["Refueling vehicle: %1 %2", _veh, name _veh];
					_x setVariable["NTSITES_REFUELNEXT",_time + _refueltime];
				};
			};
			// Rearm Vehicle			
			if (_rearmvehlast < _time) then {
				_veh=_allveh findif {!(someAmmo _x)};
				if (_veh != -1) then {
					_veh=(_allveh select _veh);
					_veh setVehicleAmmoDef 1;
					systemChat format["Rearming vehicle: %1 %2", _veh, name _veh];
					_x setVariable["NTSITES_REARMVEHNEXT",_time + _rearmvehtime];
				};
			};
			// Repair vehicle
			if (_repairlast < _time) then {
				_veh=_allveh findif {damage _x > 0};
				if (_veh != -1) then {
					_veh=(_allveh select _veh);
					_veh setDamage 0;
					systemChat format["Repaired vehicle: %1 %2", _veh, name _veh];
					_x setVariable["NTSITES_REPAIRNEXT",_time + _repairtime];
				};
			};
		};
	  } forEach NTSITES_SITES;
	};
};