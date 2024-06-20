<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header('Content-Type: application/json');

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "db_approval";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$response = array('status' => 'error', 'message' => 'File upload failed.');

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_FILES['file'])) {
    if ($_FILES['file']['error'] !== UPLOAD_ERR_OK) {
        $response['message'] = 'File upload failed with error code: ' . $_FILES['file']['error'];
    } else {
        $target_dir = "uploads/";
        $target_file = $target_dir . basename($_FILES['file']['name']);

        if (move_uploaded_file($_FILES['file']['tmp_name'], $target_file)) {
            // Prepare and bind
            $stmt = $conn->prepare("INSERT INTO tbl_gl_cdb_list (path_file) VALUES (?)");
            $stmt->bind_param("s", $target_file);

            // Execute the statement
            if ($stmt->execute()) {
                $response['status'] = 'success';
                $response['message'] = 'File uploaded and database updated successfully.';
            } else {
                $response['message'] = 'File uploaded but failed to update database.';
            }

            // Close the statement
            $stmt->close();
        } else {
            $response['message'] = 'Failed to move uploaded file.';
        }
    }
} else {
    $response['message'] = 'No file uploaded or invalid request.';
}

// Close the connection
$conn->close();

echo json_encode($response);
?>
