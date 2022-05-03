#include <karyuu>
#include <sdkhooks>
#include <sdktools>

ConVar gH_Cvar_Karyuu_Blocks_Enabled,	  // Enable or disable Blocks Module (0 - Disable, 1 - Enabled)
	gH_Cvar_Karyuu_Blocks_Friendlyfire,	  // Enable or disable block friendlyfire announce (0 - Original, 1 - Custom, 2 - Block both)
	gH_Cvar_Karyuu_Blocks_TeamChange,	  // Enable or disable block teamchange announce (0 - Original, 1 - Custom, 2 - Block both)
	gH_Cvar_Karyuu_Blocks_Connect,		  // Enable or disable block connect announce (0 - Original, 1 - Custom, 2 - Block both)
	gH_Cvar_Karyuu_Blocks_Disconnect,	  // Enable or disable block disconnect announce (0 - Original, 1 - Custom, 2 - Block both)
	gH_Cvar_Karyuu_Blocks_Cash,			  // Enable or disable block cvarchange announce (0 - Enable, 1 - Disable)
	gH_Cvar_Karyuu_Blocks_Radio,			  // Enable or disable block cvarchange announce (0 - Enable, 1 - Disable)
	gH_Cvar_Karyuu_Blocks_SavedPlayer;	  // Enable or disable block cvarchange announce (0 - Enable, 1 - Disable)
public Plugin myinfo =
{
	name			= "| CS:GO | GameText blocker",
	author		= "KitsuneLab ~ Karyuu & Hamiae",
	description = "Block unwanted game text",
	version		= "1.0",
	url			= "https://www.kitsune-lab.dev"
};

public void OnPluginStart()
{
	gH_Cvar_Karyuu_Blocks_Enabled		  = CreateConVar("sm_blocks_enabled", "1", "Enable or disable every block", 0, true, 0.0, true, 1.0);

	gH_Cvar_Karyuu_Blocks_Friendlyfire = CreateConVar("sm_blocks_friendlyfire", "1", "Enable or disable block of friendlyfire chat announce block  (0 - Disable, 1 - Enable)", 0, true, 0.0, true, 1.0);
	gH_Cvar_Karyuu_Blocks_SavedPlayer  = CreateConVar("sm_blocks_savedplayer", "1", "Enable or disable block of saved player chat announce block  (0 - Disable, 1 - Enable)", 0, true, 0.0, true, 1.0);
	gH_Cvar_Karyuu_Blocks_Cash			  = CreateConVar("sm_blocks_cashandpoint", "1", "Enable or disable block of cash and point chat announce (0 - Disable, 1 - Enable)", 0, true, 0.0, true, 1.0);
	gH_Cvar_Karyuu_Blocks_Radio		  = CreateConVar("sm_blocks_radio", "1", "Enable or disable block of radio chat announce  (0 - Disable, 1 - Enable))", 0, true, 0.0, true, 1.0);
	gH_Cvar_Karyuu_Blocks_TeamChange	  = CreateConVar("sm_blocks_teamchange", "1", "Enable or disable block of teamchange chat announce (0 - Disable, 1 - Enable)", 0, true, 0.0, true, 1.0);
	gH_Cvar_Karyuu_Blocks_Connect		  = CreateConVar("sm_blocks_connect", "1", "Enable or disable block of connect chat announce (0 - Disable, 1 - Enable)", 0, true, 0.0, true, 1.0);
	gH_Cvar_Karyuu_Blocks_Disconnect	  = CreateConVar("sm_blocks_disconnect", "1", "Enable or disable block of disconnect chat announce (0 - Disable, 1 - Enable)", 0, true, 0.0, true, 1.0);

	AutoExecConfig(true, "gametext_blocker", "sourcemod");

	HookUserMessage(GetUserMessageId("SayText2"), BlockText, true);
	HookUserMessage(GetUserMessageId("TextMsg"), BlockMsg, true);
	HookUserMessage(GetUserMessageId("RadioText"), BlockRadio, true);

	HookEvent("player_connect", Event_PlayerConnect, EventHookMode_Pre);
	HookEvent("player_disconnect", Event_PlayerDisconnect, EventHookMode_Pre);
	HookEvent("player_team", Event_PlayerTeam, EventHookMode_Pre);
}

public Action BlockRadio(UserMsg msg_id, Protobuf msg, const int[] players, int playersNum, bool reliable, bool init)
{
	return gH_Cvar_Karyuu_Blocks_Enabled.BoolValue && gH_Cvar_Karyuu_Blocks_Radio.BoolValue ? Plugin_Handled : Plugin_Continue;
}

public Action BlockText(UserMsg msg_id, BfRead bf, const int[] players, int playersNum, bool reliable, bool init)
{
	if (!gH_Cvar_Karyuu_Blocks_Enabled.BoolValue)
		return Plugin_Continue;

	if (!reliable)
		return Plugin_Continue;

	char sBuffer[25];
	if (GetUserMessageType() == UM_Protobuf)
	{
		PbReadString(bf, "msg_name", STRING(sBuffer));

		if (strcmp(sBuffer, "#Cstrike_TitlesTXT_Killed_Teammate") == 0 && gH_Cvar_Karyuu_Blocks_Friendlyfire.BoolValue)
			return Plugin_Handled;
	}
	else
	{
		BfReadChar(bf);
		BfReadChar(bf);
		BfReadString(bf, STRING(sBuffer));

		if (strcmp(sBuffer, "#Cstrike_TitlesTXT_Killed_Teammate") == 0 && gH_Cvar_Karyuu_Blocks_Friendlyfire.BoolValue)
			return Plugin_Handled;
	}
	return Plugin_Continue;
}

