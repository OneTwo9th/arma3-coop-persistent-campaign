private["_markerBaseName"];
_markerBaseName = _this select 0;

private["_result"];
_result = [];

/* Alle verf�gbaren Marker bestimmen */
private["_totalMarkerCount"];
_totalMarkerCount = 0;
_markerName = format["%1_%2", _markerBaseName, _totalMarkerCount];
while { str(getMarkerPos _markerName) != "[0,0,0]"} do 
{
	_totalMarkerCount = _totalMarkerCount + 1;
	_markerName = format["%1_%2", _markerBaseName, _totalMarkerCount];
};

/* Den gew�nschten Index zur�ck geben */
_result = floor(random _totalMarkerCount);
_result