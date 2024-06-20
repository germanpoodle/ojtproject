<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header('Content-Type: application/json');

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "db_approval";

// Establish connection to MySQL database
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
  die(json_encode(array('error' => 'Connection failed: ' . $conn->connect_error)));
}

// Get the date from the GET parameter or use the current date
$currentDate = isset($_GET['date_trans']) ? $_GET['date_trans'] : date("Y-m-d");

// Prepare SQL query to fetch transactions for the given date and with doc_type = 'CV'
$sql = "SELECT * FROM tbl_gl_cdb_list WHERE doc_type = 'CV' AND check_date = '$currentDate'";

// Execute SQL query
$result = $conn->query($sql);

// Check if there are results
if ($result->num_rows > 0) {
  // Initialize an array to store all fetched rows
  $transactions = array();

  // Fetch all rows
  while ($row = $result->fetch_assoc()) {
    $transactions[] = $row;
  }
  
  // Output transactions array as JSON
  echo json_encode($transactions);
} else {
  // If no results found, output an empty array
  echo json_encode(array());
}

// Close database connection
$conn->close();
?>
