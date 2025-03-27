-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : jeu. 27 mars 2025 à 13:55
-- Version du serveur : 5.7.36
-- Version de PHP : 7.4.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `sae41`
--

DELIMITER $$
--
-- Procédures
--
DROP PROCEDURE IF EXISTS `DELETE_FAVORI`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `DELETE_FAVORI` (IN `v_id_prod` INT, IN `v_id_us` INT)  NO SQL
BEGIN

DECLARE v_id_prod_existe, v_id_us_existe BOOLEAN;

CALL id_prod_existe(v_id_prod, v_id_prod_existe);
CALL id_us_existe(v_id_us, v_id_us_existe);

IF v_id_prod_existe AND v_id_us_existe THEN

	DELETE FROM FAVORI
    WHERE id_prod = v_id_prod
    AND id_us = v_id_us;
END IF;

END$$

DROP PROCEDURE IF EXISTS `id_cat_existe`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `id_cat_existe` (IN `v_id_cat` INT, OUT `v_id_cat_existe` BOOLEAN)  BEGIN

DECLARE v_id_cat_invalide CONDITION FOR SQLSTATE "45004";
DECLARE error_message VARCHAR(80);

SELECT v_id_cat IN (SELECT id_cat FROM CATEGORIE) INTO v_id_cat_existe;

IF v_id_cat_existe = 0 THEN
    SET error_message := CONCAT("Erreur 45004 : La catégorie n°", v_id_cat, " n'existe pas");
    SIGNAL v_id_cat_invalide SET MYSQL_ERRNO = "45004",
    MESSAGE_TEXT = error_message;
END IF;

END$$

DROP PROCEDURE IF EXISTS `id_col_existe`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `id_col_existe` (IN `v_id_col` INT, OUT `v_id_col_existe` BOOLEAN)  BEGIN

DECLARE v_id_col_invalide CONDITION FOR SQLSTATE "45002";
DECLARE error_message VARCHAR(80);

SELECT v_id_col IN (SELECT id_col FROM COULEUR) INTO v_id_col_existe;

IF v_id_col_existe = 0 THEN
    SET error_message := CONCAT("Erreur 45002 : La couleur n°", v_id_col, " n'existe pas");
    SIGNAL v_id_col_invalide SET MYSQL_ERRNO = "45002",
    MESSAGE_TEXT = error_message;
END IF;

END$$

DROP PROCEDURE IF EXISTS `id_com_existe`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `id_com_existe` (IN `v_id_com` INT, OUT `v_id_com_existe` BOOLEAN)  BEGIN

DECLARE v_id_com_invalide CONDITION FOR SQLSTATE "45005";
DECLARE error_message VARCHAR(80);

SELECT v_id_com IN (SELECT id_com FROM COMMANDE) INTO v_id_com_existe;

IF v_id_com_existe = 0 THEN
    SET error_message := CONCAT("Erreur 45005 : La commande n°", v_id_com, " n'existe pas");
    SIGNAL v_id_com_invalide SET MYSQL_ERRNO = "45005",
    MESSAGE_TEXT = error_message;
END IF;

END$$

DROP PROCEDURE IF EXISTS `id_perm_existe`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `id_perm_existe` (IN `v_id_perm` INT, OUT `v_id_perm_existe` BOOLEAN)  BEGIN

DECLARE v_id_perm_invalide CONDITION FOR SQLSTATE "45007";
DECLARE error_message VARCHAR(80);

SELECT v_id_perm IN (SELECT id_perm FROM PERMISSION) INTO v_id_perm_existe;

IF v_id_perm_existe = 0 THEN
    SET error_message := CONCAT("Erreur 45007 : La permission n°", v_id_perm, " n'existe pas");
    SIGNAL v_id_perm_invalide SET MYSQL_ERRNO = "45007",
    MESSAGE_TEXT = error_message;
END IF;

END$$

DROP PROCEDURE IF EXISTS `id_prod_existe`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `id_prod_existe` (IN `v_id_prod` INT, OUT `v_id_prod_existe` BOOLEAN)  BEGIN

DECLARE v_id_prod_invalide CONDITION FOR SQLSTATE "45001";
DECLARE error_message VARCHAR(80);

SELECT v_id_prod IN (SELECT id_prod FROM PRODUIT) INTO v_id_prod_existe;

IF v_id_prod_existe = 0 THEN
    SET error_message := CONCAT("Erreur 45001 : Le produit n°", v_id_prod, " n'existe pas");
    SIGNAL v_id_prod_invalide SET MYSQL_ERRNO = "45001",
    MESSAGE_TEXT = error_message;
END IF;

END$$

DROP PROCEDURE IF EXISTS `id_tail_existe`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `id_tail_existe` (IN `v_id_tail` INT, OUT `v_id_tail_existe` BOOLEAN)  BEGIN

DECLARE v_id_tail_invalide CONDITION FOR SQLSTATE "45003";
DECLARE error_message VARCHAR(80);

SELECT v_id_tail IN (SELECT id_tail FROM TAILLE) INTO v_id_tail_existe;

IF v_id_tail_existe = 0 THEN
    SET error_message := CONCAT("Erreur 45003 : La taille n°", v_id_tail, " n'existe pas");
    SIGNAL v_id_tail_invalide SET MYSQL_ERRNO = "45003",
    MESSAGE_TEXT = error_message;
END IF;

END$$

DROP PROCEDURE IF EXISTS `id_us_existe`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `id_us_existe` (IN `v_id_us` INT, OUT `v_id_us_existe` BOOLEAN)  BEGIN

DECLARE v_id_us_invalide CONDITION FOR SQLSTATE "45006";
DECLARE error_message VARCHAR(80);

SELECT v_id_us IN (SELECT id_us FROM USER) INTO v_id_us_existe;

IF v_id_us_existe = 0 THEN
    SET error_message := CONCAT("Erreur 45006 : L'user n°", v_id_us, " n'existe pas");
    SIGNAL v_id_us_invalide SET MYSQL_ERRNO = "45006",
    MESSAGE_TEXT = error_message;
END IF;

END$$

DROP PROCEDURE IF EXISTS `INSERT_FAVORI`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `INSERT_FAVORI` (IN `v_id_prod` INT, IN `v_id_us` INT)  NO SQL
    DETERMINISTIC
BEGIN

INSERT INTO FAVORI
(id_prod, id_us)
VALUES
(v_id_prod, v_id_us);

END$$

DROP PROCEDURE IF EXISTS `login_non_existe`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `login_non_existe` (IN `v_login` VARCHAR(20), OUT `v_login_non_existe` BOOLEAN)  NO SQL
BEGIN

DECLARE v_login_invalide CONDITION FOR SQLSTATE "45018";
DECLARE error_message VARCHAR(80);

SELECT v_login IN (SELECT login FROM USER) INTO v_login_non_existe;

IF v_login_non_existe <> 0 THEN
    SET error_message := CONCAT("Erreur 45018 : Le login ", v_login, " existe déjà");
    SIGNAL v_login_invalide SET MYSQL_ERRNO = "45018",
    MESSAGE_TEXT = error_message;
END IF;

END$$

DROP PROCEDURE IF EXISTS `verifier_date`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `verifier_date` (IN `v_date` DATE, OUT `v_date_conforme` BOOLEAN)  BEGIN

