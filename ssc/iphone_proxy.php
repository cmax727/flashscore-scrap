<?php

require_once "db_conn.inc";

    $table = $_REQUEST['table'];
  	$type =  $_REQUEST['type'];
    $state = $_REQUEST['state'];
    $time  = $_REQUEST['time'];
    $g_code= $_REQUEST['g_code'];

    $other = $_REQUEST['other'];     
    $updated  =$_REQUEST['updated']; 
    $location =$_REQUEST['location'];
    $phone_no = $_REQUEST['num'];

    if($table == '0') {
        $sql = "select login_count from users where phone_no='$phone_no'";
        $result = mysql_query($sql);
		while ( $row =  mysql_fetch_assoc($result)){
			$logcount = $row[0];
		}
		if ( empty($logcount))
			$logcount = 0;
        $logcount = $logcount+1;
        
        $sql = "insert into ( phone_no, login_count) values ('$phone_no', $logcount )";
		if (!mysql_query($sql)){ // already exist then update;
			$sql = "update users set login_count = $logcount where phone_no = '$phone_no'";
			if(!mysql_query($sql)){
				echo "failed";
				exit(0);
			}
		}
		echo "succeed";
		exit(0);
    }
    if($table == '1')       //Country List
    {
        $sql = "SELECT distinct f.name as name FROM ssc.fl_area f where 1=1;";
    }
    else if($table == '2')  //Match List
    {
        $sql = "SELECT distinct g.gn_name as name FROM ssc.game_name g inner join ssc.fl_area f on g.fl_code=f.fl_code" 
                                ." where 1=1 and g.g_type='".$type."' and f.name like '".$location."' order by g.gn_name;";
    }
    else if($table == '3')  //Team List
    {
        $sql = "SELECT distinct t.t_name as name FROM ssc.team_data t inner join ssc.fl_area f on t.fl_code=f.fl_code"
                                ." where 1=1 and t.g_type='".$type."' and f.name like '".$location."' order by t.t_name;";
    }
    else if($table == '4')  // Now MatchList(Game Menu)
    {
        $minTime = $time;
        $maxTime = $time+86400;
        $sql = "SELECT case when gn.gn_name_ko is null or gn.gn_name_ko = '' then gn.gn_name else gn.gn_name_ko end name,"
                        ." gn.fl_code as sid, gn.gn_code, count(*) as countIn FROM ssc.game_log d inner join ssc.game_name gn"
                        ." on (d.gn_code = gn.gn_code and d.g_type = gn.g_type)"
                        ." where 1=1 and d.g_type='".$type."' and d.g_time>".$minTime." and d.g_time<".$maxTime." group by gn.gn_name;";        
    }
    else if($table == '5')  //Group Url (table sectionlist)
    {
        $minTime = $time;
        $maxTime = $time+86400;
        if($state == '4') //Favorite Setting
        {
            $sql = "SELECT case when gn.gn_name_ko is null or gn.gn_name_ko = '' then gn.gn_name else gn.gn_name_ko end name,"
                            ." gn.fl_code as sid, count(*) as countIn FROM ssc.game_log d inner join ssc.game_name gn"
                            ." on (d.gn_code = gn.gn_code and d.g_type = gn.g_type)"
                    ." where 1=1 and d.g_type='".$type."' and d.g_time>".$minTime." and d.g_time<".$maxTime
                            ." and d.updated>".$updated
                            .$other." group by gn.gn_name order by gn.gn_name;";
        }
        else
        {
            $sql = "SELECT case when gn.gn_name_ko is null or gn.gn_name_ko = '' then gn.gn_name else gn.gn_name_ko end name,"
                            ." gn.fl_code as sid, count(*) as countIn FROM ssc.game_log d inner join ssc.game_name gn"
                            ." on (d.gn_code = gn.gn_code and d.g_type = gn.g_type)"
                    ." where 1=1 and d.g_type='".$type."' and d.s0 like '".$state."' and d.g_time>".$minTime." and d.g_time<".$maxTime
                            ." and d.updated>".$updated
                            .$other." group by gn.gn_name order by gn.gn_name;";
        }

    }    
    else if($table == '6')  //Browser Url (table CellResult)
    {
        $minTime = $time;
        $maxTime = $time+86400;
        if($state == '4')
        {            
            $sql = "SELECT case when ta.t_name_ko is null or ta.t_name_ko = '' then ta.t_name else ta.t_name_ko end  teamA,"
                        ." case when tb.t_name_ko is null or tb.t_name_ko = '' then tb.t_name else tb.t_name_ko end  teamB,"
                        ." case when gn.gn_name_ko is null or gn.gn_name_ko = '' then gn.gn_name else gn.gn_name_ko end  gn_name,"
                        ." g.g_time, g.s0, g.a0, g.b0, g.g_code"
                ." FROM game_log g"                   
                        ." inner join game_name gn on gn.gn_code = g.gn_code and g.g_type = '".$type."'"
                        ." inner join team_data ta on ta.t_id =g.teama and g.g_type = '".$type."'"
                        ." inner join team_data tb on tb.t_id =g.teamb and g.g_type = '".$type."'"
                ." where 1=1 and g.g_type='".$type."' and g.g_time>".$minTime." and g.g_time<".$maxTime
                        ." and g.updated>".$updated
                        .$other." order by gn.gn_name, g.teamA;";
        }
        else {
            $sql = "SELECT case when ta.t_name_ko is null or ta.t_name_ko = '' then ta.t_name else ta.t_name_ko end  teamA,"
                        ." case when tb.t_name_ko is null or tb.t_name_ko = '' then tb.t_name else tb.t_name_ko end  teamB,"
                        ." case when gn.gn_name_ko is null or gn.gn_name_ko = '' then gn.gn_name else gn.gn_name_ko end  gn_name,"
                        ." g.g_time, g.s0, g.a0, g.b0, g.g_code"
                ." FROM game_log g"                   
                        ." inner join game_name gn on gn.gn_code = g.gn_code and g.g_type = '".$type."'"
                        ." inner join team_data ta on ta.t_id =g.teama and g.g_type = '".$type."'"
                        ." inner join team_data tb on tb.t_id =g.teamb and g.g_type = '".$type."'"
                ." where 1=1 and g.g_type='".$type."' and g.s0 like '".$state."' and g.g_time>".$minTime." and g.g_time<".$maxTime
                        ." and g.updated>".$updated
                        .$other." order by gn.gn_name, g.teamA;"; 
        }
    }   
    else if($table == '7')  //Present
    {
        $sql = "SELECT g.s0, g.s1, g.a0, g.a1, g.a2, g.a3, g.a4, g.a5, g.b0, g.b1, g.b2, g.b3, g.b4, g.b5 FROM ssc.game_log g where 1=1 and g.g_code ='".$g_code."' and g.updated>".$updated;
    }  
    else{
        exit(0);
    }     
  				
		$result = mysql_query($sql);
		$arr3 = array();
		while ( $row =  mysql_fetch_assoc($result)){
			$arr3[] = $row;
		}
		$out = json_encode($arr3);
		$out = str_replace('null', '""', $out);
        
    if($table == '5' || $table == '6' || $table == '7')
    {
        $controlSQL = "SELECT max(g.updated) FROM ssc.game_log g where 1=1";
        $result = mysql_query($controlSQL);
        $row =  mysql_fetch_row($result);
        $lastUpdate = $row[0];
        
        $response = $lastUpdate. "#:#" . $out;
    }
    else        
 		$response = $out;
	echo $response;
?>
