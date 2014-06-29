
private ["_pos","_offset","_marker"];

player createDiarySubject ["TS", "TeamSpeak"];
player createDiaryRecord ["TS",["JMW","ts.jammywarfare.eu"]];

player createDiarySubject ["HELP", "Help Topics"];
 player createDiaryRecord ["HELP",["The mission", "BECTI is a Conquer The Island gamemode based on the old school OFP MFCTI where two teams composed of Players and AI fight for the controls of an island in a power struggle with towns and bases.<br/><br/> The commander is the leader of your side, only he may build the base and set the income distribution, all team leaders shall always listen to the commander. The commander is the only one which is able to perform upgrades and assign orders.<br/><br/> Towns need to be captured and held by your side, to capture a town, you simply have to stand next to the flag while no enemy is around, but watch out ! the town occupation may try to defend it ! The generated income and the units may vary depending on a town's size.<br/><br/> Funds are mainly earned by capturing town and salvaging wrecks but killing enemies will also reward you with a bounty bonus, funds may be used to purchase units and gear.<br/><br/> Parameters allows you to play with a different setup all the time, nearly everything can be changed (AI, base, environment, economy, gameplay, module, respawn, towns...).<br/><br/> As the fights goes on, different assets may appear such as:<br/> - HQ:<br/> The HQ is the commander's main toy. Once destroyed, a side may no longer build factories so move it wisely!<br/> Repair trucks:<br/> - Repair trucks may be used by anyone to buy and place defensive structure but they can also be used to repair and build factories. FOB may be deployed from it upon request!<br/> Ammo trucks:<br/> - The ammo truck act as mobile resupply point for both infantry and vehicles. The gear and the service menu may be accessed from it.<br/> Salvage trucks:<br/> - Salvage trucks may be used to gain a certain cash amount from vehicle wrecks (You get 50% of the bounty, the rest is split among the other units). Independent trucks may also be purchased by commander.<br/> Forward operating base:<br/> - Those special structures may be built from Repair Truck and may act as a mobile respawn/resupply point. Note that they are limited in a way that only X of them may be placed at a time. They can be dismantled by using the Repair Truck contextual menu.<br/> Respawn:<br/> - Whenever the player dies, he/she may choose to respawn at a FOB (if near) or at a factory built by the commander. The player may choose to respawn in one of his AI units if near (note that you get the AI's gear upon respawn). Revive will be possible in future versions.<br/> Air/Sea Lifting:<br/> - Roads are unsafe? Why not lift the HQ by the air or by the sea? SDV can hook wrecks underwater (HQ recovery!)<br/> Command Center:<br/> - Are you far from the base? Have you forgotten to buy a vehicle? Then this structure is meant for you! The Command Center increase the purchase range and allows the use of custom assets such as Units Cam and Sat Cam.<br/><br/> The mission is also composed of multiple menu (GUI) like:<br/> Purchase Menu:<br/> - This menu allows the player to reinforce his/her own squad with units/vehicles. The commander may purchase units to other groups.<br/> Gear Menu:<br/> - Thanks to the Barracks, FOB and Ammo Trucks the player may swap his gear on the fly (nb vest/uniform don't have any valid gear manipulation commands atm)<br/> Orders Menu:<br/> - The orders menu allows the commander to change the orders assigned to his/her teams. Some may need to to take town X while other have to take and hold town Y.<br/> AI Micro Menu:<br/> - By default, the engine gives a basic AI management regarding AI in one's group. This menu extends this management allowing the leader to plan/use custom orders for his/her AI such as patrol/take towns (Some orders like move or patrol can be queued)<br/> Service Menu:<br/> - This menu is used to perform utility/resupply actions on units and vehicles (heal, repair, rearm...)<br/> Upgrade Menu:<br/> - The commander has to perform upgrades in order to improve it's side assets (better units, better loadouts...)<br/> Units Camera:<br/> - When a Command Center is available, the units camera become available allowing the monitoring of other groups members.<br/> Satellite Camera:<br/> - When a Command Center is available and when this asset is upgraded, one may use the Sat cam in order to find enemy whereabouts.<br/><br/> ^HS^<br/> "]];


