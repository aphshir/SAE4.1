<?php declare(strict_types=1);

require_once "../bdd/connexion.php";
require_once 'header.php';

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
    $query .= " AND `id_coul` = :idCouleur";
}

if ($idTaille) {
    $query .= " AND `id_tail` = :idTaille";
}

$query .= " GROUP BY id_prod"; 

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

try {
    $res->execute();
    $data["status"] = "success";
    $data["message"] = "Sélection réussie";
    $data["data"] = $res->fetchAll(PDO::FETCH_ASSOC);
} catch(Exception $exception) {
    $data["status"] = "error";
    $data["message"] = $exception->getMessage();
    $data["data"] = "[]";
}

echo json_encode($data);
?>
