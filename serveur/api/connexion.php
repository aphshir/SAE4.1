<?php
require_once '../bdd/connexion.php';
require_once 'header.php';

define("SECRET_KEY", "monSuperSecret123!"); // Clé secrète pour signer le cookie

$json = [];

// Vérifier que les champs sont bien remplis
if (!isset($_POST['login']) || !isset($_POST['mdp'])) {
    $json["status"] = "error";
    $json["message"] = "Tous les champs doivent être remplis.";
    echo json_encode($json);
    exit;
}

// Requête pour récupérer l’utilisateur
$query = "SELECT id_us, mdp FROM USER WHERE login = :login";
$res = $db->prepare($query);
$res->bindParam(':login', $_POST['login']);

try {
    $res->execute();
    $user = $res->fetch();

    if ($user && password_verify($_POST['mdp'], $user['mdp'])) {
        // Génération d'un token HMAC pour éviter la modification du cookie
        $id_user = $user['id_us'];
        $signature = hash_hmac('sha256', $id_user, SECRET_KEY); // Créer une signature

        setcookie("id_us", "$id_user:$signature", [
            'expires' => time() + 10800,  // Expire dans 3 heures
            'path' => "/",
            'httponly' => true, // Empêche l'accès au cookie via JavaScript
            'secure' => true, // Utiliser uniquement en HTTPS
            'samesite' => 'Strict' // Protection CSRF
        ]);

        $json["status"] = "success";
        $json["message"] = "Connexion réussie";
    } else {
        $json["status"] = "failed";
        $json["message"] = "Identifiants incorrects";
    }
} catch (Exception $exception) {
    $json["status"] = "error";
    $json["message"] = $exception->getMessage();
}

echo json_encode($json);
?>
