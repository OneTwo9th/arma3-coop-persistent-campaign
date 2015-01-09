/* 
Gibt alle Spieler zur�ck, die sich innerhalb des angegebenen Bereichs befinden.

Parameter:
	_position: Die zu �berpr�fende Position
	_distance: Die maximale Entfernung (m) in der sich der Spieler befinden darf.

Return: 
	[]: Wenn keine Spieler in der N�he sind, sonst ein Array mit den Spielern.
*/

private["_position"];
_position = _this select 0;
private["_distance"];
_distance = _this select 1;

private["_result"];
_result = [];

private["_players"];
_players = playableUnits;
if (count _players == 0) then { _players = [player]; };

private["_maxDistance"];
_maxDistance = (_distance)^2; //optimierter Ausdruck f�r: _maxDistance = [_position, [_position select 0, (_position select 1) + _distance]] call BIS_fnc_distance2Dsqr;
{
	if (([_position, _x] call BIS_fnc_distance2Dsqr) < _maxDistance) then
	{
		_result pushBack _x;
	};
} foreach _players;

_result;