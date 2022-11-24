// NUtils Base Hangar
// arguments: 	0 - unit - unit - The hangar master unit
// 			1 - array - list_pads - Array of pads, positions where the vehicle is created
// 			2 - array - list_paddirections - Array of directions for how the vehicle is to be orientated on the pad
// 			3 - array - list_hangars - Array of Hangars, positions where to store vehicles
// 			4 - array - list_hangardirection - List of directions the Vehicle should face in the hangar
// 			5 - array - list_hangarDisplayName - List of Display names for hangars
// 			6 - array - list_filters - Entity filter: Air, Car, Tank, Man. Special cases: ALL - will skip filter.
// 			7 - bool - check_owner - Check for vehicle ownership
[HelipadHangar_HangarMaster, 
[(position HelipadHangar_Hangar1), (position HelipadHangar_Hangar2), (position HelipadHangar_Hangar3)],
[190, 190, 325],
[(position HelipadHangar_Pad1), (position HelipadHangar_Pad2), (position HelipadHangar_Pad3)],
[190, 190, 325],
["Alpha", "Bravo", "Charlie"],
["Air", "All", "Car"],
true,
3
] execVM "nutils-base\hangar\initHangarMaster.sqf";