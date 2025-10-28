-- Run this SQL to add the table storing pending verification tokens for registration flow
CREATE TABLE IF NOT EXISTS verification_tokens (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  token VARCHAR(128) NOT NULL UNIQUE,
  nom VARCHAR(255),
  prenom VARCHAR(255),
  email VARCHAR(255) NOT NULL,
  motDePasse VARCHAR(255) NOT NULL,
  cin VARCHAR(128),
  role VARCHAR(64),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
USE chess_club_db;