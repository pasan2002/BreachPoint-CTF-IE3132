/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.11.19-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: ctfd
-- ------------------------------------------------------
-- Server version	10.11.19-MariaDB-ubu2204

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `alembic_version`
--

DROP TABLE IF EXISTS `alembic_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `alembic_version` (
  `version_num` varchar(32) NOT NULL,
  PRIMARY KEY (`version_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alembic_version`
--

LOCK TABLES `alembic_version` WRITE;
/*!40000 ALTER TABLE `alembic_version` DISABLE KEYS */;
INSERT INTO `alembic_version` VALUES
('48d8250d19bd');
/*!40000 ALTER TABLE `alembic_version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `awards`
--

DROP TABLE IF EXISTS `awards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `awards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `team_id` int(11) DEFAULT NULL,
  `name` varchar(80) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `date` datetime(6) DEFAULT NULL,
  `value` int(11) DEFAULT NULL,
  `category` varchar(80) DEFAULT NULL,
  `icon` text DEFAULT NULL,
  `requirements` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`requirements`)),
  `type` varchar(80) DEFAULT 'standard',
  PRIMARY KEY (`id`),
  KEY `awards_ibfk_1` (`team_id`),
  KEY `awards_ibfk_2` (`user_id`),
  CONSTRAINT `awards_ibfk_1` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE,
  CONSTRAINT `awards_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `awards`
--

LOCK TABLES `awards` WRITE;
/*!40000 ALTER TABLE `awards` DISABLE KEYS */;
/*!40000 ALTER TABLE `awards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `brackets`
--

DROP TABLE IF EXISTS `brackets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `brackets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `type` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `brackets`
--

