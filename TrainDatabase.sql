CREATE DATABASE  IF NOT EXISTS `TrainDatabase` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `TrainDatabase` ;


DROP TABLE IF EXISTS `Accounts`;
CREATE TABLE `Accounts` (
	`username` varchar(20),
    `password` varchar(20),
    PRIMARY KEY (`username`)
);

LOCK TABLES `Accounts` WRITE;
/*!40000 ALTER TABLE `Accounts` DISABLE KEYS */;
INSERT INTO `Accounts` VALUES ('testuser','password');
/*!40000 ALTER TABLE `Accounts` ENABLE KEYS */;
UNLOCK TABLES;