DECLARE v_date_superieure CONDITION FOR SQLSTATE "45101";
DECLARE v_date_inferieure CONDITION FOR SQLSTATE "45102";
DECLARE error_message VARCHAR(80);

DECLARE v_now, v_1900 DATE;

SELECT NOW() INTO v_now;

IF v_date > v_now THEN
    SET v_date_conforme := FALSE;

    SET error_message := CONCAT("Erreur 45101 : La date ", v_date, " est supérieure à la date d'aujourd'hui");
    SIGNAL v_date_superieure SET MYSQL_ERRNO = "45101",
    MESSAGE_TEXT = error_message;
END IF;

SELECT MAKEDATE(1900, 1) INTO v_1900;

IF v_date < v_1900 THEN
    SET v_date_conforme := FALSE;

    SET error_message := CONCAT("Erreur 45102 : La date ", v_date, " est trop vieille (< 1900)");
    SIGNAL v_date_inferieure SET MYSQL_ERRNO = "45102",
    MESSAGE_TEXT = error_message;
END IF;

SET v_date_conforme := TRUE;

END$$

DROP PROCEDURE IF EXISTS `verifier_prix`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `verifier_prix` (IN `v_prix` FLOAT, OUT `v_prix_correct` BOOLEAN)  BEGIN

DECLARE v_prix_negatif CONDITION FOR SQLSTATE "45103";
DECLARE error_message VARCHAR(80);

IF v_prix < 0 THEN
    SET v_prix_correct := FALSE;

    SET error_message := CONCAT("Erreur 45103 : Le prix ", v_prix, " ne peut pas être négatif");
    SIGNAL v_prix_negatif SET MYSQL_ERRNO = "45103",
    MESSAGE_TEXT = error_message;
END IF;

SET v_prix_correct := TRUE;

END$$

DROP PROCEDURE IF EXISTS `verifier_qte`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `verifier_qte` (IN `v_qte` INT, OUT `v_qte_correcte` BOOLEAN)  BEGIN

DECLARE v_qte_negative CONDITION FOR SQLSTATE "45104";
DECLARE error_message VARCHAR(80);

IF v_qte < 0 THEN
    SET v_qte_correcte := FALSE;

    SET error_message := CONCAT("Erreur 45104 : La quantité ", v_qte, " ne peut pas être négative");
    SIGNAL v_qte_negative SET MYSQL_ERRNO = "45104",
    MESSAGE_TEXT = error_message;
END IF;

SET v_qte_correcte := TRUE;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `categorie`
--

