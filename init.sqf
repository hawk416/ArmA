/*
	NTech Utilities mission init script
*/
// Initialize ntech-utils
[] execVM "ntech-utils\init.sqf";
[] execVM "ntech\init.sqf";
// Initialize gui
[] execVM "gui\init.sqf";


// Garage
[] execVM "garage\init.sqf";

// Initialize trade
[] execVM "trade\init.sqf";
[] execVM "trade\ntech_trade_simpleTrader.sqf";
// [] execVM "utils\ntech_fnc_garage.sqf";

// Init revive
[] execVM "revive\init.sqf";

// Init sites
[] execVM "ntsites\init.sqf";

// Initialize AI
// [] execVM "ntech-dev\init.sqf";
// Set the item list
[] execVM "var_list_prices.sqf";
// _this addAction ["Arsenal", { 
// ["AmmoboxInit", [ammobox, (false, true) ]] spawn BIS_fnc_arsenal
//  } ]; 
// ["AmmoboxInit", [ammobox, false]] spawn BIS_fnc_arsenal;

/*
	DEV
*/
sleep 2;


NTDEV_fnc_addentry={
	params["_subject","_title" ,"_text"];
	if !(player diarySubjectExists _subject) then {player createDiarySubject [_subject, _subject]};
	player createDiaryRecord[_subject, [_title,format["%1: %2", [daytime] call BIS_fnc_timeToString, _text]]];
};

// Init Dev/Debug Log
if !(player diarySubjectExists "DEV") then {player createDiarySubject ["DEV", "DEVLOG"]};
["DEVLOG", "DevTools", "Initializing tools"] call NTDEV_fnc_addentry;

player addAction ["Dev/Reload", {[] call ntech_dev_reload}];
player addAction ["Teleport", {_this execVM "ntech_dev\teleport.sqf"}];
player addAction ["Virtual Arsenal", {[ "Open", [true ] ] call BIS_fnc_arsenal}];
player addAction ["Check Weapons", {hint formatText ["primary: %1 %4 secondary: %2 %4 handgun: %3", primaryWeapon player, secondaryWeapon player, handgunWeapon player, lineBreak]}];
player setVariable ["credits", 1000];
player addAction ["Money?", { Hint format["You have: %1 credits", (player getVariable "credits")]; sleep 2; Hint ""; } ];
// Initialize trader 1 - Vehicle Trader
/*
Trader init
arguments:
	1: trade_trader - the trader object
	2: trade_ui 	- one of: simple, category, variant, complex
	3: trade_type - the type of trade (see trade function)
	4: trade_object - depending on trade=, but either a unit, vehicle or position (see trade function)
	5: trade_list 	- Depending on trade_variant, but one of:
			 ["config", "class", price],
			 ["config", "category", "class", price],
			 ["config", ["varint1", "variant2", "variang3"], price],
			 ["config", "category", ["variant1", "variant2", "variant3"], price]
	6: trade_currency - The currency to be traded as friendly name and variable array, example: ["Credits", "credits"]
return:
	true/false, depending on status
*/
[ trader1, "simple", "spawn", "marker1", Heli_Civilian+ Heli_Opfor + Heli_Independend + Heli_Blufor, ["Credits", "credits"] ] call ntech_simpletrader_initTrader;
// [ trader2, "simple", "spawn", "marker1", Weapons_Trader, ["Credits", "credits"] ] call ntech_simpletrader_initTrader;
trader2 addAction["Customs", {[veh1] execVM "ntech_garage.sqf"}];
ntech_hint={
	hint format[": %1", _this];
};

trader3 setVariable["ntech_garage_bays", [[],[],[]]]; // [ ["config", ["BIS_fnc_saveVehicle"], ["getAllHitPointsDamage"], [Inventory]] ]
trader3 setVariable["ntech_garage_mode", true]; // Boolean mode of operation: Single Spawn (true)/Multi Spawn
trader3 setVariable["ntech_garage_bay_pos", marker1 modelToWorld [0,0,0] ]; // Either array of positions or single position argument depending on mode
trader3 setVariable["ntech_garage_allowed", ["Car", "Tank", "Armored"]]; // Configs not allowed to be stored
trader3 setVariable["ntech_garage_bis_save", []]; // Place to save BIS variables to




// trader1 addAction ["Trade", { call ntech_hint } ];
		// _trader addAction [_action, { _this call ntech_trader_createDialog }, args];
		 // trader3 setVariable ["ntech_garage_allowed", ["Car", "Tank", "Armored"]]


// Add Skip Time option
player addAction ["Skip Time", { "init" execVM "ntech\ntech_fnc_timeskip.sqf" }];
