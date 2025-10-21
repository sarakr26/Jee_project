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
INSERT INTO DemandeIntegration (dateDemande, statut, membre_id, club_id) 
VALUES 
('2024-01-15', 'EN_ATTENTE', 4, 1),
('2024-01-16', 'EN_ATTENTE', 5, 2),
('2024-01-17', 'EN_ATTENTE', 6, 3);

-- Créer quelques événements
INSERT INTO Evenement (titre, description, lieu, dateDebut, dateFin, statut, federation_id) 
VALUES 
('Championnat National', 'Tournoi national d''échecs', 'Casablanca', '2024-02-01', '2024-02-03', 'PLANIFIE', 1),
('Tournoi Rapide', 'Tournoi de parties rapides', 'Rabat', '2024-01-25', '2024-01-25', 'PLANIFIE', 1),
('Formation Arbitres', 'Formation pour devenir arbitre', 'Marrakech', '2024-01-30', '2024-01-31', 'PLANIFIE', 1);
