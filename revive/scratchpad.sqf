hint format["ctrls: %1", allControls findDisplay 313];
[] spawn {
	{
		_ctrlIDC = ctrlIDC _x;
		_wasvisible = ctrlVisible _ctrlIDC;
		hint format["Disabling: %1", _ctrlIDC];
		ctrlShow [_ctrlIDC, false];
		// sleep 1;
		// hint format["Disabling: %1", _ctrlIDC];
		// ctrlShow [_ctrlIDC, false];	
		// sleep 1;
		// hint format["Reseting: %1", _ctrlIDC];
		// ctrlShow [_ctrlIDC, _wasvisible];	
	} forEach allControls findDisplay 313;
};

fGetIDC = {
	_aCtrl = toArray str _this;
	_cnt = count _aCtrl - 9;
	for "_i" from 0 to (_cnt-1)do
	{
		_aCtrl set [_i, _aCtrl select (_i + 9)];
	};
	_aCtrl resize _cnt;
	parseNumber toString _aCtrl
};

/*---------------------------------------------------------------------------
Create diary entries for all displays
---------------------------------------------------------------------------*/
{
	_temp =format ["Dialog%1",(str _x)];
	player createDiarySubject [_temp, format ["Display %1", _x]];
	{
		player createDiaryRecord [_temp, format ["TYPE : %1 | TEXT : %2 | CLASSNAME : %3 | VISIBLE : %4 | POS : %5 | PARENT : %6 | ID : %7", ctrlType _x, ctrlText _x, ctrlClassName _x, "ctrlVisible _x", ctrlPosition _x, ctrlParent _x, ctrlIDC _x]]; 
	} forEach (allControls _x);
} forEach allDisplays;
player createDiarySubject ["IGUI", format ["Display %1", _x]];
player createDiaryRecord ["IGUI", format ["%1", uiNamespace getVariable ["IGUI_displays", []]]];

/*---------------------------------------------------------------------------
Title
---------------------------------------------------------------------------*/
player createDiarySubject ["ICS", "ICS"];
goat0 createDiarySubject ["ICS", "ICS"];
ICS_handleDeath = {
	_unit = _this;
	_unit removeEventHandler ["HandleDamage", _thisEventHandler];
	_units = (units (group _unit));
	_unitnew =  _units findIf {alive _x};
	if (_unitnew > -1) then {
		_unitnew = _units select _unitnew;
		addSwitchableUnit _unitnew;
		selectPlayer _unitnew;
		goat0 createDiaryRecord  ["ICS", ["Death",format["Unit: %1 is dead!\nDamage: %2\nSel: %3\nUnits: %4\nUnit: %5", name _unit, _damage, _selection, _units, _unitnew]]];
		goat0 addEventHandler ["HandleDamage", {
			params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];
			if (!alive _unit) then {
				_unit call ICS_handleDeath;
			};
		}];
	};
};
player createDiarySubject ["ICS", "ICS"];
goat0 addEventHandler ["HandleDamage", {
	params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];
	player createDiaryRecord ["ICS", [format ["Injured%1", _selection], format["%1 | Unit %2 | Selection %3 | Damage %4 | HitPoint %5 | HitIndex 6", [_time] call BIS_fnc_timeToString, name _unit, _selection, _damage, _hitPoint, _hitIndex]]];
	if (_selection in ["body", ""]) then {
		if (_damage >= 1.0) then {
			player createDiaryRecord ["ICS", ["Dead", format["%1 | Unit %2 | Selection %3 | Damage %4 | HitPoint %5 | HitIndex 6", [_time] call BIS_fnc_timeToString, name _unit, _selection, _damage, _hitPoint, _hitIndex]]];
		};
	};
	// player createDiaryRecord ["ICS", ["Injured", format["%1 Unit %2 is Hurt!\nHitIndex: %3\nHitPoint: %4\nSelection: %5", [_time] call BIS_fnc_timeToString, name _unit, _hitIndex, _hitPoint, _selection]]];
	if (!alive _unit) then {
		// _unit call ICS_handleDeath;
	};
}];


