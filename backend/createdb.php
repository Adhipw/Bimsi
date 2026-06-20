<?php
$host = '127.0.0.1';
$port = '5432';
$user = 'postgres';
$pass = 'postgres';

try {
    // Connect to the default 'postgres' database first
    $pdo = new PDO("pgsql:host=$host;port=$port;dbname=postgres", $user, $pass);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    // Check if database exists
    $stmt = $pdo->prepare("SELECT 1 FROM pg_database WHERE datname = 'bimsi_ubsi'");
    $stmt->execute();
    if ($stmt->fetchColumn()) {
        echo "Database 'bimsi_ubsi' already exists.\n";
    } else {
        // Create the new database
        $pdo->exec("CREATE DATABASE bimsi_ubsi");
        echo "Database 'bimsi_ubsi' successfully created!\n";
    }
} catch (PDOException $e) {
    echo "Error: " . $e->getMessage() . "\n";
}
