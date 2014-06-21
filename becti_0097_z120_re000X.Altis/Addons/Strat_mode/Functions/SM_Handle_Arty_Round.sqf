_unit = _this select 0;
_weapon= _this select 1;
_muzzle= _this select 2;
_mode= _this select 3;
_ammo= _this select 4;
_round = _this select 6;
//_round = nearestObject [_unit,_ammo];
{
	//diag_log "starting arty round loop";
	//diag_log _this;
	//diag_log _round;
	sleep 2;
	_side=_x;
	_structures = (_x) call CTI_CO_FNC_GetSideStructures;
	_radars = [CTI_RADAR, _structures] call CTI_CO_FNC_GetSideStructuresByType;
	{
		[_x,_ammo,_round,_side] spawn {

			_radar= _this select 0;
			_ammo= _this select 1;
			_round= _this select 2;
			_side= _this select 3;
			waitUntil {([(getPos _round) select 0,(getPos _round) select 1,0] distance _radar < SM_Radar_Range || !alive _radar || !alive _round )};
			if ( alive _radar && alive _round ) then{
				//diag_log "Detected by some radar";
				_init_pos=(getPos _round);
				_seed=random (100000000)+ diag_frameno;
				while {alive _round} do {
					//diag_log [_side,_seed,_init_pos,(getPos _round)];
					[["CLIENT",_side], "Client_SM_ARTI_RADAR",[_seed,_init_pos,(getPos _round)]] call CTI_CO_FNC_NetSend;
					sleep 1;
				};
			};
		};
	} forEach _radars;

} forEach [west,east];