player addEventHandler ["Killed", {
	params ["_unit", "_killer", "_instigator", "_useEffects"];
	_unit removeEventHandler ["Killed", _thisEventHandler];
	_units = (units (group _unit));
	_unitnew =  _units findIf {alive _x};
	if (_unitnew > -1) then {416Rbi404
		_unitnew = _units select _unitnew;
		Hint format["Unit: %1 is dead!\nDamage: %2\nSel: %3\nUnits: %4\nUnit: %5", name _unit, _damage, _selection, _units, _unitnew];
		addSwitchableUnit _unitnew;
		selectPlayer _unitnew;
	};	
}];

player removeAllEventHandlers "Killed";
player addEventHandler ["Killed", {
	Hint format["Player %1 Killed!", name player];
	if ((count (units (group player))) > 1) then {
		_unit = (((units (group player)) - [player]) select 0);
		addSwitchableUnit _unit;
		selectPlayer _unit;
		closeDialog 0;
	};
}];

hint format["Mission end: %1", missionEnd];

player addEventHandler ["Killed", {
	Hint format["Player %1 Killed!", name player];
}];
player addEventHandler ["Dammaged", {
	if (damage player >= 1) then {
		if ((count (units (group player))) > 1) then {
			_unit = (((units (group player)) - [player]) select 0);
			addSwitchableUnit _unit;
			selectPlayer _unit;
			closeDialog 0;
		};
	};
}];


//
player addEventHandler ["Killed", { 
 params ["_unit", "_killer", "_instigator", "_useEffects"]; 
 _unit removeEventHandler ["Killed", _thisEventHandler]; 
 _units = (units (group _unit)); 
 _unitnew =  _units findIf {alive _x}; 
 if (_unitnew > -1) then { 
  _unitnew = _units select _unitnew; 
  Hint format["Unit: %1 is dead!\nDamage: %2\nSel: %3\nUnits: %4\nUnit: %5", name _unit, _damage, _selection, _units, _unitnew]; 
  addSwitchableUnit _unitnew; 
  selectPlayer _unitnew; 
 };  
}];
//
player addEventHandler ["Killed", { 
	params ["_plyr", "_killer", "_instigator", "_useEffects"];
	// Incapacitate and Stop player from dying
	_unit setDamage 0;
	_unit setCaptive true;
	_unit setUnconscious true; 
	// remove this event handler
	_unit removeEventHandler ["Killed", _thisEventHandler];
	// get a list of units available
	_units = (units (group _plyr)); 
	_unitnew =  _units findIf {alive _x}; 
	if (_unitnew > -1) then { 
	_unitnew = _units select _unitnew; 
	Hint format["Unit: %1 is dead!\nDamage: %2\nSel: %3\nUnits: %4\nUnit: %5", name _unit, _damage, _selection, _units, _unitnew]; 
	// addSwitchableUnit _unitnew; 
	// selectPlayer _unitnew; 
	// get unit position & status
	_newposition=getPosWorld _unitnew;
	_newdirection=getDir _unitnew;
	_newloadout=getUnitLoadout _unitnew;
	_unitposition=getPosWorld _unit;
	_unitdirection=getDir _unit;
	_unitloadout=getUnitLoadout _unit;
	// switch player and _unitenew
	_unitenew setPos [0,0];
	_unit setPosWorld _unitposition;
	_unit setDir _unitdirection;
	_unit setUnitLoadout _unitloadout;

	_unitnew setPosWorld _unitposition;
	_unitnew setDir _unitdirection;
	_unitnew setUnitLoadout _unitloadout;

	};  
}];

