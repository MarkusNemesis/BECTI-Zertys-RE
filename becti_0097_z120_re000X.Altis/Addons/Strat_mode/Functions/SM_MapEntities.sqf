waitUntil {! isNil {player getVariable "CTI_Net"}};
_side = CTI_P_SideJoined;
_side_id= _side call CTI_CO_FNC_GetSideID;
//_side_id=player getVariable "CTI_Net";
_return=[];
_lines=[];
_group=[];
_cache= SHOWTOMAP;

waitUntil {! isNil {player getVariable "AN_iNet" }};
_ug=units player;
if ( (vehicle player) getVariable "AN_iNet" == _side_id) then {_ug=_ug-[player];};
// player group
{

	_object = _x;
	_texture= format ["a3\ui_f\data\map\Markers\NATO\%1inf",CTI_P_MarkerPrefix];
	_color = [1,1,0,1];
	if (! alive _object) then {_color = [0,0,0,1];};
	_pos = getPosASL _x;
	_size = [18, 18];
	_text = (_object) call CTI_CL_FNC_GetAIDigit;
	if (isPlayer _object) then {_text =  format ["[%1]%2",(group _object) getVariable ["cti_alias",CTI_PLAYER_DEFAULT_ALIAS], name _object] };
	_group set [count _group,[_object,_texture, _color, _pos,_size select 0,_size select 1, 0, _text, 0, 0.05,'TahomaB', 'right']];

} count _ug;



	if ! ( (vehicle player) getVariable "AN_iNet" == _side_id) exitWith {[_group,[],[]]};



// switchableUnits
{
	{	_object = _x;
		_side_id=-1;
		if (!isNil {_object getVariable "CTI_Net"}) then {_side_id=_object getVariable "CTI_Net";};
		if (!isNil {_object getVariable "AN_iNet"}) then {_side_id=_object getVariable "AN_iNet";};
		_side= (_side_id)  call CTI_CO_FNC_GetSideFromID;
		if (_side == CTI_P_SideJoined && vehicle _x == _x) then {
			_p_icon= switch (_side) do
			{
		    case 	west:{ "b_" };
		    case 	east:{ "o_" };
		    case 	resistance:{ "n_" };
		    default { "n_"  };
		  };
			_texture= format ["a3\ui_f\data\map\Markers\NATO\%1inf",_p_icon];
			_color = switch (_side) do
				{
			    case 	west:{ [0,0,1,1] };
			    case 	east:{ [1,0,0,1] };
			    case 	resistance:{ [0,1,0,1] };
			    default { [1,1,1,1]  };
				};
			if (! alive _object) then {_color = [0,0,0,1];};
			_unc = 0;
			if (! isNil {_object getvariable "FAR_isUnconscious"} ) then {_unc =_object getvariable "FAR_isUnconscious";};
			if (_unc == 1) then {_color = [0.5,0.32,0.09,1]};
			_pos =getPosASL _x;
			_size = [18, 18];
			_text="";
			if (isplayer _object && _object isKindOf "Man") then { _text =  format ["[%1]%2",(group _object) getVariable ["cti_alias",CTI_PLAYER_DEFAULT_ALIAS], name _object]};
			_return set [count _return,[_object,_texture, _color, _pos,_size select 0,_size select 1, 0, _text, 0, 0.05,'TahomaB', 'right']];
			if (!isNil {_object getVariable "AN_Conn"}) then {
				if (_object call AN_Check_Connection && ! isNull(_object getVariable "AN_Conn") ) then {
					_lines set [count _lines , [_object,visiblePosition _object, visiblePosition (_object getVariable "AN_Conn"),[1,1,0,1]]];
				};
			};
		};TRUE} count units _x;TRUE
}count ((_side call CTI_CO_FNC_GetSideGroups));

//towns

{
	_side_id=-1;
	if (!isNil {_x getVariable "AN_iNet"}) then {_side_id=_x getVariable "AN_iNet";};
	_side= (_side_id)  call CTI_CO_FNC_GetSideFromID;
	_color = switch (_side) do
	{
    case 	west:{ [0,0,1,1] };
    case 	east:{ [1,0,0,1] };
    case 	resistance:{ [0,1,0,1] };
    default { [1,1,1,1]  };
	};
	if ( ! isNull(_x getVariable "AN_Conn") && _side == CTI_P_SideJoined && !(_x isKindOf "Man")) then {
		_lines set [count _lines , [_x,visiblePosition _x, visiblePosition (_x getVariable "AN_Conn"),_color]];
	};
} count CTI_Towns;


// Team Vehicles

{
	_object = _x;
	if !(isNil {_object getVariable "CTI_Net" }) then {
		_side_id =	_object getVariable "CTI_Net" ;
		if (!isNil {_object getVariable "AN_iNet"}) then {_side_id=_object getVariable "AN_iNet";};
		_side= (_side_id)  call CTI_CO_FNC_GetSideFromID;
		if (_side == CTI_P_SideJoined) then {
			_p_icon= switch (_side) do
				{
			    case 	west:{ "b_" };
			    case 	east:{ "o_" };
			    case 	resistance:{ "n_" };
			    default { "n_"  };
			  };
			_s_icon=0 call {
	  		if (_x isKindOf "Man") exitWith { "inf" };
				if ((_x isKindOf "Car" || _x isKindOf "Motorcycle") && !(_x isKindOf "Wheeled_APC_F")) exitWith { "motor_inf" };
				if  (_x isKindOf "Wheeled_APC_F")exitWith { "mech_inf" };
				if  (_x isKindOf "Ship")exitWith { "naval" };
				if  (_x isKindOf "Tank")exitWith { "armor" };
				if  (_x isKindOf "Helicopter")exitWith { "air" };
				if  (_x isKindOf "Plane")exitWith { "plane" };
				"inf"
			};
			_special = _object getVariable "cti_spec";
			if (isNil '_special') then { _special = [] };
			if (CTI_SPECIAL_REPAIRTRUCK in _special) then {_s_icon="maint"};
			if (CTI_SPECIAL_AMMOTRUCK in _special) then {_s_icon="support"};
			if (CTI_SPECIAL_MEDICALVEHICLE in _special) then {_s_icon="med"};
			_texture= format ["a3\ui_f\data\map\Markers\NATO\%1%2",_p_icon,_s_icon];
			_color = switch (_side) do
			{
		    case 	west:{ [0,0,1,1] };
		    case 	east:{ [1,0,0,1] };
		    case 	resistance:{ [0,1,0,1] };
		    default { [1,1,1,1]  };
			};
			if (! alive _object) then {_color = [0,0,0,1];};
			_pos = getPosASL _x;
			_size = [25, 25];
			if (_object isKindOf "Man") then {_size = [18, 18];};
			_text="";
			if !(_object isKindOf "Man") then {
				{if (isplayer _x) then {_text=_text+" "+format ["[%1]%2",(group _x) getVariable ["cti_alias",CTI_PLAYER_DEFAULT_ALIAS], name _x];} }count crew _x;
			};

			_return set [count _return,[_object,_texture, _color, _pos,_size select 0,_size select 1, 0, _text, 0, 0.05,'TahomaB', 'right']];
			if (!isNil {_object getVariable "AN_Conn"} && !(_object isKindOf "Man")) then {
				if (! isNull(_object getVariable "AN_Conn")) then {
					_lines set [count _lines , [_object,visiblePosition _object, visiblePosition (_object getVariable "AN_Conn"),_color]];
				};
			};
		};
	};

}count (vehicles );

//[texture, color, position, width, height, angle, text, shadow, textSize, font, align]

[_group,_return,_lines]