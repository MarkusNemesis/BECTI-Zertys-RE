

/*
	Script written by Zerty dont remove this comment
*//*
_nbneigh={
		 _this;
		_tv= _this getVariable "cti_town_value";
		_nb_neig=0;
		if ( _tv == 500) then {_nb_neig=1};
		if ( _tv < 500) then {_nb_neig=3};
		if ( _tv < 200) then {_nb_neig=2};
		_nb_neig
};
*/
CTI_Connect_Towns = {

	_ct= _this select 0;
	_tv= _ct getVariable "cti_town_value";
	_neigh= _ct getVariable "CTI_Neigh";

	_towns=CTI_Towns;
	_new_neigh = [_ct,_towns] call CTI_CO_FNC_SortByDistance;
	_new_neigh=	_new_neigh- [_ct];
/*

	{
		if (count (_ct getVariable "CTI_Neigh") < (_ct call _nbneigh) &&!(_x == _ct) )  then {
			if  (_x getVariable "cti_town_value" <500&& {_x==_ct} count (_x getVariable "CTI_Neigh")==0 && count (_x getVariable "CTI_Neigh") <  (_x call _nbneigh)) then {
				diag_log [_ct,_x];
				_t=(_ct getVariable "CTI_Neigh") + [_x];
				_ct setVariable ["CTI_Neigh",_t,True];
				_t=(_x getVariable "CTI_Neigh") + [_ct];
				_x setVariable ["CTI_Neigh",_t,True];
			} ;
		};
	} count _new_neigh;*/
		{
			_nt=_x;
			_oneigh=  _nt getVariable "CTI_Neigh";
		  if ( (_nt getVariable "cti_town_value") <500 && _nt != _ct  && {_x==_nt} count _neigh == 0 && ( count _neigh == 0 ||  _tv <150  &&  count _neigh < 1 ||  _tv >=150 && _tv <200 &&  count _neigh < 2|| _tv >=200 &&_tv <500  && count _neigh <= 2 &&(_nt distance _ct ) <5000)) then {
//		  if ( _nt != _ct  && {_x==_nt} count _neigh == 0 && ( count _neigh == 0 || _tv <500  && count _neigh <= 2 && count _oneigh <3) )then {
		  	_neigh= _neigh + [_nt];
		  	_oneigh= _oneigh + [_ct];
		  	//diag_log format ["%1 -- %2 ",_nt,_ct];
				_ct setVariable ["CTI_Neigh",_neigh,True];
				_nt setVariable ["CTI_Neigh",_oneigh,True];
		  };
		} forEach _new_neigh;

};


CTI_Draw_Towns_conn ={
	private ["_ct","_neigh","_marker"];
	_ct= _this select 0;
	//diag_log _ct;

	_neigh= _ct getVariable "CTI_Neigh";
	while {isNil "_neigh"} do
	{
	  	_neigh= _ct getVariable "CTI_Neigh";
	  	sleep 0.3;
	};

	{
		[getPos _ct,getPos _x,"ColorBlack",500] call CTI_SM_Connect;
	} forEach _neigh;


};

waitUntil {CTI_InitTowns};
{
		_x setVariable ["CTI_Neigh",[],false];
		waitUntil {!isNil {_x getVariable "CTI_Neigh"}};
} forEach CTI_Towns;

//_sh=(CTI_Towns) call CTI_CO_FNC_ArrayShuffle;
_sh=(CTI_Towns);
{
		[_x] call CTI_Connect_Towns;
} forEach _sh;

{
	if !( isNil {_x getVariable "cti_town_fneigh"}) then {
		_neigh= _x getVariable "CTI_Neigh";
		_ot=missionNamespace getVariable (_x getVariable "cti_town_fneigh");
		_oneigh=_ot getVariable "CTI_Neigh";
		_x setVariable ["CTI_Neigh",_neigh+[_ot],True];
		_ot setVariable ["CTI_Neigh",_oneigh+[_x],True];
	};
} forEach CTI_Towns;

{
	[_x] call CTI_Draw_Towns_conn;
} forEach CTI_Towns;

SM_MAP_READY=true;
