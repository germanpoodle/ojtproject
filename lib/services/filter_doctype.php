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
  die(json_encode(array('error' => 'Connection failed: ' . $conn->connect_error)));
}

$sql = "SELECT DISTINCT doc_type FROM tbl_gl_cdb_list";
$result = $conn->query($sql);

$dropdownOptions = [];

if ($result->num_rows > 0) {
  while($row = $result->fetch_assoc()) {
    $dropdownOptions[] = $row['doc_type'];
  }
} else {
  echo json_encode(array('error' => 'No results found'));
}

$conn->close();

echo json_encode($dropdownOptions);
?>
