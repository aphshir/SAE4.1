const divRecherche = document.querySelectorAll(".recherche")[0];
const barreRecherche = document.createElement("input");
const boutonRechercher = document.createElement("input");
const selectCategorie = document.createElement("select");
const selectCouleur = document.createElement("select");
const selectTaille = document.createElement("select");

const maps = await fillMaps();
const tailleByCategorie = maps[0];
const couleurByCategorie = maps[1];

barreRecherche.setAttribute("type", "text");
barreRecherche.setAttribute("placeholder", "Rechercher des produits...");
barreRecherche.style.setProperty("color", "black", "!important");
boutonRechercher.setAttribute("type", "button");
boutonRechercher.setAttribute("value", "Rechercher");
boutonRechercher.classList.add("form_button");

const searchValue = new URLSearchParams(window.location.search).get("search");

barreRecherche.value = searchValue ? searchValue.replaceAll("+", " ") : "";
barreRecherche.classList.add("col-xl-7");
barreRecherche.classList.add("col-sm-12");
selectCategorie.classList.add("col-xl-2");
selectCategorie.classList.add("col-sm-4");
selectCouleur.classList.add("col-xl-1");
selectCouleur.classList.add("col-sm-4");
selectTaille.classList.add("col-xl-1");
selectTaille.classList.add("col-sm-4");
boutonRechercher.classList.add("col-xl-1");
boutonRechercher.classList.add("col-sm-12");

divRecherche.style.backgroundColor = "#f0f0f0"; 
divRecherche.style.padding = "10px"; 
divRecherche.style.borderRadius = "5px"; 

barreRecherche.style.backgroundColor = "#ffffff"; 
selectCategorie.style.backgroundColor = "#ffffff";
selectCouleur.style.backgroundColor = "#ffffff";
selectTaille.style.backgroundColor = "#ffffff";
boutonRechercher.style.backgroundColor = "#d9534f"; 
boutonRechercher.style.color = "white"; 

barreRecherche.style.border = "1px solid black"; 
barreRecherche.style.borderRadius = "5px"; 

async function getInfoProd() {
    return await fetch(
        "../../serveur/api/getGenericProduits.php", {
            method: "POST",
        }
    ).then((reponse) => reponse.json());
}

async function fillMaps() {
    var tailleByCategorie = new Map();
    var couleurByCategorie = new Map();
    const produits = (await getInfoProd()).data;

    produits.forEach((produit) => {
        if (tailleByCategorie.has(produit.id_cat)) {
            const categorie = tailleByCategorie.get(produit.id_cat);
            if (!categorie.includes(produit.id_tail)) {
                categorie.push(produit.id_tail);
            }
            tailleByCategorie.set(produit.id_cat, categorie);
        } else {
            tailleByCategorie.set(produit.id_cat, [produit.id_tail]);
        }
    });

    produits.forEach((produit) => {
        if (couleurByCategorie.has(produit.id_cat)) {
            const categorie = couleurByCategorie.get(produit.id_cat);
            if (!categorie.includes(produit.id_coul)) {
                categorie.push(produit.id_coul);
            }
            couleurByCategorie.set(produit.id_cat, categorie);
        } else {
            couleurByCategorie.set(produit.id_cat, [produit.id_coul]);
        }
    });    
    return [couleurByCategorie, tailleByCategorie];
}

fetchSpecification(
    selectCategorie,
    "../../serveur/api/getCategories.php",
    "Catégorie",
    "idCategorie"
);

fetchSpecification(
    selectCouleur,
    "../../serveur/api/getCouleurs.php",
    "Couleur",
    "idCouleur"
);

fetchSpecification(
    selectTaille,
    "../../serveur/api/getTailles.php",
    "Taille",
    "idTaille"
);

divRecherche.appendChild(barreRecherche);
divRecherche.appendChild(selectCategorie);
divRecherche.appendChild(selectCouleur);
divRecherche.appendChild(selectTaille);
divRecherche.appendChild(boutonRechercher);

barreRecherche.addEventListener("keydown", (event) => {
    if (event.keyCode === 13) {
        event.preventDefault();
        rechercher();
    }
});
boutonRechercher.addEventListener("click", (e) => {
    e.preventDefault();
    rechercher();
});

function rechercher() {
    const searchQuery = traiterChaine(barreRecherche);
    const idCategorie = selectCategorie.value ? selectCategorie.value : ""; // Si la catégorie est vide, on la met comme vide
    const idCouleur = selectCouleur.value ? selectCouleur.value : ""; // Si la couleur est vide, on la met comme vide
    const idTaille = selectTaille.value ? selectTaille.value : ""; // Si la taille est vide, on la met comme vide

    let url = window.location.href.split("?")[0] + "?search=" + searchQuery;

    if (idCategorie) {
        url += "&idCategorie=" + idCategorie;
    }
    if (idCouleur) {
        url += "&idCouleur=" + idCouleur;
    }
    if (idTaille) {
        url += "&idTaille=" + idTaille;
    }

    window.location.href = url;
}



function fetchSpecification(select, url, default_name, searchParam) {
    return fetch(url)
        .then((reponse) => reponse.json())
        .then((data) => {
            ajouterOptions(select, data.data, default_name, searchParam);
        })
        .catch((error) => console.log(error));
}

function ajouterOptions(select, data, default_name, searchParam) {
    const searchParams = new URLSearchParams(window.location.search);

    let option = document.createElement("option");
    option.value = "";
    option.text = default_name;
    select.add(option, null);
    data.forEach((type) => {
        type = Object.values(type);
        const selected = parseInt(searchParams.get(searchParam)) == type[0];
        let option = document.createElement("option");
        option.value = type[0];
        option.text = type[1];
        option.selected = selected;
        select.add(option, null);
    });
}

function removeAll(selectBox) {
    while (selectBox.options.length > 0) {
        selectBox.remove(0);
    }
}

function traiterChaine(barreRecherche) {
    let chaine = barreRecherche;
    if (chaine.value.includes("  ")) {
        chaine.value = chaine.value.replaceAll("  ", " ");
        return traiterChaine(chaine);
    } else return chaine.value.replaceAll(" ", "+");
}

selectCategorie.addEventListener("change", (e) => {
    e.preventDefault();
    fetch("../../serveur/api/getProduits.php")
        .then((reponse) => reponse.json().then((data) => {
            const prod_cat = data.data.filter((produit) => produit.id_cat == selectCategorie.value);
            let couleur = [];
            let taille = [];
            prod_cat.forEach((produit) => {
                couleur.push(produit.id_coul);
                taille.push(produit.id_tail);
            });
            couleur = couleur.filter((v, i, a) => a.indexOf(v) === i);
            taille = taille.filter((v, i, a) => a.indexOf(v) === i);
            fetch("../../serveur/api/getCouleurs.php").then((reponse) => reponse.json().then((data) => {
                const nom_couleur = data.data.filter((couleur) => couleur.id_col && couleur.id_col !== "");
                selectCouleur.innerHTML = "";
                ajouterOptions(selectCouleur, nom_couleur, "Couleur", "idCouleur");

                if (couleur.length > 0) {
                    selectCouleur.value = couleur[0];
                }
            }));
            fetch("../../serveur/api/getTailles.php").then((reponse) => reponse.json().then((data) => {
                const nom_tail = data.data.filter((taille) => taille.id_tail && taille.id_tail !== "");
                selectTaille.innerHTML = "";
                ajouterOptions(selectTaille, nom_tail, "Taille", "idTaille");

                if (taille.length > 0) {
                    selectTaille.value = taille[0]; 
                }
            }));
        }));
});

