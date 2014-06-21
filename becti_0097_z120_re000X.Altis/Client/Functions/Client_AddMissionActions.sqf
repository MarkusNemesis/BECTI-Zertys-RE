/*
  # HEADER #
	Script: 		Client\Functions\Client_AddMissionActions.sqf
	Alias:			CTI_CL_FNC_AddMissionActions
	Description:	Add the contextual actions from the mission to the player
					Note that this filed is called at player init and upon respawn
	Author: 		Benny
	Creation Date:	19-09-2013
	Revision Date:	19-09-2013

  # PARAMETERS #
    None

  # RETURNED VALUE #
	None

  # SYNTAX #
	call CTI_CL_FNC_AddMissionActions

  # EXAMPLE #
    call CTI_CL_FNC_AddMissionActions
*/

if (CTI_P_SideJoined == resistance) exitWith {false};

//--- Commander related actions
if ((CTI_P_SideLogic getVariable "cti_commander") == group player) then {
	player addAction ["<t color='#a5c4ff'>MENU: Construction (HQ)</t>", "Client\Actions\Action_BuildMenu.sqf", "", 93, false, true, "", "_target == player && !CTI_P_PreBuilding && CTI_Base_HQInRange"];
};

//--- Mixed actions
player addAction ["<t color='#a5c4ff'>MENU: Commanding</t>", "Client\Actions\Action_CommandMenu.sqf", "", 95, false, true, "", "!CTI_P_PreBuilding"];
player addAction ["<t color='#a5c4ff'>MENU: Factory</t>", "Client\Actions\Action_PurchaseMenu.sqf", "", 93, false, true, "", "_target == vehicle player && !CTI_P_PreBuilding &&Client_AN_Connected && (CTI_Base_BarracksInRange || CTI_Base_LightInRange || CTI_Base_HeavyInRange || CTI_Base_AirInRange || CTI_Base_AmmoInRange || CTI_Base_RepairInRange || CTI_Base_NavalInRange)"];
player addAction ["<t color='#a5c4ff'>MENU: Equipment</t>", "Client\Actions\Action_GearMenu.sqf", "", 93, false, true, "", "(CTI_Base_GearInRange || CTI_Base_GearInRange_Mobile || CTI_Base_GearInRange_FOB) && !CTI_P_PreBuilding"];
player addAction ["<t color='#a5c4ff'>MENU: Options</t>", "Client\Actions\Action_OptionsMenu.sqf", "", 95, false, true, "", "!CTI_P_PreBuilding"];

player addAction ["<t color='#3333bb'>Network : Disconnect </t>", "player setVariable ['CTI_Net',-1,true];player setVariable ['AN_iNet',CTI_P_SideID,true];", "", -100, false, true, "", "!CTI_P_PreBuilding && (player getVariable 'CTI_Net')==CTI_P_SideID "];
player addAction ["<t color='#3333bb'>Network : Reconnect </t>", "player setVariable ['CTI_Net',CTI_P_SideID,true];", "", -1001, false, true, "", "!CTI_P_PreBuilding &&!((player getVariable 'CTI_Net')==CTI_P_SideID) "];
player addAction ["<t color='#3333bb'>Network : Vehicle Disconnect </t>", "(vehicle player) setVariable ['CTI_Net',-1,true];(vehicle player) setVariable ['AN_iNet',CTI_P_SideID,true];", "", -100, false, true, "", "!CTI_P_PreBuilding && ((vehicle player) getVariable 'CTI_Net')==CTI_P_SideID && !((vehicle player) == player)"];
player addAction ["<t color='#3333bb'>Network : Vehicle Reconnect </t>", "(vehicle player) setVariable ['CTI_Net',CTI_P_SideID,true];", "", -100, false, true, "", "!CTI_P_PreBuilding&& !(((vehicle player)getVariable 'CTI_Net')==CTI_P_SideID) && !((vehicle player) == player)"];

player addAction ["<t color='#3333bb'>Network : Synchronize Tactical Hud</t>", "['SERVER', 'Server_Hud_Share_Send', [player,CTI_P_SideJoined]] call CTI_CO_FNC_NetSend;{['SERVER', 'Server_Hud_Share_Add',[_x,CTI_P_SideJoined]] call CTI_CO_FNC_NetSend;} count HUD_T_OBJ;", "", -100, false, true, "", "!CTI_P_PreBuilding && HUD_Tactical && (player getVariable 'AN_iNet')==CTI_P_SideID "];
//