/* init.sqf for ntech Quality Of Life

*/
ntech_fnc_timeskip=compile preprocessFileLineNumbers "qol\ntech_fnc_timeskip.sqf";

// Add Skip Time option
player addAction ["Skip Time", { "init" call ntech_fnc_timeskip }];


