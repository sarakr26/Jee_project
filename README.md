# Gestion des Clubs d'Échecs - Projet JEE

## 📋 Description du Projet
Application web de gestion des clubs d'échecs permettant aux présidents de club, membres et administrateurs fédéraux de gérer les clubs, les membres et les compétitions d'échecs.

## 🚀 Prérequis

### Configuration Système
- Java JDK 17 ou supérieur
- Apache Maven 3.8.6 ou supérieur
- MySQL 8.0 ou supérieur
- Apache Tomcat 10.0 ou supérieur
- Navigateur web moderne (Chrome, Firefox, Edge)

### Configuration de la Base de Données
1. Créer une base de données MySQL nommée `chess_club_db`
2. Exécuter le script SQL d'initialisation :
   ```bash
   mysql -u [username] -p chess_club_db < db_init.sql
   ```
3. Importer les données de test :
   ```bash
   mysql -u [username] -p chess_club_db < data_test.sql
   ```

## 🛠 Installation

1. **Cloner le dépôt**
   ```bash
   git clone [URL_DU_DEPOT]
   cd Jee_project
   ```

2. **Configuration de la base de données**
   - Modifier les informations de connexion dans `src/main/resources/db.properties`
   ```properties
   db.url=jdbc:mysql://localhost:3306/chess_club_db?useSSL=false&serverTimezone=UTC
   db.username=votre_utilisateur
   db.password=votre_mot_de_passe
   ```

3. **Compiler le projet**
   ```bash
   mvn clean install
   ```

## 🚀 Démarrage de l'Application

1. **Déployer sur Tomcat**
   - Copier le fichier `target/GestionClubsChess-1.0-SNAPSHOT.war` dans le répertoire `webapps` de Tomcat
   - Démarrer le serveur Tomcat

2. **Accéder à l'application**
   - Ouvrir un navigateur et aller à l'adresse :
     ```
     http://localhost:8080/GestionClubsChess-1.0-SNAPSHOT/
     ```

## 👥 Comptes de Test

### Administrateur Fédéral
- **Email** : admin@federation.ma
- **Mot de passe** : admin123

### Président de Club
- **Email** : president@club1.ma
- **Mot de passe** : president123

### Membre
- **Email** : membre1@club1.ma
- **Mot de passe** : membre123

## 🎯 Fonctionnalités Principales

### 1. Gestion des Événements
- Création et gestion des tournois
- Inscription des participants
- Suivi des résultats

### 2. Validation des Créations de Clubs
- Soumission des demandes de création
- Validation/Rejet par l'administrateur
- Notification des décisions

### 3. Gestion des Membres
- Inscription des nouveaux membres
- Gestion des profils
- Suivi des performances

### 4. Sélection des Représentants
- Désignation des joueurs pour les compétitions
- Gestion des disponibilités

### 5. Gestion du Podium
- Saisie des résultats
- Classement automatique
- Génération de statistiques

## 📁 Structure du Projet

```
src/
├── main/
│   ├── java/
│   │   └── com/projet/jee/
│   │       ├── controllers/    # Contrôleurs
│   │       ├── dao/           # Accès aux données
│   │       ├── model/         # Modèles de données
│   │       └── util/          # Classes utilitaires
│   ├── resources/             # Fichiers de configuration
│   └── webapp/
│       ├── css/               # Feuilles de style
│       ├── js/                # Scripts JavaScript
│       ├── jsp/               # Vues JSP
│       └── WEB-INF/           # Configuration web
```

## 🔧 Dépendances Principales

- Java Servlet API 5.0.0
- JSTL 2.0.0
- MySQL Connector/J 8.0.28
- JUnit 5.8.2 (pour les tests)
- Bootstrap 5.2.0
- jQuery 3.6.0

## 🐛 Dépannage

### Problème de Connexion à la Base de Données
- Vérifier les identifiants dans `db.properties`
- S'assurer que le service MySQL est en cours d'exécution

### Erreurs de Déploiement
- Vérifier la version de Java (JDK 17 requise)
- S'assurer que le port 8080 n'est pas utilisé

## 📝 Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

## 👥 Auteurs

- [Votre Nom]
- [Nom du Membre 2]
- [Nom du Membre 3]
- [Nom du Membre 4]

## 📅 Dernière Mise à Jour

Novembre 2023
