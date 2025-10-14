-- =================================================================
-- Script de création de la base de données pour la gestion des clubs d'échecs
-- =================================================================
CREATE DATABASE IF NOT EXISTS chess_club_db
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_general_ci;

USE chess_club_db;
-- -----------------------------------------------------
-- Table Club
-- Représente un club d'échecs avec son statut et son président.
-- -----------------------------------------------------
CREATE TABLE Club (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  nom VARCHAR(255) NOT NULL,
  logo VARCHAR(255),
  description TEXT,
  statut ENUM('EN_ATTENTE', 'ACTIF', 'REFUSE', 'SUSPENDU', 'ARCHIVE') NOT NULL,
  president_id BIGINT UNIQUE -- Un président ne peut diriger qu'un seul club
);

-- -----------------------------------------------------
-- Table Utilisateur
-- Table centrale pour tous les acteurs, avec un rôle pour les différencier.
-- -----------------------------------------------------
CREATE TABLE Utilisateur (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  nom VARCHAR(100) NOT NULL,
  prenom VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  motDePasse VARCHAR(100) NOT NULL,
  cin VARCHAR(100) NOT NULL UNIQUE,
  role ENUM('FEDERATION', 'PRESIDENT', 'MEMBRE') NOT NULL,
  club_id BIGINT,
  FOREIGN KEY (club_id) REFERENCES Club(id) ON DELETE SET NULL
);

-- Ajout de la clé étrangère de Club vers Utilisateur après la création de la table Utilisateur
ALTER TABLE Club ADD FOREIGN KEY (president_id) REFERENCES Utilisateur(id) ON DELETE SET NULL;


-- -----------------------------------------------------
-- Table DemandeIntegration
-- Historique des demandes d'adhésion d'un membre à un club.
-- -----------------------------------------------------
CREATE TABLE DemandeIntegration (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  dateDemande DATE NOT NULL,
  statut ENUM('EN_ATTENTE', 'ACCEPTEE', 'REFUSEE') NOT NULL,
  membre_id BIGINT NOT NULL,
  club_id BIGINT NOT NULL,
  FOREIGN KEY (membre_id) REFERENCES Utilisateur(id) ON DELETE CASCADE,
  FOREIGN KEY (club_id) REFERENCES Club(id) ON DELETE CASCADE
);

-- -----------------------------------------------------
-- Table Evenement
-- Stocke les événements (tournois) organisés par la fédération.
-- -----------------------------------------------------
CREATE TABLE Evenement (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  titre VARCHAR(255) NOT NULL,
  description TEXT,
  lieu VARCHAR(255),
  dateDebut DATE,
  dateFin DATE,
  statut ENUM('PLANIFIE', 'ANNULE', 'TERMINE') NOT NULL,
  federation_id BIGINT NOT NULL,
  FOREIGN KEY (federation_id) REFERENCES Utilisateur(id)
);

-- -----------------------------------------------------
-- Table Participation
-- Table de liaison pour suivre la participation des membres aux événements.
-- -----------------------------------------------------
CREATE TABLE Participation (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  dateInvitation DATE,
  dateConfirmation DATE,
  statut ENUM('INVITE', 'CONFIRME', 'REFUSE') NOT NULL,
  membre_id BIGINT NOT NULL,
  evenement_id BIGINT NOT NULL,
  FOREIGN KEY (membre_id) REFERENCES Utilisateur(id) ON DELETE CASCADE,
  FOREIGN KEY (evenement_id) REFERENCES Evenement(id) ON DELETE CASCADE
);

-- -----------------------------------------------------
-- Table Planning
-- Le planning est unique pour chaque club.
-- -----------------------------------------------------
CREATE TABLE Planning (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  club_id BIGINT NOT NULL UNIQUE, -- Un club a un seul planning
  FOREIGN KEY (club_id) REFERENCES Club(id) ON DELETE CASCADE
);

-- -----------------------------------------------------
-- Table Activite
-- Détaille les activités (entraînements, réunions) d'un planning.
-- -----------------------------------------------------
CREATE TABLE Activite (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  titre VARCHAR(255) NOT NULL,
  type VARCHAR(100),
  dateDebut DATETIME NOT NULL,
  dateFin DATETIME NOT NULL,
  planning_id BIGINT NOT NULL,
  FOREIGN KEY (planning_id) REFERENCES Planning(id) ON DELETE CASCADE
);

-- =================================================================
-- Fin du script
-- =================================================================
INSERT INTO Utilisateur (nom, prenom, email, motDePasse, cin, role) 
VALUES ('Admin', 'User', 'admin@federation.com', 'password', 'A123456', 'FEDERATION');
SELECT * FROM chess_club_db.Utilisateur WHERE email = 'admin@federation.com';

DELETE FROM Utilisateur WHERE email = 'president@club.com';

UPDATE Utilisateur 
SET role = 'PRESIDENT', club_id = 1 
WHERE email = 'president@club.com';