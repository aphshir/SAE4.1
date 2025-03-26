<?php
declare(strict_types=1);
header('Content-Type: application/json');

require_once "../bdd/connexion.php";

// Fonction pour décoder le JWT
function decodeJWT($jwt) {
    $parts = explode('.', $jwt);
    if (count($parts) !== 3) {
        return null; // Structure du JWT invalide
    }

    // Décodage de la charge utile (payload)
    $payload = base64_decode(strtr($parts[1], '-_', '+/'));

    return json_decode($payload, true);
}

// Récupérer le token envoyé en JSON
$inputJSON = file_get_contents('php://input');
$input = json_decode($inputJSON, true);

if (!isset($input['token'])) {
    echo json_encode(["status" => "error", "message" => "Token JWT manquant."]);
    exit;
}

$decoded = decodeJWT($input['token']);

if ($decoded && isset($decoded['sub'])) {
    echo json_encode(["status" => "success", "userId" => $decoded['sub']]);
} else {
    echo json_encode(["status" => "error", "message" => "Token JWT invalide."]);
}
