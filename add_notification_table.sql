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

