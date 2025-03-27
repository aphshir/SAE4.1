<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inscription Utilisateur</title>
</head>
<body>
    <h1>Inscription Utilisateur</h1>
    <form action="newUser.php" method="post">
        <label for="nom">Nom :</label>
        <input type="text" id="nom" name="nom" required><br><br>

        <label for="prenom">Prénom :</label>
        <input type="text" id="prenom" name="prenom" required><br><br>

        <label for="mel">Email :</label>
        <input type="email" id="mel" name="mel" required><br><br>

        <label for="date_naiss">Date de Naissance :</label>
        <input type="date" id="date_naiss" name="date_naiss" required><br><br>

        <label for="login">Login :</label>
        <input type="text" id="login" name="login" required><br><br>

        <label for="mdp">Mot de Passe :</label>
        <input type="password" id="mdp" name="mdp" required><br><br>

        <button type="submit">S'inscrire</button>
    </form>
</body>
</html>