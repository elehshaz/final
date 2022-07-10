<?php
if(!isset($_POST)){
    $response = array('status'=> 'failed', 'data'=> null);
    sendJsoonResponse($response);
    die();
}
include_once("dbconnect.php");
$email = $ $_POST['email'];

$sqlloadcart = "SELECT tbl_carts.cart_id, tbl_carts.subject_id, tbl_carts.cart_quantity, tbl_subjects.subject_name, tbl_subjects.subject_price,
tbl_subjects.subject_sessions FROM tbl_carts INNER JOIN tbl_subjects ON tbl_carts.subject_id = tbl_subjects.subject_id
WHERE tbl_carts.user_email = '$email' AND tbl_carts.cart_status IS NULL";

$result = $conn->query($sqlloadcart);
$number_of_result = $result->num_rows;
if($result->num_rows > 0){

    $total_payable =0;
    $carts["cart"] = array();
    while($rows = $result->fetch_assoc()){

        $sblist = array();
        $sblist['cart_id']= $rows['cart_id'];
        $sblist['subject_name']= $rows['cart_id'];
        $subprice = $rows['subject_price'];
        $sblist['subject_sessions']= $rows['subject_sessions'];
        $sblist['subject_price']= number_format((float)$subprice, 2, '.','');
        $sblist['cart_quantity']= $rows['cart_quantity'];
        $sblist['subject_id']= $rows['subject_id'];
        $price = $rows['cart_quantity'] * $subprice;
        $total_payable = $total_payable + $price;
        $sblist['price_total']= number_format((float)$subprice, 2, '.','');
        array_push($carts["cart"],$sblist);

    }
    $response = array('status' => 'success', 'data' => $carts, 'total' => $total_payable);
    sendJsoonResponse($response);
}else{
    $response = array('status' => 'failed', 'data' => null);
    sendJsoonResponse($response);
}

function sendJsoonResponse($sentArray){

    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>
