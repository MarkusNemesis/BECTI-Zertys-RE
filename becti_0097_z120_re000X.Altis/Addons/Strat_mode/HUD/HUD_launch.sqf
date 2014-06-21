#define HUD_IDC 1500000
#define	HUD_M_MAX	20
#define	HUD_TARG_MAX	100
#define	HUD_TOWN_MAX	10


HUD_GetRevives=compile preprocessfilelinenumbers "Addons\Strat_mode\HUD\HUD_GetRevive.sqf";
HUD_ShowRevives=compile preprocessfilelinenumbers "Addons\Strat_mode\HUD\HUD_ShowRevive.sqf";
HUD_GetTowns=compile preprocessfilelinenumbers "Addons\Strat_mode\HUD\HUD_GetTowns.sqf";
HUD_ShowTowns=compile preprocessfilelinenumbers "Addons\Strat_mode\HUD\HUD_ShowTowns.sqf";
HUD_GetTargets=compile preprocessfilelinenumbers "Addons\Strat_mode\HUD\HUD_GetTargets.sqf";
HUD_ShowTargets=compile preprocessfilelinenumbers "Addons\Strat_mode\HUD\HUD_ShowTargets.sqf";



HUD_UpdateInfo={
	_hud=_this;
	disableSerialization;
	_basic=(_hud displayCtrl(HUD_IDC+1));
	_pro=(_hud displayCtrl(HUD_IDC+3));
	// capture
	_town=((player) call CTI_CO_FNC_GetClosestTown);
	if ( player distance _town < CTI_MARKERS_TOWN_AREA_RANGE) then {
		_pro ctrlShow true;
		_pb=(CTI_TOWNS_CAPTURE_VALUE_CEIL - (_town getVariable "cti_town_capture")) / CTI_TOWNS_CAPTURE_VALUE_CEIL ;
		_pro progressSetPosition  _pb ;
	} else {
		_pro ctrlShow false;
	};
	//-------INFO -------

	_t="<t size='0.75' align='right'>";
	if (missionNamespace getVariable "CTI_EW_ANET" == 1) then {
		_co="";
		if (((vehicle player) getVariable "AN_iNet") == ((CTI_P_SideJoined) call CTI_CO_FNC_GetSideID)) then {_co="<t color='#00ff00'>Connected</t>"} else {_co="<t color='#ffff00'>Out Of Range</t>"};
		if ((vehicle player) getVariable "CTI_Net"== -1) then {_co="<t color='#ff0000'>Forced Dis.</t>"};
		_t=_t+format ["Net: %1 <br />",_co];
	};
	_t= _t+format	["%1  <t color='#00ff00'> $$ </t> <br />",[group player, CTI_P_SideJoined] call CTI_CO_FNC_GetFunds] ;
	_t=_t+format	["%1  <t color='#ff0000'><img image='A3\ui_f\data\IGUI\Cfg\Actions\heal_ca.paa'/></t> <br />",ceil( (1- getDammage	player)*100)] ;
	if ( (missionNamespace getVariable 'CTI_SM_RADAR')==1 && (count ([CTI_RADAR, ((CTI_P_SideJoined) call CTI_CO_FNC_GetSideStructures)] call CTI_CO_FNC_GetSideStructuresByType) > 0 )) then {
		//_t=_t+"<t underline='true'> Radars:</t><br />";
		_air_c="color='#ffff00'";
		_art_c="color='#ffff00'";
		if (([CTI_P_SideJoined, CTI_UPGRADE_AIRR, 1] call CTI_CO_FNC_HasUpgrade)) then {_air_c="color='#00ff00'";};
		if (([CTI_P_SideJoined, CTI_UPGRADE_ARTR, 1] call CTI_CO_FNC_HasUpgrade)) then {_art_c="color='#00ff00'";};
		if (count SM_Radar_Detected >0 ) then {_air_c="color='#ff0000'";};
		if (SM_Arty_Detected >0) then {_art_c="color='#ff0000'";};
		_t=_t+"<t size='1.75'><t "+_air_c+"><img image='a3\air_f_gamma\Plane_Fighter_03\Data\UI\map_plane_fighter_03_ca.paa'/></t><t "+_art_c+"><img image='\a3\ui_f\data\gui\cfg\CommunicationMenu\artillery_ca.paa'/></t></t><br />";
		//_t=_t+"<t size='1.75'><t "+_air_c+"><img image='a3\air_f_gamma\Plane_Fighter_03\Data\UI\map_plane_fighter_03_ca.paa'/></t></t><br />";
	};
	_t=_t+"<t underline='true'> Active Towns:</t><br />";
	{
		_marker = format ["cti_town_marker_%1", _x];

		_icon = switch (getMarkerColor _marker) do
		{
		    case 	"ColorGreen":{ "<t color='#00ff00'><img image='A3\ui_f\data\map\Markers\Military\flag_ca.paa'/></t>" };
		    case 	"ColorBlue":{ "<t color='#0000ff'><img image='A3\ui_f\data\map\Markers\Military\flag_ca.paa'/></t>" };
		    case 	"ColorRed":{ "<t color='#ff0000'><img image='A3\ui_f\data\map\Markers\Military\flag_ca.paa'/></t>" };
		    default { "<t color='#00ff00'><img image='A3\ui_f\data\map\Markers\Military\flag_ca.paa'/></t>"  };
		};
		_t = _t + format ["%1  %2<br />",(_x getVariable "cti_town_name"),_icon	]
	} count CTI_P_Active_Towns;
	_t=_t+"</t>";
	_basic ctrlSetStructuredText	parseText	 _t;
};


