CTI_P_Repairing = false;
_respawn_reset={
	while {!CTI_GameOver} do {
		waitUntil {! (isNull player)&& ( alive player)};
		CTI_P_Repairing = false;
		waitUntil {! (alive player)}
	};
};

SM_repair_vehicle={
	_target = _this select 0;
	_caller = _this select 1;

	_rk = {_x == "Toolkit"} count (backpackItems _caller);

	if (_rk > 0) then {
		CTI_P_Repairing = true ;
		_pos = getPos _caller;
		_caller switchMove "AinvPknlMstpSnonWrflDnon_medic4";
		while {alive _caller && alive _target  && (getDammage _target) > 0 && (_caller distance _target) <5 && (_caller distance _pos)<=1 && (vehicle _caller) ==_caller} do {
			hint "Repairing - This may take some time.";
			sleep 25; // 1
			if (alive _caller && alive _target  && (getDammage _target) > 0 && (_caller distance _target) <5 && (_caller distance _pos)<=1 && (vehicle _caller) ==_caller) then {
				_target setDammage (getDammage _target) - 0.25; // 0.005
				hint parseText format ["<t size='1.3' color='#2394ef'>Damage %1</t>",(getDammage _target)];
			} else {hint "Failed";CTI_P_Repairing = false;};
		};
		if ((_caller distance _target) >5 || (_caller distance _pos)>1 || !((vehicle _caller) ==_caller)) exitWith {_caller switchMove ""; hint "Failed";CTI_P_Repairing = false ;};
		hint "Done";
		_caller switchMove "";
		CTI_P_Repairing = false ;
		hintSilent "";
	} else {
		hint parseText "<t size='1.3' color='#2394ef'>You need a ToolKit to perform this action</t>";
		sleep 5;
		hintsilent "";
	};
};

SM_Force_entry={
	_target = _this select 0;
	_caller = _this select 1;
	_rk=1;
	_rk = {_x == "Toolkit" } count (backpackItems _caller);
	if ((_target getVariable "forced") ) exitWith { hint "This vehicle has already been forced";};
	_pos = getPos _caller;
	if (_rk > 0 ) then {
		_lock=1;
		CTI_P_Repairing = true ;
		_caller switchMove "AinvPknlMstpSnonWrflDnon_medic4";
		while {_lock >0  && (_caller distance _target) <5 && (_caller distance _pos)<0.5 && (vehicle _caller) ==_caller} do
		{
				_lock=_lock-0.02;
				_percent=(1-_lock)*100;
		    hint parseText format ["<t size='1.3' color='#2394ef'>Forcing Lock : %1 percent</t>",ceil (_percent)];
		    sleep 1;
		};
		if ((_caller distance _target) >5 || (_caller distance _pos)>0.5 || !((vehicle _caller) ==_caller)) exitWith { _caller switchMove ""; hint "Failed";CTI_P_Repairing = false ;};
		_target	setOwner (owner player);
		sleep 0.1;
		hint "Done";
		_caller switchMove "";
		_target lock 0;


		{
			_x action [ "eject", _target];
		} forEach crew _target;
		_target setVariable ["forced",false];
		if ( !(_target getVariable "forced") ) then {
			_target addAction ["<t color='#86F078'>Unlock</t>","Client\Actions\Action_ToggleLock.sqf", [], 99, false, true, '', 'alive _target && locked _target == 2'];
			_target addAction ["<t color='#86F078'>Lock</t>","Client\Actions\Action_ToggleLock.sqf", [], 99, false, true, '', 'alive _target && locked _target == 0'];
		};
		_target setVariable ["forced",true];
		CTI_P_Repairing = false ;
		hintSilent "";
	} else {
		hint parseText "<t size='1.3' color='#2394ef'>You need a ToolKit to perform this action</t>";
		sleep 5;
		hintsilent "";
	};
};
0 spawn _respawn_reset;
while {!CTI_GameOver} do {

	_vehicles=  (player nearEntities [["Car","Tank","Air","Ship"], 150]);
	{
			_s=getNumber(configFile >> "CfgVehicles" >> typeOf _x >> "side");

			_rs=switch (_s) do
			{
			    case 0: { east };
			    case 1: { west };
			    case 2: { resistance };
			    default {resistance};
			};
			_enemy=switch (CTI_P_SideJoined) do
			{
			    case east: { west };
			    case west: { east };
			    default {resistance};
			};
			_prevent=false;
			if (_x getVariable "SM_Repairable") then { _prevent =true};
			if (! _prevent) then {
			//diag_log format ["adding repair for %1",_x];
			_x addAction ["<t color='#CC2222'>Repair Vehicle</t>",SM_repair_vehicle, [], 98, false, true,'', '!CTI_P_PreBuilding && ((getDammage _target) >0  ) && alive _target && vehicle _this == _this && ! CTI_P_Repairing'];
			if (! (_rs == CTI_P_SideJoined) && !(_x ==  (_enemy)call CTI_CO_FNC_GetSideHQ )) then { _x addAction ["<t color='#CC2222'>Force Lock</t>",SM_Force_entry, [], 98, false, true,'', '!CTI_P_PreBuilding  && alive _target && vehicle _this == _this && ! CTI_P_Repairing ']};
			 //_x addAction ["<t color='#CC2222'>Force Lock</t>",SM_Force_entry, [], 98, false, true,'', '!CTI_P_PreBuilding  && alive _target && vehicle _this == _this && ! CTI_P_Repairing '];
						//diag_log _rs;

				_x setVariable ["SM_Repairable",true,false];
			};
	} forEach _vehicles;
	sleep 20;
};
