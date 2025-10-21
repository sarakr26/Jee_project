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
--
ALTER TABLE `utilisateur`
  ADD CONSTRAINT `utilisateur_ibfk_1` FOREIGN KEY (`club_id`) REFERENCES `club` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