public Action BlockMsg(UserMsg msg_id, BfRead msg, const int[] players, int playersNum, bool reliable, bool init)
{
	if (!gH_Cvar_Karyuu_Blocks_Enabled.BoolValue)
		return Plugin_Continue;

	char sBuffer[64];
	PbReadString(msg, "params", STRING(sBuffer), 0);

	if (gH_Cvar_Karyuu_Blocks_Cash.BoolValue)
	{
		if (strcmp(sBuffer, "#Player_Cash_Award_Killed_Enemy") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Team_Cash_Award_Win_Hostages_Rescue") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Team_Cash_Award_Win_Defuse_Bomb") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Team_Cash_Award_Win_Time") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Team_Cash_Award_Elim_Bomb") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Team_Cash_Award_Elim_Hostage") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Team_Cash_Award_T_Win_Bomb") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Player_Point_Award_Assist_Enemy_Plural") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Player_Point_Award_Assist_Enemy") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Player_Point_Award_Killed_Enemy_Plural") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Player_Point_Award_Killed_Enemy") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Player_Cash_Award_Kill_Hostage") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Player_Cash_Award_Damage_Hostage") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Player_Cash_Award_Get_Killed") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Player_Cash_Award_Respawn") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Player_Cash_Award_Interact_Hostage") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Player_Cash_Award_Killed_Enemy") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Player_Cash_Award_Rescued_Hostage") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Player_Cash_Award_Bomb_Defused") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Player_Cash_Award_Bomb_Planted") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Player_Cash_Award_Killed_Enemy_Generic") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Player_Cash_Award_Killed_VIP") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Player_Cash_Award_Kill_Teammate") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Team_Cash_Award_Win_Hostage_Rescue") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Team_Cash_Award_Loser_Bonus") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Team_Cash_Award_Loser_Zero") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Team_Cash_Award_Rescued_Hostage") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Team_Cash_Award_Hostage_Interaction") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Team_Cash_Award_Hostage_Alive") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Team_Cash_Award_Planted_Bomb_But_Defused") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Team_Cash_Award_CT_VIP_Escaped") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Team_Cash_Award_T_VIP_Killed") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Team_Cash_Award_no_income") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Team_Cash_Award_Generic") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Team_Cash_Award_Custom") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Team_Cash_Award_no_income_suicide") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Player_Cash_Award_ExplainSuicide_YouGotCash") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Player_Cash_Award_ExplainSuicide_TeammateGotCash") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Player_Cash_Award_ExplainSuicide_EnemyGotCash") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Player_Cash_Award_ExplainSuicide_Spectators") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Player_Team_Award_Killed_Enemy") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Player_Team_Award_Killed_Enemy_Plural") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Player_Team_Award_Bonus_Weapon") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Player_Team_Award_Bonus_Weapon_Plural") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Player_Team_Award_Bonus_Weapon_Plural") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Team_Cash_Award_Survive_GuardianMode_Wave") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Player_Point_Award_Killed_Enemy_NoWeapon") == 0)
			return Plugin_Handled;
		if (strcmp(sBuffer, "#Player_Point_Award_Killed_Enemy_NoWeapon_Plural") == 0)
			return Plugin_Handled;
	}

	if ((StrContains(sBuffer, "teammate") != -1) && gH_Cvar_Karyuu_Blocks_Friendlyfire.BoolValue)
		return Plugin_Handled;

	if (gH_Cvar_Karyuu_Blocks_SavedPlayer.BoolValue)
	{
		if (StrContains(sBuffer, "#Chat_SavePlayer_", false) != -1)
			return Plugin_Handled;
	}
	return Plugin_Continue;
}

public Action Event_PlayerConnect(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	if (gH_Cvar_Karyuu_Blocks_Enabled.BoolValue && Karyuu_IsValidClient(client))
	{
		if (gH_Cvar_Karyuu_Blocks_Connect.BoolValue)
		{
			event.BroadcastDisabled = true;
			dontBroadcast				= true;
			return Plugin_Changed;
		}
	}

	return Plugin_Continue;
}

public Action Event_PlayerDisconnect(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	if (gH_Cvar_Karyuu_Blocks_Enabled.BoolValue && Karyuu_IsValidClient(client))
	{
		if (gH_Cvar_Karyuu_Blocks_Disconnect.BoolValue)
		{
			event.BroadcastDisabled = true;
			dontBroadcast				= true;
			return Plugin_Changed;
		}
	}
	return Plugin_Continue;
}

public Action Event_PlayerTeam(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	if (Karyuu_IsValidClient(client))
	{
		if (!event.GetBool("disconnect"))
		{
			if (gH_Cvar_Karyuu_Blocks_TeamChange.BoolValue)
			{
				event.BroadcastDisabled = true;
				dontBroadcast				= true;
				return Plugin_Changed;
			}
		}
	}
	return Plugin_Continue;
}