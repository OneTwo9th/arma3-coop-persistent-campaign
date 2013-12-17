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

private["_groups"];
_groups = [_this, 0, [], [[]]] call BIS_fnc_param;
private["_vehicles"];
_vehicles = [_this, 1, [], [[]]] call BIS_fnc_param;
private["_buildings"];
_buildings = [_this, 2, [], [[]]] call BIS_fnc_param;
private["_logisticTransfer"];
_logisticTransfer = [_this, 3, true, [true]] call BIS_fnc_param;

/* Gruppen aufr�umen */
for "_g" from 0 to ((count _groups)-1) do 
{
	/* Wegpunkte l�schen */
	private["_waypoints"];
	_waypoints = waypoints (_groups select _g);
	for "_w" from 0 to ((count _waypoints)-1) do
	{
		deleteWaypoint (_waypoints select _w);
	};

	/* Einheiten */
	{ deleteVehicle _x; } foreach (units (_groups select _g));
	
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
