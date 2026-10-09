<?php
session_start();

$db_host = getenv('DB_HOST') ?: 's3-db';
$db_name = getenv('DB_NAME') ?: 'novaportal';
$db_user = getenv('DB_USER') ?: 'novatech';
$db_pass = getenv('DB_PASS') ?: 'portalpass';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('Location: index.php');
    exit();
}

$username = trim($_POST['username'] ?? '');
$password = trim($_POST['password'] ?? '');

if (empty($username) || empty($password)) {
    header('Location: index.php?error=1');
    exit();
}

try {
    $pdo = new PDO(
        "mysql:host={$db_host};dbname={$db_name};charset=utf8",
        $db_user, $db_pass,
        [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
    );

    $stmt = $pdo->prepare(
        "SELECT id, username, role FROM users
         WHERE username = ? AND password = ? LIMIT 1"
    );
    $stmt->execute([$username, $password]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($user) {
        $_SESSION['logged_in'] = true;
        $_SESSION['username']  = $user['username'];
        $_SESSION['role']      = $user['role'];

        // Vulnerability: OWASP A01 (Broken Access Control)
        // Issues client-controlled cookie defaulting to low-privilege 'guest'
        setcookie("nova_role", "guest", time() + 3600, "/");

        header('Location: dashboard.php');
        exit();
    } else {
        header('Location: index.php?error=1');
        exit();
    }
} catch (PDOException $e) {
    header('Location: index.php?error=1');
    exit();
}