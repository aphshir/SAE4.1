<?php
define("SECRET_KEY", "monSuperSecret123!");

function verifier_cookie() {
    if (!isset($_COOKIE['id_us'])) {
        return false;
    }

    list($id_us, $signature) = explode(":", $_COOKIE['id_us'], 2);

    $verif_signature = hash_hmac('sha256', $id_us, SECRET_KEY);
    if (!hash_equals($verif_signature, $signature)) {
        return false;
    }

    return $id_us;
}
?>