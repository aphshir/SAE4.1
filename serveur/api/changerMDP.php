<?php declare(strict_types=1);

require_once "./verifier_cookie.php";
require_once "../bdd/connexion.php";
require_once 'header.php';
$json = [];

$user = verifier_utilsateur();

if (!$user || !isset($_POST["password"]) || empty($_POST["password"])) {
    $json["status"] = "error";
    $json["message"] = "L'identifiant utilisateur et le mot de passe sont requis.";
    echo json_encode($json);
    exit;
}

try {
    $password_hash = password_hash($_POST["password"], PASSWORD_BCRYPT);
    
    $query = "UPDATE `USER` SET `mdp` = :mdp_us WHERE `id_us` = :id_us";
    $res = $db->prepare($query);
    $res->bindParam(':mdp_us', $password_hash);
    $res->bindParam(':id_us', $user['id_us']);
    
    $res->execute();
    
    if ($res->rowCount() > 0) {
        $json["status"] = "success";
        $json["message"] = "Modification du mot de passe réussie";
    } else {
        $json["status"] = "error";
        $json["message"] = "Aucun utilisateur trouvé avec cet identifiant";
    }
} catch(Exception $exception) {
    $json["status"] = "error";
    $json["message"] = $exception->getMessage();
}

echo json_encode($json);