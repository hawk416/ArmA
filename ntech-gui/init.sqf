/*
	======/ NTech GUI Utilities \======
*/

/*
	GUI_idc's
*/
ntech_gui_large_frame = 4051;
ntech_gui_large_background = 4052;
ntech_gui_large_header = 4053;
ntech_gui_large_close = 4054;
ntech_gui_large_menu_default_ok = 4055;
ntech_gui_large_menu_default_cancel = 4056;
ntech_gui_large_menu_trade_pricetxt = 4057;
ntech_gui_large_menu_trade_pricetype = 4058;
ntech_gui_large_menu_trade_pricevalue = 4059;

/*
	======/ Functions \======
*/
/*
	Set Gui List
	params: 
		0 - _idc 	: IDC of control to set list
		1 - _list 	: List of item + data in format [[item, data], [item,data]]
*/
ntech_gui_setList = {
	private["_idc", "_list", "_index"];
	_idc=_this select 0;
	_list=_this select 1;
	// Hint format["%1,%2", _idc, _list];
	// sleep 2;
	//clear old list
	lnbClear _idc;
	{
		_index = lbAdd [_idc, _x select 0];
		lbSetData [_idc, _index, _x select 1];
	} forEach _list;
	// Hint "";
	lbSetCurSel [_idc, 0];
};

ntech_gui_getCurrentSelection = {
	private ["_idc", "_index", "_return"];
	_return=[];
	_idc= _this select 0;
	_index= lbCurSel _idc;
	_return = [ lbText[_idc, _index], lbData[_idc, _index], _index ];
 	_return;
};

/*
	Sets the header with standardized style
*/
ntech_gui_setHeader = {

};
/*
	sets event handlers
		arguments:
			1: Display idd
			2: Array of idcs, event handlers and functions.
				syntax:[ [idc, "event", "fnc"], [idc, "event", "fnc"], [idc, "event", "fnc"] ] 
				event handlers: 
*/
ntech_gui_setEventHandlers = {
	private["_idd", "_idc", "_event", "_fnc"];
	_idd = _this select 0;
	{
		_idc = _x select 0;
		_event = _x select 1;
		_fnc = _x select 2;
		((findDisplay _idd) displayCtrl _idc) ctrlAddEventHandler [_event, _fnc];
	} forEach ( _this select 1 );
};
/*
	Create dialog function
		arguments:
			1: Base class idc
			2: Base class name
			3: List of additional controls to be created. 
				syntax: [ ["classname", idc, [positionX, positionY, sizeW sizeH],"control handler", "control function"] ]
*/
ntech_gui_createDialog = {
	private ["_baseIdc", "_base", "_ctrlList", "_dialog", "_handler", "_event", "_class", "_idc", "_control", "_position"];
	_baseIdc = _x select 0;
	_base = _this select 1;
	_ctrlList = _this select 2;

	_dialog = createDialog _base;
	if (_dialog) then
	{
		disableSerialization;
		waitUntil { !(isNull (findDisplay 0))};
		{
			_class = _x select 0;
			_idc = _x select 1;
			_position = _x select 2;
			_dialog = findDisplay _baseIdc;
			_control = _dialog ctrlCreate [_class, _idc];
			_control ctrlSetPosition _position;
			// ctrlSetText [_control, "Hello World"];
			// Hint format["Position set to: %1", _position];
			if ((count _X) >= 5) then
			{
				_handler = _x select 3;
				_event = _x select 4;
				_control ctrlAddEventHandler [_handler, _function];
			};
			_control ctrlCommit 0;
		} forEach _ctrlList;
	} 
	else
	{
		Hint "Dialog could not be created";
	};	
};