import { cookieValue, isConnected } from "./function.js";

if (!cookieValue || !isConnected()) {
    window.location.href = 'accueil.html';
} else {
    affInfos();
}

async function affInfos() {
    try {
        const reponse = await fetch("../../serveur/api/getCommandes.php", { method: "POST" });
        const recupDonnees = await reponse.json();
        const tableBody = document.querySelector('#commande tbody');
        const messageContainer = document.getElementById("commandeVide");

        if (recupDonnees.status !== "success" || !recupDonnees.data || recupDonnees.data.length === 0) {
            messageContainer.innerText = "Vous n'avez pas encore passé de commande.";
            return;
        }

        recupDonnees.data.forEach(commande => {
            let ligne = tableBody.insertRow();

            let dateCommande = ligne.insertCell();
            let prixCommande = ligne.insertCell();
            let idCommande = ligne.insertCell();

            dateCommande.textContent = commande.date_com;
            prixCommande.textContent = `${commande.prix_total} €`;

            let btn = document.createElement("button");
            btn.textContent = "Détails";
            btn.classList.add("btn-details");
            btn.addEventListener("click", () => {
                window.location.href = `historique_detail.html?id_com=${commande.id_com}`;
            });

            idCommande.appendChild(btn);
        });
    } catch (error) {
        console.error("Erreur lors de la récupération des commandes :", error);
    }
}
