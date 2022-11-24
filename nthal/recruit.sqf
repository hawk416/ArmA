/*
	Recruit unit UI handler

	Resources:
	// AI SKills
	"general"			// General AI Intelligence
	"aimingAccuracy"	// Affects how much the AI will know to compensate for recoil, dispersion, etc.
	"aimingShake"		// Affects how steadily the AI can hold a weapon
	"aimingSpeed"		// Affects how quickly the AI can rotate and stabilize its aim
	"reloadSpeed"		// Affects the delay between switching or reloading a weapon
	"spotDistance"		// Affects the accuracy of the information
	"spotTime"			// Affects how quick the AI react to death, damage or observing an enemy
	"courage"			// Affects unit's subordinates' morale
	"commanding"		// Affects how quickly recognized targets are shared with the group
	"endurance"			// Disabled in A3
*/
params["_mode", "_pool", "_amount", "_skill"];
private["_idclb_unit","_idclb_ldt","_idclb_grp","_idcsttxt_trait"];
if (isNil "_amount") then {_amount=1};
if (isNil "_skill") then {_skill=0.5};
_skillsconf=["general","aimingAccuracy","aimingShake","aimingSpeed","reloadSpeed","spotDistance","spotTime","courage","commanding"];
_skillnames=["General","Aim Acc.","Aim Shake","Aim Spd.","Reload Spd.","Spot Dist.","Spot Time","Courage","Commanding"];
_idclb_unit=1500;
_idclb_ldt=1501;
_idclb_grp=1502;
_idcsttxt_trait=1100;
_idclb_skills=1503;
switch (_mode) do {
	case "init" : {
		createDialog "ntech_recruit";
		waitUntil { !(isNull (findDisplay 4210))}; //4210
		for "_i" from 1 to _amount do {
			_grp = [side player, _pool, [], getPos player, 20] call nt_hal_fnc_spawngroup;
			if ((count (units _grp)) < 1) exitWith {systemChat "Could not spawn units";deleteGroup _grp};
			_unit=(units _grp) select 0;
			_config=typeOf _unit;
			_loadout=getUnitLoadout _unit;
			_indx=lbadd [_idclb_unit, name _unit];
			_trait="";
			if (_unit getUnitTrait "Medic") then {_trait="Medic"};
			if (_unit getUnitTrait "Engineer") then {_trait="Engineer"};
			if (_unit getUnitTrait "ExplosiveSpecialist") then {_trait="Explosive Specialist"};
			if (_unit getUnitTrait "UavHacker") then {_trait="Hacker"};
			_skills=[];
			{
			  _skills append [(random [_skill-0.10, _skill, _skill+0.10])];
			} forEach _skillsconf;
			// Append unit to list
			lbSetData [_idclb_unit, _indx, str([_config, _loadout, _skills, _trait])];
			//cleanup
	    	{
				deleteVehicle _x;
	    	} forEach (units _grp);
			deleteGroup _grp
		};
		_groups=player call NT_fnc_findHC;
		_indx=lbAdd [_idclb_grp, str(group player)];
		lbSetData [_idclb_grp, _indx, str(group player)];
		{
			_indx=lbAdd [_idclb_grp, str(_x)];
			lbSetData [_idclb_grp, _indx, str(_x)];
		} forEach _groups;
		lbSetCurSel [_idclb_unit, 0];
		lbSetCurSel [_idclb_grp, 0];
	};
	case "switch" : {
		_ctrl=_this select 1;
		_indx=_this select 2;
		_data=call compile (_ctrl lbData _indx);
		// hint format["Loadout: %1", _data select 2];
		lbClear _idclb_ldt;
		lbClear _idclb_skills;
		// add primary
		_ldt=((_data select 1) select 0);
		if (count _ldt > 0) then {
			_className=_ldt select 0;
			_config=_className call NT_fnc_findclass;
			_indx=lbAdd [_idclb_ldt, getText(configFile >> _config >> _className >> "displayName")];
			lbSetPictureRight [_idclb_ldt, _indx, getText(configFile >> _config >> _className >> "picture")];
		};
		// add secondary
		_ldt=((_data select 1) select 1);
		if (count _ldt > 0) then {
			_className=_ldt select 0;
			_config=_className call NT_fnc_findclass;
			_indx=lbAdd [_idclb_ldt, getText(configFile >> _config >> _className >> "displayName")];
			lbSetPictureRight [_idclb_ldt, _indx, getText(configFile >> _config >> _className >> "picture")];
		};
		// add handgun
		_ldt=((_data select 1) select 2);
		if (count _ldt > 0) then {
			_className=_ldt select 0;
			_config=_className call NT_fnc_findclass;
			_indx=lbAdd [_idclb_ldt, getText(configFile >> _config >> _className >> "displayName")];
			lbSetPictureRight [_idclb_ldt, _indx, getText(configFile >> _config >> _className >> "picture")];
		};
		// Add other
		for "_i" from 3 to 5 do {
			// Add Primary item
			_ldt=((_data select 1) select _i);
			if (count _ldt > 0) then {
				_className=_ldt select 0;
				_config=_className call NT_fnc_findclass;
				_indx=lbAdd [_idclb_ldt, getText(configFile >> _config >> _className >> "displayName")];
				lbSetPictureRight [_idclb_ldt, _indx, getText(configFile >> _config >> _className >> "picture")];
			};
			// Add sub-items items
			if (count _ldt > 1) then {
				{
				  // [[item, amount, rounds], [item,amount, rounds]]
					_className=_x select 0;
					_config=_className call NT_fnc_findclass;
					_indx=lbAdd [_idclb_ldt, format["- %1x %2",_x select 1, getText(configFile >> _config >> _className >> "displayName")]];
					// lbSetTextRight [_idclb_ldt, _indx, ];
					lbSetPictureRight [_idclb_ldt, _indx, getText(configFile >> _config >> _className >> "picture")];		  
				} forEach (_ldt select 1);
			};
		};
		// Setup Skills table
		// hint format["dat: %1",(_data) ];
		for "_i" from 0 to ((count  (_data select 2)) -1) do {
			// hint format["setting up skills %1", _i];
			_indx=lbAdd [_idclb_skills, format["%1: %2", _skillnames select _i, round (((_data select 2) select _i)*100)]];
			lbSetValue[_idclb_skills, _indx, (_data select 2) select _i];
			lbSetData[_idclb_skills, _indx, _skillsconf select _i];
		};
		// Set Trait text
		ctrlSetText [_idcsttxt_trait, format["Trait: %1", (_data select 3)]];
	};
	case "create" : {
		_uindx=lbCurSel _idclb_unit;
		_gindx=lbCurSel _idclb_grp;
		_data=call compile (lbData[_idclb_unit, _uindx]);
		_grp=(lbData[_idclb_grp, _gindx]);
		_grp=allGroups select {str(_x) == _grp};
		_grp=(_grp select 0);
		_unit=_grp createUnit [(_data select 0), position player, [], 10, "FORM"];
		[ _unit ] joinSilent _grp;
		_unit setUnitLoadout (_data select 1);
		for "_i" from 0 to ((count  (_data select 2)) -1) do {
			_unit setSkill [_skillsconf select _i, (_data select 2) select _i];
		};
		lbDelete [_idclb_unit, _uindx];
		lbSetCurSel [_idclb_unit, 0];
	}; 
};
