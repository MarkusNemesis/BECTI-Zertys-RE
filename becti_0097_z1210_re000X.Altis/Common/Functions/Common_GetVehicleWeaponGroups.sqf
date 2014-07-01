/*
  # HEADER #
	Script: 		Common\Functions\Common_GetVehicleWeaponGroups.sqf
	Alias:			CTI_CO_FNC_GetVehicleWeaponGroups
	Description:	Return a list of weapon groups available on this classname
	Author: 		Henroth
	Creation Date:	27-06-2014
	Revision Date:	27-06-2014
	
  # PARAMETERS #
    0	[String]: A classname of a vehicle
	
  # RETURNED VALUE #
		[Array]: List of weapon categories available on the vehicle
	
  # SYNTAX #
	_classname call CTI_CO_FNC_GetVehicleWeaponGroups
	
  # EXAMPLE #
    _weapon_groups = _classname call CTI_CO_FNC_GetVehicleWeaponGroups;
*/

private [ "_returned" , "_classname", "_all_vehicle_weapons", "_vehicle_turrets"];

_returned = [];

_classname = _this;

// Grab all weapons off vehicle type
_all_vehicle_weapons = [];
{
	_all_vehicle_weapons = _all_vehicle_weapons + [_x];
} forEach getArray ( configFile >> "CfgVehicles" >> _classname >> "weapons" );


_vehicle_turrets = configFile >> "CfgVehicles" >> _classname >> "turrets";

// Append all weapons from turrets
for '_i' from 0 to ( ( count _vehicle_turrets )-1) do 
{
	_turret_selected = _vehicle_turrets select _i;
	{
		_all_vehicle_weapons = _all_vehicle_weapons + [ _x ];
	} forEach getArray ( _turret_selected >> "weapons" );
};

{
	_weapon_category = _x;
	_a_magazine_list = missionNamespace getVariable format [ "CTI_%1_BASED_MAGAZINES" , _weapon_category ];
	{
		_a_weapon = _x;
		{
			_a_magazine = _x;
			if ( _a_magazine in _a_magazine_list ) then
			{
				_returned = _returned + [ _weapon_category ];
			};
		} forEach getArray(configFile >> "CfgWeapons" >> _a_weapon >> "magazines" );
	} forEach _all_vehicle_weapons;
} forEach ( CTI_WEAP_ARRAY_LIST );

_returned