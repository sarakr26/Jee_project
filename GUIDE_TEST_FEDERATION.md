# Guide de Test - Tableau de Bord Fédération

## Fonctionnalités Implémentées

### 1. Tableau de Bord Fédération
- **URL**: `/federation/dashboard`
- **Accès**: Utilisateurs avec le rôle "FEDERATION"
- **Fonctionnalités**:
  - Indicateurs clés (nombre de clubs actifs, demandes en attente, événements urgents/prochains)
  - Actions rapides (créer événement, rechercher club, valider demandes, gérer événements)
  - Liste des demandes à valider (création de clubs et intégration de membres)
  - Événements urgents (dans les 7 prochains jours)
  - Événements prochains (dans les 30 prochains jours)

### 2. Validation des Demandes
- **URL**: `/valider-demande`
- **Méthode**: POST
- **Paramètres**:
  - `type`: "creation" ou "integration"
  - `demandeId`: ID de la demande
  - `action`: "APPROUVE" ou "REFUSE"

## Comment Tester

### Étape 1: Préparer la Base de Données
1. Exécutez le script `test_federation_data.sql` dans votre base de données MySQL
2. Cela créera:
   - Un utilisateur FEDERATION (email: federation@chess.ma, mot de passe: test123)
   - Des demandes de création de club en attente
   - Des demandes d'intégration en attente
   - Des événements de test

### Étape 2: Démarrer l'Application
```bash
cd C:\Users\Administrateur\Desktop\JEE\Jee_project
mvn clean package tomcat7:run
```

### Étape 3: Tester la Connexion FEDERATION
1. Ouvrez http://localhost:8083/GestionClubsChess-1.0-SNAPSHOT/
2. Connectez-vous avec:
   - **Email**: federation@chess.ma
   - **Mot de passe**: test123
3. Vous devriez être redirigé automatiquement vers `/federation/dashboard`

### Étape 3.1: Vérifier que l'Application est Démarrée
- Attendez quelques secondes que Tomcat démarre complètement
- Vous devriez voir dans les logs: "Tomcat started on port(s): 8083"
- Si l'application n'est pas encore prête, attendez un peu plus

### Étape 4: Tester les Fonctionnalités

#### Indicateurs Clés
- Vérifiez que les compteurs affichent les bonnes valeurs
- Les indicateurs devraient montrer:
  - Nombre de clubs actifs
  - Nombre de demandes en attente
  - Nombre d'événements urgents
  - Nombre d'événements prochains

#### Actions Rapides
- Testez les boutons d'actions rapides
- Vérifiez que les liens fonctionnent correctement

#### Validation des Demandes
- Dans la section "Demandes à Valider":
  - Cliquez sur "Valider" pour une demande de création
  - Cliquez sur "Refuser" pour une demande d'intégration
  - Vérifiez que les actions se reflètent dans la base de données

#### Événements
- Vérifiez que les événements urgents s'affichent correctement
- Vérifiez que les événements prochains s'affichent correctement

## Structure des Fichiers Créés

### Backend (Java)
- `FederationDashboardServlet.java` - Servlet principal du tableau de bord
- `ValiderDemandeServlet.java` - Servlet pour valider/refuser les demandes
- Méthodes ajoutées dans `DemandeCreationClubDAO.java`
- Méthodes ajoutées dans `DemandeIntegrationDAO.java`
- Méthodes ajoutées dans `EvenementDAO.java`
- Méthodes ajoutées dans `ClubDAO.java`

### Frontend (JSP/CSS)
- `federation-dashboard.jsp` - Page principale du tableau de bord
- `federation-dashboard.css` - Styles spécifiques au tableau de bord

### Configuration
- `LoginServlet.java` - Mis à jour pour rediriger les FEDERATION vers le dashboard

## Notes Importantes

1. **Rôle FEDERATION**: Assurez-vous que l'utilisateur a bien le rôle "FEDERATION" dans la base de données
2. **Base de Données**: Le script de test crée des données fictives pour les tests
3. **Responsive**: Le tableau de bord est responsive et s'adapte aux différentes tailles d'écran
4. **Sécurité**: Seuls les utilisateurs avec le rôle FEDERATION peuvent accéder au dashboard

## Dépannage

### Problème de Connexion
- Vérifiez que MySQL est démarré
- Vérifiez les paramètres de connexion dans `DBConnection.java`

### Problème d'Affichage
- Vérifiez que les fichiers CSS sont bien chargés
- Vérifiez la console du navigateur pour les erreurs JavaScript

### Problème de Validation
- Vérifiez que les servlets sont bien déployés
- Vérifiez les logs de Tomcat pour les erreurs

## Améliorations Futures

1. **Notifications en temps réel** avec WebSockets
2. **Graphiques et statistiques** avancées
3. **Export des données** en PDF/Excel
4. **Système de notifications** par email
5. **Audit trail** des actions de validation
