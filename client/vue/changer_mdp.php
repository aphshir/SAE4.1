<!DOCTYPE html>
<html lang="fr">

<?php
    require_once '../../serveur/api/verifier_cookie.php';

    $user = verifier_utilsateur();

    if (!$user) {
        header('Location: connexion.php');
        exit();
    }
?>

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../css/style.css">
    <title>Modifier le mot de passe - PM2</title>
</head>

<body>
    <header id="printHeader"></header>

    <form>
        <label for="nouveauMdp">Entrez votre nouveau mot de passe</label>
        <input type="password" id="nouveauMdp" placeholder="password"></input>
        <span id="mdpErreur1">Le mot de passe doit contenir au moins 8 caractères</span>
        <span id="mdpErreur2">Le mot de passe doit contenir au moins un majuscule</span>
        <span id="mdpErreur3">Le mot de passe doit contenir au moins un minuscule</span>
        <span id="mdpErreur4">Le mot de passe doit contenir au moins un caractère spéciale</span>
        <span id="mdpErreur5">Le mot de passe doit contenir au moins un nombre</span>

        <label for="confirmation">Confirmer votre mot de passe</label>
        <input type="password" id="confirmation" placeholder="confirmation"></input>
        <span id="confirmationErreur" style="display: none;">Les mots de passe ne correspondent pas</span>
        <input type="submit" id="envoie" value="Confirmer" class="form_button">
    </form>

    <footer id="printFooter"></footer>
</body>


<script src="https://code.jquery.com/jquery-3.6.3.min.js" integrity="sha256-pvPw+upLPUjgMXY0G+8O0xUf+/Im1MZjXxxgOcBQBXU=" crossorigin="anonymous"></script>
<script type="module" src="../controleur/changerMDP.js"></script>
<!-- <script type="module" src="../controleur/function.js"></script> -->

</html>