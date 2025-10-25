-- Script pour supprimer la colonne federation_id de la table Evenement
-- Ce script corrige le problème de création d'événements

USE chess_club_db;

-- Vérifier si la colonne federation_id existe et la supprimer
SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
     WHERE TABLE_SCHEMA = 'chess_club_db' 
     AND TABLE_NAME = 'Evenement' 
     AND COLUMN_NAME = 'federation_id') > 0,
    'ALTER TABLE Evenement DROP COLUMN federation_id',
    'SELECT "La colonne federation_id n''existe pas"'
));

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Vérifier la structure de la table après modification
DESCRIBE Evenement;
