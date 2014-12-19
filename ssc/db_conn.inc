<?php
	$configpath = dirname(__FILE__)."/proxy_config.xml";
	$xml = simplexml_load_file($configpath);
	//$xml = new SimpleXMLElement("config.xml");
	  $host = $xml->xpath("/appSettings/add[@key='host']");
	  $host = $host[0]->attributes()->value;
	  
	  $db= $xml->xpath("/appSettings/add[@key='database']");
	  $db = $db[0]->attributes()->value;
	  
	  $user = $xml->xpath("/appSettings/add[@key='user']");
	  $user =$user[0]->attributes()->value;
	  
	  $pwd = $xml->xpath("/appSettings/add[@key='password']");
	  $pwd =$pwd[0]->attributes()->value;
	  
	  $charset = $xml->xpath("/appSettings/add[@key='charset']");
	  $charset =$charset[0]->attributes()->value;
	  
	  $port = $xml->xpath("/appSettings/add[@key='port']");
	  $port =$port[0]->attributes()->value;
	  
	  $conn = mysql_connect("$host:$port", "$user", "$pwd");
	if (!$conn) {
		die('Could not connect: ' . mysql_error());
	}

	mysql_set_charset ( "utf8" ,$conn);
	mysql_select_db($db);
	mysql_set_charset($charset);
		
?>