DROP TABLE IF EXISTS `categorie`;
CREATE TABLE IF NOT EXISTS `categorie` (
  `id_cat` int(11) NOT NULL AUTO_INCREMENT,
  `nom_cat` varchar(30) NOT NULL,
  PRIMARY KEY (`id_cat`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `categorie`
--

INSERT INTO `categorie` (`id_cat`, `nom_cat`) VALUES
(1, 'Bonnet'),
(2, 'Pull'),
(3, 'Gants'),
(4, 'Chaussettes'),
(5, 'Décoration'),
(6, 'Schysautre');

-- --------------------------------------------------------

--
-- Structure de la table `col_prod`
--

DROP TABLE IF EXISTS `col_prod`;
CREATE TABLE IF NOT EXISTS `col_prod` (
  `id_prod` int(11) NOT NULL,
  `id_col` int(11) NOT NULL,
  `prix_base_col` float NOT NULL,
  `path_img` varchar(34) NOT NULL,
  PRIMARY KEY (`id_prod`,`id_col`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `col_prod`
--

INSERT INTO `col_prod` (`id_prod`, `id_col`, `prix_base_col`, `path_img`) VALUES
(6, 12, 10, 'sousGantMagenta.webp'),
(6, 11, 10, 'sousGantCyan.webp'),
(10, 7, 10, 'chaussetteLaineNoir.jpg'),
(10, 5, 10, 'chaussetteLaineBlanc.jpg'),
(9, 13, 17, 'chaussetteHauteOrange.avif'),
(9, 7, 17, 'chaussettes hautes noires.jpg'),
(9, 6, 17, 'chaussetteHauteGris.webp'),
(8, 5, 13, 'chaussettePereNoelblanc.webp'),
(8, 2, 13, 'chaussette de noel.jpg'),
(7, 8, 11, 'gantLaineMarron.webp'),
(7, 7, 11, 'gantLaineNoir.jpg'),
(7, 6, 11, 'gantLaineGris.jpg'),
(7, 2, 11, 'gants en laine rouge.jpg'),
(6, 3, 10, 'sousGantVert.webp'),
(6, 6, 10, 'sousGantGris.webp'),
(6, 5, 10, 'sousGantBlanc.jpg'),
(3, 2, 15, 'pull-moche-noel-renne.jpeg'),
(2, 5, 4, 'bonnetMocheBlanc.webp'),
(2, 3, 4, 'bonnet moche vert.jpg'),
(2, 2, 4, 'BonnetMocheRouge.jpeg'),
(1, 2, 5, 'bonnet noel rouge.jpg'),
(10, 12, 10, 'chaussettelaineMagenta.jpg'),
(10, 10, 10, 'chaussetteLaineRose.webp'),
(10, 6, 10, 'chaussetteLaineGris.jpg'),
(10, 2, 10, 'chaussetteLaineRouge.webp'),
(1, 16, 6, 'bonnetNoelDoré.jpg'),
(7, 3, 11, 'gantLaineVert.jpg'),
(6, 4, 10, 'sousGantBleu.jpg'),
(6, 2, 10, 'sousGantRouge.webp'),
(6, 14, 10, 'sousGantTurquoise.webp'),
(6, 9, 10, 'sousGantViolet.webp'),
(6, 7, 10, 'sous gants noirs.jpg'),
(2, 8, 4, 'bonnetMocheMarron.jpg'),
(5, 7, 10, 'gantSkiNoir.jpg'),
(5, 6, 10, 'gantSkiGris.webp'),
(5, 5, 10, 'gants ski blanc.webp'),
(12, 17, 8.05, 'bouleNoelArgent.jpg'),
(12, 16, 8.4, 'bouleNoelDoré.jpg'),
(12, 5, 7, 'bouleNoelBlanc.jpg'),
(12, 3, 7, 'bouleNoelVert.jpg'),
(12, 2, 7, 'bouleNoelRouge.jpg'),
(12, 1, 7, 'bouleNoelJaune.jpg'),
(14, 5, 70, 'sapinNaturelBlanc.jpg'),
(14, 3, 70, 'sapinNaturelVert.jpg'),
(13, 5, 60, 'sapinPlastiqueBlanc.jpg'),
(13, 3, 60, 'sapinPlastiqueVert.jpg'),
(11, 5, 30, 'girlandeBlanc.jpg'),
(11, 2, 30, 'girlandeRouge.jpg'),
(11, 15, 30, 'girlandeMulti.jpg'),
(4, 7, 30, 'pullLaineNoir.jpg'),
(4, 3, 30, 'pullLaineVert.webp'),
(4, 2, 30, 'pullLaineRouge.jpg'),
(7, 5, 11, 'gantLaineBlanc.webp'),
(9, 5, 17, 'chaussetteHauteBlanc.avif'),
(9, 2, 17, 'chaussetteHauteRouge.jpg'),
(8, 6, 13, 'chaussettePereNoelGris.jpg'),
(10, 15, 10, 'chaussettes laine multicolores.jpg'),
(4, 6, 30, 'pull_laine_blanc.jpg'),
(15, 2, 0, 'pere_noel.png'),
(16, 1, 5, 'bonnetjaune.jpg'),
(17, 1, 5, 'bonnetpompon.jpg'),
(18, 7, 3, 'bonnetnoirsoft.webp'),
(19, 10, 10, 'bonnetcorail.jpg'),
(20, 7, 5, 'bonnetucipompon.jpg'),
(21, 2, 5, 'bonnettechgebo.webp'),
(22, 4, 5, 'bonnetcourt.jpg'),
(23, 4, 5, 'bonnetskateboarding.jpg'),
(24, 7, 5, 'bonnetcp.jpg'),
(25, 7, 5, 'bonnetnike.webp'),
(26, 15, 10, 'bonnetjamaique.webp'),
(27, 8, 3, 'bonnetourson.jpg'),
(28, 15, 15, 'bonnetcrazy.jpeg'),
(29, 7, 5, 'bonnetbeechfield.jpg'),
(30, 7, 5, 'bonnetlarge.webp'),
(31, 6, 5, 'bonnetcarhartt.webp'),
(32, 4, 5, 'bonnetstetson.jpg'),
(33, 7, 5, 'bonnetpolice.jpg'),
(34, 7, 5, 'pullbeer.jpeg'),
(35, 7, 5, 'pullrennebeer.jpeg'),
(36, 2, 5, 'pullcolrond.webp'),
(37, 2, 5, 'pulltorix.png'),
(38, 2, 5, 'pullreims.jpg'),
(39, 2, 5, 'pullnorway.webp'),
(40, 2, 5, 'pullkitsch.jpg'),
(41, 4, 5, 'pulllaine.jpg'),
(42, 4, 5, 'pullfcsm.jpg'),
(43, 3, 5, 'pullste.webp'),
(44, 7, 5, 'pullhumour.webp'),
(45, 4, 5, 'pullpingouin.webp'),
(46, 6, 5, 'pullchat.jpg'),
(47, 4, 5, 'pullpsg.jpg'),
(48, 9, 5, 'pulltfc.jpg'),
(49, 3, 5, 'pullguirlande.jpg'),
(50, 3, 5, 'pullasse.webp'),
(51, 7, 5, 'pulljurassic.jpg'),
(52, 1, 5, 'gantcuir.jpg'),
(53, 4, 5, 'ganttactile.jpg'),
(54, 7, 5, 'gantcoupure.jpg'),
(55, 7, 5, 'gantmontagne.jpg'),
(56, 4, 5, 'gantslegers.jpg'),
(57, 1, 5, 'gantlourds.jpg'),
(58, 6, 5, 'gantstravail.jpg'),
(59, 4, 5, 'gantsetanche.jpg'),
(60, 6, 5, 'gantspoly.jpg'),
(61, 1, 20, 'gantshercule.jpg'),
(62, 1, 5, 'gantsalaska.jpg'),
(63, 7, 5, 'gantsdouble.jpg'),
(64, 2, 5, 'gantsbuckler.jpg'),
(65, 7, 5, 'gantsninja.jpg'),
(66, 4, 5, 'gantbleu.jpg'),
(67, 4, 5, 'gantsnitrile.jpg'),
(68, 1, 3, 'gantsislande.jpg'),
(69, 2, 5, 'chaussettescamiz.jpg'),
(70, 2, 5, 'chaussetteimage.jpg'),
(71, 7, 5, 'chaussettesmari.webp'),
(72, 2, 5, 'chaussettesvacances.webp'),
(73, 2, 5, 'chaussettesfun.webp'),
(74, 2, 3, 'chaussettesmuscle.jpg'),
(75, 2, 3, 'chaussettesclayre.jpg'),
(76, 2, 3, 'chaussetteswinter.jpg'),
(77, 2, 3, 'chaussettesbonhomme.jpg'),
(78, 2, 2, 'chaussettesdrôles.jpg'),
(79, 3, 2, 'chaussetteshistoire.jpg'),
(80, 2, 4, 'chaussetteschaud.png'),
(81, 5, 3, 'chaussettesrennes.jpg'),
(82, 2, 3, 'chaussetteslovely.webp'),
(83, 2, 1, 'chaussettesfeest.jpg'),
(84, 5, 6, 'chaussettesperso.jpg'),
(85, 3, 4, 'chaussettesfantaisie.webp'),
(86, 16, 1, 'deconature.jpg'),
(87, 7, 1, 'sapinbuche.jpg'),
(88, 2, 1, 'perenoel.webp'),
(89, 2, 1, 'perenoellong.jpg'),
(90, 1, 1, 'etoile.jpg'),
(91, 5, 1, 'bougie.jpg'),
(92, 7, 1, 'renne.jpg'),
(93, 2, 1, 'sapinpere.jpg'),
(94, 2, 1, 'bouquet.webp'),
(95, 3, 1, 'guy.webp'),
(96, 2, 1, 'bûche.jpg'),
(97, 8, 1, 'planche.jpg'),
(98, 15, 1, 'cadeaux.jpg'),
(99, 15, 1, 'decotable.jpg'),
(100, 8, 1, 'ange.jpg');

--
-- Déclencheurs `col_prod`
--
DROP TRIGGER IF EXISTS `COL_PROD_BEFORE_INSERT`;
DELIMITER $$
CREATE TRIGGER `COL_PROD_BEFORE_INSERT` BEFORE INSERT ON `col_prod` FOR EACH ROW BEGIN
    DECLARE v_id_prod_existe, v_id_col_existe, v_prix_correct BOOLEAN;

    CALL id_prod_existe(NEW.id_prod, v_id_prod_existe);
    CALL id_col_existe(NEW.id_col, v_id_col_existe);
    CALL verifier_prix(NEW.prix_base_col, v_prix_correct); -- Changé ici
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `commande`
--

DROP TABLE IF EXISTS `commande`;
CREATE TABLE IF NOT EXISTS `commande` (
  `id_com` int(11) NOT NULL AUTO_INCREMENT,
  `date_com` date NOT NULL,
  `id_us` int(11) NOT NULL,
  PRIMARY KEY (`id_com`)
) ENGINE=MyISAM AUTO_INCREMENT=79 DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `commande`
--

INSERT INTO `commande` (`id_com`, `date_com`, `id_us`) VALUES
(78, '2025-03-26', 21),
(77, '2025-03-26', 21),
(76, '2025-03-26', 21),
(75, '2025-03-26', 21),
(74, '2025-03-26', 21),
(73, '2025-03-26', 21),
(72, '2025-03-26', 21);

--
-- Déclencheurs `commande`
--
DROP TRIGGER IF EXISTS `COMMANDE_BEFORE_INSERT`;
DELIMITER $$
CREATE TRIGGER `COMMANDE_BEFORE_INSERT` BEFORE INSERT ON `commande` FOR EACH ROW BEGIN

DECLARE v_id_us_existe, v_date_conforme BOOLEAN;

CALL id_us_existe(NEW.id_us, v_id_us_existe);
CALL verifier_date(NEW.date_com, v_date_conforme);

END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `COMMANDE_BEFORE_UPDATE`;
DELIMITER $$
CREATE TRIGGER `COMMANDE_BEFORE_UPDATE` BEFORE UPDATE ON `commande` FOR EACH ROW BEGIN

DECLARE v_id_us_existe, v_date_conforme BOOLEAN;

CALL id_us_existe(NEW.id_us, v_id_us_existe);
CALL verifier_date(NEW.date_com, v_date_conforme);

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `couleur`
--

DROP TABLE IF EXISTS `couleur`;
CREATE TABLE IF NOT EXISTS `couleur` (
  `id_col` int(11) NOT NULL AUTO_INCREMENT,
  `nom_col` varchar(20) NOT NULL,
  PRIMARY KEY (`id_col`)
) ENGINE=MyISAM AUTO_INCREMENT=18 DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `couleur`
--

INSERT INTO `couleur` (`id_col`, `nom_col`) VALUES
(1, 'Jaune'),
(2, 'Rouge'),
(3, 'Vert'),
(4, 'Bleu'),
(5, 'Blanc'),
(6, 'Gris'),
(7, 'Noir'),
(8, 'Marron'),
(9, 'Violet'),
(10, 'Rose'),
(11, 'Cyan'),
(12, 'Magenta'),
(13, 'Orange'),
(14, 'Turquoise'),
(15, 'Multicolore'),
(16, 'Doré'),
(17, 'Argenté');

-- --------------------------------------------------------

--
-- Structure de la table `detail_com`
--

DROP TABLE IF EXISTS `detail_com`;
CREATE TABLE IF NOT EXISTS `detail_com` (
  `id_com` int(11) NOT NULL,
  `id_prod` int(11) NOT NULL,
  `id_col` int(11) NOT NULL,
  `id_tail` int(11) NOT NULL,
  `qte_com` int(11) NOT NULL,
  `prix_total` float NOT NULL,
  PRIMARY KEY (`id_com`,`id_prod`,`id_col`,`id_tail`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `detail_com`
--

INSERT INTO `detail_com` (`id_com`, `id_prod`, `id_col`, `id_tail`, `qte_com`, `prix_total`) VALUES
(78, 5, 5, 1, 2, 48),
(77, 7, 2, 1, 2, 52.8),
(76, 1, 2, 17, 1, 12),
(75, 9, 2, 12, 1, 40.8),
(74, 9, 2, 12, 1, 40.8),
(73, 5, 5, 1, 1, 24),
(73, 4, 2, 1, 1, 72);

--
-- Déclencheurs `detail_com`
--
DROP TRIGGER IF EXISTS `DETAIL_COM_BEFORE_INSERT`;
DELIMITER $$
CREATE TRIGGER `DETAIL_COM_BEFORE_INSERT` BEFORE INSERT ON `detail_com` FOR EACH ROW BEGIN

DECLARE v_id_com_existe, v_id_prod_existe, v_id_col_existe, v_id_tail_existe, v_prix_correct, v_qte_correcte BOOLEAN;

CALL id_com_existe(NEW.id_com, v_id_com_existe);
CALL id_prod_existe(NEW.id_prod, v_id_prod_existe);
CALL id_col_existe(NEW.id_col, v_id_col_existe);
CALL id_tail_existe(NEW.id_tail, v_id_tail_existe);
CALL verifier_prix(NEW.prix_total, v_prix_correct);
CALL verifier_qte(NEW.qte_com, v_qte_correcte);

END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `DETAIL_COM_BEFORE_UPDATE`;
DELIMITER $$
CREATE TRIGGER `DETAIL_COM_BEFORE_UPDATE` BEFORE UPDATE ON `detail_com` FOR EACH ROW BEGIN

DECLARE v_id_com_existe, v_id_prod_existe, v_id_col_existe, v_id_tail_existe, v_prix_correct, v_qte_correcte BOOLEAN;

CALL id_com_existe(NEW.id_com, v_id_com_existe);
CALL id_prod_existe(NEW.id_prod, v_id_prod_existe);
CALL id_col_existe(NEW.id_col, v_id_col_existe);
CALL id_tail_existe(NEW.id_tail, v_id_tail_existe);
CALL verifier_prix(NEW.prix_total, v_prix_correct);
CALL verifier_qte(NEW.qte_com, v_qte_correcte);

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `favori`
--

DROP TABLE IF EXISTS `favori`;
CREATE TABLE IF NOT EXISTS `favori` (
  `id_us` int(11) NOT NULL,
  `id_prod` int(11) NOT NULL,
  PRIMARY KEY (`id_us`,`id_prod`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `favori`
--

INSERT INTO `favori` (`id_us`, `id_prod`) VALUES
(7, 2),
(7, 12),
(11, 1),
(11, 2),
(11, 7),
(11, 12),
(11, 15),
(16, 8),
(16, 10),
(16, 12),
(18, 8),
(18, 12);

--
-- Déclencheurs `favori`
--
DROP TRIGGER IF EXISTS `FAVORI_BEFORE_INSERT`;
DELIMITER $$
CREATE TRIGGER `FAVORI_BEFORE_INSERT` BEFORE INSERT ON `favori` FOR EACH ROW BEGIN

DECLARE v_id_prod_existe, v_id_us_existe BOOLEAN;

CALL id_prod_existe(NEW.id_prod, v_id_prod_existe);
CALL id_us_existe(NEW.id_us, v_id_us_existe);

END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `FAVORI_BEFORE_UPDATE`;
DELIMITER $$
CREATE TRIGGER `FAVORI_BEFORE_UPDATE` BEFORE UPDATE ON `favori` FOR EACH ROW BEGIN

DECLARE v_id_prod_existe, v_id_us_existe BOOLEAN;

CALL id_prod_existe(NEW.id_prod, v_id_prod_existe);
CALL id_us_existe(NEW.id_us, v_id_us_existe);

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `panier`
--

DROP TABLE IF EXISTS `panier`;
CREATE TABLE IF NOT EXISTS `panier` (
  `id_us` int(11) NOT NULL,
  `id_prod` int(11) NOT NULL,
  `id_col` int(11) NOT NULL,
  `id_tail` int(11) NOT NULL,
  `qte_pan` int(11) NOT NULL,
  PRIMARY KEY (`id_us`,`id_prod`,`id_col`,`id_tail`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `panier`
--

INSERT INTO `panier` (`id_us`, `id_prod`, `id_col`, `id_tail`, `qte_pan`) VALUES
(21, 1, 2, 17, 1);

--
-- Déclencheurs `panier`
--
DROP TRIGGER IF EXISTS `PANIER_BEFORE_INSERT`;
DELIMITER $$
CREATE TRIGGER `PANIER_BEFORE_INSERT` BEFORE INSERT ON `panier` FOR EACH ROW BEGIN

DECLARE v_id_us_existe, v_id_prod_existe, v_id_col_existe, v_id_tail_existe, v_qte_correcte BOOLEAN;

CALL id_us_existe(NEW.id_us, v_id_us_existe);
CALL id_prod_existe(NEW.id_prod, v_id_prod_existe);
CALL id_col_existe(NEW.id_col, v_id_col_existe);
CALL id_tail_existe(NEW.id_tail, v_id_tail_existe);
CALL verifier_qte(NEW.qte_pan, v_qte_correcte);

END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `PANIER_BEFORE_UPDATE`;
DELIMITER $$
CREATE TRIGGER `PANIER_BEFORE_UPDATE` BEFORE UPDATE ON `panier` FOR EACH ROW BEGIN

DECLARE v_id_us_existe, v_id_prod_existe, v_id_col_existe, v_id_tail_existe, v_qte_correcte BOOLEAN;

CALL id_us_existe(NEW.id_us, v_id_us_existe);
CALL id_prod_existe(NEW.id_prod, v_id_prod_existe);
CALL id_col_existe(NEW.id_col, v_id_col_existe);
CALL id_tail_existe(NEW.id_tail, v_id_tail_existe);
CALL verifier_qte(NEW.qte_pan, v_qte_correcte);

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `permission`
--

DROP TABLE IF EXISTS `permission`;
CREATE TABLE IF NOT EXISTS `permission` (
  `id_perm` int(11) NOT NULL AUTO_INCREMENT,
  `nom_perm` varchar(15) NOT NULL,
  `num_grade` int(11) NOT NULL,
  PRIMARY KEY (`id_perm`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `permission`
--

INSERT INTO `permission` (`id_perm`, `nom_perm`, `num_grade`) VALUES
(1, 'Administrateur', 0),
(2, 'Client', 1);

-- --------------------------------------------------------

--
-- Structure de la table `produit`
--

DROP TABLE IF EXISTS `produit`;
CREATE TABLE IF NOT EXISTS `produit` (
  `id_prod` int(11) NOT NULL AUTO_INCREMENT,
  `SKU` varchar(50) DEFAULT NULL,
  `nom_prod` varchar(50) NOT NULL,
  `description` varchar(700) NOT NULL,
  `prix_base` float NOT NULL,
  `id_cat` int(11) NOT NULL,
  PRIMARY KEY (`id_prod`)
) ENGINE=MyISAM AUTO_INCREMENT=101 DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `produit`
--

INSERT INTO `produit` (`id_prod`, `SKU`, `nom_prod`, `description`, `prix_base`, `id_cat`) VALUES
(1, 'BO-001', 'Bonnet du père noël', 'Un bonnet du père noël classique, bien pour se déguiser et apporter la bonne ambiance.', 5, 1),
(2, 'BO-002', 'Bonnet moche de noël', 'Un bonnet pas très beau, mais qui fait l\'affaire pour se réchauffer', 4, 1),
(3, 'PU-001', 'Pull de rennes', 'Un pull avec un rennes dessus, un indémodable', 15, 2),
(4, 'PU-002', 'Pull en laine', 'Un pull en laine très sobre, très confortable, très cosy', 30, 2),
(5, 'GA-001', 'Gants de ski', 'Des gants adaptés à tous types de neige, de pluie ou d\'intempéries diverses', 10, 3),
(6, 'GA-002', 'Sous-gants', 'Des sous-gants adaptés au gants de ski, très léger et qui tiennent chaud', 10, 3),
(7, 'GA-003', 'Gants en laine', 'Gants en laine adaptés à n\'importe quel besoin', 11, 3),
(8, 'CH-001', 'Chaussettes du père noël', 'Des chaussettes conviviales pour cacher les cadeaux et mettre près de la cheminée', 13, 4),
(9, 'CH-002', 'Chaussettes hautes', 'Chaussettes idéales pour se maintenir au chaud en toute circonstance', 17, 4),
(10, 'CH-003', 'Chaussettes en laine', 'Des chaussettes classiques mais néanmoins pratiques', 10, 4),
(11, 'DE-001', 'Guirlande lumineuse', 'Une guirlande sympatique pour égayer les réveillons de noël', 30, 5),
(12, 'DE-002', 'Boules de noël', 'Des boules variées à accrocher à votre sapin', 7, 5),
(13, 'DE-005', 'Sapin en plastique', 'Un sapin de noël passe partout, sans la corvée du ménage', 60, 5),
(14, 'SC-003', 'Sapin de Noël naturel', 'Un sapin de noël naturel, avec les épines qui tombent et la déforestation qui va avec', 70, 5),
(15, 'DE-004', 'Le père noël', 'Un père noël à la mode, visiblement trop cool pour ce monde. La légende dit qu\'il fait trembler internet lui-même. Il est si fort qu\'il a pu se battre contre Chuck Norris et Rambo en même temps et il a gagné tout en distribuant ses cadeaux. Il est tellement puissant qu\'on ne peut pas lui attribuer de prix. Et si on ne peut pas lui attribuer de prix, c\'est que c\'est gratuit.', 0, 6),
(24, 'BO-011', 'Bonnet CP', 'Bonnet CP Company en laine', 5, 1),
(16, 'BO-003', 'Bonnet jaune', 'Un bonnet jaune basique', 6, 1),
(17, 'BO-004', 'Bonnet pompon enfant', 'Un bonnet avec un pompon sur le dessus, conçu pour les enfants', 10, 1),
(18, 'BO-005', 'Bonnet noir soft', 'Un bonnet noir soft', 15, 1),
(19, 'BO-006', 'Bonnet corail', 'Un bonnet corail avec un pompon', 10, 1),
(20, 'BO-007', 'Bonnet UCI Pompon', 'Bonnet officiel UCI avec un pompon', 20, 1),
(21, 'BO-008', 'Bonnet technique GEBO', 'Bonnet technique de la marque GEBO', 15, 1),
(22, 'BO-009', 'Bonnet Court', 'Un bonnet court en laine', 10, 1),
(23, 'BO-010', 'Bonnet skateboarding', 'Un bonnet de skateboarding pour enfant', 20, 1),
(25, 'BO-012', 'Bonnet nike', 'Un bonnet nike simple', 30, 1),
(26, 'BO-013', 'Bonnet jamaique', 'Un bonnet plein de couleurs rappelant la jamaique', 15, 1),
(27, 'BO-014', 'Bonnet ourson', 'Un bonnet ourson pour enfant', 15, 1),
(28, 'BO-015', 'Bonnet crazy', 'Un bonnet rigolo', 15, 1),
(29, 'BO-016', 'Bonnet beechfield', 'Un bonnet / cache-cou beechfield', 15, 1),
(30, 'BO-017', 'Bonnet large', 'Un bonnet large standard', 15, 1),
(31, 'BO-018', 'Bonnet Carhartt', 'Un bonnet tricotté Carhartt', 20, 1),
(32, 'BO-019', 'Bonnet Stetson', 'Un bonnet court stetson', 15, 1),
(33, 'BO-020', 'Bonnet police', 'Un bonnet hivernal police', 15, 1),
(34, 'PU-003', 'Pull Bière', 'Pull de noel', 30, 2),
(35, 'PU-004', 'Pull Renne', 'Pull renne proposant une bière', 30, 2),
(36, 'PU-005', 'Pull Col', 'Pull au col rond de noel', 30, 2),
(37, 'PU-006', 'Pull Torix', 'Pull de noel torix', 30, 2),
(38, 'PU-007', 'Pull Reims', 'Pull de noel à l\'effigie de Reims', 30, 2),
(39, 'PU-008', 'Pull Norway', 'Pull de noel Norway', 30, 2),
(40, 'PU-009', 'Pull Kitsch', 'Pull de noel kitsch', 30, 2),
(41, 'PU-010', 'Pull laine', 'Pull de noel en laine', 30, 2),
(42, 'PU-011', 'Pull FCSM', 'Pull de noel FCSM', 30, 2),
(43, 'PU-012', 'Pull STE', 'Pull de noel Saint Etienne', 30, 2),
(44, 'PU-013', 'Pull Humour', 'Pull de noel Humor', 30, 2),
(45, 'PU-014', 'Pull Pingouin', 'Pull de noel avec un pingouin', 30, 2),
(46, 'PU-015', 'Pull Chat', 'Pull de noel chat', 30, 2),
(47, 'PU-016', 'Pull PSG', 'Pull de noel à l\'effigie du PSG', 30, 2),
(48, 'PU-017', 'Pull TFC', 'Pull de noel TFC', 30, 2),
(49, 'PU-018', 'Pull Guirlande', 'Pull de noel guirlande', 30, 2),
(50, 'PU-019', 'Pull ASSE', 'Pull de noel ASSE', 30, 2),
(51, 'PU-020', 'Pull Jurassic', 'Pull de noel Jurassic Park', 30, 2),
(52, 'GA-004', 'Gant en cuir', 'Gants en cuir', 20, 3),
(53, 'GA-005', 'Gants tactile', 'Gants tactile', 20, 3),
(54, 'GA-006', 'Gant Coupure', 'Gant contre le froid et anti coupure', 20, 3),
(55, 'GA-007', 'Gants Montagne', 'Gants contre le froid pour la montagne', 20, 3),
(56, 'GA-008', 'Gants Légers', 'Gants contre le froid légers', 20, 3),
(57, 'GA-009', 'Gants lourds', 'Gants lourds contre le froid', 20, 3),
(58, 'GA-010', 'Gants Travail', 'Gants de travail contre le froid', 20, 3),
(59, 'GA-011', 'Gants étanches', 'Gants contre le froid étanches', 20, 3),
(60, 'GA-012', 'Gants poly', 'Gants contre le froid en polyésthere', 20, 3),
(61, 'GA-013', 'Gants Hercule', 'Gants contre le froid pour le travail \"hercule\"', 20, 3),
(62, 'GA-014', 'Gants Alaska', 'Gants alaska', 20, 3),
(63, 'GA-015', 'Gants double', 'Gants à double enduction', 20, 3),
(64, 'GA-016', 'Gants Buckler', 'Gants anti-froid buckler', 20, 3),
(65, 'GA-017', 'Gants ninja', 'Gants ninja ice', 30, 3),
(66, 'GA-018', 'Gants bleu', 'Gants bleu taille unique', 15, 3),
(67, 'GA-019', 'Gants nitrile', 'Gants en nitrile', 30, 3),
(68, 'GA-020', 'Gants Islande', 'Gants anti froid islande', 20, 3),
(69, 'CH-004', 'Chaussettes Camiz', 'Chaussettes de noel', 10, 4),
(70, 'CH-005', 'Chaussettes Imagées', 'Chaussettes de noel', 20, 4),
(71, 'CH-006', 'Chaussettes Mari', 'Chaussette de noel mari', 20, 4),
(72, 'CH-007', 'Chaussettes Vacances', 'Chaussettes de noel thème vacances', 20, 4),
(73, 'CH-008', 'Chaussettes Fun', 'Chaussettes de noel', 20, 4),
(74, 'CH-009', 'Chaussettes Muscle', 'Chaussettes de noel', 20, 4),
(75, 'CH-010', 'Chaussettes Clayre', 'Chaussettes de noel', 5, 4),
(76, 'CH-011', 'Chaussettes Winter', 'Chaussettes de noel', 5, 4),
(77, 'CH-012', 'Chaussettes Bonhomme', 'Chaussettes de noel bonhommes de neige', 20, 4),
(78, 'CH-013', 'Chaussettes Drôles', 'Chaussettes de noel drôles', 20, 4),
(79, 'CH-014', 'Chaussettes Histoire', 'Chaussettes de noel', 30, 4),
(80, 'CH-015', 'Chaussettes Chaudes', 'Chaussettes de noel chaudes', 30, 4),
(81, 'CH-016', 'Chaussettes Rennes', 'Chaussettes de noel renne', 20, 4),
(82, 'CH-017', 'Chaussettes Lovely', 'Chaussettes de noel lovely skull', 20, 4),
(83, 'CH-018', 'Chaussettes Feest', 'Chaussettes de noel feest', 20, 4),
(84, 'CH-019', 'Chaussettes Perso', 'Chaussettes de noel personnalisées', 40, 4),
(85, 'CH-020', 'Chaussettes Fantaisie', 'Chaussettes de noel fantaisie', 20, 4),
(86, 'DE-006', 'Décoration nature', '', 10, 5),
(87, 'DE-007', 'Sapin Bûches', '', 30, 5),
(88, 'DE-008', 'Père Noel', '', 10, 5),
(89, 'DE-009', 'Père Noel', '', 30, 5),
(90, 'DE-010', 'Etoile', '', 5, 5),
(91, 'DE-011', 'Bougie', '', 2, 5),
(92, 'DE-012', 'Renne', '', 2, 5),
(93, 'DE-013', 'Sapin Pere Noel', '', 5, 5),
(94, 'DE-014', 'Bouquet', '', 1, 5),
(95, 'DE-015', 'Couronne Guy', '', 10, 5),
(96, 'DE-016', 'Bûche Deco', '', 19, 5),
(97, 'DE-017', 'Planche décorative', '', 10, 5),
(98, 'DE-018', 'Cadeaux', '', 5, 5),
(99, 'DE-019', 'Décoration Table', '', 20, 5),
(100, 'DE-020', 'Ange', '', 5, 5);

--
-- Déclencheurs `produit`
--
DROP TRIGGER IF EXISTS `PRODUIT_BEFORE_INSERT`;
DELIMITER $$
CREATE TRIGGER `PRODUIT_BEFORE_INSERT` BEFORE INSERT ON `produit` FOR EACH ROW BEGIN

DECLARE v_id_cat_existe, v_prix_correct BOOLEAN;

CALL id_cat_existe(NEW.id_cat, v_id_cat_existe);
CALL verifier_prix(NEW.prix_base, v_prix_correct);

END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `PRODUIT_BEFORE_UPDATE`;
DELIMITER $$
CREATE TRIGGER `PRODUIT_BEFORE_UPDATE` BEFORE UPDATE ON `produit` FOR EACH ROW BEGIN

DECLARE v_id_cat_existe, v_prix_correct BOOLEAN;

CALL id_cat_existe(NEW.id_cat, v_id_cat_existe);
CALL verifier_prix(NEW.prix_base, v_prix_correct);

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `produits_soldes`
--

DROP TABLE IF EXISTS `produits_soldes`;
CREATE TABLE IF NOT EXISTS `produits_soldes` (
  `id_solde` int(11) NOT NULL,
  `id_prod` int(11) NOT NULL,
  PRIMARY KEY (`id_solde`,`id_prod`),
  KEY `id_prod` (`id_prod`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `select_commandes`
-- (Voir ci-dessous la vue réelle)
--
DROP VIEW IF EXISTS `select_commandes`;
CREATE TABLE IF NOT EXISTS `select_commandes` (
`id_com` int(11)
,`id_us` int(11)
,`id_prod` int(11)
,`id_col` int(11)
,`id_tail` int(11)
,`date_com` date
,`qte_com` int(11)
,`prix_total` float
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `select_paniers`
-- (Voir ci-dessous la vue réelle)
--
DROP VIEW IF EXISTS `select_paniers`;
CREATE TABLE IF NOT EXISTS `select_paniers` (
`id_us` int(11)
,`id_prod` int(11)
,`nom_prod` varchar(50)
,`id_cat` int(11)
,`nom_cat` varchar(30)
,`id_col` int(11)
,`nom_col` varchar(20)
,`id_tail` int(11)
,`path_img` varchar(34)
,`prix_unit` double(19,2)
,`qte_pan` int(11)
,`prix_total` double(19,2)
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `select_produits`
-- (Voir ci-dessous la vue réelle)
--
DROP VIEW IF EXISTS `select_produits`;
CREATE TABLE IF NOT EXISTS `select_produits` (
`id_prod` int(11)
,`nom_prod` varchar(50)
,`description` varchar(700)
,`SKU` varchar(50)
,`prix_base` float
,`id_cat` int(11)
,`nom_cat` varchar(30)
,`id_col` int(11)
,`nom_col` varchar(20)
,`id_tail` int(11)
,`nom_tail` varchar(13)
,`path_img` varchar(34)
,`prix_unit` double(19,2)
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `select_users`
-- (Voir ci-dessous la vue réelle)
--
DROP VIEW IF EXISTS `select_users`;
CREATE TABLE IF NOT EXISTS `select_users` (
`id_us` int(11)
,`nom_us` varchar(30)
,`prenom_us` varchar(20)
,`mel` varchar(100)
,`date_naiss` date
,`login` varchar(20)
,`mdp` varchar(255)
,`salt` varchar(20)
,`id_perm` int(11)
,`nom_perm` varchar(15)
);

-- --------------------------------------------------------

--
-- Structure de la table `soldes`
--

DROP TABLE IF EXISTS `soldes`;
CREATE TABLE IF NOT EXISTS `soldes` (
  `id_solde` int(11) NOT NULL AUTO_INCREMENT,
  `nom_solde` varchar(50) NOT NULL,
  `date_debut` date NOT NULL,
  `date_fin` date NOT NULL,
  `pourcentage_reduction` int(11) NOT NULL,
  `actif` tinyint(1) NOT NULL,
  PRIMARY KEY (`id_solde`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `taille`
--

DROP TABLE IF EXISTS `taille`;
CREATE TABLE IF NOT EXISTS `taille` (
  `id_tail` int(11) NOT NULL AUTO_INCREMENT,
  `nom_tail` varchar(13) NOT NULL,
  `id_cat` int(11) NOT NULL,
  PRIMARY KEY (`id_tail`)
) ENGINE=MyISAM AUTO_INCREMENT=18 DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `taille`
--

INSERT INTO `taille` (`id_tail`, `nom_tail`, `id_cat`) VALUES
(1, 'XS', 0),
(2, 'S', 0),
(3, 'M', 0),
(4, 'L', 0),
(5, 'XL', 0),
(6, '30cm', 5),
(7, '60cm', 5),
(8, '50cm', 5),
(9, '100cm', 5),
(10, '150cm', 5),
(11, '200cm', 5),
(12, '32-34', 4),
(13, '35-38', 4),
(14, '39-42', 4),
(15, '43-46', 4),
(16, '47-48', 4),
(17, 'Pas de taille', 0);

-- --------------------------------------------------------

--
-- Structure de la table `tail_prod`
--

DROP TABLE IF EXISTS `tail_prod`;
CREATE TABLE IF NOT EXISTS `tail_prod` (
  `id_prod` int(11) NOT NULL,
  `id_tail` int(11) NOT NULL,
  `prix_base_tail` float NOT NULL,
  PRIMARY KEY (`id_prod`,`id_tail`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `tail_prod`
--

INSERT INTO `tail_prod` (`id_prod`, `id_tail`, `prix_base_tail`) VALUES
(3, 5, 16.5),
(3, 4, 15.75),
(3, 3, 15),
(3, 2, 15),
(3, 1, 15),
(4, 1, 30),
(4, 2, 30),
(4, 3, 30),
(4, 4, 31.5),
(4, 5, 33),
(5, 1, 10),
(5, 2, 10),
(5, 3, 10),
(6, 1, 10),
(6, 2, 10),
(6, 3, 10),
(7, 1, 11),
(7, 2, 11),
(7, 3, 11),
(8, 12, 13),
(8, 13, 13),
(8, 14, 13),
(8, 15, 13),
(8, 16, 13),
(9, 12, 17),
(9, 13, 17),
(9, 14, 17),
(9, 15, 17),
(9, 16, 17),
(10, 12, 10),
(10, 13, 10),
(10, 14, 10),
(10, 15, 10),
(10, 16, 10),
(11, 8, 30),
(11, 9, 30),
(11, 10, 30),
(11, 11, 30),
(12, 1, 7),
(12, 2, 7),
(12, 3, 7),
(13, 6, 60),
(13, 7, 60),
(14, 6, 70),
(14, 7, 70),
(1, 17, 5),
(2, 17, 4),
(15, 11, 0);

--
-- Déclencheurs `tail_prod`
--
DROP TRIGGER IF EXISTS `TAIL_PROD_BEFORE_INSERT`;
DELIMITER $$
CREATE TRIGGER `TAIL_PROD_BEFORE_INSERT` BEFORE INSERT ON `tail_prod` FOR EACH ROW BEGIN
    DECLARE v_id_prod_existe, v_id_tail_existe, v_prix_correct BOOLEAN;

    CALL id_prod_existe(NEW.id_prod, v_id_prod_existe);
    CALL id_tail_existe(NEW.id_tail, v_id_tail_existe);
    CALL verifier_prix(NEW.prix_base_tail, v_prix_correct); -- Changé ici
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `TAIL_PROD_BEFORE_UPDATE`;
DELIMITER $$
CREATE TRIGGER `TAIL_PROD_BEFORE_UPDATE` BEFORE UPDATE ON `tail_prod` FOR EACH ROW BEGIN
    DECLARE v_id_prod_existe, v_id_tail_existe, v_prix_correct BOOLEAN;

    CALL id_prod_existe(NEW.id_prod, v_id_prod_existe);
    CALL id_tail_existe(NEW.id_tail, v_id_tail_existe);
    CALL verifier_prix(NEW.prix_base_tail, v_prix_correct); -- Changé ici
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `user`
--

DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `id_us` int(11) NOT NULL AUTO_INCREMENT,
  `nom_us` varchar(30) NOT NULL,
  `prenom_us` varchar(20) NOT NULL,
  `mel` varchar(100) NOT NULL,
  `date_naiss` date NOT NULL,
  `login` varchar(20) NOT NULL,
  `mdp` varchar(255) NOT NULL,
  `salt` varchar(20) NOT NULL,
  `id_perm` int(11) NOT NULL,
  PRIMARY KEY (`id_us`)
) ENGINE=MyISAM AUTO_INCREMENT=22 DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `user`
--

INSERT INTO `user` (`id_us`, `nom_us`, `prenom_us`, `mel`, `date_naiss`, `login`, `mdp`, `salt`, `id_perm`) VALUES
(7, 'admin', 'admin', 'admin@gmail.com', '2010-10-10', 'admin', 'skD7MyPRpfvsM', 'sk#@u%Q)-V}2^)gpSK&X', 1),
(11, 'Falschenbuhl', 'Rémi', 'remi.falschenbuhl@yahoo.fr', '2003-12-04', 'remiF', 'rOo9.RCDnsGfY', 'rOyJG[>IW$;,8LZmi=<n', 2),
(16, 'Philippe', 'Kévin', 'kph@gmail.com', '2003-12-04', 'new', '9l9KCmTBMCeDo', '9l;hSW*EN)S rm.j$/p1', 2),
(18, 'Laroche', 'Pierre', 'laroche5@univ-lorraine.fr', '1991-02-24', 'laroche5', 'Mw6FchtZ8zKKY', 'MwU86#P?T8LneEO#|~GG', 2),
(19, 'aa', 'aa', 'aaaaaaaaaaa@aaaaa.com', '2002-02-20', 'aaaa', '$2y$10$D0ik0ZYUNtRkw4iDEngYGeHOxUs2dVjIXzOVDyOf5G1.angvKZ9Tq', '', 2),
(20, 'feur', 'rouge', 'feur@feur.com', '1999-12-19', 'a', '$2y$10$zDPgAMKuAgCQWevwZLp0t.9XJIACvppPk.YQIlPCsCI7mdmr4XCd2', '', 2),
(21, 'dev', 'dev', 'dev@dev.dev', '2005-11-11', 'dev', '$2y$10$RVQYNT1IgBoYuHhVYYFey.uwFeeUNS5jeQAYKNB19UviZ4uiy6POS', '', 2);

--
-- Déclencheurs `user`
--
DROP TRIGGER IF EXISTS `USER_BEFORE_INSERT`;
DELIMITER $$
CREATE TRIGGER `USER_BEFORE_INSERT` BEFORE INSERT ON `user` FOR EACH ROW BEGIN

DECLARE v_id_perm_existe, v_login_non_existe, v_date_conforme BOOLEAN;

CALL id_perm_existe(NEW.id_perm, v_id_perm_existe);
CALL login_non_existe(NEW.login, v_login_non_existe);
CALL verifier_date(NEW.date_naiss, v_date_conforme);

END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `USER_BEFORE_UPDATE`;
DELIMITER $$
CREATE TRIGGER `USER_BEFORE_UPDATE` BEFORE UPDATE ON `user` FOR EACH ROW BEGIN

DECLARE v_id_perm_existe, v_login_non_existe, v_date_conforme BOOLEAN;

CALL id_perm_existe(NEW.id_perm, v_id_perm_existe);
#CALL login_non_existe(NEW.login, v_login_non_existe);
CALL verifier_date(NEW.date_naiss, v_date_conforme);

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la vue `select_commandes`
--
DROP TABLE IF EXISTS `select_commandes`;

DROP VIEW IF EXISTS `select_commandes`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `select_commandes`  AS SELECT `c`.`id_com` AS `id_com`, `c`.`id_us` AS `id_us`, `dc`.`id_prod` AS `id_prod`, `dc`.`id_col` AS `id_col`, `dc`.`id_tail` AS `id_tail`, `c`.`date_com` AS `date_com`, `dc`.`qte_com` AS `qte_com`, `dc`.`prix_total` AS `prix_total` FROM (((`commande` `c` join `detail_com` `dc` on((`dc`.`id_com` = `c`.`id_com`))) join `couleur` `co` on((`dc`.`id_col` = `co`.`id_col`))) join `taille` `t` on((`dc`.`id_tail` = `t`.`id_tail`))) ORDER BY `c`.`id_us` ASC, `c`.`id_com` ASC, `dc`.`id_prod` ASC, `dc`.`id_col` ASC, `dc`.`id_tail` ASC ;

-- --------------------------------------------------------

--
-- Structure de la vue `select_paniers`
--
DROP TABLE IF EXISTS `select_paniers`;

DROP VIEW IF EXISTS `select_paniers`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `select_paniers`  AS SELECT `pa`.`id_us` AS `id_us`, `p`.`id_prod` AS `id_prod`, `p`.`nom_prod` AS `nom_prod`, `p`.`id_cat` AS `id_cat`, `p`.`nom_cat` AS `nom_cat`, `p`.`id_col` AS `id_col`, `p`.`nom_col` AS `nom_col`, `p`.`id_tail` AS `id_tail`, `p`.`path_img` AS `path_img`, `p`.`prix_unit` AS `prix_unit`, `pa`.`qte_pan` AS `qte_pan`, (`pa`.`qte_pan` * `p`.`prix_unit`) AS `prix_total` FROM (`panier` `pa` join (select `select_produits`.`id_prod` AS `id_prod`,`select_produits`.`nom_prod` AS `nom_prod`,`select_produits`.`id_cat` AS `id_cat`,`select_produits`.`nom_cat` AS `nom_cat`,`select_produits`.`id_col` AS `id_col`,`select_produits`.`nom_col` AS `nom_col`,`select_produits`.`id_tail` AS `id_tail`,`select_produits`.`nom_tail` AS `nom_tail`,`select_produits`.`path_img` AS `path_img`,`select_produits`.`prix_unit` AS `prix_unit` from `select_produits`) `p` on(((`pa`.`id_prod` = `p`.`id_prod`) and (`pa`.`id_col` = `p`.`id_col`) and (`pa`.`id_tail` = `p`.`id_tail`)))) ;

-- --------------------------------------------------------

--
-- Structure de la vue `select_produits`
--
DROP TABLE IF EXISTS `select_produits`;

DROP VIEW IF EXISTS `select_produits`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `select_produits`  AS SELECT `p`.`id_prod` AS `id_prod`, `p`.`nom_prod` AS `nom_prod`, `p`.`description` AS `description`, `p`.`SKU` AS `SKU`, `p`.`prix_base` AS `prix_base`, `p`.`id_cat` AS `id_cat`, `ca`.`nom_cat` AS `nom_cat`, `cp`.`id_col` AS `id_col`, `co`.`nom_col` AS `nom_col`, `tp`.`id_tail` AS `id_tail`, `t`.`nom_tail` AS `nom_tail`, `cp`.`path_img` AS `path_img`, round(((coalesce(`cp`.`prix_base_col`,`p`.`prix_base`) + coalesce(`tp`.`prix_base_tail`,0)) * 1.2),2) AS `prix_unit` FROM (((((`produit` `p` left join `col_prod` `cp` on((`cp`.`id_prod` = `p`.`id_prod`))) left join `tail_prod` `tp` on((`tp`.`id_prod` = `p`.`id_prod`))) join `categorie` `ca` on((`ca`.`id_cat` = `p`.`id_cat`))) left join `couleur` `co` on((`co`.`id_col` = `cp`.`id_col`))) left join `taille` `t` on((`t`.`id_tail` = `tp`.`id_tail`))) ORDER BY `p`.`nom_prod` ASC, `ca`.`nom_cat` ASC, `co`.`nom_col` ASC, `t`.`nom_tail` ASC ;

-- --------------------------------------------------------

--
-- Structure de la vue `select_users`
--
DROP TABLE IF EXISTS `select_users`;

DROP VIEW IF EXISTS `select_users`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `select_users`  AS SELECT `u`.`id_us` AS `id_us`, `u`.`nom_us` AS `nom_us`, `u`.`prenom_us` AS `prenom_us`, `u`.`mel` AS `mel`, `u`.`date_naiss` AS `date_naiss`, `u`.`login` AS `login`, `u`.`mdp` AS `mdp`, `u`.`salt` AS `salt`, `p`.`id_perm` AS `id_perm`, `p`.`nom_perm` AS `nom_perm` FROM (`user` `u` join `permission` `p` on((`p`.`id_perm` = `u`.`id_perm`))) ORDER BY `p`.`id_perm` ASC, `u`.`nom_us` ASC, `u`.`prenom_us` ASC ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
