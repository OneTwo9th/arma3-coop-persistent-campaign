call compile preprocessFileLineNumbers "mainmenu\config.sqf";
call compile preprocessFileLineNumbers "mainmenu\functions\_compile.sqf";

[] spawn {
	// if (!isServer || !isDedicated) then
	if ((hasInterface) && (side player != east)) then
	{
		waitUntil { !isNull player };
		["Persistent Campaign", {true}, {call fnc_MainMenu_ShowDialog}, false] call AGM_Interaction_fnc_addInteractionSelf;
	};
};

if (isServer) then
{
	pvPlayerTeleport = false;
	publicVariable "pvPlayerTeleport";
};