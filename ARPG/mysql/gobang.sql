# SQL Manager 2010 Lite for MySQL 4.5.1.1
# ---------------------------------------
# Host     : localhost
# Port     : 3306
# Database : gobang


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES latin1 */;

SET FOREIGN_KEY_CHECKS=0;

CREATE DATABASE `gobang`
    CHARACTER SET 'utf8'
    COLLATE 'utf8_general_ci';

USE `gobang`;

#
# Structure for the `player` table : 
#

CREATE TABLE `player` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` char(20) CHARACTER SET latin1 DEFAULT NULL,
  `password` char(20) CHARACTER SET latin1 DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

#
# Data for the `player` table  (LIMIT 0,500)
#

INSERT INTO `player` (`id`, `username`, `password`) VALUES 
  (1,'test888','1');
COMMIT;



/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;