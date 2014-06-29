/* NOTE

* Need to disactivate base allocation
* in init.sqf after < execVM "Common\Init\Init_Locations.sqf"; >

 0 execVM "Addons\Strat_mode\init.sqf";

* in init_location

	if (missionNamespace getVariable "CTI_GAMEPLAY_STRATEGIC" == 0) then {
		(_town) execFSM "Server\FSM\town_capture.fsm";
		(_town) execFSM "Server\FSM\town_resistance.fsm";
		if (missionNamespace getVariable "CTI_TOWNS_OCCUPATION" > 0) then {(_town) execFSM "Server\FSM\town_occupation.fsm"};
	} else {
		(_town) execFSM "Addons\Strat_mode\FSM\town_capture.fsm";
		(_town) execFSM "Addons\Strat_mode\FSM\town_resistance.fsm";
		if (missionNamespace getVariable "CTI_TOWNS_OCCUPATION" > 0) then {(_town) execFSM "Addons\Strat_mode\FSM\town_occupation.fsm"};

	};
};


*/

with missionNamespace do {
		CTI_SM_MAX_ACTIVE = 2;
		CTI_SM_Map_setup = compileFinal preprocessFileLineNumbers "Addons\Strat_mode\Functions\SM_Map_Setup.sqf";
		CTI_SM_Connect = compileFinal preprocessFileLineNumbers "Addons\Strat_mode\Functions\SM_Connect.sqf";
		TR_PROJ_HANDLER = compileFinal preprocessFileLineNumbers "Addons\Strat_mode\Functions\TR_proj_handler.sqf";
		TR_HANDLER = compileFinal preprocessFileLineNumbers "Addons\Strat_mode\Functions\TR_handler.sqf";
		CTI_REDEPLOY=false;
};

//Common stuff
SM_MAP_READY=false;
0 call CTI_SM_Map_setup;

//enableEnvironment false;

	// Parameters
with  missionNamespace do {


	if (CTI_SM_FAR == 1) then {
		call compileFinal preprocessFileLineNumbers "Addons\FAR_revive\FAR_revive_init.sqf";
	};
	if ( (missionNamespace getVariable 'CTI_SM_NONV')==1) then {
		0 execVM "Addons\Strat_mode\Functions\SM_NvThermR.sqf";
	};
};

// --- zerty Date init
if (CTI_IsServer) then {
	_it=0;
	if ((missionNamespace getVariable "CTI_WEATHER_INITIAL") < 10) then {
		_it=(missionNamespace getVariable "CTI_WEATHER_INITIAL")*6;
	} else {
		_it= random(14);
	};
	diag_log _it;
	skipTime _it;
};
// --- Zerty edit (dynamic wheather)
if ( CTI_WEATHER_DYNAMIC == 1) then {
	 execVM "Addons\DynamicWeatherEffects\randomWeather2.sqf"
};



