DROP TABLE IF EXISTS `dealership_sales`;
CREATE TABLE `dealership_sales` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `dealership` varchar(20) NOT NULL,
  `seller` varchar(22) NOT NULL,
  `buyer` varchar(22) NOT NULL,
  `model` varchar(15) NOT NULL,
  `plate` varchar(8) NOT NULL,
  `time` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
