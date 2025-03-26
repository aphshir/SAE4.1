import { cookieValue } from "./function.js";

export class ProduitGenerique extends HTMLElement {
    constructor() {
        super();
        this.attachShadow({ mode: "open" });
    }
    connectedCallback() {
        this.shadowRoot.innerHTML = `
        <style>
        *,
        *::before,
        *::after {
            transition: 200ms;
        }
        a {
            text-decoration: none;
            color: black;
        }
        .img_prod {
            margin: 3%;
            height: 200px;
            width: 95%;
            object-fit: cover;
            border-radius: 4px;
        }
        .etoile{
            width: 20px;
            height: 20px;
        }
        .etoile, .prix {
            display: inline-block;
        }
        .etoile, .prix, label {
            vertical-align: middle;
        }
        .checkbox{
            display: none;
        }
        .descProduit {
            border-radius: 8px;
            background-color: lightgray;
            box-shadow: 3px 3px gray;
        }
        .descProduit:hover {
            box-shadow: 3px 3px green;
            background-color: #5f8755;
        }
        .name {
            margin: 3%;
        }
        .prix {
            height: 20px;
            margin: 0;
        }
        .flex {
            display: flex;
            justify-content: space-between;
            padding: 3%;
        }
        </style>
        <a href="detail_produit.html?id=${this.getAttribute("id")}&id_col=${this.getAttribute("id_col")}" class="descProduit">
        <div class="descProduit">
            <input type="checkbox" class="checkbox" id="ch${this.getAttribute("id")}">
            <div class="flex">
                <label for="ch${this.getAttribute("id")}"><img class="etoile" src='img/icones/star_vide.png'/></label>
                <p class="prix">${this.getAttribute("prix")}€</p>
            </div>
            <p class="name">${this.getAttribute("name")}</p>
            <img class="img_prod" src="${this.getAttribute('path_img')}" alt="${this.getAttribute("path_img")}" />
        </div>
        </a>
        `;
    }
}

customElements.define("produit-generique", ProduitGenerique);

let currentPage = 1;
let isLoading = false;

async function afficherTousLesProduits(page = 1) {
    if (isLoading) return;
    isLoading = true;
    
    const urlParams = new URLSearchParams(window.location.search);
    const taille = urlParams.get("taille");
    const couleur = urlParams.get("idCouleur");
    
    const produitGenerique = "../../serveur/api/getGenericProduits.php";
    const produitComplet = "../../serveur/api/getProduits.php";
    let url = taille || couleur ? produitComplet : produitGenerique;
    
    url += `?page=${page}`;
    
    // Ajouter les autres paramètres existants
    if (urlParams.has('search')) url += `&search=${urlParams.get('search')}`;
    if (urlParams.has('idCategorie')) url += `&idCategorie=${urlParams.get('idCategorie')}`;
    if (urlParams.has('idTaille')) url += `&idTaille=${urlParams.get('idTaille')}`;
    if (urlParams.has('idCouleur')) url += `&idCouleur=${urlParams.get('idCouleur')}`;

    try {
        const response = await fetch(url);
        const data = await response.json();
        
        if (page === 1) {
            // Si c'est la première page, on vide la liste
            document.querySelector(".produits").innerHTML = "";
        }
        
        imprimerTousLesProduits(data.data);
        currentPage = page;
        
        // Vérifier s'il y a plus de produits à charger
        const loadMoreBtn = document.getElementById('load-more');
        if (loadMoreBtn) {
            loadMoreBtn.style.display = data.data.length === 10 ? 'block' : 'none';
        }
    } catch (error) {
        console.error("Erreur lors du chargement des produits:", error);
    } finally {
        isLoading = false;
    }
}

function produitsRecherche(recherche, data) {
    let dejaSortit = [];
    data.forEach((produit) => {
        if (produitContientMot(produit, recherche)) {
            dejaSortit.push(produit);
        }
    });
    data = purgerListeProduit(dejaSortit, data);
    recherche.split(" ").forEach((mot) => {
        data.forEach((produit) => {
            if (produitContientMot(produit, mot) && !dejaSortit.includes(produit)) {
                dejaSortit.push(produit);
            }
        });
    });
    return dejaSortit;
}

function purgerListeProduit(dejaSortit, data) {
    dejaSortit.forEach((produit) => {
        if (data.includes(produit)) {
            data.splice(data.indexOf(produit), 1);
        }
    });
    return data;
}

function produitsCategorie(idCategorie, data) {
    let dejaSortit = [];
    data.forEach((produit) => {
        if (produit.id_cat == idCategorie) dejaSortit.push(produit);
    });
    return dejaSortit;
}

function produitsCouleur(idCouleur, data) {
    let dejaSortit = [];
    data.forEach((produit) => {
        if (produit.id_col == idCouleur) dejaSortit.push(produit);
    });
    return dejaSortit;
}

function produitsTaille(idTaille, data) {
    let dejaSortit = [];
    data.forEach((produit) => {
        if (produit.id_tail == idTaille) dejaSortit.push(produit);
    });
    return dejaSortit;
}

