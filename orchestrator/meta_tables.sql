-- Contains all the orchestrator-managed MySQL clusters
CREATE TABLE `cluster` (
  `anchor` tinyint NOT NULL,
  `cluster_name` varchar(128) NOT NULL DEFAULT '',
  `cluster_domain` varchar(128) NOT NULL DEFAULT '',
  PRIMARY KEY (`anchor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Contains the promotion rules per cluster member / host (must_not, neutral, prefer, ...)
CREATE TABLE `promotion_rules` (
  `cluster_member` varchar(128) NOT NULL DEFAULT '',
  `promotion_rule` varchar(128) NOT NULL DEFAULT '',
  PRIMARY KEY (`cluster_member`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Contains the semi-sync priority per cluster member (higher number is higher priority)
CREATE TABLE `semi_sync` (
  `cluster_member` varchar(128) NOT NULL DEFAULT '',
  `priority` tinyint unsigned NOT NULL,
  PRIMARY KEY (`cluster_member`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Insert examples:

-- Cluster
INSERT INTO `cluster` VALUES (1,'g0','example.com');

-- Promotion rules (we never want to promote -3)
INSERT INTO `promotion_rules` VALUES ('db-g0-1','neutral');
INSERT INTO `promotion_rules` VALUES ('db-g0-2','neutral');
INSERT INTO `promotion_rules` VALUES ('db-g0-3','must_not');

-- Semi-sync priority (if all hosts are up, -3 should not be a semi-sync replica,
-- assuming that rpl_semi_sync_master_wait_for_slave_count=1)
INSERT INTO `semi_sync` VALUES ('db-g0-1',2);
INSERT INTO `semi_sync` VALUES ('db-g0-2',2);
INSERT INTO `semi_sync` VALUES ('db-g0-3',1);