LOCK TABLES `brackets` WRITE;
/*!40000 ALTER TABLE `brackets` DISABLE KEYS */;
/*!40000 ALTER TABLE `brackets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `challenge_topics`
--

DROP TABLE IF EXISTS `challenge_topics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `challenge_topics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `challenge_id` int(11) DEFAULT NULL,
  `topic_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `challenge_id` (`challenge_id`),
  KEY `topic_id` (`topic_id`),
  CONSTRAINT `challenge_topics_ibfk_1` FOREIGN KEY (`challenge_id`) REFERENCES `challenges` (`id`) ON DELETE CASCADE,
  CONSTRAINT `challenge_topics_ibfk_2` FOREIGN KEY (`topic_id`) REFERENCES `topics` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `challenge_topics`
--

LOCK TABLES `challenge_topics` WRITE;
/*!40000 ALTER TABLE `challenge_topics` DISABLE KEYS */;
/*!40000 ALTER TABLE `challenge_topics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `challenges`
--

DROP TABLE IF EXISTS `challenges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `challenges` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `max_attempts` int(11) DEFAULT NULL,
  `value` int(11) DEFAULT NULL,
  `category` varchar(80) DEFAULT NULL,
  `type` varchar(80) DEFAULT NULL,
  `state` varchar(80) NOT NULL,
  `requirements` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`requirements`)),
  `connection_info` text DEFAULT NULL,
  `next_id` int(11) DEFAULT NULL,
  `attribution` text DEFAULT NULL,
  `logic` varchar(80) NOT NULL,
  `initial` int(11) DEFAULT NULL,
  `minimum` int(11) DEFAULT NULL,
  `decay` int(11) DEFAULT NULL,
  `function` varchar(32) DEFAULT NULL,
  `position` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `next_id` (`next_id`),
  CONSTRAINT `challenges_ibfk_1` FOREIGN KEY (`next_id`) REFERENCES `challenges` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `challenges`
--

LOCK TABLES `challenges` WRITE;
/*!40000 ALTER TABLE `challenges` DISABLE KEYS */;
INSERT INTO `challenges` VALUES
(1,'Open Eyes','The attacker started with nothing except the target company name. Before touching any system directly, they performed passive reconnaissance against NovaTech Corp\'s public website. In doing so, they investigated sensitive information that a developer had inadvertently left behind in the page source and published corporate assets.',0,100,'OSINT / Reconnaissance','standard','visible',NULL,NULL,NULL,NULL,'any',NULL,NULL,NULL,'static',0),
(2,'Knock Knock','Building on the reconnaissance clues discovered in Stage 1, the attacker performed path enumeration against the corporate web server. Their objective was to map out the hidden surface of the application and locate exposed administrative and development endpoints.',0,150,'Web Recon / API Security','standard','visible','{\"prerequisites\": [1], \"anonymize\": false}',NULL,NULL,NULL,'any',NULL,NULL,NULL,'static',0),
(3,'The Login Wall','Armed with credentials recovered from the exposed API, the attacker navigated to NovaTech Corp\'s internal administrative portal. Bypassing the authentication wall granted access to the internal dashboard where restricted backup data resides.',0,200,'Web Security / Authentication','standard','visible','{\"prerequisites\": [2], \"anonymize\": false}',NULL,NULL,NULL,'any',NULL,NULL,NULL,'static',0),
(4,'Scrambled Secrets','From the internal portal, the attacker located an internal diagnostic and maintenance utility. Analyzing the diagnostic tool\'s handling of user input revealed a critical vulnerability allowing unauthorized access to the server\'s encrypted configuration archives.',0,250,'Cryptography / Web','standard','visible','{\"prerequisites\": [3], \"anonymize\": false}',NULL,NULL,NULL,'any',NULL,NULL,NULL,'static',0),
(5,'Dead Logs Tell Tales','Using the recovered access credentials, the attacker established a remote SSH session into NovaTech\'s internal deployment server as the low-privilege deploy user. Instead of immediate escalation, they conducted post-exploitation filesystem forensics, investigating shell history and encrypted archives for leftover artifacts.',0,350,'Digital Forensics','standard','visible','{\"prerequisites\": [4], \"anonymize\": false}',NULL,NULL,NULL,'any',NULL,NULL,NULL,'static',0),
(6,'Root of Evil','Operating from the low-privilege deploy shell, the attacker audited the Linux system for privilege escalation vectors. Identifying an insecurely configured SUID binary, they leveraged a sandbox escape to break out of the restricted environment and achieve full root compromise.',0,500,'Linux / System Security','standard','visible','{\"prerequisites\": [5], \"anonymize\": false}',NULL,NULL,NULL,'any',NULL,NULL,NULL,'static',0);
/*!40000 ALTER TABLE `challenges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(80) DEFAULT NULL,
  `content` text DEFAULT NULL,
  `date` datetime(6) DEFAULT NULL,
  `author_id` int(11) DEFAULT NULL,
  `challenge_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `team_id` int(11) DEFAULT NULL,
  `page_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `author_id` (`author_id`),
  KEY `challenge_id` (`challenge_id`),
  KEY `page_id` (`page_id`),
  KEY `team_id` (`team_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`challenge_id`) REFERENCES `challenges` (`id`) ON DELETE CASCADE,
  CONSTRAINT `comments_ibfk_3` FOREIGN KEY (`page_id`) REFERENCES `pages` (`id`) ON DELETE CASCADE,
  CONSTRAINT `comments_ibfk_4` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE,
  CONSTRAINT `comments_ibfk_5` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `config`
--

DROP TABLE IF EXISTS `config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` text DEFAULT NULL,
  `value` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `config`
--

LOCK TABLES `config` WRITE;
/*!40000 ALTER TABLE `config` DISABLE KEYS */;
INSERT INTO `config` VALUES
(1,'ctf_version','3.8.7'),
(2,'dynamic_challenges_alembic_version','93284ed9c099'),
(3,'ctf_name','BreachPoint CTF'),
(4,'ctf_description','Multi-Stage Enterprise Penetration Testing Assessment\r\n'),
(5,'user_mode','users'),
(6,'ctf_logo','cc30830e1cc582d032c2c8682c4a4787/breachpoint_logo_1790130796144.jpg'),
(7,'ctf_theme','core'),
(8,'theme_header','<style>\r\n/* Clean Developer Theme - No Neon Glows or Oversized Radii */\r\n:root {\r\n  --bg-canvas: #0d1117;\r\n  --bg-panel: #161b22;\r\n  --bg-header: #1f242c;\r\n  --border-line: #30363d;\r\n  --text-white: #f0f6fc;\r\n  --text-body: #c9d1d9;\r\n  --text-muted: #8b949e;\r\n  --btn-green: #238636;\r\n  --tag-bg: #21262d;\r\n}\r\n\r\nbody {\r\n  background-color: var(--bg-canvas) !important;\r\n  color: var(--text-body) !important;\r\n  font-family: -apple-system, BlinkMacSystemFont, \"Segoe UI\", Helvetica, Arial, sans-serif;\r\n}\r\n\r\n/* Hide default CTFd elements */\r\n.jumbotron { display: none !important; }\r\n.thm-active [x-data=\'ChallengeBoard\'] { display: none !important; }\r\n\r\n/* Target Info Box */\r\n.target-spec-card {\r\n  background: var(--bg-panel);\r\n  border: 1px solid var(--border-line);\r\n  border-radius: 4px;\r\n  padding: 16px 20px;\r\n  margin-top: 20px;\r\n  margin-bottom: 24px;\r\n  font-size: 0.9rem;\r\n}\r\n\r\n.target-spec-header {\r\n  display: flex;\r\n  justify-content: space-between;\r\n  align-items: baseline;\r\n  border-bottom: 1px solid var(--border-line);\r\n  padding-bottom: 10px;\r\n  margin-bottom: 12px;\r\n}\r\n\r\n.target-title {\r\n  font-size: 1.15rem;\r\n  font-weight: 700;\r\n  color: var(--text-white);\r\n  margin: 0;\r\n}\r\n\r\n.target-stats {\r\n  font-size: 0.85rem;\r\n  color: var(--text-muted);\r\n}\r\n\r\n.target-points {\r\n  font-weight: 700;\r\n  color: #3fb950;\r\n  margin-right: 8px;\r\n}\r\n\r\n.target-endpoint-row {\r\n  display: flex;\r\n  gap: 20px;\r\n  font-family: ui-monospace, SFMono-Regular, Consolas, monospace;\r\n  font-size: 0.85rem;\r\n  color: var(--text-white);\r\n  background: #0d1117;\r\n  padding: 8px 12px;\r\n  border: 1px solid var(--border-line);\r\n  border-radius: 4px;\r\n  margin-top: 12px;\r\n}\r\n\r\n/* Task Accordion Cards */\r\n.task-row-card {\r\n  background: var(--bg-panel);\r\n  border: 1px solid var(--border-line);\r\n  border-radius: 4px;\r\n  margin-bottom: 12px;\r\n}\r\n\r\n.task-row-card.solved {\r\n  border-left: 3px solid #238636;\r\n}\r\n\r\n.task-header-bar {\r\n  background: var(--bg-header);\r\n  padding: 12px 18px;\r\n  cursor: pointer;\r\n  display: flex;\r\n  justify-content: space-between;\r\n  align-items: center;\r\n  user-select: none;\r\n}\r\n\r\n.task-header-bar:hover {\r\n  background: #252b35;\r\n}\r\n\r\n.task-left-meta {\r\n  display: flex;\r\n  align-items: center;\r\n  gap: 12px;\r\n}\r\n\r\n.task-id-badge {\r\n  font-family: ui-monospace, monospace;\r\n  font-size: 0.78rem;\r\n  font-weight: 700;\r\n  padding: 2px 6px;\r\n  border-radius: 3px;\r\n  background: var(--tag-bg);\r\n  border: 1px solid var(--border-line);\r\n  color: var(--text-white);\r\n}\r\n\r\n.task-row-card.solved .task-id-badge {\r\n  color: #3fb950;\r\n  border-color: rgba(63, 185, 80, 0.4);\r\n}\r\n\r\n.task-name-text {\r\n  font-size: 0.95rem;\r\n  font-weight: 600;\r\n  color: var(--text-white);\r\n}\r\n\r\n.task-cat-text {\r\n  font-size: 0.75rem;\r\n  color: var(--text-muted);\r\n  background: #0d1117;\r\n  padding: 2px 6px;\r\n  border-radius: 3px;\r\n  border: 1px solid var(--border-line);\r\n}\r\n\r\n.task-right-meta {\r\n  display: flex;\r\n  align-items: center;\r\n  gap: 14px;\r\n  font-size: 0.85rem;\r\n}\r\n\r\n.task-pts-badge {\r\n  font-weight: 600;\r\n  color: #58a6ff;\r\n}\r\n\r\n.task-row-card.solved .task-pts-badge {\r\n  color: #3fb950;\r\n}\r\n\r\n.task-content-body {\r\n  padding: 18px;\r\n  border-top: 1px solid var(--border-line);\r\n  display: none;\r\n  font-size: 0.9rem;\r\n}\r\n\r\n.task-content-body.open {\r\n  display: block;\r\n}\r\n\r\n.task-briefing-text {\r\n  color: var(--text-body);\r\n  margin-bottom: 16px;\r\n  line-height: 1.5;\r\n}\r\n\r\n/* Hints list */\r\n.hints-container {\r\n  margin-bottom: 16px;\r\n  padding-top: 8px;\r\n}\r\n\r\n.btn-hint-tag {\r\n  background: var(--tag-bg);\r\n  border: 1px solid var(--border-line);\r\n  color: var(--text-muted);\r\n  font-size: 0.8rem;\r\n  padding: 4px 10px;\r\n  border-radius: 4px;\r\n  cursor: pointer;\r\n  margin-right: 6px;\r\n  margin-bottom: 6px;\r\n}\r\n\r\n.btn-hint-tag:hover {\r\n  color: var(--text-white);\r\n  border-color: #8b949e;\r\n}\r\n\r\n.hint-revealed-block {\r\n  background: #0d1117;\r\n  border: 1px solid var(--border-line);\r\n  border-left: 3px solid #d29922;\r\n  border-radius: 3px;\r\n  padding: 8px 12px;\r\n  font-size: 0.85rem;\r\n  margin-top: 6px;\r\n}\r\n\r\n/* Flag Input Bar */\r\n.submit-input-group {\r\n  display: flex;\r\n  gap: 8px;\r\n  max-width: 540px;\r\n  align-items: center;\r\n}\r\n\r\n.flag-text-field {\r\n  flex: 1;\r\n  background: #0d1117;\r\n  border: 1px solid var(--border-line);\r\n  border-radius: 4px;\r\n  padding: 6px 10px;\r\n  color: var(--text-white);\r\n  font-family: ui-monospace, Consolas, monospace;\r\n  font-size: 0.85rem;\r\n}\r\n\r\n.flag-text-field:focus {\r\n  border-color: #58a6ff;\r\n  outline: none;\r\n}\r\n\r\n.btn-submit-flag {\r\n  background: var(--btn-green);\r\n  color: #ffffff;\r\n  border: 1px solid rgba(240, 246, 252, 0.1);\r\n  font-weight: 600;\r\n  font-size: 0.85rem;\r\n  padding: 6px 14px;\r\n  border-radius: 4px;\r\n  cursor: pointer;\r\n}\r\n\r\n.btn-submit-flag:hover {\r\n  background: #2ea043;\r\n}\r\n\r\n.flag-result-msg {\r\n  font-size: 0.85rem;\r\n  margin-top: 8px;\r\n  font-weight: 600;\r\n}\r\n.flag-result-msg.ok { color: #3fb950; }\r\n.flag-result-msg.err { color: #f85149; }\r\n</style>'),
(9,'start',''),
(10,'end',''),
(11,'freeze',NULL),
(12,'challenge_visibility','private'),
(13,'registration_visibility','public'),
(14,'score_visibility','public'),
(15,'account_visibility','public'),
(16,'verify_emails','false'),
(17,'social_shares','false'),
(18,'team_size',''),
(19,'mail_server',NULL),
(20,'mail_port',NULL),
(21,'mail_tls',NULL),
(22,'mail_ssl',NULL),
(23,'mail_username',NULL),
(24,'mail_password',NULL),
(25,'mail_useauth',NULL),
(26,'setup','1'),
(27,'version_latest',NULL),
(28,'next_update_check','1790174884'),
(29,'theme_footer','<script>\r\n(function () {\r\n  const BACKUP_HINTS = {\r\n    1: [\r\n      { content: \"Always check what the browser isn\'t rendering for you.\", cost: 0 },\r\n      { content: \"Images carry more than just pixels, investigate their metadata.\", cost: 20 }\r\n    ],\r\n    2: [\r\n      { content: \"The server is hiding more than one path. Tools exist specifically to find them automatically.\", cost: 0 },\r\n      { content: \"Try gobuster with a common wordlist against the web server - look at what comes back with Status 200.\", cost: 30 },\r\n      { content: \"Once you find the API endpoint, try to access it directly — no credentials needed.\", cost: 50 }\r\n    ],\r\n    3: [\r\n      { content: \"You already have everything you need to get through this door. Check what Stage 2 gave you.\", cost: 0 },\r\n      { content: \"The credentials found in the API response are valid for this portal.\", cost: 40 },\r\n      { content: \"Logging in grants guest privileges. Inspect your session cookies in DevTools or Burp Suite to see if your role can be tampered with.\", cost: 50 }\r\n    ],\r\n    4: [\r\n      { content: \"This tool does more than ping. Try giving it something unexpected.\", cost: 0 },\r\n      { content: \"Look for the padding characters at the end of the cipher text. This is a well-known web encoding method.\", cost: 40 },\r\n      { content: \"After Base64 and ROT13, the final layer needs a key. You have already found it in stage 1 — pay attention to the footer.\", cost: 70 }\r\n    ],\r\n    5: [\r\n      { content: \"A good investigator always checks what the previous user did on the system.\", cost: 0 },\r\n      { content: \"Shell history records every command including references to other files that may still exist.\", cost: 60 },\r\n      { content: \"Production containers do not host cracking tools. Transfer the encrypted archive to your workstation via scp and launch an offline dictionary attack.\", cost: 100 }\r\n    ],\r\n    6: [\r\n      { content: \"On Linux, some programs run as root regardless of who executes them. Find them.\", cost: 0 },\r\n      { content: \"Use the find command with permission flags to locate files with the SUID bit set.\", cost: 100 },\r\n      { content: \"The binary behaves like a file reader. Once you are inside it, think about what else a file reader might let you do. GTFOBins documents exactly this.\", cost: 150 }\r\n    ]\r\n  };\r\n\r\n  async function renderChallengeWorkspace() {\r\n    if (!window.location.pathname.startsWith(\"/challenges\")) return;\r\n    if (document.getElementById(\"ctf-workspace\")) return;\r\n\r\n    const board = document.querySelector(\"[x-data=\'ChallengeBoard\']\");\r\n    if (!board) return;\r\n\r\n    try {\r\n      const res = await fetch(\"/api/v1/challenges\");\r\n      const data = await res.json();\r\n      if (!data.success || !data.data || data.data.length === 0) return;\r\n\r\n      const challenges = data.data;\r\n\r\n      const workspace = document.createElement(\"div\");\r\n      workspace.id = \"ctf-workspace\";\r\n\r\n      workspace.innerHTML = `\r\n        <div class=\"target-spec-card\">\r\n          <div class=\"target-spec-header\">\r\n            <h2 class=\"target-title\">Target Environment: NovaTech Infrastructure</h2>\r\n            <div class=\"target-stats\"><span class=\"target-points\">1,550 Pts</span>6 Sequential Stages</div>\r\n          </div>\r\n          <div style=\"color: #8b949e; font-size: 0.88rem; line-height: 1.5;\">\r\n            Follow the penetration testing path from passive reconnaissance to root privilege escalation. Solve each challenge to unlock subsequent attack vectors.\r\n          </div>\r\n          <div class=\"target-endpoint-row\">\r\n            <div>Web Target: <strong>http://&lt;ip_address&gt;</strong></div>\r\n            <div>SSH Service: <strong>&lt;username&gt;@&lt;ip_address&gt; -p 2222</strong></div>\r\n          </div>\r\n        </div>\r\n        <div id=\"task-card-list\"></div>\r\n      `;\r\n\r\n      board.parentNode.insertBefore(workspace, board);\r\n      document.body.classList.add(\"thm-active\");\r\n\r\n      const cardList = document.getElementById(\"task-card-list\");\r\n      let autoExpanded = false;\r\n\r\n      for (let i = 0; i < challenges.length; i++) {\r\n        const c = challenges[i];\r\n        const taskIdx = i + 1;\r\n        const isSolved = c.solved_by_me;\r\n\r\n        let shouldOpen = false;\r\n        if (!isSolved && !autoExpanded) {\r\n          shouldOpen = true;\r\n          autoExpanded = true;\r\n        }\r\n\r\n        const detailRes = await fetch(`/api/v1/challenges/${c.id}`);\r\n        const detailJson = await detailRes.json();\r\n        const detail = detailJson.data || {};\r\n\r\n        const card = document.createElement(\"div\");\r\n        card.className = `task-row-card ${isSolved ? \"solved\" : \"\"}`;\r\n        card.id = `card-id-${c.id}`;\r\n\r\n        card.innerHTML = `\r\n          <div class=\"task-header-bar\" onclick=\"document.getElementById(\'body-${c.id}\').classList.toggle(\'open\')\">\r\n            <div class=\"task-left-meta\">\r\n              <span class=\"task-id-badge\">${isSolved ? \"SOLVED\" : \"STAGE \" + taskIdx}</span>\r\n              <span class=\"task-name-text\">${c.name}</span>\r\n              <span class=\"task-cat-text\">${c.category}</span>\r\n            </div>\r\n            <div class=\"task-right-meta\">\r\n              <span class=\"task-pts-badge\">${c.value} pts</span>\r\n              <span style=\"color: #8b949e; font-size: 0.8rem;\">${isSolved ? \"Completed\" : \"Details\"}</span>\r\n            </div>\r\n          </div>\r\n\r\n          <div class=\"task-content-body ${shouldOpen ? \'open\' : \'\'}\" id=\"body-${c.id}\">\r\n            <div class=\"task-briefing-text\">\r\n              <strong>Objective:</strong><br>\r\n              ${detail.description || \'No challenge description provided.\'}\r\n            </div>\r\n\r\n            <div class=\"hints-container\" id=\"hints-box-${c.id}\">\r\n              <div style=\"font-size: 0.78rem; font-weight: 600; color: #8b949e; margin-bottom: 6px; text-transform: uppercase;\">Investigation Hints</div>\r\n            </div>\r\n\r\n            <div class=\"submit-input-group\">\r\n              <input type=\"text\" class=\"flag-text-field\" id=\"input-${c.id}\" placeholder=\"BPCTF{...}\" ${isSolved ? \'disabled value=\"Flag Captured\"\' : \'\'} />\r\n              <button class=\"btn-submit-flag\" id=\"btn-${c.id}\" onclick=\"submitFlag(${c.id})\" ${isSolved ? \'disabled style=\"background: #21262d; border-color: #30363d; color: #8b949e;\"\' : \'\'}>\r\n                ${isSolved ? \"Completed\" : \"Submit\"}\r\n              </button>\r\n            </div>\r\n            <div class=\"flag-result-msg\" id=\"msg-${c.id}\"></div>\r\n          </div>\r\n        `;\r\n\r\n        cardList.appendChild(card);\r\n\r\n        const hintsBox = document.getElementById(`hints-box-${c.id}`);\r\n        const activeHints = (detail.hints && detail.hints.length > 0) ? detail.hints : (BACKUP_HINTS[taskIdx] || []);\r\n\r\n        activeHints.forEach((h, hIdx) => {\r\n          const cost = typeof h === \"object\" && h.cost !== undefined ? h.cost : 0;\r\n          const text = typeof h === \"object\" && h.content ? h.content : (BACKUP_HINTS[taskIdx] ? BACKUP_HINTS[taskIdx][hIdx].content : \"\");\r\n          const hintId = typeof h === \"object\" && h.id ? h.id : null;\r\n\r\n          const btn = document.createElement(\"button\");\r\n          btn.className = \"btn-hint-tag\";\r\n          btn.textContent = cost === 0 ? `Hint ${hIdx + 1} (Free)` : `Hint ${hIdx + 1} (-${cost} pts)`;\r\n\r\n          btn.onclick = async function () {\r\n            if (cost > 0) {\r\n              if (!confirm(`Unlock Hint ${hIdx + 1} for a ${cost} point deduction?`)) return;\r\n            }\r\n\r\n            if (hintId) {\r\n              try {\r\n                await fetch(`/api/v1/hints/${hintId}`, {\r\n                  method: \"POST\",\r\n                  headers: {\r\n                    \"Content-Type\": \"application/json\",\r\n                    \"CSRF-Token\": window.init ? window.init.csrfNonce : \"\"\r\n                  }\r\n                });\r\n              } catch (e) {}\r\n            }\r\n\r\n            btn.remove();\r\n            const revealed = document.createElement(\"div\");\r\n            revealed.className = \"hint-revealed-block\";\r\n            revealed.innerHTML = `<strong>Hint ${hIdx + 1}:</strong> ${text}`;\r\n            hintsBox.appendChild(revealed);\r\n          };\r\n\r\n          hintsBox.appendChild(btn);\r\n        });\r\n      }\r\n    } catch (e) {\r\n      console.error(e);\r\n    }\r\n  }\r\n\r\n  window.submitFlag = async function (id) {\r\n    const input = document.getElementById(`input-${id}`);\r\n    const msg = document.getElementById(`msg-${id}`);\r\n    const flag = input.value.trim();\r\n    if (!flag) return;\r\n\r\n    msg.textContent = \"Validating flag...\";\r\n    msg.className = \"flag-result-msg\";\r\n\r\n    const res = await fetch(\"/api/v1/challenges/attempt\", {\r\n      method: \"POST\",\r\n      headers: {\r\n        \"Content-Type\": \"application/json\",\r\n        \"CSRF-Token\": window.init ? window.init.csrfNonce : \"\"\r\n      },\r\n      body: JSON.stringify({ challenge_id: id, submission: flag })\r\n    });\r\n\r\n    const data = await res.json();\r\n    if (data.success && data.data.status === \"correct\") {\r\n      msg.textContent = \"Flag accepted. Unlocking subsequent stage...\";\r\n      msg.className = \"flag-result-msg ok\";\r\n      input.disabled = true;\r\n\r\n      const card = document.getElementById(`card-id-${id}`);\r\n      if (card) card.classList.add(\"solved\");\r\n\r\n      setTimeout(() => {\r\n        window.location.reload();\r\n      }, 1000);\r\n    } else {\r\n      msg.textContent = \"Incorrect flag submitted. Check string formatting.\";\r\n      msg.className = \"flag-result-msg err\";\r\n    }\r\n  };\r\n\r\n  if (document.readyState === \"loading\") {\r\n    document.addEventListener(\"DOMContentLoaded\", renderChallengeWorkspace);\r\n  } else {\r\n    renderChallengeWorkspace();\r\n  }\r\n})();\r\n</script>'),
(30,'theme_settings','');
/*!40000 ALTER TABLE `config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dynamic_challenge`
--

DROP TABLE IF EXISTS `dynamic_challenge`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `dynamic_challenge` (
  `id` int(11) NOT NULL,
  `dynamic_initial` int(11) DEFAULT NULL,
  `dynamic_minimum` int(11) DEFAULT NULL,
  `dynamic_decay` int(11) DEFAULT NULL,
  `dynamic_function` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `dynamic_challenge_ibfk_1` FOREIGN KEY (`id`) REFERENCES `challenges` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dynamic_challenge`
--

LOCK TABLES `dynamic_challenge` WRITE;
/*!40000 ALTER TABLE `dynamic_challenge` DISABLE KEYS */;
/*!40000 ALTER TABLE `dynamic_challenge` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `field_entries`
--

DROP TABLE IF EXISTS `field_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `field_entries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(80) DEFAULT NULL,
  `value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`value`)),
  `field_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `team_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `field_id` (`field_id`),
  KEY `team_id` (`team_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `field_entries_ibfk_1` FOREIGN KEY (`field_id`) REFERENCES `fields` (`id`) ON DELETE CASCADE,
  CONSTRAINT `field_entries_ibfk_2` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE,
  CONSTRAINT `field_entries_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `field_entries`
--

LOCK TABLES `field_entries` WRITE;
/*!40000 ALTER TABLE `field_entries` DISABLE KEYS */;
/*!40000 ALTER TABLE `field_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fields`
--

DROP TABLE IF EXISTS `fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `fields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` text DEFAULT NULL,
  `type` varchar(80) DEFAULT NULL,
  `field_type` varchar(80) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `required` tinyint(1) DEFAULT NULL,
  `public` tinyint(1) DEFAULT NULL,
  `editable` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fields`
--

LOCK TABLES `fields` WRITE;
/*!40000 ALTER TABLE `fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `files`
--

DROP TABLE IF EXISTS `files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `files` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(80) DEFAULT NULL,
  `location` text DEFAULT NULL,
  `challenge_id` int(11) DEFAULT NULL,
  `page_id` int(11) DEFAULT NULL,
  `sha1sum` varchar(40) DEFAULT NULL,
  `solution_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `page_id` (`page_id`),
  KEY `files_ibfk_1` (`challenge_id`),
  KEY `solution_id` (`solution_id`),
  CONSTRAINT `files_ibfk_1` FOREIGN KEY (`challenge_id`) REFERENCES `challenges` (`id`) ON DELETE CASCADE,
  CONSTRAINT `files_ibfk_2` FOREIGN KEY (`page_id`) REFERENCES `pages` (`id`),
  CONSTRAINT `files_ibfk_3` FOREIGN KEY (`solution_id`) REFERENCES `solutions` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `files`
--

LOCK TABLES `files` WRITE;
/*!40000 ALTER TABLE `files` DISABLE KEYS */;
INSERT INTO `files` VALUES
(1,'standard','cc30830e1cc582d032c2c8682c4a4787/breachpoint_logo_1790130796144.jpg',NULL,NULL,'55c2a4d13cb33da51b8e96768415670e95616f99',NULL);
/*!40000 ALTER TABLE `files` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flags`
--

DROP TABLE IF EXISTS `flags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `flags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `challenge_id` int(11) DEFAULT NULL,
  `type` varchar(80) DEFAULT NULL,
  `content` text DEFAULT NULL,
  `data` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `flags_ibfk_1` (`challenge_id`),
  CONSTRAINT `flags_ibfk_1` FOREIGN KEY (`challenge_id`) REFERENCES `challenges` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flags`
--

LOCK TABLES `flags` WRITE;
/*!40000 ALTER TABLE `flags` DISABLE KEYS */;
INSERT INTO `flags` VALUES
(1,1,'static','BPCTF{r3c0n_m4st3r}','case_sensitive'),
(2,2,'static','BPCTF{4p1_3xp0sur3_l34ks_cr3ds}','case_sensitive'),
(3,3,'static','BPCTF{4uth_p0rt4l_4cc3ss}','case_sensitive'),
(4,4,'static','BPCTF{crypt0_l4y3rs_d3c0d3d}','case_sensitive'),
(5,5,'static','BPCTF{f0r3ns1cs_4rt3f4ct_r3c0v3r3d}','case_sensitive'),
(6,6,'static','BPCTF{r00t_pr1v3sc_m1ss10n_c0mpl3t3}','case_sensitive');
/*!40000 ALTER TABLE `flags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hints`
--

DROP TABLE IF EXISTS `hints`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hints` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(80) DEFAULT NULL,
  `challenge_id` int(11) DEFAULT NULL,
  `content` text DEFAULT NULL,
  `cost` int(11) DEFAULT NULL,
  `requirements` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`requirements`)),
  `title` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `hints_ibfk_1` (`challenge_id`),
  CONSTRAINT `hints_ibfk_1` FOREIGN KEY (`challenge_id`) REFERENCES `challenges` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hints`
--

LOCK TABLES `hints` WRITE;
/*!40000 ALTER TABLE `hints` DISABLE KEYS */;
INSERT INTO `hints` VALUES
(1,'standard',1,'Always check what the browser isn\'t rendering for you.',0,NULL,NULL),
(2,'standard',1,'Images carry more than just pixels, investigate their metadata.',20,NULL,NULL),
(3,'standard',2,'The server is hiding more than one path. Tools exist specifically to find them automatically.',0,NULL,NULL),
(4,'standard',2,'Try gobuster with a common wordlist against the web server - look at what comes back with Status 200.',30,NULL,NULL),
(5,'standard',2,'Once you find the API endpoint, try to access it directly - no credentials needed.',50,NULL,NULL),
(6,'standard',3,'You already have everything you need to get through this door. Check what Stage 2 gave you.',0,NULL,NULL),
(7,'standard',3,'The credentials found in the API response are valid for this portal.',40,NULL,NULL),
(8,'standard',3,'Logging in grants guest privileges. Inspect your session cookies in DevTools or Burp Suite to see if your role can be tampered with.',50,NULL,NULL),
(9,'standard',4,'This tool does more than ping. Try giving it something unexpected.',0,NULL,NULL),
(10,'standard',4,'Look for the padding characters at the end of the cipher text. This is a well known web encoding method.',40,NULL,NULL),
(11,'standard',4,'After Base64 and ROT13, the final layer needs a key. You have already found it in stage 1 pay attention to the footer.',70,NULL,NULL),
(12,'standard',5,'A good investigator always checks what the previous user did on the system.',0,NULL,NULL),
(13,'standard',5,'Shell history records every command including references to other files that may still exist.',60,NULL,NULL),
(14,'standard',5,'Production containers do not host cracking tools. Transfer the encrypted archive to your workstation via scp and launch an offline dictionary attack.',100,NULL,NULL),
(15,'standard',6,'On Linux, some programs run as root regardless of who executes them. Find them.',0,NULL,NULL),
(16,'standard',6,'Use the find command with permission flags to locate files with the SUID bit set.',100,NULL,NULL),
(17,'standard',6,'The binary behaves like a file reader. Once you are inside it, think about what else a file reader might let you do. GTFOBins documents exactly this.',150,NULL,NULL);
/*!40000 ALTER TABLE `hints` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text DEFAULT NULL,
  `content` text DEFAULT NULL,
  `date` datetime(6) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `team_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `team_id` (`team_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`),
  CONSTRAINT `notifications_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pages`
--

DROP TABLE IF EXISTS `pages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `pages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(80) DEFAULT NULL,
  `route` varchar(128) DEFAULT NULL,
  `content` text DEFAULT NULL,
  `draft` tinyint(1) DEFAULT NULL,
  `hidden` tinyint(1) DEFAULT NULL,
  `auth_required` tinyint(1) DEFAULT NULL,
  `format` varchar(80) DEFAULT NULL,
  `link_target` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `route` (`route`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pages`
--

LOCK TABLES `pages` WRITE;
/*!40000 ALTER TABLE `pages` DISABLE KEYS */;
INSERT INTO `pages` VALUES
(1,'BreachPoint CTF','index','<style>\r\n:root {\r\n  --surface-bg: #0d1117;\r\n  --panel-bg: #161b22;\r\n  --panel-border: #30363d;\r\n  --text-primary: #c9d1d9;\r\n  --text-heading: #f0f6fc;\r\n  --text-secondary: #8b949e;\r\n  --brand-blue: #58a6ff;\r\n  --brand-green: #238636;\r\n}\r\n\r\nbody {\r\n  background-color: var(--surface-bg) !important;\r\n  color: var(--text-primary) !important;\r\n  font-family: -apple-system, BlinkMacSystemFont, \"Segoe UI\", Helvetica, Arial, sans-serif;\r\n  line-height: 1.5;\r\n}\r\n\r\n.ctf-header-block {\r\n  padding: 32px 0 24px 0;\r\n  border-bottom: 1px solid var(--panel-border);\r\n  margin-bottom: 28px;\r\n}\r\n\r\n.ctf-title {\r\n  font-size: 2rem;\r\n  font-weight: 700;\r\n  color: var(--text-heading);\r\n  letter-spacing: -0.5px;\r\n  margin-bottom: 6px;\r\n}\r\n\r\n.ctf-meta-sub {\r\n  color: var(--text-secondary);\r\n  font-size: 0.95rem;\r\n  margin-bottom: 18px;\r\n}\r\n\r\n.btn-nav-primary {\r\n  background-color: var(--brand-green);\r\n  color: #ffffff !important;\r\n  font-weight: 600;\r\n  font-size: 0.88rem;\r\n  padding: 8px 18px;\r\n  border-radius: 4px;\r\n  border: 1px solid rgba(240, 246, 252, 0.1);\r\n  display: inline-block;\r\n  text-decoration: none;\r\n  margin-right: 8px;\r\n}\r\n\r\n.btn-nav-primary:hover {\r\n  background-color: #2ea043;\r\n  color: #ffffff !important;\r\n  text-decoration: none;\r\n}\r\n\r\n.btn-nav-secondary {\r\n  background-color: #21262d;\r\n  color: var(--text-heading) !important;\r\n  font-weight: 600;\r\n  font-size: 0.88rem;\r\n  padding: 8px 18px;\r\n  border-radius: 4px;\r\n  border: 1px solid var(--panel-border);\r\n  display: inline-block;\r\n  text-decoration: none;\r\n}\r\n\r\n.btn-nav-secondary:hover {\r\n  background-color: #30363d;\r\n  color: var(--text-heading) !important;\r\n  text-decoration: none;\r\n}\r\n\r\n.doc-section {\r\n  background: var(--panel-bg);\r\n  border: 1px solid var(--panel-border);\r\n  border-radius: 6px;\r\n  padding: 20px 24px;\r\n  margin-bottom: 24px;\r\n}\r\n\r\n.doc-section h2 {\r\n  font-size: 1.15rem;\r\n  font-weight: 600;\r\n  color: var(--text-heading);\r\n  margin-bottom: 12px;\r\n  padding-bottom: 8px;\r\n  border-bottom: 1px solid var(--panel-border);\r\n}\r\n\r\n.doc-table {\r\n  width: 100%;\r\n  border-collapse: collapse;\r\n  font-size: 0.88rem;\r\n  margin-top: 10px;\r\n}\r\n\r\n.doc-table th {\r\n  text-align: left;\r\n  padding: 8px 12px;\r\n  background-color: #0d1117;\r\n  color: var(--text-secondary);\r\n  font-weight: 600;\r\n  border-bottom: 1px solid var(--panel-border);\r\n}\r\n\r\n.doc-table td {\r\n  padding: 10px 12px;\r\n  border-bottom: 1px solid var(--panel-border);\r\n  color: var(--text-primary);\r\n}\r\n\r\n.doc-table tr:last-child td {\r\n  border-bottom: none;\r\n}\r\n\r\n.code-inline {\r\n  font-family: ui-monospace, SFMono-Regular, \"SF Mono\", Menlo, Consolas, monospace;\r\n  font-size: 0.82rem;\r\n  background-color: rgba(110, 118, 129, 0.4);\r\n  padding: 2px 6px;\r\n  border-radius: 4px;\r\n  color: #f0f6fc;\r\n}\r\n</style>\r\n\r\n<div class=\"container pb-5\">\r\n\r\n<div class=\"ctf-header-block\">\r\n<h1 class=\"ctf-title\">BreachPoint CTF</h1>\r\n<div class=\"ctf-meta-sub\">\r\nIE3132 Penetration Testing &bull; Practical Challenge Environment &bull; 1,550 Total Points\r\n</div>\r\n<div>\r\n<a href=\"/challenges\" class=\"btn-nav-primary\">Open Challenges</a>\r\n<a href=\"/scoreboard\" class=\"btn-nav-secondary\">Scoreboard</a>\r\n</div>\r\n</div>\r\n\r\n<div class=\"doc-section\">\r\n<h2>Scenario Briefing</h2>\r\n<p style=\"font-size: 0.92rem; color: var(--text-primary); margin-bottom: 0;\">\r\nThis assessment simulates an external-to-internal network intrusion against NovaTech Corp. Participants are tasked with identifying perimeter exposure, validating API authorization boundaries, executing authenticated diagnostic checks, analyzing forensics artifacts, and evaluating local privilege escalation controls. Each stage directly provides credentials, keys, or access vectors required for subsequent stages.\r\n</p>\r\n</div>\r\n\r\n<div class=\"doc-section\">\r\n<h2>Attack Lifecycle &amp; Scoring Matrix</h2>\r\n<div class=\"table-responsive\">\r\n<table class=\"doc-table\">\r\n<thead>\r\n<tr>\r\n<th>Stage</th>\r\n<th>Title</th>\r\n<th>Domain</th>\r\n<th>Points</th>\r\n<th>Primary Focus</th>\r\n</tr>\r\n</thead>\r\n<tbody>\r\n<tr>\r\n<td><strong>S1</strong></td>\r\n<td>Open Eyes</td>\r\n<td>OSINT / Recon</td>\r\n<td>100</td>\r\n<td>Metadata &amp; source reconnaissance on public web assets</td>\r\n</tr>\r\n<tr>\r\n<td><strong>S2</strong></td>\r\n<td>Knock Knock</td>\r\n<td>Web / API Security</td>\r\n<td>150</td>\r\n<td>Endpoint enumeration and unauthenticated data exposure</td>\r\n</tr>\r\n<tr>\r\n<td><strong>S3</strong></td>\r\n<td>The Login Wall</td>\r\n<td>Authentication</td>\r\n<td>200</td>\r\n<td>Credential replay and internal portal access</td>\r\n</tr>\r\n<tr>\r\n<td><strong>S4</strong></td>\r\n<td>Scrambled Secrets</td>\r\n<td>Cryptography &amp; Web</td>\r\n<td>250</td>\r\n<td>Command execution in diagnostics tool &amp; cipher analysis</td>\r\n</tr>\r\n<tr>\r\n<td><strong>S5</strong></td>\r\n<td>Dead Logs Tell Tales</td>\r\n<td>Digital Forensics</td>\r\n<td>350</td>\r\n<td>SSH session investigation, shell history, archive extraction</td>\r\n</tr>\r\n<tr>\r\n<td><strong>S6</strong></td>\r\n<td>Root of Evil</td>\r\n<td>System Security</td>\r\n<td>500</td>\r\n<td>Misconfigured SUID binary review &amp; privilege escalation</td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n</div>\r\n</div>\r\n\r\n<div class=\"doc-section\">\r\n<h2>Scoping and Ground Rules</h2>\r\n<table class=\"doc-table\">\r\n<tbody>\r\n<tr>\r\n<td style=\"width: 220px; font-weight: 600;\">Target Challenge Box</td>\r\n<td><span class=\"code-inline\">http://&lt;ip_address&gt;</span> (Web) &bull; <span class=\"code-inline\">&lt;username&gt;@&lt;ip_address&gt; -p 2222</span> (SSH)</td>\r\n</tr>\r\n<tr>\r\n<td style=\"font-weight: 600;\">Control Infrastructure</td>\r\n<td>Port 8000 (CTFd scoring platform) is strictly out of scope. Do not attack scoring services.</td>\r\n</tr>\r\n<tr>\r\n<td style=\"font-weight: 600;\">Flag Structure</td>\r\n<td>Standard submission format: <span class=\"code-inline\">BPCTF{...}</span> (case-sensitive).</td>\r\n</tr>\r\n<tr>\r\n<td style=\"font-weight: 600;\">Hint Policy</td>\r\n<td>Introductory hints are zero-cost. Progressive hints deduct penalty points directly from your recorded score.</td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n</div>\r\n\r\n</div>',0,0,0,'html',NULL);
/*!40000 ALTER TABLE `pages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ratings`
--

DROP TABLE IF EXISTS `ratings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ratings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `challenge_id` int(11) DEFAULT NULL,
  `value` int(11) DEFAULT NULL,
  `review` varchar(2000) DEFAULT NULL,
  `date` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`challenge_id`),
  KEY `challenge_id` (`challenge_id`),
  CONSTRAINT `ratings_ibfk_1` FOREIGN KEY (`challenge_id`) REFERENCES `challenges` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ratings_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ratings`
--

LOCK TABLES `ratings` WRITE;
/*!40000 ALTER TABLE `ratings` DISABLE KEYS */;
/*!40000 ALTER TABLE `ratings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `solutions`
--

DROP TABLE IF EXISTS `solutions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `solutions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `challenge_id` int(11) DEFAULT NULL,
  `content` text DEFAULT NULL,
  `state` varchar(80) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `challenge_id` (`challenge_id`),
  CONSTRAINT `solutions_ibfk_1` FOREIGN KEY (`challenge_id`) REFERENCES `challenges` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `solutions`
--

LOCK TABLES `solutions` WRITE;
/*!40000 ALTER TABLE `solutions` DISABLE KEYS */;
/*!40000 ALTER TABLE `solutions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `solves`
--

DROP TABLE IF EXISTS `solves`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `solves` (
  `id` int(11) NOT NULL,
  `challenge_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `team_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `challenge_id` (`challenge_id`,`team_id`),
  UNIQUE KEY `challenge_id_2` (`challenge_id`,`user_id`),
  KEY `team_id` (`team_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `solves_ibfk_1` FOREIGN KEY (`challenge_id`) REFERENCES `challenges` (`id`) ON DELETE CASCADE,
  CONSTRAINT `solves_ibfk_2` FOREIGN KEY (`id`) REFERENCES `submissions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `solves_ibfk_3` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE,
  CONSTRAINT `solves_ibfk_4` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `solves`
--

LOCK TABLES `solves` WRITE;
/*!40000 ALTER TABLE `solves` DISABLE KEYS */;
INSERT INTO `solves` VALUES
(1,1,1,NULL),
(2,1,2,NULL),
(3,2,1,NULL),
(4,3,1,NULL),
(5,4,1,NULL);
/*!40000 ALTER TABLE `solves` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `submissions`
--

DROP TABLE IF EXISTS `submissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `submissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `challenge_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `team_id` int(11) DEFAULT NULL,
  `ip` varchar(46) DEFAULT NULL,
  `provided` text DEFAULT NULL,
  `type` varchar(32) DEFAULT NULL,
  `date` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `challenge_id` (`challenge_id`),
  KEY `team_id` (`team_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `submissions_ibfk_1` FOREIGN KEY (`challenge_id`) REFERENCES `challenges` (`id`) ON DELETE CASCADE,
  CONSTRAINT `submissions_ibfk_2` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE,
  CONSTRAINT `submissions_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `submissions`
--

LOCK TABLES `submissions` WRITE;
/*!40000 ALTER TABLE `submissions` DISABLE KEYS */;
INSERT INTO `submissions` VALUES
(1,1,1,NULL,'172.23.0.1','BPCTF{r3c0n_m4st3r}','correct','2026-09-23 05:13:02.799687'),
(2,1,2,NULL,'172.23.0.1','BPCTF{r3c0n_m4st3r}','correct','2026-09-23 05:14:58.671361'),
(3,2,1,NULL,'172.23.0.1','BPCTF{4p1_3xp0sur3_l34ks_cr3ds}','correct','2026-09-23 05:21:43.190907'),
(4,3,1,NULL,'172.23.0.1','BPCTF{4uth_p0rt4l_4cc3ss}','correct','2026-09-23 05:24:40.639955'),
(5,4,1,NULL,'172.23.0.1','BPCTF{crypt0_l4y3rs_d3c0d3d}','correct','2026-09-23 05:26:50.689604');
/*!40000 ALTER TABLE `submissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tags`
--

DROP TABLE IF EXISTS `tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `challenge_id` int(11) DEFAULT NULL,
  `value` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tags_ibfk_1` (`challenge_id`),
  CONSTRAINT `tags_ibfk_1` FOREIGN KEY (`challenge_id`) REFERENCES `challenges` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tags`
--

LOCK TABLES `tags` WRITE;
/*!40000 ALTER TABLE `tags` DISABLE KEYS */;
/*!40000 ALTER TABLE `tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teams`
--

DROP TABLE IF EXISTS `teams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `teams` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `oauth_id` int(11) DEFAULT NULL,
  `name` varchar(128) DEFAULT NULL,
  `email` varchar(128) DEFAULT NULL,
  `password` varchar(128) DEFAULT NULL,
  `secret` varchar(128) DEFAULT NULL,
  `website` varchar(128) DEFAULT NULL,
  `affiliation` varchar(128) DEFAULT NULL,
  `country` varchar(32) DEFAULT NULL,
  `hidden` tinyint(1) DEFAULT NULL,
  `banned` tinyint(1) DEFAULT NULL,
  `created` datetime(6) DEFAULT NULL,
  `captain_id` int(11) DEFAULT NULL,
  `bracket_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `id` (`id`,`oauth_id`),
  UNIQUE KEY `oauth_id` (`oauth_id`),
  KEY `team_captain_id` (`captain_id`),
  KEY `bracket_id` (`bracket_id`),
  CONSTRAINT `team_captain_id` FOREIGN KEY (`captain_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `teams_ibfk_1` FOREIGN KEY (`bracket_id`) REFERENCES `brackets` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teams`
--

LOCK TABLES `teams` WRITE;
/*!40000 ALTER TABLE `teams` DISABLE KEYS */;
/*!40000 ALTER TABLE `teams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tokens`
--

DROP TABLE IF EXISTS `tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(32) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created` datetime(6) DEFAULT NULL,
  `expiration` datetime(6) DEFAULT NULL,
  `value` varchar(128) DEFAULT NULL,
  `description` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `value` (`value`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tokens`
--

LOCK TABLES `tokens` WRITE;
/*!40000 ALTER TABLE `tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `topics`
--

DROP TABLE IF EXISTS `topics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `topics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `value` (`value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `topics`
--

LOCK TABLES `topics` WRITE;
/*!40000 ALTER TABLE `topics` DISABLE KEYS */;
/*!40000 ALTER TABLE `topics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tracking`
--

DROP TABLE IF EXISTS `tracking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tracking` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(32) DEFAULT NULL,
  `ip` varchar(46) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `date` datetime(6) DEFAULT NULL,
  `target` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tracking_ibfk_1` (`user_id`),
  CONSTRAINT `tracking_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tracking`
--

LOCK TABLES `tracking` WRITE;
/*!40000 ALTER TABLE `tracking` DISABLE KEYS */;
INSERT INTO `tracking` VALUES
(1,NULL,'172.23.0.1',1,'2026-09-23 11:12:37.395800',NULL),
(2,NULL,'172.23.0.1',2,'2026-09-23 05:17:55.878094',NULL),
(3,'challenges.open','172.23.0.1',2,'2026-09-23 05:14:48.391595',1),
(4,'challenges.open','172.23.0.1',2,'2026-09-23 05:15:03.928455',2),
(5,NULL,'172.23.0.1',3,'2026-09-23 08:01:57.789846',NULL),
(6,'challenges.open','172.23.0.1',3,'2026-09-23 08:01:57.911016',1);
/*!40000 ALTER TABLE `tracking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `unlocks`
--

DROP TABLE IF EXISTS `unlocks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `unlocks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `team_id` int(11) DEFAULT NULL,
  `target` int(11) DEFAULT NULL,
  `date` datetime(6) DEFAULT NULL,
  `type` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `unlocks_ibfk_1` (`team_id`),
  KEY `unlocks_ibfk_2` (`user_id`),
  CONSTRAINT `unlocks_ibfk_1` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE,
  CONSTRAINT `unlocks_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `unlocks`
--

LOCK TABLES `unlocks` WRITE;
/*!40000 ALTER TABLE `unlocks` DISABLE KEYS */;
/*!40000 ALTER TABLE `unlocks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `oauth_id` int(11) DEFAULT NULL,
  `name` varchar(128) DEFAULT NULL,
  `password` varchar(128) DEFAULT NULL,
  `email` varchar(128) DEFAULT NULL,
  `type` varchar(80) DEFAULT NULL,
  `secret` varchar(128) DEFAULT NULL,
  `website` varchar(128) DEFAULT NULL,
  `affiliation` varchar(128) DEFAULT NULL,
  `country` varchar(32) DEFAULT NULL,
  `hidden` tinyint(1) DEFAULT NULL,
  `banned` tinyint(1) DEFAULT NULL,
  `verified` tinyint(1) DEFAULT NULL,
  `team_id` int(11) DEFAULT NULL,
  `created` datetime(6) DEFAULT NULL,
  `language` varchar(32) DEFAULT NULL,
  `bracket_id` int(11) DEFAULT NULL,
  `change_password` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `id` (`id`,`oauth_id`),
  UNIQUE KEY `oauth_id` (`oauth_id`),
  KEY `team_id` (`team_id`),
  KEY `bracket_id` (`bracket_id`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`),
  CONSTRAINT `users_ibfk_2` FOREIGN KEY (`bracket_id`) REFERENCES `brackets` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES
(1,NULL,'admin','$bcrypt-sha256$v=2,t=2b,r=12$Zx9IzXC9GFTbhkKV84eqAu$n3ytmbtKdY0PzWAVN.TSh30wIBo2YX2','admin@breachpoint.local','admin',NULL,NULL,NULL,NULL,1,0,0,NULL,'2026-09-23 02:39:24.332213',NULL,NULL,0),
(2,NULL,'ulindu','$bcrypt-sha256$v=2,t=2b,r=12$4BfX.X6HfLNLd6YIHIoREe$M8ffZ8EE3Mjihu61BiumyPZ5MUGphA2','ulindu@gmail.com','user',NULL,NULL,NULL,NULL,0,0,0,NULL,'2026-09-23 05:14:48.242817',NULL,NULL,0),
(3,NULL,'pasan','$bcrypt-sha256$v=2,t=2b,r=12$M2eW475oEjvshLKl5CHDNe$4Edh2h4VYILoT2uy0mlN7aMkSRMbwrW','pasan@gmail.com','user',NULL,NULL,NULL,NULL,0,0,0,NULL,'2026-09-23 08:01:57.769954',NULL,NULL,0);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-23 11:41:20
