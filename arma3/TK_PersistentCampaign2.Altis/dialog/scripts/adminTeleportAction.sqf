if (!isServer || !isDedicated) then
{
	openMap [true, true] ;
	adminTeleportUnit = vehicle player;
	onMapSingleClick "adminTeleportUnit setPos _pos; onMapSingleClick ''; openMap [true, false]; openMap [false, false]; true;";
};
