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
        $issueAtt = time();
        $expirationTime = $issueAtt + 10800; // Expire dans 3 heures

        $header = [
            'alg' => 'HS256',
            'typ' => 'JWT'
        ];

        $payload = [
            'iss' => 'SAE4.1',
            'sub' => $id_user,
            'iat' => $issueAtt,
            'exp' => $expirationTime
        ];

        $base64UrlHeader = str_replace(['+', '/', '='], ['-', '_', ''], base64_encode(json_encode($header)));
        $base64UrlPayload = str_replace(['+', '/', '='], ['-', '_', ''], base64_encode(json_encode($payload)));

        $signature = hash_hmac('sha256', $base64UrlHeader. "." . $base64UrlPayload, SECRET_KEY);
        $base54UrlSignature = str_replace(['+', '/', '='], ['-', '_', ''], base64_encode($signature));

        $jwt = $base64UrlHeader . "." . $base64UrlPayload . "." . $signature;

        setcookie("jwt", $jwt, [
            'expires' => $expirationTime,
            'path' => '/',
            'domain' => 'localhost',
            'secure' => false,
            'httponly' => false,
            'samesite' => 'Strict'
        ]);

        $json["status"] = "success";
        $json["message"] = "Connexion réussie";
        $json["jwt"] = $jwt;
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
