<?php declare(strict_types=1);

require_once "../bdd/connexion.php";

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *'); 
header('Access-Control-Allow-Credentials: true');

// Fonction pour décoder le JWT
function decodeJWT($jwt) {
    $parts = explode('.', $jwt);
    if(count($parts) !== 3) {
        return null; // JWT invalide
    }

    $payload = base64_decode(strtr($parts[1], '-_', '+/'));
    return json_decode($payload, true);
}

// Vérifie si le token est en cookie ou en POST
$jwt = $_COOKIE['jwt'] ?? ($_POST['jwt'] ?? null);

if (!$jwt) {
    echo json_encode(["status" => "error", "message" => "Token JWT non trouvé."]);
    exit;
}

$decoded = decodeJWT($jwt);

if (!$decoded || !isset($decoded['sub'])) {
    echo json_encode(["status" => "error", "message" => "Token JWT invalide ou non décodable."]);
    exit;
}

echo json_encode(["status" => "success", "userId" => $decoded['sub']]);
