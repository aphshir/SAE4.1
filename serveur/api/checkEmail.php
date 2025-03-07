<?php declare(strict_types=1);

require_once "../bdd/connexion.php";

header('Content-Type: application/json');

$mel = $_POST['mel'];

$query = "SELECT COUNT(*) FROM USER WHERE mel = :mel";
$res = $db->prepare($query);
$res->bindParam(':mel', $mel);
$res->execute();
$emailExists = $res->fetchColumn();

echo json_encode(['exists' => $emailExists > 0]);