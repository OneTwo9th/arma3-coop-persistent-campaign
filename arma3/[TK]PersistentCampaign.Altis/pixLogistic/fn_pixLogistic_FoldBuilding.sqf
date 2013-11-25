private ["_cursorTarget"];
_cursorTarget = cursorTarget;
if !(isNull _cursorTarget) then
{
	private["_cursorTargetType"];
	_cursorTargetType = typeof _cursorTarget;
	if ((_cursorTargetType in pixlogisticBuildings) || (_cursorTargetType in pixlogisticHQs) || (_cursorTargetType in pixlogisticBuildingsService) || (_cursorTargetType in pixlogisticBuildingsBarracks)) then
	{
		private["_position"];
		_position = getPos _cursorTarget;
		private["_direction"];
		_direction = getDir _cursorTarget;
		
		/*-------------------------*/
		/* Das alte Objekt l�schen */
		/*-------------------------*/
		if (isServer && !isDedicated) then
		{
			player sidechat "simulate server";
			[_cursorTarget] execVM "pixLogistic\serverDeleteItem.sqf";
		}
		else
		{
			pvehPixlogisticDeleteItem = _cursorTarget;
			publicVariable "pvehPixlogisticDeleteItem";
		};

		/*--------------------------------------*/
		/* Einen neuen Container daf�r erzeugen */
		/*--------------------------------------*/
		private["_object"];
		_object = [pixlogisticBuildingContainer, _position] call fn_pixLogistic_CreateCorrectedVehicle;/*_object = createVehicle [pixlogisticBuildingContainer, _position, [], 0, "NONE"];*/
		Sleep .2;		
		_object setDir _direction;
		_object setPos _position;
		_object setVariable ["pixLogisticContent", [_cursorTargetType], true];

		/* zur Datenbank hinzuf�gen*/
		if (isServer && !isDedicated) then
		{
			player sidechat "simulate server";
			[_object] execVM "pixLogistic\serverInsertItem.sqf";
		}
		else
		{
			pvehPixlogisticInsertItem = _object;
			publicVariable "pvehPixlogisticInsertItem";
		};				
	};
};
