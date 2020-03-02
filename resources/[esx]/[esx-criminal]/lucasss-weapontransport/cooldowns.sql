CREATE TABLE IF NOT EXISTS `cooldowns` (
  `id` text,
  `cooldown` bigint(20) DEFAULT NULL,
  `timestamp` bigint(20) DEFAULT NULL
)