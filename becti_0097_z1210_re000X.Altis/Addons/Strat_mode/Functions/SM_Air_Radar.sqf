// Variables declarations

CTI_RADAR="Radar";
SM_Radar_Range=5000;
SM_Radar_MinAlt=40;
SM_Radar_TimeOut=400;
SM_Radar_Log=false;
SM_Radar_Detected=[]; //kept as global to ensure that we have no double detections
SM_Arty_Detected=0;
SM_Radar_MarkerIterator=0;
SM_Radar_ArtyMarkerIterator=0;

		// ma

// Building declarations
//(had to modify the script Common\Config\Base\Set_Structures.sqf not do delete old structures)
/*_headers = [[CTI_RADAR, "Air Radar", "Air Radar"]];
_classes = [["Land_TTowerBig_1_F", "Land_TTowerBig_1_ruins_F"]];
_prices =  [8000];
_times =  [120];
_placements = [[180, 30]];
_specials = [[["DMG_Reduce", 1]]];

{
	[_x, _headers, _classes, _prices, _times, _placements, _specials] call compile preprocessFileLineNumbers "Common\Config\Base\Set_Structures.sqf";
} forEach [east,west];*/

//Main radar loop as Global so it can be called by PFV
// Only declared on clients (server dont give shit about radar)

