<?php

    function GetConn(){
        $db = "visite3000_connecteur_dev"; //database name
        $dbuser = "admin"; //database username
        $dbpassword = "admin"; //database password
        $dbhost = "localhost"; //database host

        $mysqlCon = mysqli_connect($dbhost, $dbuser, $dbpassword, $db);

        return $mysqlCon;
    }
?>