setviewdistance 1000;
setObjectViewDistance 1000;
setTerrainGrid 50;

waituntil {!isnil "bis_fnc_init"};
enableSaving [false, false];
enableTeamSwitch false;

//-----------------------------------------------
// Debug
pixDebug = false;
if (isServer && !isDedicated) then { pixDebug = true; };

//-----------------------------------------------
// Parameter (0): TFR-Muted while dead 
//pixParamTFARMutedOnDeath = (paramsArray select 0); //0=aus 1=an 
//diag_log format["INFO: pixParamTFARMutedOnDeath: %1", pixParamTFARMutedOnDeath];

// Wenn "HeadlessClientAvailable" nil ist, dann gibt es keinen. Sonst ist "HeadlessClientAvailable" automatisch TRUE. Daf�r sorgt die Funktion: fn_HeadlessClientInit.sqf
if (isNil "HeadlessClientAvailable") then 
{	
	HeadlessClientAvailable = false;
	diag_log "No headless-client detected";
};

// Lokal f�r jeden Rechner pr�fen, ob hier (auf dieser Maschine) Headless Code ausgef�hrt werden soll, oder nicht.
ExecuteHeadlessCode = false;
if ((HeadlessClientAvailable && !hasInterface && !isServer) || (!HeadlessClientAvailable && isServer)) then { ExecuteHeadlessCode = true; };
diag_log format["ExecuteHeadlessCode: %1", ExecuteHeadlessCode];

myvehicles = [];

call compile preprocessFileLineNumbers "sub_config.sqf";
call compile preprocessFileLineNumbers "sub_compile.sqf";
call compile preprocessFileLineNumbers "sub_init.sqf";

// call compile preprocessFileLineNumbers "test.sqf";