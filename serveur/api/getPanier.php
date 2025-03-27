<?php declare(strict_types=1);

require_once "./verifier_cookie.php";
require_once "../bdd/connexion.php";
require_once 'header.php';

header('Content-Type: application/json');

$user = verifier_utilsateur();

$json = [];

if (!$user) {
    $json["status"] = "error";
    $json["message"] = "Utilisateur non authentifié ou ID utilisateur invalide.";
    echo json_encode($json);
    exit;
}

// Vérification de l'utilisateur et récupération de son panier
$query = "SELECT * FROM select_paniers WHERE id_us = :id_us";
$res = $db->prepare($query);
$res->bindParam(":id_us", $user["id_us"]);

try {
    $res->execute();
    $data = $res->fetchAll(PDO::FETCH_ASSOC);
    
    // Si aucune ligne n'est trouvée
    if (empty($data)) {
        $json["status"] = "error";
        $json["message"] = "Le panier est vide ou aucun produit trouvé pour cet utilisateur.";
        $json["data"] = [];
    } else {
        $json["status"] = "success";
        $json["message"] = "Sélection réussie.";
        $json["data"] = $data;
    }
} catch(Exception $exception) {
    $json["status"] = "error";
    $json["message"] = "Erreur lors de la récupération du panier : " . $exception->getMessage();
    $json["data"] = [];
}

echo json_encode($json);
