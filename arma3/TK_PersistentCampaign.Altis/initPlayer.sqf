/* Ausr�stung entfernen */
if (!isServer || !isDedicated) then
{
	private["_tmp"];
	_tmp = [] spawn {
		waitUntil { player == player };
		/* Aktuelle Ausr�stung l�schen */
		removeAllAssignedItems player;
		removeAllPrimaryWeaponItems player;
		removeAllHandgunItems player;
		removeAllWeapons player; 
		removeBackpack player;
		removeHeadgear player;
		removeVest player;
		player linkItem "ItemMap";
	};
};