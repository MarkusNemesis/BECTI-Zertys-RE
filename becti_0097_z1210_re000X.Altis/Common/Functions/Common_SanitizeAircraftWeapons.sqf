/*
  # HEADER #
	Script: 		Common\Functions\Common_SanitizeAircraftWeapons.sqf
	Alias:			CTI_CO_FNC_SanitizeAircraftWeapons
	Description:	Sanitize the weapons of an aircraft basead on the chosen loadout
	Author: 		Henroth
	Creation Date:	25/06/2015 (Henroth)
	Revision Date:	25/06/2015 (Henroth) - Initial code
					
  # PARAMETERS #
    0	[Object]: The vehicle

  # RETURNED VALUE #
	None

  # SYNTAX #
	(VEHICLE) call CTI_CO_FNC_SanitizeAircraftWeapons

  # EXAMPLE #
    (vehicle player) call CTI_CO_FNC_SanitizeAircraftAA;
	  -> Sanitize the player's vehicles weapons
*/

private ["_magazines","_vehicle","_weapons","_loadout","_weapons_remove","_magazines_remove","_type_category","_magazine_list","_a_weapon"];

_vehicle = _this;
_type = typeOf _vehicle;
_loadout = _vehicle getVariable "cti_custom_weapon_loadout";
_weapons = weapons _vehicle;
_magazines = magazines _vehicle;

// forEach ( CTI_WEAP_ARRAY_LIST ); - Loop through each weapon categories
{
	_type_category = _x;
	// If weapon category is not part of vehicle loadout plan
	if ( ! ( _type_category in _loadout ) ) then
	{
		
		// Extract all the known magazines for that weapon category
		_magazine_list = missionNamespace getVariable format [ "CTI_%1_BASED_MAGAZINES" , _type_category ];
		_weapons_remove = [];
		_magazines_remove= [];
		
		// Loop through each weapon on the vehicle, find the magazine and try to
		// match the know list of magzines.
		{
			_a_weapon = _x;
			{
				// If matches, mark magazine + weapons for removal
				if ( _x in _magazine_list ) then
				{
					_magazines_remove = _magazines_remove + [_x];
					_weapons_remove = _weapons_remove + [ _a_weapon ];
				};
			} forEach getArray(configFile >> "CfgWeapons" >> _x >> "magazines" );
		} forEach _weapons;
		
		/* 
		 For planes, there are graphical glitches when removing magazines
		 experimentation revealed that setting the ammo to 0 for the weapon type
		 produced the best results
		 */
		{
			if ( ! ( _vehicle isKindof "Plane" ) ) then
			{
				if ( _x in _magazines_remove ) then 
				{
					_vehicle removeMagazine _x;
				};
			};
		} forEach ( _magazines );
		
		{
			_vehicle addWeaponGlobal _x;
			_vehicle setAmmo [_x, 0]; // For the benefit of planes
			_vehicle removeWeaponGlobal _x;
		} forEach ( _weapons_remove );
		
	};
} forEach ( CTI_WEAP_ARRAY_LIST );