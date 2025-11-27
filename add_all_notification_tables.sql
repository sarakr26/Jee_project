-- =================================================================
-- Script complet pour ajouter les notifications dans la base de données
-- A exécuter dans MySQL/MariaDB
-- =================================================================

USE chess_club_db;

-- =================================================================
-- Table Notification
-- Stocke toutes les notifications pour les membres
-- =================================================================

-- Supprimer la table si elle existe déjà (optionnel)
-- DROP TABLE IF EXISTS Notification;

CREATE TABLE IF NOT EXISTS Notification (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  message TEXT NOT NULL,
  type VARCHAR(50) NOT NULL COMMENT 'Types: CLUB_ACCEPTED, EVENT_ADDED, MEMBRE_EVENT_ADDED',
  dateCreation DATE NOT NULL,
  lu BOOLEAN DEFAULT FALSE COMMENT 'false = non lu, true = lu',
  membre_id BIGINT NOT NULL,
  FOREIGN KEY (membre_id) REFERENCES Utilisateur(id) ON DELETE CASCADE,
  INDEX idx_membre_date (membre_id, dateCreation)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- =================================================================
-- Types de notifications supportés
-- =================================================================

-- CLUB_ACCEPTED: Quand un président accepte une demande d'intégration de club
-- EVENT_ADDED: Quand la fédération ou un président crée un nouvel événement
-- MEMBRE_EVENT_ADDED: Quand un président sélectionne un membre comme représentant

-- =================================================================
-- Vérifications
-- =================================================================

-- Vérifier que la table a été créée
SELECT 'Table Notification créée avec succès!' as Status;
SHOW CREATE TABLE Notification;

-- Compter les notifications existantes
SELECT COUNT(*) as total_notifications FROM Notification;

-- =================================================================
-- Instructions de test
-- =================================================================

-- 1. Pour insérer une notification de test manuellement :
/*
INSERT INTO Notification (message, type, dateCreation, lu, membre_id) 
VALUES (
    'Test notification - Nouvel événement créé',
    'EVENT_ADDED',
    CURDATE(),
    false,
    1  -- Remplacez 1 par un ID membre existant
);
*/

-- 2. Pour voir toutes les notifications :
/*
SELECT * FROM Notification ORDER BY dateCreation DESC;
*/

-- 3. Pour voir les notifications d'un membre spécifique :
/*
SELECT * FROM Notification WHERE membre_id = [ID_DU_MEMBRE] ORDER BY dateCreation DESC;
*/

-- 4. Pour voir les notifications non lues :
/*
SELECT * FROM Notification WHERE lu = false;
*/

-- 5. Pour marquer une notification comme lue :
/*
UPDATE Notification SET lu = true WHERE id = [ID_NOTIFICATION];
*/

-- 6. Pour compter les notifications non lues d'un membre :
/*
SELECT COUNT(*) as non_lues 
FROM Notification 
WHERE membre_id = [ID_DU_MEMBRE] AND lu = false;
*/

-- 7. Pour tester avec un membre existant :
/*
-- Trouver un membre
SELECT id, nom, prenom, email FROM Utilisateur WHERE role = 'MEMBRE' LIMIT 1;

-- Créer une notification de test pour ce membre
INSERT INTO Notification (message, type, dateCreation, lu, membre_id) 
VALUES (
    'Événement test créé le ' || CURDATE(),
    'EVENT_ADDED',
    CURDATE(),
    false,
    (SELECT id FROM Utilisateur WHERE role = 'MEMBRE' LIMIT 1)
);

-- Vérifier
SELECT * FROM Notification WHERE lu = false;
*/

-- =================================================================
-- Nettoyage (optionnel - à exécuter avec prudence)
-- =================================================================

-- Pour supprimer toutes les notifications de test :
/*
DELETE FROM Notification WHERE message LIKE '%test%';
*/

-- Pour supprimer toutes les notifications (attention !) :
/*
TRUNCATE TABLE Notification;
*/

-- =================================================================
-- Structure finale attendue
-- =================================================================

/*
+---------------+--------------+------+-----+---------+----------------+
| Field         | Type         | Null | Key | Default | Extra          |
+---------------+--------------+------+-----+---------+----------------+
| id            | bigint(20)   | NO   | PRI | NULL    | auto_increment |
| message       | text         | NO   |     | NULL    |                |
| type          | varchar(50)  | NO   |     | NULL    |                |
| dateCreation  | date         | NO   |     | NULL    |                |
| lu            | tinyint(1)   | YES  |     | 0       |                |
| membre_id     | bigint(20)   | NO   | MUL | NULL    |                |
+---------------+--------------+------+-----+---------+----------------+
*/




