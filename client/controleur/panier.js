import { cookieValue } from "./function.js";
let prixTotal = 0

if (cookieValue === undefined) {
    window.location.href = 'login.html'; //Si le cookie est vide, l'utilisateur n'est pas connecté donc on retourne à l'accueil.
}

async function getPanier(id_us) {
    return fetch("../../serveur/api/getPanier.php", {
            method: "POST",
            body: new URLSearchParams({
                id_us: id_us,
            }),
        })
        //.then(reponse => console.log(reponse.json()))
        .then(reponse => reponse.json());
}

async function getProduit(id_produit) {
    return fetch("../../serveur/api/getProduit.php", {
        method: "POST",
        body: new URLSearchParams({
            id_prod: id_produit,
        }),
    });
}

function findId(id, array) {
    let test = null;
    array.forEach((element) => {
        if (element.id == id) {
            test = element;
        }
    });
    return test;
}

function delButton(id) {

    const test = findId(id, document.querySelectorAll(".del"))
        //console.log(test)

    test.addEventListener("click", (e) => {
        const id_prod = e.target.id.split("|")[0];
        const id_col = e.target.id.split("|")[1];
        const id_tail = e.target.id.split("|")[2];
        // console.log(e.target.id)
        // console.log(id_prod, id_col, id_tail);
        fetch("../../serveur/api/delPanier.php", {
            method: "POST",
            body: new URLSearchParams({
                id_us: id_us,
                id_prod: id_prod,
                id_col: id_col,
                id_tail: id_tail,
            }),
        }).then((response) => {
            response.json().then((json) => {
                if (json.status !== "success") {
                    console.log("suppression échouée");
                    return;
                }
                console.log("suppression réussie");
                appelPanier();
            });
        });
    });
}

function modifButton(id) {
    const button = findId(id, document.querySelectorAll(".mod"));

    button.addEventListener("click", (e) => {
        // Récupérer l'id du produit, de la couleur et de la taille à partir de l'ID du bouton
        const id_prod = e.target.id.split("|")[0];
        const id_col = e.target.id.split("|")[1];
        const id_tail = e.target.id.split("|")[2];

        // Récupérer la quantité actuelle depuis l'input
        const qte_pan = document.getElementById(id).value;
        
        // Vérification que la quantité est valide
        if (isNaN(qte_pan) || qte_pan <= 0) {
            alert("Veuillez entrer une quantité valide !");
            return;
        }

        let new_id_col = null;
        let new_id_tail = null;

        // Récupérer la couleur sélectionnée
        const colorSelect = document.getElementById(`couleur${id}`);
        colorSelect.querySelectorAll("option").forEach((element) => {
            if (element.selected) {
                new_id_col = element.id;
            }
        });

        // Récupérer la taille sélectionnée (si elle existe)
        if (document.getElementById(`taille${id}`) === null) {
            new_id_tail = 17; // valeur par défaut si pas de taille
        } else {
            const sizeSelect = document.getElementById(`taille${id}`);
            sizeSelect.querySelectorAll("option").forEach((element) => {
                if (element.selected) {
                    new_id_tail = element.id;
                }
            });
        }

        console.log(`Modifier le panier avec :
        Produit ID: ${id_prod},
        Couleur ID: ${new_id_col},
        Taille ID: ${new_id_tail},
        Quantité : ${qte_pan}`);

        // Envoi des nouvelles données au serveur pour mise à jour du panier
        fetch("../../serveur/api/setPanier.php", {
            method: "POST",
            body: new URLSearchParams({
                id_us: id_us,
                id_prod: id_prod,
                id_col: id_col,
                id_tail: id_tail,
                qte_pan: qte_pan,
                new_id_col: new_id_col,
                new_id_tail: new_id_tail,
            }),
        }).then((response) => {
            response.json().then((json) => {
                if (json.status !== "success") {
                    alert("Modification échouée");
                    appelPanier();  // Recharger le panier pour synchroniser l'affichage
                    return;
                }

                console.log("Modification réussie");
                appelPanier();  // Recharger le panier après la modification réussie
            });
        }).catch((error) => {
            console.log("Erreur lors de la modification du panier", error);
        });
    });
}


function rempliSelect(select, array, arrayId, def) {
    array = array.filter((value, index) => array.indexOf(value) === index);
    arrayId = arrayId.filter((value, index) => arrayId.indexOf(value) === index);
    array.forEach((element) => {
        const option = document.createElement("option");
        option.id = arrayId[array.indexOf(element)];
        if (element == def) {
            option.selected = true;
        }
        option.value = element;
        option.innerHTML = element;
        select.appendChild(option);
    });
}

function casNulltaill(id, panier) {
    if (panier === 17) {
        return ""
    }
    return `<select  id="taille${id}"></select>`
}

