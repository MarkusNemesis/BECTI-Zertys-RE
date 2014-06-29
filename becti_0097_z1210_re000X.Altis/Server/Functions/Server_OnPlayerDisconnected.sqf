/*
  # HEADER #
	Script: 		Server\Functions\Server_OnPlayerDisconnected.sqf
	Alias:			CTI_SE_FNC_OnPlayerDisconnected
	Description:	Triggered when a player leave the server
					Note this function is MP only.
					Also note that the server (in MP) will also trigger this script with a name of __SERVER__
	Author: 		Benny
	Creation Date:	23-09-2013
	Revision Date:	15-10-2013

  # PARAMETERS #
    0	[String]: The Player's UID
    1	[String]: The Player's name
    2	[Number]: The Player's seed ID

  # RETURNED VALUE #
	None

  # SYNTAX #
	[UID, NAME, ID] call CTI_SE_FNC_OnPlayerDisconnected

  # DEPENDENCIES #
	Common Function: CTI_CO_FNC_GetClosestEntity
	Common Function: CTI_CO_FNC_GetFunds
	Common Function: CTI_CO_FNC_GetRandomPosition
	Common Function: CTI_CO_FNC_GetSideCommander
	Common Function: CTI_CO_FNC_GetSideHQ
	Common Function: CTI_CO_FNC_GetSideStructures
	Common Function: CTI_CO_FNC_NetSend

  # EXAMPLE #
    onPlayerDisconnected {[_uid, _name, _id] call CTI_SE_FNC_OnPlayerDisconnected};
*/

_uid = _this select 0;
_name = _this select 1;
_id = _this select 2;

if (CTI_Log_Level >= CTI_Log_Information) then {["INFORMATION", "FILE: Server\Functions\Server_OnPlayerDisconnected.sqf", format["Player [%1] [%2] has left the current session", _name, _uid]] call CTI_CO_FNC_Log};

if (_name == '__SERVER__' || _uid == '') exitWith {}; //--- We don't care about the server!

waitUntil {!isNil 'CTI_Init_Common'};

//--- Was it an Headless Client?
_candidates = missionNamespace getVariable "CTI_HEADLESS_CLIENTS";
if !(isNil '_candidates') then {
	_index = -1;
	{if (_x select 2 == _uid) exitWith {_index = _forEachIndex}} forEach _candidates;
	if (_index > -1) then {
		_candidates set [_index, "!nil!"]; _candidates = _candidates - ["!nil!"];
		missionNamespace setVariable ["CTI_HEADLESS_CLIENTS", _candidates];
		if (CTI_Log_Level >= CTI_Log_Information) then {["INFORMATION", "FILE: Server\Functions\Server_OnPlayerDisconnected.sqf", format["Headless Client [%1] [%2] has been disconnected and was removed from the registered clients. There is now [%3] Headless Clients.", _uid, _name, count _candidates]] call CTI_CO_FNC_Log};
	};
};

//--- We attempt to get the player information in case that he joined before
_get = missionNamespace getVariable format["CTI_SERVER_CLIENT_%1", _uid];
if (isNil '_get') exitWith {if (CTI_Log_Level >= CTI_Log_Warning) then {["WARNING", "FILE: Server\Functions\Server_OnPlayerDisconnected.sqf", format["Disconnected Player [%1] [%2] information couldn't be retrieved", _name, _uid]] call CTI_CO_FNC_Log}};

//--- Get the disconnected group
_team = grpNull;
{if ((group _x getVariable "cti_uid") == _uid) exitWith {_team = group _x}} forEach playableUnits;
if (isNull _team) exitWith {if (CTI_Log_Level >= CTI_Log_Error) then {["ERROR", "FILE: Server\Functions\Server_OnPlayerDisconnected.sqf", format["Disconnected Player [%1] [%2] group couldn't be found among the current playable units", _name, _uid]] call CTI_CO_FNC_Log}};

_side = _get select 3; //--- Get the last side joined
_funds = [_team, _side] call CTI_CO_FNC_GetFunds;
_commander = (_side) call CTI_CO_FNC_GetSideCommander;
_is_commander = if (_commander == _team) then {true} else {false};
_leader = leader _team;

