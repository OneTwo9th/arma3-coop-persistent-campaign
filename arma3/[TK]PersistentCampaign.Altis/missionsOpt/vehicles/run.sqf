private["_zoneIndex"];
_zoneIndex = _this select 0;
private["_missionInfoIndex"];
_missionInfoIndex = _this select 1;
private["_vehicleClassname"];
_vehicleClassname = _this select 2;

/*----------------------------------*/
/* Die Missionsdaten herausarbeiten */
/*----------------------------------*/
private["_missionOpt"]; /* [missionIndex, missionPosition, missionStatus] */
_missionOpt = ((pvehPixZones_MissionInfos select 2) select _missionInfoIndex);
private["_missionPosition"];
_missionPosition = _missionOpt select 1;

/*---------------------------------------*/
/* Wenn notwendig die Clientside starten */
/*---------------------------------------*/
if (!isServer || !isDedicated) then
{
	private["_tmp"];
	_tmp = [_missionInfoIndex, _missionPosition, _vehicleClassname] execVM "missionsOpt\vehicles\runClient.sqf";	
};

if (isServer) then
{
	private["_units"];
	_units = [];

	private["_vehicle1"];
	_vehicle1 = _vehicleClassname createVehicle _missionPosition;
	Sleep .2;
	_vehicle1 lock true;
	_vehicle1 setdir random 360;
	_normal = surfaceNormal (position _vehicle1);
	_vehicle1 setVectorUp _normal;
	_units = _units + [_vehicle1];

	private["_vehicle2"];
	_vehicle2 = _vehicleClassname createVehicle [_missionPosition select 0, (_missionPosition select 1) + ((random 100) - 50), 0]; 
	Sleep .2;
	_vehicle2 lock true;
	_vehicle2 setdir random 360;
	_normal = surfaceNormal (position _vehicle2);
	_vehicle2 setVectorUp _normal;
	_units = _units + [_vehicle2];

	private["_vehicle3"];
	_vehicle3 = _vehicleClassname createVehicle [(_missionPosition select 0) + ((random 100) - 50), _missionPosition select 1, 0]; 
	Sleep .2;
	_vehicle3 lock true;
	_vehicle3 setdir random 360;
	_normal = surfaceNormal (position _vehicle3);
	_vehicle3 setVectorUp _normal;
	_units = _units + [_vehicle3];
	

	private["_spawnGroup"];
	private["_randomPos"];
	private["_random"];
	_random = floor (random 3) + 1;
	for "_i" from 0 to _random do 
	{
		_randomPos = [[[_missionPosition, random 400 + 250]],["water","out"]] call BIS_fnc_randomPos;
		private["_spawnGroup"];
		_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam")] call BIS_fnc_spawnGroup;
		nul = [_spawnGroup, _missionPosition, random 600 + 300] call fn_missionsOpt_Patrol;
		_units = _units + (units _spawnGroup);
		 [_spawnGroup] call fn_missionsOpt_SetSkill;
	};

	_random = floor (random 2) + 1;
	for "_i" from 0 to _random do 	
	{
		_randomPos = [[[_missionPosition,random 150]],["water","out"]] call BIS_fnc_randomPos;
		_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam")] call BIS_fnc_spawnGroup;
		[_spawnGroup, _missionPosition] call BIS_fnc_taskDefend;
		_units = _units + (units _spawnGroup);
		 [_spawnGroup] call fn_missionsOpt_SetSkill;
	};

	_vehicle1 setDamage 0.5;
	_vehicle2 setDamage 0.5;
	_vehicle3 setDamage 0.5;
	if (_vehicle1 distance [0,0,0] < 1000) then { _vehicle1 setDamage 1;};
	if (_vehicle2 distance [0,0,0] < 1000) then { _vehicle2 setDamage 1;};
	if (_vehicle3 distance [0,0,0] < 1000) then { _vehicle3 setDamage 1;};

	/*--------------------------------------*/
	/* Warten bis die Mission erf�llt wurde */
	/*--------------------------------------*/
	waitUntil {((!alive _vehicle1) &&(!alive _vehicle2) &&(!alive _vehicle3)) || (pixZones_ActiveIndex == -1)};
	
	/*--------------------------------------------------------*/
	/* Status auf beendet setzen und allen Clienten mitteilen */
	/*--------------------------------------------------------*/
	if (pixZones_ActiveIndex != -1) then
	{
		pvehPixZones_MissionStatus set [_missionInfoIndex, 1]; /* erfolgreich */	
	}
	else
	{	
		pvehPixZones_MissionStatus set [_missionInfoIndex, 2]; /* Fehlgeschlagen */
	};
	publicVariable "pvehPixZones_MissionStatus";
	if (!isDedicated) then { call compile preprocessFileLineNumbers "pixZones\pvehPixZones_MissionStatus.sqf"; }; /* PublicVariableEventHandler simulieren */

	/*-----------------------*/
	/* Kurze Zeitverz�gerung */
	/*-----------------------*/
	if (pixDebug) then
	{
		sleep 60;
	}
	else
	{
		sleep 10;
	};

	/*------------------------*/
	/* Alle Einheiten l�schen */
	/*------------------------*/
	{deletevehicle _x} foreach _units;
};