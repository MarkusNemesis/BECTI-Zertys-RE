private ["_town","_town_groups","_side","_group","_pos"];

_town= _this select 0;
_town_groups = _this select 1;



//main Loop
_maingrouploop={

	private ["_group","_town","_town_groups","_objects","_o","_cas"];
	_create_cas={
		_town=_this select 0;
		_units=_this select 1;
		_type=_this select 2;
		_fly=_this select 3;
		_group=createGroup resistance;
		_pos=[_town,500,2000] call CTI_CO_FNC_GetRandomPosition;
		_dir=[_pos, _town] call CTI_CO_FNC_GetDirTo;
		if (_fly == "FLY") then {_pos set [2,1000];};
		_dir=[_pos, _town] call CTI_CO_FNC_GetDirTo;
		_v=[_type,_pos , _dir, resistance, false, true, true,_fly] call CTI_CO_FNC_CreateVehicle;

		[_v,_group] call bis_fnc_spawncrew;
		if !( isNil "ADMIN_ZEUS") then { ADMIN_ZEUS addCuratorEditableObjects [([_v]),true];};
		if !( isNil "ADMIN_ZEUS") then { ADMIN_ZEUS addCuratorEditableObjects [(units _group),true];};
		{_group reveal (_x select 4)} count _units;
		_v flyInHeight 300;
		_wp=_group addWaypoint [(getPos _town), 500];
		_wp setWaypointType "MOVE";
		_wp setWaypointBehaviour "CARELESS";
		_wp setWaypointCombatMode "GREEN";
		_wp setWaypointTimeout [0,0,0];
		_wp setWaypointCompletionRadius 1000;
		_wp setWaypointSpeed "FULL";

		_wp2=_group addWaypoint [(getPos _town), 250];
		_wp2 setWaypointType "SAD";
		_wp2 setWaypointBehaviour "COMBAT";
		_wp2 setWaypointCombatMode "RED";
		_wp2 setWaypointTimeout [10000,10000,10000];
		_wp2 setWaypointCompletionRadius 300;
		_group setCurrentWaypoint _wp;
		diag_log format [ "MORTAR ::  %1 Calling CAS %2", _town,_v];
		[_group,_v]
	};



	_town=_this select 0;
	_cas=[];
	_target=[];
	_group=_this select 1;
	_town_groups=_this select 2;
	diag_log format [ "MORTAR :: Starting mortar from group %1 for town %2 linked to %3", _group,_town,_town_groups];
	while {count(_group call CTI_CO_FNC_GetLiveUnits)>0 &&( _town getVariable "cti_town_sideID")==CTI_RESISTANCE_ID && (_town getVariable "cti_town_resistance_active")} do
	{
		_t=[];
		{
			_add=[];
			 {_s= _x select 2;_nt=_x; if ({_x == _s} count [east,west] >0) then {_add set [count _add,_nt ]} ; true}count ((leader _x) nearTargets CTI_TOWNS_RESISTANCE_DETECTION_RANGE);
			_t = _t + _add;


		} count _town_groups;

		//CAS Creation
		if (count _cas == 0 && _town getVariable "cti_town_value">=300) then {
			_rn= random (1);
			if (_rn > 0.85) then {
				_cas = [_town,_t, "I_Plane_Fighter_03_AA_F","FLY"] call _create_cas;
			} else {
				_cas = [_town,_t, "I_Heli_light_03_F","FORM"] call _create_cas;
			};
		};
		if (count _t >0) then {_target = (_t select floor random count _t)};

		if (count _target >0 ) then {
			//if (count _cas == 0) then {_cas = [_town,_t, "I_Heli_light_03_F"] call _create_cas	};
			diag_log format [ "MORTAR ::  %1 Firing to %2", _group,_target select 0];
			{
				_x commandArtilleryFire [([ _target select 0, 25, 100] call CTI_CO_FNC_GetRandomPosition), "8Rnd_82mm_Mo_shells", 1];
				_x commandArtilleryFire [([_target select 0, 25, 100] call CTI_CO_FNC_GetRandomPosition), "8Rnd_82mm_Mo_shells", 1];
			} forEach units _group;
			sleep (60+ random (60));
		};
	sleep (10);

	};
	if (count _cas >0 ) then {
		if (! isNull (_cas select 0 )) then {
			{deleteVehicle _x} count units (_cas select 0);
			deleteGroup (_cas select 0);
		};
		if (! isNull (_cas select 1) && side (_cas select 1) == resistance && alive (_cas select 1)) then {
			deleteVehicle (_cas select 1);
		};

	};

};


//spawn
_group= createGroup resistance;
_pos= [_town,1000,1500] call CTI_CO_FNC_GetRandomPosition;

_mp=[];
for "_x" from 1 to 4 do {
	_pos2= [_pos,100,400] call CTI_CO_FNC_GetRandomPosition;
	_v = ["I_Mortar_01_F", _pos2, 180, resistance] call CTI_CO_FNC_CreateVehicle;
	_v addEventHandler ["Fired",{_this execVM "Addons\Strat_mode\Functions\SM_Handle_Arty_Round.sqf"} ];
	_m = [_v,_group] call bis_fnc_spawncrew;
	_mp=_mp + [_v];

};
[_town,_group,_town_groups] spawn _maingrouploop;

[_mp,_group,_pos]