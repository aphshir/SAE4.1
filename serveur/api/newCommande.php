<?php
declare(strict_types=1);

require_once "../bdd/connexion.php";
require_once 'header.php';

header('Content-Type: application/json');

// Récupérer les données JSON du corps de la requête
$json_data = file_get_contents('php://input');
$data = json_decode($json_data, true);

$response = [];

try {
    // Vérifier si l'ID utilisateur est bien reçu
    if (!isset($data['id_us']) || empty($data['id_us'])) {
        throw new Exception("ID utilisateur manquant");
    }

    $db->beginTransaction();

    $query = "INSERT INTO COMMANDE (`date_com`, `id_us`) VALUES (CURDATE(), :id_us)";
    $res = $db->prepare($query);
    $res->bindParam(":id_us", $data["id_us"], PDO::PARAM_INT);

    if (!$res->execute()) {
        throw new Exception("Erreur lors de l'insertion de la commande");
    }

    $id_com = $db->lastInsertId();
    
    if (!$id_com) {
        throw new Exception("Impossible de récupérer l'ID de la commande");
    }

    $db->commit();

    $response["status"] = "success";
    $response["message"] = "Insertion réussie";
    $response["data"] = ["id_com" => (int)$id_com];
    
} catch (Exception $exception) {
    if ($db->inTransaction()) {
        $db->rollBack();
    }
    
    $response["status"] = "error";
    $response["message"] = $exception->getMessage();
    $response["data"] = null;
}

echo json_encode($response);