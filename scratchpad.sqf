private _camera = "camera" camCreate getPosATL player;
_camera camPrepareTarget player;
_coords=[player, 50, 180] call BIS_fnc_relPos
_coords set [2, 10];
_camera camPreparePos _coords;
_camera cameraEffect ["internal", "back"];
_camera camCommitPrepared 0;


_camera camPreparePos (player getRelPos [5, 0]);

_camera cameraEffect ["terminate", "back"];
_camera camCommitPrepared 0;
camDestroy _camera;
hint format["hint: %1", "true" configClasses (configfile >> "CfgVehicles" >>  "C_Offroad_01_F" >> "TextureSources")];


Camrunning = true; // set to false to stop the camera
_radius = 50; // circle radius
_angle = 180; // starting angle
_altitude = 10; // camera altitude
_dir = 0; //Direction of camera movement 0: anti-clockwise, 1: clockwise
_speed = 0.02; //lower is faster

_coords = [cameratarget, _radius, _angle] call BIS_fnc_relPos;
_coords set [2, _altitude];
_camera = "camera" camCreate _coords;
_camera cameraEffect ["INTERNAL","BACK"];
_camera camPrepareFOV 0.700;
_camera camPrepareTarget cameratarget;
_camera camCommitPrepared 0;

while {Camrunning} do {
_coords = [cameratarget, _radius, _angle] call BIS_fnc_relPos;
_coords set [2, _altitude];

_camera camPreparePos _coords;
_camera camCommitPrepared _speed;

waitUntil {camCommitted _camera || !(Camrunning)};

_camera camPreparePos _coords;
_camera camCommitPrepared 0;

_angle = if (_dir == 0) then {_angle - 1} else {_angle + 1};
};



[player, 50, 180] call BIS_fnc_relPos

_display = (findDisplay 46) createDisplay "RscDisplayEmpty";
_ctrlEdit = _display ctrlCreate ["RscEdit", 19998];	
_ctrlEdit ctrlSetPosition [safezoneX,safezoneY,safezoneW,safezoneH];
_ctrlEdit ctrlSetBackgroundColor [0,0,0,1];
_ctrlEdit ctrlCommit 0;
_ctrlEdit ctrlAddEventHandler ["MouseMoving", {hint format["mouse delta: %1", _this]}];
_ctrlEdit ctrlEnable true;
ctrlSetFocus _ctrlEdit;

_display = (findDisplay 46) createDisplay "RscDisplayEmpty";
(findDisplay 46) displayAddEventHandler ["MouseMoving", {hint str _this}];

hint format["%1", missionNamespace getVariable "ntech_garage_mods"];["Hello World"] spawn BIS_fnc_guiMessage;
hint format["%1", player nearObjects ["Car", 30]];

this addaction [ "<t color='#00FF00'>Garage</t>",{
_pos = [ player, 30, getDir player ] call BIS_fnc_relPos;
BIS_fnc_garage_center = createVehicle [ "Land_HelipadEmpty_F", _pos, [], 0, "CAN_COLLIDE" ];
["Open",true] call BIS_fnc_garage;
}, [], 1, true, true, "", "isNull cursortarget"];


this addaction [ "<t color='#FF0000'>Edit Vehicle</t>",{
BIS_fnc_garage_center = cursorTarget;
uinamespace setvariable ["bis_fnc_garage_defaultClass", typeOf cursorTarget ];
["Open",true] call BIS_fnc_garage;
}, [], 1, true, true, "", "!( isNull cursortarget ) "];


this addaction [ "<t color='#0000FF'>CustomGarage</t>",{
BIS_fnc_garage_data = [
	[
		'\a3\soft_f\mrap_01\mrap_01_unarmed_f',
		[ ( configFile >> 'cfgVehicles' >> 'B_MRAP_01_F' ) ]
	]
];
_pos = [ player, 30, getDir player ] call BIS_fnc_relPos;
BIS_fnc_garage_center = createVehicle [ "Land_HelipadEmpty_F", _pos, [], 0, "CAN_COLLIDE" ];
["Open",true] call BIS_fnc_garage;
h = [] spawn {
	waitUntil { isNull ( uinamespace getvariable ["BIS_fnc_arsenal_cam",objnull] ) };
	BIS_fnc_garage_data = nil;
};
}, [], 1, true, true, "", "isNull cursortarget"];

veh1 addAction["Virtual Garage", {[veh1, player] execVM ntech_garage.sqf}];