if (CTI_IsServer) then {

	//constants for the server
{
	_sl=_x call CTI_CO_FNC_GetSideLogic;
	_sl setVariable ["CTI_ACTIVE",[],true];
	_sl setVariable ["CTI_AVAILLABLE",[],true];
	_sl setVariable ["CTI_PREVENT",objNull,false];
	_sl setVariable ["CTI_PRIORITY",objNull,true];
	_sl setVariable ["CTI_HUD_SHARED",[],true];
} count [east,west];
CTI_ACTIVE_EAST=[];
CTI_ACTIVE_WEST=[];

CTI_AVAILLABLE_EAST=[];
CTI_AVAILLABLE_WEST=[];

CTI_PREVENT_EAST=objNull;
CTI_PREVENT_WEST=objnull;

	CTI_BASES_WEST_NEIGH=[];
	CTI_BASES_EAST_NEIGH=[];

	CTI_STRUCT_WEST_LINK=[];
	CTI_STRUCT_EAST_LINK=[];

	CTI_BASES_WEST_FOUND=[];
	CTI_BASES_EAST_FOUND=[];

	CTI_PRIORITY_WEST=objNull;
	CTI_PRIORITY_EAST=objNull;

	for "_i" from 1 to CTI_BASE_AREA_MAX do {
		CTI_BASES_WEST_NEIGH=CTI_BASES_WEST_NEIGH + [[]];
		CTI_BASES_EAST_NEIGH=CTI_BASES_EAST_NEIGH + [[]];
	};

	CTI_HUD_SHARED_EAST=[];
	CTI_HUD_SHARED_WEST=[];

	// Functions

	CTI_SM_Allow_Capture = compileFinal preprocessFileLineNumbers "Addons\Strat_mode\Functions\SM_Allow_Capture.sqf";


	CTI_SM_Base_Prot = compileFinal preprocessFileLineNumbers "Addons\Strat_mode\Functions\SM_Base_Prot.sqf";
	CTI_SM_Mortars_script = compileFinal preprocessFileLineNumbers "Addons\Strat_mode\Functions\SM_Mortar.sqf";



	//PVF
	with missionNamespace do {
    /*
		CTI_PVF_Server_Active_Towns = {
			_req_p=_this;
			_ac_s=(missionNamespace getVariable (format["CTI_ACTIVE_%1",(side _req_p)]));
			[["CLIENT",_req_p], "Client_Active_Towns",_ac_s] call CTI_CO_FNC_NetSend;
		};
		CTI_PVF_Server_Availlable_Towns = {
			_req_p=_this;
			_av_s=(missionNamespace getVariable (format["CTI_AVAILLABLE_%1",(side _req_p)]));
			[["CLIENT",_req_p], "Client_Availlable_Towns",_av_s] call CTI_CO_FNC_NetSend;
		};*/

		CTI_PVF_Server_Mortars_Towns = {
			_req_p=_this;
			_ac_s=(missionNamespace getVariable (format["CTI_ACTIVE_%1",(side _req_p)]));
			{
				[["CLIENT", _req_p], "Client_Update_Mortars",[_x, (_x getVariable "cti_town_mortars")]] call CTI_CO_FNC_NetSend;
			} forEach _ac_s;
		};
		CTI_PVF_Server_Base_Connect= {
			_req_p=_this;
			if ((side _req_p) == resistance) exitWith {false};
			_ci=0;
			_sidelogic= (side _req_p) call CTI_CO_FNC_GetSideLogic;
			_conn= missionNamespace getVariable (format ["CTI_BASES_%1_NEIGH",(side _req_p)]);
			_bases = (_sidelogic getVariable "cti_structures_areas");
			{
				_ctown=_conn select _ci;
				{
					[["CLIENT",_req_p], "Client_Connect",[[(_bases select _ci) select 0,(_bases select _ci) select 1,0],getPos _x,"ColorBrown",500]] call CTI_CO_FNC_NetSend;
				} forEach _ctown;
				_ci=_ci+1;
			} forEach _conn;
		};

		CTI_PVF_Server_Base_Detec ={
			_req_p=_this;
			_ci=0;
			if ((side _req_p) == resistance) exitWith {false};
			_enemy = switch (side _req_p) do
			{
		    case west: {east };
		    case east: {west };
		    default {east};
			};
			_enemysl= (_enemy) call CTI_CO_FNC_GetSideLogic;

			_d_base= missionNamespace getVariable (format ["CTI_BASES_%1_FOUND",(side _req_p)]);

			{
				_cbase= (_enemysl getVariable "cti_structures_areas") select _x;
				_conn= missionNamespace getVariable (format ["CTI_BASES_%1_NEIGH",_enemy]);
				_ctown=_conn select _x;
				[["CLIENT",_req_p], "Client_Base_Zone",[_enemy,_x,[_cbase select 0,_cbase select 1,0]]] call CTI_CO_FNC_NetSend;


					{
						[["CLIENT",_req_p], "Client_Connect",[[_cbase select 0,_cbase select 1,0],getPos _x,((_enemy) call CTI_CO_FNC_GetSideColoration),500]] call CTI_CO_FNC_NetSend;
					} forEach _ctown;
					_ci=_ci+1;
			} forEach _d_base;
		};

		CTI_PVF_Server_Priority_Targ ={
			_req_p=_this;
			if (! isNull (missionNamespace getVariable format ["CTI_PRIORITY_%1",(side _req_p)])) then {
				[["CLIENT",_req_p], "Client_SM_priority",(missionNamespace getVariable format ["CTI_PRIORITY_%1",(side _req_p)])] call CTI_CO_FNC_NetSend;
			};
		};


		CTI_PVF_Server_SM_Priority = {
			_sl= (_this select 0) call CTI_CO_FNC_GetSideLogic;
			_sl setVariable ["CTI_PRIORITY",(_this select 1),true];
			[["CLIENT",(_this select 0)], "Client_SM_priority",(_this select 1)] call CTI_CO_FNC_NetSend;
		};

		CTI_PVF_Server_SM_Disactivate = {
			_sl= (_this select 0) call CTI_CO_FNC_GetSideLogic;
			if (! isNull (_sl getVariable  "CTI_PRIORITY")) then {
				if ( _sl getVariable "CTI_PRIORITY" == _this select 1) then {
					_sl setVariable ["CTI_PRIORITY",objNull,true];
				};
			};
			/*if ({_this select 1 == _x } count (missionNamespace getVariable format ["CTI_ACTIVE_%1",_this select 0]) >0 ) then {
				_t= (missionNamespace getVariable format ["CTI_ACTIVE_%1",_this select 0]) - [_this select 1];
				missionNamespace setVariable [format ["CTI_ACTIVE_%1",_this select 0],_t];
				[["CLIENT",(_this select 0)],"Client_Active_Towns",_t] call CTI_CO_FNC_NetSend;
			};*/
			_sl setVariable ["CTI_PREVENT" , _this select 1,false];
		};
		/*CTI_PVF_Server_Hud_Share_Send = {
			[["CLIENT",(_this select 0)], "Client_HUD_reveal",(missionNamespace getVariable format ["CTI_HUD_SHARED_%1",_this select 1])] call CTI_CO_FNC_NetSend;
		};*/
				CTI_PVF_Server_Addeditable_Zeus= {

    	GUER_ZEUS addCuratorEditableObjects [[_this],true] ;
    	diag_log format ["Zeus ::G:: Adding editable %1 .",_this];
		};
		CTI_PVF_Server_Hud_Share_Add= {
			_sl= (_this select 1) call CTI_CO_FNC_GetSideLogic;
			_hud =_sl getVariable "CTI_HUD_SHARED";
			_hud=_hud -[objNull];
			if !((_this select 0) in _hud) then { _hud set [count _hud, (_this select 0)]};
			_sl setVariable ["CTI_HUD_SHARED",_hud,true];
			[["CLIENT",(_this select 1)], "Client_HUD_reveal",[(_this select 0)]] call CTI_CO_FNC_NetSend;
		};
		CTI_PVF_Server_Hud_Share_Remove= {
			_sl= (_this select 1) call CTI_CO_FNC_GetSideLogic;
			_hud =_sl getVariable "CTI_HUD_SHARED";
			if !((_this select 0) in _hud) exitWith {false};
			_hud=_hud -[objNull] - [(_this select 0)];
			if !((_this select 0) in _hud) then { _hud set [count _hud, (_this select 0)]};
			_sl setVariable ["CTI_HUD_SHARED",_hud,true];
		};
		CTI_PVF_Server_Addeditable= {

    	(_this select 0) addCuratorEditableObjects [[_this select 1],true] ;
    	diag_log format ["Zeus ::%2:: Adding editable %1 .",_this select 1, _this select 0];
		};
	};

};

