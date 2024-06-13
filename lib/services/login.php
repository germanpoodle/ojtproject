<?php
$servername = "localhost";
$username = "username"; 
$password = "password"; 
$database = "db_approval";
$port = 3307; //Change according to your port

$conn = new mysqli($servername, $username, $password, $database, $port);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$username = $_POST['username'];
$password = $_POST['password'];

$stmt = $conn->prepare("SELECT * FROM tbl_main_users WHERE username=? AND password=?");
$stmt->bind_param("ss", $username, $password);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    echo "success";
} else {
    echo "failure";
}

$stmt->close();
$conn->close();
?>
