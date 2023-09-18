/*
Navicat MySQL Data Transfer

Source Server         : aliyun
Source Server Version : 80034
Source Host           : 47.108.233.209:3306
Source Database       : crmdb

Target Server Type    : MYSQL
Target Server Version : 80034
File Encoding         : 65001

Date: 2023-09-17 11:44:40
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for tbl_activity
-- ----------------------------
DROP TABLE IF EXISTS `tbl_activity`;
CREATE TABLE `tbl_activity` (
  `id` char(32) COLLATE utf8mb4_general_ci NOT NULL,
  `owner` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `start_date` char(10) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `end_date` char(10) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `cost` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `create_time` char(19) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `create_by` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `edit_time` char(19) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `edit_by` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_owner` (`owner`),
  KEY `fk_create_by` (`create_by`),
  KEY `fk_edit_by` (`edit_by`),
  CONSTRAINT `fk_create_by` FOREIGN KEY (`create_by`) REFERENCES `tbl_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_edit_by` FOREIGN KEY (`edit_by`) REFERENCES `tbl_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_owner` FOREIGN KEY (`owner`) REFERENCES `tbl_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of tbl_activity
-- ----------------------------
INSERT INTO `tbl_activity` VALUES ('7e7be530331740f29b6f9502828fe6eb', '06f5fc056eac41558a964f96daa7f27c', '测试04', '2023-09-22', '2023-12-21', '0', '测试04', '2023-09-07 08:20:47', '06f5fc056eac41558a964f96daa7f27c', null, null);
INSERT INTO `tbl_activity` VALUES ('95278be6ca9e4982aa0ae09d877deb2b', '06f5fc056eac41558a964f96daa7f27c', '测试01', '2023-08-27', '2023-09-04', '100', '测试01', '2023-09-07 08:21:09', '06f5fc056eac41558a964f96daa7f27c', null, null);
INSERT INTO `tbl_activity` VALUES ('fb413e44fd334611baae2050323247aa', '06f5fc056eac41558a964f96daa7f27c', '测试03', '2023-09-13', '2023-09-21', '100', '测试03', '2023-09-06 21:19:44', '06f5fc056eac41558a964f96daa7f27c', null, null);
INSERT INTO `tbl_activity` VALUES ('fbd4eb09644f4ebca1d135c48a6c9485', '06f5fc056eac41558a964f96daa7f27c', '测试02', '2023-09-20', '2023-09-30', '50', '测试02', '2023-09-07 08:21:48', '06f5fc056eac41558a964f96daa7f27c', null, null);

-- ----------------------------
-- Table structure for tbl_activity_remark
-- ----------------------------
DROP TABLE IF EXISTS `tbl_activity_remark`;
CREATE TABLE `tbl_activity_remark` (
  `id` char(32) COLLATE utf8mb4_general_ci NOT NULL,
  `note_content` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `create_time` char(19) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `create_by` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `edit_time` char(19) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `edit_by` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `edit_flag` char(1) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '0表示未修改，1表示已修改',
  `activity_id` char(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_activity_id` (`activity_id`),
  CONSTRAINT `fk_activity_id` FOREIGN KEY (`activity_id`) REFERENCES `tbl_activity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of tbl_activity_remark
-- ----------------------------

-- ----------------------------
-- Table structure for tbl_clue
-- ----------------------------
DROP TABLE IF EXISTS `tbl_clue`;
CREATE TABLE `tbl_clue` (
  `id` char(32) COLLATE utf8mb4_general_ci NOT NULL,
  `fullname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `appellation` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `owner` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `company` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `job` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `website` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `mphone` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `state` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `source` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `create_by` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `create_time` char(19) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `edit_by` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `edit_time` char(19) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `contact_summary` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `next_contact_time` char(10) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `address` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_create_by_clue` (`create_by`),
  KEY `fk_edit_by_clue` (`edit_by`),
  KEY `fk_owner_clue` (`owner`),
  KEY `fk_appellation_clue` (`appellation`),
  KEY `fk_state_clue` (`state`),
  KEY `fk_source_clue` (`source`),
  KEY `fullname` (`fullname`),
  CONSTRAINT `fk_appellation_clue` FOREIGN KEY (`appellation`) REFERENCES `tbl_dic_value` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_create_by_clue` FOREIGN KEY (`create_by`) REFERENCES `tbl_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_edit_by_clue` FOREIGN KEY (`edit_by`) REFERENCES `tbl_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_owner_clue` FOREIGN KEY (`owner`) REFERENCES `tbl_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_source_clue` FOREIGN KEY (`source`) REFERENCES `tbl_dic_value` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_state_clue` FOREIGN KEY (`state`) REFERENCES `tbl_dic_value` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of tbl_clue
-- ----------------------------
INSERT INTO `tbl_clue` VALUES ('f31a7eec57ea47b09b966815c68ee74d', '邓和颖', '59795c49896947e1ab61b7312bd0597c', '06f5fc056eac41558a964f96daa7f27c', '桂林电子科技大学', '学生', '1234567891@qq.com', '6351542', 'http://example.com', '14536366550', '966170ead6fa481284b7d21f90364984', '86c56aca9eef49058145ec20d5466c17', '06f5fc056eac41558a964f96daa7f27c', '2023-09-13 08:34:16', null, null, '测试', '测试', '2023-09-21', '桂林电子科技大学花江校区');

-- ----------------------------
-- Table structure for tbl_clue_activity_relation
-- ----------------------------
DROP TABLE IF EXISTS `tbl_clue_activity_relation`;
CREATE TABLE `tbl_clue_activity_relation` (
  `id` char(32) COLLATE utf8mb4_general_ci NOT NULL,
  `clue_id` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `activity_id` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_clue_id_rel` (`clue_id`),
  KEY `fk_activity_id_rel` (`activity_id`),
  CONSTRAINT `fk_activity_id_rel` FOREIGN KEY (`activity_id`) REFERENCES `tbl_activity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_clue_id_rel` FOREIGN KEY (`clue_id`) REFERENCES `tbl_clue` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of tbl_clue_activity_relation
-- ----------------------------
INSERT INTO `tbl_clue_activity_relation` VALUES ('3ce9dd51a8ab40d9a541b1bdefbe9516', 'f31a7eec57ea47b09b966815c68ee74d', 'fbd4eb09644f4ebca1d135c48a6c9485');
INSERT INTO `tbl_clue_activity_relation` VALUES ('a42def2a718c42a395b48fe6ce32913d', 'f31a7eec57ea47b09b966815c68ee74d', '95278be6ca9e4982aa0ae09d877deb2b');
INSERT INTO `tbl_clue_activity_relation` VALUES ('e65c2e72e8f24faaa0e0ec19cde0e21f', 'f31a7eec57ea47b09b966815c68ee74d', '7e7be530331740f29b6f9502828fe6eb');

-- ----------------------------
-- Table structure for tbl_clue_remark
-- ----------------------------
DROP TABLE IF EXISTS `tbl_clue_remark`;
CREATE TABLE `tbl_clue_remark` (
  `id` char(32) COLLATE utf8mb4_general_ci NOT NULL,
  `note_content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `create_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `create_time` char(19) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `edit_by` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `edit_time` char(19) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `edit_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `clue_id` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_clue_id` (`clue_id`),
  KEY `fk_create_by_clue_remark` (`create_by`),
  KEY `fk_edit_by_clue_remark` (`edit_by`),
  CONSTRAINT `fk_clue_id` FOREIGN KEY (`clue_id`) REFERENCES `tbl_clue` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_create_by_clue_remark` FOREIGN KEY (`create_by`) REFERENCES `tbl_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_edit_by_clue_remark` FOREIGN KEY (`edit_by`) REFERENCES `tbl_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of tbl_clue_remark
-- ----------------------------

-- ----------------------------
-- Table structure for tbl_contacts
-- ----------------------------
DROP TABLE IF EXISTS `tbl_contacts`;
CREATE TABLE `tbl_contacts` (
  `id` char(32) COLLATE utf8mb4_general_ci NOT NULL,
  `owner` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `source` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `customer_id` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `fullname` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `appellation` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `mphone` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `job` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `create_by` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `create_time` char(19) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `edit_by` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `edit_time` char(19) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `contact_summary` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `next_contact_time` char(10) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `address` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_owner_contacts` (`owner`),
  KEY `fk_customer_id_contacts` (`customer_id`),
  KEY `fk_create_by_contacts` (`create_by`),
  KEY `fk_source_contacts` (`source`),
  KEY `fk_appellation_contacts` (`appellation`),
  CONSTRAINT `fk_appellation_contacts` FOREIGN KEY (`appellation`) REFERENCES `tbl_dic_value` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_create_by_contacts` FOREIGN KEY (`create_by`) REFERENCES `tbl_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_customer_id_contacts` FOREIGN KEY (`customer_id`) REFERENCES `tbl_customer` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_owner_contacts` FOREIGN KEY (`owner`) REFERENCES `tbl_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_source_contacts` FOREIGN KEY (`source`) REFERENCES `tbl_dic_value` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of tbl_contacts
-- ----------------------------
INSERT INTO `tbl_contacts` VALUES ('a31493af6baa4435a1b2e79999dee1ed', '06f5fc056eac41558a964f96daa7f27c', '3a39605d67da48f2a3ef52e19d243953', 'c55de55982764078b8aa5815adfb7251', '大力王', '59795c49896947e1ab61b7312bd0597c', '1234567@qq.com', '14536366550', '健美选手', '06f5fc056eac41558a964f96daa7f27c', '2023-09-12 21:32:27', null, null, '绷不住了', 'What is love?', '2023-09-20', '美国加利福尼亚州');
INSERT INTO `tbl_contacts` VALUES ('f1827a1e1cef4589b0892b519988f5f3', '06f5fc056eac41558a964f96daa7f27c', 'a83e75ced129421dbf11fab1f05cf8b4', '2000300211', 'MC石头', '59795c49896947e1ab61b7312bd0597c', '1234567@qq.com', '14536366550', '喊麦', '06f5fc056eac41558a964f96daa7f27c', '2023-09-12 21:37:41', null, null, 'MC石头是一个极具商业头脑的经营者', '一人饮酒醉', '2023-09-22', '中国');
INSERT INTO `tbl_contacts` VALUES ('f73173371fe34549ac8466bbd696f3bf', '06f5fc056eac41558a964f96daa7f27c', 'a83e75ced129421dbf11fab1f05cf8b4', '4285535ddbb949fe96ea1773f7aecda4', '张三', '176039d2a90e4b1a81c5ab8707268636', '1234567@qq.com', '13853273925', '教授', '06f5fc056eac41558a964f96daa7f27c', '2023-09-11 11:49:40', null, null, null, '大客户', '2023-09-27', '中国政法大学');

-- ----------------------------
-- Table structure for tbl_contacts_activity_relation
-- ----------------------------
DROP TABLE IF EXISTS `tbl_contacts_activity_relation`;
CREATE TABLE `tbl_contacts_activity_relation` (
  `id` char(32) COLLATE utf8mb4_general_ci NOT NULL,
  `contacts_id` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `activity_id` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_activity_id_c_a_relation` (`activity_id`),
  KEY `fk_contacts_id_c_a_relation` (`contacts_id`),
  CONSTRAINT `fk_activity_id_c_a_relation` FOREIGN KEY (`activity_id`) REFERENCES `tbl_activity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_contacts_id_c_a_relation` FOREIGN KEY (`contacts_id`) REFERENCES `tbl_contacts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of tbl_contacts_activity_relation
-- ----------------------------
INSERT INTO `tbl_contacts_activity_relation` VALUES ('4801b5c501f94967bce76285d0dcf8f5', 'f73173371fe34549ac8466bbd696f3bf', 'fb413e44fd334611baae2050323247aa');
INSERT INTO `tbl_contacts_activity_relation` VALUES ('bea263b404ee4bfe9a024e00d80e9724', 'f73173371fe34549ac8466bbd696f3bf', '95278be6ca9e4982aa0ae09d877deb2b');
INSERT INTO `tbl_contacts_activity_relation` VALUES ('c7415ea6ab52472aa340ecd19025ab3c', 'f73173371fe34549ac8466bbd696f3bf', 'fbd4eb09644f4ebca1d135c48a6c9485');
INSERT INTO `tbl_contacts_activity_relation` VALUES ('e24cc0a269dd4994a086c29fc8d74541', 'f73173371fe34549ac8466bbd696f3bf', '7e7be530331740f29b6f9502828fe6eb');

-- ----------------------------
-- Table structure for tbl_contacts_remark
-- ----------------------------
DROP TABLE IF EXISTS `tbl_contacts_remark`;
CREATE TABLE `tbl_contacts_remark` (
  `id` char(32) COLLATE utf8mb4_general_ci NOT NULL,
  `note_content` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `create_by` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `create_time` char(19) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `edit_by` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `edit_time` char(19) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `edit_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `contacts_id` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_create_by_contacts_remark` (`create_by`),
  KEY `fk_edit_by_contacts_remark` (`edit_by`),
  KEY `fk_contacts_id_contacts_remark` (`contacts_id`),
  CONSTRAINT `fk_contacts_id_contacts_remark` FOREIGN KEY (`contacts_id`) REFERENCES `tbl_contacts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_create_by_contacts_remark` FOREIGN KEY (`create_by`) REFERENCES `tbl_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_edit_by_contacts_remark` FOREIGN KEY (`edit_by`) REFERENCES `tbl_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of tbl_contacts_remark
-- ----------------------------
INSERT INTO `tbl_contacts_remark` VALUES ('010bb139501940ceb82306bf55b09a77', '罗翔老师！', '06f5fc056eac41558a964f96daa7f27c', '2023-09-11', null, null, '0', 'f73173371fe34549ac8466bbd696f3bf');
INSERT INTO `tbl_contacts_remark` VALUES ('11b644a2f34c42028d93ccfd4428d7e1', '老师好！！', '06f5fc056eac41558a964f96daa7f27c', '2023-09-11', '06f5fc056eac41558a964f96daa7f27c', '2023-09-06 10:38:03', '1', 'f73173371fe34549ac8466bbd696f3bf');
INSERT INTO `tbl_contacts_remark` VALUES ('9021b96829d6452e9890318e3b02a760', '法外狂徒，张三！', '06f5fc056eac41558a964f96daa7f27c', '2023-09-11', '06f5fc056eac41558a964f96daa7f27c', '2023-09-06 10:34:37', '1', 'f73173371fe34549ac8466bbd696f3bf');

-- ----------------------------
-- Table structure for tbl_customer
-- ----------------------------
DROP TABLE IF EXISTS `tbl_customer`;
CREATE TABLE `tbl_customer` (
  `id` char(32) COLLATE utf8mb4_general_ci NOT NULL,
  `owner` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `website` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `create_by` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `create_time` char(19) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `edit_by` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `edit_time` char(19) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `contact_summary` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `next_contact_time` char(10) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `address` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_owner_customer` (`owner`),
  KEY `fk_create_by_customer` (`create_by`),
  KEY `fk_edit_by_customer` (`edit_by`),
  CONSTRAINT `fk_create_by_customer` FOREIGN KEY (`create_by`) REFERENCES `tbl_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_edit_by_customer` FOREIGN KEY (`edit_by`) REFERENCES `tbl_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_owner_customer` FOREIGN KEY (`owner`) REFERENCES `tbl_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of tbl_customer
-- ----------------------------
INSERT INTO `tbl_customer` VALUES ('2000300211', '06f5fc056eac41558a964f96daa7f27c', '桂林电子科技大学', 'http://example.com', '1234567', '06f5fc056eac41558a964f96daa7f27c', '2023-09-11 11:49:40', '06f5fc056eac41558a964f96daa7f27c', '', '大客户', '2023-09-27', '有用', '中国政法大学');
INSERT INTO `tbl_customer` VALUES ('2a93fb32323442579ac210bb54f597dc', '06f5fc056eac41558a964f96daa7f27c', '测试02', null, null, '06f5fc056eac41558a964f96daa7f27c', '2023-09-15 17:03:56', null, null, null, null, null, null);
INSERT INTO `tbl_customer` VALUES ('4285535ddbb949fe96ea1773f7aecda4', '06f5fc056eac41558a964f96daa7f27c', '中国政法大学', 'http://example.com', '1234567', '06f5fc056eac41558a964f96daa7f27c', '2023-09-11 11:49:40', null, null, '大客户', '2023-09-27', '有用', '中国政法大学');
INSERT INTO `tbl_customer` VALUES ('c55de55982764078b8aa5815adfb7251', '06f5fc056eac41558a964f96daa7f27c', '美国加利福尼亚州', null, null, '06f5fc056eac41558a964f96daa7f27c', '2023-09-12 21:32:27', null, null, null, null, null, null);

-- ----------------------------
-- Table structure for tbl_customer_remark
-- ----------------------------
DROP TABLE IF EXISTS `tbl_customer_remark`;
CREATE TABLE `tbl_customer_remark` (
  `id` char(32) COLLATE utf8mb4_general_ci NOT NULL,
  `note_content` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `create_by` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `create_time` char(19) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `edit_by` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `edit_time` char(19) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `edit_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `customer_id` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_create_by_customer_remark` (`create_by`),
  KEY `fk_edit_by_customer_remark` (`edit_by`),
  KEY `fk_customer_id_customer_remark` (`customer_id`),
  CONSTRAINT `fk_create_by_customer_remark` FOREIGN KEY (`create_by`) REFERENCES `tbl_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_customer_id_customer_remark` FOREIGN KEY (`customer_id`) REFERENCES `tbl_customer` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_edit_by_customer_remark` FOREIGN KEY (`edit_by`) REFERENCES `tbl_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of tbl_customer_remark
-- ----------------------------
INSERT INTO `tbl_customer_remark` VALUES ('3b730471f3a44695acf23e851004f145', '罗翔老师！', '06f5fc056eac41558a964f96daa7f27c', '2023-09-11 11:49:40', null, null, '0', '4285535ddbb949fe96ea1773f7aecda4');
INSERT INTO `tbl_customer_remark` VALUES ('8c60c91f95ec43698188eed7378fbc44', '老师好！！', '06f5fc056eac41558a964f96daa7f27c', '2023-09-11 11:49:40', '06f5fc056eac41558a964f96daa7f27c', '2023-09-06 10:38:03', '1', '4285535ddbb949fe96ea1773f7aecda4');
INSERT INTO `tbl_customer_remark` VALUES ('b246aaa0caed43799478f119523f256f', '法外狂徒，张三！', '06f5fc056eac41558a964f96daa7f27c', '2023-09-11 11:49:40', '06f5fc056eac41558a964f96daa7f27c', '2023-09-06 10:34:37', '1', '4285535ddbb949fe96ea1773f7aecda4');

-- ----------------------------
-- Table structure for tbl_dic_type
-- ----------------------------
DROP TABLE IF EXISTS `tbl_dic_type`;
CREATE TABLE `tbl_dic_type` (
  `code` varchar(255) COLLATE utf8mb4_general_ci NOT NULL COMMENT '编码是主键，不能为空，不能含有中文。',
  `name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of tbl_dic_type
-- ----------------------------
INSERT INTO `tbl_dic_type` VALUES ('appellation', '称呼', '');
INSERT INTO `tbl_dic_type` VALUES ('clueState', '线索状态', '');
INSERT INTO `tbl_dic_type` VALUES ('returnPriority', '回访优先级', '');
INSERT INTO `tbl_dic_type` VALUES ('returnState', '回访状态', '');
INSERT INTO `tbl_dic_type` VALUES ('source', '来源', '');
INSERT INTO `tbl_dic_type` VALUES ('stage', '阶段', '');
INSERT INTO `tbl_dic_type` VALUES ('transactionType', '交易类型', '');

-- ----------------------------
-- Table structure for tbl_dic_value
-- ----------------------------
DROP TABLE IF EXISTS `tbl_dic_value`;
CREATE TABLE `tbl_dic_value` (
  `id` char(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键，采用UUID',
  `value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '不能为空，并且要求同一个字典类型下字典值不能重复，具有唯一性。',
  `text` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '可以为空',
  `order_no` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '可以为空，但不为空的时候，要求必须是正整数',
  `type_code` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '外键',
  PRIMARY KEY (`id`,`value`),
  KEY `fk_type_code` (`type_code`),
  KEY `id` (`id`),
  CONSTRAINT `fk_type_code` FOREIGN KEY (`type_code`) REFERENCES `tbl_dic_type` (`code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of tbl_dic_value
-- ----------------------------
INSERT INTO `tbl_dic_value` VALUES ('06e3cbdf10a44eca8511dddfc6896c55', '虚假线索', '虚假线索', '4', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('0fe33840c6d84bf78df55d49b169a894', '销售邮件', '销售邮件', '8', 'source');
INSERT INTO `tbl_dic_value` VALUES ('12302fd42bd349c1bb768b19600e6b20', '交易会', '交易会', '11', 'source');
INSERT INTO `tbl_dic_value` VALUES ('1615f0bb3e604552a86cde9a2ad45bea', '最高', '最高', '2', 'returnPriority');
INSERT INTO `tbl_dic_value` VALUES ('176039d2a90e4b1a81c5ab8707268636', '教授', '教授', '5', 'appellation');
INSERT INTO `tbl_dic_value` VALUES ('1e0bd307e6ee425599327447f8387285', '将来联系', '将来联系', '2', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('2173663b40b949ce928db92607b5fe57', '丢失线索', '丢失线索', '5', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('2876690b7e744333b7f1867102f91153', '未启动', '未启动', '1', 'returnState');
INSERT INTO `tbl_dic_value` VALUES ('29805c804dd94974b568cfc9017b2e4c', '成交', '成交', '7', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('310e6a49bd8a4962b3f95a1d92eb76f4', '试图联系', '试图联系', '1', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('31539e7ed8c848fc913e1c2c93d76fd1', '博士', '博士', '4', 'appellation');
INSERT INTO `tbl_dic_value` VALUES ('37ef211719134b009e10b7108194cf46', '资质审查', '资质审查', '1', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('391807b5324d4f16bd58c882750ee632', '丢失的线索', '丢失的线索', '8', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('3a39605d67da48f2a3ef52e19d243953', '聊天', '聊天', '14', 'source');
INSERT INTO `tbl_dic_value` VALUES ('474ab93e2e114816abf3ffc596b19131', '低', '低', '3', 'returnPriority');
INSERT INTO `tbl_dic_value` VALUES ('48512bfed26145d4a38d3616e2d2cf79', '广告', '广告', '1', 'source');
INSERT INTO `tbl_dic_value` VALUES ('4d03a42898684135809d380597ed3268', '合作伙伴研讨会', '合作伙伴研讨会', '9', 'source');
INSERT INTO `tbl_dic_value` VALUES ('59795c49896947e1ab61b7312bd0597c', '先生', '先生', '1', 'appellation');
INSERT INTO `tbl_dic_value` VALUES ('5c6e9e10ca414bd499c07b886f86202a', '高', '高', '1', 'returnPriority');
INSERT INTO `tbl_dic_value` VALUES ('67165c27076e4c8599f42de57850e39c', '夫人', '夫人', '2', 'appellation');
INSERT INTO `tbl_dic_value` VALUES ('68a1b1e814d5497a999b8f1298ace62b', '因竞争丢失关闭', '因竞争丢失关闭', '9', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('6b86f215e69f4dbd8a2daa22efccf0cf', 'web调研', 'web调研', '13', 'source');
INSERT INTO `tbl_dic_value` VALUES ('72f13af8f5d34134b5b3f42c5d477510', '合作伙伴', '合作伙伴', '6', 'source');
INSERT INTO `tbl_dic_value` VALUES ('7c07db3146794c60bf975749952176df', '未联系', '未联系', '6', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('86c56aca9eef49058145ec20d5466c17', '内部研讨会', '内部研讨会', '10', 'source');
INSERT INTO `tbl_dic_value` VALUES ('9095bda1f9c34f098d5b92fb870eba17', '进行中', '进行中', '3', 'returnState');
INSERT INTO `tbl_dic_value` VALUES ('954b410341e7433faa468d3c4f7cf0d2', '已有业务', '已有业务', '1', 'transactionType');
INSERT INTO `tbl_dic_value` VALUES ('966170ead6fa481284b7d21f90364984', '已联系', '已联系', '3', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('96b03f65dec748caa3f0b6284b19ef2f', '推迟', '推迟', '2', 'returnState');
INSERT INTO `tbl_dic_value` VALUES ('97d1128f70294f0aac49e996ced28c8a', '新业务', '新业务', '2', 'transactionType');
INSERT INTO `tbl_dic_value` VALUES ('9ca96290352c40688de6596596565c12', '完成', '完成', '4', 'returnState');
INSERT INTO `tbl_dic_value` VALUES ('9e6d6e15232549af853e22e703f3e015', '需要条件', '需要条件', '7', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('9ff57750fac04f15b10ce1bbb5bb8bab', '需求分析', '需求分析', '2', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('a70dc4b4523040c696f4421462be8b2f', '等待某人', '等待某人', '5', 'returnState');
INSERT INTO `tbl_dic_value` VALUES ('a83e75ced129421dbf11fab1f05cf8b4', '推销电话', '推销电话', '2', 'source');
INSERT INTO `tbl_dic_value` VALUES ('ab8472aab5de4ae9b388b2f1409441c1', '常规', '常规', '5', 'returnPriority');
INSERT INTO `tbl_dic_value` VALUES ('ab8c2a3dc05f4e3dbc7a0405f721b040', '提案/报价', '提案/报价', '5', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('b924d911426f4bc5ae3876038bc7e0ad', 'web下载', 'web下载', '12', 'source');
INSERT INTO `tbl_dic_value` VALUES ('c13ad8f9e2f74d5aa84697bb243be3bb', '价值建议', '价值建议', '3', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('c83c0be184bc40708fd7b361b6f36345', '最低', '最低', '4', 'returnPriority');
INSERT INTO `tbl_dic_value` VALUES ('db867ea866bc44678ac20c8a4a8bfefb', '员工介绍', '员工介绍', '3', 'source');
INSERT INTO `tbl_dic_value` VALUES ('e44be1d99158476e8e44778ed36f4355', '确定决策者', '确定决策者', '4', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('e5f383d2622b4fc0959f4fe131dafc80', '女士', '女士', '3', 'appellation');
INSERT INTO `tbl_dic_value` VALUES ('e81577d9458f4e4192a44650a3a3692b', '谈判/复审', '谈判/复审', '6', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('fb65d7fdb9c6483db02713e6bc05dd19', '在线商场', '在线商场', '5', 'source');
INSERT INTO `tbl_dic_value` VALUES ('fd677cc3b5d047d994e16f6ece4d3d45', '公开媒介', '公开媒介', '7', 'source');
INSERT INTO `tbl_dic_value` VALUES ('ff802a03ccea4ded8731427055681d48', '外部介绍', '外部介绍', '4', 'source');

-- ----------------------------
-- Table structure for tbl_tran
-- ----------------------------
DROP TABLE IF EXISTS `tbl_tran`;
CREATE TABLE `tbl_tran` (
  `id` char(32) COLLATE utf8mb4_general_ci NOT NULL,
  `owner` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `money` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `expected_date` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `customer_id` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `stage` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `type` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `source` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `activity_id` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `contacts_id` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `create_by` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `create_time` char(19) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `edit_by` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `edit_time` char(19) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `contact_summary` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `next_contact_time` char(10) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_owner_tran` (`owner`),
  KEY `fk_c_b_tran` (`create_by`),
  KEY `fk_e_b_tran` (`edit_by`),
  KEY `fk_customer_id_tran` (`customer_id`),
  KEY `fk_activity_id_tran` (`activity_id`),
  KEY `fk_contacts_id_tran` (`contacts_id`),
  KEY `fk_stage_tran` (`stage`),
  KEY `fk_type_tran` (`type`),
  KEY `money` (`money`),
  KEY `expected_date` (`expected_date`),
  CONSTRAINT `fk_activity_id_tran` FOREIGN KEY (`activity_id`) REFERENCES `tbl_activity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_c_b_tran` FOREIGN KEY (`create_by`) REFERENCES `tbl_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_contacts_id_tran` FOREIGN KEY (`contacts_id`) REFERENCES `tbl_contacts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_customer_id_tran` FOREIGN KEY (`customer_id`) REFERENCES `tbl_customer` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_e_b_tran` FOREIGN KEY (`edit_by`) REFERENCES `tbl_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_owner_tran` FOREIGN KEY (`owner`) REFERENCES `tbl_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_stage_tran` FOREIGN KEY (`stage`) REFERENCES `tbl_dic_value` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_type_tran` FOREIGN KEY (`type`) REFERENCES `tbl_dic_value` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of tbl_tran
-- ----------------------------
INSERT INTO `tbl_tran` VALUES ('325fa47e85c743bdaabe55dee73a36c6', '06f5fc056eac41558a964f96daa7f27c', '200', '测试02', '2023-09-15', '2a93fb32323442579ac210bb54f597dc', 'e44be1d99158476e8e44778ed36f4355', '954b410341e7433faa468d3c4f7cf0d2', '12302fd42bd349c1bb768b19600e6b20', 'fbd4eb09644f4ebca1d135c48a6c9485', 'a31493af6baa4435a1b2e79999dee1ed', '06f5fc056eac41558a964f96daa7f27c', '2023-09-15 17:03:56', null, null, '测试02', '测试02', '2023-09-22');
INSERT INTO `tbl_tran` VALUES ('857a3dd3b539437c9fa30daf3f2fcd00', '06f5fc056eac41558a964f96daa7f27c', '3000', '测试03', '2023-09-27', 'c55de55982764078b8aa5815adfb7251', '29805c804dd94974b568cfc9017b2e4c', '954b410341e7433faa468d3c4f7cf0d2', '4d03a42898684135809d380597ed3268', 'fb413e44fd334611baae2050323247aa', 'a31493af6baa4435a1b2e79999dee1ed', '06f5fc056eac41558a964f96daa7f27c', '2023-09-15 20:05:02', null, null, '测试03', '测试03', '2023-12-29');
INSERT INTO `tbl_tran` VALUES ('994b6149bf2b4ea7b7436ed37615a74e', '06f5fc056eac41558a964f96daa7f27c', '10000', '中国政法大学-刑法讲座', '2023-09-11', '4285535ddbb949fe96ea1773f7aecda4', '29805c804dd94974b568cfc9017b2e4c', null, null, 'fbd4eb09644f4ebca1d135c48a6c9485', 'f73173371fe34549ac8466bbd696f3bf', '06f5fc056eac41558a964f96daa7f27c', '2023-09-11 11:49:41', null, null, null, null, null);
INSERT INTO `tbl_tran` VALUES ('db6ffbe5a1324ef3bc2bada8f65144c6', '06f5fc056eac41558a964f96daa7f27c', '100', '测试01', '2023-09-15', '2000300211', '9ff57750fac04f15b10ce1bbb5bb8bab', '97d1128f70294f0aac49e996ced28c8a', '12302fd42bd349c1bb768b19600e6b20', '95278be6ca9e4982aa0ae09d877deb2b', 'f1827a1e1cef4589b0892b519988f5f3', '06f5fc056eac41558a964f96daa7f27c', '2023-09-15 16:39:23', null, null, '测试01', '测试01', '2023-09-30');

-- ----------------------------
-- Table structure for tbl_tran_history
-- ----------------------------
DROP TABLE IF EXISTS `tbl_tran_history`;
CREATE TABLE `tbl_tran_history` (
  `id` char(32) COLLATE utf8mb4_general_ci NOT NULL,
  `stage` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `money` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `expected_date` char(10) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `create_time` char(19) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `create_by` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tran_id` char(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_stage_t_h` (`stage`),
  KEY `fk_create_by_t_h` (`create_by`),
  KEY `fk_tran_id_t_h` (`tran_id`),
  CONSTRAINT `fk_create_by_t_h` FOREIGN KEY (`create_by`) REFERENCES `tbl_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_stage_t_h` FOREIGN KEY (`stage`) REFERENCES `tbl_dic_value` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_tran_id_t_h` FOREIGN KEY (`tran_id`) REFERENCES `tbl_tran` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of tbl_tran_history
-- ----------------------------
INSERT INTO `tbl_tran_history` VALUES ('2000300211', '391807b5324d4f16bd58c882750ee632', '20000', '2023-12-28', '2023-09-16 09:25:42', '06f5fc056eac41558a964f96daa7f27c', '857a3dd3b539437c9fa30daf3f2fcd00');
INSERT INTO `tbl_tran_history` VALUES ('2167a99f07a94fec8108047b24a3d72f', '29805c804dd94974b568cfc9017b2e4c', '3000', '2023-09-27', '2023-09-15 20:05:02', '06f5fc056eac41558a964f96daa7f27c', '857a3dd3b539437c9fa30daf3f2fcd00');
INSERT INTO `tbl_tran_history` VALUES ('6efb860c6b7b4db9998c2169ba3edc2a', 'e44be1d99158476e8e44778ed36f4355', '200', '2023-09-15', '2023-09-17 11:16:41', '06f5fc056eac41558a964f96daa7f27c', '325fa47e85c743bdaabe55dee73a36c6');
INSERT INTO `tbl_tran_history` VALUES ('b5a9d5f4c58a4ef6b9a12610b1737ba7', 'e81577d9458f4e4192a44650a3a3692b', '200', '2023-09-15', '2023-09-17 10:57:59', '06f5fc056eac41558a964f96daa7f27c', '325fa47e85c743bdaabe55dee73a36c6');

-- ----------------------------
-- Table structure for tbl_tran_remark
-- ----------------------------
DROP TABLE IF EXISTS `tbl_tran_remark`;
CREATE TABLE `tbl_tran_remark` (
  `id` char(32) COLLATE utf8mb4_general_ci NOT NULL,
  `note_content` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `create_by` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `create_time` char(19) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `edit_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `edit_time` char(19) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `edit_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `tran_id` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_e_b_tran_remark` (`edit_by`),
  KEY `fk_c_b_tran_remark` (`create_by`),
  KEY `fk_tran_id_tran_remark` (`tran_id`),
  CONSTRAINT `fk_c_b_tran_remark` FOREIGN KEY (`create_by`) REFERENCES `tbl_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_e_b_tran_remark` FOREIGN KEY (`edit_by`) REFERENCES `tbl_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_tran_id_tran_remark` FOREIGN KEY (`tran_id`) REFERENCES `tbl_tran` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of tbl_tran_remark
-- ----------------------------
INSERT INTO `tbl_tran_remark` VALUES ('6eaa8a27bfa0471e86a08360cb77ef82', '老师好！！', '06f5fc056eac41558a964f96daa7f27c', null, '06f5fc056eac41558a964f96daa7f27c', '2023-09-06 10:38:03', '1', '994b6149bf2b4ea7b7436ed37615a74e');
INSERT INTO `tbl_tran_remark` VALUES ('e1844da0734c44f5a61c696277a96e7e', '法外狂徒，张三！', '06f5fc056eac41558a964f96daa7f27c', null, '06f5fc056eac41558a964f96daa7f27c', '2023-09-06 10:34:37', '1', '994b6149bf2b4ea7b7436ed37615a74e');
INSERT INTO `tbl_tran_remark` VALUES ('eb19402035554a6bbd54acc6cd1ab5b3', '罗翔老师！', '06f5fc056eac41558a964f96daa7f27c', null, null, null, '0', '994b6149bf2b4ea7b7436ed37615a74e');

-- ----------------------------
-- Table structure for tbl_user
-- ----------------------------
DROP TABLE IF EXISTS `tbl_user`;
CREATE TABLE `tbl_user` (
  `id` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'uuid\r\n            ',
  `login_act` varchar(255) DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `login_pwd` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '密码不能采用明文存储，采用密文，MD5加密之后的数据（采用AES）',
  `email` varchar(255) DEFAULT NULL,
  `expire_time` char(19) DEFAULT NULL COMMENT '失效时间为空的时候表示永不失效，失效时间为2018-10-10 10:10:10，则表示在该时间之前该账户可用。',
  `lock_state` char(1) DEFAULT NULL COMMENT '锁定状态为空时表示启用，为0时表示锁定，为1时表示启用。',
  `deptno` char(4) DEFAULT NULL,
  `allow_ips` varchar(255) DEFAULT NULL COMMENT '允许访问的IP为空时表示IP地址永不受限，允许访问的IP可以是一个，也可以是多个，当多个IP地址的时候，采用半角逗号分隔。允许IP是192.168.100.2，表示该用户只能在IP地址为192.168.100.2的机器上使用。',
  `createTime` char(19) DEFAULT NULL,
  `create_by` varchar(255) DEFAULT NULL,
  `edit_time` char(19) DEFAULT NULL,
  `edit_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`,`name`),
  KEY `id` (`id`),
  KEY `edit_by` (`edit_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Records of tbl_user
-- ----------------------------
INSERT INTO `tbl_user` VALUES ('06f5fc056eac41558a964f96daa7f27c', 'mrying', '邓和颖', '14e1b600b1fd579f47433b88e8d85291', '1234567891@qq.com', '2023-7-27 21:50:05', '1', 'A001', '192.168.1.1,0:0:0:0:0:0:0:1,127.0.0.1', '2023-7-27 12:11:40', '邓和颖', null, null);
