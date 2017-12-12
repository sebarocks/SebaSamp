//----------------------------------------------------------
//
//  GRAND LARCENY  1.0
//  A freeroam gamemode for SA-MP 0.3
//
//----------------------------------------------------------

#include <a_samp>
#include <core>
#include <float>
#include <zcmd>
#include <sscanf2>
#include <streamer>
#include "../include/gl_common.inc"
#include "../include/gl_spawns.inc"

#pragma tabsize 0

//----------------------------------------------------------

#define COLOR_WHITE 		0xFFFFFFFF
#define COLOR_NORMAL_PLAYER 0xFFBB7777
#define COLOR_ERROR         0xFF0000AA
#define COLOR_SUCCESS       0x0000FFFF
#define COLOR_INFO          0x00FF00FF

#define CITY_LOS_SANTOS 	0
#define CITY_SAN_FIERRO 	1
#define CITY_LAS_VENTURAS 	2

new total_vehicles_from_files=0;

// Class selection globals
new gPlayerCitySelection[MAX_PLAYERS];
new gPlayerHasCitySelected[MAX_PLAYERS];
new gPlayerLastCitySelectionTick[MAX_PLAYERS];

new Text:txtClassSelHelper;
new Text:txtLosSantos;
new Text:txtSanFierro;
new Text:txtLasVenturas;

//new thisanimid=0;
//new lastanimid=0;

//----------------------------------------------------------

main()
{
	print("\n---------------------------------------");
	print("Running Grand Larceny fork - by the SA-MP team and Seba\n");
	print("---------------------------------------\n");
}

//----------------------------------------------------------

public OnPlayerConnect(playerid)
{
	GameTextForPlayer(playerid,"~w~NarcoCitt",3000,4);
  	SendClientMessage(playerid,COLOR_WHITE,"Welcome to {88AA88}N{FFFFFF}arco {88AA88}C{FFFFFF}itt");
	showComandos(playerid);
  	
  	// class selection init vars
  	gPlayerCitySelection[playerid] = -1;
	gPlayerHasCitySelected[playerid] = 0;
	gPlayerLastCitySelectionTick[playerid] = GetTickCount();

 	return 1;
}

//----------------------------------------------------------

public OnPlayerSpawn(playerid)
{
	if(IsPlayerNPC(playerid)) return 1;
	
	new randSpawn = 0;
	
	SetPlayerInterior(playerid,0);
	TogglePlayerClock(playerid,0);
 	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, 10000);

	if(CITY_LOS_SANTOS == gPlayerCitySelection[playerid]) {
 	    randSpawn = random(sizeof(gRandomSpawns_LosSantos));
 	    SetPlayerPos(playerid,
		 gRandomSpawns_LosSantos[randSpawn][0],
		 gRandomSpawns_LosSantos[randSpawn][1],
		 gRandomSpawns_LosSantos[randSpawn][2]);
		SetPlayerFacingAngle(playerid,gRandomSpawns_LosSantos[randSpawn][3]);
	}
	else if(CITY_SAN_FIERRO == gPlayerCitySelection[playerid]) {
 	    randSpawn = random(sizeof(gRandomSpawns_SanFierro));
 	    SetPlayerPos(playerid,
		 gRandomSpawns_SanFierro[randSpawn][0],
		 gRandomSpawns_SanFierro[randSpawn][1],
		 gRandomSpawns_SanFierro[randSpawn][2]);
		SetPlayerFacingAngle(playerid,gRandomSpawns_SanFierro[randSpawn][3]);
	}
	else if(CITY_LAS_VENTURAS == gPlayerCitySelection[playerid]) {
 	    randSpawn = random(sizeof(gRandomSpawns_LasVenturas));
 	    SetPlayerPos(playerid,
		 gRandomSpawns_LasVenturas[randSpawn][0],
		 gRandomSpawns_LasVenturas[randSpawn][1],
		 gRandomSpawns_LasVenturas[randSpawn][2]);
		SetPlayerFacingAngle(playerid,gRandomSpawns_LasVenturas[randSpawn][3]);
	}
    
    //GivePlayerWeapon(playerid,WEAPON_COLT45,12);
    GivePlayerWeapon(playerid,4,1);
	//GivePlayerWeapon(playerid,WEAPON_MP5,100);
	TogglePlayerClock(playerid, 0);
	
	SendClientMessage(playerid, COLOR_SUCCESS, "Comandos:");
	SendClientMessage(playerid, COLOR_INFO , "/lambo /autito /armas /fix /moto /motox /jason /offroad");
	SendClientMessage(playerid, COLOR_INFO , "/jetpack /suspension /nitro /rims /katana /chela /rims /tps");
	
	return 1;
}

