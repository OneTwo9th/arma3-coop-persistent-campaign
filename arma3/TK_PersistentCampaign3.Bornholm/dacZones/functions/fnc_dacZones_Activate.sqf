diag_log format["active: _this = %1", _this];

private["_spalte"];
_spalte = (_this select 0) - 1;
private["_zeile"];
_zeile = (_this select 1) - 1;

private["_links"];
_links = (sectorLinks select _zeile) select _spalte;

{
	private["_linkSpalte"];
	_linkSpalte = _x select 0;
	private["_linkZeile"];
	_linkZeile = _x select 1;
	
	private["_sectorStatusZeile"];
	_sectorStatusZeile = sectorStatus select _linkZeile;
		
	// Referenzz�hler erh�hen
	_sectorStatusZeile set [_linkSpalte, (_sectorStatusZeile select _linkSpalte) + 1];

	// Referenz auf Aktivierung pr�fen
	if ((_sectorStatusZeile select _linkSpalte) == 1) then
	{
		_code = format["tmp = [zx%1y%2] call DAC_Activate;", _linkSpalte, _linkZeile];
		diag_log _code;
		[] call compile _code;
	};
} foreach _links;