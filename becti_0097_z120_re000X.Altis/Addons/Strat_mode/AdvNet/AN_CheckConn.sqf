#define	AN_Range_V	1000
#define	AN_Range_I	100

/*
_vehicle getVariable "AN_Conn"
_vehicle getVariable "AN_iNet"
_vehicle getVariable "CTI_Net"
*/

_vehicle = _this;
_connection=objNull;

_side_id=_vehicle getVariable "CTI_Net";
if (isNil "_side_id") exitWith{false};
_side =(_side_id)  call CTI_CO_FNC_GetSideFromID;
if (_side == civilian || _side == resistance) exitWith {false};

// destroyed

if !(alive _vehicle) exitWith {false};

//HQ
//if (_vehicle ==(_side) call CTI_CO_FNC_GetSideHQ ) exitWith {True};

// grab Connection
if (! isNil {_vehicle getVariable "AN_Conn"}) then  {_connection=_vehicle getVariable "AN_Conn"};

// disconnected
if (isNull _connection ) exitWith {false};

//check distance
_max_distance=1000;
_up=(_side) call CTI_CO_FNC_GetSideUpgrades;
_up_r=_up select CTI_UPGRADE_NETR;
if (_vehicle isKindOf "Man") then {_max_distance=AN_Range_I+200*_up_r;} else {_max_distance=AN_Range_V+1000*_up_r;};
if (_vehicle isKindOf "FlagPole_F") then {_max_distance=100000};
if (_vehicle distance _connection > _max_distance) exitWith {false};
/*
//check CC
_structures = (_side) call CTI_CO_FNC_GetSideStructures;
_ccs = [CTI_CONTROLCENTER, _structures] call CTI_CO_FNC_GetSideStructuresByType;
if ({_x==_connection} count _ccs >0) exitWith {true};*/

if (! (alive _connection && _connection getVariable "AN_iNet" == _side_id) ) exitWith {false};

true