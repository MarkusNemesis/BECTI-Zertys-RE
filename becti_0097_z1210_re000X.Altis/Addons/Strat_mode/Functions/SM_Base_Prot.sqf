//private ["",""];

_link_bases ={

	_script=_this select 0;
	_script_object=_this select 1;
	while {!CTI_GameOver} do {
		{
			_side=_x;
			_sidelogic= (_x) call CTI_CO_FNC_GetSideLogic;
			_bases = (_sidelogic getVariable "cti_structures_areas");
			_ci=0;
			{
				_base=_x;
				_conn= missionNamespace getVariable (format ["CTI_BASES_%1_NEIGH",_side]);
				if (count (missionNamespace getVariable (format ["CTI_BASES_%1_NEIGH",_side]) select _ci) !=3 ) then {
						_towns=CTI_Towns;
						_new_neigh = [[_x select 0 , _x select 1 , 0],_towns] call CTI_CO_FNC_SortByDistance;
						//diag_log format ["connecting base %1 of %2 to %3",_ci,_side,[_new_neigh select 0 , _new_neigh select 1]];
						_conn set [_ci,[(_new_neigh select 0) , (_new_neigh select 1), (_new_neigh select 2)]];
						missionNamespace setVariable [(format ["CTI_BASES_%1_NEIGH",_side]) , _conn];
						{
							[["CLIENT",_side], "Client_Connect",[[_base select 0,_base select 1,0],getPos _x,"ColorBrown",500]] call CTI_CO_FNC_NetSend;
						} forEach [(_new_neigh select 0) , (_new_neigh select 1), (_new_neigh select 2)];
						[_base,_side,[(_new_neigh select 0) , (_new_neigh select 1), (_new_neigh select 2)],_script_object] spawn _script;
				};
				_ci=_ci+1;
				sleep 1;
			} forEach _bases;
		} forEach [east,west];
		sleep 5;

	} ;
};

_protect_loop={
	_object= _this select 0;
	_neigh= _this select 1;
	_base = _this select 2;
	_side= _this select 3;
	diag_log format [ "%1 :: Protecting %2" , _base,_object];
	while { {(_x getVariable "cti_town_sideID") == ((_side) call CTI_CO_FNC_GetSideID )}  count _neigh >=3} do {
		_object allowDammage False;
		sleep 10;
	};
	_object allowDammage True;
	diag_log format [ "%1 :: Protectection off %2" , _base,_object];

};


_protect = {
	_base= _this select 0;
	_side = _this select 1;
	_sidelogic= (_side) call CTI_CO_FNC_GetSideLogic;
	_neigh = _this select 2;
	_script= _this select 3;
	_protected = [];
	while {!CTI_GameOver} do {
		if ({(_x getVariable "cti_town_sideID") == ((_side) call CTI_CO_FNC_GetSideID )}  count _neigh >=3 ) then {
			//diag_log (format [ "%1 :: Protection On -- %2" , _base,_neigh]);
			//_objects = ([_base select 0,_base select 1,0] nearEntities ["AllVehicles", (CTI_BASE_AREA_RANGE)]) unitsBelowHeight 50;
			_objects =  ([_base select 0,_base select 1,0] nearObjects ["Building", (CTI_BASE_AREA_RANGE)]);
			{
				_o =_x;
				if (({_x == _o} count _protected <1)&& !(_o isKindOf "Land_Medevac_house_V1_F")) then {
					[_o,_neigh,_base,_side] spawn _script;
					_protected = _protected + [_o];
					//diag_log format [ "%1 :: Protecting %2" , _base,_o];
				};
			} forEach _objects;
		} else {
			_protected = [];
		};
		sleep 10;
	};
};


_detect_base= {
while {!CTI_GameOver} do {
	{

		_side=_x;
		_sidelogic= (_x) call CTI_CO_FNC_GetSideLogic;
		_bases = (_sidelogic getVariable "cti_structures_areas");
		_enemy = switch (_side) do
		{
		    case west: {east };
		    case east: {west };
		};
		_detected= (missionNamespace getVariable (format ["CTI_BASES_%1_FOUND",_enemy]));

		_ci=0;
		{
			_cbase=_x;
			_objects = ([_cbase select 0,_cbase select 1,0] nearEntities ["AllVehicles", (CTI_BASE_AREA_RANGE*2)]) unitsBelowHeight 150;
			if ( ({_ci == _x} count _detected) !=1 && (_enemy countSide _objects) > 0 ) then {
				_detected=_detected + [_ci];
				missionNamespace setVariable [(format ["CTI_BASES_%1_FOUND",_enemy]),_detected];
				[["CLIENT",_enemy], "Client_Base_Zone",[_side,_ci,[_cbase select 0,_cbase select 1,0]]] call CTI_CO_FNC_NetSend;
				_conn= missionNamespace getVariable (format ["CTI_BASES_%1_NEIGH",_side]);
				_ctown=_conn select _ci;
				{
					[["CLIENT",_enemy], "Client_Connect",[[_cbase select 0,_cbase select 1,0],getPos _x,((_side) call CTI_CO_FNC_GetSideColoration),500]] call CTI_CO_FNC_NetSend;
				} forEach _ctown;
			};
			_ci = _ci +1;
		} forEach _bases;
		//diag_log format ["%1 : bases %2 : detected : %3",_side,_bases,_detected]
	} forEach [east,west];
	sleep 5;
};

};

[_protect,_protect_loop] spawn _link_bases;


0 spawn _detect_base;