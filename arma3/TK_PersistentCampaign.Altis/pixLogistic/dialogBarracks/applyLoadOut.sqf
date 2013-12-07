/*G_Sport_Red / G_Sport_BlackWhite / G_Shades_Black / G_Combat /  G_Tactical_Clear / ["Taucher", ["G_Diving","","U_B_Wetsuit","V_RebreatherB","keep"]]
/* _this parameter abfragen */
private["_unit"];
_unit = _this select 0;
private["_loadout"];
_loadout = _this select 1;

/* Loadout abfragen */
private["_result"];
_result = _unit call compile preprocessFileLineNumbers format["pixLogistic\dialogBarracks\loadouts\%1", _loadout];

/* Result lesbar machen */
private["_goggleClassname"];
_goggleClassname = _result select 0;

private["_headgearClassname"];
_headgearClassname = _result select 1;

private["_binocularClassname"];
_binocularClassname = _result select 2;

private["_nightVisionClassname"];
_nightVisionClassname = _result select 3;

private["_linkedItems"];
_linkedItems = _result select 4;

private["_primaryWeapon"];
_primaryWeapon = _result select 5;
private["_primaryWeaponClassname"];
_primaryWeaponClassname = _primaryWeapon select 0;
private["_primaryWeaponMagazine"];
_primaryWeaponMagazine = _primaryWeapon select 1;
private["_primaryWeaponItems"];
_primaryWeaponItems = _primaryWeapon select 2;

private["_secondaryWeapon"];
_secondaryWeapon = _result select 6;
private["_secondaryWeaponClassname"];
_secondaryWeaponClassname = _secondaryWeapon select 0;
private["_secondaryWeaponMagazine"];
_secondaryWeaponMagazine = _secondaryWeapon select 1;
private["_secondaryWeaponItems"];
_secondaryWeaponItems = _secondaryWeapon select 2;

private["_handgun"];
 _handgun = _result select 7;
private["_handgunClassname"];
_handgunClassname = _handgun select 0;
private["_handgunMagazine"];
_handgunMagazine = _handgun select 1;
private["_handgunItems"];
_handgunItems = _handgun select 2;

private["_uniform"];
_uniform = _result select 8;
private["_uniformClassname"];
_uniformClassname = _uniform select 0;
private["_uniformWeapons"];
_uniformWeapons = _uniform select 1;
private["_uniformMagazines"];
_uniformMagazines = _uniform select 2;
private["_uniformItems"];
_uniformItems = _uniform select 3;

private["_vest"];
_vest = _result select 9;
private["_vestClassname"];
_vestClassname = _vest select 0;
private["_vestWeapons"];
_vestWeapons = _vest select 1;
private["_vestMagazines"];
_vestMagazines = _vest select 2;
private["_vestItems"];
_vestItems = _vest select 3;

private["_backpack"];
_backpack = _result select 10;
private["_backpackClassname"];
_backpackClassname = _backpack select 0;
private["_backpackWeapons"];
_backpackWeapons = _backpack select 1;
private["_backpackMagazines"];
_backpackMagazines = _backpack select 2;
private["_backpackItems"];
_backpackItems = _backpack select 3;

/* Aktuelle Ausr�stung l�schen */
removeAllAssignedItems _unit;
removeAllPrimaryWeaponItems _unit;
removeAllHandgunItems _unit;
removeAllWeapons _unit; 
removeBackpack _unit;
removeHeadgear _unit;
removeVest _unit;
removeUniform _unit;
removeGoggles _unit;



/* Erstmal Klamotten anziehen, damit Platz zum bef�llen ist */
if (_uniformClassname != "") then {	_unit addUniform _uniformClassname;};
if (_vestClassname != "") then { _unit addVest _vestClassname;};
if (_backpackClassname != "") then { _unit addBackpack _backpackClassname;};

/* Munition hinzuf�gen, sonst ist diese nacher nicht verf�gbar */
if (_uniformClassname != "") then 
{
	{ _unit addItemToUniform _x; } foreach _uniformWeapons;
	{ _unit addItemToUniform _x; } foreach _uniformMagazines;
	{ _unit addItemToUniform _x; } foreach _uniformItems;
};
if (_vestClassname != "") then 
{
	{ _unit addItemToVest _x; } foreach _vestWeapons;
	{ _unit addItemToVest _x; } foreach _vestMagazines;
	{ _unit addItemToVest _x; } foreach _vestItems;
};
if (_backpackClassname != "") then 
{
	{ _unit addItemToBackpack _x; } foreach _backpackWeapons;
	{ _unit addItemToBackpack _x; } foreach _backpackMagazines;	
	{ _unit addItemToBackpack _x; } foreach _backpackItems;
};

/* Dann die Waffen hinzuf�gen, damit diese die Magazine gleich aufnehmen k�nnen 
   das Inventar sollte danach wieder leersein. */
if (_primaryWeaponClassname != "") then
{
	if (_primaryWeaponMagazine != "") then { _unit addMagazine _primaryWeaponMagazine; };
	_unit addWeapon _primaryWeaponClassname;
	{_unit addPrimaryWeaponItem _x;} foreach _primaryWeaponItems;
};
if (_secondaryWeaponClassname != "") then
{
	if (_secondaryWeaponMagazine != "") then { _unit addMagazine _secondaryWeaponMagazine; };
	_unit addWeapon _secondaryWeaponClassname;
	{_unit addSecondaryWeaponItem _x;} foreach _secondaryWeaponItems;
};
if (_handgunClassname != "") then
{
	if (_handgunMagazine != "") then {_unit addMagazine  _handgunMagazine; };
	_unit addWeapon _handgunClassname;
	{_unit addHandgunItem _x;} foreach _handgunItems;
};

/* Ausr�stung hinzuf�gen */
{ 
	_unit linkItem _x; 
} foreach _linkedItems;
if (_goggleClassname != "") then 
{
	_unit addGoggles _goggleClassname;
};
if (_headgearClassname != "") then 
{
	_unit addHeadgear _headgearClassname;
};
if (_binocularClassname != "") then 
{
	if (_binocularClassname == "Laserdesignator") then { _unit addMagazine "Laserbatteries"; }; /*Rangefinder*/
	_unit addWeapon _binocularClassname;
};
if (_nightVisionClassname != "") then 
{
	_unit linkItem _nightVisionClassname;
};
