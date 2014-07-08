private["_zoneIndex"];
_zoneIndex = _this select 0;
private["_missionInfoIndex"];
_missionInfoIndex = _this select 1;

/*----------------------------------*/
/* Die Missionsdaten herausarbeiten */
/*----------------------------------*/
private["_missionOpt"]; /* [missionIndex, missionPosition, missionDirection, markerPosition, markerRadius] */
_missionOpt = ((pvehPixZones_MissionInfos select 2) select _missionInfoIndex);
private["_missionPosition"];
_missionPosition = _missionOpt select 1;
private["_missionDirection"];
_missionDirection = _missionOpt select 2;
private["_missionMarkerPosition"];
_missionMarkerPosition = _missionOpt select 3;
private["_missionMarkerRadius"];
_missionMarkerRadius = _missionOpt select 4;

/*---------------------------------------*/
/* Wenn notwendig die Clientside starten */
/*---------------------------------------*/
if (!isServer || !isDedicated) then
{
	[_missionPosition, _missionInfoIndex, _missionMarkerPosition, _missionMarkerRadius] spawn {
		/* Variablen übergeben */
		private["_missionPosition"];
		_missionPosition = _this select 0;
		private["_missionInfoIndex"];
		_missionInfoIndex = _this select 1;
		private["_missionMarkerPosition"];
		_missionMarkerPosition = _this select 2;
		private["_missionMarkerRadius"];
		_missionMarkerRadius = _this select 3;
		/*-------------------------*/
		/* Missions vorbereitungen */
		/*-------------------------*/
		/* Objekte suchen (warten bis erzeugt) */
		private["_counter"];
		_counter = 20;
		private["_objects"];
		_objects = [];
		while { (count _objects != 1) && (_counter > 0) } do
		{
			Sleep 0.5;
			_objects = nearestObjects [_missionPosition, ["O_officer_F"], 300];
			_counter = _counter - 1;
		};
		
		Sleep 1;
		
		/* Action Menü zu den Objekten hinzufügen */
		{ 
			if (_x getVariable ["missionOptCaptureOfficer", false]) then
			{
				_x addAction["Gefangen nehmen", "missionsOpt\_common\actionTakeCaptive.sqf"]; 
			};
		} foreach _objects;
		
		/*----------------------------------------*/
		/* Standart Missions verarbeitung starten */
		/*----------------------------------------*/
		private["_taskTitle"];
		_taskTitle = "Gefangennahme";
		private["_taskDescription"];
		_taskDescription = "Unser Geheimdienst hat Hinweise darauf bekommen, dass sich ein hochrangiger Offizier gerade auf Patroulie im Feld befindet. Nehmen sie den Offizier gefangen und bringen ihn außerhalb der Angriffssektors.";
		
		private["_tmp"];
		_tmp = [_missionInfoIndex, _missionMarkerPosition, _missionMarkerRadius, _taskTitle, _taskDescription] execVM "missionsOpt\_common\runClient.sqf";	
	};	
};

