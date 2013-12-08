/* 
	Diese Funktion l�scht alle Einheiten einer Gruppe. 
	Optional werden alle defekten Fahrzeuge in die Logistik eingebunden.
	
Parameter:
	groups:				Array mit den zu l�schenden Gruppen.
	vehicles: 			Array mit den zu l�schenden Fahrzeugen.
	buildings:			Array mit den zu l�schenden Geb�uden 
	logisticTransfer:	true/false
	
Return: 
	nix

/*-------------------------------------------------------------------*/

if (!isServer) exitWith {};

private["_group"];
_group = [_this, 0, grpNull, [grpNull]] call BIS_fnc_param;
private["_vehicles"];
_vehicles = [_this, 1, objNull, [objNull]] call BIS_fnc_param;
private["_buildings"];
_buildings = [_this, 2, objNull, [objNull]] call BIS_fnc_param;
private["_logisticTransfer"];
_logisticTransfer = [_this, 3, true, [true]] call BIS_fnc_param;

if (isNull _group) then
{
	/* Gruppen aufr�umen */
	for "_g" from 0 to (count _groups) do 
	{
		/* Wegpunkte l�schen */
		private["_waypoints"];
		_waypoints = waypoints (_groups select _g);
		for "_w" from 0 to (count _waypoints) do
		{
			deleteWaypoint (_waypoints select _w);
		};

		/* Einheiten */
		{ deleteVehicle _x; } foreach (units _group);
		
		/* Gruppe */
		deleteGroup (_groups select _g);		
	};
	
	/* Buildings aufr�umen */
	{ deleteVehicle _x; } foreach _buildings;
	
	/* Vehicles aufr�umen */
	{ 
		if (_logisticTransfer && (!canMove _x)) then 
		{
			[_x] call compile preprocessFileLineNumbers "pixLogistic\serverInsertItem.sqf";
		}
		else
		{
			deleteVehicle _x; 
		};
	} foreach _vehicles;
};