player addEventHandler ["HandleDamage", {
	params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];
	if (_damage >= 0.99) then {
		[_unit, _damage] spawn {

		};
		// if !(lifeState _unit == "INCAPACITATED") then {
			//[_unit, true] call DREAD_fnc_unitSetReviveState;
			// [_unit, true] remoteExec ["DREAD_fnc_unitSetReviveState", _unit];
			//_unit call DREAD_fnc_addPlayerHoldRevive;
			// _unit remoteExec ["DREAD_fnc_addPlayerHoldRevive", 0];
			//_unit setVariable ["DE_TIME_KILLED", time];
			// cutText [format["Unit: %1 is dead!\nDamage: %2\nSel: %3\nUnits: %4\nUnit: %5", name _unit, _damage, _hitPoint, _units, _unitnew], "BLACK FADED"]; 
			_unit setDamage 0;
			// remove this event handler
			// _unit removeEventHandler ["Killed", _thisEventHandler];
			// get a list of units available
			_units = (units (group _unit));
			_units = _units - [_unit];
			_unitnew =  _units findIf {alive _x}; 
			if (_unitnew > -1) then { 
				_unitnew = _units select _unitnew; 
				// addSwitchableUnit _unitnew; 
				// selectPlayer _unitnew; 
				// get unit position & status
				_newposition=getPos _unitnew;
				_newdirection=getDir _unitnew;
				_newloadout=getUnitLoadout _unitnew;
				_unitposition=getPos _unit;
				_unitdirection=getDir _unit;
				_unitloadout=getUnitLoadout _unit;
				hint format["new position: %1", _newposition];
				// switch player and _unitenew
				// _unitnew setPos [0,0];
				// _unitnew setVehiclePosition [[0,0,0], [], 0, "none"];
				_unit setDir _newdirection;
				_unit setVehiclePosition [_newposition, [], 0, "none"];
				_unit setUnitLoadout _newloadout;

				// _unitnew setDir _unitdirection;
				// _unitnew setVehiclePosition [_unitposition, [], 0, "none"];
				// _unitnew setUnitLoadout _unitloadout;


				// _unit setDamage (damage _unitnew);
				// _unitnew setDamage 1;
				// titleFadeOut 1;
		};
		_damage = 0;
	// };
	_damage;
	};
}];



ntech_revive={
	private["_unit", "_isPlayer", "_damage", "_scapegoat", "_team", "_instigator", "_projectile"];
	_unit = _this select 0;
	_damage = _this select 1;
	_instigator = _this select 2;
	_projectile = _this select 3;
	// check if unit is player
	_isPlayer=(_unit == player);
	if (_isPlayer) then {
		[_unit, _team, _instigator, _projectile] call ntech_revive_unitswitch;
	} else {
		// TODO: Implement AI revive
		// Call-out (Medic!)
		// set revive action
		// set visual cue
	};
}};


ntech_revive_unitswitch={
	private ["_unit", "_team", "_scapegoat", "_instigator", "_projectile"];
	_unit = _this select 0;
	_team = _this select 1;
	_instigator = _this select 2;
	_projectile = _this select 3;
	cutText [format["Unit: %1 is dead!\nKilled by %2 with %3", name _unit, _instigator, _projectile], "BLACK FADED"]; 
	// find team members and a scapegoat
	_team = (units (group _unit)); // get all units from team
	_team = _team - [_unit]; // remove the current unit from team
	// TODO: Open dialog - orbit camera + team member select + Give Up/Sacrifice Buttons
	_scapegoat =  _team findIf {alive _x}; // find index if alive (-1 otherwise)
	if (_scapegoat > -1) then {
		//TODO: Implement Camera + Selector
		_scapegoat = _team select _scapegoat;
		_scapegoat setCaptive true;
		_scapegoat allowDamage false;
		// get _scapegoat position & status
		_newposition=getPos _scapegoat;
		_newdirection=getDir _scapegoat;
		_newloadout=getUnitLoadout _scapegoat;
		// get _unit position & status
		_unitposition=getPos _unit;
		_unitdirection=getDir _unit;
		_unitloadout=getUnitLoadout _unit;
		// Set unit back to concious and adjust stance before position move
		_unit setUnconscious false;
		_unit playActionNow (stance _scapegoat);
		// switch unit and scapegoat
		_scapegoat setVehiclePosition [[0,0,0], [], 0, "none"];
		_unit setDir _newdirection;
		_unit setVehiclePosition [_newposition, [], 0, "none"];
		_unit setUnitLoadout _newloadout;
		_scapegoat setDir _unitdirection;
		_scapegoat setVehiclePosition [_unitposition, [], 0, "none"];
		_scapegoat setUnitLoadout _unitloadout;
		// Set damage for unit
		[_unit, damage _scapegoat, stance _scapegoat] spawn {
			_unit = _this select 0;
			_dmg = _this select 1;
			_stance = _this select 2;
			hintSilent "You are invulnerable for 3";
			sleep 1;
			hintSilent "You are invulnerable for 2";
			sleep 1;
			hintSilent "You are invulnerable for 1";
			sleep 1;
			_unit setDamage _dmg;
			_unit setCaptive false;
			_unit allowDamage true;
			hintSilent "You are NO LONGER invulnerable";
		};
		// set damage to scapegoat
		_scapegoat setDamage 1;
		_scapegoat setCaptive false;
		_scapegoat allowDamage true;
		titleFadeOut 1;
	};
};

