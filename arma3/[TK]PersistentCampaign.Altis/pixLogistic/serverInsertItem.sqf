if (isServer) then
{
	private ["_item"];
	_item = _this select 0; /* vehicle, object */

	waitUntil { !pixlogisticDbMutex };
	pixlogisticDbMutex = true;

	/*-----------------------------------------*/
	/* Pr�fen, ob schon in der Liste vorhanden */
	/*-----------------------------------------*/
	if (pixlogisticDbItems find _item == -1) then
	{
		/*------------------------------------*/
		/* In die �berwachungsliste aufnehmen */
		/*------------------------------------*/
		pixlogisticDbItems = pixlogisticDbItems + [_item];	
	}
	else
	{
		player sidechat "pixLogistic: Error: unable to insert item";		
	};
	
	pixlogisticDbMutex = false;
};