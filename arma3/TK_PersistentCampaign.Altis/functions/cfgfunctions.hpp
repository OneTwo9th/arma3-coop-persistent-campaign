class PC
{
	tag = "PC";
	
	class AI
	{
		file = "functions\ai";
		class AttackObject {description = "";};
		class CleanupMission {description = "";};
		class GuardObject {description = "";};
		class PatrolObject {description = "";};
		class PatrolZone {description = "";};
		class SetSkill {description = "";};
		class SpawnGroup {description = "";};
		class SpawnGroupAttackObject {description = "";};
		class SpawnGroupGuardObject {description = "";};
		class SpawnGroupPatrolObject {description = "";};
		class SpawnGroupPatrolZone {description = "";};
		class TrackGroup {description = "";};
	};
	
	class Logistic
	{
		file = "functions\logistic";
	};
	
	class Zone
	{
		file = "functions\zone";
		class AllMissionsFinished {description = "";};
		class AllMissionsSuccessfull {description = "";};
		class CanBlueforEngageZone {description = "";};
		class GetConnectedHostileZones {description = "";};
		class GetZoneIndex {description = "";};
		class IsPositionInZone {description = "";};
		class IsZoneBlueFor {description = "";};
		class IsZoneForbidden {description = "";};
		class IsMissionLocationValid {description = "Prüft, ob eine MissionLocation gültig ist. Dazu wird verglichen, ob andere Missionen weit genug entfernt liegen.";};
	};
	
	class missionsOpt
	{
		class FinishMissionStatus {description = "";};
		class FindVehicleTypeInRange {description = "";};
	};
	
	class TFR
	{
		class ActivateTFRRadio {description = "Activates a TFR radio that is somewhere stored in the uniform.";};
	};
	class Tools
	{
		file = "functions\tools";
		class CreateMineField {description = "Erzeugt ein Minenfeld";};
		class CreateMineFieldAtTarget {description = "Erzeugt ein Minenfeld in der Nähe eines Zieles";};		
		class Debug {description = "";};
		class Error {description = "";};
		class GetMinDistance {description = "";};
		class GetObfuscatedMarker {description = "";};
		class GetPlayerCount {description = "";};
		class GetRandomLocationZoneCity {description = "";};
		class GetRandomLocationZoneField {description = "";};
		class GetRandomLocationZoneHouse {description = "";};
		class GetRandomLocationZoneRoad {description = "";};
		class GetRandomLocationZoneWater {description = "";};
		class GetRandomPositionMarker {description = "";};
		class GetRandomPositionZone {description = "";};
		class GetRandomPositionZoneObject {description = "";};
		class GetUniqueMarkerName {description = "";};
		class IsFlat {description = "";};
	};
};




