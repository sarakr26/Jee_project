-- =================================================================
-- Script de diagnostic pour les notifications
-- Exécutez ce script pour identifier le problème
-- =================================================================

USE chess_club_db;

-- =================================================================
-- VÉRIFICATIONS DE BASE
-- =================================================================

-- 1. La table Notification existe-t-elle ?
SELECT '=== VÉRIFICATION TABLE ===' as Info;
SELECT 
    CASE 
        WHEN COUNT(*) > 0 THEN '✓ Table Notification existe'
        ELSE '✗ Table Notification MANQUANTE'
    END as status
FROM information_schema.tables 
WHERE table_schema = 'chess_club_db' AND table_name = 'Notification';

-- 2. Combien de notifications existent ?
SELECT '=== NOMBRE DE NOTIFICATIONS ===' as Info;
SELECT COUNT(*) as total_notifications FROM Notification;

-- 3. Y a-t-il des présidents ?
SELECT '=== PRÉSIDENTS ===' as Info;
SELECT COUNT(*) as nb_presidents FROM Utilisateur WHERE role = 'PRESIDENT';
SELECT id, nom, prenom, email FROM Utilisateur WHERE role = 'PRESIDENT';

-- 4. Y a-t-il des membres ?
SELECT '=== MEMBRES ===' as Info;
SELECT COUNT(*) as nb_membres FROM Utilisateur WHERE role = 'MEMBRE';
SELECT id, nom, prenom, email, club_id FROM Utilisateur WHERE role = 'MEMBRE' LIMIT 5;

-- =================================================================
-- VÉRIFICATIONS DES NOTIFICATIONS
-- =================================================================

-- 5. Voir toutes les notifications récentes
SELECT '=== NOTIFICATIONS RÉCENTES ===' as Info;
SELECT 
    n.id,
    n.message,
    n.type,
    n.lu,
    n.dateCreation,
    u.nom,
    u.prenom,
    u.role
FROM Notification n
JOIN Utilisateur u ON n.membre_id = u.id
ORDER BY n.dateCreation DESC
LIMIT 10;

-- 6. Notifications des présidents
SELECT '=== NOTIFICATIONS PRÉSIDENTS ===' as Info;
SELECT 
    n.id,
    n.message,
    n.type,
    n.lu,
    n.dateCreation,
    u.nom,
    u.prenom
FROM Notification n
JOIN Utilisateur u ON n.membre_id = u.id
WHERE u.role = 'PRESIDENT'
ORDER BY n.dateCreation DESC;

-- 7. Notifications des membres
SELECT '=== NOTIFICATIONS MEMBRES ===' as Info;
SELECT 
    n.id,
    n.message,
    n.type,
    n.lu,
    n.dateCreation,
    u.nom,
    u.prenom
FROM Notification n
JOIN Utilisateur u ON n.membre_id = u.id
WHERE u.role = 'MEMBRE'
ORDER BY n.dateCreation DESC;

-- =================================================================
-- VÉRIFICATIONS PAR TYPE
-- =================================================================

-- 8. Compter par type
SELECT '=== COMPTAGE PAR TYPE ===' as Info;
SELECT 
    type,
    COUNT(*) as total,
    SUM(CASE WHEN lu = false THEN 1 ELSE 0 END) as non_lues
FROM Notification
GROUP BY type;

-- =================================================================
-- TEST MANUEL
-- =================================================================

-- 9. Test : Créer une notification manuellement pour un président
-- DÉCOMMENTEZ ces lignes pour tester manuellement
/*
SELECT '=== TEST MANUEL ===' as Info;

-- Trouver un président
SELECT @president_id := id FROM Utilisateur WHERE role = 'PRESIDENT' LIMIT 1;
SELECT CONCAT('ID président trouvé: ', @president_id) as Info;

-- Créer une notification de test
INSERT INTO Notification (message, type, dateCreation, lu, membre_id) 
VALUES (
    'Notification de test - Événement créé',
    'EVENT_ADDED',
    CURDATE(),
    false,
    @president_id
);

-- Vérifier
SELECT * FROM Notification ORDER BY id DESC LIMIT 1;
*/

-- =================================================================
-- DIAGNOSTIC DES ERREURS POSSIBLES
-- =================================================================

-- 10. Vérifier les contraintes de clé étrangère
SELECT '=== VÉRIFICATION CLÉS ÉTRANGÈRES ===' as Info;
SELECT 
    TABLE_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'chess_club_db' 
AND TABLE_NAME = 'Notification'
AND REFERENCED_TABLE_NAME IS NOT NULL;

-- 11. Vérifier les rôles
SELECT '=== RÉPARTITION DES RÔLES ===' as Info;
SELECT 
    role,
    COUNT(*) as nb_utilisateurs
FROM Utilisateur
GROUP BY role;

-- =================================================================
-- INSTRUCTIONS
-- =================================================================

SELECT '=== INSTRUCTIONS ===' as Info;
SELECT '
Pour diagnostiquer le problème :

1. Exécutez ce script SQL complet
2. Regardez les résultats de chaque section
3. Vérifiez :
   - Si la table Notification existe
   - S''il y a des présidents/membres dans la base
   - Si des notifications existent
   - S''il y a des erreurs de contrainte

4. Pour créer la table si elle n''existe pas :
   Voir: add_notification_table.sql

5. Pour tester manuellement :
   Décommentez la section "TEST MANUEL" ci-dessus
' as instructions;