VehIntroSyn=vehicle (selectRandom units GrpIntroCiv);
VehIntroSynType=typeOf VehIntroSyn;
hint format ["Civilians Arrived in vehicle: %1", VehIntroSynType];
VehIntroSyn sethit [getText(configFile >> "cfgVehicles" >> VehIntroSynType >> "HitPoints" >> "HitRFWheel" >> "name"),1]; 
VehIntroSyn sethit [getText(configFile >> "cfgVehicles" >> VehIntroSynType >> "HitPoints" >> "HitRLWheel" >> "name"),1]; 
[[GrpIntroCiv], [GrpIntroSyn], 1] call NTECH_fnc_switchsides;



/*
	init.sqf for: <>
	Simple heli transport mission. 32 passengers require transport to a new location
*/

// MIS_STATIC_units=32;
// MIS_ARR_units_start=[];
// MIS_ARR_units_end=[];
// MIS_GRP_current_group=objNul;

NTECH_fnc_vehicleHasSpace={
	_vehicle=_this select 0;
	_space=1; // +1 for co-pilot seat
	{
		if isNull (_x select 0) then {
			_rndunit=(selectRandom GRP_CIV_GroupPickup);
			_rndunit joinSilent GRP_CIV_group_InFlight;
			_rndunit action ["getInCargo", _vehicle, _x];
		};
	} forEach (fullCrew _vehicle);
	//return
	_space;
};

//DEV
player addAction ["Teleport", {_this execVM "teleport.sqf"}];

//STATIC
GRP_CIV_DropOff = createGroup civilian;
GRP_CIV_InFlight = createGroup civilian;
(units GRP_CIV_Pickup) allowGetIn true;
/*
	trigger: Player is landed next to pickup point
	condition: ((player distance marker_pickup) < 30) && (isTouchingGround (vehicle player))
	action:

*/
trg1=createTrigger ["EmptyDetector", markerPos "marker_pickup"];
// trg1 setTriggerActivation ["NONE", "PRESENT", true]
// trg1 setTriggerArea [10, 10, 0, false];
// _type=toLower(_x select 1);
// switch (_type) do {
//     case 'cargo': { _rndunit action ['getInCargo', _vehicle, (_x select 2)] };
//     case 'turret': { _rndunit action ['getInTurret', _vehicle, (_x select 3)] };
//     default { _rndunit action [format['getIn%1', _type], _vehicle] };
// };
trg1 setTriggerStatements ["((player distance (markerPos 'marker_pickup')) < 30) && (isTouchingGround (vehicle player))", "
	hint 'player has eneter pickup zone';
	_vehicle=(vehicle player);
	GRP_CIV_InFlight = createGroup civilian;
	{
		if isNull (_x select 0) then {
			_rndunit=(selectRandom (units GRP_CIV_Pickup));
			[_rndunit] joinSilent GRP_CIV_InFlight;
			_type=toLower(_x select 1);
			switch (_type) do {
			    case 'cargo': { _rndunit assignAsCargo _vehicle };
			    case 'turret': { _rndunit assignAsTurret [_vehicle, (_x select 3)] };
			    default {};
			};
		};
	} forEach (fullCrew [(vehicle player), '', true]);
	{
		deleteWaypoint [GRP_CIV_InFlight , (_x select 1)];
	} forEach (waypoints GRP_CIV_InFlight);
	_wp=GRP_CIV_InFlight addWaypoint [_vehicle, 0];
	_wp setWaypointType 'GETIN';
", "hint 'player left pickup point'"];

/*
	trigger: player is landed next to drop off point
	condition: ((player distance marker_dropoff) < 50) && (isTouchingGround (vehicle player))
	action:
		//give group a disembark waypoint
		//move any stragglers
		//move group into GRP_CIV_DropOff
*/
trg2=createTrigger ["EmptyDetector", markerPos "marker_dropoff"];
trg2 setTriggerStatements ["((player distance (markerPos 'marker_dropoff')) < 30) && (isTouchingGround (vehicle player))", "
	hint 'player has eneter drop-off zone';
	_vehicle=(vehicle player);
	{
		_x action ['getOut', _vehicle];
		[_x] joinSilent GRP_CIV_DropOff;
		unassignVehicle _x;
	} forEach (units GRP_CIV_InFlight);
	{
		deleteWaypoint [GRP_CIV_InFlight , (_x select 1)];
	} forEach (waypoints GRP_CIV_InFlight);
	_wp=GRP_CIV_InFlight addWaypoint [_vehicle, 0];
	_wp setWaypointType 'GETOUT';
	(units GRP_CIV_DropOff) allowGetIn false;
", "hint 'player left drop-off point'"];