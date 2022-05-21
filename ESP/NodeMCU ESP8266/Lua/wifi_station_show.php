<?php
	// ------------------------------------------------
	// -- Code created by Everton Pereira da Cruz    --
	// -- to show record information about light     --
	// -- state with NodeMCU ESP8266                 --
	// ------------------------------------------------
	
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
		
		$sql  = "SELECT id, vDatetime, vStatus FROM tableState";
		
		$sth = $db->prepare( $sql );
		$sth->execute();
		echo '<h1 align="center">NodeMCU ESP8266<br/>State LED BuiltIN</h1>';
		echo '<table align="center" border="1">';
		echo '<tr><td>id</td><td>datetime</td><td>status</td></tr>';
		while( $row = $sth->fetch(PDO::FETCH_ASSOC, PDO::FETCH_ORI_NEXT) ){
			echo "<tr><td>{$row['id']}</td><td>{$row['vDatetime']}</td><td>{$row['vStatus']}</td></tr>";
		}
		echo '</table>';
		
		$sth = null;
		$db = null;
	}
	catch( PDOException $e ){
		echo 'Connection failed: ' . $e->getMessage();
	}
?>