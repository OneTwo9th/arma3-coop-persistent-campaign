if (isServer) then
{
	/* -------------------------------------*/
	/* Schleife zum automatischen speichern */
	/* -------------------------------------*/
	while { true } do
	{
		Sleep 580; /* knapp 10 Minuten um eine gewisse asynchronitšt zu erhalten. */
		_script = [] execVM "pixLogistic\serverSaveAllItems.sqf";
		waitUntil {scriptDone _script};
	};
};