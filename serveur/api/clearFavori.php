<?php declare(strict_types=1);

require_once "./verifier_cookie.php";
require_once "../bdd/connexion.php";
require_once 'header.php';

$user = verifier_utilsateur();

$json = [];

$query =
"DELETE FROM FAVORI
WHERE id_us = :id_us";

$res = $db->prepare($query);
$res->bindParam(":id_us", $user["id_us"]);

try {
    $res->execute();
    $json["status"] = "success";
    $json["message"] = "Suppression réussie";

} catch(Exception $exception) {
    $json["status"] = "error";
    $json["message"] = $exception->getMessage();
}


echo json_encode($json);