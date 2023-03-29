<?php
    $postdata = json_decode(file_get_contents("php://input"));

    require_once "GetConn.php";
    $mysqlCon = GetConn();
	
    $query = "SELECT * FROM users WHERE username='$postdata->username' AND password='$postdata->password'";

    $result = $mysqlCon->query($query);

    $postRes = new stdClass();
    if ($result->num_rows == 1) {
        $userDatas = mysqli_fetch_object($result);

        if ($userDatas->token == NULL) {
            //generate token
            $query = "UPDATE users SET token = CONCAT(id, LEFT(UUID(), 16)) WHERE Id=$userDatas->id";
            $mysqlCon->query($query);
        }

        //Returning datas
        $query = "SELECT token, id FROM users WHERE id=$userDatas->id";
        $result = $mysqlCon->query($query);
        $datas = mysqli_fetch_object($result);

        $postRes->status = 1;
        $postRes->datas = $datas;

        echo json_encode($postRes);

    } else {
        $postRes->status = 0;
        $postRes->message = "User not found";
        echo json_encode($postRes);
    }
?>