if (CTI_IsClient) then {

	SM_ARTY_MARKERU={

		_marker = _this select 0;
		_base1 = _this select 1;
		_base2 = _this select 2;

		_xdif = (_base1 select 0) - (_base2 select 0);
		_ydif = (_base1 select 1) - (_base2 select 1);

		_xpos = (_base1 select 0) - _xdif / 2;
		_ypos = (_base1 select 1) - _ydif / 2;

		_pos	= [_xpos,_ypos,0];
		_dir	= atan ( _xdif / _ydif );
		_marker setMarkerPosLocal _pos;
		_marker setMarkerDirLocal _dir;
		_marker setMarkerSizeLocal [5, ((([ _base1 select 0, _base1 select 1]  distance [ _base2 select 0, _base2 select 1])) / 2) ];
	};

	SM_ARTY_TIMEOUT={
		waitUntil {time > (_this select 1)};
		deleteMarkerLocal (_this select 0);
		SM_Arty_Detected=SM_Arty_Detected-1;
	};


	SM_DETECT_ARTY={
				if !([CTI_P_SideJoined, CTI_UPGRADE_ARTR, 1] call CTI_CO_FNC_HasUpgrade) exitWith {False};



				diag_log _this;
				_seed=_this select 0;
				_pos1=_this select 1;
				_pos2=_this select 2;
				if (isNil {missionNamespace getVariable format ["SM_RAD_%1",_seed]}) then {
					_m=createMarkerLocal [format ["SM_RAD_M_%1",_seed],_pos1];
					missionNamespace setVariable [format ["SM_RAD_%1",_seed],_m];
					_m setMarkerShapeLocal "RECTANGLE";
					_m setMarkerBrushLocal "Solid";
					_m setMarkerColorLocal "ColorYellow";
					_m setMarkerAlphaLocal 1;
					[_m, (time+SM_Radar_TimeOut)] spawn SM_ARTY_TIMEOUT;
					SM_Arty_Detected=SM_Arty_Detected+1;
				};

				_marker = missionNamespace getVariable format ["SM_RAD_%1",_seed];
				[_marker, _pos1, _pos2] call SM_ARTY_MARKERU;
	};

	SM_RADAR_LOOP = {
		_radar=_this;
		if (SM_Radar_Log) then { diag_log format ["RADAR: Starting radar for %1",_radar]};

		_marker_range = createMarkerLocal [format ["SM_R_%1", _radar], getPos _radar];
		_marker_range setMarkerShapeLocal "ELLIPSE";
		_marker_range setMarkerBrushLocal "Border";
		_marker_range setMarkerSizeLocal [SM_Radar_Range,SM_Radar_Range];
		_marker_range setMarkerColorLocal "ColorBrown";
		_marker_range setMarkerAlphaLocal 1;
		[_radar, _marker_range] spawn {
			waitUntil {! (alive (_this select 0))};
			deleteMarkerLocal (_this select 1);
		};



		// Loop declared localy (did not want to use a public variable) for markers
		// only runned for opisite sides air vehicles

		_DETECT_MARKER ={
		   _radar=_this select 0;
			_obj= _this select 1;
			_color= _this select 2;
			_id=floor(random(10000));
			if (SM_Radar_Log) then {diag_log format ["RADAR: Radar %1 detected %2",_radar,_obj]};
			//CTI_P_ChatID commandChat format["ENEMY RADAR CONTACT at %1",(mapGridPosition _obj)];
			_marker = createMarkerLocal [format ["CTI_R_%1",  SM_Radar_MarkerIterator], (getPos _obj)];
			SM_Radar_MarkerIterator=SM_Radar_MarkerIterator+1;
			_marker setMarkerTypeLocal "mil_triangle";
			_marker setMarkerSizeLocal [0.7,0.7];
			_marker setMarkerColorLocal _color;
			_top_radar= (getPosATL _radar);
			 _top_radar set [2, (_top_radar select 2 )+35];
			//_marker setMarkerColorLocal ((side _obj) call CTI_CO_FNC_GetSideColoration);
			(group player) reveal [_obj, 2];
			_marker setMarkerAlphaLocal 0.7;
			_timeout=time+30;
			// if we are still detected by some radar
			While {! CTI_GameOver && alive _obj  && alive _radar && time < _timeout} do {


				_alt=(((getPosASLW _obj) select 2) min ((getPosATL _obj) select 2));
				// hide maker if below some altitude
				_marker setMarkerTextLocal format ["Unk%1 -- A:%2",_id, floor ( _alt)];
				if (  _alt > SM_Radar_MinAlt && !(terrainIntersect [_top_radar,(getPosATL _obj)]) ) then {
					if (markerAlpha _marker == 0) then { _marker setMarkerAlphaLocal 0.7 };
					_timeout=time+30;
				} else {
					if (markerAlpha _marker >0) then { _marker setMarkerAlphaLocal 0 };
				};
				//update
				_marker setMarkerPosLocal (getPos _obj);
				// find closest radar
				//_structures = (CTI_P_SideJoined) call CTI_CO_FNC_GetSideStructures;
				//_radar=[CTI_RADAR, _obj, _structures,SM_Radar_Range] call CTI_CO_FNC_GetClosestStructure;
				//sleeps
				sleep 1;
			};
			deleteMarkerLocal _marker;
			sleep random (1);
			SM_Radar_Detected=SM_Radar_Detected-[_obj];
			if (SM_Radar_Log) then {diag_log format ["RADAR: End detection for %1",_obj]};

		};
		waitUntil {([CTI_P_SideJoined, CTI_UPGRADE_AIRR, 1] call CTI_CO_FNC_HasUpgrade)};

		while {! CTI_GameOver && ! (isNull _radar)} do
		{
			_objects = _radar nearEntities ["Air", SM_Radar_Range];
			_objects=_objects - (_objects unitsBelowHeight SM_Radar_MinAlt);
			_r=[];
			{
				_s=getNumber(configFile >> "CfgVehicles" >> typeOf _x >> "side");

				_rs=switch (_s) do
					{
			  		case 0: { east };
			  		case 1: { west };
			  		case 2: { resistance };
			   		default {resistance};
			  	};

				if (_rs == CTI_P_SideJoined) then {_r=_r+[_x];};
				if (_x isKindOf "ParachuteBase") then {_r =_r+[_x];};
			} forEach _objects;
			_objects=_objects -	_r;
			_d=SM_Radar_Detected- [objNull];
			{
				_o=_x;
				if ( {_x == _o} count _d == 0) then {
					_s=getNumber(configFile >> "CfgVehicles" >> typeOf _x >> "side");
					_rs=switch (_s) do
					{
			  		case 0: { east };
			  		case 1: { west };
			  		case 2: { resistance };
			   		default {resistance};
			  	};
					_co=(_rs) call CTI_CO_FNC_GetSideColoration;
					_d = _d + [ _x];
					[_radar, _x,_co] spawn _DETECT_MARKER;

				};

			} forEach _objects;
			sleep random(0.5);
			SM_Radar_Detected = _d;
			/*
			_d = SM_Arty_Detected - [objNull];
			_ammos = (_radar nearObjects ["ShellBase",SM_Radar_Range/4]) + (_radar nearObjects ["SubmunitionBase ",SM_Radar_Range/4]);
			{
				_o=_x;
				if ( {_x == _o} count _d == 0) then {
					if (getNumber(configFile >> "CfgAmmo" >> (typeOf _x) >> "artillerylock")==1) then {
						if (count _d == 0) then {CTI_P_ChatID commandChat format["Incominig Artillery Rounds detected by radar at %1",(mapGridPosition _radar)];};
						_d = _d + [_x];
						[_radar,_x] spawn _DETECT_ARTY;
					};
				};
			} forEach _ammos;
			sleep random(0.5);
			SM_Arty_Detected = _d;*/

			sleep 5;
		};

	};
	with missionNamespace do {

		CTI_PVF_Client_SM_ARTI_RADAR={  (_this) call SM_DETECT_ARTY;};

		waitUntil {!(isNil "CTI_PVF_Client_OnStructureConstructed")};
		CTI_PVF_Client_OnStructureConstructed = nil;
		waitUntil {(isNil "CTI_PVF_Client_OnStructureConstructed")};
		CTI_PVF_Client_OnStructureConstructed = {
			_this spawn CTI_CL_FNC_OnStructureConstructed;
			_o= missionNamespace getVariable (_this select 1);
			if (((_o select 0) select 0) == CTI_RADAR ) then {
				(_this select 0) spawn SM_RADAR_LOOP;
			};
		};
	};
};

SM_Radar_init=true;