HUD_UpdateVehicle={
	_hud=_this;
	disableSerialization;
	_veh=(_hud displayCtrl(HUD_IDC+2));
	if (vehicle	player == player ||  {isplayer _x} count crew (vehicle player) <2  ) then{
		_veh ctrlShow	false;
	} else {
		_veh ctrlShow	true;
		_text="<t size='0.7'>";
		_d=driver	(vehicle	player);
		if (!isNull	_d && isPlayer	_d) then {_text=_text + 	format	["<img image='Rsc\Pictures\i_driver.paa'/>%1<br />",name _d];};
		_c=commander (vehicle	player);
		if (!isNull	_c && isPlayer	_c) then {_text=_text + 	format	["<img image='Rsc\Pictures\i_commander.paa'/>%1<br />",name _c];};
		_g=gunner (vehicle	player);
		if (!isNull	_g && isPlayer	_g) then {_text=_text + 	format	["<img image='Rsc\Pictures\i_gunner.paa'/>%1<br />",name _g];};
		{
				if (isplayer _x && !(commander (vehicle	player) == _x || driver	(vehicle	player) ==_x || gunner (vehicle	player) ==_x )) then {
					_text=_text + 	format	["<img image='Rsc\Pictures\i_turrets.paa'/>%1<br />",name _x];
				};
		} forEach crew (vehicle	player);
		_text=_text+"</t>";
		_veh ctrlSetStructuredText	parseText	 _text;
	};
};



HUD_Revive_frame={
	["ReviveFrame", "onEachFrame", "{
	 	disableSerialization;
		_hud=uiNamespace getVariable 'HUD';
		[_hud] call HUD_ShowRevives;
	}"] call BIS_fnc_addStackedEventHandler;
};
HUD_AddFrameHandler={
	["hudFrame", "onEachFrame", "{
	 	disableSerialization;
		_hud=uiNamespace getVariable 'HUD';
		[_hud] call HUD_ShowTargets;
		[_hud] call HUD_ShowTowns;
	}"] call BIS_fnc_addStackedEventHandler;
};

HUD_RemoveFrameHandler={
	["hudFrame", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
};
/*
0 spawn {
	disableSerialization;
	_hud=uiNamespace getVariable 'HUD';
	while {!CTI_GameOver} do {
		[_hud] call HUD_ShowTargets;
		//[_hud] call HUD_ShowTowns;
		[_hud] call HUD_ShowRevives;
	};
};*/

0 call HUD_Revive_frame;

0 spawn {
	while {!CTI_GameOver} do {
		waitUntil {HUD_Tactical};
		if HUD_Tactical then {
			HUD_Targets = (0) call HUD_GetTargets;
			//HUD_Targets = (0) exec "Addons\Strat_mode\HUD\HUD_GetTargets.sqf";
			HUD_Towns = (0) call HUD_GetTowns;
		};
		sleep 1;
	};
};

0 spawn {
	while {!CTI_GameOver} do {
			disableSerialization;
			_hud=uiNamespace getVariable 'HUD';
			(_hud) call HUD_UpdateInfo;
			(_hud) call HUD_UpdateVehicle;
			HUD_Revives = (0) call HUD_GetRevives;
			sleep 2;
	};
};






