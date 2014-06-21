AN_Check_Connection=compile preprocessfilelinenumbers "Addons\Strat_mode\AdvNet\AN_CheckConn.sqf";
AN_Disconnect=compile preprocessfilelinenumbers "Addons\Strat_mode\AdvNet\AN_Disconnect.sqf";
AN_Reconfigure=compile preprocessfilelinenumbers "Addons\Strat_mode\AdvNet\AN_Reconfigure.sqf";


if (CTI_IsClient) then {
	/*player setVariable ["AN_iNet", -1,false];
	with missionNamespace do {
		CTI_PVF_Client_AN_Parrents={
			player setVariable ["AN_Parrents", _this,false];
		};
		CTI_PVF_Client_AN_iNet={
			player setVariable ["AN_iNet", _this,false];
		};
	};*/
	0 spawn {
		while {!CTI_GameOver} do{
			waitUntil {! (isNull player) && alive player};
			waitUntil {! (isNil {player getVariable "CTI_Net"} || isNil {player getVariable "AN_iNet"})};
			while {alive player} do {
				if (!(player getVariable "CTI_Net"==player getVariable "AN_iNet") || player getVariable "CTI_Net" == -1) then{Client_AN_Connected=False;} else {Client_AN_Connected=true;} ;
				sleep 0.2;
			};
		};
	};
};




if (CTI_IsServer) then {
	with missionNamespace do {
		CTI_PVF_Server_Run_Net={
			_this spawn AN_Launch;
		};
	};
	AN_Launch={

		_vehicle = _this select 0;
		_side_id= _this select 1;
		if ! (isNil {_vehicle getVariable "AN_iNet"}) exitWith {false};
		//diag_log format ["Starting networking for %1 side %2", _this select 0 , _this	 select 1];
		if (isNil {_vehicle getVariable "CTI_Net"}) then {_vehicle setVariable ["CTI_Net",_side_id,true];};
		if (isNil {_vehicle getVariable "AN_Conn"}) then {_vehicle setVariable ["AN_Conn",objNull,false];};
		if (isNil {_vehicle getVariable "AN_iNet"}) then {_vehicle setVariable ["AN_iNet",-1,false];};
		if (isNil {_vehicle getVariable "AN_Parrents"}) then {_vehicle setVariable ["AN_Parrents",[],false];};
		waitUntil {! (isNil {_vehicle getVariable "CTI_Net"} || isNil {_vehicle getVariable "AN_Conn"} || isNil {_vehicle getVariable "AN_iNet"} || isNil {_vehicle getVariable "CTI_Net"})};
		_vehicle spawn AN_Update_Connection;
		(_vehicle) spawn AN_Reconfigure_loop;
	};

	AN_Update_Connection={
		_vehicle=_this;
		while {! CTI_GameOver && alive  _vehicle} do {
			if ((_vehicle) call AN_Check_Connection) then {
				if !((_vehicle getVariable "AN_iNet") == (_vehicle getVariable "AN_Conn") getVariable "AN_iNet") then {
					_vehicle setVariable ["AN_iNet",(_vehicle getVariable "AN_Conn") getVariable "AN_iNet" ,true];
					//if (_vehicle isKindOf "Man" && isPlayer _vehicle) then {[["CLIENT",_vehicle], "Client_AN_iNet",(_vehicle getVariable "AN_Conn") getVariable "AN_iNet"] call CTI_CO_FNC_NetSend;};
				};
			} else {
				if !((_vehicle getVariable "AN_iNet") == -1) then {
					_vehicle setVariable ["AN_iNet",-1,true];
					//if (_vehicle isKindOf "Man" && isPlayer _vehicle) then {[["CLIENT",_vehicle], "Client_AN_iNet",-1] call CTI_CO_FNC_NetSend;};
				};
			};
			sleep 3;
		};
		_vehicle setVariable ["AN_iNet",nil,true];
	};

	AN_Switchable = {
		_unit=_this;
		waitUntil {alive _unit && ! (isNull _unit) && CTI_Init_Server};
		_side = side _unit;
		_side_id =(side _unit)  call CTI_CO_FNC_GetSideID;
		while {!CTI_GameOver} do {
			waitUntil {alive _unit };
			[_unit,_side_id] call AN_Launch;
			waitUntil {!alive _unit};
		};
	};
	AN_Reconfigure_loop={
			while {! CTI_GameOver && alive  _this } do {
				_this call AN_Reconfigure;
				sleep 10+random(15);
			};
	};
	//waitUntil {CTI_Init_Server};
	{ (_x) spawn AN_Switchable; true } count switchableUnits;

	0 spawn {
		while {!CTI_GameOver} do
		{
		   	{ [_x,((side _x)  call CTI_CO_FNC_GetSideID)] call AN_Launch; true } count playableUnits;
		   	sleep 1;
		};

	};

	{ [_x,-1]  spawn AN_Launch ;true }count CTI_Towns;
};