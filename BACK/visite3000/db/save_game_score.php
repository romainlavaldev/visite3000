<?php
    ini_set('display_errors', 1);
    ini_set('display_startup_errors', 1);
    error_reporting(E_ALL);

    $postdata = json_decode(file_get_contents("php://input"));

    $db = "visite3000"; //database name
    $dbuser = "admin"; //database username
    $dbpassword = "admin"; //database password
    $dbhost = "localhost"; //database host

    $mysqlCon = mysqli_connect($dbhost, $dbuser, $dbpassword, $db);
    
    $query = "INSERT INTO gameScores (name, gameScores.time, displayTime) VALUES ('$postdata->name',$postdata->time, '$postdata->displayTime')";

    $mysqlCon->query($query);
?>
