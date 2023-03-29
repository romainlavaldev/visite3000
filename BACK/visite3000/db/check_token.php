<?php
    $postdata = json_decode(file_get_contents("php://input"));

	require_once "GetConn.php";
    $mysqlCon = GetConn();

    $query = "SELECT * FROM users WHERE id='$postdata->userId' AND token='$postdata->token'";

    $result = $mysqlCon->query($query);

    $postRes = new stdClass();
    if ($result->num_rows == 1) {
        //Token is up to date !
        $postRes->status = 1;
        echo json_encode($postRes);
    } else {

        $postRes->status = 0;
        echo json_encode($postRes);
    }
?>