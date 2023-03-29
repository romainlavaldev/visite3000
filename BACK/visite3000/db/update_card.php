<?php
    $postdata = json_decode(file_get_contents("php://input"));

    require_once "GetConn.php";
    $mysqlCon = GetConn();
	
    $query = "UPDATE cards SET role='$postdata->role', phone='$postdata->phone', mail='$postdata->mail' WHERE id=$postdata->cardId;";

    $mysqlCon->query($query);
?>