if (isServer) then
{
	private["_groups"];
	_groups = [];
	private["_vehicles"];
	_vehicles = [];
	private["_buildings"];
	_buildings = [];
	 	
	/*------------------------------*/
	/* Gruppe des Officers erzeugen */
	/*------------------------------*/
	private["_groupOfficer"];
	_groupOfficer = [_missionPosition, east, ["O_officer_F","O_medic_F","O_recon_F"]] call BIS_fnc_spawnGroup;	
	Sleep .2;
	_groups = _groups + [_groupOfficer];	
	private["_officer"];
	_officer = (units _groupOfficer) select 0;
	_officer setVariable ["missionOptCaptureOfficer", true, true];

	/*-----------------*/
	/* Skill festlegen */
	/*-----------------*/
	[_groupOfficer] call PC_fnc_SetSkill;
	
	/*--------------------------*/
	/* Patroullienroute anlegen */
	/*--------------------------*/
	[_groupOfficer, _zoneIndex, _missionPosition, 100, 10] call PC_fnc_PatrolObject;
	if (isServer && !isDedicated) then { [_groupOfficer, true, "ColorRed","Ofc"] spawn PC_fnc_TrackGroup;};

	if (pixParamMissionOpt == 1) then
	{
		/*----------------------------------------------------------------------------*/
		/* Anzahl der Spieler berechnen um den Schwierigkeitsgrad bestimmen zu können */
		/*----------------------------------------------------------------------------*/
		private["_patrolCount"];
		_patrolCount = ceil((call PC_fnc_GetPlayerCount) / 6);

		/*-------------------------*/
		/* Patroullierende Truppen */
		/*-------------------------*/
		for "_i" from 0 to _patrolCount do 
		{
			private["_groupInfos"];
			_groupInfos = [["OIA_InfSquad","OIA_InfTeam","OIA_InfTeam_AT","OIA_MotInf_Team","OIA_MotInf_AT"], _zoneIndex, _missionPosition, 600, 25] call PC_fnc_SpawnGroupPatrolObject;		
			if (count _groupInfos > 0) then
			{
				_groups = _groups + [(_groupInfos select 0)];
				_vehicles = _vehicles + (_groupInfos select 1);
			};
		};
	};
	
	if (pixParamMineFields == 1) then
	{
		/*-------------*/
		/* Minenfelder */
		/*-------------*/
		private["_mineFieldCount"];
		_mineFieldCount = 1 + floor(random 2);
		for "_i" from 0 to _mineFieldCount do 
		{
			[_missionPosition, ["APERSTripMine"]] call PC_fnc_CreateMineFieldAtTarget;
		};
	};
	
	/*--------------------------------------*/
	/* Warten bis die Mission erfüllt wurde */
	/*--------------------------------------*/
	private["_continue"];
	_continue = true;
	private["_disarmed"];
	_disarmed = false;
	while { _continue } do
	{
		if (!alive _officer) then { _continue = false; };
		if (pixZones_ActiveIndex == -1) then { _continue = false; };
		if (!([_zoneIndex, getPos _officer] call PC_fnc_IsPositionInZone)) then { _continue = false; };
		
		if (!_disarmed) then
		{
				player globalChat "check";
			if (count units group _officer == 1) then
			{
				player globalChat "disarmed";
				_disarmed = true;
				
				/* Aktuelle Ausrüstung löschen */
				removeAllPrimaryWeaponItems _officer;
				removeAllHandgunItems _officer;
				removeAllWeapons _officer; 
				
				/* Officer gibt auf */
				doStop _officer;
				_officer action["sitdown", _officer];
			};
		};
		Sleep 5;
	};
		
	/*--------------------------------------------------------*/
	/* Status auf beendet setzen und allen Clienten mitteilen */
	/*--------------------------------------------------------*/
	/*[_missionInfoIndex] call PC_fnc_FinishMissionStatus;*/
	if ((!alive _officer) || (pixZones_ActiveIndex == -1)) then
	{
		(pvehPixZones_MissionStatus select 1) set [_missionInfoIndex, 2]; /* Fehlgeschlagen */
	}
	else
	{
		(pvehPixZones_MissionStatus select 1) set [_missionInfoIndex, 1]; /* erfolgreich */	
	};
	publicVariable "pvehPixZones_MissionStatus";
	if (!isDedicated) then { call compile preprocessFileLineNumbers "pixZones\pvehPixZones_MissionStatus.sqf"; }; /* PublicVariableEventHandler simulieren */

	/*-------------------------------------------------------------------------------------------------------------*/
	/* Warten bis Zone beendet. Dann nocheinmal zufällige Zeitverzögerung, damit nicht alle gleichzeitig aufräumen */
	/*-------------------------------------------------------------------------------------------------------------*/
	waitUntil {pixZones_ActiveIndex == -1 };
	sleep (random 60);
	[_groups, _vehicles, _buildings, true] call PC_fnc_CleanupMission;
};