//----------------------------------------------------------

public OnPlayerDeath(playerid, killerid, reason)
{
    
    // if they ever return to class selection make them city
	// select again first
	gPlayerHasCitySelected[playerid] = 0;
	
	// transfiere la luca
	if(killerid != INVALID_PLAYER_ID) {
		new playercash;
		playercash = GetPlayerMoney(playerid);
		if(playercash >= 1000)  {			
			GivePlayerMoney(playerid, -1000);
		}
		GivePlayerMoney(killerid, 1000);
	}
		
	//mensaje de muerte
	
	new asesino[MAX_PLAYER_NAME];
	new victima[MAX_PLAYER_NAME];
	new string[80];
	
	GetPlayerName(playerid,asesino, sizeof asesino);
	GetPlayerName(playerid,victima, sizeof victima);
	
	format(string,128,"%s ha asesinado a %s.",asesino,victima);
	SendClientMessageToAll(COLOR_INFO, string);
	
	return 1;
}

//----------------------------------------------------------

ClassSel_SetupCharSelection(playerid)
{
   	if(gPlayerCitySelection[playerid] == CITY_LOS_SANTOS) {
		SetPlayerInterior(playerid,11);
		SetPlayerPos(playerid,508.7362,-87.4335,998.9609);
		SetPlayerFacingAngle(playerid,0.0);
    	SetPlayerCameraPos(playerid,508.7362,-83.4335,998.9609);
		SetPlayerCameraLookAt(playerid,508.7362,-87.4335,998.9609);
	}
	else if(gPlayerCitySelection[playerid] == CITY_SAN_FIERRO) {
		SetPlayerInterior(playerid,3);
		SetPlayerPos(playerid,-2673.8381,1399.7424,918.3516);
		SetPlayerFacingAngle(playerid,181.0);
    	SetPlayerCameraPos(playerid,-2673.2776,1394.3859,918.3516);
		SetPlayerCameraLookAt(playerid,-2673.8381,1399.7424,918.3516);
	}
	else if(gPlayerCitySelection[playerid] == CITY_LAS_VENTURAS) {
		SetPlayerInterior(playerid,3);
		SetPlayerPos(playerid,349.0453,193.2271,1014.1797);
		SetPlayerFacingAngle(playerid,286.25);
    	SetPlayerCameraPos(playerid,352.9164,194.5702,1014.1875);
		SetPlayerCameraLookAt(playerid,349.0453,193.2271,1014.1797);
	}
	
}

//----------------------------------------------------------
// Used to init textdraws of city names

ClassSel_InitCityNameText(Text:txtInit)
{
  	TextDrawUseBox(txtInit, 0);
	TextDrawLetterSize(txtInit,1.25,3.0);
	TextDrawFont(txtInit, 0);
	TextDrawSetShadow(txtInit,0);
    TextDrawSetOutline(txtInit,1);
    TextDrawColor(txtInit,0xEEEEEEFF);
    TextDrawBackgroundColor(txtClassSelHelper,0x000000FF);
}

//----------------------------------------------------------

ClassSel_InitTextDraws()
{
    // Init our observer helper text display
	txtLosSantos = TextDrawCreate(10.0, 380.0, "Los Santos");
	ClassSel_InitCityNameText(txtLosSantos);
	txtSanFierro = TextDrawCreate(10.0, 380.0, "San Fierro");
	ClassSel_InitCityNameText(txtSanFierro);
	txtLasVenturas = TextDrawCreate(10.0, 380.0, "Las Venturas");
	ClassSel_InitCityNameText(txtLasVenturas);

    // Init our observer helper text display
	txtClassSelHelper = TextDrawCreate(10.0, 415.0,
	   " Press ~b~~k~~GO_LEFT~ ~w~or ~b~~k~~GO_RIGHT~ ~w~to switch cities.~n~ Press ~r~~k~~PED_FIREWEAPON~ ~w~to select.");
	TextDrawUseBox(txtClassSelHelper, 1);
	TextDrawBoxColor(txtClassSelHelper,0x222222BB);
	TextDrawLetterSize(txtClassSelHelper,0.3,1.0);
	TextDrawTextSize(txtClassSelHelper,400.0,40.0);
	TextDrawFont(txtClassSelHelper, 2);
	TextDrawSetShadow(txtClassSelHelper,0);
    TextDrawSetOutline(txtClassSelHelper,1);
    TextDrawBackgroundColor(txtClassSelHelper,0x000000FF);
    TextDrawColor(txtClassSelHelper,0xFFFFFFFF);
}

