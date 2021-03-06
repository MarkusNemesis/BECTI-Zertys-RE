/*
  # HEADER #
	Script: 		Server\Functions\Server_StartUpgrade.sqf
	Alias:			CTI_SE_FNC_StartUpgrade
	Description:	Start upgrading an element, The server-side can spawn it straigh away.
					Use the PVF "CTI_PVF_Request_Upgrade" for a client-request
	Author: 		Benny
	Creation Date:	23-09-2013
	Revision Date:	23-09-2013

  # PARAMETERS #
    0	[Side]: The side which requested the upgrade
    1	[Integer]: The upgrade element
    2	[Integer]: The upgrade current level

  # RETURNED VALUE #
	None

  # SYNTAX #
	[SIDE, UPGRADE, LEVEL] spawn CTI_SE_FNC_StartUpgrade

  # DEPENDENCIES #
	Common Function: CTI_CO_FNC_GetSideLogic
	Common Function: CTI_CO_FNC_GetSideUpgrades
	Common Function: CTI_CO_FNC_NetSend

  # EXAMPLE #
    [West, CTI_UPGRADE_BARRACKS, 0] spawn CTI_SE_FNC_StartUpgrade
	  -> Will bring the barracks on level 1 after the upgrade completion
*/

private ["_level", "_side", "_upgrade"];

_side = _this select 0;
_upgrade = _this select 1;
_level = _this select 2;

_upgrade_time = ((missionNamespace getVariable Format["CTI_%1_UPGRADES_TIMES", _side]) select _upgrade) select _level;
if (CTI_DEBUG) then {_upgrade_time =0};
//sleep _upgrade_time;
private ['_pTime','_rTime'];
_pTime = floor time;
// Markus - Time till the upgrade is completed
_upgrade_time call compile format ["RE_VAR_UPGRADECOUNTDOWN_%1 = _this; publicVariable 'RE_VAR_UPGRADECOUNTDOWN_%1';", _side];
waitUntil {
	if ((floor time) > _pTime) then {
		_pTime = floor time;
		_upgrade_time = _upgrade_time - 1;
		_upgrade_time call compile format ["RE_VAR_UPGRADECOUNTDOWN_%1 = _this; publicVariable 'RE_VAR_UPGRADECOUNTDOWN_%1';", _side];
	};
	_uTime < time
};

_logic = (_side) call CTI_CO_FNC_GetSideLogic;
_upgrades = (_side) call CTI_CO_FNC_GetSideUpgrades;
_upgrades set [_upgrade, (_upgrades select _upgrade) + 1];

_logic setVariable ["cti_upgrades", _upgrades, true];
_logic setVariable ["cti_upgrade", -1, true];

[["CLIENT", _side], "Client_OnMessageReceived", ["upgrade-ended", [_upgrade, _level+1]]] call CTI_CO_FNC_NetSend;
