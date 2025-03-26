"use strict";

async function printUser() {
    try {
        const User = await getUser();
        console.log("Réponse de l'API:", User);  // Affiche la réponse de l'API

        if (!User.data || User.data.length === 0) {
            throw new Error("Aucune donnée utilisateur trouvée");
        }

        const user_data = User.data[0];

        const id = document.getElementById("id");
        const nom = document.getElementById("nom");
        const prenom = document.getElementById("prenom");
        const mel = document.getElementById("mel");
        const date_naiss = document.getElementById("date_naiss");
        const login = document.getElementById("login");
        const perm = document.getElementById("perm");

        id.innerText += " " + user_data.id_us;
        nom.innerText += " " + user_data.nom_us;
        prenom.innerText += " " + user_data.prenom_us;
        mel.innerText += " " + user_data.mel;
        date_naiss.innerText += " " + user_data.date_naiss;
        login.innerText += " " + user_data.login;
        perm.innerText += " " + user_data.nom_perm;
    } catch (error) {
        console.error("Erreur lors de l'affichage de l'utilisateur:", error);
        const msgErreur = document.getElementById("MessageErreur");
        msgErreur.innerText = "Erreur lors de l'affichage de l'utilisateur : " + error.message;
        msgErreur.style.display = "block";
    }
}

async function getUser() {
    try {
        const response = await fetch('../../serveur/api/getUser.php', {
            method: "POST",
            body: new URLSearchParams({
                id_us: new URLSearchParams(window.location.search).get("id_us") // id_us
            })
        });

        const data = await response.json();
        console.log("Données reçues de l'API:", data);  // Affiche les données reçues de l'API
        return data;
    } catch (error) {
        console.error("Erreur lors de la récupération des données utilisateur:", error);
        throw error;
    }
}

const section = document.getElementById("userInfo");

printUser();