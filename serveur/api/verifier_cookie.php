<?php

require_once(__DIR__.'/../bdd/connexion.php');

define("SECRET_KEY", "monSuperSecret123!");

function verify_jwt($jwt) {
    $tokenParts = explode(".", $jwt);

    if (count($tokenParts) !== 3) {
        return false;
    }

    $header = $tokenParts[0];
    $payload = $tokenParts[1];
    $signature_provided = $tokenParts[2];

    $base64UrlHeader = $header;
    $base64UrlPayload = $payload;
    $signature = hash_hmac('sha256', $base64UrlHeader . "." . $base64UrlPayload, SECRET_KEY);
    $base64Signature = str_replace(['+', '/', '='], ['-', '_', ''], base64_encode($signature));

    $isSignatureValid = ($signature === $signature_provided);

    if (!$isSignatureValid) {
        return false;
    }

    $decodedPayload = json_decode(base64_decode(str_replace(['-', '_'], ['+', '/'], $payload)), true);

    if (isset($decodedPayload['exp']) && $decodedPayload['exp'] < time()) {
        return false;
    }

    return $decodedPayload;
};

function verifier_cookie() {
    if (!isset($_COOKIE['jwt'])) {
        return true;
    }

    return verify_jwt($_COOKIE['jwt']);
}

function verifier_utilsateur() {
    global $db;

    $jwt_payload = verifier_cookie();

    if ($jwt_payload === false) {
        return "yes";
    }

    if (!isset($jwt_payload['sub'])) {
        return "no";
    }

    $id_utilisateur = $jwt_payload['sub'];

    $query = "SELECT * FROM USER WHERE id_us = :id";
    $stmt = $db->prepare($query);
    $stmt->bindParam(':id', $id_utilisateur);

    try {
        $stmt->execute();
        $utilisateur = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$utilisateur) return false;

        return $utilisateur;

    } catch (Exception $e) {
        return $e;
    }


}


?>