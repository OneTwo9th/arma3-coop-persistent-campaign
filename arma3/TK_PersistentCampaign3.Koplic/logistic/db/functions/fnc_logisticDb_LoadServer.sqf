if (isServer) then
{
	// ------------------------------------------------------------------------------
	// Vorbereiten
	waitUntil { !logisticDbSaving };
	logisticDbSaving = true;
	"LOGISTIC-Database loading" remoteExec ["hint"];

	#include "_databaseIndexes.hpp"

	// Datenbank aus dem VAR-Bereich lesen
	//private _database = [];
	private _database = profileNameSpace getVariable [(logisticDbPrefix + "_database"), []];
	diag_log format["LOGISTIC-Database loaded: %1", _database];

	//------------------------------------
	// Fahrzeuge aus der Datenbank laden und erstellen
	//------------------------------------
	if (count _database > VEHICLE_INDEX) then
	{
		private _vehicles = _database select VEHICLE_INDEX;

		{	
			// _x = [_classname, _position, _direction, _damageArray, _cargoArray];	
			// Fahrzeug erstellen
			private _vehicle = [(_x select 0), (_x select 1), (_x select 2)] call fnc_logisticDb_CreateVehicleCorrected;
			// Schaden hinzufügen
			[_vehicle, (_x select 3)] call  fnc_logisticDb_SetVehicleDamageArray;
			// Ladung hinzufügen
			[_vehicle, (_x select 4)] call  fnc_logisticDb_SetVehicleCargoArray;
		} foreach _vehicles; 
	};

	//------------------------------------
	// Ammoboxen aus der Datenbank laden und erstellen
	//------------------------------------
	/*if (count _database > AMMOBOX_INDEX) then
	{
		private _ammoboxes = _database select AMMOBOX_INDEX;

		{	
			// _x = [_classname, _position, _direction, _damageArray, _cargoArray];	
			// Fahrzeug erstellen
			private _vehicle = [(_x select 0), (_x select 1), (_x select 2)] call fnc_logisticDb_CreateVehicleCorrected;
			// Schaden hinzufügen
			_vehicle setDamage (_x select 3);
			// Ladung hinzufügen
			[_vehicle, (_x select 4)] call  fnc_logisticDb_SetVehicleCargoArray;
		} foreach _ammoboxes; 
	};*/

	//------------------------------------
	// Objekte aus der Datenbank laden und erstellen
	//------------------------------------
	if (count _database > OBJECT_INDEX) then
	{
		private _objects = _database select OBJECT_INDEX;

		{	
			// _x = [_classname, _position, _direction, _damageArray, _cargoArray];	
			// Fahrzeug erstellen
			private _vehicle = [(_x select 0), (_x select 1), (_x select 2)] call fnc_logisticDb_CreateVehicleCorrected;
			// Schaden hinzufügen
			_vehicle setDamage (_x select 3);
		} foreach _objects; 
	};

	// ------------------------------------------------------------------------------
	// Bestätigung ausgeben
	"LOGISTIC-Database loading complete" remoteExec ["hint"];

	// ------------------------------------------------------------------------------
	// Nachbereiten
	logisticDbSaving = false;
};