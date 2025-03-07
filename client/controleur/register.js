let form = document.querySelector('form');
let msgErreur = document.getElementById("MessageErreur");
const mdpErreurs = document.querySelectorAll('span[id^="mdpErreur"]');

let mdpOK = false;
let melOK = false;

mdpErreurs.forEach((mdpErreur) => {
    mdpErreur.style.display = "none";
});

msgErreur.style.display = "none";
msgErreur.style.backgroundColor = "red";
msgErreur.style.color = "white";
msgErreur.style.fontSize = "16px";
msgErreur.style.padding = "10px";
msgErreur.style.marginBottom = "10px";
msgErreur.style.borderRadius = "5px";
msgErreur.style.textAlign = "center";
msgErreur.style.justifyContent = "center";

document.getElementById("mel").addEventListener("input", (e) => {
    let mel_conforme = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    let msgErreurMail = document.getElementById("melErreur");
    melOK = mel_conforme.test(document.getElementById("mel").value);

    if (melOK) {
        msgErreurMail.style.color = "green";
        msgErreurMail.innerHTML = "Adresse mail conforme";
    } else {
        msgErreurMail.style.color = "red";
        msgErreurMail.innerHTML = "Adresse mail non conforme";
    }
});

document.getElementById("mdp").addEventListener("input", (e) => {
    mdpErreurs.forEach((mdpErreur) => {
        mdpErreur.style.display = "block";
    });

    let testLg = /.{8,}/;
    let testMaj = /[A-Z]/;
    let testMin = /[a-z]/;
    let testCar = /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/;
    let testNb = /[0-9]/;

    let valeurTester = document.getElementById("mdp").value;
    mdpOK = testLg.test(valeurTester) && testMaj.test(valeurTester) && testMin.test(valeurTester) && testCar.test(valeurTester) && testNb.test(valeurTester);
    console.log(mdpOK);

    if (testLg.test(valeurTester)) mdpErreurs[0].style.color = "green";
    else {
        mdpErreurs[0].style.color = "red";
    }

    if (testMaj.test(valeurTester)) mdpErreurs[1].style.color = "green";
    else {
        mdpErreurs[1].style.color = "red";
    }

    if (testMin.test(valeurTester)) mdpErreurs[2].style.color = "green";
    else {
        mdpErreurs[2].style.color = "red";
    }

    if (testCar.test(valeurTester)) mdpErreurs[3].style.color = "green";
    else {
        mdpErreurs[3].style.color = "red";
    }

    if (testNb.test(valeurTester)) mdpErreurs[4].style.color = "green";
    else {
        mdpErreurs[4].style.color = "red";
    }
});

function register() {
    let erreur = 0;

    const inputs = document.querySelectorAll('form input[type="text"], form input[type="password"], form input[type="date"]');
    const values = [];

    inputs.forEach((input) => {
        values.push(input.value.trim());
        if (input.value.trim() === "") {
            erreur++;
        }
    });

    if (erreur !== 0) {
        msgErreur.innerHTML = "Remplissez tous les champs !";
        msgErreur.style.display = "block";
        setTimeout(() => {
            msgErreur.style.display = "none";
        }, 10000);
        return;
    }

    if (!melOK || !mdpOK) {
        msgErreur.innerHTML = "Votre mot de passe ou votre adresse mail n'est pas conforme !";
        msgErreur.style.display = "block";
        setTimeout(() => {
            msgErreur.style.display = "none";
        }, 10000);
        return;
    }

    // Vérification de la date de naissance
    const dateNaiss = new Date(values[5]);
    const today = new Date();
    const minDate = new Date(today.getFullYear() - 16, today.getMonth(), today.getDate());

    if (dateNaiss >= today) {
        msgErreur.innerHTML = "La date de naissance ne peut pas être aujourd'hui ou dans le futur !";
        msgErreur.style.display = "block";
        setTimeout(() => {
            msgErreur.style.display = "none";
        }, 10000);
        return;
    }

    if (dateNaiss > minDate) {
        msgErreur.innerHTML = "Vous devez avoir au moins 16 ans pour vous inscrire !";
        msgErreur.style.display = "block";
        setTimeout(() => {
            msgErreur.style.display = "none";
        }, 10000);
        return;
    }

    // Vérif si l'email existe déjà
    fetch('https://devweb.iutmetz.univ-lorraine.fr/~lutz53u/BUT2/SAE4.1/serveur/api/checkEmail.php', {
        method: 'POST',
        body: new URLSearchParams({
            mel: values[4]
        }),
    })
    .then(response => response.json())
    .then(data => {
        if (data.exists) {
            msgErreur.innerHTML = "L'adresse mail existe déjà !";
            msgErreur.style.display = "block";
            setTimeout(() => {
                msgErreur.style.display = "none";
            }, 10000);
        } else {
            const user = { nom: values[0], prenom: values[1], login: values[2], mdp: values[3], mel: values[4], date_naiss: values[5] }
            console.log(user);
            fetch('https://devweb.iutmetz.univ-lorraine.fr/~lutz53u/SAE4.1/serveur/api/newUser.php', {
                    method: 'POST',
                    body: new URLSearchParams({
                        nom: user.nom,
                        prenom: user.prenom,
                        login: user.login,
                        mdp: user.mdp,
                        mel: user.mel,
                        date_naiss: user.date_naiss,
                    }),
                })
                .then(response => response.json())
                .then(data => {
                    console.log(data);
                    if (data.status == 'success') {
                        // L'Authentification a réussi
                        fetch('https://devweb.iutmetz.univ-lorraine.fr/~lutz53u/SAE4.1/serveur/api/connexion.php', {
                            method: 'POST',
                            body: new URLSearchParams({
                                login: user.login,
                                mdp: user.mdp,
                            }),
                        }).then(response => response.json().then(data => {

                            let date_expiration = new Date();
                            date_expiration.setTime(date_expiration.getTime() + (1 * 60 * 60 * 1000));
                            document.cookie = "id_user=" + data.id_us + ";expires=" + date_expiration.toUTCString() + ";path=/";

                            window.location.href = 'accueil.html';
                            return;
                        }));
                    }

                    // Echec
                    msgErreur.innerHTML = data.message;
                    msgErreur.style.display = "block";
                    setTimeout(() => {
                        msgErreur.style.display = "none";
                    }, 10000);
                })
                .catch(error => {
                    msgErreur.innerHTML = "Une erreur serveur est survenue.";
                    msgErreur.style.display = "block";
                    setTimeout(() => {
                        msgErreur.style.display = "none";
                    }, 10000);
                });
        }
    })
    .catch(error => {
        msgErreur.innerHTML = "Une erreur serveur est survenue.";
        msgErreur.style.display = "block";
        setTimeout(() => {
            msgErreur.style.display = "none";
        }, 10000);
    });
};

document.querySelector('form').addEventListener('submit', (e) => {
    e.preventDefault();
    register();
});

document.getElementById("togglePassword").addEventListener("click", function () {
    const passwordField = document.getElementById("mdp");
    const type = passwordField.getAttribute("type") === "password" ? "text" : "password";
    passwordField.setAttribute("type", type);
    this.classList.toggle("fa-eye-slash");
});