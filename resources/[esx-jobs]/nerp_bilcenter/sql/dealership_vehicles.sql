DROP TABLE IF EXISTS `dealership_vehicles`;
CREATE TABLE `dealership_vehicles` (
  `plate` varchar(12) NOT NULL,
  `label` varchar(20) NOT NULL,
  `model` varchar(15) NOT NULL,
  `user` varchar(22) NOT NULL,
  `bought` timestamp DEFAULT CURRENT_TIMESTAMP,
  `vehicle` longtext DEFAULT NULL,
  `job` varchar(20) DEFAULT NULL,
  `price` int(10) unsigned DEFAULT 0,
  `stored` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`plate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
