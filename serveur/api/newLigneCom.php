<?php 
declare(strict_types=1);

require_once "../bdd/connexion.php";
require_once 'header.php';

// Désactive les notices pour avoir un JSON propre
error_reporting(E_ALL & ~E_NOTICE);

header('Content-Type: application/json');

// Récupère les données JSON
$json_data = file_get_contents('php://input');
$data = json_decode($json_data, true);

$response = [];

try {
    // Vérifie les données requises
    $required = ['id_com', 'id_prod', 'qte_com', 'id_col', 'id_tail'];
    foreach ($required as $field) {
        if (empty($data[$field])) {
            throw new Exception("Le champ $field est manquant");
        }
    }

    // Récupère le prix en fonction de la couleur et taille
    $query = "SELECT 
                COALESCE(cp.prix_base_col, p.prix_base) + COALESCE(tp.prix_base_tail, 0) AS prix_base
              FROM PRODUIT p
              LEFT JOIN col_prod cp ON cp.id_prod = p.id_prod AND cp.id_col = :id_col
              LEFT JOIN tail_prod tp ON tp.id_prod = p.id_prod AND tp.id_tail = :id_tail
              WHERE p.id_prod = :id_prod";

    $stmt = $db->prepare($query);
    $stmt->bindParam(':id_prod', $data['id_prod'], PDO::PARAM_INT);
    $stmt->bindParam(':id_col', $data['id_col'], PDO::PARAM_INT);
    $stmt->bindParam(':id_tail', $data['id_tail'], PDO::PARAM_INT);
    $stmt->execute();

    $prix = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$prix) {
        throw new Exception("Produit non trouvé");
    }

    // Calcule le prix total avec TVA (20%)
    $prix_total = $prix['prix_base'] * $data['qte_com'] * 1.2;

    // Insertion dans DETAIL_COM
    $query = "INSERT INTO DETAIL_COM
              (id_com, id_prod, qte_com, id_col, id_tail, prix_total)
              VALUES
              (:id_com, :id_prod, :qte_com, :id_col, :id_tail, :prix_total)";

    $stmt = $db->prepare($query);
    $stmt->bindParam(':id_com', $data['id_com'], PDO::PARAM_INT);
    $stmt->bindParam(':id_prod', $data['id_prod'], PDO::PARAM_INT);
    $stmt->bindParam(':qte_com', $data['qte_com'], PDO::PARAM_INT);
    $stmt->bindParam(':id_col', $data['id_col'], PDO::PARAM_INT);
    $stmt->bindParam(':id_tail', $data['id_tail'], PDO::PARAM_INT);
    $stmt->bindParam(':prix_total', $prix_total);

    if (!$stmt->execute()) {
        throw new Exception("Erreur lors de l'insertion");
    }

    $response = [
        'status' => 'success',
        'message' => 'Ligne de commande ajoutée',
        'data' => [
            'id_com' => $data['id_com'],
            'id_prod' => $data['id_prod'],
            'prix_total' => $prix_total
        ]
    ];

} catch (Exception $e) {
    $response = [
        'status' => 'error',
        'message' => $e->getMessage(),
        'data' => null
    ];
}

echo json_encode($response);