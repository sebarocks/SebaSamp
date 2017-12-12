// This is a comment
// uncomment the line below if you want to write a filterscript
#define FILTERSCRIPT

#include <a_samp>
#include <zcmd>

#define COLOR_WHITE 		0xFFFFFFFF
#define COLOR_NORMAL_PLAYER 0xFFBB7777
#define COLOR_ERROR         0xFF0000AA
#define COLOR_SUCCESS       0x0000FFFF
#define COLOR_INFO          0x00FF00FF

static Menu:arma;
static Menu:tps;

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Menus locos");
	print("--------------------------------------\n");
	
	// MENU ARMAS	
 	arma = CreateMenu("Arma", 2, 227, 171, 100, 100);

	SetMenuColumnHeader(arma, 0, "Arma");
	AddMenuItem(arma, 0, "Pistola");
	AddMenuItem(arma, 0, "Uzi");
	AddMenuItem(arma, 0, "Ak47");
	AddMenuItem(arma, 0, "Escopeta");
	AddMenuItem(arma, 0, "Rifle");
	AddMenuItem(arma, 0, "Armadura");

	SetMenuColumnHeader(arma, 1, "Precio");
	AddMenuItem(arma, 1, "1000");
	AddMenuItem(arma, 1, "2000");
	AddMenuItem(arma, 1, "5000");
	AddMenuItem(arma, 1, "8000");
	AddMenuItem(arma, 1, "9000");
	AddMenuItem(arma, 1, "5000");
	
	//MENU TPS
	tps = CreateMenu("Teleports", 1, 227, 171, 100, 100);
	SetMenuColumnHeader(tps, 0, "Teleports");	
    AddMenuItem(tps, 0, "Casa CJ");
    AddMenuItem(tps, 0, "Torre");
    AddMenuItem(tps, 0, "Area 51");
    AddMenuItem(tps, 0, "San Fierro");
    AddMenuItem(tps, 0, "Los Santos");
    AddMenuItem(tps, 0, "Las Venturas");
	
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
    if(GetPlayerMenu(playerid) == arma)
    {
        switch(row)
        {
            case 0: //Pistola
            {
				if(GetPlayerMoney(playerid)>0)
				{
					GivePlayerWeapon(playerid,22,24);
					GivePlayerMoney(playerid, -1000);
				}
				else
				{
					SendClientMessage(playerid, COLOR_ERROR, "No tienes dinero :o");
				}
				TogglePlayerControllable(playerid, true);
            }
			case 1: //Uzi
			{
				if(GetPlayerMoney(playerid)>0)
				{
					GivePlayerWeapon(playerid,28,30);
					GivePlayerMoney(playerid, -2000);
				}
				else
				{
					SendClientMessage(playerid, COLOR_ERROR, "No tienes dinero :o");
				}
				TogglePlayerControllable(playerid, true);
			}
			case 2: //Ak47
			{
				if(GetPlayerMoney(playerid)>0)
				{
					GivePlayerWeapon(playerid,30,20);
					GivePlayerMoney(playerid, -5000);
				}
				else
				{
					SendClientMessage(playerid, COLOR_ERROR, "No tienes dinero :o");
				}
				TogglePlayerControllable(playerid, true);
			}
			case 3: //Escopeta
			{
				if(GetPlayerMoney(playerid)>0)
				{
					GivePlayerWeapon(playerid,25,10);
					GivePlayerMoney(playerid, -8000);
				}
				else
				{
					SendClientMessage(playerid, COLOR_ERROR, "No tienes dinero :o");
				}
				TogglePlayerControllable(playerid, true);
			}
			case 4: //Rifle
			{
				if(GetPlayerMoney(playerid)>0)
				{
					GivePlayerWeapon(playerid,33,10);
					GivePlayerMoney(playerid, -9000);
				}
				else
				{
					SendClientMessage(playerid, COLOR_ERROR, "No tienes dinero :o");
				}
				TogglePlayerControllable(playerid, true);
			}
			case 5: //Armadura
			{
				if(GetPlayerMoney(playerid)>0)
				{
					SetPlayerArmour(playerid, 100.00);
					GivePlayerMoney(playerid, -5000);
				}
				else
				{
					SendClientMessage(playerid, COLOR_ERROR, "No tienes dinero :o");
				}
				TogglePlayerControllable(playerid, true);
            }
        }
    }
	 
	if(GetPlayerMenu(playerid) == tps)
	{
		switch(row)
        {
            case 0: //Casa CJ
			{
				hacertp(playerid, 2494.0, -1672.0, 13.4);
				TogglePlayerControllable(playerid, true);
			}
			case 1: //Torre
			{
				hacertp(playerid, 1542.0, -1356.0, 329.5);
				TogglePlayerControllable(playerid, true);
			}
			case 2: //Area 51
			{
				hacertp(playerid, 212.0, 1863.0, 13.2);
				TogglePlayerControllable(playerid, true);
			}
			case 3: //San Fierro
			{
				hacertp(playerid, -2207.3, 625.3, 49.5);
				TogglePlayerControllable(playerid, true);
			}
			case 4: //Los Santos
			{
				hacertp(playerid, 1480.0, -1638.7, 14.2);
				TogglePlayerControllable(playerid, true);
			}
			case 5: //Las Venturas
			{
				hacertp(playerid, 2000.64, 1538.86, 13.6);
				TogglePlayerControllable(playerid, true);
			}
		}
	 }
     return 1;
}

public OnPlayerExitedMenu(playerid)
{
    TogglePlayerControllable(playerid, true);
    return 1;
}

stock hacertp(playerid, Float:x, Float:y, Float:z)
{
	if (GetPlayerInterior(playerid)!=0)
        return SendClientMessage(playerid, COLOR_ERROR, "area no apta para tp");
	else{
	    SetPlayerPos(playerid,x,y,z);
	    return SendClientMessage(playerid, COLOR_SUCCESS,"tp exitoso xD");
	}
}

CMD:armas(playerid, params[])
{
	TogglePlayerControllable(playerid, false);
	return ShowMenuForPlayer(arma, playerid);
}

CMD:tps(playerid,params[])
{
	TogglePlayerControllable(playerid, false);
	return ShowMenuForPlayer(tps, playerid);
}
