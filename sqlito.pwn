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

// da plata extra por racha
public OnPlayerDeath(playerid, killerid, reason)
{
	new racha=0;
	if(killerid != INVALID_PLAYER_ID) {
		racha = getRacha(playerid); 
		GivePlayerMoney(killerid, 1000*racha);
		setRacha(racha+1,playerid);
		updateMoney(playerid);
	}
   	return 1;
}

// C O M A N D O S

CMD:registrar(playerid, params[])
{
	new pass[MAX_PLAYER_NAME];
    if(sscanf(params, "s", pass)) return SendClientMessage(playerid, COLOR_ERROR, "Usage: \"/registrar <pass> \"");
    else
    {
        return registro(playerid,pass);
    }
}

CMD:login(playerid, params[])  // INCOMPLETO
{
	// llamar al dialogo
}

// F U N C I O N E S

stock registro(playerid, pass[])
{
	new consulta[80];
	new DBResult: query;
	new newname[MAX_PLAYER_NAME];  
  	
	GetPlayerName(playerid, newname, sizeof newname);
	
	if(isRegistrado(newname)) {
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

stock login(playername,pass)  // INCOMPLETO
{
	// select pass from users where nombre = playername
	
	if(password==pass)
	{
		// update users set online=1 where nombre = playername
		return true;
	}
	else
	{
		return false;
	}
}

// GETTERS / SETTERS

stock isRegistrado(playername[])
{
	new consulta[80];
	new DBResult: query;
	
	// select * from users where nombre = playername
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
	new consulta[80];
	new DBResult: query;
	new respuesta = 0;
	
	// select online from users where nombre = playername
	format(consulta, sizeof(consulta), "select `online` from `users` where `nombre` = '%q'", playername);
	query = db_query(miDB, consulta);
	printf("%s",consulta);
	
	if(db_num_rows(query))
	{
		respuesta = db_get_field_int(query, 0);
	}
	db_free_result(query);
	return respuesta
}

stock setOnline(conectando, playername[]) // INCOMPLETO
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

stock getRacha(playerid)  // INCOMPLETO
{
	new playername[MAX_PLAYER_NAME];
	GetPlayerName(playerid,playername, sizeof playername);
	
	// select racha from kills where nombre=playername
	
	// si no esta user devuelve 1
	return 1;
}

stock setRacha(num,playerid) // INCOMPLETO
{
	// update kills set racha=num where nombre=playername
}

stock updateMoney(playerid) // INCOMPLETO
{
	new playername[MAX_PLAYER_NAME];
	GetPlayerName(playerid,playername, sizeof playername);
	plata = GetPlayerMoney(playerid);
	
	// update money set dinero=plata where nombre = playername
	
}

stock readDinero(playerid) // INCOMPLETO
{
	new playername[MAX_PLAYER_NAME];
	new plata;
	GetPlayerName(playerid,playername, sizeof playername);
	
	// select dinero from money where nombre = playername
		
	
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, plata);
}

stock isAdmin(playerid)
{
	new playername[MAX_PLAYER_NAME];
	new consulta[80];
	new DBResult: query;
	
	GetPlayerName(playerid,playername, sizeof playername);
	
	// select * from admin where nombre=playername
	format(consulta, sizeof(consulta), "select * from `admin` where `nombre` = '%q'", playername);
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