//----------------------------------------------------------

ClassSel_SetupSelectedCity(playerid)
{
	if(gPlayerCitySelection[playerid] == -1) {
		gPlayerCitySelection[playerid] = CITY_LOS_SANTOS;
	}
	
	if(gPlayerCitySelection[playerid] == CITY_LOS_SANTOS) {
		SetPlayerInterior(playerid,0);
   		SetPlayerCameraPos(playerid,1630.6136,-2286.0298,110.0);
		SetPlayerCameraLookAt(playerid,1887.6034,-1682.1442,47.6167);
		
		TextDrawShowForPlayer(playerid,txtLosSantos);
		TextDrawHideForPlayer(playerid,txtSanFierro);
		TextDrawHideForPlayer(playerid,txtLasVenturas);
	}
	else if(gPlayerCitySelection[playerid] == CITY_SAN_FIERRO) {
		SetPlayerInterior(playerid,0);
   		SetPlayerCameraPos(playerid,-1300.8754,68.0546,129.4823);
		SetPlayerCameraLookAt(playerid,-1817.9412,769.3878,132.6589);
		
		TextDrawHideForPlayer(playerid,txtLosSantos);
		TextDrawShowForPlayer(playerid,txtSanFierro);
		TextDrawHideForPlayer(playerid,txtLasVenturas);
	}
	else if(gPlayerCitySelection[playerid] == CITY_LAS_VENTURAS) {
		SetPlayerInterior(playerid,0);
   		SetPlayerCameraPos(playerid,1310.6155,1675.9182,110.7390);
		SetPlayerCameraLookAt(playerid,2285.2944,1919.3756,68.2275);
		
		TextDrawHideForPlayer(playerid,txtLosSantos);
		TextDrawHideForPlayer(playerid,txtSanFierro);
		TextDrawShowForPlayer(playerid,txtLasVenturas);
	}
}

//----------------------------------------------------------

ClassSel_SwitchToNextCity(playerid)
{
    gPlayerCitySelection[playerid]++;
	if(gPlayerCitySelection[playerid] > CITY_LAS_VENTURAS) {
	    gPlayerCitySelection[playerid] = CITY_LOS_SANTOS;
	}
	PlayerPlaySound(playerid,1052,0.0,0.0,0.0);
	gPlayerLastCitySelectionTick[playerid] = GetTickCount();
	ClassSel_SetupSelectedCity(playerid);
}

//----------------------------------------------------------

ClassSel_SwitchToPreviousCity(playerid)
{
    gPlayerCitySelection[playerid]--;
	if(gPlayerCitySelection[playerid] < CITY_LOS_SANTOS) {
	    gPlayerCitySelection[playerid] = CITY_LAS_VENTURAS;
	}
	PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
	gPlayerLastCitySelectionTick[playerid] = GetTickCount();
	ClassSel_SetupSelectedCity(playerid);
}

//----------------------------------------------------------

ClassSel_HandleCitySelection(playerid)
{
	new Keys,ud,lr;
    GetPlayerKeys(playerid,Keys,ud,lr);
    
    if(gPlayerCitySelection[playerid] == -1) {
		ClassSel_SwitchToNextCity(playerid);
		return;
	}

	// only allow new selection every ~500 ms
	if( (GetTickCount() - gPlayerLastCitySelectionTick[playerid]) < 500 ) return;
	
	if(Keys & KEY_FIRE) {
	    gPlayerHasCitySelected[playerid] = 1;
	    TextDrawHideForPlayer(playerid,txtClassSelHelper);
		TextDrawHideForPlayer(playerid,txtLosSantos);
		TextDrawHideForPlayer(playerid,txtSanFierro);
		TextDrawHideForPlayer(playerid,txtLasVenturas);
	    TogglePlayerSpectating(playerid,0);
	    return;
	}
	
	if(lr > 0) {
	   ClassSel_SwitchToNextCity(playerid);
	}
	else if(lr < 0) {
	   ClassSel_SwitchToPreviousCity(playerid);
	}
}

