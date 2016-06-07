#include "..\defines.hpp"
params ["_zoneIndex", "_camp"];
_camp params ["_house","_positionIndex"];

#ifndef NO_MARKERS
private["_markerName"];
_markerName = createMarker [format["markerTown%1", floor(random 999999)], getPos _house];
_markerName setMarkerShape "ICON";
_markerName setMarkerType "o_hq";
_markerName setMarkerSize [0.5, 0.5];
_markerName setMarkerText format["t %1", _positionIndex];
_markerName setMarkerColor "ColorOrange"; 
_markerName setMarkerAlpha 0.8;
#endif

// Als erstes die Schranke erstellen, da sich alles um diese Schranke dreht. 
private _laptop = createVehicle [aizCampTownClassnames call PIX_fnc_RandomElement, (_house buildingPos _positionIndex), [], 0, "NONE"];
Sleep .2;
_laptop setPos (_house buildingPos _positionIndex);