export function imprimerUnProduit(produit) {
    let path = produit["path_img"] ?
        "../../serveur/img/articles/" + produit["path_img"] :
        "https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png";
    
    let produitElement = document.createElement("produit-generique");
    produitElement.classList.add("col-xs-12");
    produitElement.classList.add("col-sm-6");
    produitElement.classList.add("col-md-4");
    produitElement.classList.add("col-lg-3");
    produitElement.classList.add("col-xl-2");
    produitElement.classList.add("descProduit");
    produitElement.setAttribute("name", produit["nom_prod"]);
    produitElement.setAttribute("prix", produit["prix_unit"]);
    produitElement.setAttribute("id", produit["id_prod"]);
    produitElement.setAttribute("id_col", produit["id_col"]);
    produitElement.setAttribute("path_img", path);
    
    return produitElement;
}

function produitContientMot(produit, mot) {
    return produit.nom_prod
        .toLowerCase()
        .normalize("NFD")
        .replace(/[\u0300-\u036f]/g, "")
        .includes(
            mot
            .toLowerCase()
            .normalize("NFD")
            .replace(/[\u0300-\u036f]/g, "")
        );
}

function imprimerTousLesProduits(produits) {
    const urlParams = new URLSearchParams(window.location.search);
    const recherche = urlParams.get("search");
    const categorie = urlParams.get("idCategorie");
    const taille = urlParams.get("idTaille");
    const couleur = urlParams.get("idCouleur");
    const id_us = cookieValue;
    
    if (recherche) {
        produits = produitsRecherche(recherche, produits);
    }
    if (categorie) {
        produits = produitsCategorie(categorie, produits);
    }
    if (taille) {
        produits = produitsTaille(taille, produits);
    }
    if (couleur) {
        produits = produitsCouleur(couleur, produits);
    }

    const produitUniques = {};
    produits.forEach((produit) => {
        if (!produitUniques[produit.id_prod] ||
            (couleur && produit.id_col == couleur)
        ) {
            produitUniques[produit.id_prod] = produit;
        }
    });

    const produitsAfficher = Object.values(produitUniques);
    const listeProd = document.querySelector(".produits");

    produitsAfficher.forEach((produit) => {
        const produitElement = imprimerUnProduit(produit);
        listeProd.appendChild(produitElement);
    });
    
    traiterFavori(id_us);
}

async function getFavori(id_us) {
    try {
        const response = await fetch(
            "../../serveur/api/getFavori.php", {
                method: "POST",
                body: new URLSearchParams({
                    id_us: id_us,
                }),
            }
        );
        return await response.json().then((data) => data.data);
    } catch (error) {
        console.error("Erreur lors de la récupération des favoris:", error);
        return [];
    }
}

function ajouterFavori(event, id_us) {
    fetch(
        "../../serveur/api/newFavori.php", {
            method: "POST",
            body: new URLSearchParams({
                id_us: id_us,
                id_prod: event.target.id.substring(2),
            }),
        }
    ).catch((error) => console.error("Erreur lors de l'ajout aux favoris:", error));
}

function supprimerFavori(event, id_us) {
    fetch(
        "../../serveur/api/delFavori.php", {
            method: "POST",
            body: new URLSearchParams({
                id_us: id_us,
                id_prod: event.target.id.substring(2),
            }),
        }
    ).catch((error) => console.error("Erreur lors de la suppression des favoris:", error));
}

function traiterFavori(id_us) {
    const id_fav = [];
    getFavori(id_us).then((data) => {
        data.forEach((fav) => {
            id_fav.push(fav["id_prod"]);
        });
        
        document.querySelector(".produits").querySelectorAll("produit-generique").forEach((produit) => {
            const checkbox = produit.shadowRoot.querySelector(".checkbox");
            const img = produit.shadowRoot.querySelector("label").querySelector("img");
            
            if (id_fav.includes(parseInt(checkbox.id.substring(2)))) {
                checkbox.checked = true;
                img.src = "img/icones/star_plein.png";
            };
            
            checkbox.addEventListener("click", (event) => {
                if (event.target.checked === true) {
                    ajouterFavori(event, id_us);
                    img.src = "img/icones/star_plein.png";
                } else {
                    supprimerFavori(event, id_us);
                    img.src = "img/icones/star_vide.png";
                }
            });
        });
    });
}

// Fonction pour charger plus de produits
function loadMoreProducts() {
    afficherTousLesProduits(currentPage + 1);
}

// Initialisation au chargement de la page
document.addEventListener('DOMContentLoaded', () => {
    // Création du bouton "Afficher plus"
    const loadMoreBtn = document.createElement('button');
    loadMoreBtn.id = 'load-more';
    loadMoreBtn.textContent = 'Afficher plus de produits';
    loadMoreBtn.className = 'btn btn-primary mt-3 mx-auto d-block';
    loadMoreBtn.style.display = 'none';
    loadMoreBtn.addEventListener('click', loadMoreProducts);
    
    // Ajout du bouton à la page
    const section = document.querySelector('section');
    if (section) {
        section.appendChild(loadMoreBtn);
    }
    
    // Chargement initial des produits
    afficherTousLesProduits(1);
});

// Gestion des changements d'URL (filtres, recherche)
window.addEventListener('popstate', () => {
    currentPage = 1;
    afficherTousLesProduits(1);
});