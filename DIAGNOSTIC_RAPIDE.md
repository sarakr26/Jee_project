# 🚨 Diagnostic Rapide - Notifications Ne Fonctionnent Pas

## ⚡ Diagnostic Express

### Étape 1 : Vérifier la Table Notification

**Dans MySQL/phpMyAdmin, exécutez :**

```sql
USE chess_club_db;
SHOW TABLES LIKE 'Notification';
```

**Si le résultat est vide**, exécutez :
```sql
-- Copier le contenu de add_notification_table.sql et l'exécuter
```

### Étape 2 : Vérifier les Présidents

```sql
SELECT COUNT(*) as nb_presidents FROM Utilisateur WHERE role = 'PRESIDENT';
SELECT id, nom, prenom FROM Utilisateur WHERE role = 'PRESIDENT';
```

**Si le résultat est 0**, il n'y a pas de comptes présidents dans la base.

### Étape 3 : Tester la Création Manuelle

```sql
-- Créer une notification de test
INSERT INTO Notification (message, type, dateCreation, lu, membre_id) 
SELECT 
    'Test notification',
    'EVENT_ADDED',
    CURDATE(),
    false,
    id
FROM Utilisateur 
WHERE role = 'PRESIDENT' 
LIMIT 1;

-- Vérifier que ça a fonctionné
SELECT * FROM Notification WHERE type = 'EVENT_ADDED';
```

**Si cette insertion échoue**, il y a un problème de structure.

## 🔍 Vérifications Complètes

Exécutez le fichier `DIAGNOSTIC_NOTIFICATIONS.sql` pour un diagnostic complet.

## 📋 Checklist

- [ ] Table Notification existe ?
- [ ] Au moins un compte PRÉSIDENT existe ?
- [ ] Au moins un compte MEMBRE existe ?
- [ ] Insertion manuelle fonctionne ?
- [ ] Tomcat redémarré après modifications ?
- [ ] Aucune erreur dans les logs Tomcat ?

## 🐛 Erreurs Communes

### Erreur : "Table doesn't exist"
**Solution** : Créer la table avec `add_notification_table.sql`

### Erreur : "No presidents found"
**Solution** : Créer au moins un compte avec `role='PRESIDENT'`

### Erreur : "Foreign key constraint"
**Solution** : Vérifier que les IDs utilisateur existent

## 📝 Rapporter le Problème

Si ça ne marche toujours pas, envoyez :
1. Le résultat du script de diagnostic
2. Les logs Tomcat après création d'un événement
3. L'erreur exacte affichée




