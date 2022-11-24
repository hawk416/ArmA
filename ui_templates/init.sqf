disableserialization;
enablesaving [false,false];

waituntil {time > 0};
createdialog "RscTestControlTypes";

player addaction ["<t size='1.5'>UI Types</t>",{createdialog "RscTestControlTypes";},[],10];
player addaction ["<t size='1.5'>UI Styles</t>",{createdialog "RscTestControlStyles";},[],10];

activatekey "moricky_uiControls";
markAsFinishedOnSteam;