<?php
/**
 * EXPO Booth Registration Backend API
 * 
 * This is a sample backend API for demonstration purposes.
 * Replace database credentials with environment variables in production.
 */

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

// Valid booth IDs (A-Q)
$validBoothIds = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q'];

/**
 * Validate booth ID
 */
function isValidBoothId($id) {
    global $validBoothIds;
    return in_array(strtoupper($id), $validBoothIds);
}

/**
 * Database connection
 * IMPORTANT: Use environment variables for credentials in production
 */
function get_connection() {
    // TODO: Replace with environment variables
    $host = getenv('DB_HOST') ?: 'localhost';
    $user = getenv('DB_USER') ?: 'your_db_user';
    $pass = getenv('DB_PASS') ?: 'your_db_password';
    $dbname = getenv('DB_NAME') ?: 'your_database';
    
    $conn = new mysqli($host, $user, $pass, $dbname);
    
    if ($conn->connect_error) {
        echo json_encode([
            'success' => false, 
            'message' => 'Database connection failed'
        ]);
        exit;
    }
    
    $conn->set_charset('utf8mb4');
    return $conn;
}

// Only allow POST requests
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode([
        'success' => false, 
        'message' => 'Only POST requests are allowed'
    ]);
    exit;
}

// Parse JSON input
$input = json_decode(file_get_contents('php://input'), true);
if (!$input) {
    echo json_encode([
        'success' => false, 
        'message' => 'Invalid JSON data'
    ]);
    exit;
}

$action = $input['action'] ?? '';

// ============================================
// ACTION: Check Duplicate
// ============================================
if ($action === 'checkDuplicate') {
    $identifier = trim($input['identifier'] ?? '');
    $boothId = strtoupper($input['boothId'] ?? '');
    
    if ($identifier === '' || $boothId === '') {
        echo json_encode([
            'success' => false, 
            'message' => 'Missing identifier or booth ID',
            'exists' => false
        ]);
        exit;
    }
    
    $conn = get_connection();
    $stmt = $conn->prepare("SELECT 1 FROM tb_participants WHERE identifier = ? AND booth = ? LIMIT 1");
    $stmt->bind_param('ss', $identifier, $boothId);
    $stmt->execute();
    $stmt->store_result();
    $exists = $stmt->num_rows > 0;
    $stmt->close();
    $conn->close();
    
    echo json_encode([
        'success' => true, 
        'exists' => $exists
    ]);
    exit;
}

// ============================================
// ACTION: Get Booth Info
// ============================================
if ($action === 'getBoothInfo') {
    $boothId = strtoupper($input['boothId'] ?? '');
    
    if (!$boothId) {
        echo json_encode([
            'success' => false, 
            'message' => 'Missing booth ID'
        ]);
        exit;
    }
    
    if (!isValidBoothId($boothId)) {
        echo json_encode([
            'success' => false, 
            'message' => 'Invalid booth ID (only A-Q allowed)',
            'validCodes' => $validBoothIds
        ]);
        exit;
    }
    
    $conn = get_connection();
    $stmt = $conn->prepare("SELECT booth_id, booth_name, summary_name FROM tb_booths WHERE booth_id = ?");
    $stmt->bind_param('s', $boothId);
    $stmt->execute();
    $result = $stmt->get_result();
    
    if ($result->num_rows === 0) {
        echo json_encode([
            'success' => false, 
            'message' => 'Booth not found'
        ]);
    } else {
        $row = $result->fetch_assoc();
        echo json_encode([
            'success' => true, 
            'data' => [
                'boothId' => $row['booth_id'],
                'boothName' => $row['booth_name'],
                'summaryName' => $row['summary_name']
            ]
        ]);
    }
    
    $stmt->close();
    $conn->close();
    exit;
}

// ============================================
// ACTION: Register and Visit
// ============================================
if ($action === 'registerAndVisit') {
    $boothId = strtoupper($input['boothId'] ?? '');
    $type = $input['type'] ?? '';
    $identifier = $input['identifier'] ?? '';
    $name = $input['name'] ?? '';
    $contact = $input['contact'] ?? '';
    $privacyConsent = $input['privacyConsent'] ?? false;
    
    if (!$boothId || !$identifier || !$type) {
        echo json_encode([
            'success' => false, 
            'message' => 'Missing required information'
        ]);
        exit;
    }
    
    if (!isValidBoothId($boothId)) {
        echo json_encode([
            'success' => false, 
            'message' => 'Invalid booth ID (only A-Q allowed)',
            'validCodes' => $validBoothIds
        ]);
        exit;
    }
    
    $conn = get_connection();
    
    // Check for duplicate visit
    $stmt = $conn->prepare("SELECT 1 FROM tb_participants WHERE booth = ? AND identifier = ?");
    $stmt->bind_param('ss', $boothId, $identifier);
    $stmt->execute();
    $stmt->store_result();
    
    if ($stmt->num_rows > 0) {
        echo json_encode([
            'success' => false, 
            'message' => 'Already visited this booth'
        ]);
        $stmt->close();
        $conn->close();
        exit;
    }
    $stmt->close();
    
    // Insert new participant record
    $privacyInt = $privacyConsent ? 1 : 0;
    $stmt = $conn->prepare(
        "INSERT INTO tb_participants (booth, identifier, type, name, contact, privacy, created_at) 
         VALUES (?, ?, ?, ?, ?, ?, NOW())"
    );
    $stmt->bind_param('sssssi', $boothId, $identifier, $type, $name, $contact, $privacyInt);
    $ok = $stmt->execute();
    $stmt->close();
    $conn->close();
    
    if ($ok) {
        echo json_encode([
            'success' => true, 
            'message' => 'Registration completed'
        ]);
    } else {
        echo json_encode([
            'success' => false, 
            'message' => 'Database insertion failed'
        ]);
    }
    exit;
}

// ============================================
// ACTION: Get Valid Codes
// ============================================
if ($action === 'getValidCodes') {
    echo json_encode([
        'success' => true, 
        'validCodes' => $validBoothIds,
        'message' => 'Valid codes are A through Q'
    ]);
    exit;
}

// Invalid action
echo json_encode([
    'success' => false, 
    'message' => 'Invalid action'
]);
exit;
?>