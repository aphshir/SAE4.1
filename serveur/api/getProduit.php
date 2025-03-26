<?php declare(strict_types=1);

require_once "./verifier_cookie.php";
require_once "../bdd/connexion.php";
require_once 'header.php';

$user = verifier_utilsateur();

$json = [];

if ($user) {
    $query = "
    SELECT p.*, 
           CASE WHEN f.id_us IS NOT NULL THEN 1 ELSE 0 END AS est_favori
    FROM SELECT_PRODUITS p
    LEFT JOIN favori f ON p.id_prod = f.id_prod AND f.id_us = :id_us
    WHERE p.id_prod = :id_prod";
    
    $res = $db->prepare($query);
    $res->bindParam(":id_prod", $_POST["id_prod"]);
    $res->bindParam(":id_us", $user['id_us']);
} else {
    $query = "
    SELECT *, 0 AS est_favori
    FROM SELECT_PRODUITS
    WHERE id_prod = :id_prod";
    
    $res = $db->prepare($query);
    $res->bindParam(":id_prod", $_POST["id_prod"]);
}

try {
    $res->execute();
    $json["status"] = "success";
    $json["message"] = "Sélection réussie";
    $json["data"] = $res->fetchAll(PDO::FETCH_ASSOC);

} catch(Exception $exception) {
    $json["status"] = "error";
    $json["message"] = $exception->getMessage();
    $json["data"] = [];
}


echo json_encode($json);