if (CTI_IsClient) then {

	CTI_ANET_Con=False;
	CTI_ANET_Obj=False;
	CTI_P_Active_Towns = [];
	CTI_P_Availlable_Towns = [];
	SM_Ask_Town=objNull;
		// prepare Markers for Base areas
	for "_i" from 1 to CTI_BASE_AREA_MAX do {
			_pos = [0,0,0];
			_marker = createMarkerLocal [(format ["cti_base_%1",_i]), _pos];
			_marker setMarkerShapeLocal "ELLIPSE";
			_marker setMarkerBrushLocal "SolidBorder";
			_marker setMarkerSizeLocal [CTI_BASE_AREA_RANGE,CTI_BASE_AREA_RANGE];
			_marker setMarkerColorLocal  "ColorBrown";
			_marker setMarkerAlphaLocal 0;
	};





	with missionNamespace do {
		//print a message
		CTI_PVF_SM_message={ CTI_P_ChatID commandChat format ["Strat Mode : %1 ",_this] };

		// Update priority target
		CTI_PVF_Client_SM_priority={SM_Ask_Town = _this ;};
		/*
		// Set Active towns for player side
		CTI_PVF_Client_Active_Towns = {CTI_P_Active_Towns = _this};

		// Set available towns for player side
		CTI_PVF_Client_Availlable_Towns = {CTI_P_Availlable_Towns = _this};
		*/
		// Connect Marker 2 positions (POs1,POs2, color, offset)
		CTI_PVF_Client_Connect = {(_this) call CTI_SM_Connect;};

		// Update Mortar POsition (town, pos)
		CTI_PVF_Client_Update_Mortars = {
			_town = _this select 0;
			_pos = _this select 1;
			_mortar_zone = Format ["cti_town_mortar_zone_%1", _town];
			_mortar= Format ["cti_town_mortar_%1", _town];
			_mortar setMarkerPosLocal _pos;
			_mortar_zone setMarkerPosLocal _pos;
		};

		// Update  one base zone
		CTI_PVF_Client_Base_Zone = {
			_side=_this select 0;
			_num= _this select 1;
			_pos=_this select 2;
			_marker = createMarkerLocal [(format ["cti_base_%1_%2",_side,_num]), _pos];
			_marker setMarkerShapeLocal "ELLIPSE";
			_marker setMarkerBrushLocal "SolidBorder";
			_marker setMarkerSizeLocal [CTI_BASE_AREA_RANGE,CTI_BASE_AREA_RANGE];
			_marker setMarkerColorLocal  ((_side) call CTI_CO_FNC_GetSideColoration);
			_marker setMarkerAlphaLocal 0.7;
		};
	};

	waitUntil {! isNil  {missionNamespace getVariable "CTI_PVF_Client_Base_Zone"} && ! isNil {missionNamespace getVariable "CTI_PVF_Client_Update_Mortars"} && ! isNil  {missionNamespace getVariable "CTI_PVF_Client_Connect"}&&  ! isNil {missionNamespace getVariable "CTI_PVF_SM_message"} };
	if ( (missionNamespace getVariable 'CTI_SM_MORTARS')==1) then {
		{
			_town=_x;
			_marker = createMarkerLocal [format ["cti_town_mortar_%1", _town], getPos _town];
			_marker setMarkerTypeLocal "mil_dot";
			_marker setMarkerTextLocal format ["Mortar Team - %1",(_town getVariable "cti_town_name")];
			_marker setMarkerColorLocal "ColorGreen";
			_marker setMarkerSizeLocal [0.5,0.5];
			_marker setMarkerAlphaLocal 0;

			_marker = createMarkerLocal [format ["cti_town_mortar_zone_%1", _town], getPos _town];
			_marker setMarkerShapeLocal "ELLIPSE";
			_marker setMarkerBrushLocal "Border";
			_marker setMarkerSizeLocal [400,400];
			_marker setMarkerColorLocal "ColorGreen";
			_marker setMarkerAlphaLocal 0;
		} forEach CTI_Towns;
	};
};


