/*
	NTech Squad Manager UI Handler
*/
params["_mode"];
_grpbox=2100;
_unitlb=1500;
_grptransferbox=2101;
_loadoutbox=2102;
_edit=1400;
_setcallsign=1600;
_cache=1601;
_primary=1200;
_secondary=1201;
_hgun=1202;
_trait=1203;
_newgrp=1602;
_skills=1501;
switch (_mode) do { 
	case "init" : {
		createDialog "ntech_squadmanager";
		waitUntil { !(isNull (findDisplay 4210))}; //4210
		["initgrp"] execVM 'sqmngr.sqf';
	}; 
	case "initgrp" : {
		// Setup Group boxes
		lbClear _grpbox;
		lbClear _grptransferbox;
		_indx=lbAdd [_grpbox, str(group player)];
		lbSetData [_grpbox, _indx, str(group player)];
		lbSetCurSel [_grpbox, 0];
		_indx=lbAdd [_grptransferbox, str(group player)];
		lbSetData [_grptransferbox, _indx, str(group player)];
		// lbSetCurSel [_grptransferbox, 0];
		_groups=player call NT_fnc_findHC;
		{
			_indx=lbAdd [_grpbox, str(_x)];
			lbSetData [_grpbox, _indx, str(_x)];
			_indx=lbAdd [_grptransferbox, str(_x)];
			lbSetData [_grptransferbox, _indx, str(_x)];
		} forEach _groups;
	};
	case "updgrp" : {
		_indx=_this select 1;
		// Set Transferbox: Note this will trigger EventHandler
		// lbSetCurSel [_grptransferbox, _indx];
		// Clear and populate unit listbox
		lbClear _unitlb;
		_grp=(lbData[_grpbox, _indx]);
		_grps=player call NT_fnc_findHC;
		_grp=_grps select {str(_x) == _grp};
		_grp=_grp select 0;
		{
			// systemchat format["%1", _x];
			_indx=lbAdd [_unitlb, name _x];
			lbSetData [_unitlb, _indx, str([str _x, str _grp])];
		} forEach (units _grp);
		lbSetCurSel [_unitlb, 0];
	}; 
	case "updunit" : {
		_indx=_this select 1;
		_data=call compile (lbData[_unitlb, _indx]);
		_unit=_data select 0;
		_grp=_data select 1;
		_grps=player call NT_fnc_findHC;
		_grp=_grps select {str(_x) == _grp};
		_grp=_grp select 0;
		_unit=((units _grp) select {str(_x) == _unit}) select 0;
		// Setup primary weapon picture
		ctrlSetText [_primary, getText(configFile >> "CfgWeapons" >> (primaryWeapon _unit) >> "picture")];
		((findDisplay 4210) displayCtrl _primary) ctrlSetTooltip getText(configFile >> "CfgWeapons" >> (primaryWeapon _unit) >> "DisplayName");
		// Setup secondary weapon picture
		ctrlSetText [_secondary, getText(configFile >> "CfgWeapons" >> (secondaryWeapon _unit) >> "picture")];
		((findDisplay 4210) displayCtrl _secondary) ctrlSetTooltip getText(configFile >> "CfgWeapons" >> (secondaryWeapon _unit) >> "DisplayName");
		// Setup handgun weapon picture
		ctrlSetText [_hgun, getText(configFile >> "CfgWeapons" >> (handgunWeapon _unit) >> "picture")];
		((findDisplay 4210) displayCtrl _hgun) ctrlSetTooltip getText(configFile >> "CfgWeapons" >> (handgunWeapon _unit) >> "DisplayName");
		// Setup picture
		_icon=getText(configFile >> "CfgVehicles" >> typeOf _unit >> "icon");
		_icon=getText (configFile >> "CfgVehicleIcons" >> _icon);
		ctrlSetText [_trait,_icon];
		// Setup traits
		lbClear _skills;
		lbAdd [_skills, format["General.: %1", _unit skill "general"]];
		lbAdd [_skills, format["Aim Acc.: %1", _unit skill "aimingAccuracy"]];
		lbAdd [_skills, format["Aim Shake.: %1", _unit skill "aimingShake"]];
		lbAdd [_skills, format["Aim Spd.: %1", _unit skill "aimingSpeed"]];
		lbAdd [_skills, format["Spot Dist.: %1", _unit skill "spotDistance"]];
		lbAdd [_skills, format["Spot Time: %1", _unit skill "spotTime"]];
		lbAdd [_skills, format["Courage: %1", _unit skill "courage"]];
		lbAdd [_skills, format["Reload Spd.: %1", _unit skill "reloadSpeed"]];
		lbAdd [_skills, format["Commanding: %1", _unit skill "commanding"]];
		// Setup Loadouts
		// TODO: Add check for existing loadout
		lbClear _loadoutbox;
		_indx=lbAdd [_loadoutbox, format["Cur: %1", _unit getVariable ["NTECH_LOADOUTNAME","Custom Loadout"]]];
		_ldt=[_unit,[_unit, "CustomLdt"]] call BIS_fnc_saveInventory;
		lbSetData [_loadoutbox, _indx, str(_unit getVariable ["NTECH_LOADOUT",_ldt]) ];
		_ArsenalData=profilenamespace getvariable ["bis_fnc_saveInventory_data",[]];
		for "_i" from 0 to ((count _ArsenalData) - 1) step 2 do {
			_indx=lbAdd [_loadoutbox,( _ArsenalData select _i)];
			lbSetData [_loadoutbox, _indx, str(_ArsenalData select (_i+1))];
		};
		// lbSetCurSel [_loadoutbox, 0];
	};
	case "setcallsign" : {
		_indx=lbCurSel _unitlb;
		_data=lbData [_unitlb, _indx];
		_data=call compile _data;
		_grp=_data select 1;
		_grps=player call NT_fnc_findHC;
		_grp=_grps select {str(_x) == _grp};
		_grp=_grp select 0;
		_newname=ctrlText _edit;
		hint format["Group: %1 Renamed to: %2", _grp, _newname];
		_grp setGroupId [_newname];
		["initgrp"] execVM 'sqmngr.sqf';
	}; 
	case "newgrp" : {
		_indx=lbCurSel _unitlb;
		_data=call compile (lbData[_unitlb, _indx]);
		_unit=_data select 0;
		_grp=_data select 1;
		_grps=player call NT_fnc_findHC;
		_grp=_grps select {str(_x) == _grp};
		_grp=_grp select 0;
		_unit=((units _grp) select {str(_x) == _unit}) select 0;
		_newgrp=createGroup (side _unit);
		[_unit] joinSilent _newgrp;
		player hcSetGroup [_newgrp];
		["initgrp"] execVM 'sqmngr.sqf';
	};
	case "swgrp" : {
		_indxgrp=_this select 1;
		_indx=lbCurSel _unitlb;
		_data=call compile (lbData[_unitlb, _indx]);
		_unit=_data select 0;
		_grp=_data select 1;
		_grps=player call NT_fnc_findHC;
		_grp=_grps select {str(_x) == _grp};
		_grp=_grp select 0;
		_unit=((units _grp) select {str(_x) == _unit}) select 0;
		_newgrp=lbData [_grptransferbox, _indxgrp];
		_grps=player call NT_fnc_findHC;
		_newgrp=_grps select {str(_x) == _newgrp};
		_newgrp=_newgrp select 0;
		[_unit] joinSilent _newgrp;
		if (count (units _grp) < 1) then {["initgrp"] execVM 'sqmngr.sqf'};
		lbDelete[_unitlb, _indx];
		// 
	};
	case "setldt" : {
		_indxldt=_this select 1;
		_indx=lbCurSel _unitlb;
		_data=call compile (lbData[_unitlb, _indx]);
		_unit=_data select 0;
		_grp=_data select 1;
		_grps=player call NT_fnc_findHC;
		_grp=_grps select {str(_x) == _grp};
		_grp=_grp select 0;
		_unit=((units _grp) select {str(_x) == _unit}) select 0;
		_ldt=lbData [_loadoutbox, _indxldt];
		_ldt=call compile _ldt;
		// _ldt=_ldt select 0;
		_ldtname=lbText[_loadoutbox, _indxldt];
		_unit setVariable ["NTECH_LOADOUT", _ldt];
		_unit setVariable ["NTECH_LOADOUTNAME", _ldtname];
		hint format["unit: %1\nldt: %2", _unit, _ldt select 0];
		[_unit, [_ldt]] call BIS_fnc_loadInventory;
		// _unit setUnitLoadout [_ldt, true];
	};
	case "cache" : {  /*...code...*/ }; 

	// default {  ...code... }; 
};