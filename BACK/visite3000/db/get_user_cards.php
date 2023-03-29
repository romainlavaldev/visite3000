<?php
    $postdata = json_decode(file_get_contents("php://input"));

    require_once "GetConn.php";
    $mysqlCon = GetConn();
	
    $query = "SELECT id FROM cards WHERE ownerId=1";

    $result = $mysqlCon->query($query);
	 
    $postRes = new stdClass();
    if ($result->num_rows != 0) {
        //Token is up to date !
        
        $postRes->status = 1;
        $postRes->datas = mysqli_fetch_all($result, MYSQLI_ASSOC);
        echo json_encode($postRes);
    } else {

        $postRes->status = 0;
        echo json_encode($postRes);
    }
?>