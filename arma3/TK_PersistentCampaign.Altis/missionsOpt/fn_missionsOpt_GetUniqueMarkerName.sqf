waitUntil { !missionsOpt_GetUniqueMarkerName_Mutex };
missionsOpt_GetUniqueMarkerName_Mutex = true;

/*-----------------------------------*/
/* Eindeutigen Markernamen erstellen */
/*-----------------------------------*/
private["_i"];
_i = 0;
private["_result"];
_result = format["marker_unique_%1", _i];
while { str(getMarkerPos _result) != "[0,0,0]" } do 
{
	_i = _i + 1;
	_result = format["marker_unique_%1", _i];
};

missionsOpt_GetUniqueMarkerName_Mutex = false;
_result;