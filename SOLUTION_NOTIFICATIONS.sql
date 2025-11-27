-- =================================================================
-- SOLUTION COMPLÈTE POUR LES NOTIFICATIONS
-- =================================================================

USE chess_club_db;

-- =================================================================
-- ÉTAPE 1 : CRÉER LA TABLE SI ELLE N'EXISTE PAS
-- =================================================================

CREATE TABLE IF NOT EXISTS Notification (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  message TEXT NOT NULL,
  type VARCHAR(50) NOT NULL,
  dateCreation DATE NOT NULL,
  lu BOOLEAN DEFAULT FALSE,
  membre_id BIGINT NOT NULL,
  FOREIGN KEY (membre_id) REFERENCES Utilisateur(id) ON DELETE CASCADE,
  INDEX idx_membre_date (membre_id, dateCreation)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- =================================================================
-- ÉTAPE 2 : VÉRIFIER QUE LES DONNÉES EXISTENT
-- =================================================================

-- Voir les présidents
SELECT '=== PRÉSIDENTS DANS LA BASE ===' as Info;
SELECT id, nom, prenom, email FROM Utilisateur WHERE role = 'PRESIDENT';

-- Voir les membres
SELECT '=== MEMBRES DANS LA BASE ===' as Info;
SELECT id, nom, prenom, email, club_id FROM Utilisateur WHERE role = 'MEMBRE';

-- =================================================================
-- ÉTAPE 3 : CRÉER DES NOTIFICATIONS DE TEST
-- =================================================================

-- Notification de test pour un président (si existe)
INSERT INTO Notification (message, type, dateCreation, lu, membre_id) 
SELECT 
    'Test : Nouvel événement créé par la fédération',
    'EVENT_ADDED',
    CURDATE(),
    false,
    id
FROM Utilisateur 
WHERE role = 'PRESIDENT' 
LIMIT 1
ON DUPLICATE KEY UPDATE id=id;

-- Notification de test pour un membre (si existe)
INSERT INTO Notification (message, type, dateCreation, lu, membre_id) 
SELECT 
    'Test : Nouvel événement créé par la fédération',
    'EVENT_ADDED',
    CURDATE(),
    false,
    id
FROM Utilisateur 
WHERE role = 'MEMBRE' 
LIMIT 1
ON DUPLICATE KEY UPDATE id=id;

-- =================================================================
-- ÉTAPE 4 : VÉRIFIER LES NOTIFICATIONS CRÉÉES
-- =================================================================

SELECT '=== NOTIFICATIONS CRÉÉES ===' as Info;
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
ORDER BY n.dateCreation DESC;

-- =================================================================
-- ÉTAPE 5 : COMPTER LES NOTIFICATIONS NON LUES
-- =================================================================

SELECT '=== COMPTEURS PAR UTILISATEUR ===' as Info;
SELECT 
    u.id,
    u.nom,
    u.prenom,
    u.role,
    COUNT(n.id) as total_notifications,
    SUM(CASE WHEN n.lu = false THEN 1 ELSE 0 END) as non_lues
FROM Utilisateur u
LEFT JOIN Notification n ON u.id = n.membre_id
WHERE u.role IN ('PRESIDENT', 'MEMBRE')
GROUP BY u.id, u.nom, u.prenom, u.role
ORDER BY u.role, non_lues DESC;




