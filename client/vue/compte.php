<!DOCTYPE html>
<html lang="fr-fr">

<?php
    require_once '../../serveur/api/verifier_cookie.php';

    $user = verifier_utilsateur();

    if (!$user) {
        header('Location: login.html');
        exit();
    }
?>


<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../css/style.css">
    <title>Compte - PM2</title>
</head>

<body>
    <header id="printHeader"></header>

    <form method="post" action="javascript:afficherInfos()">
        <h2>Informations du compte</h2>

        <label for="nom">Nom : </label>
        <input type="text" id="nom" name="nom" placeholder='Entrez votre nom' maxlength="40" value="<?php echo $user['nom_us'] ?>" disabled>

        <label for="prenom">Prénom : </label>
        <input type="text" id="prenom" name="prenom" placeholder='Entrez votre prenom' maxlength="20" value="<?php echo $user['prenom_us'] ?>" disabled>

        <label for="mel">Mel : </label>
        <input type="text" id="mel" name="mel" placeholder='Entrez votre mail' value="<?php echo $user['mel']?>" disabled>

        <label for="login">Login : </label>
        <input type="text" id="login" name="login" placeholder='Entrez votre login' maxlength="30" value="<?php echo $user['login'] ?>" disabled>

        <label for="date_naiss">Date de naissance : </label>
        <input type="date" id="date_naiss" name="date_naiss" placeholder='Entrez votre date de naissance' value="<?php echo $user['date_naiss'] ?>" disabled>

        <br><br>
        <a href="changer_mdp.php" class="form_button">Changer le mot de passe</a>
        <a href="logout.html" class="form_button">Déconnexion</a>
        <br>
        <span style="width: 100%; margin: 30px;"></span>

    </form>

    <footer id="printFooter"></footer>
</body>

<script src="https://code.jquery.com/jquery-3.6.3.min.js" integrity="sha256-pvPw+upLPUjgMXY0G+8O0xUf+/Im1MZjXxxgOcBQBXU=" crossorigin="anonymous"></script>
<script type="module" src="../controleur/function.js"></script>
<!-- <script type="module" src="../controleur/compte.js"></script> -->

</html>