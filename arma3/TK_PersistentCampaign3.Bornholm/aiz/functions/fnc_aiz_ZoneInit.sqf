private _zoneIndex = _this select 0;
private _zoneDataSet = _this select 1;

//==========================================================================================
// Marker auslesen
//==========================================================================================
private _markerName = format["markerAiz%1", _zoneIndex];
if (markerType _markerName == "") exitWith { [format["Marker for zoneIndex %1 not found. Markername should be %2", _zoneIndex, _markerName]] call BIS_fnc_error; false; };

private _markerPos = markerPos _markerName;
private _markerSize = markerSize _markerName;
private _markerDir = markerDir _markerName;
private _markerIsRectangle = if (markerShape _markerName == "rectangle") then { true; } else { false; };

//==========================================================================================
// Variablen definieren
//==========================================================================================
private _campsTown = [];		// [house, housePosIndex]
private _campsField = [];		// [position, respawns]
private _checkpoints = [];		// [position, direction]
private _groupCount = 0;

private _geoInfo = [_markerName, 0];

//------------------------------------------------------------------------------------------
// WaypointPool erstellen
//------------------------------------------------------------------------------------------
private _waypointPool = [];		// [position]
for "_i" from 1 to 20 do
{
	_randomPosition = [_geoInfo, [true, false, 50]] call fnc_aiz_GetRandomPosition; // [position]
	if (count _randomPosition > 0) then
	{
		_waypointPool pushBack _randomPosition;
			
		private["_markerNameWp"];
		_markerNameWp = createMarker [format["markerWP%1_%2", _zoneIndex, floor(random 999999)], _randomPosition];
		_markerNameWp setMarkerShape "ICON";
		_markerNameWp setMarkerType "Waypoint";
		_markerNameWp setMarkerSize [0.2, 0.2];
		_markerNameWp setMarkerColor "ColorBlack"; 
		_markerNameWp setMarkerAlpha 0.5;			
	};
};

//==========================================================================================
// Daten generieren oder aus DB übernehmen
//==========================================================================================
if (count _zoneDataSet != 4) then
{
	//diag_log format["AIZ Init-Zone %1 (code)", _zoneIndex];
	//------------------------------------------------------------------------------------------
	// Nach einer Position für CAMP-TOWN suchen
	//------------------------------------------------------------------------------------------
	private _randomPosition = [_geoInfo, [true, [20, 100]]] call fnc_aiz_GetRandomPositionHouse; // [house, buildingPosIndex]
	if (count _randomPosition > 0) then
	{		
		_campsTown pushBack _randomPosition;// [house, buildingPosIndex]
	};
	
	
	//------------------------------------------------------------------------------------------
	// Nach einer Position für CAMP-FIELD suchen
	//------------------------------------------------------------------------------------------
	_randomPosition = [_geoInfo, [5]] call fnc_aiz_GetRandomPositionField; // [position]
	if (count _randomPosition > 0) then
	{			
		_campsField pushBack [_randomPosition, 6 + (random 6)]; // [position, respawnCount]
	};
	
	//------------------------------------------------------------------------------------------
	// Nach Checkpoints für diese Zone suchen
	//------------------------------------------------------------------------------------------
	_randomPosition = [_geoInfo] call fnc_aiz_GetRandomPositionRoad; // [position, direction]
	if (count _randomPosition > 0) then
	{
		_checkpoints pushBack _randomPosition; // [position, direction]
	};
	
	//------------------------------------------------------------------------------------------
	// Festlegen wieviele Gruppen es geben soll
	//------------------------------------------------------------------------------------------
	_groupCount = floor (count _waypointPool / 5);
} 
else
{
	//diag_log format["AIZ Init-Zone %1 (database)", _zoneIndex];
	
	if (count _zoneDataSet >= 1) then
	{
		_campsTown  = (_zoneDataSet select 0); 		// [[house, buildingPosIndex], ..., [house, buildingPosIndex]];
	};
	
	if (count _zoneDataSet >= 2) then
	{
		_campsField  = (_zoneDataSet select 1); 		// [[house, buildingPosIndex], ..., [house, buildingPosIndex]];
	};
	
	if (count _zoneDataSet >= 3) then
	{
		_checkpoints  = (_zoneDataSet select 2); 		// [[house, buildingPosIndex], ..., [house, buildingPosIndex]];
	};
	
	if (count _zoneDataSet >= 4) then
	{
		_groupCount  = (_zoneDataSet select 3); 		// [[house, buildingPosIndex], ..., [house, buildingPosIndex]];
	};
};

//==========================================================================================
// Zone überprüfen, ob mit diesen Daten gestartet werden kann - oder nicht.
//==========================================================================================
private _triggerRequired = false;

if  (_zoneIndex != 29) then
{
	//==========================================================================================
	// Camps-Town initialisieren
	//==========================================================================================
	{
		_triggerRequired = true;	
		[_zoneIndex, _x] spawn fnc_aiz_BuildCampTown;
	} foreach _campsTown;

	//==========================================================================================
	// Camps-Field initialisieren
	//==========================================================================================
	{
		_triggerRequired = true;
		[_zoneIndex, _x] spawn fnc_aiz_BuildCampField;
	} foreach _campsField;

	//==========================================================================================
	// Checkpoints initialisieren
	//==========================================================================================
	{
		_triggerRequired = true;
		[_zoneIndex, _x] spawn fnc_aiz_BuildCheckpoint;
	} foreach _checkpoints;

	//==========================================================================================
	// Gruppen initialisieren
	//==========================================================================================
	if (_groupCount > 0) then
	{
		_triggerRequired = true;
	};
};

//==========================================================================================
// Trigger erstellen
//==========================================================================================
if (_triggerRequired) then
{	
	call compile format["aizZoneData%1 = [_campsTown, _campsField, _checkpoints, _waypointPool, _groupCount];", _zoneIndex];

	private _radiusExtension = if (pixDebug) then { 0 } else { 1000 };
	private["_trigger"];
	_trigger = createTrigger ["EmptyDetector", _markerPos, true];				
	_trigger setTriggerType "NONE";
	_trigger setTriggerArea [(_markerSize select 0) + _radiusExtension, (_markerSize select 1) + _radiusExtension, _markerDir, _markerIsRectangle];
	_trigger setTriggerActivation ["WEST", "PRESENT", true];
	_trigger setTriggerStatements ["this", format["[%1] call fnc_aiz_OnTriggerActivated;", _zoneIndex], format["[%1] call fnc_aiz_OnTriggerDeactivated;", _zoneIndex]];

	_markerName setMarkerAlpha 0;
	_markerName SetMarkerColor "ColorRed";
}
else
{
	_markerName setMarkerAlpha 0.2;
	_markerName SetMarkerColor "ColorGreen";
};