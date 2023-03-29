<?php
    $postdata = json_decode(file_get_contents("php://input"));

    require_once "GetConn.php";
    $mysqlCon = GetConn();
	
    $query = "INSERT INTO gameScores (name, gameScores.time, displayTime) VALUES ('$postdata->name',$postdata->time, '$postdata->displayTime')";

    $mysqlCon->query($query);
?>
