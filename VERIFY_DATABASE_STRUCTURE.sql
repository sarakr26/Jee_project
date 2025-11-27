-- =================================================================
-- Script de vérification de la structure de la base de données
-- Vérifie que toutes les tables et relations nécessaires existent
-- =================================================================

USE chess_club_db;

-- =================================================================
-- Vérifier les tables principales
-- =================================================================

SELECT 'Vérification des tables...' as Info;

-- Vérifier Utilisateur
SELECT 'Table Utilisateur:' as Status, COUNT(*) as total_users FROM Utilisateur;
SELECT id, nom, prenom, role, club_id FROM Utilisateur WHERE role = 'MEMBRE' LIMIT 5;

-- Vérifier Club
SELECT 'Table Club:' as Status, COUNT(*) as total_clubs FROM Club;

-- Vérifier Evenement
SELECT 'Table Evenement:' as Status, COUNT(*) as total_events FROM Evenement;

-- Vérifier DemandeIntegration
SELECT 'Table DemandeIntegration:' as Status, COUNT(*) as total_demandes FROM DemandeIntegration;

-- Vérifier Participation
SELECT 'Table Participation:' as Status, COUNT(*) as total_participations FROM Participation;

-- =================================================================
-- Vérifier la table Notification (NOUVELLE)
-- =================================================================

SELECT 'Table Notification:' as Status;

-- Vérifier si la table existe
SELECT 
    CASE 
        WHEN COUNT(*) > 0 THEN '✓ Table Notification existe'
        ELSE '✗ Table Notification manquante - Exécutez add_notification_table.sql'
    END as status
FROM information_schema.tables 
WHERE table_schema = 'chess_club_db' AND table_name = 'Notification';

-- Si la table existe, montrer sa structure
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT
FROM information_schema.columns
WHERE table_schema = 'chess_club_db' AND table_name = 'Notification'
ORDER BY ORDINAL_POSITION;

-- Compter les notifications
SELECT 
    CASE 
        WHEN COUNT(*) > 0 THEN COUNT(*)
        ELSE 0
    END as total_notifications
FROM Notification;

-- =================================================================
-- Vérifier les données de test
-- =================================================================

SELECT '=== COMPTEURS GENERAUX ===' as Info;

-- Membres
SELECT COUNT(*) as nombre_membres FROM Utilisateur WHERE role = 'MEMBRE';

-- Membres avec club
SELECT COUNT(*) as membres_avec_club FROM Utilisateur WHERE role = 'MEMBRE' AND club_id IS NOT NULL;

-- Membres sans club
SELECT COUNT(*) as membres_sans_club FROM Utilisateur WHERE role = 'MEMBRE' AND club_id IS NULL;

-- Événements planifiés
SELECT COUNT(*) as evenements_planifies FROM Evenement WHERE statut = 'PLANIFIE';

-- Demandes en attente
SELECT COUNT(*) as demandes_en_attente FROM DemandeIntegration WHERE statut = 'EN_ATTENTE';

-- =================================================================
-- Créer des données de test (optionnel)
-- =================================================================

-- Pour insérer un membre de test si besoin :
/*
INSERT INTO Utilisateur (nom, prenom, email, motDePasse, cin, role) 
VALUES (
    'Test',
    'Membre',
    'test.membre@example.com',
    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', -- motdepasse
    'T123456',
    'MEMBRE'
);
*/

-- Pour créer une notification de test :
/*
INSERT INTO Notification (message, type, dateCreation, lu, membre_id) 
SELECT 
    'Test notification - Un nouvel événement a été ajouté',
    'EVENT_ADDED',
    CURDATE(),
    false,
    id
FROM Utilisateur 
WHERE role = 'MEMBRE' 
LIMIT 1;
*/

-- =================================================================
-- Requêtes utiles pour le débogage
-- =================================================================

-- Voir toutes les notifications
SELECT 
    n.id,
    n.message,
    n.type,
    n.dateCreation,
    n.lu,
    u.nom,
    u.prenom
FROM Notification n
JOIN Utilisateur u ON n.membre_id = u.id
ORDER BY n.dateCreation DESC;

-- Voir les notifications non lues
SELECT 
    n.id,
    n.message,
    n.type,
    n.dateCreation,
    u.nom,
    u.prenom
FROM Notification n
JOIN Utilisateur u ON n.membre_id = u.id
WHERE n.lu = false
ORDER BY n.dateCreation DESC;

-- Compter les notifications par type
SELECT 
    type,
    COUNT(*) as nombre,
    SUM(CASE WHEN lu = false THEN 1 ELSE 0 END) as non_lues
FROM Notification
GROUP BY type;

-- Voir les membres et leurs notifications
SELECT 
    u.nom,
    u.prenom,
    COUNT(n.id) as total_notifications,
    SUM(CASE WHEN n.lu = false THEN 1 ELSE 0 END) as non_lues
FROM Utilisateur u
LEFT JOIN Notification n ON u.id = n.membre_id
WHERE u.role = 'MEMBRE'
GROUP BY u.id, u.nom, u.prenom
ORDER BY non_lues DESC;




