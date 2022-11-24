/*	init.sqf for NTECH Revive

	Links & Resources:
	- https://github.com/DreadedEntity/DE_Revive
	- https://forums.bohemia.net/forums/topic/205515-handledamage-event-handler-explained/
	- https://forums.bohemia.net/forums/topic/238336-a-barebones-but-full-featured-minimal-code-revive-system/
*/
/* Move to position and execute command
	Parameters
		0 - _unit : unit to execute the commands on
		1 - _pos : position to move to
		2 - _trap : Code to exec in case of interrup
		3 - _cond : Condifiton (Code) to run before move
		4 - _stop : Code to run after move
		5 - _cmdargs : Arguments to be passed along to the Code
*/
ntech_ai_moveAndExec={
	params ["_unit", "_target", "_cond", "_trap", "_stop", "_cmdargs"];
	private ["_pos", "_mappos", "_leader", "_expdest"];
	// TODO: Check for AI Lock before locking
	_unit setVariable ["NTECH_AILOCK", true, true]; // Lock Mutex
	_pos=getPos _target; // get position in case of object
	_mappos=mapGridPosition _pos;
	if !(_cmdargs call _cond) exitWith { [_unit, "Canceled Move, Condition failed!"] remoteExec ["groupChat", group _unit] }; // call start command
	[_unit, _pos] remoteExec ["moveTo", _unit]; // use moveTo as overrides current command
	[_unit, _pos] remoteExec ["doMove", _unit]; // fills in the waypoint/expdest
	sleep 0.5;
	_expdest = expectedDestination _unit;
	_moveComplete=false;
	if (((_expdest select 0) distance2D _pos) < 1) then {
		// [_unit, format ["Moving to position %1", _mappos]] remoteExec ["groupChat", group _unit];
		// Wait for command to finish
		while {true} do {
			if (moveToCompleted _unit) exitWith { _moveComplete=true};
			if (moveToFailed _unit) exitWith {
				// [_unit, format ["Cannot Move to position %1!", _mappos]] remoteExec ["groupChat", group _unit];
				_moveComplete=false;
			};
			if (((currentCommand _unit) != "MOVE") or !(_expdest isEqualTo (expectedDestination _unit)))  exitWith {
				// [_unit, format ["Move order Interrupted!", _mappos]] remoteExec ["groupChat", group _unit];
				_moveComplete=false;
			};
			if !((lifeState _unit == "HEALTHY") or (lifeState _unit == "INJURED")) exitWith {
				// [_unit, format ["Move order Canceled, I'm down!", _mappos]] remoteExec ["groupChat", group _unit];
				_moveComplete=false;
			};
			if ((_unit distance2D _target) < 2) exitWith {_moveComplete= true};
		};
	} else {
		[_unit, format ["Move order Canceled, following another command", _mappos]] remoteExec ["groupChat", group _unit];
	};
	if !(_moveComplete) exitWith {
		_cmdargs call _trap;
		_unit setVariable ["NTECH_AILOCK", false, true]; // Unlock Mutex
		doStop _unit; //stop here prevents unit from returning to formation
		_unit doFollow (leader _unit);
	};
	// Unit arrive at position
	[_unit, _unit getDir _pos] remoteExec ["setFormDir", _unit];
	sleep 0.5;
	doStop _unit; //stop here prevents unit from returning to formation
	[_unit, _unit getDir _pos] remoteExec ["setDir", _unit]; // force set direction in case unit doesn't turn
	_cmdargs call _stop; // call the end command
	_unit doFollow (leader _unit);
	_unit setVariable ["NTECH_AILOCK", false, true]; // Unlock Mutex
};
ntech_revive_reviveAction={
	params ["_target", "_caller", "_actionId", "_arguments"];
	//Check if caller has FAK in FirstAidKit
	if !("FirstAidKit" in (items _caller)) exitWith { _caller groupChat format["Cannot revive %1, no FirstAidKit in inventory", name _target]};
	_caller removeItem "FirstAidKit";
	// _caller groupChat format["Cover Me! I'm reviving %1!", name _target];
	// play moves
	_caller setFormDir (_caller getDir _target);
	_caller playMove "AinvPknlMstpSnonWnonDnon_medic1";
	_caller playMove "AinvPknlMstpSnonWnonDnon_medic2";
	_caller playMove "AinvPknlMstpSnonWnonDnon_medicEnd";
	sleep 14;
	_caller playMoveNow ""; // stop any animation
	// reset states
	// _target setDamage ((damage _target)-0.25);
	[_target, false] call ntech_revive_setState;
	_target setVariable["NT_REVIVE_BLEEDING",false];
	_target setDamage 0;
	// send back to leader
	_caller doFollow (leader _caller);
	_target doFollow (leader _target);
};
ntech_revive_healAction={
	params ["_target", "_caller", "_actionId", "_arguments"];
	//Check if caller has FAK in FirstAidKit
	if !("FirstAidKit" in (items _caller)) exitWith { _caller groupChat format["Cannot heal %1, no FirstAidKit in inventory", name _target]};
	// _caller groupChat format["Cover Me! I'm reviving %1!", name _target];
	_caller setFormDir (_caller getDir _target);
	_caller removeItem "FirstAidKit";
	// play moves
	_caller playMove "AinvPknlMstpSnonWnonDnon_medic1";
	sleep 8;
	_target setDamage ((damage _target) - 0.5);
	if (_caller getUnitTrait "Medic") then {
		_target setDamage 0;	
	};
	_caller playMove "AinvPknlMstpSnonWnonDnon_medicEnd";
	sleep 2;
	_caller playMoveNow ""; // stop any animation
	// reset states
	// _target setDamage ((damage _target)-0.25);
	// [_target, false] call ntech_revive_setState;
	// send back to leader
	// _caller doFollow (leader _caller);
	_target doFollow (leader _target);
};
ntech_revive_bleedout={
	private["_unit", "_actionId", "_timemax", "_timestart", "_timenow", "_timepercentage", "_timetolive", "_icon","_color"];
	_unit = _this select 0;
	_actionId = _this select 1;
	_timemax = _this select 2;
	_timestart = time;
	_timenow = time;
	_icon = "a3\ui_f\data\igui\cfg\holdactions\holdaction_revivemedic_ca.paa";
	_unit setDamage 0.98; //for effect
	waitUntil {(lifeState _unit) == "INCAPACITATED"};
	while{((_timenow - _timestart) <= _timemax) and (lifeState _unit == "INCAPACITATED")} do {
		_timenow=time;
		_timepercentage=(_timenow - _timestart)/_timemax; //0-1
		_timetolive=_timemax - (_timenow - _timestart);
		// Draw 3D icon
		if ((_unit distance2D player) < 100) then {
			_color = [1,1-_timepercentage,0,1];
			// if (!isNil {_unit getVariable "DE_REVIVING"}) then {
			// 	_icon = "a3\ui_f\data\igui\cfg\holdactions\holdaction_revive_ca.paa";
			// 	_color = [1,1,0,1];
			// };
			drawIcon3D [_icon, _color, ASLToAGL (aimPos _unit), 1, 1, 1, "", true, 0, "RobotoCondensed", "", true];
		};
		// every N seconds call out for help
		if ((_timetolive mod 60) < 0.02)  then {
			[_unit, format ["I'm down! Position: %1", mapGridPosition _unit]] remoteExec ["groupChat", group _unit];
			// _unit call ntech_revive_callhelp;
			sleep 0.02; // make sure to skip to next number
		};
		sleep 0.01;
	};
	_unit setDamage (0.5+(_timepercentage/2));
	// Reset states and remove actions
	[_unit, false] call ntech_revive_setState;
	_unit removeAction _actionId;
};
ntech_revive_bleedout2={
	private["_unit", "_actionId", "_timemax", "_timestart", "_timenow", "_timepercentage", "_timetolive", "_icon","_color"];
	_unit = _this select 0;
	_actionId = _this select 1;
	_timemax = _this select 2;
	_timestart = time;
	_timenow = time;
	_icon = "a3\ui_f\data\igui\cfg\holdactions\holdaction_revivemedic_ca.paa";
	_unit setDamage 0.98; //for effect
	// waitUntil {(lifeState _unit) == "INCAPACITATED"};
	while{((_timenow - _timestart) <= _timemax) and (_unit getVariable["NT_REVIVE_BLEEDING",false])} do {
		_timenow=time;
		_timepercentage=(_timenow - _timestart)/_timemax; //0-1
		_timetolive=_timemax - (_timenow - _timestart);
		// Draw 3D icon
		if ((_unit distance2D player) < 100) then {
			_color = [1,1-_timepercentage,0,1];
			// if (!isNil {_unit getVariable "DE_REVIVING"}) then {
			// 	_icon = "a3\ui_f\data\igui\cfg\holdactions\holdaction_revive_ca.paa";
			// 	_color = [1,1,0,1];
			// };
			drawIcon3D [_icon, _color, ((getPos _unit) vectorAdd [0,0,1]), 1, 1, 1, format["%1",round _timetolive], 0];//, false, 1, "RobotoCondensed", "center", true];
		};
		// every N seconds call out for help
		if ((_timetolive mod 60) < 0.02)  then {
			[_unit, format ["I'm down! Position: %1", mapGridPosition _unit]] remoteExec ["groupChat", group _unit];
			// _unit call ntech_revive_callhelp;
			sleep 0.02; // make sure to skip to next number
		};
		sleep 0.01;
		if (_unit == player) then {
			if !(stance _unit in ["PRONE", "UNDEFINED"]) then {_unit switchMove "AidlPpneMstpSnonWnonDnon_AI";_unit playMoveNow "AidlPpneMstpSnonWnonDnon_AI"; sleep 2.13};
			if !(cameraView in ["INTERNAL", "EXTERNAL"]) then {_unit switchCamera "Internal"};
			if (isActionMenuVisible) then {hint "hello";showCommandingMenu "RscGroupRootMenu"; showCommandingMenu ""};
		};
	};
	// _unit setDamage (0.5+(_timepercentage/2));
	// Reset states and remove actions
	// [_unit, false] call ntech_revive_setState;
	if (_unit getVariable["NT_REVIVE_BLEEDING",true]) then {_unit setDamage 1};
	_unit setVariable["NT_REVIVE_BLEEDING",false];
	_unit removeAction _actionId;
};
ntech_revive_setState={
	params ["_unit", "_state"];
	_unit setCaptive _state;
	_unit allowDamage !_state;
	_unit setUnconscious _state;
};
ntech_revive_dmgHandler={
	params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];
	if (_damage >= 0.99) then {
		// Check the lifestate
		if !(lifeState _unit == "INCAPACITATED") then {
			// unit is incapacitated, disable damage to stop additional event handlers from spawning.
			[_unit, true] call ntech_revive_setState;
			// _unit groupChat "I'm down!";
			// [_unit, _team, _instigator, _projectile] call ntech_revive_unitswitch;
			_actionId =_unit addAction[format["Revive %1", name _unit, [], -1], ntech_revive_reviveAction];
			[_unit, _actionId ,120] spawn ntech_revive_bleedout2;
		}; // End IF lifestate
		_damage = 0;
	}; // End If damage
	_damage;
};
ntech_revive_dmgHandler2={
	params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];
	if (_damage >= 0.99) then {
		// Check the lifestate
		if !(_unit getVariable["NT_REVIVE_BLEEDING",false]) then {
			hint format["%1 is down", _unit];
			// unit is incapacitated, disable damage to stop additional event handlers from spawning.
			_unit setVariable["NT_REVIVE_BLEEDING",true];
			if !(vehicle _unit == _unit) then {moveOut _unit};
			if !(_unit == player) then {_unit setUnconscious true};
			// [_unit, true] call ntech_revive_setState;
			// _unit groupChat "I'm down!";
			// [_unit, _team, _instigator, _projectile] call ntech_revive_unitswitch;
			_actionId =_unit addAction[format["Revive %1", name _unit, [], -1], ntech_revive_reviveAction];
			[_unit, _actionId ,120] spawn ntech_revive_bleedout2;
			// NT_REVIVE_BLEEDERS append _unit;
		}; // End IF lifestate
		_damage = 0;
	}; // End If damage
	_damage;
};
ntech_revive_addHoldActions = {
	[
		_this,
		"Heal Self",
		"a3\ui_f\data\igui\cfg\holdactions\holdaction_revivemedic_ca.paa",
		"a3\ui_f\data\igui\cfg\holdactions\holdaction_revivemedic_ca.paa",
		'(_target == _this) and ("Medikit" in (items _this)) and (lifeState _this == "INCAPACITATED")',
		"_this distance _target < 3",
		{},
		{},
		{
			_target removeItem "Medikit";
			_target setDamage 0.25;
			_target setUnconscious false;
			_target setCaptive false;
			_target allowDamage true;
		},
		{},
		[],
		8,
		9999,
		false,
		true
	] call BIS_fnc_holdActionAdd; // remoteExec ["BIS_fnc_holdActionAdd", 0, _target];	// MP compatible implementation
	[
		_this,
		"Call for Help",
		"a3\ui_f\data\igui\cfg\holdactions\holdaction_revive_ca.paa",
		"a3\ui_f\data\igui\cfg\holdactions\holdaction_revive_ca.paa",
		'(_target == _this) and (lifeState _this == "INCAPACITATED")',
		"_this distance _target < 3",
		{},
		{},
		{
			_target call ntech_revive_callhelp
		},
		{},
		[],
		3,
		10000,
		false,
		true
	] call BIS_fnc_holdActionAdd;
	[
		_this,
		"Switch units",
		"",
		"",
		'(_target == _this) and (lifeState _this == "INCAPACITATED")',
		"_this distance _target < 3",
		{},
		{},
		{
			private _idc = 4391;
			private _idcbutton= 4392;
			createDialog "ntech_revive_unitswitch";
			// Hide the nonfunctional stuff
			ctrlEnable [_idc,true];
			ctrlEnable [_idcbutton,true];
			// ctrlEnable [_idc_ntech_garage_button_left,false];
			// ctrlShow [_idc_ntech_garage_listvehicle,false];
			// ctrlShow [_idc_ntech_garage_description,false];
			// ctrlShow [_idc_ntech_garage_button_left,false];
			ctrlShow [_idcbutton,true];
			ctrlShow [_idc,true];
			// ctrlSetText [_idc_ntech_garage_button_right, "Done"];
			// ((findDisplay _idd_ntech_garage) displayCtrl _idc_ntech_garage_button_right) ctrlAddEventHandler["MouseButtonClick",{closeDialog 0}];
			waitUntil {dialog};
			lnbClear _idc;
			_team=[_target];
			_index = lbAdd [_idc, format ["%1 %2", [_target, "displayNameShort"] call BIS_fnc_rankParams, name _target]];
			_icon=getText (configfile >> "CfgVehicles" >>  typeof _target >> "icon");
			_icon=getText (configFile >> "CfgVehicleIcons" >> _icon);
			lbSetPicture [_idc, _index, _icon]; //"\a3\Ui_f\data\Map\Markers\Military\warning_CA.paa"
			{
				_index = lbAdd [_idc, format ["%1 %2", [_x, "displayNameShort"] call BIS_fnc_rankParams, name _x]];
				// lbSetData [_idc, _index, _x call BIS_fnc_objectVar]; // Test this
				// lbSetData [_idc, _index, "somename"]; // Test this
				_icon=getText (configfile >> "CfgVehicles" >>  typeof _x >> "icon");
				_icon=getText (configFile >> "CfgVehicleIcons" >> _icon);
				lbSetPicture [_idc, _index, _icon]; //"\a3\Ui_f\data\Map\Markers\Military\warning_CA.paa"
				lbSetPictureRight[_idc, _index, getText (configfile >> "CfgWeapons" >>   primaryWeapon _x >> "picture")];
				// ((findDisplay 4390) displayCtrl _idc) lbSetTextRight[_index, "hello"];
				// lbSetColor[_idc, _index, [0,1,1,1]];
				// lbSetColorRight[_idc, _index, [0,1,1,1]];
				// lbSetPictureColor[_idc, _index, [0,1,1,1]];
				_team append [_x];
			} forEach ((units (group _target))-[_target]);
			lbSetCurSel [_idc, 0];
			localNamespace setVariable ["ntech_revive_goats", _team];
			// [4391, [["Item1", "item1"], ["Item2", "item2"]]] call ntech_gui_setList;
			// sleep 0.1;
			[{
				// private _index=(lbCurSel 4391);
				_index=localNamespace getVariable ["ntech_revive_goat", 0];
				_goats=localNamespace getVariable ["ntech_revive_goats", [player]];
				// systemchat format["Index: %1 | Unit: %2 | Team: %3", _index, _goats select _index ,_goats];
				// systemChat format["unit: %1  |  position: %2", (_goats select _index), getPos (_goats select _index)];
				getPos (_goats select _index);
			}, {(lifestate _this) == "INCAPACITATED"}, _target, [10,10]] execVM "ntech-gui\ntech_gui_camera_orbitalctrl.sqf";
			waitUntil {!dialog};
			_index=localNamespace getVariable ["ntech_revive_goat", 0];
			// _target disableAI "MOVE";
			// _target setUnconscious false;
			_goat=(_team select _index);
			_textlayer="normal" cutText [format["%1 %2 had died",[_goat, "displayNameShort"] call BIS_fnc_rankParams, name _goat], "BLACK OUT", 3]; 
			sleep 3;
			[_target, _goat] call ntech_revive_switchUnit;
			_textlayer cutFadeOut 1.5;
		},
		{},
		[],
		1,
		9998,
		false,
		true
	] call BIS_fnc_holdActionAdd;
};
ntech_revive_canRevive={
	params["_unit"];
	private	_okcmds=["","WAIT","HIDE","MOVE","STOP","EXPECT"];
	private _okstates=["HEALTHY", "INJURED"];
	if !(((currentCommand _unit) in _okcmds) and ((lifeState _unit) in _okstates)) exitWith {false};
	if !("FirstAidKit" in (items _unit)) exitWith {false};
	if ((_unit getVariable ["NTECH_AILOCK", true]) == true) exitWith {false};
	// hint format["Unit: %1 State: %2 Cmd: %3 FAK: %4", _unit, currentCommand _unit, lifeState _unit, ("FirstAidKit" in (items _unit))];
	true;
};
ntech_revive_healLoop={
	params["_unit", "_ttl", "_maxdist"];
	private["_timestart", "_besttgt", "_bestdist", "_distance"];
	_timestart=time;
	_unit groupChat "Cover me, healing team!";
	while {(time < (_timestart + _ttl))} do {
		// Check unit status and items
		if (_unit call ntech_revive_canRevive) then {
			_besttgt=objNull;
			_bestdist=_maxdist;
			// find nearest incapaccitated
			{
				// check unit lifestate
				if ((lifeState _x) == "INJURED") then {
					_distance=_unit distance2D _x;
					// compare to previous best
					if ((_distance < _bestdist) and (_distance <= _maxdist)) then {
						_besttgt=_x;
						_bestdist=_distance;
					};
				};
			} forEach (units (group _unit));
			if !(isNull _besttgt) then {
				_unit groupChat format["Cover me, going to heal %1", (name _besttgt)];
				doStop _besttgt;
				_besttgt disableAI "MOVE";
				[	_unit, // caller 
					_besttgt, // target
					{true}, // condition/start
					{params["_besttgt", "_unit"];_unit groupChat format["Couldn't get to heal %1", (name _besttgt)];}, 	 // interrupt
					{_this call ntech_revive_healAction}, // execcmd/finish
					[_besttgt, _unit]
				] call ntech_ai_moveAndExec;
				waitUntil{ (lifestate _besttgt) != "INJURED"};
				_besttgt enableAI "MOVE";
				_unit doFollow (leader _unit);
			};
		};
		sleep 5;
	};
	_unit groupChat format["Finished healing nearby", (name _besttgt)];
};
ntech_revive_reviveLoop={
	params["_unit", "_ttl", "_maxdist"];
	private["_timestart", "_besttgt", "_bestdist", "_distance"];
	_timestart=time;
	_unit groupChat "Cover me, reviving team!";
	while {(time < (_timestart + _ttl))} do {
		// Check unit status and items
		if (_unit call ntech_revive_canRevive) then {
			_besttgt=objNull;
			_bestdist=_maxdist;
			// find nearest incapaccitated
			{
				// check unit lifestate
				if ((lifeState _x) == "INCAPACITATED") then {
					_distance=_unit distance2D _x;
					// compare to previous best
					if ((_distance < _bestdist) and (_distance <= _maxdist)) then {
						_besttgt=_x;
						_bestdist=_distance;
					};
				};
			} forEach (units (group _unit));
			if !(isNull _besttgt) then {
				_unit groupChat format["Cover me, going to revive %1", (name _besttgt)];
				[	_unit, // caller 
					_besttgt, // target
					{true}, // condition/start
					{params["_besttgt", "_unit"];_unit groupChat format["Couldn't get to revive %1", (name _besttgt)];}, 	 // interrupt
					{_this call ntech_revive_reviveAction}, // execcmd/finish
					[_besttgt, _unit]
				] call ntech_ai_moveAndExec;
				_unit doFollow (leader _unit);
			};
		};
		sleep 5;
	};
	_unit groupChat format["Finished reviving nearby", (name _besttgt)];
};
ntech_revive_callhelp={
	params["_unit"];
	private["_team", "_bestunit", "_bestdist", "_okcmds", "_okstates", "_distance"];
	_team=(units (group _unit))-[_unit, player]; // Everyone but the unit itself & player
	_bestunit=objNull;
	_bestdist=10000;
	_okcmds=["","WAIT","HIDE","MOVE","STOP","EXPECT"];
	_okstates=["HEALTHY", "INJURED"];
	// Callout
	_unit groupChat format["I'm down and need help here! Position: %1", mapGridPosition _unit];
	// Find nearest unit with FAK if any
	{
		// check unit command and state
		// [_x, format ["CurrCmd: %1 Lifestat: %2 FAK: %3", (currentCommand _x), ((lifeState _x) in _okstates), ("FirstAidKit" in (items _x))]] remoteExec ["groupChat", group _x];
		if (((currentCommand _x) in _okcmds) and ((lifeState _x) in _okstates) and ("FirstAidKit" in (items _x))) then {
			_distance=_unit distance2D _x;
			// compare to previous best
			if (_distance < _bestdist) then {
				_bestunit=_x;
				_bestdist=_distance;
			};
		};
	} forEach _team;
	if !(isNull _bestunit) then {
		[_bestunit, format ["Cover Me! I'm coming to revive %1", name _unit]] remoteExec ["groupChat", group _bestunit];
		[	_bestunit, // caller 
			_unit, // target
			{true}, // condition/start
			{params["_unit", "_bestunit"];_bestunit groupChat format["Couldn't get to revive %1", (name _unit)];}, 	 // interrupt
			{_this call ntech_revive_reviveAction}, // execcmd/finish
			[_unit, _bestunit]
		] spawn ntech_ai_moveAndExec;
	};
};
ntech_revive_switchunit={
	params ["_unit", "_target"];
	private [];
	_target setCaptive true;
	_target allowDamage false;
	// get _target position & status
	_newposition=getPos _target;
	_newdirection=getDir _target;
	_newloadout=getUnitLoadout _target;
	// get _unit position & status
	_unitposition=getPos _unit;
	_unitdirection=getDir _unit;
	_unitloadout=getUnitLoadout _unit;
	// Set unit back to concious and adjust stance before position move
	_unit setUnconscious false;
	_unit playActionNow (stance _target);
	// switch unit and scapegoat
	_target setVehiclePosition [[0,0,0], [], 0, "none"];
	_unit setDir _newdirection;
	_unit setVehiclePosition [_newposition, [], 0, "none"];
	_unit setUnitLoadout _newloadout;
	_target setDir _unitdirection;
	_target setVehiclePosition [_unitposition, [], 0, "none"];
	_target setUnitLoadout _unitloadout;
	// Set damage for unit
	hintSilent "You are invulnerable for 3";
	sleep 1;
	hintSilent "You are invulnerable for 2";
	sleep 1;
	hintSilent "You are invulnerable for 1";
	sleep 1;
	_hitPoints=getAllHitPointsDamage _target; // [ [name], [selection], [damage]]
	for "_i" from 0 to (count (_hitPoints select 0)) do {
		_unit setHitPointDamage [(_hitPoints select 0) select _i,(_hitPoints select 2) select _i];
	};
	// _unit setDamage (damage _target);
	_unit setCaptive false;
	_unit allowDamage true;
	hintSilent "You are NO LONGER invulnerable";
	// set damage to scapegoat
	_target setDamage 1;
	_target setCaptive false;
	_target allowDamage true;
};
ntech_revive_initTeam={
	params["_unit"];
	// hint format["units %1", (units (group _unit))];
	{
		if (isNull (_x getVariable["NTECH_AILOCK", objNull])) then {
			_x addEventHandler ["HandleDamage", ntech_revive_dmgHandler2]; // Damage Handler
			_x call ntech_revive_addHoldActions;
			_x setVariable["NTECH_AILOCK", false, true];

			_x addAction
			[
				"Revive Nearby",	// title
				{
					params ["_target", "_caller", "_actionId", "_arguments"]; // script
					_arguments spawn ntech_revive_reviveloop;
				},
				[_x, 120, 100],		// arguments
				10000,		// priority default (1.5)
				false,		// showWindow - show when nearby
				false,		// hideOnUse
				"",			// shortcut
				'("FirstAidKit" in (items _target)) and ((lifeState _target) in ["HEALTHY", "INJURED"]) and (_target != player)', 	// condition
				-1			// radius - radius to show in (default 50), -1 to disable
				// false,		// unconscious - show if unconcious
				// "",			// selection
				// ""			// memoryPoint
			];
			if (_x getUnitTrait "Medic") then {
				_x addAction
				[
					"Heal Nearby",	// title
					{
						params ["_target", "_caller", "_actionId", "_arguments"]; // script
						_arguments spawn ntech_revive_healloop;
					},
					[_x, 120, 100],		// arguments
					11000,		// priority default (1.5)
					false,		// showWindow - show when nearby
					false,		// hideOnUse
					"",			// shortcut
					'("FirstAidKit" in (items _target)) and ((lifeState _target) in ["HEALTHY", "INJURED"]) and (_target != player)', 	// condition
					-1			// radius - radius to show in (default 50), -1 to disable
					// false,		// unconscious - show if unconcious
					// "",			// selection
					// ""			// memoryPoint
				];				
			};
		};
	} forEach (units (group _unit));
};

// goat1 addEventHandler ["HandleDamage", ntech_revive_dmgHandler]; // End Handler
// goat2 addEventHandler ["HandleDamage", ntech_revive_dmgHandler]; // End Handler
// player addEventHandler ["HandleDamage", ntech_revive_dmgHandler]; // End Handler

// // goat2 addAction["Heal Goat2", {  }];
// player call ntech_revive_addHoldActions;
NT_BLEEDOUT_TIME=300;
player call ntech_revive_initTeam;
// Setup player
if (!isDedicated) then {
	inGameUISetEventHandler [
		'Action',
		'
		if !(player getvariable ["NT_REVIVE_BLEEDING",false]) exitWith {true};
		false;
		'
	];
};