#define	AN_Range_V	1000
#define	AN_Range_I	100

/*
_vehicle getVariable "AN_Conn"
_vehicle getVariable "AN_iNet"
_vehicle getVariable "CTI_Net"
*/

_vehicle=_this;

_connected_to=objNull;

_side_id=_vehicle getVariable "CTI_Net";
if (isNil "_side_id") exitWith{};
_side =(_side_id)  call CTI_CO_FNC_GetSideFromID;

if (_side == civilian || _side == resistance) exitWith {false};

//if (_vehicle call AN_Check_Connection) exitWith {false};

if (_vehicle == (_side) call CTI_CO_FNC_GetSideHQ ) exitwith {
	if !(_vehicle getVariable "AN_Conn" == _vehicle ) then {_vehicle setVariable ["AN_Conn",_vehicle,true];};
	if !(_vehicle getVariable "AN_iNet" == _side_id ) then {_vehicle setVariable ["AN_iNet",_side_id,true];};
	if !({_x == _vehicle} count  (_vehicle getVariable "AN_Parrents")>1 ) then {_vehicle setVariable ["AN_Parrents",[_vehicle],false];};
 	false
};


// we dont want to be connected


// man and inside vehicle

if (_vehicle isKindOf "Man" && !(vehicle _vehicle == _vehicle)&& (vehicle _vehicle) getVariable "AN_iNet" == _side_id  ) exitwith {_vehicle setVariable ["AN_Conn",vehicle _vehicle,true]; };

//CONNEnct to leader
if (_vehicle isKindOf "Man" && ! (_vehicle == leader _vehicle)) exitwith {_vehicle setVariable ["AN_Conn",leader _vehicle,true]; };
// Candidates and max distance
_candidates=[];
_max_distance=5000;
_up=(_side) call CTI_CO_FNC_GetSideUpgrades;
_up_r=_up select CTI_UPGRADE_NETR;
if (_vehicle isKindOf "Man") then {_max_distance=AN_Range_I+200*_up_r;} else {_max_distance=AN_Range_V+1000*_up_r;};
if (_vehicle isKindOf "FlagPole_F") then {_max_distance=5000};

// Try to connect to closest CC
//if (count _candidates == 0) then {
	_structures = (_side) call CTI_CO_FNC_GetSideStructures;
	_ccs = [CTI_CONTROLCENTER, _structures] call CTI_CO_FNC_GetSideStructuresByType;
	{ if (_vehicle distance _x <= _max_distance) then {_candidates set [count _candidates,_x];}; true}count _ccs;
//};

// Try to connect to closest town
if (count _candidates == 0) then {
	{
		_town=_x;
		if (!(isNull _town) && !(_town == _vehicle) && _vehicle distance _town <=  _max_distance && (_town getVariable "AN_iNet" == _side_id )&& ! (_x getVariable "AN_Conn" == _vehicle) && {_x == _vehicle} count (_x getVariable "AN_Parrents") == 0 ) then
		{
			_candidates set [count _candidates,_town];
		};

	} count ( (_side_id) call CTI_CO_FNC_GetSideTowns);
};

// try to connect to the HQ
if ((count _candidates == 0) || (_vehicle isKindOf "FlagPole_F")) then {
	_hq = (_side) call CTI_CO_FNC_GetSideHQ;
	if (_vehicle distance _hq <= _max_distance) then { _candidates set [count _candidates,_hq]};
};



// try to connect to another connected vehicle

if !(_vehicle isKindOf "FlagPole_F")  then {
	{
		if (!(_x == _vehicle) && !(_x ==(_side) call CTI_CO_FNC_GetSideHQ) && alive _x && (_x getVariable "AN_iNet" == _side_id ) && ! (_x getVariable "AN_Conn" == _vehicle) && {_x == _vehicle} count (_x getVariable "AN_Parrents") == 0 ) then {_candidates set [count _candidates,_x]};
	} count vehicles;
};
// sort candidates

_final = [_vehicle, _candidates] call CTI_CO_FNC_GetClosestEntity;
// Connect to the closest connected


//_vehicle setVariable ["AN_iNet",_final getVariable "CTI_Net",true];
if !(_final == _vehicle getVariable "AN_Conn" && {_x == _vehicle} count (_final getVariable "AN_Parrents") > 0) then {
//diag_log format ["Reconfiguring %1 -- %2", _vehicle,_final];
_global=if (_vehicle isKindOf "Man") then {false} else  {true};
_vehicle setVariable ["AN_Conn",_final,_global];
//_vehicle setVariable ["AN_iNet",-1,true];
//_vehicle setVariable ["AN_Parrents",(_final getVariable "AN_Parrents") + [_vehicle],false];
};
_vehicle setVariable ["AN_Parrents",((_vehicle getVariable "AN_Conn") getVariable "AN_Parrents") + [_vehicle],false];