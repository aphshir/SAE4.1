<?php
require_once '../bdd/connexion.php';
require_once 'header.php';

$json = [];
$query = "
SELECT mdp, id_us
FROM USER
WHERE login = :login";

$res = $db->prepare($query);

$res->bindParam(':login', $_POST['login']);
try {
    $res->execute();
    $res = $res->fetch();

    if (password_verify($_POST['mdp'], $res['mdp'])) {
        setcookie("id_us", $res['id_us'], 10800 + time());  // 3 heures de validité
        $json["id_us"] = $res['id_us'];
        $json["status"] = "success";
        $json["message"] = "Connexion réussie";
    } else {
        $json["status"] = "failed";
        $json["message"] = "Mauvais mot de passe";
    }
} catch (Exception $exception) {
    $json["status"] = "error";
    $json["message"] = $exception->getMessage();
}

echo json_encode($json);
?>
