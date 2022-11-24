/*
	NTech Simple Trader init script
*/
/*
	ntech_gui_large_header = 4053;
	ntech_gui_large_close = 4054;
	ntech_gui_large_menu_default_ok = 4055;
	ntech_gui_large_menu_default_cancel = 4056;
	ntech_gui_large_menu_trade_pricetxt = 4057;
	ntech_gui_large_menu_trade_pricetype = 4058;
	ntech_gui_large_menu_trade_pricevalue = 4059;
*/
/*
	Definitions
*/
// idd's
ntech_trade_simple=4300;
// base idc's
ntech_trade_header = 4053;
ntech_trade_close = 4054;
ntech_trade_ok = 4055;
ntech_trade_cancel = 4056;
ntech_trade_pricetxt = 4057;
ntech_trade_pricetype = 4058;
ntech_trade_pricevalue = 4059;
//  simple trader idc's
ntech_trade_simple_picture=4301; 
ntech_trade_simple_description=4302;
ntech_trade_simple_list=4303;
ntech_trader_simple_map=[[ntech_trade_ok, "ButtonClick", { [trader1, ntech_trade_simple_list, ntech_trade_pricevalue] call ntech_simpletrader_buy } ],
						[ntech_trade_simple_list, "LBSelChanged", { [trader1, ntech_trade_simple_list, ntech_trade_pricevalue, ntech_trade_simple_description, ntech_trade_simple_picture] call ntech_simpletrader_changeItem} ]];


/*
	Functions
*/
/*
	Trader init
	arguments:
		1: trade_trader - the trader object
		2: trade_ui 	- one of: simple, category, variant, complex
		3: trade_type - the type of trade (see trade function)
		4: trade_object - depending on trade, but either a unit/crate/vehicle or position (see trade function)
		5: trade_list 	- Depending on trade_ui, but one of:
				 ["config", "class", price],
				 ["config", "category", "class", price],
				 ["config", ["varint1", "variant2", "variang3"], price],
				 ["config", "category", ["variant1", "variant2", "variant3"], price]
		6: trade_currency - The currency to be traded as friendly name and variable, example: ["Credits", "credits"]
	return:
		true/false, depending on status
*/
ntech_simpletrader_initTrader={
	private["_trader","_ui","_type","_object","_list", "_currency"];
	_trader=_this select 0;
	_ui=_this select 1;
	_type=_this select 2;
	_object=_this select 3;
	_list=_this select 4;
	_currency=_this select 5;
	// set trader variables
	_trader setVariable ["ntech_trade_ui", _ui];
	_trader setVariable ["ntech_trade_type", _type];
	_trader setVariable ["ntech_trade_object", _object];
	_trader setVariable ["ntech_trade_list", _list];
	// TODO: Change this to call a function for better integration
	_trader setVariable ["currency", _currency];
	// Add action to trader
	_trader addAction [ "Trade", { call ntech_simpletrader_createDialog } ];
};

/*
	Create Dialog
*/
ntech_simpletrader_createDialog={
	_trader=_this select 0;
	_target=_this select 1;
	_action=_this select 2;
	// get the type of trader (simple, variant, complex)
	_ui=_trader getVariable "ntech_trade_ui";
	createDialog(format["ntech_trade_%1Trader", _ui]);
	// TODO: Would a waituntil display is ready be better?
	// register the event handlers
	sleep 0.1;
	switch ( _ui ) do {
		case "simple": {
			[ntech_trade_simple,ntech_trader_simple_map] call ntech_gui_setEventHandlers;
			[_trader] call ntech_simpletrader_initList
		};
		case "category": {};
		case "variant": {};
	};
};

