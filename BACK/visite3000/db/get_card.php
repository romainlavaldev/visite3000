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

        $query = "select phone, mail, role, firstname, lastname from cards right join users on cards.ownerId = users.id where cards.id = '$postdata->cardId'";

        $result = $mysqlCon->query($query);

        $postRes = new stdClass();
        if ($result->num_rows != 0) {
            $postRes->status = 1;
            $postRes->datas = mysqli_fetch_all($result, MYSQLI_ASSOC);
            echo json_encode($postRes);
        } else {

            $postRes->status = 0;
            echo json_encode($postRes);
        }
    ?>