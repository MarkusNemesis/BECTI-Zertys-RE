SM_Last_dis=0;
SM_TO_dis=60;

SM_Ask_Priority={

	hint parseText format ["<t size='1.3' color='#2394ef'>Priority Target</t><br /><br />Click near the town you want to activate next. <br /> It wont be activated until it is available for capture.<br /> Once deactivated, the priority target will be removed. <br />Current priority target :<t  color='#2394ef'> %1 </t>",(SM_Ask_Town getVariable "cti_town_name")];

	openMap true;
	SM_mapclick = false;
	onMapSingleClick ' temp_Ask_Town= (_pos) call CTI_CO_FNC_GetClosestTown;SM_mapclick = true; onMapSingleClick ""; true;';



		waitUntil {SM_mapclick or !(visiblemap)};
		if (!visibleMap) exitwith {
				systemChat "Priority Target Cancelled";
			hintsilent "";
			breakOut "main";
		};
		[["CLIENT",CTI_P_SideJoined],"SM_message",format ["Next Priority Town is %1 ",(temp_Ask_Town getVariable "cti_town_name")]] call CTI_CO_FNC_NetSend ;
		CTI_P_ChatID commandChat format  ["Next Priority Town is %1 ",(temp_Ask_Town getVariable "cti_town_name")];
		openMap false;
		hint parseText format ["Next Priority Town is <t  color='#2394ef'>%1</t>",(temp_Ask_Town getVariable "cti_town_name")];
		["SERVER","Server_SM_Priority",[CTI_P_SideJoined,temp_Ask_Town]] call CTI_CO_FNC_NetSend;

};
SM_Disactivate_Town={
		hint parseText "<t size='1.3' color='#2394ef'>Force Deactivation</t><br /><br />Click near the town you want to deactivate. <br /> This will activate your priority target.<br /> Note that it will despawn the AI.";

	openMap true;
	SM_mapclick = false;
	onMapSingleClick ' temp_Ask_Town= (_pos) call CTI_CO_FNC_GetClosestTown;SM_mapclick = true; onMapSingleClick ""; true;';



		waitUntil {SM_mapclick or !(visiblemap)};
		if (!visibleMap) exitwith {
				systemChat "Town deactivation Cancelled";
			hintsilent "";
			breakOut "main";
		};
		["SERVER","Server_SM_Disactivate",[CTI_P_SideJoined,temp_Ask_Town]] call CTI_CO_FNC_NetSend;
		CTI_P_ChatID commandChat format ["Commander is deactivating %1",(temp_Ask_Town getVariable "cti_town_name")];
		openMap false;
		[["CLIENT",CTI_P_SideJoined],"SM_message",format ["Commander is deactivating %1",(temp_Ask_Town getVariable "cti_town_name")]] call CTI_CO_FNC_NetSend ;
		SM_Last_dis=time;
};

while {! CTI_GameOver } do {

	player addAction ["<t color='#ff9900'>SM# Set Active Town</t>",SM_Ask_Priority,[], 92, false, true,'', '!CTI_P_PreBuilding && alive _this  && ! CTI_P_Repairing && CTI_CL_FNC_IsPlayerCommander'];
	player addAction ["<t color='#ff9900'>SM# Force town Deactivation</t>",SM_Disactivate_Town,[], 92, false, true,'', '!CTI_P_PreBuilding && alive _this  && ! CTI_P_Repairing && CTI_CL_FNC_IsPlayerCommander && !(isNull SM_Ask_Town) && time > (SM_Last_dis +SM_TO_dis)'];
	player addAction ["<t color='#ff9900'>SM# Clear Priority Target</t>","['SERVER','Server_SM_Priority',[CTI_P_SideJoined,objNull]] call CTI_CO_FNC_NetSend;SM_Ask_Town = objNull;",[], 92, false, true,'', '!CTI_P_PreBuilding && alive _this  && ! CTI_P_Repairing && CTI_CL_FNC_IsPlayerCommander && !(isNull SM_Ask_Town)'];
	waitUntil {! alive player};
	sleep 10;
	waitUntil {alive player};
};