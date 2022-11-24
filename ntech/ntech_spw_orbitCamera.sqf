/*
	NTECH Orbital Camera with Controls
	
	summary: provides orbtal camera with controls
	description: Creates a camera object with controls for rotate, angle/altitute, distance
	params:
		0 - _centercmd - Code to execute to receive position
		1 - _condition - Code to execute as condition: {}
		2 - _args: array - Arguments to send to center and condition 
		*3 - _limit: array - Limit of altitude and distance [_alt, _dist];
		*4 - _args: array - Optional: initial values: [_rotation,_altitude,_distance]
*/
private ["_camera","_mousex","_mousey","_mousexn","_mouseyn","_mousexdiff","_mouseydiff",
		"_coords", "_mouse_handler","_mouse_handler2","_mouse_handler3"];
private _centercmd=_this select 0;
private _condition=_this select 1;
private _args=_this select 2;
private _maxalt=100;
private _maxdist=100;
if (count _this >= 4) then {
	_maxalt=(_this select 3) select 0;
	_maxdist=(_this select 3) select 1;
};
private _rotation=180;
private _altitude=5;
private _distance=5;
if (count _this == 5) then {
	_rotation=(_this select 4) select 0;
	_altitude=(_this select 4) select 1;
	_distance=(_this select 4) select 2;
};
// Grab initial mouse position
_mousex=getMousePosition select 0;
_mousey=getMousePosition select 1;
// Initialize Camera on Vehicle
_center=_args call _centercmd;
_camera = "camera" camCreate _center;
_camera camPrepareTarget _center;
// set initial position & altitude
_coords=[_center, _distance, _rotation] call BIS_fnc_relPos;
_coords set [2, (_center select 2) + _altitude];
_camera camPreparePos _coords;
_camera cameraEffect ["INTERNAL", "BACK"];
_camera camCommitPrepared 0;
showCinemaBorder false;
/*
	UI Event handlers
*/
// Setup event handlers
_mouse_handler=(findDisplay 46) displayAddEventHandler ["MouseButtonDown", {missionNamespace setVariable ["ntech_ui_mousedrag", true]}];
_mouse_handler2=(findDisplay 46) displayAddEventHandler ["MouseButtonUP", {missionNamespace setVariable ["ntech_ui_mousedrag", false]}];
_mouse_handler3=(findDisplay 46) displayAddEventHandler ["MouseZChanged", {missionNamespace setVariable ["ntech_ui_mousescroll", (missionNamespace getVariable ["ntech_ui_mousescroll",0]) + (_this select 1)]}];
/*
	MAIN LOOP
*/
// give the ui time to load up

while { _args call _condition } do {
	// Set camera position based on mouse movement/dragging
	if (missionNamespace getVariable ["ntech_ui_mousedrag", false]) then {
		_mousexn=getMousePosition select 0;
		_mouseyn=getMousePosition select 1;
		_mousexdiff=_mousex - _mousexn;
		_rotation=_rotation + (_mousexdiff*5);///10);
		_mouseydiff=_mousey - _mouseyn;
		_altitude=_altitude + (_mouseydiff*2);///500);
	} else {
		_mousex=getMousePosition select 0;
		_mousey=getMousePosition select 1;
	};
	_ntech_ui_mousescroll=missionNamespace getVariable ["ntech_ui_mousescroll", 0];
	// get Mouse Scroll
	if (_ntech_ui_mousescroll != 0) then {
		_distance=_distance - (0.1 * _ntech_ui_mousescroll);
		missionNamespace setVariable ["ntech_ui_mousescroll", 0];
	};
	// Collect coordinate info
	_center=_args call _centercmd;
	_distance=_distance min _maxdist;
	_altitude=_altitude min _maxalt;
	_coords=[_center,  _distance, _rotation] call BIS_fnc_relPos;
	_coords set [2, (_center select 2) + _altitude];
	// Prepare and commit
	_camera camPrepareTarget _center;
	_camera camPreparePos _coords;
	if(((getPos _camera) distance2D _coords) > 2) then {
		_camera camCommitPrepared ((getPos _camera) distance2D _coords)/30;
	} else {
		_camera camCommitPrepared 0.1;
	};
	waitUntil {camCommitted _camera};
};
/*
	Cleanup
*/
// Camera
_camera cameraEffect ["TERMINATE", "BACK"];
_camera camCommitPrepared 0;
camDestroy _camera;	
// Event Handlers
(findDisplay 46) displayRemoveEventHandler ["MouseButtonDown",_mouse_handler];
(findDisplay 46) displayRemoveEventHandler ["MouseButtonUP",_mouse_handler2];
(findDisplay 46) displayRemoveEventHandler ["MouseZChanged",_mouse_handler3];
