-- --------------------------------------------------------
-- Värd:                         127.0.0.1
-- Serverversion:                10.1.31-MariaDB - mariadb.org binary distribution
-- Server-OS:                    Win32
-- HeidiSQL Version:             9.5.0.5261
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumpar struktur för tabell qalle.user_keys
CREATE TABLE IF NOT EXISTS `user_keys` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) NOT NULL,
  `key_name` varchar(50) NOT NULL,
  `key_unit` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

-- Dumpar data för tabell qalle.user_keys: ~2 rows (ungefär)
/*!40000 ALTER TABLE `user_keys` DISABLE KEYS */;
INSERT INTO `user_keys` (`id`, `identifier`, `key_name`, `key_unit`) VALUES
/*!40000 ALTER TABLE `user_keys` ENABLE KEYS */;

-- Dumpar struktur för tabell qalle.user_storages
CREATE TABLE IF NOT EXISTS `user_storages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) NOT NULL,
  `storage_unit` int(50) NOT NULL,
  `storage_key_name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

-- Dumpar data för tabell qalle.user_storages: ~2 rows (ungefär)
/*!40000 ALTER TABLE `user_storages` DISABLE KEYS */;
INSERT INTO `user_storages` (`id`, `identifier`, `storage_unit`, `storage_key_name`) VALUES
/*!40000 ALTER TABLE `user_storages` ENABLE KEYS */;

-- Dumpar struktur för tabell qalle.user_storages_items
CREATE TABLE IF NOT EXISTS `user_storages_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `storage_unit` int(11) NOT NULL,
  `item` varchar(255) NOT NULL,
  `count` int(11) NOT NULL,
  `weapon` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

-- Dumpar data för tabell qalle.user_storages_items: ~0 rows (ungefär)
/*!40000 ALTER TABLE `user_storages_items` DISABLE KEYS */;
INSERT INTO `user_storages_items` (`id`, `storage_unit`, `item`, `count`, `weapon`) VALUES
/*!40000 ALTER TABLE `user_storages_items` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
