GESTION DES CLUBS D'ÉCHECS - GUIDE D'UTILISATION
============================================

1. PRÉSENTATION GÉNÉRALE
----------------------
Application web de gestion des clubs d'échecs développée dans le cadre du module JEE.

2. INSTALLATION ET CONFIGURATION
------------------------------
2.1 Prérequis
- Java JDK 17+
- MySQL 8.0+
- Apache Tomcat 10.0+
- Maven 3.8.6+
- WAMP/XAMPP (pour le serveur web et MySQL)

2.2 Configuration de l'environnement
1. Installer et démarrer WAMP/XAMPP
2. Démarrer les services Apache et MySQL
3. Démarrer le serveur Tomcat

2.3 Configuration de la base de données
1. Lancer phpMyAdmin via WAMP/XAMPP (http://localhost/phpmyadmin)
2. Créer une nouvelle base de données nommée 'chess_club_db'
3. Importer le script d'initialisation : db_init.sql
4. Importer les données de test : data_test.sql

2.4 Configuration de l'application
1. Modifier les informations de connexion dans :
   src/main/resources/db.properties
   ```
   db.url=jdbc:mysql://localhost:3306/chess_club_db?useSSL=false&serverTimezone=UTC
   db.username=root
   db.password=
   ```
   (Ajustez les identifiants selon votre configuration MySQL)

2.5 Configuration de l'Email (Obligatoire pour la vérification)
   - L'application nécessite une vérification par email pour activer les comptes
   - Pour le développement, vous pouvez utiliser un service comme Mailtrap ou votre propre SMTP
   - Configurer les paramètres d'email dans `src/main/resources/email.properties`
   - En mode développement, les liens de vérification s'affichent dans la console du serveur

   Exemple de configuration pour Mailtrap (dans email.properties) :
   ```
   mail.smtp.host=sandbox.smtp.mailtrap.io
   mail.smtp.port=2525
   mail.smtp.auth=true
   mail.smtp.starttls.enable=true
   mail.user=your_mailtrap_username
   mail.password=your_mailtrap_password
   ```

IMPORTANT : Pour les tests, utilisez des adresses email valides et accessibles. 
Un lien de vérification sera envoyé à l'adresse fournie lors de l'inscription.
Le compte ne sera actif qu'après avoir cliqué sur ce lien de vérification.

3. LANCEMENT DE L'APPLICATION
---------------------------
1. Compiler le projet :
   ```bash
   mvn clean install
   ```
2. Déployer le fichier .war généré dans le dossier webapps de Tomcat
3. Démarrer le serveur Tomcat
4. Lancer l'application avec la commande :
   ```bash
   mvn tomcat7:run
   ```
5. Accéder à : http://localhost:8080/GestionClubsChess-1.0-SNAPSHOT/

4. GUIDE DE TEST
----------------

4.1 Création d'un nouveau club (en tant que membre)
1. Connectez-vous en tant que membre (membre1@club1.ma / membre123)
2. Accédez à la section "Créer un club"
3. Remplissez le formulaire avec les informations du club
4. Soumettez la demande

4.2 Validation du club (en tant qu'administrateur fédéral)
1. Déconnectez-vous et connectez-vous en tant qu'administrateur (admin@federation.ma / admin123)
2. Allez dans la section "Demandes de clubs"
3. Trouvez la demande du nouveau club
4. Cliquez sur "Valider" pour approuver le club

4.3 Rejoindre le club (en tant que membre)
1. Reconnectez-vous en tant que membre
2. Allez dans la section "Rejoindre un club"
3. Sélectionnez le club que vous venez de créer
4. Cliquez sur "Rejoindre"

4.4 Gestion des membres (en tant que président)
1. Connectez-vous en tant que président (president@club1.ma / president123)
2. Allez dans la section "Gestion des membres"
3. Approuvez la demande d'adhésion du membre
4. Vous pouvez maintenant gérer les rôles et les permissions des membres

4.5 Création d'un événement
1. En tant que président, allez dans "Gestion des événements"
2. Cliquez sur "Créer un événement"
3. Remplissez les détails de l'événement
4. Enregistrez l'événement

4.6 Inscription à un événement (en tant que membre)
1. Connectez-vous en tant que membre
2. Allez dans la section "Événements à venir"
3. Trouvez l'événement créé
4. Cliquez sur "S'inscrire"

5. FONCTIONNALITÉS PRINCIPALES
---------------------------

5.1 Tableau de Bord Administrateur
- Validation des demandes de création de clubs
- Gestion des utilisateurs et des rôles
- Supervision des événements et compétitions
- Génération de rapports

5.2 Tableau de Bord Président
- Gestion complète des membres du club
- Création et gestion des événements
- Sélection des représentants pour les compétitions
- Consultation des statistiques et performances
- Gestion des inscriptions aux événements

5.3 Espace Membre
- Consultation du calendrier des événements
- Inscription aux compétitions
- Suivi des résultats et classements
- Gestion du profil personnel
- Communication avec les autres membres

5. FONCTIONNALITÉS CLÉS
----------------------

5.1 Gestion des Événements
- Création et modification d'événements
- Inscription des participants
- Gestion des résultats

5.2 Validation des Clubs
- Soumission des demandes
- Traitement par l'administrateur
- Notification des décisions

5.3 Gestion des Membres
- Ajout/Modification des profils
- Attribution des rôles
- Suivi des performances

5.4 Sélection des Représentants
- Désignation des joueurs
- Gestion des disponibilités
- Validation des sélections

5.5 Gestion du Podium
- Saisie des résultats
- Classement automatique
- Génération de statistiques

6. DÉPANNAGE
-----------
- Erreur de connexion BD : Vérifier les paramètres dans db.properties
- Problème de déploiement : Vérifier la version de Java et les logs Tomcat
- Problème d'accès : Vérifier les rôles et permissions

7. CONTACT
---------
Pour toute question ou problème, veuillez contacter :
- [Votre Nom]
- [Votre Email]

Dernière mise à jour : Novembre 2023