player createDiarySubject ["CL", "Change Log"];
player createDiarySubject ["CR", "Credits"];
player createDiaryRecord ["CL",["* 1.1.8",
"  - FEATURE: Air radar (range 5Km at least 40m heigth)<br />
  - FEATURE: Gear to vehicles<br />
  - FEATURE: HC slot<br />
  - FEATURE: More items in defence menu<br />
  - FEATURE: Stratis version<br />
  - PARAM : Town Mortars<br />
  - PARAM : Base Protections<br />
  - FIX: Param strategic mode only disactivate strat mode not all features<br />
  - FIX: Cannot steal HQ anymore :) <br />
  - FIX: AI mortar less precise<br />
  - FIX: Commander money exploit  <br />
  - FIX: Lag in Respawn menu (hopefully)<br />
  - CODE: Init cleanup<br />
"]];
player createDiaryRecord ["CL",["* 1.1.8.1",
"  - FIX: Mortars Not despawning<br />
  - FIX: Air Radar Init and JIP
"]];
player createDiaryRecord ["CL",["* 1.1.9",
"  - FEATURE: Farooq's Revive <br />
  - FEATURE: More items in defence menu<br />
  - FEATURE: Artillery radar<br />
  - FEATURE: NVs and Thermal limitation (innactive by default)<br />
  - PARAM : Farooq's Revive active<br />
  - PARAM : Farooq's Revive mode<br />
  - PARAM : Town capture award multiplyer<br />
  - PARAM : Teamswap protection<br />
  - PARAM : NVs and Thermal limitation<br />
  - FIX: Structure placing tweaks to prevent clusterfucks<br />
         of buildings (30m radius)<br />
         So build defences first and then factories<br />
  - FIX: WeaponGroundContainers Cleanup (4 minutes timeout)<br />
  - FIX: Occupation can take back a town even if innactive<br />
  - FIX: Money exploit with teamkills<br />
  - FIX: Selling buildings<br />
  - FIX: Non despawning vehicle in resistance towns<br />
  - FIX: ScrollBars in dialogs (partially, some errors left)<br />
  - FIX: Rearm now gives the rigth number of magazines<br />
  - FIX: Reduced despawning time of town offroads.<br />
  - FIX: Disactivating MRLS for balance.<br />
  - HOTFIX: Removed hook capacities of SDVs to prevent abuse<br />
            (it will be reintroduced later).<br />
"]];
player createDiaryRecord ["CL",["* 1.1.9.1","
  - CHANGE: Crates at towns are now random <br />
  - FIX: Parachute are now not detected by the Air radar <br />
  - FIX: Halo jumping is now working as expected (rigth position) <br />
  - FIX: PFV error when client and/or server is lagging <br />
  - CODE: Partially Rewriten the strategic mode <br />
          Some changes of behavior are to be expected.<br />
  - HOTFIX: Removed AI delegation (pb with town groups) <br />
"]];
player createDiaryRecord ["CL",["* 1.1.9.2","
  - FEATURE: Basic HUD <br />
  - FIX: Activation when no town occupation <br />
  - FIX: Town disactivation preventing reactivation <br />
  - FIX: Capture with AI without force spawning <br />
  - CODE: Arty radar rewrite (less client lags) <br />
"]];

player createDiaryRecord ["CL",["* 1.1.9.3","
  - FEATURE: Tactical HUD with tactical glasses and upgrade<br />
  - FEATURE: More Upgrades <br /><br />
  - FIX: Terrain intercept radar contact <br />
  - FIX: Radar Spam <br />
  - FIX: Arty radar not working <br />
  - FIX: Lowered radar hitpoints <br />
  - FIX: Air contacs are revealed to player <br /><br />
  - FIX: Placing fob inside buildings or other stuff <br />
  - FIX: FOB protected by base protections <br />
  - FIX: Canceling building creating base <br /><br />
  - FIX: Disactivation of the respawn button <br />
  - FIX: 30s Suicide TimeOut <br />
  - FIX: No more respawning in a town being captured <br /><br />
  - FIX: Tweak Gear/Upgrades/startup <br />
  - FIX: No more respawning in a town being captured <br />
  - FIX: Repair action stacking <br />
  - FIX: Priority target disactivation <br />
  - FIX: 60s timeout on town disactivation action <br />
  - FIX: Tweak on Town vehicles spawning <br /><br />
  - CODE: Upgrades rewriten <br />
"]];

player createDiaryRecord ["CL",["* 1.2.0.0","
  - FEATURE: Adaptative player groupsize <br />
  - FEATURE: Advance mesh networking <br />
  - FEATURE: 3P pov limitation <br />
  - FEATURE: Guerrilla uniforms in equipment <br />
  - FEATURE: More H barrier element in defence menu <br />
  - FEATURE: Basic resistance patrols<br />
  - FEATURE: Serverside unit cleanup<br />
  - FEATURE: Zeus Interface for Logged Admin <br />
  - FEATURE: Some Stuff :) <br /> <br />
  - PARAM: Advance mesh networking <br />
  - PARAM: 3P limitation <br />
  - PARAM: Resistance patrols <br /> <br />
  - FIX: Ajusted construction timeout <br />
  - FIX: eject crew of hooked vehicles <br />
  - FIX: Revive available at 0-25% health <br />
  - FIX: Removed Suicide Timeout  <br />
  - FIX: player goes unconscious if hp below 25% <br />
  - FIX: Artillery Radar (maybe need more tests)<br />
  - FIX: Centralised Tact Hud targets per side on server <br />
  - FIX: Augmented time for town capture 1.5 min<br /> <br />
  - CHANGE: Commander slots at the end of the list<br />
  - CHANGE: Target sharing can only be done if connected <br />
  - CHANGE: Map updates only if connected <br />
  - CHANGE: Factory accessible only if connected <br />
  - CHANGE: Friendly units update on map if player and unit connected <br />
  - CHANGE: player name shows only if connected <br />
  - CHANGE: Weather script changed for randomWeather2<br /><br />
  - CODE: Changed Tact Hud targets rendering method (drawIcon3D) <br />
  - CODE: Changed Map rendering (drawIcon, drawLine) <br />
"]];

player createDiaryRecord ["CL",["* 1.2.1.0","
  - FEATURE: Offroads can load statics /crates <br />
  - FEATURE: Trophy APS on tanks and APCs +2 Upgrades<br />
  - FEATURE: New upgrade for the respawn truck<br />
  - FEATURE: Commander can delete defences<br />
  - FEATURE: Quadbikes can be bougth on fobs<br />
  - FEATURE: Equipement menu access on respawn trucks<br />
  - FEATURE: AAF technologies can be upgrades to access AAF vehicles<br />
  - PARAM: Tactical Hud Targets sensivity <br /><br />
  - FIX: Getting award for crashing Chopper/plane<br />
  - FIX: Not getting award for UAV kills <br />
  - FIX: Disapearing AI when AI teams enabled<br />
  - FIX: Script error in cleanup<br />
  - FIX: Some logic errors in the networking <br />
  - FIX: Town occupations are disconnected by default <br />
  - FIX: Guerrilla vehicles are disconnected by default <br />
  - FIX: Stopping Networking procedures on disconnected vehicles <br /><br />
  - CHANGE: Player access to defense menu near HQ// repair depot <br />
  - CHANGE: Moved the APCs to basic heavy factory <br />
  - CHANGE: Lowered the price of Respawn trucks <br />
  - CHANGE: 30k bounty on side HQs <br />
  - CHANGE: 5k bounty on Commanders <br />
  - CHANGE: HALO jump now costs 500$ per jumps <br />
  - CHANGE: Changed blufor chopper prices <br />
  - CHANGE: 7 second timeount before starting field repairs <br />
  - CHANGE: Misile range limit is disactivated by default (replaced by APS) <br /><br />
  - CODE: Moved activation and hud variable to side logics <br />
  - CODE: Changed repairing and forcelocking a bit <br /> <br /> <br />

Next version:
  - Blackhole routing <br />
  - Network intrusion <br />
  - Scrambler (maybe) <br />
  - Revamp of the fob system
"]];

player createDiaryRecord ["HELP",["Tactical Hud", "
Tactical Hud is available if you are equiped with tactical glasses and if the upgrade is done by your side. <br /> <br />
This HUD functionnalities are: <br />
 - Target highligths <br />
 - Automatic Target Sharing between groups <br />
  Shared Targets are marked with a dot above it  <br />
  (If connected to field mesh network) <br />
 - Town highligths with status <br />
 - Friendly units highligth (if connected)<br />
  <br />

Associated Keys are:<br />
 - Shift + Window Key : Switch On/Off<br />
  <br />



"]];


player createDiaryRecord ["HELP",["Advanced Networking","
The network is the way for you to communicate with the rest of your team <br /> <br />
Being connected to the network allows: <br />
 - To get the positions of friendly units on the map <br />
 - To be able to purchase units from the factories <br />
 - To see what upgrades are available or running<br />
 - To be able to see friendly Connected units on the hud.<br />
 - To be able to share target to other units using Tac Hud.<br />
 - To be able to receive target from the network. <br />
<br />
Be aware that part of your network can be hacked by the opposing forces.
<br /><br />
The network is a tree meshing network (look on wikipedia)<br />
http://en.wikipedia.org/wiki/Tree_network#Tree <br />
the reconfiguration process tries to lower network units power consumption by connecting to the closest connected unit. <br />
The backbone of the network is constituted of the HQ, CCs, Towns And Vehicles. <br />
As infantry your are able to connect to either of those elements <br />
The following are the efective ranges of connection depending on types <br />
  - Infantry:  100m + 200m * (Upgrade Level)<br />
  - Vehicle: 1000m + 1000m * (Upgrade Level) <br />
  - Town : 5 km<br />
  - CCs : Unlimited<br />
  - HQ : Unlimited<br /><br />
Also, another remark : you do NOT need a Master degree to understand that!<br />
"]];
/*
player createDiaryRecord ["HELP",["Independant ZEUS","

The current gameply follow sthese simple rules:<br />
- Every player can connect to zeus if they stay inside the hq (Church).<br />
- Only one player can be connected to zeus at a time.<br />
- players can redeploy their group from each town flag and from the HQ<br />
- they can only redeploy/respawn with their group on the HQ or 500 towns.<br />
- They are limited to first person.<br />
- They can see the side of every town on the map<br />
<br />
Zeus is limited to<br />
- editing around hq and around players<br />
- moving the camera around players, non active towns and around hq<br />
- the heigth of the zeus camera is limited to 20 m<br />
<br />
Zeus can:<br />
- Buy units<br />
- Move units<br />
- Set waypoints for owned groups<br />
- Group players and bougth units<br />
<br />

Zeus only owns the units it placed, and neither the town resistance forces or the patrols<br />
<br />
Zeus is wining buy points when every resistance unit is killing an enemy, depending of the class killed.<br />
"]];
*/
player createDiaryRecord ["CR","
- Benny for the mission<br />
- Bl1p, Fluit for random AI skill<br />
- =ATM=Pokertour for ATM airdrop<br />
- Meatball for randomWeather2<br />
- Prodavec for Map Markers titling<br />
- ^HS^ for writting the diary help <br />
- Farooq for his revive script <br />
- Sari for updating the sanitize scripts <br />
- John681611 for his original idea of offroad aug.<br />
"];


_enemy = switch (CTI_P_SideJoined) do
{
	case west: {east };
	case east: {west };
  default {east};
};

_pos=[2400,30000,0];
_offset=500;
_marker = createMarkerLocal ["cti_help_00", _pos];
_marker setMarkerTypeLocal "mil_dot";
_marker setMarkerSizeLocal [2,2];
_marker setMarkerColorLocal "ColorRed";
_marker setMarkerAlphaLocal 0.7;
_marker setMarkerTextLocal "== Strategic Mode Rules ==";
_pos=[(_pos select 0),(_pos select 1)-_offset,0];

_marker = createMarkerLocal ["cti_help_01", _pos];
_marker setMarkerTypeLocal "mil_dot";
_marker setMarkerSizeLocal [1,1];
_marker setMarkerColorLocal "ColorBlack";
_marker setMarkerAlphaLocal 0.7;
_marker setMarkerTextLocal "You can capture any town as your first town.";
_pos=[(_pos select 0),(_pos select 1)-_offset,0];

_marker = createMarkerLocal ["cti_help_02", _pos];
_marker setMarkerTypeLocal "mil_dot";
_marker setMarkerSizeLocal [1,1];
_marker setMarkerColorLocal "ColorBlack";
_marker setMarkerAlphaLocal 0.7;
_marker setMarkerTextLocal "A town can be captured only if active.";
_pos=[(_pos select 0),(_pos select 1)-_offset,0];



_marker = createMarkerLocal ["cti_help_03", _pos];
_marker setMarkerTypeLocal "mil_dot";
_marker setMarkerSizeLocal [1,1];
_marker setMarkerColorLocal "ColorBlack";
_marker setMarkerAlphaLocal 0.7;
_marker setMarkerTextLocal format ["You can only have %1 town actives at a time.",(missionNamespace getVariable "CTI_SM_MAX_ACTIVE")];
_pos=[(_pos select 0),(_pos select 1)-_offset,0];

_marker = createMarkerLocal ["cti_help_04", _pos];
_marker setMarkerTypeLocal "mil_dot";
_marker setMarkerSizeLocal [1,1];
_marker setMarkerColorLocal "ColorBlack";
_marker setMarkerAlphaLocal 0.7;
_marker setMarkerTextLocal "A town can be activated if available.";
_pos=[(_pos select 0),(_pos select 1)-_offset,0];



_marker = createMarkerLocal ["cti_help_05", _pos];
_marker setMarkerTypeLocal "mil_dot";
_marker setMarkerSizeLocal [1,1];
_marker setMarkerColorLocal "ColorBlack";
_marker setMarkerAlphaLocal 0.7;
_marker setMarkerTextLocal "A town is available if you have no town or if you own one town connected to it.";
_pos=[(_pos select 0),(_pos select 1)-_offset,0];

_marker = createMarkerLocal ["cti_help_06", _pos];
_marker setMarkerTypeLocal "mil_dot";
_marker setMarkerSizeLocal [1,1];
_marker setMarkerColorLocal "ColorBlack";
_marker setMarkerAlphaLocal 0.7;
_marker setMarkerTextLocal  format ["No towns are available if you already have %1 towns actives.",(missionNamespace getVariable "CTI_SM_MAX_ACTIVE")];
_pos=[(_pos select 0),(_pos select 1)-_offset,0];

_marker = createMarkerLocal ["cti_help_07", _pos];
_marker setMarkerTypeLocal "mil_dot";
_marker setMarkerSizeLocal [1,1];
_marker setMarkerColorLocal "ColorBlack";
_marker setMarkerAlphaLocal 0.7;
_marker setMarkerTextLocal "Everything inside a base area is protected if all towns linked to it are owned by the side of the base.";
_pos=[(_pos select 0),(_pos select 1)-_offset,0];

_marker = createMarkerLocal ["cti_help_08", _pos];
_marker setMarkerTypeLocal "mil_dot";
_marker setMarkerSizeLocal [1,1];
_marker setMarkerColorLocal "ColorBlack";
_marker setMarkerAlphaLocal 0.7;
_marker setMarkerTextLocal format ["A base is considered detected (and marked on map) if an enemy have been less than %1 meter from it", (CTI_BASE_AREA_RANGE*2)];
_pos=[(_pos select 0),(_pos select 1)-_offset,0];

_pos=[3600,9090,0];
_offset=CTI_MARKERS_TOWN_AREA_RANGE*3;

_marker = createMarkerLocal ["cti_help_1", _pos];
_marker setMarkerShapeLocal "ELLIPSE";
_marker setMarkerBrushLocal "SolidBorder";
_marker setMarkerSizeLocal [CTI_MARKERS_TOWN_AREA_RANGE, CTI_MARKERS_TOWN_AREA_RANGE];
_marker setMarkerColorLocal "ColorWhite";
_marker setMarkerAlphaLocal 0.7;
_pos=[(_pos select 0),(_pos select 1),(_pos select 2)+_offset/3];

_marker = createMarkerLocal ["cti_help_10", _pos];
_marker setMarkerTypeLocal "mil_dot";
_marker setMarkerSizeLocal [1,1];
_marker setMarkerColorLocal "ColorWhite";
_marker setMarkerAlphaLocal 0.7;
_marker setMarkerTextLocal "Town available for capture (no IA spawned)";
_pos=[(_pos select 0),(_pos select 1)-_offset,(_pos select 2)-_offset/3];

_marker = createMarkerLocal ["cti_help_2", _pos];
_marker setMarkerShapeLocal "ELLIPSE";
_marker setMarkerBrushLocal "SolidBorder";
_marker setMarkerSizeLocal [CTI_MARKERS_TOWN_AREA_RANGE, CTI_MARKERS_TOWN_AREA_RANGE];
_marker setMarkerColorLocal "ColorGreen";
_marker setMarkerAlphaLocal 0.7;

_pos=[(_pos select 0),(_pos select 1),(_pos select 2)+_offset/3];

	_marker = createMarkerLocal ["cti_help_20", _pos];
_marker setMarkerTypeLocal "mil_dot";
_marker setMarkerSizeLocal [1,1];
_marker setMarkerColorLocal "ColorGreen";
_marker setMarkerAlphaLocal 0.7;
_marker setMarkerTextLocal "Town Activated by your side - IA Present ";
_pos=[(_pos select 0),(_pos select 1)-_offset,(_pos select 2)-_offset/3];

_marker = createMarkerLocal ["cti_help_3", _pos];
_marker setMarkerShapeLocal "ELLIPSE";
_marker setMarkerBrushLocal "SolidBorder";
_marker setMarkerSizeLocal [CTI_MARKERS_TOWN_AREA_RANGE, CTI_MARKERS_TOWN_AREA_RANGE];
_marker setMarkerColorLocal  ( (CTI_P_SideJoined) call CTI_CO_FNC_GetSideColoration);
_marker setMarkerAlphaLocal 0.7;

_pos=[(_pos select 0),(_pos select 1),(_pos select 2)+_offset/3];

	_marker = createMarkerLocal ["cti_help_30", _pos];
_marker setMarkerTypeLocal "mil_dot";
_marker setMarkerSizeLocal [1,1];
_marker setMarkerColorLocal ( (CTI_P_SideJoined) call CTI_CO_FNC_GetSideColoration);
_marker setMarkerAlphaLocal 0.7;
_marker setMarkerTextLocal "Town activated for your side (100% income)";
_pos=[(_pos select 0),(_pos select 1)-_offset,(_pos select 2)-_offset/3];


_marker = createMarkerLocal ["cti_help_4", _pos];
_marker setMarkerShapeLocal "ELLIPSE";
_marker setMarkerBrushLocal "Border";
_marker setMarkerSizeLocal [CTI_MARKERS_TOWN_AREA_RANGE, CTI_MARKERS_TOWN_AREA_RANGE];
_marker setMarkerColorLocal  "ColorYellow";
_marker setMarkerAlphaLocal 0.7;

_pos=[(_pos select 0),(_pos select 1),(_pos select 2)+_offset/3];

	_marker = createMarkerLocal ["cti_help_40", _pos];
_marker setMarkerTypeLocal "mil_dot";
_marker setMarkerSizeLocal [1,1];
_marker setMarkerColorLocal  "ColorYellow";
_marker setMarkerAlphaLocal 0.7;
_marker setMarkerTextLocal "HALO Jump zones";
_pos=[(_pos select 0),(_pos select 1)-_offset,(_pos select 2)-_offset/3];

_marker = createMarkerLocal ["cti_help_5", _pos];
_marker setMarkerShapeLocal "ELLIPSE";
_marker setMarkerBrushLocal "SolidBorder";
_marker setMarkerSizeLocal [CTI_MARKERS_TOWN_AREA_RANGE, CTI_MARKERS_TOWN_AREA_RANGE];
_marker setMarkerColorLocal  "ColorBrown";
_marker setMarkerAlphaLocal 0.7;

_pos=[(_pos select 0),(_pos select 1),(_pos select 2)+_offset/3];

	_marker = createMarkerLocal ["cti_help_50", _pos];
_marker setMarkerTypeLocal "mil_dot";
_marker setMarkerSizeLocal [1,1];
_marker setMarkerColorLocal  "ColorBrown";
_marker setMarkerAlphaLocal 0.7;
_marker setMarkerTextLocal "Base Areas of your side";

_pos=[(_pos select 0),(_pos select 1)-_offset,(_pos select 2)-_offset/3];
_marker = createMarkerLocal ["cti_help_6", _pos];
_marker setMarkerShapeLocal "ELLIPSE";
_marker setMarkerBrushLocal "SolidBorder";
_marker setMarkerSizeLocal [CTI_MARKERS_TOWN_AREA_RANGE, CTI_MARKERS_TOWN_AREA_RANGE];
_marker setMarkerColorLocal  ( (_enemy) call CTI_CO_FNC_GetSideColoration);
_marker setMarkerAlphaLocal 0.7;

_pos=[(_pos select 0),(_pos select 1),(_pos select 2)+_offset/3];

	_marker = createMarkerLocal ["cti_help_60", _pos];
_marker setMarkerTypeLocal "mil_dot";
_marker setMarkerSizeLocal [1,1];
_marker setMarkerColorLocal  ( (_enemy) call CTI_CO_FNC_GetSideColoration);
_marker setMarkerAlphaLocal 0.7;
_marker setMarkerTextLocal "Enemy Base Areas";
_pos=[(_pos select 0),(_pos select 1)-_offset,(_pos select 2)-_offset/3];


