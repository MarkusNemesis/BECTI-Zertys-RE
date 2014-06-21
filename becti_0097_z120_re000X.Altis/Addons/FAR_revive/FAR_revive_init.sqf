//
// Farooq's Revive 1.5
//

//------------------------------------------//
// Parameters - Feel free to edit these
//------------------------------------------//

// Seconds until unconscious unit bleeds out and dies. Set to 0 to disable.
FAR_BleedOut = 600;

// Enable teamkill notifications
FAR_EnableDeathMessages = false;

// If enabled, unconscious units will not be able to use ACRE radio, hear other people or use proximity chat
FAR_MuteACRE = false;

/*
	0 = Only medics can revive
	1 = All units can revive
	2 = Same as 1 but a medikit is required to revive
*/
if (isnil "FAR_ReviveMode") then {FAR_ReviveMode = 1};

0 spawn{
	disableSerialization;
	_main_disp = displayNull;
	while {!CTI_GameOver } do {
		_main_disp=findDisplay 49;
		if (! isNull _main_disp) then {
			_ntime=time +5; // 120

			while {time < _ntime && ! (isNull _main_disp) } do {
				(_main_disp displayctrl 1010) ctrlEnable false;
				(_main_disp displayctrl 1010)  ctrlSetText format ["Respawn (%1)", (ceil (_ntime-time))];
				sleep 0.1;
			};

			(_main_disp displayctrl 1010) ctrlEnable true;
			(_main_disp displayctrl 1010) ctrlSetText "Respawn";
			/*if(player getVariable "FAR_isUnconscious" == 1) then {
				(_main_disp displayctrl 1010) ctrlshow false;
			} else {
				(_main_disp displayctrl 1010) ctrlshow true;
			};*/
			waitUntil {isNull _main_disp};
		};
		sleep 0.1;
	};

};
//------------------------------------------//

call compile preprocessFile "Addons\FAR_revive\FAR_revive_funcs.sqf";

#define SCRIPT_VERSION "1.5"

FAR_isDragging = false;
FAR_isDragging_EH = [];
FAR_deathMessage = [];
FAR_Debugging = false;
FAR_Time_Unconscious = 0;
if (isDedicated) exitWith {};

////////////////////////////////////////////////
// Player Initialization
////////////////////////////////////////////////
[] spawn
{
    waitUntil { !isNull player };

	// Public event handlers
	"FAR_isDragging_EH" addPublicVariableEventHandler FAR_public_EH;
	"FAR_deathMessage" addPublicVariableEventHandler FAR_public_EH;

	[] spawn FAR_Player_Init;

	if (FAR_MuteACRE) then
	{
		[] spawn FAR_Mute_ACRE;

		hintSilent format["Farooq's Revive %1 is initialized.%2", SCRIPT_VERSION, "\n\n Note: Unconscious units will not be able to use radio, hear other people or use proximity chat"];
	}
	else
	{
		hintSilent format["Farooq's Revive %1 is initialized.", SCRIPT_VERSION];
	};

	// Event Handlers
	player addEventHandler
	[
		"Respawn",
		{
			[] spawn FAR_Player_Init;
		}
	];
};

FAR_Player_Init =
{
	// Cache player's side
	FAR_PlayerSide = side player;

	// Clear event handler before adding it
	player removeAllEventHandlers "HandleDamage";

	player addEventHandler ["HandleDamage", FAR_HandleDamage_EH];
	/*player addEventHandler
	[
		"Killed",
		{
			// Remove dead body of player (for missions with respawn enabled)
			_body = _this select 0;

			[_body] spawn
			{

				waitUntil { alive player };
				_body = _this select 0;
				deleteVehicle _body;
			}
		}
	];*/
	player enableSimulation true;
	player setDamage 0;
	player setVariable ["FAR_isUnconscious", 0, true];
	player setVariable ["FAR_isStabilized", 0, true];
	player setVariable ["FAR_isDragged", 0, true];
	player setVariable ["ace_sys_wounds_uncon", false];
	player setCaptive false;
	//player playMove "amovppnemstpsraswrfldnon";
	//player playMove "";

	FAR_isDragging = false;

	[] spawn FAR_Player_Actions;
};

// Drag & Carry animation fix
[] spawn
{
	while {true} do
	{
		if (animationState player == "acinpknlmstpsraswrfldnon_acinpercmrunsraswrfldnon" || animationState player == "helper_switchtocarryrfl" || animationState player == "AcinPknlMstpSrasWrflDnon") then
		{
			if (FAR_isDragging) then
			{
				player switchMove "AcinPknlMstpSrasWrflDnon";
			}
			else
			{
				player switchMove "amovpknlmstpsraswrfldnon";
			};
		};

		sleep 3;
	}
};

FAR_Mute_ACRE =
{
	waitUntil { time > 0 };

	waitUntil
	{
		if (alive player) then
		{
			// player getVariable ["ace_sys_wounds_uncon", true/false];
			if ((player getVariable["ace_sys_wounds_uncon", false])) then
			{
				private["_saveVolume"];

				_saveVolume = acre_sys_core_globalVolume;

				player setVariable ["acre_sys_core_isDisabled", true, true];

				waitUntil
				{
					acre_sys_core_globalVolume = 0;

					if (!(player getVariable["acre_sys_core_isDisabled", false])) then
					{
						player setVariable ["acre_sys_core_isDisabled", true, true];
						[true] call acre_api_fnc_setSpectator;
					};

					!(player getVariable["ace_sys_wounds_uncon", false]);
				};

				if ((player getVariable["acre_sys_core_isDisabled", false])) then
				{
					player setVariable ["acre_sys_core_isDisabled", false, true];
					[false] call acre_api_fnc_setSpectator;
				};

				acre_sys_core_globalVolume = _saveVolume;
			};
		}
		else
		{
			waitUntil { alive player };
		};

		sleep 0.25;

		false
	};
};

////////////////////////////////////////////////
// [Debugging] Add revive to playable AI units
////////////////////////////////////////////////
if (!FAR_Debugging || isMultiplayer) exitWith {};

{
	if (!isPlayer _x) then
	{
		_x addEventHandler ["HandleDamage", FAR_HandleDamage_EH];
		_x setVariable ["FAR_isUnconscious", 0, true];
		_x setVariable ["FAR_isStabilized", 0, true];
		_x setVariable ["FAR_isDragged", 0, true];
	};
} forEach switchableUnits;