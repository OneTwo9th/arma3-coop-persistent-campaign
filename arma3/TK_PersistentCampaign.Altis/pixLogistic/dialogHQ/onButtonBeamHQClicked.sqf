openMap [true, true];
player sidechat "HQ werden gesucht";

pixZonesHqBeamTriggerDone = 0;
pixZonesHqBeamTriggerData = [];		

/* Trigger erstellen und R�ckmeldung abwarten */
private ["_trigger"];
_trigger = createTrigger["EmptyDetector", [15000,15000,0]]; 
_trigger setTriggerArea[15000,15000,0,true];
_trigger setTriggerActivation["ANY", "PRESENT", true]; /* WEST,EAST,CIV*/
_trigger setTriggerStatements["this", "pixZonesHqBeamTriggerData = thislist; pixZonesHqBeamTriggerDone = 1;", ""]; 
_trigger setPos [15000,15000,0];

/* Warten auf die Beendigung des Triggers */
_i = 0;
while { pixZonesHqBeamTriggerDone == 0 and _i < 50} do 
{
	_i = _i + 1;
	sleep 0.1;
};
deleteVehicle _trigger;


/* Marker an den Positionen erstellen */
private ["_i", "_markerName"];
_i = 0;
{
	if (_x isKindOf "Land_Cargo20_military_green_F") then
	{
		_i = _i + 1;
		_markerName = format["pixZonesHqBeamMarker%1", _i];
		createMarkerLocal [_markerName, position _x ];
		
		_markerName setMarkerColorLocal "ColorBlue";
		_markerName setMarkerShapeLocal "ICON";				
		_markerName setMarkerTypeLocal "o_inf";
		_markerName setMarkerTextLocal format["HQ-%1", _i];
		_markerName setMarkerAlphaLocal 1;
		//_markerName setMarkerSizeLocal [0.5, 0.5];
	};
} foreach pixZonesHqBeamTriggerData;


/* Mapclick freigeben */
player sidechat "Bitte gew�nschtes HQ anklicken...";
onMapSingleClick "if (count nearestObjects [player, [""Land_Cargo20_military_green_F""], 50] > 0) then { player setPos _pos;} else { hint ""Kein HQ in der N�he dieser Position"";}; pixZonesHqBeamTriggerData = nil; onMapSingleClick ''; openMap [true, false]; openMap [false, false]; true;";

/* warten bis geklickt wurde */
waitUntil { isNil "pixZonesHqBeamTriggerData" };
pixZonesHqBeamTriggerDone = nil;

/* Marker wieder l�schen */
while { _i > 0 } do
{
	_markerName = format["pixZonesHqBeamMarker%1", _i];
	deleteMarkerLocal _markerName;	
	_i = _i - 1;
};
player sidechat "Beamen abgeschlossen";
