<?php
declare(strict_types=1);

require_once "../bdd/connexion.php";
require_once 'header.php';

header('Content-Type: application/json');  // Important pour que le client sache que la réponse est du JSON

$json = [];

// Vérification des paramètres POST
if (!isset($_POST["nom"]) || !isset($_POST["prenom"]) || !isset($_POST["mel"]) || !isset($_POST["date_naiss"]) || !isset($_POST["login"]) || !isset($_POST["mdp"])) {
    $json["status"] = "error";
    $json["message"] = "Tous les champs doivent être remplis";
    echo json_encode($json);
    exit;
}

// Hash du mot de passe avec password_hash() (utilise bcrypt)
$password = password_hash($_POST["mdp"], PASSWORD_BCRYPT);

// Préparation de la requête d'insertion
$query = "
INSERT INTO user
(`id_us`, `nom_us`, `prenom_us`, `mel`, `date_naiss`, `login`, `mdp`, `salt`, `id_perm`)
VALUES
(NULL, :nom, :prenom, :mel, :date_naiss, :login, :mdp, :salt, 2)";

$res = $db->prepare($query);

// Le mot de passe est déjà hashé, donc pas besoin de salt supplémentaire
$res->bindValue(':nom', $_POST['nom']);  // bindValue au lieu de bindParam
$res->bindValue(':prenom', $_POST['prenom']);  // bindValue au lieu de bindParam
$res->bindValue(':mel', $_POST['mel']);  // bindValue au lieu de bindParam
$res->bindValue(':date_naiss', $_POST['date_naiss']);  // bindValue au lieu de bindParam
$res->bindValue(':login', $_POST['login']);  // bindValue au lieu de bindParam
$res->bindValue(':mdp', $password);  // bindValue pour éviter le problème de référence
$res->bindValue(':salt', '');  // Vous pouvez laisser le salt vide si vous utilisez password_hash()

try {
    $res->execute();
    $json["status"] = "success";
    $json["message"] = "Insertion réussie";
} catch (Exception $exception) {
    $json["status"] = "error";
    $json["message"] = $exception->getMessage();
}

echo json_encode($json);
?>
