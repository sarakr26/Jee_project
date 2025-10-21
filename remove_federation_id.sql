-- Script pour supprimer la colonne federation_id de la table Evenement
-- Exécuter ce script sur votre base de données existante

USE chess_club_db;

-- Étape 1: Supprimer la contrainte de clé étrangère (si elle existe)
ALTER TABLE Evenement DROP FOREIGN KEY IF EXISTS evenement_ibfk_1;

-- Étape 2: Supprimer la colonne federation_id
ALTER TABLE Evenement DROP COLUMN IF EXISTS federation_id;

-- Vérification: Afficher la structure de la table après modification
DESCRIBE Evenement;
