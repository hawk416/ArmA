/*
	NTech trade init script
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
/*
	description: Takes the amount from payee and gives it to reciever
				respecting "currency" as the variable name
	params:
	0 - payee - the object to take the credits from
	1 - reciever - the object to add credits to
	2 - amount - the amount of currency to transact
	*3 - currency - optional currency (default: credits) 
*/
ntech_trade_transaction={
	private _return=false;
	private _payee=_this select 0;
	private _reciever=_this select 1;
	private _amount=_this select 2;
	private _currency="credits";
	if (count _this == 4) then {
		_currency=_this select 3;
	};
	// Check if payee has the amount
	_payee_balance=_payee getVariable [_currency,0];
	if ( _payee_balance >= _amount) then {
		_payee setVariable[_currency,(_payee_balance-_amount)];
		_return=true;
		// Add to recieve if he exists
		if !(_reciever == objNull) then{
			_reciever setVariable [_currency, (_reciever getVariable[_currency,0])+_amount];
		};
	};
	_return
};