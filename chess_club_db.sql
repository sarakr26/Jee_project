-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : mar. 21 oct. 2025 à 02:51
-- Version du serveur : 10.4.32-MariaDB
-- Version de PHP : 8.2.12
use chess_club_db;

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `chess_club_db`
--

-- --------------------------------------------------------

--
-- Structure de la table `activite`
--

CREATE TABLE `activite` (
  `id` bigint(20) NOT NULL,
  `titre` varchar(255) NOT NULL,
  `type` varchar(100) DEFAULT NULL,
  `dateDebut` datetime NOT NULL,
  `dateFin` datetime NOT NULL,
  `planning_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `club`
--

CREATE TABLE `club` (
  `id` bigint(20) NOT NULL,
  `nom` varchar(255) NOT NULL,
  `logo` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `statut` enum('EN_ATTENTE','ACTIF','REFUSE','SUSPENDU','ARCHIVE') NOT NULL,
  `president_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `club`
--

INSERT INTO `club` (`id`, `nom`, `logo`, `description`, `statut`, `president_id`) VALUES
(1, 'tet_club', 'logo', 'clubtetouan', 'ACTIF', NULL),
(2, 'Club Royal d\'Échecs', NULL, 'Le club le plus ancien de la ville avec une histoire riche. Nous organisons des tournois hebdomadaires et des cours pour tous les niveaux.', 'ACTIF', NULL),
(3, 'Échecs et Stratégie', NULL, 'Club moderne axé sur l\'enseignement des stratégies avancées. Parfait pour les joueurs intermédiaires et avancés.', 'ACTIF', NULL),
(4, 'Les Pions d\'Or', NULL, 'Club convivial pour débutants et amateurs. Ambiance chaleureuse et formations gratuites pour les nouveaux membres.', 'ACTIF', NULL),
(5, 'Académie des Échecs', NULL, 'Formation professionnelle d\'échecs avec des entraîneurs certifiés. Préparation aux compétitions nationales et internationales.', 'ACTIF', NULL),
(6, 'Club des Champions', NULL, 'Rejoignez l\'élite des joueurs d\'échecs ! Club compétitif avec des membres classés et des tournois réguliers.', 'ACTIF', NULL),
(7, 'Club Royal d\'├ëchecs', NULL, 'Le club le plus ancien de la ville avec une histoire riche. Nous organisons des tournois hebdomadaires et des cours pour tous les niveaux.', 'ACTIF', NULL),
(8, '├ëchecs et Strat├®gie', NULL, 'Club moderne ax├® sur l\'enseignement des strat├®gies avanc├®es. Parfait pour les joueurs interm├®diaires et avanc├®s.', 'ACTIF', NULL),
(9, 'Les Pions d\'Or', NULL, 'Club convivial pour d├®butants et amateurs. Ambiance chaleureuse et formations gratuites pour les nouveaux membres.', 'ACTIF', NULL),
(10, 'Acad├®mie des ├ëchecs', NULL, 'Formation professionnelle d\'├®checs avec des entra├«neurs certifi├®s. Pr├®paration aux comp├®titions nationales et internationales.', 'ACTIF', NULL),
(11, 'Club des Champions', NULL, 'Rejoignez l\'├®lite des joueurs d\'├®checs ! Club comp├®titif avec des membres class├®s et des tournois r├®guliers.', 'ACTIF', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `demandecreationclub`
--

CREATE TABLE `demandecreationclub` (
  `id` bigint(20) NOT NULL,
  `nomClub` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `dateDemande` date NOT NULL,
  `statut` enum('EN_ATTENTE','ACCEPTEE','REFUSEE') NOT NULL DEFAULT 'EN_ATTENTE',
  `president_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `demandecreationclub`
--

INSERT INTO `demandecreationclub` (`id`, `nomClub`, `description`, `dateDemande`, `statut`, `president_id`) VALUES
(1, 'club chess 123', 'clubbbbbbb', '2025-10-10', 'EN_ATTENTE', 10),
(5, 'ddddddd', 'dddddd', '2025-10-21', 'EN_ATTENTE', 18);

-- --------------------------------------------------------

--
-- Structure de la table `demandeintegration`
--

CREATE TABLE `demandeintegration` (
  `id` bigint(20) NOT NULL,
  `dateDemande` date NOT NULL,
  `statut` enum('EN_ATTENTE','ACCEPTEE','REFUSEE') NOT NULL,
  `membre_id` bigint(20) NOT NULL,
  `club_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `demandeintegration`
--

INSERT INTO `demandeintegration` (`id`, `dateDemande`, `statut`, `membre_id`, `club_id`) VALUES
(1, '2025-10-09', 'EN_ATTENTE', 9, 5),
(2, '2025-10-10', 'EN_ATTENTE', 9, 10),
(3, '2025-10-10', 'EN_ATTENTE', 9, 6);

-- --------------------------------------------------------

--
-- Structure de la table `evenement`
--

CREATE TABLE `evenement` (
  `id` bigint(20) NOT NULL,
  `titre` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `lieu` varchar(255) DEFAULT NULL,
  `dateDebut` date DEFAULT NULL,
  `dateFin` date DEFAULT NULL,
  `statut` enum('PLANIFIE','ANNULE','TERMINE') NOT NULL,
  `federation_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `evenement`
--

INSERT INTO `evenement` (`id`, `titre`, `description`, `lieu`, `dateDebut`, `dateFin`, `statut`, `federation_id`) VALUES
(1, 'Tournoi National d\'Échecs 2025', 'Grand tournoi national réunissant les meilleurs joueurs du pays. Ouvert à tous les niveaux.', 'Palais des Congrès, Paris', '2025-11-15', '2025-11-17', 'PLANIFIE', 4),
(2, 'Championnat Régional', 'Compétition régionale pour promouvoir les jeunes talents.', 'Centre Sportif Municipal, Lyon', '2025-12-05', '2025-12-06', 'PLANIFIE', 4),
(3, 'Tournoi Blitz d\'Hiver', 'Tournoi de parties rapides pour tous les passionnés d\'échecs.', 'Salle Polyvalente, Marseille', '2026-01-20', '2026-01-20', 'PLANIFIE', 4),
(4, 'Festival des Échecs', 'Festival combinant tournois, ateliers et conférences avec des grands maîtres.', 'Espace Culturel, Toulouse', '2026-02-10', '2026-02-12', 'PLANIFIE', 4),
(5, 'Open International de Printemps', 'Tournoi international ouvert à tous avec des prix attractifs.', 'Centre de Congrès, Nice', '2026-03-25', '2026-03-28', 'PLANIFIE', 4),
(6, 'club1', 'club1', 'tetouan', '2025-10-18', '2025-10-23', 'ANNULE', 12),
(7, 'event2', 'ffffff', 'tetouan', '2025-09-10', '2026-12-02', 'PLANIFIE', 13);

-- --------------------------------------------------------

--
-- Structure de la table `participation`
--

CREATE TABLE `participation` (
  `id` bigint(20) NOT NULL,
  `dateInvitation` date DEFAULT NULL,
  `dateConfirmation` date DEFAULT NULL,
  `statut` enum('INVITE','CONFIRME','REFUSE') NOT NULL,
  `membre_id` bigint(20) NOT NULL,
  `evenement_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `planning`
--

CREATE TABLE `planning` (
  `id` bigint(20) NOT NULL,
  `club_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `utilisateur`
--

CREATE TABLE `utilisateur` (
  `id` bigint(20) NOT NULL,
  `nom` varchar(255) NOT NULL,
  `prenom` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `motDePasse` varchar(255) NOT NULL,
  `cin` varchar(100) NOT NULL,
  `role` enum('FEDERATION','PRESIDENT','MEMBRE') NOT NULL,
  `club_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `utilisateur`
--

INSERT INTO `utilisateur` (`id`, `nom`, `prenom`, `email`, `motDePasse`, `cin`, `role`, `club_id`) VALUES
(1, 'Dupont', 'Jean', 'jean.dupont@example.com', 'motdepasse123', 'AB123456', 'MEMBRE', NULL),
(3, 'user', 'userr', 'user@example.com', 'user123', 'AB123458', 'MEMBRE', NULL),
(4, 'TALBI', 'Manal', 'talbimanal28@gmail.com', '$2a$10$9aoFQTBalLmoJkHhWdj40.63zwYorhVMIM25g7BQOXN4iRqYnnYQK', 'L000001', 'PRESIDENT', NULL),
(9, 'mouad', 'talbi', 'mouad@gmail.com', '$2a$10$vsGjwq987ZuNaDPyKMTx/O/ovXN5hG70Rspv7hVCF4pw40udZc0i.', 'X313131', 'MEMBRE', NULL),
(10, 'sara', 'krichi', 'sara@gmail.com', '$2a$10$LfPnUg1GvLhzClmsFA2lTOWxlP1SV8TFd9XiN7eBKuCW/985DLlqu', 'BA13488', 'PRESIDENT', NULL),
(12, 'sara', 'krichi', 'krichi@gmail.com', '$2a$10$PFvZihLL4GRBTcF.4sD/cevcBkTNqRyNUg.FCK.4jPxGHLlFfv9KO', 'L000005', 'FEDERATION', NULL),
(13, 'wissal', 'nounousa', 'wissal@gmail.com', '$2a$10$bJjFC8XijcbHp0MisBa7lewe6VCUgqO/ZsnK/qUIP3xy.JeykTP8.', 'bk49346', 'FEDERATION', NULL),
(14, 'imane', 'khaila', 'imane@gmail.com', '$2a$10$jueg217j.Jujo3I.oeZEX.aG6VsI1VShvKsK1AMQri.gcDSnCx4Mi', 'X456', 'MEMBRE', NULL),
(15, 'wiam', 'wiam', 'wiam@gmail.com', '$2a$10$cc4Uh.AkA5Ybfmwtb8g34ewenmovzKTnuiZPYpnye.8esi2PS2cw.', 'G123', 'MEMBRE', NULL),
(16, 'BELHAROUCH', 'CHTIOUIA', 'mama@gmail.com', '$2a$10$A8DWGl2uJv9oa.KhiXJ.8.A6hWT.NmltXJ.BWJkHeUDoQsTHyqxW2', 'c123', 'FEDERATION', NULL),
(17, 'mourtada', 'talbi', 'mourtada@gmail.com', '$2a$10$Wr3aTf3tqBqLbnigK50HCeKN57gLARcVmz9pXHqpi6.b7oH84h6pa', 'v123456', 'MEMBRE', NULL),
(18, 'elkaddaoui', 'Nassim', 'nassim@gmail.com', '$2a$10$B7s6kErn5YryeNCGQdPkaeJQqblYkdRpXevrajHEUlvNQeL.L3Wh2', 'N123456', 'PRESIDENT', NULL),
(19, 'nelmaa', 'dddd', 'nelma@gmail.com', '$2a$10$FQE2jG8.X4oF/6tDkkfsW.u.Q4TsUAuUB9GpH5kWwEBOe3pR9Q0MG', 'x456789', 'FEDERATION', NULL);

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `activite`
--
ALTER TABLE `activite`
  ADD PRIMARY KEY (`id`),
  ADD KEY `planning_id` (`planning_id`);

--
-- Index pour la table `club`
--
ALTER TABLE `club`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `president_id` (`president_id`);

--
-- Index pour la table `demandecreationclub`
--
ALTER TABLE `demandecreationclub`
  ADD PRIMARY KEY (`id`),
  ADD KEY `president_id` (`president_id`);

--
-- Index pour la table `demandeintegration`
--
ALTER TABLE `demandeintegration`
  ADD PRIMARY KEY (`id`),
  ADD KEY `membre_id` (`membre_id`),
  ADD KEY `club_id` (`club_id`);

--
-- Index pour la table `evenement`
--
ALTER TABLE `evenement`
  ADD PRIMARY KEY (`id`),
  ADD KEY `federation_id` (`federation_id`);

--
-- Index pour la table `participation`
--
ALTER TABLE `participation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `membre_id` (`membre_id`),
  ADD KEY `evenement_id` (`evenement_id`);

--
-- Index pour la table `planning`
--
ALTER TABLE `planning`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `club_id` (`club_id`);

--
-- Index pour la table `utilisateur`
--
ALTER TABLE `utilisateur`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `cin` (`cin`),
  ADD KEY `club_id` (`club_id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `activite`
--
ALTER TABLE `activite`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `club`
--
ALTER TABLE `club`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT pour la table `demandecreationclub`
--
ALTER TABLE `demandecreationclub`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT pour la table `demandeintegration`
--
ALTER TABLE `demandeintegration`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT pour la table `evenement`
--
ALTER TABLE `evenement`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT pour la table `participation`
--
ALTER TABLE `participation`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `planning`
--
ALTER TABLE `planning`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `utilisateur`
--
ALTER TABLE `utilisateur`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `activite`
--
ALTER TABLE `activite`
  ADD CONSTRAINT `activite_ibfk_1` FOREIGN KEY (`planning_id`) REFERENCES `planning` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `club`
--
ALTER TABLE `club`
  ADD CONSTRAINT `club_ibfk_1` FOREIGN KEY (`president_id`) REFERENCES `utilisateur` (`id`) ON DELETE SET NULL;

--
-- Contraintes pour la table `demandecreationclub`
--
ALTER TABLE `demandecreationclub`
  ADD CONSTRAINT `demandecreationclub_ibfk_1` FOREIGN KEY (`president_id`) REFERENCES `utilisateur` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `demandeintegration`
--
ALTER TABLE `demandeintegration`
  ADD CONSTRAINT `demandeintegration_ibfk_1` FOREIGN KEY (`membre_id`) REFERENCES `utilisateur` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `demandeintegration_ibfk_2` FOREIGN KEY (`club_id`) REFERENCES `club` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `evenement`
--
ALTER TABLE `evenement`
  ADD CONSTRAINT `evenement_ibfk_1` FOREIGN KEY (`federation_id`) REFERENCES `utilisateur` (`id`);

--
-- Contraintes pour la table `participation`
--
ALTER TABLE `participation`
  ADD CONSTRAINT `participation_ibfk_1` FOREIGN KEY (`membre_id`) REFERENCES `utilisateur` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `participation_ibfk_2` FOREIGN KEY (`evenement_id`) REFERENCES `evenement` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `planning`
--
ALTER TABLE `planning`
  ADD CONSTRAINT `planning_ibfk_1` FOREIGN KEY (`club_id`) REFERENCES `club` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `utilisateur`
-- =================================================================
-- Chess Club Management System - Complete Database Schema
-- =================================================================

-- Create database if not exists
CREATE DATABASE IF NOT EXISTS chess_club_db
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_general_ci;

USE chess_club_db;

-- =================================================================
-- Table: Club
-- Represents a chess club with its status and president
-- =================================================================
CREATE TABLE IF NOT EXISTS Club (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  nom VARCHAR(255) NOT NULL,
  logo VARCHAR(255),
  description TEXT,
  statut ENUM('EN_ATTENTE', 'ACTIF', 'REFUSE', 'SUSPENDU', 'ARCHIVE') NOT NULL DEFAULT 'EN_ATTENTE',
  date_creation DATETIME DEFAULT CURRENT_TIMESTAMP,
  president_id BIGINT UNIQUE,
  federation_id BIGINT,
  adresse VARCHAR(255),
  ville VARCHAR(100),
  code_postal VARCHAR(20),
  telephone VARCHAR(20),
  email VARCHAR(100),
  site_web VARCHAR(255),
  INDEX idx_statut (statut)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =================================================================
-- Table: Utilisateur
-- Central table for all system users with role-based access
-- =================================================================
CREATE TABLE IF NOT EXISTS Utilisateur (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  nom VARCHAR(100) NOT NULL,
  prenom VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  motDePasse VARCHAR(100) NOT NULL,
  cin VARCHAR(20) NOT NULL UNIQUE,
  role ENUM('FEDERATION', 'PRESIDENT', 'MEMBRE') NOT NULL,
  statut ENUM('ACTIF', 'INACTIF', 'EN_ATTENTE') NOT NULL DEFAULT 'EN_ATTENTE',
  date_inscription DATETIME DEFAULT CURRENT_TIMESTAMP,
  derniere_connexion DATETIME,
  telephone VARCHAR(20),
  adresse TEXT,
  date_naissance DATE,
  elo_standard INT,
  elo_rapide INT,
  elo_blitz INT,
  club_id BIGINT,
  photo_profil VARCHAR(255),
  est_verifie BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (club_id) REFERENCES Club(id) ON DELETE SET NULL,
  INDEX idx_email (email),
  INDEX idx_club (club_id),
  INDEX idx_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Add foreign key from Club to Utilisateur for president
ALTER TABLE Club
ADD CONSTRAINT fk_club_president
FOREIGN KEY (president_id) REFERENCES Utilisateur(id) ON DELETE SET NULL;

-- =================================================================
-- Table: VerificationToken
-- Stores email verification tokens for user registration
-- =================================================================
CREATE TABLE IF NOT EXISTS VerificationToken (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  token VARCHAR(255) NOT NULL UNIQUE,
  email VARCHAR(255) NOT NULL,
  nom VARCHAR(100) NOT NULL,
  prenom VARCHAR(100) NOT NULL,
  cin VARCHAR(20) NOT NULL,
  motDePasse VARCHAR(100) NOT NULL,
  role VARCHAR(20) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  expires_at TIMESTAMP NOT NULL,
  INDEX idx_token (token),
  INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =================================================================
-- Table: DemandeIntegration
-- Tracks membership requests to join clubs
-- =================================================================
CREATE TABLE IF NOT EXISTS DemandeIntegration (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  dateDemande DATETIME DEFAULT CURRENT_TIMESTAMP,
  statut ENUM('EN_ATTENTE', 'ACCEPTEE', 'REFUSEE') NOT NULL DEFAULT 'EN_ATTENTE',
  message TEXT,
  date_traitement DATETIME,
  motif_refus TEXT,
  membre_id BIGINT NOT NULL,
  club_id BIGINT NOT NULL,
  FOREIGN KEY (membre_id) REFERENCES Utilisateur(id) ON DELETE CASCADE,
  FOREIGN KEY (club_id) REFERENCES Club(id) ON DELETE CASCADE,
  INDEX idx_membre (membre_id),
  INDEX idx_club (club_id),
  INDEX idx_statut (statut)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =================================================================
-- Table: Evenement
-- Stores information about chess events and tournaments
-- =================================================================
CREATE TABLE IF NOT EXISTS Evenement (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  titre VARCHAR(255) NOT NULL,
  description TEXT,
  lieu VARCHAR(255),
  dateDebut DATETIME NOT NULL,
  dateFin DATETIME NOT NULL,
  dateLimiteInscription DATETIME,
  nbPlacesMax INT,
  statut ENUM('PLANIFIE', 'EN_COURS', 'TERMINE', 'ANNULE') NOT NULL DEFAULT 'PLANIFIE',
  type_evenement VARCHAR(50),
  cout_participation DECIMAL(10,2) DEFAULT 0,
  image_url VARCHAR(255),
  created_by BIGINT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (created_by) REFERENCES Utilisateur(id) ON DELETE SET NULL,
  INDEX idx_dates (dateDebut, dateFin),
  INDEX idx_statut (statut)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =================================================================
-- Table: Participation
-- Tracks member participation in events
-- =================================================================
CREATE TABLE IF NOT EXISTS Participation (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  dateInscription DATETIME DEFAULT CURRENT_TIMESTAMP,
  dateConfirmation DATETIME,
  statut ENUM('INVITE', 'INSCRIT', 'CONFIRME', 'REFUSE', 'ANNULE') NOT NULL DEFAULT 'INSCRIT',
  resultat VARCHAR(100),
  classement INT,
  score DECIMAL(10,2) DEFAULT 0,
  nb_victoires INT DEFAULT 0,
  nb_nuls INT DEFAULT 0,
  nb_defaites INT DEFAULT 0,
  membre_id BIGINT NOT NULL,
  evenement_id BIGINT NOT NULL,
  FOREIGN KEY (membre_id) REFERENCES Utilisateur(id) ON DELETE CASCADE,
  FOREIGN KEY (evenement_id) REFERENCES Evenement(id) ON DELETE CASCADE,
  UNIQUE KEY unique_participation (membre_id, evenement_id),
  INDEX idx_membre (membre_id),
  INDEX idx_evenement (evenement_id),
  INDEX idx_statut (statut)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =================================================================
-- Table: Planning
-- Club schedules and activities
-- =================================================================
CREATE TABLE IF NOT EXISTS Planning (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  nom VARCHAR(100) NOT NULL,
  description TEXT,
  date_creation DATETIME DEFAULT CURRENT_TIMESTAMP,
  date_modification DATETIME ON UPDATE CURRENT_TIMESTAMP,
  club_id BIGINT NOT NULL,
  created_by BIGINT,
  FOREIGN KEY (club_id) REFERENCES Club(id) ON DELETE CASCADE,
  FOREIGN KEY (created_by) REFERENCES Utilisateur(id) ON DELETE SET NULL,
  INDEX idx_club (club_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =================================================================
-- Table: Activite
-- Activities within a schedule
-- =================================================================
CREATE TABLE IF NOT EXISTS Activite (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  titre VARCHAR(255) NOT NULL,
  description TEXT,
  type_activite VARCHAR(50) NOT NULL,
  jour_semaine ENUM('LUNDI', 'MARDI', 'MERCREDI', 'JEUDI', 'VENDREDI', 'SAMEDI', 'DIMANCHE') NOT NULL,
  heure_debut TIME NOT NULL,
  heure_fin TIME NOT NULL,
  planning_id BIGINT NOT NULL,
  responsable_id BIGINT,
  salle VARCHAR(100),
  capacite_max INT,
  statut ENUM('ACTIF', 'INACTIF', 'ANNULE') DEFAULT 'ACTIF',
  FOREIGN KEY (planning_id) REFERENCES Planning(id) ON DELETE CASCADE,
  FOREIGN KEY (responsable_id) REFERENCES Utilisateur(id) ON DELETE SET NULL,
  INDEX idx_planning (planning_id),
  INDEX idx_jour_heure (jour_semaine, heure_debut)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =================================================================
-- Table: Notification
-- System notifications for users
-- =================================================================
CREATE TABLE IF NOT EXISTS Notification (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  message TEXT NOT NULL,
  type VARCHAR(50) NOT NULL,
  date_creation DATETIME DEFAULT CURRENT_TIMESTAMP,
  date_lecture DATETIME,
  lue BOOLEAN DEFAULT FALSE,
  lien_action VARCHAR(255),
  utilisateur_id BIGINT NOT NULL,
  emetteur_id BIGINT,
  FOREIGN KEY (utilisateur_id) REFERENCES Utilisateur(id) ON DELETE CASCADE,
  FOREIGN KEY (emetteur_id) REFERENCES Utilisateur(id) ON DELETE SET NULL,
  INDEX idx_utilisateur (utilisateur_id, date_creation),
  INDEX idx_lue (lue)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =================================================================
-- Table: Podium
-- Tournament results and rankings
-- =================================================================
CREATE TABLE IF NOT EXISTS Podium (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  evenement_id BIGINT NOT NULL,
  premier_place_id BIGINT,
  deuxieme_place_id BIGINT,
  troisieme_place_id BIGINT,
  date_creation DATETIME DEFAULT CURRENT_TIMESTAMP,
  commentaires TEXT,
  FOREIGN KEY (evenement_id) REFERENCES Evenement(id) ON DELETE CASCADE,
  FOREIGN KEY (premier_place_id) REFERENCES Utilisateur(id) ON DELETE SET NULL,
  FOREIGN KEY (deuxieme_place_id) REFERENCES Utilisateur(id) ON DELETE SET NULL,
  FOREIGN KEY (troisieme_place_id) REFERENCES Utilisateur(id) ON DELETE SET NULL,
  UNIQUE KEY unique_evenement (evenement_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =================================================================
-- Table: Partie
-- Chess games between players
-- =================================================================
CREATE TABLE IF NOT EXISTS Partie (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  evenement_id BIGINT,
  tour INT,
  ronde INT,
  joueur_blanc_id BIGINT,
  joueur_noir_id BIGINT,
  resultat ENUM('BLANC_GAGNE', 'NOIR_GAGNE', 'NUL', 'EN_COURS', 'ANNULE') DEFAULT 'EN_COURS',
  pgn TEXT,
  date_debut DATETIME,
  date_fin DATETIME,
  duree_secondes INT,
  arbitre_id BIGINT,
  commentaires TEXT,
  FOREIGN KEY (evenement_id) REFERENCES Evenement(id) ON DELETE CASCADE,
  FOREIGN KEY (joueur_blanc_id) REFERENCES Utilisateur(id) ON DELETE SET NULL,
  FOREIGN KEY (joueur_noir_id) REFERENCES Utilisateur(id) ON DELETE SET NULL,
  FOREIGN KEY (arbitre_id) REFERENCES Utilisateur(id) ON DELETE SET NULL,
  INDEX idx_evenement (evenement_id),
  INDEX idx_joueurs (joueur_blanc_id, joueur_noir_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =================================================================
-- Table: Message
-- Internal messaging between users
-- =================================================================
CREATE TABLE IF NOT EXISTS Message (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  expediteur_id BIGINT NOT NULL,
  destinataire_id BIGINT,
  club_id BIGINT,
  evenement_id BIGINT,
  sujet VARCHAR(255),
  contenu TEXT NOT NULL,
  date_envoi DATETIME DEFAULT CURRENT_TIMESTAMP,
  lu BOOLEAN DEFAULT FALSE,
  date_lecture DATETIME,
  supprime_exp BOOLEAN DEFAULT FALSE,
  supprime_dest BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (expediteur_id) REFERENCES Utilisateur(id) ON DELETE CASCADE,
  FOREIGN KEY (destinataire_id) REFERENCES Utilisateur(id) ON DELETE SET NULL,
  FOREIGN KEY (club_id) REFERENCES Club(id) ON DELETE CASCADE,
  FOREIGN KEY (evenement_id) REFERENCES Evenement(id) ON DELETE SET NULL,
  INDEX idx_expediteur (expediteur_id, date_envoi),
  INDEX idx_destinataire (destinataire_id, lu, date_envoi)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =================================================================
-- Table: Document
-- Document management for clubs and events
-- =================================================================
CREATE TABLE IF NOT EXISTS Document (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  nom_fichier VARCHAR(255) NOT NULL,
  chemin_fichier VARCHAR(512) NOT NULL,
  type_mime VARCHAR(100),
  taille BIGINT,
  type_document VARCHAR(50),
  statut VARCHAR(20) DEFAULT 'ACTIF',
  date_upload DATETIME DEFAULT CURRENT_TIMESTAMP,
  upload_par BIGINT,
  club_id BIGINT,
  evenement_id BIGINT,
  FOREIGN KEY (upload_par) REFERENCES Utilisateur(id) ON DELETE SET NULL,
  FOREIGN KEY (club_id) REFERENCES Club(id) ON DELETE CASCADE,
  FOREIGN KEY (evenement_id) REFERENCES Evenement(id) ON DELETE CASCADE,
  INDEX idx_club (club_id),
  INDEX idx_evenement (evenement_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =================================================================
-- Table: Parametre
-- System configuration parameters
-- =================================================================
CREATE TABLE IF NOT EXISTS Parametre (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  cle VARCHAR(100) NOT NULL UNIQUE,
  valeur TEXT,
  type_donnee VARCHAR(20) DEFAULT 'TEXTE',
  categorie VARCHAR(50),
  description TEXT,
  modifiable BOOLEAN DEFAULT TRUE,
  date_creation DATETIME DEFAULT CURRENT_TIMESTAMP,
  date_modification DATETIME ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_cle (cle),
  INDEX idx_categorie (categorie)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =================================================================
-- Table: Journal
-- System activity log
-- =================================================================
CREATE TABLE IF NOT EXISTS Journal (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  date_operation DATETIME DEFAULT CURRENT_TIMESTAMP,
  type_operation VARCHAR(50) NOT NULL,
  entite VARCHAR(50) NOT NULL,
  entite_id BIGINT,
  utilisateur_id BIGINT,
  ip_adresse VARCHAR(45),
  user_agent VARCHAR(255),
  ancienne_valeur TEXT,
  nouvelle_valeur TEXT,
  FOREIGN KEY (utilisateur_id) REFERENCES Utilisateur(id) ON DELETE SET NULL,
  INDEX idx_date (date_operation),
  INDEX idx_utilisateur (utilisateur_id, date_operation),
  INDEX idx_entite (entite, entite_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =================================================================
-- Insert default system parameters
-- =================================================================
INSERT INTO Parametre (cle, valeur, type_donnee, categorie, description, modifiable) VALUES
('SITE_NOM', 'Gestion des Clubs d\'Échecs', 'TEXTE', 'GENERAL', 'Nom du site web', TRUE),
('SITE_EMAIL', 'contact@chessclub.ma', 'TEXTE', 'GENERAL', 'Email de contact du site', TRUE),
('INSCRIPTION_ACTIVEE', 'true', 'BOOLEAN', 'INSCRIPTION', 'Autoriser les nouvelles inscriptions', TRUE),
('VERIFICATION_EMAIL_OBLIGATOIRE', 'true', 'BOOLEAN', 'SECURITE', 'Obliger la vérification par email', TRUE),
('TAILLE_MIN_MDP', '8', 'ENTIER', 'SECURITE', 'Longueur minimale des mots de passe', TRUE),
('SESSION_TIMEOUT', '1800', 'ENTIER', 'SECURITE', 'Délai d\'inactivité avant déconnexion (secondes)', TRUE),
('UPLOAD_MAX_TAILLE', '10485760', 'ENTIER', 'UPLOAD', 'Taille maximale des fichiers uploadés (en octets)', TRUE),
('FORMAT_IMAGES_AUTORISES', 'jpg,jpeg,png,gif', 'TEXTE', 'UPLOAD', 'Extensions de fichiers images autorisées', TRUE),
('FORMAT_DOCUMENTS_AUTORISES', 'pdf,doc,docx,xls,xlsx,ppt,pptx', 'TEXTE', 'UPLOAD', 'Extensions de documents autorisées', TRUE);

-- =================================================================
-- Create indexes for better performance
-- =================================================================
ALTER TABLE Utilisateur ADD FULLTEXT INDEX idx_recherche (nom, prenom, email, cin);
ALTER TABLE Evenement ADD FULLTEXT INDEX idx_recherche_evenement (titre, description, lieu);
ALTER TABLE Club ADD FULLTEXT INDEX idx_recherche_club (nom, description, ville);

-- =================================================================
-- Create views for common queries
-- =================================================================
CREATE OR REPLACE VIEW vue_membres_par_club AS
SELECT 
    c.id AS club_id,
    c.nom AS club_nom,
    COUNT(DISTINCT u.id) AS nombre_membres,
    MAX(u.date_inscription) AS dernier_membre_date
FROM 
    Club c
LEFT JOIN 
    Utilisateur u ON c.id = u.club_id
WHERE 
    u.role = 'MEMBRE' 
    AND u.statut = 'ACTIF'
GROUP BY 
    c.id, c.nom;

CREATE OR REPLACE VIEW vue_evenements_a_venir AS
SELECT 
    e.*,
    COUNT(DISTINCT p.id) AS nombre_participants,
    CONCAT(u.prenom, ' ', u.nom) AS organisateur
FROM 
    Evenement e
LEFT JOIN 
    Participation p ON e.id = p.evenement_id AND p.statut = 'CONFIRME'
LEFT JOIN
    Utilisateur u ON e.created_by = u.id
WHERE 
    e.dateDebut >= CURRENT_DATE()
    AND e.statut = 'PLANIFIE'
GROUP BY 
    e.id;

-- =================================================================
-- Create stored procedures
-- =================================================================
DELIMITER //

-- Procedure to archive old events
CREATE PROCEDURE archiver_evenements_termines()
BEGIN
    UPDATE Evenement 
    SET statut = 'ARCHIVE' 
    WHERE statut = 'TERMINE' 
    AND dateFin < DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR);
END //

-- Procedure to clean up old verification tokens
CREATE PROCEDURE nettoyer_tokens_expires()
BEGIN
    DELETE FROM VerificationToken 
    WHERE expires_at < NOW();
END //

DELIMITER ;

-- =================================================================
-- Create events for maintenance tasks
-- =================================================================
DELIMITER //

-- Event to clean up old tokens daily
CREATE EVENT IF NOT EXISTS event_nettoyage_tokens
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
    CALL nettoyer_tokens_expires();
END //

-- Event to archive old events weekly
CREATE EVENT IF NOT EXISTS event_archivage_evenements
ON SCHEDULE EVERY 1 WEEK
DO
BEGIN
    CALL archiver_evenements_termines();
END //

DELIMITER ;

-- =================================================================
-- Database schema version
-- =================================================================
CREATE TABLE IF NOT EXISTS SchemaVersion (
    version VARCHAR(20) PRIMARY KEY,
    date_application DATETIME DEFAULT CURRENT_TIMESTAMP,
    description TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =================================================================
-- Sample Data for Testing
-- =================================================================

-- Insert Federation Admin
INSERT INTO Utilisateur (nom, prenom, email, motDePasse, role, estVerifie, dateInscription)
VALUES ('Talbi', 'Manal', 'talbimanal28@gmail.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'FEDERATION', TRUE, NOW());

-- Insert President
INSERT INTO Utilisateur (nom, prenom, email, motDePasse, role, estVerifie, dateInscription)
VALUES ('El Kaddaoui', 'Nassim', 'nassimelkaddaoui18@gmail.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'PRESIDENT', TRUE, NOW());

-- Insert Club Member
INSERT INTO Utilisateur (nom, prenom, email, motDePasse, role, estVerifie, dateInscription)
VALUES ('Krichi', 'Sara', 'krichi.2003.sara@gmail.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'MEMBRE', TRUE, NOW());

-- Insert Additional Test Users (Club Members)
INSERT INTO Utilisateur (nom, prenom, email, motDePasse, role, estVerifie, dateInscription) VALUES
('Benali', 'Mehdi', 'mehdi.benali@example.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'MEMBRE', TRUE, NOW()),
('Zouhair', 'Amina', 'amina.zouhair@example.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'MEMBRE', TRUE, NOW()),
('El Amrani', 'Youssef', 'youssef.elamrani@example.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'MEMBRE', TRUE, NOW()),
('Bennani', 'Laila', 'laila.bennani@example.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'MEMBRE', TRUE, NOW()),
('Cherkaoui', 'Karim', 'karim.cherkaoui@example.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'PRESIDENT', TRUE, NOW());

-- Insert El Haiaa El Maghrebia Club with the correct logo path
INSERT INTO Club (nom, logo, description, statut, president_id) VALUES
('El Haiaa El Maghrebia', 'uploads/chess_club_logo/chess_club_logo.jpeg', 'Club d''échecs El Haiaa El Maghrebia, promouvant l''excellence aux échecs depuis 2010.', 'ACTIF', 
 (SELECT id FROM Utilisateur WHERE email = 'nassimelkaddaoui18@gmail.com'));

-- Insert another club without logo (as the file doesn't exist)
INSERT INTO Club (nom, description, statut, president_id) VALUES
('Les Cavaliers de Casablanca', 'Un club dynamique formant les futurs champions d''échecs du Maroc.', 'ACTIF',
 (SELECT id FROM Utilisateur WHERE email = 'karim.cherkaoui@example.com'));

-- Update President's club_id
UPDATE Utilisateur 
SET club_id = (SELECT id FROM Club WHERE nom = 'El Haiaa El Maghrebia')
WHERE email = 'nassimelkaddaoui18@gmail.com';

-- Update Members' club_id
UPDATE Utilisateur 
SET club_id = (SELECT id FROM Club WHERE nom = 'El Haiaa El Maghrebia')
WHERE email IN ('krichi.2003.sara@gmail.com', 'mehdi.benali@example.com', 'amina.zouhair@example.com');

UPDATE Utilisateur 
SET club_id = (SELECT id FROM Club WHERE nom = 'Les Cavaliers de Casablanca')
WHERE email IN ('youssef.elamrani@example.com', 'laila.bennani@example.com');

-- Insert Events
INSERT INTO Evenement (titre, description, dateDebut, dateFin, lieu, statut, createur_id, club_id) VALUES
('Championnat Marocain des Échecs', 'Le tournoi national annuel rassemblant les meilleurs joueurs du Maroc.', 
 '2025-12-12 09:00:00', '2025-12-27 18:00:00', 'Complexe Sportif Mohammed V, Casablanca', 'PLANIFIE',
 (SELECT id FROM Utilisateur WHERE email = 'talbimanal28@gmail.com'), NULL),
('Open International de Rabat', 'Tournoi international avec des joueurs de toute l''Afrique du Nord.', 
 '2025-11-15 10:00:00', '2025-11-17 20:00:00', 'Palais des Congrès, Rabat', 'TERMINE',
 (SELECT id FROM Utilisateur WHERE email = 'talbimanal28@gmail.com'), NULL),
('Tournoi des Jeunes Espoirs', 'Compétition réservée aux jeunes de moins de 18 ans.', 
 '2026-01-20 09:00:00', '2026-01-22 18:00:00', 'Centre Culturel d''Agadir', 'PLANIFIE',
 (SELECT id FROM Utilisateur WHERE email = 'nassimelkaddaoui18@gmail.com'), 
 (SELECT id FROM Club WHERE nom = 'El Haiaa El Maghrebia'));

-- Insert Event Participants
INSERT INTO Participation (evenement_id, utilisateur_id, statut, dateInscription) VALUES
((SELECT id FROM Evenement WHERE titre = 'Championnat Marocain des Échecs'), 
 (SELECT id FROM Utilisateur WHERE email = 'nassimelkaddaoui18@gmail.com'), 'CONFIRME', NOW()),
((SELECT id FROM Evenement WHERE titre = 'Championnat Marocain des Échecs'), 
 (SELECT id FROM Utilisateur WHERE email = 'krichi.2003.sara@gmail.com'), 'CONFIRME', NOW()),
((SELECT id FROM Evenement WHERE titre = 'Open International de Rabat'), 
 (SELECT id FROM Utilisateur WHERE email = 'mehdi.benali@example.com'), 'CONFIRME', '2025-10-15 14:30:00'),
((SELECT id FROM Evenement WHERE titre = 'Tournoi des Jeunes Espoirs'), 
 (SELECT id FROM Utilisateur WHERE email = 'amina.zouhair@example.com'), 'INSCRIT', NOW());

-- Insert Sample Games
INSERT INTO Partie (evenement_id, tour, ronde, joueurBlanc_id, joueurNoir_id, resultat, dateDebut, dateFin) VALUES
((SELECT id FROM Evenement WHERE titre = 'Open International de Rabat'), 1, 1, 
 (SELECT id FROM Utilisateur WHERE email = 'mehdi.benali@example.com'),
 (SELECT id FROM Utilisateur WHERE email = 'laila.bennani@example.com'),
 'BLANC', '2025-11-15 10:00:00', '2025-11-15 11:30:00'),
((SELECT id FROM Evenement WHERE titre = 'Open International de Rabat'), 1, 2, 
 (SELECT id FROM Utilisateur WHERE email = 'youssef.elamrani@example.com'),
 (SELECT id FROM Utilisateur WHERE email = 'karim.cherkaoui@example.com'),
 'NOIR', '2025-11-15 11:30:00', '2025-11-15 13:00:00');

-- Insert Sample Notifications
INSERT INTO Notification (titre, message, type, dateCreation, utilisateur_id, lue) VALUES
('Bienvenue sur Chess Club', 'Merci de vous être inscrit sur notre plateforme !', 'INFO', NOW(), 
 (SELECT id FROM Utilisateur WHERE email = 'krichi.2003.sara@gmail.com'), FALSE),
('Confirmation d''inscription', 'Votre inscription au Championnat Marocain des Échecs a été confirmée.', 'EVENEMENT', 
 '2025-11-10 15:30:00', (SELECT id FROM Utilisateur WHERE email = 'krichi.2003.sara@gmail.com'), TRUE),
('Nouveau message', 'Vous avez reçu un nouveau message de la part de l''administration.', 'MESSAGE', 
 NOW(), (SELECT id FROM Utilisateur WHERE email = 'nassimelkaddaoui18@gmail.com'), FALSE);

-- Insert Sample Documents
INSERT INTO Document (titre, description, cheminFichier, type, dateUpload, utilisateur_id, club_id, evenement_id) VALUES
('Règlement du Championnat', 'Règlement officiel du Championnat Marocain des Échecs 2025', 
 'uploads/documents/reglement_championnat_2025.pdf', 'PDF', NOW(), 
 (SELECT id FROM Utilisateur WHERE email = 'talbimanal28@gmail.com'), NULL, 
 (SELECT id FROM Evenement WHERE titre = 'Championnat Marocain des Échecs')),
('Fiche d''inscription', 'Formulaire d''inscription pour les tournois', 
 'uploads/documents/fiche_inscription.pdf', 'PDF', '2025-11-05 10:00:00', 
 (SELECT id FROM Utilisateur WHERE email = 'nassimelkaddaoui18@gmail.com'), 
 (SELECT id FROM Club WHERE nom = 'El Haiaa El Maghrebia'), NULL);

-- Insert Sample Planning and Activities
INSERT INTO Planning (titre, description, dateDebut, dateFin, club_id) VALUES
('Entraînements Novembre 2025', 'Séances d''entraînement pour le mois de novembre', 
 '2025-11-01 00:00:00', '2025-11-30 23:59:59', 
 (SELECT id FROM Club WHERE nom = 'El Haiaa El Maghrebia'));

INSERT INTO Activite (titre, type, dateDebut, dateFin, planning_id) VALUES
('Entraînement Débutants', 'ENTRAINEMENT', '2025-11-05 16:00:00', '2025-11-05 18:00:00', 
 (SELECT id FROM Planning WHERE titre = 'Entraînements Novembre 2025')),
('Analyse de Parties', 'ATELIER', '2025-11-12 16:00:00', '2025-11-12 18:00:00', 
 (SELECT id FROM Planning WHERE titre = 'Entraînements Novembre 2025')),
('Tournoi Amical', 'TOURNOI', '2025-11-19 14:00:00', '2025-11-19 20:00:00', 
 (SELECT id FROM Planning WHERE titre = 'Entraînements Novembre 2025'));

-- Insert Sample Messages
INSERT INTO Message (expediteur_id, destinataire_id, objet, contenu, dateEnvoi, lu) VALUES
((SELECT id FROM Utilisateur WHERE email = 'talbimanal28@gmail.com'),
 (SELECT id FROM Utilisateur WHERE email = 'nassimelkaddaoui18@gmail.com'),
 'Confirmation de l''équipe pour le championnat',
 'Bonjour Nassim, je vous confirme la participation de votre équipe au championnat. Cordialement, Manal',
 '2025-11-08 11:23:45', TRUE),
((SELECT id FROM Utilisateur WHERE email = 'nassimelkaddaoui18@gmail.com'),
 (SELECT id FROM Utilisateur WHERE email = 'krichi.2003.sara@gmail.com'),
 'Réunion d''équipe',
 'Bonjour Sara, nous avons une réunion demain à 16h pour préparer le tournoi. À demain !',
 '2025-11-09 15:10:22', FALSE);

-- Update Schema Version
UPDATE SchemaVersion 
SET version = '1.1.0', 
    description = 'Added sample data for testing' 
WHERE version = '1.0.0';

COMMIT;

-- =================================================================
-- End of database schema
-- =================================================================

-- Enable event scheduler if not already enabled
SET GLOBAL event_scheduler = ON;
