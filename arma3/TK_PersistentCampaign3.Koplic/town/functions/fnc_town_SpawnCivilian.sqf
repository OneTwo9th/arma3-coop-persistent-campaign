diag_log format["fnc_town_SpawnCivilian: _this = %1", _this];
//==========================================================================================
// THIS
//==========================================================================================
params["_townIndex","_townActiveIndex"];

//==========================================================================================
// H�USLE suchen
private _position = [format["markerTown%1",_townIndex]] call fnc_town_GetRandomPositionHouse;
if (count _position == 0) exitWith { [format["No Spawnposition for civilian found: townIndex=%1", _townIndex]] call BIS_fnc_error; };
_position = (_position select 0) buildingPos (_position select 1); // [_house, _buildingPosition]
private _homePosition = [_position select 0, _position select 1, _position select 2];

//==========================================================================================
// Unit erstellen
private _group = createGroup civilian;
private _unit = _group createUnit [townCivClassnames call PIX_fnc_RandomElement, _position, [], 0, "FORM"];
_unit setPos _position;
_unit setDir (random 360);
_unit setUnitAbility 0;
_unit setBehaviour "CARELESS";

private["_markerName"];
_markerName = createMarker [format["markerCiv%1_%2", _townIndex, floor(random 999999)], (getPos _unit)];
_markerName setMarkerShape "ICON";
_markerName setMarkerType "o_inf";
_markerName setMarkerSize [0.4, 0.4];
_markerName setMarkerColor "ColorBlue";
_markerName setMarkerAlpha 1;

#define STATE_THINKING			0
#define STATE_RELAXING			1
#define STATE_WALKING			2
#define STATE_WALKING_HOME		3
#define STATE_WALKING_SUPPLY	4
#define STATE_EXIT				5
#define STATE_SEARCH_SUPPLIES	6
#define STATE_GOHOME 			7
#define STATE_GOSOMEWHERE		8

private _ttl = 0;
private _target = [0,0,0];
private _supply = objNull;