//Game Dynamics

if (CTI_IsServer) then {
		if ( (missionNamespace getVariable 'CTI_SM_STRATEGIC')==1) then {
			CTI_SM_STRATEGIC_FNC = compilefinal preprocessFileLineNumbers CTI_SM_Allow_Capture;
			0 spawn CTI_SM_STRATEGIC_FNC;
		};
		if ( (missionNamespace getVariable 'CTI_SM_BASEP')==1) then {
			CTI_SM_BASEP_FNC = compilefinal preprocessFileLineNumbers CTI_SM_Base_Prot;
			0 spawn CTI_SM_BASEP_FNC;
		};
		if ( (missionNamespace getVariable 'CTI_SM_RADAR')==1) then {
			CTI_SM_RADAR_FNC = compilefinal preprocessFileLineNumbers "Addons\Strat_mode\Functions\SM_Air_Radar.sqf";
			0 spawn CTI_SM_RADAR_FNC;
		};
		if ( (missionNamespace getVariable 'CTI_SM_PATROLS')==1) then {
			CTI_SM_PATROLS_FNC = compilefinal preprocessFileLineNumbers "Addons\Strat_mode\Functions\SM_AI_Patrols.sqf";
			0 spawn CTI_SM_PATROLS_FNC;
		};
		//0 execVM "Addons\Strat_mode\Functions\SM_CAS_Patrols.sqf";
		//groundcontainer cleanup
		0 call compile preprocessFileLineNumbers "Addons\Strat_mode\Functions\SM_CleanUp.sqf";


		if !( isNil "ADMIN_ZEUS") then {
			0 spawn {
				while {!CTI_GameOver} do {
					ADMIN_ZEUS addCuratorEditableObjects [playableUnits,true];
					sleep 10;
				};
			};
		};
};

