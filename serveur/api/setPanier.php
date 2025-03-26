<?php declare(strict_types=1);

require_once "../bdd/connexion.php";
require_once 'header.php';

$json = [];

// Fonction pour décoder le JWT
function decodeJWT($jwt) {
    $parts = explode('.', $jwt);
    if(count($parts) !== 3) {
        return null; // Structure du JWT invalide
    }

    // Décodez la charge utile du JWT (partie du milieu)
    $payload = base64_decode(strtr($parts[1], '-_', '+/'));

    // Décodez la charge utile JSON en tableau
    return json_decode($payload, true);
}
$jwt = $_POST['id_us'];
$decoded = decodeJWT($jwt);

if ($decoded) {
    $id_us = $decoded['sub'];
} else {
    $json["status"] = "error";
    $json["message"] = "Token JWT invalide ou non décodable.";
    echo json_encode($json);
    exit;
}

error_log("Données reçues : " . json_encode($_POST));

$query = "
    UPDATE panier SET
        qte_pan = :qte_pan,
        id_col = :new_id_col,
        id_tail = :new_id_tail
    WHERE id_us = :id_us
    AND id_prod = :id_prod
    AND id_col = :id_col
    AND id_tail = :id_tail";

error_log("Requête SQL : " . $query);
error_log("Données : id_us = " . $id_us . ", id_prod = " . $_POST["id_prod"] . ", id_col = " . $_POST["id_col"] . ", id_tail = " . $_POST["id_tail"]);

$res = $db->prepare($query);
$res->bindParam(":id_us", $id_us);
$res->bindParam(":id_prod", $_POST["id_prod"]);
$res->bindParam(":qte_pan", $_POST["qte_pan"]);
$res->bindParam(":id_col", $_POST["id_col"]);
$res->bindParam(":id_tail", $_POST["id_tail"]);
$res->bindParam(":new_id_col", $_POST["new_id_col"]);
$res->bindParam(":new_id_tail", $_POST["new_id_tail"]);

try {
    $res->execute();

    $rowsAffected = $res->rowCount();
    if ($rowsAffected > 0) {
        $json["status"] = "success";
        $json["message"] = "Modification réussie";
    } else {
        $json["status"] = "error";
        $json["message"] = "Aucune ligne modifiée. Vérifiez les paramètres de la requête.";
    }
} catch (Exception $exception) {
    $json["status"] = "error";
    $json["message"] = "Erreur lors de l'exécution de la requête : " . $exception->getMessage();
    error_log("Erreur lors de l'exécution de la requête : " . $exception->getMessage());
}

echo json_encode($json);
