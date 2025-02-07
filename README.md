# SAE4.1
Répertoire de la sae

# Règles de protection des branches
Pourquoi je peux pas merge dans Main?

Le merge direct dans main n'est pas aurorisé car il représente la version qui sera taggé. **Le main doit être prore est de préférence fonctionnel au moment du tag**

Pour travailer sur le code merci d'utiliser la branche dev. Quand le code sera jugé acceptable pour être taggé merci de faire une PR (Pull request) et de le merge d'ici. Pour l'instant l'approbation n'est pas nécéssaire. Donc il est possible de directement push sur main après un PR.

Cette règle est présente pour éviter de push du code de mauvaise qualité et potentiellement non-fonctionnel sur Main. Que ça soit par erreure ou volontairement. (c'est surtout par erreur)
