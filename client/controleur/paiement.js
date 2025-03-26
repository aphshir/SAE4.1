document.addEventListener('DOMContentLoaded', async function () {
    const urlParams = new URLSearchParams(window.location.search);
    const prixTotalProduit = parseFloat(urlParams.get('prixTotal')) || 0;
    const fraisPort = parseFloat(urlParams.get('fraisPort')) || 0;
    const totalPayer = prixTotalProduit + fraisPort;

    // Affichage des informations du panier
    const prixTotalProduitElement = document.getElementById("prixTotalProduit");
    const fraisPortElement = document.getElementById("fraisPort");
    const totalPayerElement = document.getElementById("totalPayer");

    if (prixTotalProduitElement && fraisPortElement && totalPayerElement) {
        prixTotalProduitElement.textContent = prixTotalProduit.toFixed(2) + "€";
        fraisPortElement.textContent = fraisPort.toFixed(2) + "€";
        totalPayerElement.textContent = totalPayer.toFixed(2) + "€";
    }

    // Fonction pour récupérer l'ID utilisateur via JWT stocké en cookie
    async function getUserId() {
        try {
            const response = await fetch('../../serveur/api/getUserId.php', {
                method: 'GET',
                credentials: 'include',
                headers: { 'Content-Type': 'application/json' }
            });

            const data = await response.json();

            if (data.status === "success") {
                return data.userId;
            } else {
                console.error("Erreur récupération ID utilisateur:", data.message);
                return null;
            }
        } catch (error) {
            console.error("Erreur serveur lors de la récupération de l'ID utilisateur:", error);
            return null;
        }
    }

    async function getPanierProduits(userId) {
        try {
            const response = await fetch("../../serveur/api/getPanier.php", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                },
                body: JSON.stringify({ userId: userId })
            });

            if (!response.ok) {
                console.error("Erreur HTTP : ", response.status, response.statusText);
                return [];
            }

            const responseText = await response.text();
            console.log("Réponse brute du serveur:", responseText);

            const panierData = JSON.parse(responseText);

            if (panierData.status === "success" && panierData.data.length > 0) {
                console.log("Produits récupérés du panier:", panierData.data);
                return panierData.data;
            } else {
                console.error("Erreur récupération du panier ou panier vide.");
                return [];
            }
        } catch (error) {
            console.error("Erreur lors de la récupération du panier:", error);
            return [];
        }
    }

    // Créer une commande via newCommande.php
    async function createCommande(userId) {
        const response = await fetch('../../serveur/api/newCommande.php', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ id_us: userId })
        });
    
        const responseText = await response.text();
        console.log("Réponse brute de la création de la commande:", responseText);
    
        let result;
        try {
            result = JSON.parse(responseText);
        } catch (error) {
            console.error("Erreur lors du parsing de la réponse:", error);
            return null;
        }
    
        if (result.status === 'success' && result.data && result.data.id_com) {
            const id_com = result.data.id_com;
            console.log("ID de la commande récupéré:", id_com);
            return id_com;
        } else {
            console.error("Erreur lors de la création de la commande.");
            return null;
        }
    }

    // Supprimer le panier après commande
    async function supprimerPanier(userId) {
        try {
            const response = await fetch('../../serveur/api/supprimerPanier.php', {
                method: 'POST',
                headers: { 
                    'Content-Type': 'application/json',
                    'Accept': 'application/json'
                },
                body: JSON.stringify({ userId: userId })
            });

            const result = await response.json();
            
            if (result.status === 'success') {
                console.log("Panier supprimé avec succès");
                return true;
            } else {
                console.error("Erreur lors de la suppression du panier:", result.message);
                return false;
            }
        } catch (error) {
            console.error("Erreur lors de la suppression du panier:", error);
            return false;
        }
    }

    // Configurer le bouton PayPal
    paypal.Buttons({
        createOrder: (data, actions) => {
            return actions.order.create({
                purchase_units: [{
                    amount: {
                        value: totalPayer.toFixed(2)
                    }
                }]
            });
        },

        onApprove: async (data, actions) => {
            try {
                const details = await actions.order.capture();
                console.log('Paiement effectué par ' + details.payer.name.given_name);

                // Récupérer l'ID utilisateur
                const userId = await getUserId();
                if (!userId) {
                    console.error("Impossible de récupérer l'utilisateur !");
                    return;
                }

                console.log("ID Utilisateur récupéré:", userId);

                // Créer une commande
                const id_com = await createCommande(userId);
                if (!id_com) {
                    console.error("Erreur lors de la création de la commande.");
                    return;
                }

                // Récupérer les produits du panier
                const produits = await getPanierProduits(userId);
                if (produits.length === 0) {
                    console.error("Le panier est vide ou n'a pas pu être récupéré.");
                    return;
                }

                // Insérer les lignes de commande
                let toutesLignesAjoutees = true;
                for (let produit of produits) {
                    const orderResponse = await fetch('../../serveur/api/newLigneCom.php', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({
                            id_com: id_com,
                            id_prod: produit.id_prod,
                            qte_com: produit.qte_pan,
                            id_col: produit.id_col,
                            id_tail: produit.id_tail
                        })
                    });

                    const orderResult = await orderResponse.json();
                    if (orderResult.status !== "success") {
                        console.error("Erreur lors de l'ajout de la ligne de commande.");
                        toutesLignesAjoutees = false;
                    }
                }

                // Si toutes les lignes ont été ajoutées, supprimer le panier
                if (toutesLignesAjoutees) {
                    const panierSupprime = await supprimerPanier(userId);
                    if (!panierSupprime) {
                        console.error("Le panier n'a pas pu être vidé");
                    }
                }

                // Redirection vers la page de remerciements après paiement réussi
                window.location.href = "../vue/remerciements.html";

            } catch (error) {
                console.error("Erreur durant le paiement ou la gestion du panier:", error);
                alert("Une erreur est survenue. Veuillez réessayer ou contacter le support.");
            }
        },

        onError: (err) => {
            alert("Une erreur est survenue pendant le paiement. Veuillez réessayer.");
            console.error(err);
        }
    }).render('#paypal-button-container');
});