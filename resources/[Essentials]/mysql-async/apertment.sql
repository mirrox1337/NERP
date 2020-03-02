CREATE TABLE IF NOT EXISTS `apartments` (
  `id` int(11) DEFAULT NULL,
  `identifier` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `modifications` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `items` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `garage` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `apartment_sessions` (
  `owner` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `players` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin
) ENGINE=InnoDB DEFAULT CHARSET=latin1;