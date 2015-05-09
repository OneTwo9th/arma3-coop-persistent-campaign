// [Text, Enabled, Visible, SQF-Datei]
private["_buttons"];	
_buttons = [		
	["GPS umschalten", true, true, fnc_Admin_GpsScript],
	["Virtual Arsenal umschalten", true, true, fnc_Admin_VirtualArsenalSwitch],
	["Spieler-Teleport umschalten", true, true, fnc_Admin_TeleportSwitch],
	["Teleportieren", true, true, fnc_Admin_TeleportScript],
	["Rallypoint versetzen", call fnc_Admin_RallyTeleportCond, false, fnc_Admin_RallyTeleportScript],
	["Fahrzeug hinzufügen", true, true, fnc_Admin_VehicleAddScript],
	["Fahrzeug entfernen", true, true, fnc_Admin_VehicleRemoveScript],
	["Fahrzeuge speichern", true, true, fnc_Admin_VehiclesSaveScript],
	["Städte speichern", true, true, fnc_Admin_TownsSaveScript],
	["Stadt Status abfragen", true, true, fnc_Admin_TownStatusScript],
	//["Switch Zeus", true, true, fnc_Admin_SwitchZeusScript],
	["Informations Status abfragen", true, true, fnc_Admin_InfoStatusScript]
];

[_buttons, "Administrator"] execVM "maindialog_showtemplate.sqf";