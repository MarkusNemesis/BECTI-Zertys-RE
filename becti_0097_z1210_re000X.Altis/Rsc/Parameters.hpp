class Params {
	class CTI_AI_TEAMS_ENABLED {
		title = "AI: Teams";
		values[] = {0,1};
		texts[] = {"Disabled", "Enabled"};
		default = 0;
	};
	class CTI_ARTILLERY_SETUP {
		title = "ARTILLERY: Setup";
		values[] = {-2,-1,0,1,2,3};
		texts[] = {"Disabled","Ballistic Computer","Short","Medium","Long","Extreme"};
		default = 1; // Markus - Medium
	};
	class CTI_BASE_HQ_REPAIR {
		title = "BASE: HQ Repairable";
		values[] = {0,1};
		texts[] = {"Disabled","Enabled"};
		default = 1;
	};
	class CTI_BASE_FOB_MAX {
		title = "BASE: FOB Limit";
		values[] = {0,1,2,3,4,5,6,7,8,9,10};
		texts[] = {"Disabled","1","2","3","4","5","6","7","8","9","10"};
		default = 4;
	};
	class CTI_BASE_STARTUP_PLACEMENT {
		title = "BASE: Startup Placement";
		values[] = {2000,3000,4000,5000,6000,7000,8000,9000,10000,12000,15000,20000};
		texts[] = {"2 KM","3 KM","4 KM","5 KM","6 KM","7 KM","8 KM","9 KM","10 KM","12 KM","15 KM","20 KM"};
		default = 8000;
	};
	class CTI_ECONOMY_INCOME_CYCLE {
		title = "INCOME: Delay";
		values[] = {15,30,45,60,90,120,160,190};
		texts[] = {"00:15 Minute","00:30 Minute","00:45 Minute","01:00 Minute","01:30 Minutes","02:00 Minutes","02:30 Minutes","03:00 Minutes"};
		default = 45;
	};
	class CTI_ECONOMY_STARTUP_FUNDS_EAST_COMMANDER {
		title = "INCOME: Starting Funds (East Commander)";
		values[] = {9000,15000,20000,25000,30000,35000,40000,45000,50000,60000};
		texts[] = {"$9000","$15000","$20000","$25000","$30000","$35000","$40000","$45000","$50000","$60000"};
		default = 15000;
	};
	class CTI_ECONOMY_STARTUP_FUNDS_EAST {
		title = "INCOME: Starting Funds (East Players)";
		values[] = {900,1500,2400,3200,6000,8000,10000,12500,15000,20000};
		texts[] = {"$900","$1500","$2400","$3200","$6000","$8000","$10000","$12500","$15000","$20000"};
		default = 3200; // 2400
	};
	class CTI_ECONOMY_STARTUP_FUNDS_WEST_COMMANDER {
		title = "INCOME: Starting Funds (West Commander)";
		values[] = {9000,15000,20000,25000,30000,35000,40000,45000,50000,60000};
		texts[] = {"$9000","$15000","$20000","$25000","$30000","$35000","$40000","$45000","$50000","$60000"};
		default = 15000;
	};
	class CTI_ECONOMY_STARTUP_FUNDS_WEST {
		title = "INCOME: Starting Funds (West Players)";
		values[] = {900,1500,2400,3200,6000,8000,10000,12500,15000,20000};
		texts[] = {"$900","$1500","$2400","$3200","$6000","$8000","$10000","$12500","$15000","$20000"};
		default = 3200; // 2400
	};
	class CTI_ECONOMY_TOWNS_OCCUPATION {
		title = "INCOME: Towns Occupation";
		values[] = {0,1};
		texts[] = {"Disabled","Enabled"};
		default = 1;
	};
	class CTI_RESPAWN_AI {
		title = "RESPAWN: AI Members";
		values[] = {0,1};
		texts[] = {"Disabled","Enabled"};
		default = 0;
	};
	class CTI_RESPAWN_FOB_RANGE {
		title = "RESPAWN: FOB Range";
		values[] = {500,750,1000,1250,1500,1750,2000};
		texts[] = {"0.50 KM","0.75 KM","1 KM","1.25 KM","1.5 KM","1.75 KM","2 KM"};
		default = 1750;
	};
	class CTI_RESPAWN_MOBILE {
		title = "RESPAWN: Mobile";
		values[] = {0,1};
		texts[] = {"Disabled","Enabled"};
		default = 1;
	};
	class CTI_RESPAWN_TIMER {
		title = "RESPAWN: Delay";
		values[] = {15,20,25,30,35,40,45,50,55,60};
		texts[] = {"15 Seconds","20 Seconds","25 Seconds","30 Seconds","35 Seconds","40 Seconds","45 Seconds","50 Seconds","55 Seconds","60 Seconds"};
		default = 20;
	};
	class CTI_TOWNS_OCCUPATION {
		title = "TOWNS: Occupation";
		values[] = {0,1};
		texts[] = {"Disabled","Enabled"};
		default = 1;
	};
	class CTI_VEHICLES_AIR_AA {
		title = "UNITS: Aircraft AA Missiles";
		values[] = {0,1,2};
		texts[] = {"Disabled","Enabled with Upgrade","Enabled"};
		default = 1;
	};
	class CTI_VEHICLES_AIR_AT {
		title = "UNITS: Aircraft AT Missiles";
		values[] = {0,1,2};
		texts[] = {"Disabled","Enabled with Upgrade","Enabled"};
		default = 1;
	};
	class CTI_VEHICLES_AIR_CM {
		title = "UNITS: Aircraft Countermeasures";
		values[] = {0,1,2};
		texts[] = {"Disabled","Enabled with Upgrade","Enabled"};
		default = 1;
	};
	class CTI_MARKERS_INFANTRY {
		title = "UNITS: Show Map Infantry";
		values[] = {0,1};
		texts[] = {"Disabled","Enabled"};
		default = 1;
	};
	class CTI_UNITS_FATIGUE {
		title = "UNITS: Fatigue";
		values[] = {0,1};
		texts[] = {"Disabled","Enabled"};
		default = 0; // 1
	};
	class CTI_VEHICLES_EMPTY_TIMEOUT {
		title = "UNITS: Vehicles Reycling Delay";
		values[] = {60,120,180,240,300,600,1200,1800,2400,3000,3600};
		texts[] = {"1 Minute","2 Minutes","3 Minutes","4 Minutes","5 Minutes","10 Minutes","20 Minutes","30 Minutes","40 Minutes","50 Minutes","1 Hour"};
		default = 3600;
	};
	class CTI_GRAPHICS_TG_MAX {
		title = "VISUAL: Terrain Grid";
		values[] = {10,20,30,50};
		texts[] = {"Far","Medium","Short","Free"};
		default = 50;
	};
	class CTI_GRAPHICS_VD_MAX {
		title = "VISUAL: View Distance";
		values[] = {1000,1500,2000,2500,3000,3500,4000,5000,6000};
		texts[] = {"1 KM","1.5 KM","2 KM","2.5 KM","3 KM","3.5 KM","4 KM","5 KM", "6 KM"};
		default = 4000;
	};
	class CTI_WEATHER_FAST {
		title = "WEATHER: Fast Time";
		values[] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13};
		texts[] = {"Disabled","24H = 10H","24H = 9H30","24H = 9H","24H = 8H30","24H = 8H","24H = 7H30","24H = 7H","24H = 6H30", 
		"24H = 6H","24H = 5H30","24H = 5H","24H = 4H30","24H = 4H"};
		default = 0;
	};
		//Additionnal Parameter (Zerty)
	class SEPARATOR {
		title = "=======================================================================";
		values[] = {1};
		texts[] = {""};
		default = 1;
	};
	class CTI_TEAMSWAP {
		title = "Zerty:Team swap protection";
		values[] = {0,1};
		texts[] = {"off","on"};
		default = 1;
	};

	class CTI_SM_NONV {
		title = "Zerty: No NVs, No Thermal";
		values[] = {0,1};
		texts[] = {"false","true"};
		default = 0;
	};

	class CTI_AI_SKILL {
		title = "Zerty: AI: Skill (credit : Bl1p, fluit)";
		values[] = {1,2,3,4,5};
		texts[] = {"Retards","DumbFucks","NotSobad","Good","Very Good"};
		default = 3;
	};

	class CTI_MAX_MISSION_TIME {
		title = "Zerty: MISSION : Time Limit";
		values[] = {0,2,4,6,8,12,24};
		texts[] = {"Never","2h","4h","6h","8h","12h","24h"};
		default = 12;
	};
	class CTI_VICTORY_HQ {
		title = "Zerty: MISSION : Victory on HQ Destroyed";
		values[] = {0,1};
		texts[] = {"False","True"};
		default = 0;
	};

	class CTI_BASE_WORKERS_RATIO {
		title = "Zerty: MISSION : Building speed ratio";
		values[] = {0,1,2,3,4};
		texts[] = {"10%","25%","50%","75%","100%"};
		default = 3;
	};

	class CTI_BASE_FOB_PERMISSION {
		title = "Zerty: MISSION : Need Commander permission for FOB";
		values[] = {0,1};
		texts[] = {"False","True"};
		default = 0;
	};
	
	class CTI_AI_TEAMS_GROUPSIZE {
		title = "Zerty: GROUPS: Size (AI) -- Resistance, West, East ";
		values[] = {0,8,10,12,14,16};
		texts[] = {"0","8","10","12","14","16"};
		default = 3; // 8
	};

	class CTI_PLAYERS_GROUPSIZE {
		title = "Zerty: GROUPS: Size (Players)";
		values[] = {0,1,2,3,4,5,8,10,12,14,16};
		texts[] = {"0","1","2","3","4","5","8","10","12","14","16"};
		default = 9;
	};
	class CTI_GAMEPLAY_MISSILES_RANGE {
		title = "Zerty: GAMEPLAY: Missile Range";
		values[] = {0,500,1000,1500,2000,2500,3000,3500,4000,4500,5000,5500,6000,6500,7000,7500,8000,8500,9000,9500,10000};
		texts[] = {"Disabled","500m","1000m","1500m","2000m","2500m","3000m","3500m","4000m","4500m","5000m","5500m","6000m","6500m","7000m","7500m","8000m","8500m","9000m","9500m","10000m"};
		default = 2500;
	};
		class CTI_GAMEPLAY_3P {
		title = "Zerty: GAMEPLAY: 3P view";
		values[] = {0,1,2};
		texts[] = {"All","Vehicle","None"};
		default = 0; // 1
	};
	class CTI_ECONOMY_BASE_PLAYER_INCOME {
		title = "Zerty: INCOME: base income for players";
		values[] = {0,10,25,50,100,150,200,250};
		texts[] = {"0$","10$","25$","50$","100$","150$","200$","250$"};
		default = 10;
	};
	class CTI_VEHICLES_BOUNTY {
		title = "Zerty: INCOME: On kill";
		values[] = {0,25,50,75,100};
		texts[] = {"No value","Low value","Medium value","High value","Full value"};
		default = 50;
	};	
	class CTI_PLAYER_REEQUIP {
		title = "Zerty: RESPAWN : Reequip Gear";
		values[] = {0,1};
		texts[] = {"False","True"};
		default = 1;
	};	
	class CTI_PLAYER_TOWN_RESPAWN {
		title = "Zerty: RESPAWN : On occupied towns";
		values[] = {0,1,2};
		texts[] = {"False","Closest", "All"};
		default = 1;
	};	
	class CTI_TOWNS_INCOME_RATIO {
		title = "Zerty: TOWNS: Value Ratio";
		values[] = {1,2,3,4,5,10};
		texts[] = {"1","2","3","4","5","10"};
		default = 1;
	};
	class CTI_TOWNS_CAPTURE_RATIO {
		title = "Zerty: TOWNS: Value Award Ratio";
		values[] = {1,2,3,4,5,10};
		texts[] = {"1","2","3","4","5","10"};
		default = 10;
	};
	class CTI_TOWNS_RESISTANCE_DETECTION_RANGE {
		title = "Zerty: TOWNS: Detection Range";
		values[] = {300,500,800,1000,1200};
		texts[] = {"300m","500m","800m","1000m","1200m"};
		default = 500;
	};
	class CTI_TOWNS_RESISTANCE_GROUPS_RATIO {
		title = "Zerty: TOWNS : Resistance difficulty";
		values[] = {0,25,50,75,100};
		texts[] = {"Null","Normal","Hard","Very hard","HELL"};
		default = 50;
	};
	class CTI_TOWNS_RESISTANCE_INACTIVE_MAX {
		title = "Zerty: TOWNS : Resistance despawn Timer";
		values[] = {30,60,120,240};
		texts[] = {"30s","60s","120s","240s"};
		default = 240;
	};
	
	class CTI_UNITS_CLEANUP {
		title = "Zerty: UNITS: Cleanup on Disconnect";
		values[] = {0,1};
		texts[] = {"False","True"};
		default = 1;
	};
	class CTI_WEATHER_INITIAL {
		title = "Zerty: WEATHER: Inital time";
		values[] = {0,1,2,3,10};
		texts[] = {"Morning","Noon","Evening","Midnight","Random"};
		default = 0; // 10
	};
	class CTI_WEATHER_DYNAMIC {
		title = "Zerty: WEATHER: Dynamic";
		values[] = {0,1};
		texts[] = {"False","True"};
		default = 0;
	};

   class initialWeatherParam {
    title = "Zerty: Starting Weather";
    values[] = {0,1,2,3,4};
    texts[] = {"Clear","Overcast","Rain","Fog","Random"};
    default = 0;
  };
	class SEPARATOR2 {
		title = "=======================================================================";
		values[] = {1};
		texts[] = {""};
		default = 1;
	};

	class CTI_SM_RADAR {
		title = "Zerty: Strategic: Air Radar";
		values[] = {0,1};
		texts[] = {"Disabled","Enabled"};
		default = 1;
	};
	class CTI_SM_BASEP {
		title = "Zerty: Strategic: Base Protection";
		values[] = {0,0};
		texts[] = {"Disabled","Disabled"};
		default = 0; // Markus - To solve the issue of base camping without end.
	};
	class CTI_SM_FAR {
		title = "Zerty: Strategic: FAR Revive Active";
		values[] = {0,1};
		texts[] = {"disabled","Enabled"};
		default = 1;
	};
	class FAR_ReviveMode {
		title = "Zerty: Strategic: FAR Revive mode";
		values[] = {0,1};
		texts[] = {"Only Medics","Everyone"};
		default = 1;
	};
	class CTI_SM_HALO {
		title = "Zerty: Strategic: Halo Jump";
		values[] = {0,1};
		texts[] = {"Disabled","Enabled"};
		default = 1;
	};
	class CTI_SM_PATROLS {
		title = "Zerty: Strategic: Patrols";
		values[] = {0,1};
		texts[] = {"Disabled","Enabled"};
		default = 1;
	};
	class CTI_SM_REPAIR {
		title = "Zerty: Strategic: Repair/Forcelock";
		values[] = {0,1};
		texts[] = {"Disabled","Enabled"};
		default = 1;
	};
	class CTI_SM_MORTARS {
		title = "Zerty: Strategic: Town Mortars";
		values[] = {0,1};
		texts[] = {"Disabled","Enabled"};
		default = 0; // 1
	};
	class CTI_SM_STRATEGIC {
		title = "Zerty: Strategic: Town Links";
		values[] = {0,1};
		texts[] = {"Disabled","Enabled"};
		default = 1;
	};

	class SEPARATOR3 {
		title = "=======================================================================";
		values[] = {1};
		texts[] = {""};
		default = 1;
	};
	class CTI_EW_HUD {
		title = "Zerty: Electronic Warfare : Tactical HUD";
		values[] = {0,1};
		texts[] = {"Disabled","Enabled"};
		default = 1;
	};
	class CTI_EW_HUD_S {
		title = "Zerty: Electronic Warfare : Tactical HUD Sensivity";
		values[] = {1,2,3,4};
		texts[] = {"high","medium high", "medium low", "low"};
		default = 2;
	};
	class CTI_EW_ANET {
		title = "Zerty: Electronic Warfare : Field Network Meshing";
		values[] = {0,1};
		texts[] = {"Disabled","Enabled"};
		default = 0; // 1
	};
};
