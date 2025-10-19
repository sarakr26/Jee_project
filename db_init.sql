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

-- Remplacez 'federation@email.com' par l'email que vous avez enregistré
UPDATE Utilisateur SET role = 'FEDERATION' WHERE email = 'federation@email.com';

UPDATE Utilisateur 
SET role = 'FEDERATION' 
WHERE email = 'federation@email.com';

UPDATE Utilisateur 
SET role = 'PRESIDENT', club_id = 2 
WHERE email = 'president.dupont@club.com';

-- ===========================
-- Indexes (performance)
-- ===========================
-- DemandeIntegration FKs
CREATE INDEX idx_demande_membre ON DemandeIntegration (membre_id);
CREATE INDEX idx_demande_club ON DemandeIntegration (club_id);

-- Evenement FK
CREATE INDEX idx_evenement_federation ON Evenement (federation_id);

-- Participation FKs
CREATE INDEX idx_participation_membre ON Participation (membre_id);
CREATE INDEX idx_participation_evenement ON Participation (evenement_id);

-- Planning unique per club already enforced; add explicit index too
CREATE INDEX idx_planning_club ON Planning (club_id);

-- Activite FK
CREATE INDEX idx_activite_planning ON Activite (planning_id);

-- Common lookups on Utilisateur
CREATE INDEX idx_user_role ON Utilisateur (role);
CREATE INDEX idx_user_club ON Utilisateur (club_id);

-- ===========================
-- Views (reporting)
-- ===========================
CREATE OR REPLACE VIEW v_club_members AS
SELECT u.id AS user_id, u.nom, u.prenom, u.email, u.role, u.club_id
FROM Utilisateur u
WHERE u.role = 'MEMBRE' AND u.club_id IS NOT NULL;

CREATE OR REPLACE VIEW v_pending_requests AS
SELECT d.id AS demande_id, d.dateDemande, d.statut, d.membre_id, u.nom, u.prenom, u.email, d.club_id
FROM DemandeIntegration d
JOIN Utilisateur u ON u.id = d.membre_id
WHERE d.statut = 'EN_ATTENTE';

CREATE OR REPLACE VIEW v_upcoming_activities AS
SELECT c.id AS club_id, c.nom AS club_nom, a.id AS activite_id, a.titre, a.type, a.dateDebut, a.dateFin
FROM Club c
JOIN Planning p ON p.club_id = c.id
JOIN Activite a ON a.planning_id = p.id
WHERE a.dateFin >= NOW()
ORDER BY a.dateDebut ASC;

-- ===========================
-- Procedures (business flows)
-- ===========================
DELIMITER $$

-- Accept a join request: marks demande ACCEPTEE and sets user's club_id.
CREATE PROCEDURE sp_accept_demande(IN p_demande_id BIGINT)
BEGIN
  DECLARE v_membre_id BIGINT;
  DECLARE v_club_id BIGINT;

  SELECT membre_id, club_id INTO v_membre_id, v_club_id
  FROM DemandeIntegration
  WHERE id = p_demande_id AND statut = 'EN_ATTENTE'
  FOR UPDATE;

  -- Update demande status
  UPDATE DemandeIntegration
  SET statut = 'ACCEPTEE'
  WHERE id = p_demande_id AND statut = 'EN_ATTENTE';

  -- Attach user to club only if member role
  UPDATE Utilisateur
  SET club_id = v_club_id
  WHERE id = v_membre_id AND role = 'MEMBRE';
END$$

-- Refuse a join request
CREATE PROCEDURE sp_refuse_demande(IN p_demande_id BIGINT)
BEGIN
  UPDATE DemandeIntegration
  SET statut = 'REFUSEE'
  WHERE id = p_demande_id AND statut = 'EN_ATTENTE';
END$$

-- Remove a member from a club (kick)
CREATE PROCEDURE sp_remove_member(IN p_user_id BIGINT, IN p_club_id BIGINT)
BEGIN
  UPDATE Utilisateur
  SET club_id = NULL
  WHERE id = p_user_id AND role = 'MEMBRE' AND club_id = p_club_id;
END$$

-- Ensure a Planning exists for a club; if not, create it.
-- OUT param returns the planning id.
CREATE PROCEDURE sp_ensure_planning(IN p_club_id BIGINT, OUT p_planning_id BIGINT)
BEGIN
  SELECT id INTO p_planning_id FROM Planning WHERE club_id = p_club_id LIMIT 1;

  IF p_planning_id IS NULL THEN
    INSERT INTO Planning (club_id) VALUES (p_club_id);
    SET p_planning_id = LAST_INSERT_ID();
  END IF;
END$$

DELIMITER ;

-- ===========================
-- Seed data (optional for tests)
-- ===========================
-- Ensure at least one active club exists
INSERT INTO Club (nom, statut) 
SELECT 'Club Alpha', 'ACTIF'
WHERE NOT EXISTS (SELECT 1 FROM Club WHERE nom = 'Club Alpha');

-- Ensure a planning for Club Alpha
CALL sp_ensure_planning(
  (SELECT id FROM Club WHERE nom = 'Club Alpha' LIMIT 1),
  @p_planning_id
);

-- Add a sample upcoming activity if none exists
INSERT INTO Activite (titre, type, dateDebut, dateFin, planning_id)
SELECT 'Entraînement hebdo', 'TRAINING', NOW() + INTERVAL 2 DAY, NOW() + INTERVAL 2 DAY + INTERVAL 2 HOUR, @p_planning_id
WHERE NOT EXISTS (
  SELECT 1 FROM Activite WHERE planning_id = @p_planning_id AND dateDebut > NOW()
);