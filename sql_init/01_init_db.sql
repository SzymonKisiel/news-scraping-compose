CREATE DATABASE IF NOT EXISTS news_scraping_db;
USE news_scraping_db;

-- news_scraping_db.article definition

CREATE TABLE IF NOT EXISTS `article` (
  `id` int NOT NULL AUTO_INCREMENT,
  `url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `website` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `published_at` datetime DEFAULT NULL,
  `title` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `author` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `subtitle` varchar(4096) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `text` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `articles_UN` (`url`),
  FULLTEXT KEY `articles_title_IDX` (`title`,`subtitle`,`text`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- news_scraping_db.client definition

CREATE TABLE IF NOT EXISTS `client` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `client_UN` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- news_scraping_db.search_term definition

CREATE TABLE IF NOT EXISTS `search_term` (
  `id` int NOT NULL AUTO_INCREMENT,
  `term` varchar(200) NOT NULL,
  `updated_sentiments_at` timestamp NOT NULL DEFAULT '1970-01-01 00:00:01',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- news_scraping_db.client_search_term definition

CREATE TABLE IF NOT EXISTS `client_search_term` (
  `client_id` int NOT NULL,
  `search_term_id` int NOT NULL,
  KEY `client_search_term_FK` (`search_term_id`),
  KEY `client_search_term_FK_1` (`client_id`),
  CONSTRAINT `client_search_term_FK` FOREIGN KEY (`search_term_id`) REFERENCES `search_term` (`id`),
  CONSTRAINT `client_search_term_FK_1` FOREIGN KEY (`client_id`) REFERENCES `client` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- news_scraping_db.sentiment_label definition

CREATE TABLE IF NOT EXISTS `sentiment_label` (
  `id` int NOT NULL,
  `label` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- news_scraping_db.sentiment definition

CREATE TABLE IF NOT EXISTS `sentiment` (
  `id` int NOT NULL AUTO_INCREMENT,
  `article_id` int DEFAULT NULL,
  `search_term_id` int NOT NULL,
  `sentence` varchar(2000) DEFAULT NULL,
  `positive_score` decimal(5,4) DEFAULT NULL,
  `neutral_score` decimal(5,4) DEFAULT NULL,
  `negative_score` decimal(5,4) DEFAULT NULL,
  `overall_sentiment` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sentiment_FK` (`overall_sentiment`),
  KEY `sentiment_FK_1` (`article_id`),
  KEY `sentiment_FK_2` (`search_term_id`),
  CONSTRAINT `sentiment_FK` FOREIGN KEY (`overall_sentiment`) REFERENCES `sentiment_label` (`id`),
  CONSTRAINT `sentiment_FK_1` FOREIGN KEY (`article_id`) REFERENCES `article` (`id`),
  CONSTRAINT `sentiment_FK_2` FOREIGN KEY (`search_term_id`) REFERENCES `search_term` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- insert initial data

INSERT INTO news_scraping_db.sentiment_label
	(id, label)
VALUES
	(0, 'negative'),
	(1, 'neutral'),
	(2, 'positive');