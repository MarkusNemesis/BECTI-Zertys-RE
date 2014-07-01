/*
  # HEADER #
	Script: 		Common\Functions\Common_GetWeaponCostScaling.sqf
	Alias:			CTI_CO_FNC_GetWeaponCostScaling
	Description:	Caculate the weapon scaling costs.
	Author: 		Henroth
	Creation Date:	27-06-2014
	Revision Date:	27-06-2014
	
  # PARAMETERS #
    0	[Object]: The unit
	
  # RETURNED VALUE #
	[Array]: The weapon categories available on a vehicle
	
  # SYNTAX #
	(player vehicle) call CTI_CO_FNC_GetWeaponCostScaling
	
  # EXAMPLE #
    _scale =  _weapon_categories call CTI_CO_FNC_GetWeaponCostScaling
	  -> Return the sum of the weapon cost scalings
*/

_selected_weapons = _this;
_summedscale = 1.0;
{
	if ( _x in _selected_weapons ) then 
	{	
		_scale_to_add = missionNamespace getVariable format [ "CTI_WEAP_%1_COSTSCALE" , _x ];
		_summedscale = _summedscale + _scale_to_add;
	};
} forEach ( CTI_WEAP_ARRAY_LIST );
_summedscale