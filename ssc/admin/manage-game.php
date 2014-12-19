<?php
require_once "../db_conn.inc";
require_once "auth.php"
?>
<html>
<head>
<META http-equiv="Content-Type" content="text/html; charset=utf-8">

<title> Admin Live Score </title>
<script src="jquery-1.7.1.min.js"></script>

<script type="text/javascript">
var updateme = function(rowid){
	tid = $("#"+rowid).attr('id');
	koname = $("#"+rowid + " .koname input").val();
	
	$.ajax({
	  url: "ajax-update.php?type=gamename" + "&rowid="+tid + "&koname="+koname ,
	  context: document.body,
	  success: function(data){
		alert("Data updated!");
	  }
	});

}
function search(){
	$('#page').val(0);
	
}

</script>
</head>

<body>
<div>
<a href="index.php"> Home </a>
</div>

<div id="errMsg" style="color:#ff0000">
<?
	if ( isset($_REQUEST['msg'])){
		echo $_REQUEST['msg'];
	}
?>
</div>
<form method="post" action="" >
<div id="search">
	
		<span>
			<label for="game_type"> Game type:</label>
			<select name="game_type" id="game_type" >
				<option value="1" <?if($_REQUEST['game_type'] == '1') echo "selected='true'"?>>soccer</option>
				<option value="2" <?if($_REQUEST['game_type'] == '2') echo "selected='true'"?>>tennis</option>
				<option value="3" <?if($_REQUEST['game_type'] == '3') echo "selected='true'"?>>basketball</option>
				<option value="4" <?if($_REQUEST['game_type'] == '4') echo "selected='true'"?>>hockey</option>
				<option value="6" <?if($_REQUEST['game_type'] == '6') echo "selected='true'"?>>handball</option>
				<option value="7" <?if($_REQUEST['game_type'] == '7') echo "selected='true'"?>>volleyball</option>
				<option value="12" <?if($_REQUEST['game_type'] == '12') echo "selected='true'"?>>baseball</option>
			</select>
		</span>
		
		<span>
			<label for="gamename"> English Name:</label>
			<input name="gamename" id="gamename" value='<?=$_REQUEST['gamename']?>'/>
		</span>
		
		<span>
			<input type="submit" value="search" onclick="search()"/>
		</span>
		<input type="hidden" name="page" id="page" value='<?=$_REQUEST['page']?>'/>
		<input type="hidden" name="section" value='<?=$_REQUEST['section']?>'/>
		
	
</div>

<?
	if ( !isset($_REQUEST['page'])){
		$_REQUEST['page'] = 0;
	}
	
	if ( !isset($_REQUEST['game_type'])){
		$_REQUEST['game_type'] = 1;
	}

	$game_type = $_REQUEST['game_type'];
	$page = $_REQUEST['page'] ;
	$gamename=$_REQUEST['gamename'] ;
	$sql =  "select count(*) cnt from game_name t where t.g_type=$game_type and t.gn_name like '%$gamename%'";
	$row = mysql_fetch_row(mysql_query($sql,$conn) );
	$rowCnt = $row[0];
	$pageCnt = ceil($rowCnt /10);
	$section = floor($page / 10);
	$page = $page * 10;
	$sql = "select *  from game_name t where t.g_type=$game_type and t.gn_name like '%$gamename%' limit $page, 10";
	$page = $page / 10;
	$res = mysql_query($sql,$conn) ;
?>
<div id="list">
<table style="border:solid">
<thead>
	<td width="140px">Game Type</td>
	<td width="240px">English Name</td>
	<td width="240px">Korean Name</td>
	<td width="80px"></td>
</thead>
<?
$idx = 0;
while ($row = mysql_fetch_assoc($res)) {
$idx++; ?>

	<tr id="<?= $row['gn_code'] ?>">
		<td class="gtype"><?= $row['g_type']?></td>
		<td class="ename"><?= $row['gn_name']?></td>
		<td class="koname"><input type=text value='<?= $row['gn_name_ko']?>'/></td>
		<td><input type=button value='update' onclick="updateme('<?= $row['gn_code'] ?>')"/></td>
		
	</tr>
<?}?>

</table>
</div>
<div id="nav">
<?
	if ( $section >0){
		echo "<span style='width:50px'>
			<a href='?game_type={$_REQUEST['game_type']}&gamename={$_REQUEST['gamename']}&page=",($section-1)*10,"}'>&lt;&lt;</a></span>";
	}
	
	for($idx = $section*10;$idx < $section*10+10; $idx++){
		echo "<span style='width:50px'>
			<a href='?game_type={$_REQUEST['game_type']}&gamename={$_REQUEST['gamename']}&page=$idx'>$idx</a></span>";
	}
	
	if ( ($section+1)*100<=$rowCnt){
		echo "<span style='width:50px'>
			<a href='?game_type={$_REQUEST['game_type']}&gamename={$_REQUEST['gamename']}&page=",($section+1)*10,"}'>&gt;&gt;</a></span>";
	}
	
?>
</div>




</body>
