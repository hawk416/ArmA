/*
	NTECH Time Skip script
	
	Summary: Skips up to 24h
	Description: Opens Dialog allowing to skip time
	Parameters: 
		0 - _mode - Operating mode, one of: init, update, skip
		1 - _tts - time to skip in minutes
*/
/*
	IDC's
*/
private _ntech_qol_timeskip=4210;
private _ntech_qol_timeskip_frame=4211;
private _ntech_qol_timeskip_bg=4212;
private _ntech_qol_timeskip_slider=4213;
private _ntech_qol_timeskip_btnCancel=4214;
private _ntech_qol_timeskip_title=4215;
private _ntech_qol_timeskip_currenttime=4216;
private _ntech_qol_timeskip_btnOK=4217;
/*
	MAIN
*/
params ["_mode", "_tts"]
// private _mode = _this select 0;
// private _tts = _this select 1;
private _curtime = dayTime;
private _newtime = _curtime + (_tts/60);
switch ( _mode) do { 
	case "init" : { createDialog "ntech_qol_timeskip"; 
					((findDisplay _ntech_qol_timeskip) displayCtrl _ntech_qol_timeskip_title) ctrlSetStructuredText (parseText '<t align=center> Skip Time </t>');
					((findDisplay _ntech_qol_timeskip) displayCtrl _ntech_qol_timeskip_currenttime) ctrlSetStructuredText (parseText (format["<t align='left'> Current time: %1</t><t align='center'>Skip %2 minutes</t><t align='right'>New Time %3</t>", [_curtime] call BIS_fnc_timeToString, str _tts, [(_newtime%24)] call BIS_fnc_timeToString]));
				  }; 
	case "update" : { ((findDisplay _ntech_qol_timeskip) displayCtrl _ntech_qol_timeskip_currenttime) ctrlSetStructuredText (parseText (format["<t align='left'> Current time: %1</t><t align='center'>Skip %2 minutes</t><t align='right'>New Time %3</t>", [_curtime] call BIS_fnc_timeToString, str _tts, [(_newtime%24)] call BIS_fnc_timeToString])); }; 
	case "skip" : {
					closeDialog 1; // Close with OK Status
					cutText ["","BLACK FADED"];
					[[[format["Skipping to %1", [(_newtime%24)] call BIS_fnc_timeToString],"<t align='center' valign='middle' shadow='1' size='2.0'>%1</t>"]]] spawn BIS_fnc_typeText;
					skipTime (_tts/60);
					titleFadeOut 1;
				  }; 
	default {  hintSilent parseText (format["<t align='center'>Time Skip Script Error</t><br/>Unknown Mode: %1", _mode]) }; 
};