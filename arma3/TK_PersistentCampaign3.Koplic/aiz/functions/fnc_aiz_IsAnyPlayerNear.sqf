/* 
Pr�ft ob sich irgendein Spieler in der N�he der angegebenen Koordinate befindet.

Parameter:
	_position: Die zu �berpr�fende Position
	_distance: Die maximale Entfernung (m) in der sich der Spieler befinden darf.

Return: 
	TRUE wenn sich mindestens ein Spieler in der N�he befindet, sonst FALSE.
*/

/*
private["_position"];
_position = _this select 0;
private["_distance"];
_distance = _this select 1;
*/
//private["_result"];
//_result = false;
/*
private["_players"];
_players = playableUnits;
if (count _players == 0) then { _players = [player]; };

private["_maxDistance"];
_maxDistance = (_distance)^2; //optimierter Ausdruck f�r: _maxDistance = [_position, [_position select 0, (_position select 1) + _distance]] call BIS_fnc_distance2Dsqr;
{
	if (_maxDistance >= [_position, _x] call BIS_fnc_distance2Dsqr) exitWith { _result = true; };
} foreach _players;
*/



private["_units"];
_units = (_this select 0) nearEntities ["SoldierGB", (_this select 1)];
(count _units > 0)