function affichePanier(panier, qte, taille, couleur, couleurId, tailleId) {
    const prix = document.getElementById("prixTotal");
    const panierDiv = document.createElement("div");
    panierDiv.classList.add("panierElement");
    const id = `${panier.id_prod}|${panier.id_col}|${panier.id_tail}`
        //console.log(panier)
    panierDiv.innerHTML = `

        <center><img id="img${id}" src="../../serveur/img/articles/${panier.path_img}" alt="image du produit"></center>
        <p>${panier.nom_prod}</p>
        <div id="select">
            <select  id="couleur${id}"></select>
            ${casNulltaill(id, panier.id_tail)}
        </div> 
        <center>
            <div id="input_qte">Quantité : <input class="qte" id="${id}" type="number" value="${qte}"></div>
            <p id="prix">Prix : ${Math.round(panier.prix_unit * qte * 100) / 100}€</p>
            <div id="button">
                <button class="mod form_button" id="${id}">Modifier</button>
                <button class="del form_button" id="${id}">Supprimer</button>
            </div>
        </center>
        `;
    document.getElementById("panier").appendChild(panierDiv);

    delButton(id);
    modifButton(id);
    rempliSelect(document.getElementById(`couleur${id}`), couleur, couleurId, panier.nom_col);
    panier.id_tail !== 17 ? rempliSelect(document.getElementById(`taille${id}`), taille, tailleId, panier.nom_tail) : casNulltaill(id, panier.id_tail);
    prix.innerHTML = (Math.round((parseFloat(prix.innerHTML) + panier.prix_unit * qte) * 100) / 100);
    document.getElementById(`couleur${id}`).addEventListener("change", (e) => {
        getProduit(panier.id_prod).then((response) => {
            response.json().then(BDDproduit => {
                BDDproduit.data.forEach((element) => {
                    if (element.nom_col === e.target.value) {
                        document.getElementById(`img${id}`).src = `../../serveur/img/articles/${element.path_img}`
                    }
                })
            })
        });
    });
}

async function appelPanier() {
    document.getElementById("panier").innerHTML = "";
    document.getElementById("prixTotal").innerHTML = 0;

    getPanier(id_us).then((panier) => {
        if (panier.data.length !== 0) {
            document.getElementById("footer").style.display = "block";
        } else {
            document.getElementById("footer").style.display = "none";
            const section = document.createElement("section");
            section.classList.add("accueil");
            const rien = document.createElement("h1");
            rien.innerHTML = "Votre panier est vide";
            section.appendChild(rien);
            document.getElementById("panier").appendChild(section);
            document.getElementById("panier").id = "accueil";
        }

        let total = 0;
        panier.data.forEach((produit) => {
            getProduit(produit.id_prod).then((response) => {
                let couleur = [];
                let couleurId = [];
                let taille = [];
                let tailleId = [];

                response.json().then((BDDproduits) => {
                    BDDproduits.data.forEach((BDDproduit) => {
                        if (BDDproduit.id_prod == produit.id_prod) {
                            couleur.push(BDDproduit.nom_col);
                            taille.push(BDDproduit.nom_tail);
                            couleurId.push(BDDproduit.id_col);
                            tailleId.push(BDDproduit.id_tail);
                        }
                    });

                    BDDproduits.data.forEach((BDDproduit) => {
                        if (BDDproduit.id_col == produit.id_col && BDDproduit.id_tail == produit.id_tail) {
                            affichePanier(BDDproduit, produit.qte_pan, taille, couleur, couleurId, tailleId);
                            total += Math.round(BDDproduit.prix_unit * produit.qte_pan * 100) / 100;
                        }
                    });
                    document.getElementById("prixTotal").innerHTML = total;
                    prixTotal = total
                });
            });
        });
    });
}

/*document.getElementById("payer").addEventListener("click", async () => {
    const response = await fetch("../../serveur/api/payer.php", { method: "POST" })
        
    const data = await response.json();

    if (data.status == "success") {
        console.log("paiement réussi");
        const responsePanier = await fetch("../../serveur/api/clearPanier.php", { method: "POST" });

        const dataPanier = await responsePanier.json()

        if (dataPanier.status == "success") {
            console.log("suppression réussie");
            appelPanier();
            window.location.href = "accueil.html";
        } else {
            console.log("suppression échouée");
        }

    } else {
        console.log("paiement échoué");
        console.info(data);
    }

});*/

document.getElementById("payer").addEventListener("click", async () => {
    // Vérifiez si l'utilisateur est connecté
    if (cookieValue === undefined) {
        window.location.href = 'login.html'; // Si l'utilisateur n'est pas connecté, on le redirige vers la page de connexion
        return;
    }

    // Récupérer la valeur du prix total affichée dans l'élément #prixTotal
    const prixTotal = parseFloat(document.getElementById("prixTotal").innerHTML);

    // Rediriger vers la page des informations personnelles avec le prix total dans l'URL
    window.location.href = `../vue/informations-personnelles.html?prixTotal=${prixTotal.toFixed(2)}&id_us=${cookieValue}`;
});





const id_us = cookieValue; // A changer en cookieValue

appelPanier()