# 🔧 Instructions d'Installation - Base de Données

## Fichiers SQL Créés

### 1. `add_notification_table.sql` (Original)
Script simple pour créer la table Notification

### 2. `add_all_notification_tables.sql` (Recommandé)
Script complet avec :
- Création de la table Notification
- Instructions de test
- Requêtes utiles
- Exemples d'utilisation

### 3. `VERIFY_DATABASE_STRUCTURE.sql`
Script de vérification de toute la structure de la base de données

## 🚀 Installation Rapide

### Étape 1 : Créer la table Notification

**Option A : Via MySQL/MariaDB en ligne de commande**
```bash
mysql -u root -p chess_club_db < add_notification_table.sql
```

**Option B : Via phpMyAdmin ou DBClient**
1. Ouvrez phpMyAdmin ou votre client MySQL
2. Sélectionnez la base `chess_club_db`
3. Onglet "SQL"
4. Copiez-collez le contenu de `add_notification_table.sql`
5. Exécutez

**Option C : Via l'éditeur intégré**
1. Ouvrez `add_notification_table.sql`
2. Sélectionnez tout (Ctrl+A)
3. Exécutez dans votre client SQL

### Étape 2 : Vérifier que la table existe

Exécutez :
```sql
SHOW TABLES LIKE 'Notification';
```

Vous devriez voir :
```
+----------------------------+
| Tables_in_chess_club_db    |
+----------------------------+
| Notification               |
+----------------------------+
```

### Étape 3 : Redémarrer Tomcat

1. Arrêtez Tomcat
2. Redémarrez Tomcat
3. L'application devrait maintenant créer des notifications

## 📋 Structure de la Table Notification

```sql
CREATE TABLE Notification (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  message TEXT NOT NULL,
  type VARCHAR(50) NOT NULL,
  dateCreation DATE NOT NULL,
  lu BOOLEAN DEFAULT FALSE,
  membre_id BIGINT NOT NULL,
  FOREIGN KEY (membre_id) REFERENCES Utilisateur(id) ON DELETE CASCADE,
  INDEX idx_membre_date (membre_id, dateCreation)
);
```

## ✅ Tests

### Test 1 : Vérifier la table
```sql
SELECT * FROM Notification;
```

### Test 2 : Créer une notification de test
```sql
-- Trouver un membre
SELECT id, nom, prenom FROM Utilisateur WHERE role = 'MEMBRE' LIMIT 1;

-- Créer une notification de test
INSERT INTO Notification (message, type, dateCreation, lu, membre_id) 
VALUES (
    'Test notification',
    'EVENT_ADDED',
    CURDATE(),
    false,
    1  -- Remplacez par l'ID d'un membre
);

-- Vérifier
SELECT * FROM Notification WHERE lu = false;
```

### Test 3 : Tester via l'application
1. **Créer un événement** (Fédération ou Président)
   - Les notifications devraient être créées automatiquement

2. **Se connecter comme membre**
   - Le badge 🔔 devrait afficher le nombre de notifications
   - Cliquer sur "Notifications" pour voir les notifications

## 🐛 Dépannage

### Le badge ne s'affiche pas
1. Vérifiez que la table existe : `SHOW TABLES LIKE 'Notification';`
2. Vérifiez qu'il y a des membres : `SELECT COUNT(*) FROM Utilisateur WHERE role = 'MEMBRE';`
3. Vérifiez les logs Tomcat pour les erreurs

### Les notifications ne sont pas créées
1. Vérifiez les logs Tomcat (catalina.out)
2. Cherchez les erreurs SQL
3. Vérifiez que les membres existent

### Erreur : "Table doesn't exist"
```sql
-- Exécutez simplement
mysql -u root -p chess_club_db < add_notification_table.sql
```

### Erreur : "Column count doesn't match"
La table existe déjà mais avec une structure différente. Supprimez-la :
```sql
DROP TABLE Notification;
-- Puis recréez-la avec le script
```

## 📊 Requêtes Utiles

### Voir toutes les notifications
```sql
SELECT * FROM Notification ORDER BY dateCreation DESC;
```

### Compter les notifications non lues par membre
```sql
SELECT 
    u.nom, 
    u.prenom,
    COUNT(n.id) as non_lues
FROM Utilisateur u
LEFT JOIN Notification n ON u.id = n.membre_id AND n.lu = false
WHERE u.role = 'MEMBRE'
GROUP BY u.id, u.nom, u.prenom;
```

### Marquer toutes les notifications comme lues
```sql
UPDATE Notification SET lu = true WHERE lu = false;
```

### Supprimer les vieilles notifications (30 jours)
```sql
DELETE FROM Notification 
WHERE dateCreation < DATE_SUB(CURDATE(), INTERVAL 30 DAY);
```

## 🎯 Objectif

Après l'installation, quand :
- ✅ Un président accepte une demande de club → Notification créée
- ✅ La fédération crée un événement → Tous les membres reçoivent une notification
- ✅ Un président sélectionne des représentants → Les membres reçoivent une notification

## 📞 Support

Si vous rencontrez des problèmes :
1. Vérifiez que la table existe
2. Vérifiez les logs Tomcat
3. Testez une insertion manuelle (voir Test 2)
4. Vérifiez que les membres existent dans la base