//----------------------------------------------------------

public OnPlayerRequestClass(playerid, classid)
{
	if(IsPlayerNPC(playerid)) return 1;

	if(gPlayerHasCitySelected[playerid]) {
		ClassSel_SetupCharSelection(playerid);
		return 1;
	} else {
		if(GetPlayerState(playerid) != PLAYER_STATE_SPECTATING) {
			TogglePlayerSpectating(playerid,1);
    		TextDrawShowForPlayer(playerid, txtClassSelHelper);
    		gPlayerCitySelection[playerid] = -1;
		}
  	}
    
	return 0;
}

//----------------------------------------------------------

public OnGameModeInit()
{
	SetGameModeText("Grand Larceny");
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_GLOBAL);
	ShowNameTags(1);
	SetNameTagDrawDistance(40.0);
	EnableStuntBonusForAll(0);
	DisableInteriorEnterExits();
	SetWeather(2);
	SetWorldTime(11);
	
	//SetObjectsDefaultCameraCol(true);
	//UsePlayerPedAnims();
	//ManualVehicleEngineAndLights();
	//LimitGlobalChatRadius(300.0);
	
	ClassSel_InitTextDraws();

	// Player Class
	AddPlayerClass(298,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(299,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(300,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(301,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(302,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(303,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(304,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(305,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(280,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(281,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(282,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(283,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(284,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(285,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(286,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(287,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(288,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(289,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(265,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(266,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(267,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(268,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(269,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(270,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(1,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(2,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(3,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(4,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(5,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(6,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(8,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(42,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(65,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(74,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(86,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(119,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
 	AddPlayerClass(149,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(208,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(273,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(289,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	
	AddPlayerClass(47,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(48,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(49,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(50,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(51,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(52,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(53,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(54,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(55,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(56,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(57,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(58,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
   	AddPlayerClass(68,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(69,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(70,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(71,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(72,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(73,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(75,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(76,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(78,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(79,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(80,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(81,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(82,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(83,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(84,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(85,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(87,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(88,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(89,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(91,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(92,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(93,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(95,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(96,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(97,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(98,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(99,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);

	// SPECIAL
	total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/trains.txt");
	total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/pilots.txt");

   	// LAS VENTURAS
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/lv_law.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/lv_airport.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/lv_gen.txt");
    
    // SAN FIERRO
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/sf_law.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/sf_airport.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/sf_gen.txt");
    
    // LOS SANTOS
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/ls_law.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/ls_airport.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/ls_gen_inner.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/ls_gen_outer.txt");
    
    // OTHER AREAS
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/whetstone.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/bone.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/flint.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/tierra.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/red_county.txt");

    printf("Total vehicles from files: %d",total_vehicles_from_files);

	return 1;
}

//----------------------------------------------------------

public OnPlayerUpdate(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(IsPlayerNPC(playerid)) return 1;

	// changing cities by inputs
	if( !gPlayerHasCitySelected[playerid] &&
	    GetPlayerState(playerid) == PLAYER_STATE_SPECTATING ) {
	    ClassSel_HandleCitySelection(playerid);
	    return 1;
	}
	
	// Don't allow minigun
	if(GetPlayerWeapon(playerid) == WEAPON_MINIGUN) {
	    Kick(playerid);
	    return 0;
	}

	
	return 1;
}

//----------------------------------------------------------
/*  C O D I G O    D E    S E B A   XD */
//----------------------------------------------------------

// CALLBACKS

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if (IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		if (newkeys & KEY_CROUCH)
        {
			new Float:x, Float:y, Float:z;
			GetVehicleVelocity(GetPlayerVehicleID(playerid),x,y,z);
			SetVehicleVelocity(GetPlayerVehicleID(playerid),x,y,z+0.3);
		}
	}
	return 1;
}

// FUNCIONES

stock SpawnVehiculo(playerid, carid)
{
	if(IsPlayerInAnyVehicle(playerid))
	{
		return SendClientMessage(playerid, COLOR_ERROR, "ERROR: ya estas en un vehiculo");
	}
	else
	{
		new resultado;
		new Float:x, Float:y, Float:z;
	
    	GetPlayerPos(playerid, x, y, z);
		resultado = CreateVehicle(carid, x+1, y, z, 0.0, -1, -1, -1);
		if(resultado==INVALID_VEHICLE_ID)
			return SendClientMessage(playerid, COLOR_ERROR, "ERROR: no fue creado :(");
		else
	    	return SendClientMessage(playerid, COLOR_SUCCESS, "auto creado ;-)");
	}
}

stock AddComponente(playerid, compid)
{
	new vehicle;
	vehicle = GetPlayerVehicleID(playerid);
	if(IsPlayerInAnyVehicle(playerid)){
	    return AddVehicleComponent(vehicle,compid);
	}
	return 0;
}

stock tpxyz(playerid, Float:x, Float:y, Float:z)
{
	if (GetPlayerInterior(playerid)!=0)
        return SendClientMessage(playerid, COLOR_ERROR, "area no apta para tp");
	else{
	    SetPlayerPos(playerid,x,y,z);
	    return SendClientMessage(playerid, COLOR_SUCCESS,"tp exitoso xD");
	}
}

// BASICO

CMD:heal(playerid, params[]){
	new userid;
	if (sscanf(params, "u", userid))
		return SendClientMessage(playerid, COLOR_ERROR, "Usage: \"/sanar <player>\"");
	else
		return SetPlayerHealth(userid, 100.00);
}

CMD:armor(playerid, params[]){
	SetPlayerArmour(playerid, 100.00);
	return 1;
}

CMD:fix(playerid, params[])
{
	if(!IsPlayerInAnyVehicle(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "ERROR: no estas en un vehiculo");
	else {
	    RepairVehicle(GetPlayerVehicleID(playerid));
	    return 1;
	}
}

// AUTOS

CMD:vh(playerid, params[])
{
	new carid;
	
	if (sscanf(params, "d", carid))
		return SendClientMessage(playerid, COLOR_ERROR, "Usage: \"/vh <carID>\"");
	else
		return SpawnVehiculo(playerid, carid);
}

CMD:lambo(playerid, params[]){
	return SpawnVehiculo(playerid, 451);
}

CMD:moto(playerid, params[]){
	return SpawnVehiculo(playerid, 522);
}

CMD:motox(playerid, params[]){
	return SpawnVehiculo(playerid, 521);
}

CMD:autito(playerid, params[]){
	return SpawnVehiculo(playerid, 496);
}

CMD:bici(playerid, params[]){
	return SpawnVehiculo(playerid, 481);
}

CMD:bote(playerid, params[]){
	return SpawnVehiculo(playerid, 473);
}

// ACCESORIOS

CMD:offroad(playerid, params[]){
	return AddComponente(playerid, 1025);
}

CMD:rims(playerid, params[]){
    return AddComponente(playerid, 1076);
}

CMD:nitro(playerid, params[]){
    return AddComponente(playerid, 1010);
}

CMD:suspension(playerid, params[]){
	return AddComponente(playerid, 1087);
}

CMD:vcolor(playerid, params[]){
	new c1, c2;
	new vehicle;
	vehicle = GetPlayerVehicleID(playerid);
	
    if (sscanf(params, "dd", c1, c2)){
		return SendClientMessage(playerid, COLOR_ERROR, "Usage: \"/vcolor <colorID> <colorID>\"");
	}
	else if (vehicle==0){
	    return SendClientMessage(playerid, COLOR_ERROR, "Error: no estas en un vehiculo");
	}
	else{
		vehicle = GetPlayerVehicleID(playerid);
		ChangeVehicleColor(vehicle, c1, c2);
		return 1;
	}
}

// ARMAS


CMD:weaponx(playerid, params[])
{
	new arma,cant;
    if (sscanf(params, "dd", arma, cant))
		return SendClientMessage(playerid, COLOR_ERROR, "Usage: \"/armax <WeaponId> <amount>\"");
	else{
	    return GivePlayerWeapon(playerid,arma,cant);
	}
}

CMD:katana(playerid, params[]){
    GivePlayerWeapon(playerid,8,1);
    return 1;
}

CMD:paracaidas(playerid, params[]){
    GivePlayerWeapon(playerid,46,1);
    return 1;
}

CMD:bate(playerid, params[]){
    GivePlayerWeapon(playerid,5,1);
    return 1;
}

CMD:pala(playerid, params[]){
    GivePlayerWeapon(playerid,6,1);
    return 1;
}

CMD:cuchillo(playerid, params[]){
    GivePlayerWeapon(playerid,4,1);
    return 1;
}

// ACCIONES

CMD:accion(playerid, params[])
{
	new accion;
    if (sscanf(params, "d", accion))
        return SendClientMessage(playerid, COLOR_ERROR, "Usage: \"/accion <ActionID> \"");
	else{
	    return SetPlayerSpecialAction(playerid, accion);
	}
}

CMD:jetpack(playerid, params[])
{
	return SetPlayerSpecialAction(playerid, 2);
}

CMD:chela(playerid, params[])
{
	return SetPlayerSpecialAction(playerid, 20);
}

CMD:jason(playerid, params[])
{
	return GivePlayerWeapon(playerid,9,1);
}

// INFO

stock showComandos(playerid)
{
	SendClientMessage(playerid, COLOR_SUCCESS, "Comandos:");
	SendClientMessage(playerid, COLOR_INFO , "/lambo /autito /arsenal /fix /moto /motox /jason /offroad");
	SendClientMessage(playerid, COLOR_INFO , "/jetpack /suspension /nitro /rims /katana /chela /rims /tps");
	return 1;
}

CMD:comandos(playerid,params[])
{
	return showComandos(playerid);
}

CMD:listatps(playerid,params[])
{
	SendClientMessage(playerid, COLOR_SUCCESS, "Tps:");
	SendClientMessage(playerid, COLOR_INFO , "/casacj /ls /sf /lv ");
	SendClientMessage(playerid, COLOR_INFO , "/area51 /playa /torre ");
	return 1;
}

// TPS

CMD:casacj(playerid, params[]){
	return tpxyz(playerid, 2494.0, -1672.0, 13.4);
}

CMD:torre(playerid, params[]){
	return tpxyz(playerid, 1542.0, -1356.0, 329.5);
}

CMD:playa(playerid, params[]){
	return tpxyz(playerid, 528.0, -1813.0, 11.0);
}

CMD:area51(playerid, params[]){
	return tpxyz(playerid, 212.0, 1863.0, 13.2);
}

CMD:sf(playerid, params[]){
    return tpxyz(playerid, -2207.3, 625.3, 49.5);
}

CMD:lv(playerid, params[]){
    return tpxyz(playerid, 2000.64, 1538.86, 13.6);
}

CMD:ls(playerid, params[]){
    return tpxyz(playerid, 1480.0, -1638.7, 14.2);
}

CMD:gotoplayer(playerid, params[])
{
	new userX;
	new Float:x, Float:y, Float:z;
    if (sscanf(params, "u", userX))
    {		
        return SendClientMessage(playerid, COLOR_ERROR, "Usage: \"/tp <user> \"");
    }
	else{
		GetPlayerPos(userX,x,y,z);
	    return tpxyz(playerid,x,y,z);
	}
}


// TEST

CMD:pos(playerid, params[])
{
	new Float:x , Float:y, Float:z;
	new szMessage[128];
	
	GetPlayerPos(playerid,x,y,z);
	format(szMessage, sizeof(szMessage), "Pos: %f x, %f y, %f z",x,y,z);
	printf("Player %d position: %fx %fy %fz",playerid,x,y,z);
	return SendClientMessage(playerid, COLOR_INFO, szMessage);
}

CMD:skin(playerid,params[])
{
	new skinid;
	if(sscanf(params, "d", skinid)) return SendClientMessage(playerid, COLOR_ERROR, "Usage: \"/skin <id> \"");
	
	else if(skinid>=0 && skinid<=311){
		SetPlayerSkin(playerid,skinid);
		return SendClientMessage(playerid, COLOR_SUCCESS,"cambio de skin exitoso xD");
	}
	else {
		return SendClientMessage(playerid, COLOR_ERROR,"numero de skin invalido");
	}
}
