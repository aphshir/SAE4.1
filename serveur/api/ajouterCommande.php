<?php
require_once "../bdd/connexion.php";

$data = json_decode(file_get_contents("php://input"));

$userId = $data->userId;
$totalPayer = $data->totalPayer;
$produits = json_decode($data->produits);

try {
    $query = "INSERT INTO COMMANDE (id_user, total, date_commande) VALUES (:userId, :totalPayer, NOW())";
    $stmt = $db->prepare($query);
    $stmt->bindParam(':userId', $userId);
    $stmt->bindParam(':totalPayer', $totalPayer);
    $stmt->execute();

    $orderId = $db->lastInsertId();

    foreach ($produits as $produit) {
        $query = "INSERT INTO DETAIL_COM (id_com, id_prod, qte_com, prix_total) VALUES (:orderId, :id_prod, :qte_com, :prix_total)";
        $stmt = $db->prepare($query);
        $stmt->bindParam(':orderId', $orderId);
        $stmt->bindParam(':id_prod', $produit->id_prod);
        $stmt->bindParam(':qte_com', $produit->qte);
        $stmt->bindParam(':prix_total', $produit->prix);
        $stmt->execute();
    }

    echo json_encode(['status' => 'success', 'orderId' => $orderId]);
} catch (Exception $e) {
    echo json_encode(['status' => 'error', 'message' => $e->getMessage()]);
}
?>
