<?
require_once "db_conn.inc";
require_once "auth.php";

$type = $_REQUEST['type'];
$koname = $_REQUEST['koname'];
$rowid = $_REQUEST['rowid'];

$sql = "";
if ( $type =='team'){
	$sql = "update team_data  set t_name_ko='$koname' where t_id = '$rowid'";
}else if ( $type =='gamename'){
	$sql = "update game_name set gn_name_ko = '$koname' where gn_code = '$rowid'";
}

mysql_query($sql);
die();

?>