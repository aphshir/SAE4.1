let id_user = -1;
let form = document.querySelector("form");
let msgErreur = document.querySelector("#MessageErreur");

msgErreur.style.display = "none";
msgErreur.style.backgroundColor = "red";
msgErreur.style.color = "white";
msgErreur.style.fontSize = "16px";
msgErreur.style.padding = "10px";
msgErreur.style.marginBottom = "10px";
msgErreur.style.borderRadius = "5px";
msgErreur.style.textAlign = "center";
msgErreur.style.justifyContent = "center";

async function authentifier() {
    // Get all the user input value
    const login = document.querySelector("#login").value;
    const password = document.querySelector("#motdepasse").value;

    // Check if value is empty
    if (!login || !password) {
        msgErreur.innerHTML = "Remplissez tous les champs !";
        msgErreur.style.display = "block";
        setTimeout(() => {
            msgErreur.style.display = "none";
        }, 10000);

        return;
    }

    // Send the data to the server
    const reponse = await fetch(
        "../../serveur/api/connexion.php", {
            method: "POST",
            body: new URLSearchParams({
                login: login,
                mdp: password,
            }),
        }
    );

    const data = await reponse.json();
    console.log("M : ", data.message);
    console.log("Data : ", data);

    if (data.status === "success") {

        let date_expiration = new Date();
        date_expiration.setTime(date_expiration.getTime() + (1 * 60 * 60 * 1000));

        window.location.href = "accueil.html";
        return;
    }

    // Echec
    msgErreur.innerHTML = data.message;
    msgErreur.style.display = "block";
    setTimeout(() => {
        msgErreur.style.display = "none";
    }, 10000);
}