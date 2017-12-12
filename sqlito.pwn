// This is a comment
// uncomment the line below if you want to write a filterscript
#define FILTERSCRIPT

#include <a_samp>
#include <sscanf2>
#include <streamer>
#include <zcmd>

#define COLOR_ERROR         0xFF0000AA
#define COLOR_SUCCESS       0x0000FFFF


new DB: miDB;

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Sqlito");
	print("--------------------------------------\n");
	miDB = db_open("sqlito.db");
	print("Base de datos cargada :D");
	
 	if (miDB) {
        printf("la base de datos ha sido abierta, o creada. la id es %d", miDB);
    } else {
        print("tener este error, sería una cosa muy extraña");
    }
	
	return 1;
}

public OnFilterScriptExit()
{
	db_close(miDB);
	return 1;
}

public OnPlayerConnect(playerid)
{
	new playername[MAX_PLAYER_NAME];
	GetPlayerName(playerid,playername, sizeof playername);
	
	if(estaRegistrado(playername)) //si ya esta registrado
	{		
		setOnline(true,playername);
	}
}

public OnPlayerDisconnect(playerid)
{
	new playername[MAX_PLAYER_NAME];
	GetPlayerName(playerid,playername, sizeof playername);
	
	if(estaRegistrado(playername)) 
	{		
		setOnline(false,playername);
	}
}

stock registro(playerid, pass[])
{
	new consulta[80];
	new DBResult: query;
	new newname[MAX_PLAYER_NAME];  
  	
	GetPlayerName(playerid, newname, sizeof newname);
	
	if(estaRegistrado(newname)) {
		SendClientMessage(playerid, COLOR_ERROR, "Usuario ya Registrado");
		return false;
	}
	else{
		db_free_result(query);
	    format(consulta, sizeof(consulta), "insert into `users` values( '%q', '%q', 1 )",newname,pass);
		printf("%s",consulta);
		query = db_query(miDB, consulta);
	    db_free_result(query);
	    SendClientMessage(playerid, COLOR_SUCCESS, "Registro exitoso :D");
	    return true;
	}
}

stock estaRegistrado(playername[]) //ahora usa playername
{
	new consulta[80];
	new DBResult: query;
	
	format(consulta, sizeof(consulta), "select * from `users` where `nombre` = '%q'", playername);
	query = db_query(miDB, consulta);
	printf("%s",consulta);
	
	if( db_num_rows(query) > 0)
	{
		db_free_result(query);
		return true;
	}
	else{
		db_free_result(query);
		return false;
	}
}

stock isOnline( playername[])
{
	// select online from users where nombre = playername
}

stock setOnline(conectando, playername[])
{
	if(conectando)
	{
		//update users set online = 1 where nombre = playername
	}
	else
	{
		//update users set online = 0 where nombre = playername
	}
}

CMD:registrar(playerid, params[])
{
	new pass[MAX_PLAYER_NAME];
    if(sscanf(params, "s", pass)) return SendClientMessage(playerid, COLOR_ERROR, "Usage: \"/registrar <pass> \"");
    else
    {
        return registro(playerid,pass);
    }
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if(killerid != INVALID_PLAYER_ID) {
		playercash = GetPlayerMoney(playerid);
		if(playercash >= 1000)  {			
			GivePlayerMoney(playerid, -1000);
		}
		//new racha = getRacha()
		GivePlayerMoney(killerid, 1000);
	}
   	return 1;
}