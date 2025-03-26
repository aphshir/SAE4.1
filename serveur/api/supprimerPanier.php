<?php
require_once "../bdd/connexion.php";

header('Content-Type: application/json');
$data = json_decode(file_get_contents("php://input"));

$userId = $data->userId;

$query = "DELETE FROM PANIER WHERE id_us = :userId";
$stmt = $db->prepare($query);
$stmt->bindParam(':userId', $userId);
$stmt->execute();

echo json_encode(['status' => 'success']);
?>
