import { cookieValue } from './function.js'; // Assure-toi que le chemin est correct

document.getElementById("form-infos").addEventListener("submit", async function(event) {
    event.preventDefault(); // Empêche le rechargement de la page

    // Récupérer les informations saisies par l'utilisateur
    const nom = document.getElementById("nom").value;
    const prenom = document.getElementById("prenom").value;
    const adresse = document.getElementById("adresse").value;
    const ville = document.getElementById("ville").value;
    const codePostal = document.getElementById("codePostal").value;

    // Vérifiez si toutes les informations sont valides
    if (!nom || !prenom || !adresse || !ville || !codePostal) {
        alert("Veuillez remplir tous les champs.");
        return;
    }

    // Fonction de calcul des frais de port
    function calculerFraisDePort(codePostal) {
        const fraisDePortStandard = 5; // Frais de port pour les commandes en dehors de la France
        const fraisDePortGratuit = 0; // Frais de port pour les commandes en France
        const codePostalFrance = "57"; // Code postal de Metz (où l'entreprise est située)

        let fraisPort = 0;

        // Vérification du code postal pour savoir si c'est en France (ici uniquement Metz)
        if (codePostal.startsWith(codePostalFrance)) {
            fraisPort = fraisDePortGratuit; // Livraison gratuite pour Metz
        } else {
            fraisPort = fraisDePortStandard; // Autres zones
        }

        return fraisPort;
    }

    try {
        // Récupérer le prixTotal de l'URL de la page actuelle
        const urlParams = new URLSearchParams(window.location.search);
        const prixTotalFromUrl = parseFloat(urlParams.get('prixTotal')); // Récupérer prixTotal de l'URL

        // Vérifier si prixTotal existe dans l'URL
        if (isNaN(prixTotalFromUrl)) {
            alert("Erreur : Prix total non trouvé dans l'URL.");
            return;
        }

        // Calcul des frais de port
        const fraisPort = calculerFraisDePort(codePostal);

        // Vérifier que cookieValue existe avant de l'utiliser
        if (!cookieValue) {
            alert("Erreur : Vous n'êtes pas connecté.");
            return;
        }

        // Rediriger vers la page de paiement avec les paramètres nécessaires
        window.location.href = `../vue/paiement.html?fraisPort=${fraisPort}&prixTotal=${prixTotalFromUrl.toFixed(2)}&id_us=${cookieValue}`;

    } catch (error) {
        console.error("Erreur lors de la récupération des informations : ", error);
        alert("Une erreur est survenue.");
    }
});
