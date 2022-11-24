/*
    Calculate Item Price
*/
params["_item", "_amount", "_ammo"];
if (isNil "_amount") then {_amount=1};
if (isNil "_ammo") then {_ammo=1} else {
    _count=getNumber (configFile >> "CfgMagazines" >> _item >> "count");
    _ammo=_ammo/_count;
};
_ret=[0,0,0];
switch true do
{
    case(isClass(configFile >> "CfgMagazines" >> _item)): {_ret=[1,1,1] };
    case(isClass(configFile >> "CfgWeapons" >> _item)): {_ret=[2,2,2] };
    case(isClass(configFile >> "CfgVehicles" >> _item)): {_ret=[3,3,3] };
    case(isClass(configFile >> "CfgGlasses" >> _item)): {_ret=[4,4,4] };
    case(isClass(configFile >> "CfgItems" >> _item)): {_ret=[5,5,5] };
};
_ret=_ret vectorMultiply _amount;
_ret=_ret vectorMultiply _ammo;
_ret;