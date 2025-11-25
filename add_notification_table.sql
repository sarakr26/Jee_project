-- Script to add Notification table to the chess club database
-- Run this script to add the notification feature

USE chess_club_db;

-- Create Notification table
-- Types: CLUB_ACCEPTED, EVENT_ADDED, EVENT_UPDATED, etc.
-- lu: Read status (true if read, false if unread)
CREATE TABLE IF NOT EXISTS Notification (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  message TEXT NOT NULL,
  type VARCHAR(50) NOT NULL,
  dateCreation DATE NOT NULL,
  lu BOOLEAN DEFAULT FALSE,
  membre_id BIGINT NOT NULL,
  FOREIGN KEY (membre_id) REFERENCES Utilisateur(id) ON DELETE CASCADE,
  INDEX idx_membre_date (membre_id, dateCreation)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

USE chess_club_db;
SHOW TABLES;


USE chess_club_db;

CREATE TABLE IF NOT EXISTS `notification` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `message` TEXT NOT NULL,
  `type` VARCHAR(50) NOT NULL,
  `dateCreation` DATE NOT NULL,
  `lu` TINYINT(1) DEFAULT 0,
  `membre_id` BIGINT(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_membre_date` (`membre_id`, `dateCreation`),
  KEY `membre_id` (`membre_id`),
  CONSTRAINT `notification_ibfk_1` FOREIGN KEY (`membre_id`) REFERENCES `utilisateur` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


USE chess_club_db;

-- Create table without foreign key first
CREATE TABLE IF NOT EXISTS notification (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  message TEXT NOT NULL,
  type VARCHAR(50) NOT NULL,
  dateCreation DATE NOT NULL,
  lu BOOLEAN DEFAULT FALSE,
  membre_id BIGINT NOT NULL,
  INDEX idx_membre_date (membre_id, dateCreation)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Add foreign key separately
ALTER TABLE notification 
ADD CONSTRAINT fk_notification_membre 
FOREIGN KEY (membre_id) REFERENCES utilisateur(id) ON DELETE CASCADE;