ntech_revive_bleedout={
	private["_unit", "_actionId", "_timemax", "_timestart", "_timenow", "_timepercentage", "_timetolive", "_icon","_color"];
	_unit = _this select 0;
	_actionId = _this select 1;
	_timemax = _this select 2;
	_timestart = time;
	_timenow = time;
	while{((_timenow - _timestart) <= _timemax) and (lifeState _unit == "INCAPACITATED")} do {
		_timenow=time;
		_timepercentage=(_timenow - _timestart)/_timemax; //0-1
		_timetolive=_timemax - (_timenow - _timestart);
		// Draw 3D icon
		_icon = "a3\ui_f\data\igui\cfg\holdactions\holdaction_revivemedic_ca.paa";
		_color = [1,1-_timepercentage,0,1];
		if (!isNil {_unit getVariable "DE_REVIVING"}) then {
			_icon = "a3\ui_f\data\igui\cfg\holdactions\holdaction_revive_ca.paa";
			_color = [1,1,0,1];
		};
		drawIcon3D [_icon, _color, ASLToAGL (aimPos _unit), 1, 1, 1, "", true, 0, "RobotoCondensed", "", true];
		hint format["%1 will die in %2 seconds", _unit, ceil _timetolive];
		_unit setDamage (0.5+(_timepercentage/2));
	};
	_unit removeAction _actionId;
};
ntech_revive_dmgHandler={
params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];
	if (_damage >= 0.99) then {
		// Check the lifestate
		if !(lifeState _unit == "INCAPACITATED") then {
			// unit is incapacitated, disable damage to stop additional event handlers from spawning.
			_unit setCaptive true;
			_unit allowDamage false;
			_unit setUnconscious true;
			// TODO: Add revive action to unit
			[_unit, _team, _instigator, _projectile] call ntech_revive_unitswitch;
			_actionId =_unit addAction[format["Heal %1", name _unit], {
				params ["_target", "_caller", "_actionId", "_arguments"];
				//TODO: Check if caller has FAK in inventory
				hint format["%1 is healing %2", _caller, _target];
				_target setDamage 0.5;
				_target setUnconscious false;
				_target setCaptive false;
				_target allowDamage true;
			}, _unit];
			[_unit, _actionId ,120] spawn ntech_revive_bleedout;
			// [_unit, _damage, _instigator, _projectile ] spawn ntech_revive;
		}; // End IF lifestate
		_damage = 0;
	}; // End If damage
	_damage;
};
ntech_revive_addHoldActions = {
	[
		_this,
		"Heal Self",
		"",
		"",
		'("FirstAidKit" in (items _this)) and (lifeState _this == "INCAPACITATED")',
		"_caller distance _target < 3",
		{},
		{},
		{
			_target setDamage 0.5;
			_target setUnconscious false;
			_target setCaptive false;
			_target allowDamage true;
		},
		{},
		[],
		12,
		10000,
		true,
		false
	] call BIS_fnc_holdActionAdd; // remoteExec ["BIS_fnc_holdActionAdd", 0, _target];	// MP compatible implementation

};
goat1 addEventHandler ["HandleDamage", ntech_revive_dmgHandler]; // End Handler
player addEventHandler ["HandleDamage", ntech_revive_dmgHandler]; // End Handler
player call ntech_revive_addHoldActions;

hint format["Unit: %1 State: %2 Cmd: %3 FAK: %4", goat4, lifeState goat4, currentCommand goat4, ("FirstAidKit" in (items goat4))]; 

goat4 action ["heal", goat1]


