/*
	Init.sqf file for NTech sites
*/
// Setup Global vars
NTSITES_SITES=[];
// NTSITES_OWNTIME=10;
NTSITES_RSCBLU=[0,0,0];
NTSITES_RSCRED=[0,0,0];
NTSITES_RSCGRN=[0,0,0];

[] ExecVM "ntsites\siteloop.sqf";
[] execVM "ntsites\spawngroup.sqf";
if !(player diarySubjectExists "NTSites") then {player createDiarySubject ["NTSites", "NTSITES"]};
player createDiaryRecord["NTSites", ["Main",format["%1: %2", [daytime] call BIS_fnc_timeToString, "initializing"]]];

/*
	Functions
*/
NTSITES_fnc_modrsc={
	params["_side", "_rsc"];
	switch (_side) do { 
			case east : {NTSITES_RSCRED=NTSITES_RSCRED vectorAdd _rsc}; 
			case west : {NTSITES_RSCBLU=NTSITES_RSCBLU vectorAdd _rsc}; 
			case independent : {NTSITES_RSCGRN=NTSITES_RSCGRN vectorAdd _rsc}; 
		};	
};
NTSITES_fnc_getDirName={
	params["_pos1", "_pos2"];
	_dir=_pos1 getDir _pos2;
	_dirname=format["%1", _dir];
	switch (true) do { 
		case ((_dir < 22.5) or (_dir > 337.5)) : {  _dirname="N" }; 
		case ((_dir > 22.5) and (_dir <= 67.5)) : {  _dirname="NE" }; 
		case ((_dir > 67.5) and (_dir <= 112.5)) : {  _dirname="E" }; 
		case ((_dir > 112.5) and (_dir <= 157.5)) : {  _dirname="SE" }; 
		case ((_dir > 157.5) and (_dir <= 202.5)) : {  _dirname="S" }; 
		case ((_dir > 202.5) and (_dir <= 247.5)) : {  _dirname="SW" }; 
		case ((_dir > 247.5) and (_dir <= 292.5)) : {  _dirname="W" }; 
		case ((_dir > 292.5) and (_dir <= 337.5)) : {  _dirname="NW" }; 
	};
	_dirname;
};
NTSITES_fnc_getNearestLocation={
	params["_pos"];
	private["_ret"];
	_ret=[];
	_dist=[];
	{
		_f=nearestLocation [_pos, _x];
		_ret append [_f];
		_dist append [_pos distance2D (locationPosition _f)];
	} forEach ["NameLocal","NameVillage","NameCity","NameCityCapital"];
	_min=selectMin _dist;
	_indx=_dist findIf {_x == _min};
	_ret=_ret select _indx;
	_ret;
};
NTSITES_fnc_initSite={
	params["_name", "_marker", "_radbase", "_flag", "_numper",			// Required
			"_prod","_prodtime",										// Optional
			"_owntime", "_reinftime", "_healtime", "_repairtime",		// Optional
			"_rearminftime", "_rearmstatime", "_rearmvehtime"];			// Optional
	// Process optional
	if (isNil "_prod") then {_prod=[]};
	if (isNil "_prodtime") then {_prodtime=10};
	if (isNil "_owntime") then {_owntime=10};
	if (isNil "_reinftime") then {_reinftime=5};
	if (isNil "_healtime") then {_healtime=5};
	if (isNil "_repairtime") then {_repairtime=5};
	if (isNil "_rearminftime") then {_rearminftime=5};
	if (isNil "_rearmstatime") then {_rearmstatime=5};
	if (isNil "_rearmvehtime") then {_rearmvehtime=5};
	/*
		 Setup markers
	*/
	_pos=getMarkerPos [_marker, true];
	_nloc=[_pos] call NTSITES_fnc_getNearestLocation;
	_desc=(text _nloc);
	_dist=_pos distance2D (locationPosition _nloc);
	if(_dist > 10) then {
		_desc=format["%1km %2 from %3", [_dist/1000, 2] call BIS_fnc_cutDecimals, [locationPosition _nloc, _pos] call NTSITES_fnc_getDirName,  _desc];
	};
	player createDiaryRecord["NTSites", ["Main",format["%1: Setting up site %2 , position: %3", 
												[daytime] call BIS_fnc_timeToString,
												 _desc,
												 _pos]]];
	_marker setMarkerColor "ColorWhite";
	if (_name != "") then {
		_namemarker=format["%1_name",_marker];
		_newname=createMarker [_namemarker, getpos _flag];
		_namemarker setMarkerType "mil_dot";
		_namemarker setMarkerText _name;
	} else {
		_name=_desc;
	};
	_basemarker=format["%1_base",_marker];
	_newname=createMarker [_basemarker,_pos];
	_basemarker setMarkerShape "ELLIPSE";
	_basemarker setMarkerBrush "Border";
	_basemarker setMarkerSize [_radbase, _radbase];
	_basemarker setMarkerAlpha 1;
	/*
		Setup flag variables
	*/
	_flag setFlagSide civilian;
	_flag setVariable ["NTSITES_OWNTIME", _owntime];
	_flag setVariable ["NTSITES_TIMER", time-_owntime];
	// Setup Patrols, Garisons and Statics
	_flag setVariable ["NTSITES_MARKER",_marker];
	_flag setVariable ["NTSITES_NAME",_name];
	_flag setVariable ["NTSITES_CENTER",_pos];	
	_flag setVariable ["NTSITES_RADCON",(getMarkerSize _marker) select 0];	
	_flag setVariable ["NTSITES_RADBASE",_radbase];
	_flag setVariable ["NTSITES_PATROLMAX",_numper];	
	_flag setVariable ["NTSITES_PATROLLIST",[]];
	_flag setVariable ["NTSITES_STATICGRP",grpNull];
	// Timers
	_flag setVariable ["NTSITES_PRODTIME",_prodtime];
	_flag setVariable ["NTSITES_REINFTIME",_reinftime];
	_flag setVariable ["NTSITES_HEALTIME",_healtime];
	_flag setVariable ["NTSITES_REPAIRTIME",_repairtime];
	_flag setVariable ["NTSITES_REARMINFTIME",_rearminftime];
	_flag setVariable ["NTSITES_REARMSTATIME",_rearmstatime];
	_flag setVariable ["NTSITES_REARMVEHTIME",_rearmvehtime];
	_flag setVariable ["NTSITES_REFUELTIME",_refueltime];
	// Next iteration
	_flag setVariable ["NTSITES_PRODNEXT",_prodtime-_owntime];
	_flag setVariable ["NTSITES_REINFNEXT",_reinftime-_owntime];
	_flag setVariable ["NTSITES_HEALNEXT",_healtime-_owntime];
	_flag setVariable ["NTSITES_REPAIRNEXT",_repairtime-healtime];
	_flag setVariable ["NTSITES_REARMINFNEXT",_rearminftime-_owntime];
	_flag setVariable ["NTSITES_REARMSTANEXT",_rearmstatime-_owntime];
	_flag setVariable ["NTSITES_REARMVEHNEXT",_rearmvehtime-_owntime];
	_flag setVariable ["NTSITES_REFUELNEXT",_refueltime-_owntime];
	// Production
	_site setVariable ["NTSITES_PROD_LIST",_production];
	// Add site to sitelist
	NTSITES_SITES append [_flag];
};
NTSITES_fnc_initProd={
	params["_site", "_production", "_time"];
	// _site setVariable ["NTSITES_PROD_RSC",_production];
	_site setVariable ["NTSITES_PROD_LIST",_production];
	_site setVariable ["NTSITES_PROD_TIME",_time];
	_site setVariable ["NTSITES_PROD_LAST",time];
};
NTSITES_fnc_taskPatrol={
	params["_grp", "_pos", "_radius"];
	private["_dir", "_wppos", "_wp"];
	_dir=random 360;
	for "_i" from 0 to 7 step 1 do {
		_wppos=[[_pos, _radius, _dir+(_i*45)] call BIS_fnc_relPos,
				0, 10, 1
				/*, waterMode, maxGrad, shoreMode, blacklistPos, defaultPos*/
				] call BIS_fnc_findSafePos;
		_wp=_grp addWaypoint [_wppos, 2];
		if (_i == 7) then {_wp setWaypointType "CYCLE"};
	};
};