/*
	The trade function.
	arguments:
		1: trader 		- Trader object
		2: price 		- price as int
		3: type - Type of trade to be performed
			possible values: inventory, crate, spawn, unit, variable, script
		4: object - Depends on trade type:
			possible values: unit (object), crate/vehicle (object), position (array)
		5: list - list of objects to be traded:
			syntax - [ [ class, amount], [ class, amount], [ class, amount] ] OR idc 
	return:
		Unit/Vehicle if it was created, false if failed (hint if not enough credits), true otherwise.
*/
ntech_simpletrader_trade={
	private["_trader","_price", "_type", "_object", "_list", "_currency", "_trader_money", "_client_money", "_test", "_return"];
	_trader=_this select 0;
	_price=_this select 1;
	_type=_this select 2;
	_object=_this select 3;
	_list=(_this select 4) select 0;
	_return=false;		// the return status of this functions
	_test=false;		// used to indicate the items were created successfully internaly
	// get the currency;
	_currency=(_trader getVariable "currency") select 1;
	// Get the available credits
	_trader_money=_trader getVariable format["%1", _currency];
	_client_money=player getVariable format["%1", _currency];
	// check if there is enough money
	// if(_client_money >= _price) then
	// {
	// 	// Create the actual items
	// 	switch ( _type ) do {
	// 		case "spawn": {
	// 			{
					_object=getMarkerPos _object;
					// Hint format["%1,%2", _x, _object];
					// Hint format["%1", player];
					_return=_list createVehicle _object;
					// Check if the vehicle was created successfully
					// if !(isNull _return) then {
					// 	_test=true;
					// };
			// 	} forEach _list;
			// };
			// case "crate": {
			// 	// _object=
			// };
			// case "inventory": {
			// 	// Something
			// };

		// };
		// Check if items were created and deduct the money
		// if (_test) then
		// {
			// Take the credits from player and add them to trader
			player setVariable[_currency, (_client_money - _price)];
			_trader setVariable[_currency, (_trader_money + _price)];
			closeDialog 0;
//CARS
	// [
	// 	//model
	// 	"\a3\soft_f\offroad_01\offroad_01_unarmed_f",
	// 	//config paths of classes that use above model
	// 	[
	// 		config.bin/CfgVehicles/C_Offroad_01_F,
	// 		config.bin/CfgVehicles/B_G_Offroad_01_F
	// 	],

	// ],
	// [],		//ARMOR
	// [],		//HELIS
	// [],		//PLANES
	// [],		//NAVAL
	// []		//STATICS

		// [ ["\a3\soft_f\offroad_01\offroad_01_unarmed_f", [config.bin/CfgVehicles/C_Offroad_01_F, config.bin/CfgVehicles/B_G_Offroad_01_F]], [], [], [], [], [] ]

			// hint format["return: %1", _list];
			_vehtype=(['cfgVehicles', _list, ["model"]] call ntech_config_getAttributes) select 0;
			// hint format["vehicle type: %1", _vehtype];
			BIS_fnc_garage_data = [ ["\a3\soft_f\offroad_01\offroad_01_unarmed_f", ['config.bin/CfgVehicles/C_Offroad_01_F', 'config.bin/CfgVehicles/B_G_Offroad_01_F']], [], [], [], [], [] ];
			uinamespace setvariable ["bis_fnc_garage_defaultClass", "C_Offroad_01_F" ];

			// uinamespace setvariable ["BIS_fnc_arsenal_fullGarage", false];
			// missionnamespace setvariable ["BIS_fnc_arsenal_fullGarage", [_this,0,false,[false]] call bis_fnc_param];
			// missionnamespace setvariable ["BIS_fnc_arsenal_fullGarage", false];
			missionNamespace setVariable ["BIS_fnc_garage_data", [ ["\a3\soft_f\offroad_01\offroad_01_unarmed_f", ['config.bin/CfgVehicles/C_Offroad_01_F', 'config.bin/CfgVehicles/B_G_Offroad_01_F']], [], [], [], [], [] ] ];
			missionNamespace setVariable ["BIS_fnc_garage_centerType", "C_Offroad_01_F"];

			// currentNamespace setvariable ["BIS_fnc_arsenal_fullGarage", false];
			BIS_fnc_garage_centerType=_list;
			BIS_fnc_arsenal_fullGarage=false;

			// ["Open", false] call BIS_fnc_garage;
			// with missionNamespace do { [ "Init", [false,  _return ]] call BIS_fnc_garage }; 
			// ["ListAdd"] execVM "ntech-utils\ntech_fnc_garage.sqf";
			["Open", false] execVM "ntech-utils\ntech_fnc_garage.sqf";
			h = [] spawn {
				waitUntil { ! isNull ( uinamespace getvariable ["BIS_fnc_arsenal_cam",objnull] ) };
				// missionnamespace setvariable ["BIS_fnc_arsenal_fullGarage", false];
				missionNamespace setVariable ["BIS_fnc_garage_data", [ ["\a3\soft_f\offroad_01\offroad_01_unarmed_f", ['config.bin/CfgVehicles/C_Offroad_01_F', 'config.bin/CfgVehicles/B_G_Offroad_01_F']], [], [], [], [], [] ] ];
				// BIS_fnc_garage_data = nil;
			};
		// };
	// }
	// else
	// {
	// 	Hint format["Not enough %1 available\nRequired: %2 %1\nAvailable: %3 %1",_currency, _price, _client_money]; 
	// };

	_return;
};
/*
	UI Functions
*/
/*
	Initialize gui list from trader list
	This is called on start
*/
ntech_simpletrader_initList={
	private["_idc", "_trader", "_newList", "_itemName", "_return"];
	_trader=_this select 0;
	_list=_trader getVariable "ntech_trade_list";
	_idc=ntech_trade_simple_list;
	_newList=[];
	{
		//[config, item, price]
		_config=_x select 0;
		_item=_x select 1;
		// get config item displayName
		_itemName= [ _config, _item, [ "displayName" ] ] call ntech_config_getAttributes;
		_itemName=_itemName select 0;
		// create new list
		_newList = _newList + [ [_itemName, _item] ];
	} forEach _list;
	[ _idc, _newList ] call ntech_gui_setList;
};

