private ["_bounty", "_created_units", "_created_vehicles", "_crew", "_crews", "_group", "_locked", "_net", "_position", "_side", "_sideID", "_unit", "_units", "_vehicle", "_vehicle_crew"];

_units = _this select 0;
_position = _this select 1;
_side = _this select 2;
_group = _this select 3;
_locked = if (count _this > 4) then {_this select 4} else {true};
_net = if (count _this > 5) then {_this select 5} else {false};
_bounty = if (count _this > 6) then {_this select 6} else {false};

if (_side == resistance) then {_net=false};

_sideID = (_side) call CTI_CO_FNC_GetSideID;
//if (isNull _group) then {_group = createGroup _side};


_created_units = [];
_created_vehicles = [];
_crews = [];

{
	if (_x isKindOf "Man") then {
		_unit = [_x, _group, [_position, 2, 15] call CTI_CO_FNC_GetRandomPosition, _sideID] call CTI_CO_FNC_CreateUnit;
		[_created_units, _unit] call CTI_CO_FNC_ArrayPush;
	} else {
		_crew = switch (true) do {
			case (_x isKindOf "Tank"): { missionNamespace getVariable format["%1_SOLDIER_CREW", _side] };
			case (_x isKindOf "Air"): { missionNamespace getVariable format["%1_SOLDIER_PILOT", _side] };
			default { missionNamespace getVariable format["%1_SOLDIER", _side] };
		};
		if (typeName _crew == "ARRAY") then {_crew = _crew select 0};
		//_vehicle = [_x, [_position, 2, 15] call CTI_CO_FNC_GetRandomPosition, random 360, _sideID, _locked, _net, _bounty] call CTI_CO_FNC_CreateVehicle;
		_vehicle = [_x, [_position, 150] call CTI_CO_FNC_GetEmptyPosition, random 360, _sideID, _locked, _net, _bounty] call CTI_CO_FNC_CreateVehicle;
		_vehicle setPos ([_vehicle, 150] call CTI_CO_FNC_GetEmptyPosition);
		[_created_vehicles, _vehicle] call CTI_CO_FNC_ArrayPush;
		_vehicle_crew = [_vehicle, _crew, _group, _sideID] call CTI_CO_FNC_ManVehicle;
		_crews = _crews + _vehicle_crew;
	};
	// Markus - AI Skill redux
	_AISkill = missionNamespace getVariable "CTI_AI_SKILL";
	_skill = _AISkill/10;
	if (vehicle _x != _x) then { // Markus - Unit is in vehicle
		_x setSkill ["aimingAccuracy",0.5];
		_x setSkill ["aimingShake",0.5];
		_x setSkill ["aimingSpeed",0.5];
	} else {
		_x setSkill ["aimingAccuracy",_skill];
		_x setSkill ["aimingShake",_skill];
		_x setSkill ["aimingSpeed",_skill];
	};
	_x setSkill ["spotDistance",100];
	_x setSkill ["spotTime",100];
	_x setSkill ["courage",100];
	_x setSkill ["commanding",100];
	_x setSkill ["endurance",100];
	/// - Markus
} forEach _units;

{_group addVehicle _x} forEach _created_vehicles;

[_created_units, _created_vehicles, _crews, _group]