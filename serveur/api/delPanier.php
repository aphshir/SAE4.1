<?php declare(strict_types=1);

require_once "./verifier_cookie.php";
require_once "../bdd/connexion.php";
require_once 'header.php';

$user = verifier_utilsateur();

$json = [];

$query =
"DELETE FROM PANIER
WHERE id_us = :id_us
AND id_prod = :id_prod
AND id_col = :id_col
AND id_tail = :id_tail";

$res = $db->prepare($query);

$res->bindParam(":id_us", $user["id_us"]);
$res->bindParam(":id_prod", $_POST["id_prod"]);
$res->bindParam(":id_col", $_POST["id_col"]);
$res->bindParam(":id_tail", $_POST["id_tail"]);

try {
    $res->execute();
    $json["status"] = "success";
    $json["message"] = "Suppression réussie";

} catch(Exception $exception) {
    $json["status"] = "error";
    $json["message"] = $exception->getMessage();
}


echo json_encode($json);