private _state = STATE_THINKING;
private _run = true;
while { _run } do 
{
	switch (_state) do 
	{
		case STATE_THINKING: 
		{ 
			if (pixDebug) then { diag_log format["townIndex: %1 = STATE_THINKING", _townIndex]; };
			// Early out
			if (townActive select _townIndex != _townActiveIndex) exitWith { _state = STATE_EXIT; };

			// Supplies suchen ist immer das Wichtigste!
			private _supplies = nearestObjects [_unit, townSupplyClassnames, townSupplySearchRadius];
			if (count _supplies > 0) then
			{
				_target = (getPos (_supplies select 0));
				_unit doMove _target;
				_state = STATE_WALKING_SUPPLY;			
				_ttl = 100;
			}
			else
			{
				switch (floor(random 3)) do 
				{
					case 1: 
					{
						_state = STATE_GOHOME;
					};
					case 2:
					{
						_state = STATE_GOSOMEWHERE;
					};
					default
					{
						_state = STATE_RELAXING;
					};
				};
			};			
		};
		case STATE_GOHOME:
		{ 
			if (pixDebug) then { diag_log format["townIndex: %1 = STATE_GOHOME", _townIndex]; };
			_unit doMove _homePosition;
			_state = STATE_WALKING_HOME;			
			_ttl = 50;
		};		
		case STATE_GOSOMEWHERE:
		{ 
			if (pixDebug) then { diag_log format["townIndex: %1 = STATE_GOSOMEWHERE", _townIndex]; };
			_target set [0, (_homePosition select 0) - townWalkRadius + random (townWalkRadius*2)];
			_target set [1, (_homePosition select 1) - townWalkRadius + random (townWalkRadius*2)];
			_target set [2, 0];
			_target = _target findEmptyPosition [0, 100, "SoldierWB"];
			if (count _target == 0) then { _state = STATE_RELAXING; }
			else
			{
				_unit doMove _target;
				_state = STATE_WALKING;
				_ttl = 30; // Max 2 Minuten
			};						
		};
		case STATE_RELAXING:
		{ 
			if (pixDebug) then { diag_log format["townIndex: %1 = STATE_RELAXING", _townIndex]; };
			private _idleTime = 5 + floor(random 60);
			if (pixDebug) then { _idleTime = 5; };
			
			if (_idleTime > 10) then
			{
				if (random 1 < 0.5) then
				{
					doStop _unit;
					sleep 0.5;			
					_unit action ["SitDown", _unit];
				};
			};
			
			_markerName setMarkerPos (getPos _unit);
			while { _idleTime > 0 } do
			{
				_markerName setMarkerText format["Relax: %1", _idleTime];
				Sleep 2;
				_idleTime = _idleTime - 2;
				
				// Town inaktiv
				if (townActive select _townIndex != _townActiveIndex) exitWith { _state = STATE_EXIT; };

				// Alive
				if (!alive _unit) exitWith { _state = STATE_EXIT; };
			};
			
			_state = STATE_THINKING;
		};
		case STATE_WALKING:
		{
			if (pixDebug) then { diag_log format["townIndex: %1 = STATE_WALKING", _townIndex]; };
			while {true} do
			{
				_markerName setMarkerPos (getPos _unit);
				_markerName setMarkerText "Walk";

				Sleep 2;
				
				_ttl = _ttl - 1;
				if (_ttl == 0) exitWith { _state = STATE_THINKING; };
				
				// Town inaktiv
				if (townActive select _townIndex != _townActiveIndex) exitWith { _state = STATE_EXIT; };

				// Alive
				if (!alive _unit) exitWith { _state = STATE_EXIT; };

				if (_target distance2D (getPos _unit) < 5) exitWith
				{
					Sleep 2; // Noch mal kurz warten
					
					_state = STATE_THINKING;
				};
			};			
		};		
		case STATE_WALKING_HOME: 
		{
			if (pixDebug) then { diag_log format["townIndex: %1 = STATE_WALKING_HOME", _townIndex]; };
			_markerName setMarkerText "Home";
			while {true} do
			{
				Sleep 2;
				_markerName setMarkerPos (getPos _unit);
			
				_ttl = _ttl - 1;
				if (_ttl == 0) exitWith { _state = STATE_EXIT; };
				
				// Town inaktiv
				if (townActive select _townIndex != _townActiveIndex) exitWith { _state = STATE_EXIT; };

				// Alive
				if (!alive _unit) exitWith { _state = STATE_EXIT; };

				// Ziel erreicht
				diag_log format["Home: %1", _homePosition distance2D (getPos _unit)];
				if (_homePosition distance2D (getPos _unit) < 5) exitWith
				{
					Sleep 2; // Noch mal kurz warten
					if (random 1 < 0.33) then {_state = STATE_EXIT;}
					else {_state = STATE_RELAXING;};
				};
			};			
		};		
		case STATE_WALKING_SUPPLY: 
		{
			if (pixDebug) then { diag_log format["townIndex: %1 = STATE_WALKING_SUPPLY", _townIndex]; };
			while {true} do
			{
				Sleep 2;
				_markerName setMarkerPos (getPos _unit);
				_markerName setMarkerText "Supply";
				
				_ttl = _ttl - 1;
				if (_ttl == 0) exitWith { _state = STATE_THINKING; };

				// Town inaktiv
				if (townActive select _townIndex != _townActiveIndex) exitWith { _state = STATE_EXIT; };
				
				// Alive
				if (!alive _unit) exitWith { _state = STATE_EXIT; };

				// Ziel erreicht
				if (_target distance2D (getPos _unit) < 5) exitWith
				{
					Sleep 2; // Noch mal kurz warten
					private _supplies = nearestObjects [getPos _unit, townSupplyClassnames, 10];
					if (count _supplies > 0) then
					{
						private _supply = _supplies select 0;
						_supply setDamage ((damage _supply) - 0.1);
						if (damage _supply <= 0) then { deleteVehicle _supply; };

						(townInfos select _townIndex) params["_supplies", "_civilianCount", "_houseCount"];
						_supplies = _supplies + 10;
						(townInfos select _townIndex) set [0, _supplies];
					};

					_state = STATE_GOHOME;				
				};
			};			
		};		
		case STATE_EXIT: 
		{ 
			if (pixDebug) then { diag_log format["townIndex: %1 = STATE_EXIT", _townIndex]; };
			diag_log "STATE_EXIT";
			_run = false;
		};
		default 
		{ 
			diag_log format["ERROR: fnc_town_SpawnCivilian.sqf: Invalid state for state-machine: _state=%1", _state];
			_run = false; // Emergency exit
		};
	};

};

//==========================================================================================
// Nachschub spawnen, wenn Town noch aktiv
if (townActive select _townIndex == _townActiveIndex) then { [_townIndex, _townActiveIndex] spawn fnc_town_SpawnCivilian; };

//==========================================================================================
// Aufr�umen
if (alive _unit) then 
{
	deleteVehicle _unit;	
}
else
{
	(townInfos select _townIndex) params["_supplies", "_civilianCount", "_houseCount"];	
	_supplies = _supplies - 10;
	if (_supplies < 0) then { _supplies = 0; }; 
	(townInfos select _townIndex) set [0, _supplies];
};
deleteGroup _group;
deleteMarker _markerName;