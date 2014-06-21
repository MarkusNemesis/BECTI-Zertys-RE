_log=true;
_Z_Object=GUER_ZEUS;

Z_GUER_REM=["A3_Modules_F_Curator_Animals",
"A3_Modules_F_Curator_CAS",
"A3_Modules_F_Curator_Effects",
"A3_Modules_F_Curator_Environment",
"A3_Modules_F_Curator_Flares",
"A3_Modules_F_Curator_Intel",
"A3_Modules_F_Curator_Lightning",
"A3_Modules_F_Curator_Mines",
"A3_Modules_F_Curator_Multiplayer",
"A3_Modules_F_Curator_Objectives",
"A3_Modules_F_Curator_Ordnance",
"A3_Modules_F_Curator_Respawn",
"A3_Modules_F_Curator_Smokeshells"];

Z_GUER_HANDLER={
		_classes = _this select 1;
		_costs = [];
		{
			_show=false;
			_price_full=1;
			_empty_ratio=0.9;
			if (_x isKindOf "Plane" && ! (_x isKindOf "UAV")) then {_price_full=1;};
			if (_x isKindOf "Man") then {_price_full=0.1;};
			if (_x isKindOf "Helicopter") then {_price_full=0.7;};
			if (_x isKindOf "Wheeled_APC_F") then {_price_full=0.4;};
			if (_x isKindOf "Truck_F") then {_price_full=0.2;};
			if (_x isKindOf "Offroad_01_base_F") then {_price_full=0.2;};
			if (_x isKindOf "Quadbike_01_base_F") then {_price_full=0.15;};
			if (_x isKindOf "MRAP_03_base_F") then {_price_full=0.2;};
			if (_x isKindOf "UGV_01_base_F") then {_price_full=0.3;_show=false;};
			if (_x isKindOf "Tank") then {_price_full=0.6;};
			if (_x isKindOf "StaticWeapon") then {_price_full=0.4;_show=false;};
			if (_x isKindOf "Strategic" || _x isKindOf "House") then {_price_full=0.1;};
			if (_x isKindOf "IND_Box_Base") then {_price_full=0.1;};
			_side=(configFile >> "CfgVehicles" >> _x >> "side") call bis_fnc_getcfgdata;
			if ( _side == 2 ||  _x isKindOf "HBarrier_base_F" ||  _x isKindOf "BagFence_base_F" ||  _x isKindOf "BagBunker_base_F" ||_x isKindOf "IND_Box_Base" )then {_show=true;};
			//if (((unitAddons _x) select 0) in Z_GUER_REM) then {_show=false};
			_costs set [count _costs,[_show,(_price_full*_empty_ratio),_price_full]];
		} forEach _classes; // Go through all classes and assign cost for each of them
		_costs
};


if (isNil "_Z_Object" ) exitWith {false};
// if (_log) then {diag_log "Zeus :: Loading addons GUER"};
 // GUER_ZEUS  removeCuratorAddons Z_GUER_REM;
if (_log) then {diag_log "Zeus ::G:: Setting Handler"};
_Z_Object addEventHandler ["CuratorObjectRegistered",Z_GUER_HANDLER];
_Z_Object addEventHandler ["CuratorObjectPlaced",{
	["", [0,0,0], 0, resistance, false, true, true, "FORM",(_this select 1) ] call CTI_CO_FNC_CreateVehicle ;
}];

if (_log) then {diag_log "Zeus ::G:: Setting Coefs"};
_Z_Object setCuratorCoef ["place",-1];
_Z_Object setCuratorCoef ["edit",0];
_Z_Object setCuratorCoef ["delete",-10000];
_Z_Object setCuratorCoef ["destroy",-10000];
_Z_Object setCuratorCoef ["group",0];
_Z_Object setCuratorCoef ["synchronize",0];


if (_log) then {diag_log "Zeus ::G:: Setting Attribute edit"};
[_Z_Object,"object",["UnitPos"]] call  BIS_fnc_setCuratorAttributes;
[_Z_Object,"player",[]]  call  BIS_fnc_setCuratorAttributes;

if (_log) then {diag_log "Zeus ::G:: Setting Camera Ceilling"};
GUER_ZEUS setCuratorCameraAreaCeiling 30;

if (_log) then {diag_log "Zeus ::G:: Setting Zones"};
waitUntil {!isNil "CTI_TOWNS"};

{
	_Z_Object addCuratorEditingArea [(CTI_TOWNS find _x) ,getPos _x,250];
  _Z_Object addCuratorCameraArea [(CTI_TOWNS find _x) ,getPos _x,100];
  true
} count CTI_TOWNS;
