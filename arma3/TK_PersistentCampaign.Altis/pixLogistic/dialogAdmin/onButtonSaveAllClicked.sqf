closeDialog 0;

if (isServer && !isDedicated) then
{
	player globalChat "simulate server";
	_tmp = [] execVM "pixLogistic\serverSaveAllItems.sqf";
}
else
{
	pvehPixlogisticSaveAllItems = true;
	publicVariable "pvehPixlogisticSaveAllItems";
};
