-- VERIFICATION RAPIDE DES NOTIFICATIONS
-- Exécutez ce script pour voir ce qui ne va pas

USE chess_club_db;

-- 1. La table existe-t-elle ?
SELECT '1. Table Notification' as Vérification;
SHOW TABLES LIKE 'Notification';

-- 2. Présidents dans la base ?
SELECT '2. Présidents' as Vérification;
SELECT COUNT(*) as nb_presidents FROM Utilisateur WHERE role = 'PRESIDENT';

-- 3. Membres dans la base ?
SELECT '3. Membres' as Vérification;
SELECT COUNT(*) as nb_membres FROM Utilisateur WHERE role = 'MEMBRE';

-- 4. Notifications existantes ?
SELECT '4. Notifications' as Vérification;
SELECT COUNT(*) as total FROM Notification;

-- 5. Notifications des présidents ?
SELECT '5. Notif Présidents' as Vérification;
SELECT COUNT(*) as notif_presidents 
FROM Notification n
JOIN Utilisateur u ON n.membre_id = u.id
WHERE u.role = 'PRESIDENT';




