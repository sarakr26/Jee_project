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
  nom VARCHAR(255) NOT NULL,
  prenom VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  motDePasse VARCHAR(255) NOT NULL,
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
  statut ENUM('PLANIFIE', 'ANNULE', 'TERMINE') NOT NULL
);
ALTER TABLE Evenement DROP FOREIGN KEY evenement_ibfk_1; ALTER TABLE Evenement DROP COLUMN federation_id;-- -----------------------------------------------------
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
CREATE TABLE IF NOT EXISTS DemandeCreationClub (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  nomClub VARCHAR(255) NOT NULL,
  description TEXT,
  dateDemande DATE NOT NULL,
  statut ENUM('EN_ATTENTE', 'ACCEPTEE', 'REFUSEE') NOT NULL DEFAULT 'EN_ATTENTE',
  president_id BIGINT NOT NULL,
  FOREIGN KEY (president_id) REFERENCES Utilisateur(id) ON DELETE CASCADE
);
-
INSERT INTO evenement (titre, description, lieu, dateDebut, dateFin, statut) VALUES
('Tournoi National d''Échecs 2025', 'Grand tournoi national réunissant les meilleurs joueurs du pays. Ouvert à tous les niveaux.', 'Palais des Congrès, Paris', '2025-11-15', '2025-11-17', 'PLANIFIE'),
('Championnat Régional', 'Compétition régionale pour promouvoir les jeunes talents.', 'Centre Sportif Municipal, Lyon', '2025-12-05', '2025-12-06', 'PLANIFIE'),
('Tournoi Blitz d''Hiver', 'Tournoi de parties rapides pour tous les passionnés d''échecs.', 'Salle Polyvalente, Marseille', '2026-01-20', '2026-01-20', 'PLANIFIE'),
('Festival des Échecs', 'Festival combinant tournois, ateliers et conférences avec des grands maîtres.', 'Espace Culturel, Toulouse', '2026-02-10', '2026-02-12', 'PLANIFIE'),
('Open International de Printemps', 'Tournoi international ouvert à tous avec des prix attractifs.', 'Centre de Congrès, Nice', '2026-03-25', '2026-03-28', 'PLANIFIE');

INSERT INTO Club (nom, logo, description, statut, president_id) VALUES
('Club Royal d''Échecs', NULL, 'Le club le plus ancien de la ville avec une histoire riche. Nous organisons des tournois hebdomadaires et des cours pour tous les niveaux.', 'ACTIF', NULL),
('Échecs et Stratégie', NULL, 'Club moderne axé sur l''enseignement des stratégies avancées. Parfait pour les joueurs intermédiaires et avancés.', 'ACTIF', NULL),
('Les Pions d''Or', NULL, 'Club convivial pour débutants et amateurs. Ambiance chaleureuse et formations gratuites pour les nouveaux membres.', 'ACTIF', NULL),
('Académie des Échecs', NULL, 'Formation professionnelle d''échecs avec des entraîneurs certifiés. Préparation aux compétitions nationales et internationales.', 'ACTIF', NULL),
('Club des Champions', NULL, 'Rejoignez l''élite des joueurs d''échecs ! Club compétitif avec des membres classés et des tournois réguliers.', 'ACTIF', NULL)




-- Script de test pour créer un utilisateur FEDERATION et des données de test

-- Créer un utilisateur FEDERATION avec mot de passe "test123" hashé
INSERT INTO Utilisateur (nom, prenom, email, motDePasse, cin, role, club_id) 
VALUES ('Federation', 'Admin', 'federation@chess.ma', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhW', 'F123456', 'FEDERATION', NULL);

-- Créer quelques demandes de création de club en attente
INSERT INTO DemandeCreationClub (nomClub, description, dateDemande, statut, president_id) 
VALUES 
('Club des Rois', 'Un club pour les joueurs expérimentés', '2024-01-15', 'EN_ATTENTE', 1),
('Club des Pions', 'Un club pour les débutants', '2024-01-16', 'EN_ATTENTE', 2),
('Club des Cavaliers', 'Un club compétitif', '2024-01-17', 'EN_ATTENTE', 3);

-- Créer quelques demandes d'intégration en attente

-- Créer quelques événements