_target = _this select 0;
_caller = _this select 1;
_id = _this select 2;

// Check if target has weapons
NTECH_fnc_hasWeapon={
	_target=_this select 0;
	if ((primaryWeapon _target == "") && (secondaryWeapon _target == "") && (handgunWeapon _target == "")) then {
		hint "player has no weapons";
	};	
};

hint "hello world";
[_target] spawn NTECH_fnc_hasWeapon;
// Move 
// {
// } forEach units (group _target);