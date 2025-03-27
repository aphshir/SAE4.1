<?php declare(strict_types=1);

require_once "../bdd/connexion.php";
require_once 'header.php';

// Récupérer le numéro de page (par défaut 1)
$page = isset($_GET['page']) ? (int)$_GET['page'] : 1;
$limit = 10; // Nombre de produits par page
$offset = ($page - 1) * $limit;

$query = "SELECT * FROM `SELECT_PRODUITS` WHERE 1";

$search = isset($_GET['search']) ? $_GET['search'] : ''; 
$idCategorie = isset($_GET['idCategorie']) ? $_GET['idCategorie'] : null;
$idCouleur = isset($_GET['idCouleur']) ? $_GET['idCouleur'] : null;
$idTaille = isset($_GET['idTaille']) ? $_GET['idTaille'] : null;

if ($search) {
    $query .= " AND `nom_prod` LIKE :search"; 
}

if ($idCategorie) {
    $query .= " AND `id_cat` = :idCategorie";
}

if ($idCouleur) {
    $query .= " AND `id_col` = :idCouleur";
}

if ($idTaille) {
    $query .= " AND `id_tail` = :idTaille";
}

$query .= " GROUP BY id_prod LIMIT :limit OFFSET :offset"; 

$res = $db->prepare($query);

if ($search) {
    $res->bindValue(":search", "%" . $search . "%", PDO::PARAM_STR);
}
if ($idCategorie) {
    $res->bindParam(":idCategorie", $idCategorie, PDO::PARAM_INT);
}
if ($idCouleur) {
    $res->bindParam(":idCouleur", $idCouleur, PDO::PARAM_INT);
}
if ($idTaille) {
    $res->bindParam(":idTaille", $idTaille, PDO::PARAM_INT);
}

$res->bindParam(":limit", $limit, PDO::PARAM_INT);
$res->bindParam(":offset", $offset, PDO::PARAM_INT);

try {
    $res->execute();
    $data["status"] = "success";
    $data["message"] = "Sélection réussie";
    $data["data"] = $res->fetchAll(PDO::FETCH_ASSOC);
    $data["current_page"] = $page;
    $data["items_per_page"] = $limit;
} catch(Exception $exception) {
    $data["status"] = "error";
    $data["message"] = $exception->getMessage();
    $data["data"] = [];
}

echo json_encode($data);
?>