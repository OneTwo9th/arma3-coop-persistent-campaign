townDbPrefix = "PC3TOWN";
townTownCount = 24;
townSupplySearchRadius = 400;
townWalkRadius = 75;
townSupplyClassnames = [
	"Land_Sacks_heap_F",
	"Land_WaterBarrel_F"
	];

townCivClassnames = [
	"C_man_p_fugitive_F",
	"C_man_p_beggar_F",
	"C_man_w_worker_F",
	"C_man_hunter_1_F",
	"C_man_polo_1_F",
	"C_man_polo_2_F",
	"C_man_polo_3_F",
	"C_man_polo_4_F",
	"C_man_polo_5_F",
	"C_man_polo_6_F",
	"C_man_p_shorts_1_F"
	//"C_man_p_shorts_2_F", //buggy
	//"C_man_p_shorts_3_F", //buggy
	//"C_man_p_shorts_4_F" //buggy
	];

	
// ------------------------------------------------------------------------------
// Runtime Variablen initialisieren (nicht verändern!)
townActive = [];
townInfos = [];
townActiveCounter = 0;
townInitCompleted = false;
townDatabaseSaving = false;