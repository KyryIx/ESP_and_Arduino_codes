<?php
	// ------------------------------------------------
	// -- Code created by Everton Pereira da Cruz    --
	// -- to record information with NodeMCU ESP8266 --
	// -- about light state                          --
	// ------------------------------------------------
	// example use: http://www.YOUR_HOST.com/wifi_station_insert.php?state=on
	if( isset( $_GET['state'] ) ){
		$state = addslashes( $_GET['state'] );
		if( strlen($state) > 0 ){
			try{
				/*
					DROP TABLE IF EXISTS tableState;
					
					CREATE TABLE tableState (
						id        INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
						vDatetime VARCHAR (255),
						vStatus   VARCHAR (3) DEFAULT 'off'
					);
				*/
				$dsn = 'sqlite:./wifi_station_database.db3';
				$db = new PDO( $dsn );
				
				// https://www.php.net/manual/pt_BR/timezones.america.php
				$dt = new DateTime( "now", new DateTimeZone( "America/Sao_Paulo" ) );
				$dt->setTimestamp( time() );
				$date_time = $dt->format( 'Y-m-d H:i:s' );
				$sql  = "INSERT INTO tableState(vDatetime, vStatus) ";
				$sql .= "VALUES('$date_time','$state')";
				
				$count = $db->exec( $sql );
				if( $count > 0 ){
					print( "Sucess. Insert state." );
				}
				else{
					print( "Warning. Do not insert state." );
					print_r( $db->errorInfo() );
				}
			}
			catch( PDOException $e ){
				echo 'Connection failed: ' . $e->getMessage();
			}
		}
	}
?>