/*
	Changes the item selected for buying and
	sets it's description
*/
ntech_simpletrader_changeItem={
	private["_trader", "_idc", "_item", "_idc_price", "_idc_description", "_idc_picture", "_config","_return"];
	_trader=_this select 0;
	_idc=_this select 1;
	_idc_price=_this select 2;
	_idc_description=_this select 3;
	_idc_picture=_this select 4;
	_item=[_idc] call ntech_gui_getCurrentSelection;
	_price=0;
	_itemList=_trader getVariable "ntech_trade_list";
	_config="";
	{
		if ((_x select 1) == ( _item select 1)) exitWith {
			_price=_x select 2;
			_config=_x select 0;
		};
	} forEach _itemList;
	// Hint format["%1, %2", _this, _price];
	ctrlSetText [_idc_price, format["%1", _price]];
	_description=[_config, _item select 1] call ntech_config_getDescription;
	// Hint _idc_description;
	((findDisplay ntech_trade_simple) displayCtrl _idc_description) ctrlSetStructuredText (parseText _description);
	_picture=([_config, _item select 1, [ "picture" ] ] call ntech_config_getAttributes) select 0;
	((findDisplay ntech_trade_simple) displayCtrl _idc_picture) ctrlSetText _picture;
	// _idc_picture
	// Hint format["Name: %1\nClass: %2\nIndex: %3", _item select 0, _item select 1, _item select 2];

};
/*
	Collects information about selection and trader
	for calling the actual trade function
*/
ntech_simpletrader_buy={
	private["_idc", "_trader", "_item", "_marker", "_object", "_price", "_currency", "_money"];
	_trader=_this select 0;
	_idc=_this select 1;
	_idc_price=_this select 2;
	_item=([_idc] call ntech_gui_getCurrentSelection) select 1; 	//Grab th e data field only
	_marker=_trader getVariable "ntech_trade_object";
	getMarkerPos format["_marker"];
	_price=parseNumber (ctrlText _idc_price);
	_object = [_trader, _price, "spawn", _marker, [_item]] call ntech_simpletrader_trade;
};
