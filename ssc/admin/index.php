<?php
@session_start();
if (!isset($_SESSION['user_info'])){
	include "auth.php";
}

?>
<html>
<head>
<title> Flash Score </title>
<script type="text/javascript">
</script>
</head>

<body>
<a href="manage-game.php">game_edit</a>
<br/>
<a href="manage-team.php">team_edit</a>

</body>
