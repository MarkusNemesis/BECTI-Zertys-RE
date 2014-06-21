private ["_town","_objects","_sideID","_side","_west","_east","_awest","_aeast"];

waitUntil {SM_MAP_READY};
SM_ACTIVATION_LOG=False;


while {!CTI_GameOver} do
{
	// old values to check for update needed
	{
		missionNamespace setVariable [format ["OLD_AVAILlABLE_%1",_x],missionNamespace getVariable format ["CTI_AVAILLABLE_%1",_x]];
		missionNamespace setVariable [format ["OLD_ACTIVE_%1",_x],missionNamespace getVariable format ["CTI_ACTIVE_%1",_x]];
		missionNamespace setVariable [format ["OLD_PRIORITY_%1",_x],missionNamespace getVariable format ["CTI_PRIORITY_%1",_x]];
	} forEach [east,west];

	// cleenup activation
	{
		_t=_x;
		if (_x getVariable "cti_town_disactivate") then {
			{
				_ac_s=missionNamespace getVariable format ["CTI_ACTIVE_%1",_x];
				_pr_s=missionNamespace getVariable format ["CTI_PRIORITY_%1",_x];
				_id_s=missionNamespace getVariable format ["CTI_%1_ID",_x];
				if (_pr_s == _t && ((_t) getVariable "cti_town_sideID" == _id_s) ) then {
					_pr_s=objNull;
					missionNamespace setVariable [format ["CTI_PRIORITY_%1", _x],_pr_s];
				};
				/*if (_t == (missionNamespace getVariable format ["CTI_PREVENT_%1", _x])) then{
					missionNamespace setVariable [format ["CTI_PREVENT_%1", _x] , objNull];
				};*/
				if ({_t == _x} count _ac_s >0 ) then {
					_ac_s = _ac_s - [_t];
					missionNamespace setVariable [format ["CTI_ACTIVE_%1",_x],_ac_s];
					[["CLIENT",_x],"SM_message",format ["Town is %1 is now Inactive",(_t getVariable "cti_town_name")]] call CTI_CO_FNC_NetSend ;
				};
			} forEach [west,east];
			_t setVariable ["cti_town_disactivate",false];
		};
	} forEach CTI_TOWNS;

	// Compute available town per side
	{
		_av_s=[];
		_ac_s=missionNamespace getVariable format ["CTI_ACTIVE_%1",_x];
		_id_s=missionNamespace getVariable format ["CTI_%1_ID",_x];
		_s=_x;
		{
			_t=_x;
			if (
				{_t == _x} count _ac_s>0 && (( { ((_t) getVariable "cti_town_sideID") == _id_s} count (_x getVariable "CTI_Neigh") >0 ) || count ((_s) call CTI_CO_FNC_GetSideTowns) ==0) && (((_t) getVariable "cti_town_sideID") != _id_s || (_t) getVariable "cti_town_resistance_active" || (_t getVariable "cti_town_occupation_active"  &&  (missionNamespace getVariable "CTI_TOWNS_OCCUPATION" > 0)))
				||
				((_x) getVariable "cti_town_sideID") != _id_s  && ( count ((_s) call CTI_CO_FNC_GetSideTowns) ==0|| { ((_x) getVariable "cti_town_sideID") == _id_s} count (_x getVariable "CTI_Neigh") >0  ))	 then {
				_av_s = _av_s + [_x];
			};
		} forEach CTI_TOWNS;
		if (! isNull (missionNamespace getVariable format ["CTI_PREVENT_%1", _x])) then {
			_av_s=_av_s-[missionNamespace getVariable format ["CTI_PREVENT_%1", _x]];
			missionNamespace setVariable [format ["CTI_PREVENT_%1", _x] , objNull];
		};
		missionNamespace setVariable [format ["CTI_AVAILLABLE_%1",_s],_av_s];

	} forEach [east,west];
	//diag_log format ["Available : W :: %1  E :: %2", CTI_AVAILLABLE_WEST,CTI_AVAILLABLE_EAST];


	{
		_s=_x;
		_av_s=missionNamespace getVariable format ["CTI_AVAILLABLE_%1",_x];
		_ac_s=missionNamespace getVariable format ["CTI_ACTIVE_%1",_x];
		_id_s=missionNamespace getVariable format ["CTI_%1_ID",_x];
		_pr_s=missionNamespace getVariable format ["CTI_PRIORITY_%1",_x];

		_n_ac_s=[];
		{
			_t=_x;
			if ({_x == _t} count _av_s >0 ) then {_n_ac_s = _n_ac_s + [_t];};
		} forEach _ac_s;
		if (count _n_ac_s < CTI_SM_MAX_ACTIVE && ! isnull _pr_s && {_pr_s == _x} count _av_s >0 && {_pr_s == _x} count _n_ac_s == 0  ) then {
			_n_ac_s = _n_ac_s + [_pr_s];
		};


		{
			_t=_x;
			_objects = (_x nearEntities ["AllVehicles", CTI_TOWNS_RESISTANCE_DETECTION_RANGE]) unitsBelowHeight CTI_TOWNS_RESISTANCE_DETECTION_RANGE_AIR;
			_cp= { side _x == _s && isPlayer _x } count _objects;
			if (_cp>0 && {_x == _t} count _n_ac_s ==0 && {_x == _t} count _av_s >0 && count _n_ac_s < CTI_SM_MAX_ACTIVE) then {
				_n_ac_s = _n_ac_s + [_t];
			};
		} forEach _av_s;
		if (! ((count (_ac_s - _n_ac_s) + count (_n_ac_s - _ac_s))== 0) ) then {missionNamespace setVariable [format ["CTI_ACTIVE_%1",_s],_n_ac_s];
		};

	} forEach [east,west];
//	diag_log CTI_AVAILLABLE_WEST;
	sleep 1;
	// Update for clients if needed
	{
		_o_av_s=missionNamespace getVariable format ["OLD_AVAILLABLE_%1",_x];
		_o_ac_s=missionNamespace getVariable format ["OLD_ACTIVE_%1",_x];
		_o_pr_s=missionNamespace getVariable format ["OLD_PRIORITY_%1",_x];
		_av_s=missionNamespace getVariable format ["CTI_AVAILLABLE_%1",_x];
		_ac_s=missionNamespace getVariable format ["CTI_ACTIVE_%1",_x];
		_pr_s=missionNamespace getVariable format ["CTI_PRIORITY_%1",_x];
		if (! ((count (_o_av_s - _av_s) + count (_av_s - _o_av_s))== 0) ) then { [["CLIENT",_x], "Client_Availlable_Towns",_av_s] call CTI_CO_FNC_NetSend; };
		if (! ((count (_o_ac_s - _ac_s) + count (_ac_s - _o_ac_s))== 0) ) then { [["CLIENT",_x],"Client_Active_Towns",_ac_s] call CTI_CO_FNC_NetSend; };
		if (! (_o_pr_s == _pr_s) && !( isNull _o_pr_s && isnull _pr_s)) then {[["CLIENT",(leader ((_x) call CTI_CO_FNC_GetSideCommander))], "Client_SM_priority",_pr_s] call CTI_CO_FNC_NetSend; };

	} forEach [west,east];

	//diag_log format ["W: %1 E: %2", CTI_ACTIVE_WEST,CTI_ACTIVE_EAST];

	sleep 1;
};