if (CTI_IsClient) then {
	Client_AN_Connected=True;
			// Show help and exec loops

	//New Map
	if (missionNamespace getVariable "CTI_EW_ANET" == 1) then {
		MAP_GetItems=compile preprocessfilelinenumbers "Addons\Strat_mode\Functions\SM_MapEntities.sqf";
		MAP_DrawItems=compile preprocessfilelinenumbers "Addons\Strat_mode\Functions\SM_Draw_Map_Icons.sqf";
		MAP_DrawLines=compile preprocessfilelinenumbers "Addons\Strat_mode\Functions\SM_Draw_Map_Lines.sqf";
		SHOWTOMAP=[[],[],[]];
		0 spawn {
			disableSerialization;
			_map1=controlNull;
			while {isNull _map1} do {
				_map1=findDisplay 12 displayCtrl 51;
				sleep 0.1;
			};
			_map1 ctrlAddEventHandler ["Draw", "_this call MAP_DrawItems;_this call MAP_DrawLines;"];
		};
		0 spawn {
			disableSerialization;
			_map2=controlNull;
			while {isNull _map2} do {
				{if !(isNil {_x displayctrl 101}) then {_map2= _x displayctrl 101};} count (uiNamespace getVariable "IGUI_Displays");
				sleep 0.1;
			};
			_map2 ctrlAddEventHandler ["Draw", "_this call MAP_DrawItems;"];
		};
		0 spawn {
			while {!CTI_GameOver} do {
				SHOWTOMAP= 0 call MAP_GetItems;
				sleep 1;
			};
		};
	} else {
		0 spawn {
			waitUntil {!isNil {CTI_P_SideLogic getVariable "cti_teams"}};
			if (CTI_SM_FAR == 1 ) then {
				execFSM "Addons\Strat_mode\FSM\update_markers_team.fsm";
			} else {
				execFSM "Client\FSM\update_markers_team.fsm";
			};
		};
	};

  0 execVM "Addons\Strat_mode\Functions\SM_3pRestrict.sqf";
  0 execVM "Addons\Strat_mode\Functions\SM_AttachStatics.sqf";


	// JIP
	0 spawn {
		if ((side player) == resistance) exitWith {false};
		sleep 5;
		//JIP
		/*if ( (missionNamespace getVariable 'CTI_SM_STRATEGIC')==1) then {
			["SERVER", "Server_Active_Towns", player] call CTI_CO_FNC_NetSend;
			["SERVER", "Server_Availlable_Towns", player] call CTI_CO_FNC_NetSend;
			["SERVER", "Server_Priority_Targ", player] call CTI_CO_FNC_NetSend;
		};*/
		if ( (missionNamespace getVariable 'CTI_SM_MORTARS')==1) then {
			["SERVER", "Server_Mortars_Towns", player] call CTI_CO_FNC_NetSend;
		};

		if ( (missionNamespace getVariable 'CTI_SM_BASEP')==1) then {
			["SERVER", "Server_Base_Connect", player] call CTI_CO_FNC_NetSend;
			["SERVER", "Server_Base_Detec", player] call CTI_CO_FNC_NetSend;
		};
	};

	//dynamics and functions
	0 execVM "Addons\Strat_mode\Functions\SM_Town_Actions.sqf";

	//adaptative group size - Markus - Disabled
	//0 execVM "Addons\Strat_mode\Functions\SM_AdaptGroup.sqf";

	// gear auto save
	/*0 spawn {
		waitUntil {alive player};
		while {! CTI_GameOver} do {
			if (CTI_PLAYER_REEQUIP == 1  && ! CTI_P_Respawning && alive player && !(side player == civilian)) then {CTI_P_LastPurchase= (player) call CTI_UI_Gear_GetUnitEquipment;} ;
			sleep 1;
		};
	};*/
	//-------------

	if ( (missionNamespace getVariable 'CTI_SM_STRATEGIC')==1) then {
		0 execVM "Addons\Strat_mode\Functions\SM_DrawHelp.sqf";
		if !((side player) == resistance) then{
			0 execVM "Addons\Strat_mode\Functions\SM_Orders.sqf";
			0 execVM "Addons\Strat_mode\Functions\SM_TownPriority.sqf";
		};
	};
	if ( (missionNamespace getVariable 'CTI_SM_HALO')==1) then {
		0 spawn {
			while {!CTI_GameOver&& !  ((side player) == resistance)} do {
				player addAction ["<t color='#ff9900'>HALO jump (500$)</t>", "Addons\ATM_airdrop\atm_airdrop.sqf","",100, false, true, "", "vehicle player == player && !CTI_P_PreBuilding && CTI_Base_HaloInRange && [CTI_P_SideJoined, CTI_UPGRADE_HALO, 1] call CTI_CO_FNC_HasUpgrade"];
				waitUntil {!(alive player)};
				waitUntil {alive player};
			};
		};
	};
	if ( (missionNamespace getVariable 'CTI_SM_REPAIR')==1) then {
		0 execVM "Addons\Strat_mode\Functions\SM_RepairVehicule.sqf";
	};

	if ( (missionNamespace getVariable 'CTI_SM_RADAR')==1 && !  ((side player) == resistance)) then {
		0 execVM "Addons\Strat_mode\Functions\SM_Air_Radar.sqf";
		0 spawn {
			waitUntil {! (isNil "SM_Radar_init")};
			{

				if (alive _x ) then {
					_var = missionNamespace getVariable format ["CTI_%1_%2", CTI_P_SideJoined, typeOf _x];
					if ((((_var select 0) select 0) == CTI_RADAR ) ) then {
						(_x) spawn SM_RADAR_LOOP;
					};
				};
			} forEach (CTI_P_SideJoined call CTI_CO_FNC_GetSideStructures);
		};
	};
	//Lauch custom update marker script on towns
	0 spawn {
		waitUntil {!isNil 'CTI_InitTowns'};
		sleep 1;
		if !(CTI_P_SideJoined == resistance) then {
			if (missionNamespace getVariable "CTI_SM_STRATEGIC" == 1) then {
				execFSM "Addons\Strat_mode\FSM\town_markers.fsm";
			} else {
				execFSM "Client\FSM\town_markers.fsm";
			};
		};
	};
	// HUD
	if (missionNamespace getVariable "CTI_EW_HUD" == 1 ) then {
		0 execVM	 "Addons\Strat_mode\HUD\HUD_init.sqf";
	};
};

CTI_Init_Strat=True;