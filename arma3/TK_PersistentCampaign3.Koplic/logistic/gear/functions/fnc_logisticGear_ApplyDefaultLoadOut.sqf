private _loadouts = [] call compile preprocessFileLineNumbers format["logistic\gear\%1\_getArray.sqf", cfgLogisticGear_LoadoutFolder];
if (count _loadouts > 0) then { [(_this select 0), (_loadouts select 0)select 1] call fnc_logisticGear_ApplyLoadOut; };
//[(_this select 0), "Default.sqf"] call fnc_logisticGear_ApplyLoadOut; 