<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header('Content-Type: application/json');

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "db_approval";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$sql = "SELECT * FROM tbl_gl_cdb_list";
$result = $conn->query($sql);

$data = array();
if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $data[] = array(
            'transacting_party' => $row['transacting_party'],
            'doc_type' => $row['doc_type'],
            'doc_no' => $row['doc_no'],
            'trans_type_description' => $row['trans_type_description'],
            'check_amount' => $row['check_amount'],
            'transaction_status' => $row['transaction_status'],
            'remarks' => $row['remarks'],
        );
    }
}

// Close connection
$conn->close();

// Output JSON
header('Content-Type: application/json');
echo json_encode(array('data' => $data));
?>
