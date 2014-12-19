<?php
@session_start();
if (!isset($_SESSION['user_info'])){
	//$_REQUEST['msg'] = "You must login first.";
	include "login.php";
	die();
}
	
?>

