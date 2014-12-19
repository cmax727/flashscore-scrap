<?php
@session_start();
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
	// …
	require_once "db_conn.inc";
	$login_id = $_REQUEST['login_id'];
	$password = $_REQUEST['password'];

	$login_id = str_replace("'", "", $login_id);
	$select = "select * from manage_users where login_id='$login_id'";

	$result = mysql_query($select, $conn);

	$row = mysql_fetch_assoc($result);
	
	echo "<br>";
	
	if ($row['password'] == md5($password)){
		$_SESSION['user_info'] = array('login_id'=>$login_id);
		include "index.php";
		die();
	}else{
		$_REQUEST['msg'] = "Incorrect password. Try again";
	}
}
?>
<html>
<head>
<title> Flash Score </title>
<script type="text/javascript">
</script>
</head>

<body>
<div id="errMsg" style="color:#ff0000">
<?
	if ( isset($_REQUEST['msg'])){
		echo $_REQUEST['msg'];
	}
?>
</div>

<div id="content">
	<form method="post" action="login.php" >
		<span>
			<label for="login_id"> Login ID:</label>
			<input name="login_id" id="login_id" value="<?=$_REQUEST['login_id']?>"/>
		</span>
		
		<span>
			<label for="password"> Password:</label>
			<input type="password" name="password" id="password" />
		</span>
		
		<span>
			<input type="submit"/>
		</span>
		
	</form>
</div>

</body>