//--- We force the unit out of it's vehicle.
if !(isNull assignedVehicle _leader) then { unassignVehicle _leader; [_leader] orderGetIn false; [_leader] allowGetIn false };
if (vehicle _leader == (_side call CTI_CO_FNC_GetSideHQ)) then { _leader action ["EJECT", vehicle _leader] }; //--- Is it the HQ?

// prevent the commender to keep its money
if (! _is_commander) then {
	_get set [1, _funds];
} else {
	_get set [1, (missionNamespace getVariable format ["CTI_ECONOMY_STARTUP_FUNDS_%1", _side]) ];
};

if ((missionNamespace getVariable "CTI_AI_TEAMS_ENABLED") == 1) then { //--- Place the leader back at base
	_leader enableAI "Move";
	_hq = (_side) call CTI_CO_FNC_GetSideHQ;
	_structures = (_side) call CTI_CO_FNC_GetSideStructures;

	_spawn_at = _hq;
	if (count _structures > 0) then { _spawn_at = [_hq, _structures] call CTI_CO_FNC_GetClosestEntity };

	if (_is_commander) then {if (alive _hq) then { _spawn_at = _hq }}; //--- AI commander will prefer to spawn at HQ if it's alive
	_spawn_at = [_spawn_at, 8, 30] call CTI_CO_FNC_GetRandomPosition;
	_leader setPos _spawn_at;

// --- Zerty edit
if ( (missionNamespace getVariable "CTI_UNITS_CLEANUP") == 1 ) then {
	{
	  if ( (_x != (_side call CTI_CO_FNC_GetSideHQ)) ) then {
		  if (vehicle _x == _x) then { //--- On foot
			  _x setDammage 1 ;
		  } else { //--- In vehicle
			  if ((effectiveCommander vehicle _x) in units player) then { //--- The vehicle is lead by us
				  _x setDammage 1;
			  } else { //--- The vehicle is lead by someone else
				  unassignVehicle _x;
				  _x setDammage 1;
			  };
		  };
	  };
  } forEach (units _team call CTI_CO_FNC_GetLiveUnits);
};


	if (!_is_commander && !isNull _team) then { //--- AI Leader Takeover
		if (CTI_Log_Level >= CTI_Log_Information) then {["INFORMATION", "FILE: Server\Functions\Server_OnPlayerDisconnected.sqf", format["AI Leader is taking over [%1] [%2] slot since he/she left the current session. The team is [%3]", _name, _uid, _team]] call CTI_CO_FNC_Log};
		[_team, _side] execFSM "Server\FSM\update_ai.fsm";
	};
} else { //--- Place the leader at the respawn island and disable his movements
	_leader setPos ([getMarkerPos format["CTI_%1Respawn",_side], 3, 15] call CTI_CO_FNC_GetRandomPosition);
	_leader disableAI "MOVE";
};

_team setVariable ["cti_uid", nil]; //--- Release the uid.

//--- Was it the commander?
if (_is_commander && !isNull _team) then {
	['SERVER','Server_SM_Priority',[_side,objNull]] call CTI_CO_FNC_NetSend;
	//--- Send a message!
	[["CLIENT", _side], "Client_OnMessageReceived", ["commander-disconnected"]] call CTI_CO_FNC_NetSend;

	if ((missionNamespace getVariable "CTI_AI_TEAMS_ENABLED") == 1) then { (_side) execFSM "Server\FSM\update_commander.fsm" }; //--- AI commander takeover
};

//--- Update the global teams if needed
(_side) spawn {
	sleep 10;
	_logic = (_this) call CTI_CO_FNC_GetSideLogic;
	_teams = _logic getVariable "cti_teams";
	if ({isNull _x} count _teams > 0) then {
		_teams = _teams - [objNull];
		_logic setVariable ["cti_teams", _teams];
		if (CTI_Log_Level >= CTI_Log_Information) then {["INFORMATION", "FILE: Server\Functions\Server_OnPlayerDisconnected.sqf", format["Removed some null groups from the Global Teams for side [%1]", _this]] call CTI_CO_FNC_Log};
	};
};