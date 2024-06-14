<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');
header('Content-Type: application/json');

$servername = "localhost";
$username = "root";
$password = "";
$database = "db_approval";
$port = '3307';

$conn = new mysqli($servername, $username, $password, $database, $port);
if ($conn->connect_error) {
    die(json_encode(array('status' => 'error', 'message' => 'Connection failed: ' . $conn->connect_error)));
}

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    exit(0);
}

if (!isset($_POST['username']) || !isset($_POST['password'])) {
    die(json_encode(array('status' => 'error', 'message' => 'Username or password not provided.')));
}

$username = $_POST['username'];
$password = $_POST['password'];

$stmt = $conn->prepare("SELECT * FROM tbl_main_users WHERE username = ? AND password = ?");
$stmt->bind_param("ss", $username, $password);

$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    echo json_encode(array('status' => 'success'));
} else {
    echo json_encode(array('status' => 'error', 'message' => 'Username and password do not match.'));
}

$stmt->close();
$conn->close();
?>
