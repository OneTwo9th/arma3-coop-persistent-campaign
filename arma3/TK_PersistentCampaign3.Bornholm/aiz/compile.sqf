if (isServer) then
{
	fnc_aiz_IsInGeoInfo = compile preprocessFileLineNumbers "aiz\functions\fnc_aiz_IsInGeoInfo.sqf";

	fnc_aiz_GetRandomPosition = compile preprocessFileLineNumbers "aiz\functions\fnc_aiz_GetRandomPosition.sqf";
	fnc_aiz_GetRandomPositionRoad = compile preprocessFileLineNumbers "aiz\functions\fnc_aiz_GetRandomPositionRoad.sqf";
	fnc_aiz_GetRandomPositionField = compile preprocessFileLineNumbers "aiz\functions\fnc_aiz_GetRandomPositionField.sqf";
	fnc_aiz_GetRandomPositionHouse = compile preprocessFileLineNumbers "aiz\functions\fnc_aiz_GetRandomPositionHouse.sqf";

	fnc_aiz_BuildCampField = compile preprocessFileLineNumbers "aiz\functions\fnc_aiz_BuildCampField.sqf";
	fnc_aiz_BuildCampTown = compile preprocessFileLineNumbers "aiz\functions\fnc_aiz_BuildCampTown.sqf";
	fnc_aiz_BuildCheckpoint = compile preprocessFileLineNumbers "aiz\functions\fnc_aiz_BuildCheckpoint.sqf";

	fnc_aiz_IsFlat = compile preprocessFileLineNumbers "aiz\functions\fnc_aiz_IsFlat.sqf";
	fnc_aiz_CreateMineField = compile preprocessFileLineNumbers "aiz\functions\fnc_aiz_CreateMineField.sqf";
	fnc_aiz_CreateMineFieldRandom = compile preprocessFileLineNumbers "aiz\functions\fnc_aiz_CreateMineFieldRandom.sqf";
	fnc_aiz_GetMaxBuildingPositions = compile preprocessFileLineNumbers "aiz\functions\fnc_aiz_GetMaxBuildingPositions.sqf";
	fnc_aiz_GetMaxBuildingsPositions = compile preprocessFileLineNumbers "aiz\functions\fnc_aiz_GetMaxBuildingsPositions.sqf";
	fnc_aiz_CreateGroup = compile preprocessFileLineNumbers "aiz\functions\fnc_aiz_CreateGroup.sqf";
	fnc_aiz_IsAnyPlayerNear = compile preprocessFileLineNumbers "aiz\functions\fnc_aiz_IsAnyPlayerNear.sqf";
	fnc_aiz_NearestResidentialLocation = compile preprocessFileLineNumbers "aiz\functions\fnc_aiz_NearestResidentialLocation.sqf";
	fnc_aiz_RandomElement = compile preprocessFileLineNumbers "aiz\functions\fnc_aiz_RandomElement.sqf";

	fnc_aiz_ZoneInit = compile preprocessFileLineNumbers "aiz\functions\fnc_aiz_ZoneInit.sqf";
	fnc_aiz_ZoneResume = compile preprocessFileLineNumbers "aiz\functions\fnc_aiz_ZoneResume.sqf";
	fnc_aiz_ZonePause = compile preprocessFileLineNumbers "aiz\functions\fnc_aiz_ZonePause.sqf";

	fnc_aiz_OnTriggerActivated = compile preprocessFileLineNumbers "aiz\functions\fnc_aiz_OnTriggerActivated.sqf";
	fnc_aiz_OnTriggerDeactivated = compile preprocessFileLineNumbers "aiz\functions\fnc_aiz_OnTriggerDeactivated.sqf";
};

diag_log "aiz compiled";