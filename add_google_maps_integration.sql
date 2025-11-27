-- =================================================================
-- Script pour améliorer l'intégration Google Maps
-- Optionnel : Ajouter des champs de localisation aux clubs
-- =================================================================

USE chess_club_db;

-- =================================================================
-- Option 1: Ajouter des champs d'adresse et coordonnées à la table Club
-- =================================================================

-- Ajouter le champ adresse (si pas déjà présent)
ALTER TABLE Club 
ADD COLUMN IF NOT EXISTS adresse VARCHAR(255) NULL COMMENT 'Adresse complète du club';

-- Ajouter les champs de coordonnées GPS (optionnel, pour améliorer la précision)
ALTER TABLE Club 
ADD COLUMN IF NOT EXISTS latitude DECIMAL(10, 8) NULL COMMENT 'Latitude GPS du club',
ADD COLUMN IF NOT EXISTS longitude DECIMAL(11, 8) NULL COMMENT 'Longitude GPS du club';

-- Ajouter un index pour améliorer les recherches par localisation
CREATE INDEX IF NOT EXISTS idx_club_location ON Club(latitude, longitude);

-- =================================================================
-- Option 2: Ajouter des champs similaires aux événements si nécessaire
-- =================================================================

-- Les événements utilisent déjà le champ "lieu" qui peut être géocodé
-- Pas besoin de modifications supplémentaires

-- =================================================================
-- Exemple de mise à jour de données existantes
-- =================================================================

-- Mettre à jour quelques clubs avec des adresses d'exemple (optionnel)
-- UPDATE Club SET adresse = '123 Rue des Échecs, Casablanca, Maroc' WHERE id = 1;
-- UPDATE Club SET adresse = '45 Avenue du Roi, Rabat, Maroc' WHERE id = 2;

-- Note: Les coordonnées GPS peuvent être obtenues via géocodage Google Maps
-- ou saisies manuellement si vous les connaissez


