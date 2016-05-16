private["_zoneIndex"];
_zoneIndex = _this select 0;
private["_camp"];
_camp = _this select 1;

private["_house"];
_house = (_camp select 0) select 0;
private["_positionIndex"];
_positionIndex = (_camp select 0) select 1;
private["_respawns"];
_respawns = _camp select 1;


private["_markerName"];
_markerName = createMarkerLocal [format["markerTown%1", random 999999], getPos _house];
_markerName setMarkerShapeLocal "ICON";
_markerName setMarkerTypeLocal "o_inf";
_markerName setMarkerSizeLocal [0.5, 0.5];
_markerName setMarkerTextLocal format["t %1 / %2", _respawns, _positionIndex];
_markerName setMarkerColorLocal "ColorRed"; 
_markerName setMarkerAlphaLocal 0.8;