<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.projet.jee.model.Evenement" %>
<%@ page import="com.projet.jee.model.DemandeCreationClub" %>
<%@ page import="com.projet.jee.model.DemandeIntegration" %>
<%@ page import="com.projet.jee.model.Club" %>
<%@ page import="com.projet.jee.model.Utilisateur" %>
<%
    Utilisateur currentUser = (Utilisateur) session.getAttribute("currentUser");
    if (currentUser == null || !"PRESIDENT".equals(currentUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    List<Evenement> evenements = (List<Evenement>) request.getAttribute("evenements");
    List<DemandeCreationClub> demandes = (List<DemandeCreationClub>) request.getAttribute("demandes");
    List<DemandeIntegration> demandesIntegration = (List<DemandeIntegration>) request.getAttribute("demandesIntegration");
    Club presidentClub = (Club) request.getAttribute("presidentClub");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Président - Gestion des Clubs</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .president-dashboard {
            min-height: 100vh;
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            padding: 20px;
        }

        .dashboard-header {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header-title {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .header-title i {
            font-size: 2.5rem;
            color: #8B4513;
        }

        .header-title h1 {
            color: #1e3c72;
            font-size: 2rem;
            margin: 0;
        }

        .header-actions {
            display: flex;
            gap: 10px;
        }

        .btn {
            padding: 12px 25px;
            border-radius: 8px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            font-weight: 600;
            transition: all 0.3s;
            border: none;
            cursor: pointer;
            font-size: 1rem;
        }

        .btn-primary {
            background: #4CAF50;
            color: white;
        }

        .btn-primary:hover {
            background: #45a049;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(76, 175, 80, 0.3);
        }

        .btn-secondary {
            background: #8B4513;
            color: white;
        }

        .btn-secondary:hover {
            background: #6d3410;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(139, 69, 19, 0.3);
        }

        .btn-danger {
            background: #dc3545;
            color: white;
        }

        .btn-danger:hover {
            background: #c82333;
        }

        .dashboard-container {
            max-width: 1400px;
            margin: 0 auto;
        }

        .section {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
        }

        .section-title {
            font-size: 1.5rem;
            color: #1e3c72;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .events-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        .event-card {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            border-left: 4px solid #4CAF50;
            transition: all 0.3s;
        }

        .event-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .event-title {
            font-size: 1.2rem;
            font-weight: bold;
            color: #1e3c72;
            margin-bottom: 10px;
        }

        .event-info {
            display: flex;
            flex-direction: column;
            gap: 8px;
            color: #666;
            font-size: 0.9rem;
        }

        .event-info i {
            width: 20px;
            color: #8B4513;
        }

        .event-status {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 15px;
            font-size: 0.85rem;
            font-weight: 600;
            color: white;
            margin-top: 10px;
        }

        .event-status.PLANIFIE {
            background: #4CAF50;
        }

        .event-status.ANNULE {
            background: #dc3545;
        }

        .event-status.TERMINE {
            background: #6c757d;
        }

        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            animation: fadeIn 0.3s;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        .modal-content {
            background-color: white;
            margin: 5% auto;
            padding: 30px;
            border-radius: 15px;
            width: 90%;
            max-width: 600px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3);
            animation: slideIn 0.3s;
        }

        @keyframes slideIn {
            from {
                transform: translateY(-50px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
        }

        .modal-header h2 {
            color: #1e3c72;
            margin: 0;
        }

        .close {
            color: #aaa;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
            transition: color 0.3s;
        }

        .close:hover {
            color: #000;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 600;
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 1rem;
            transition: border-color 0.3s;
        }

        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #4CAF50;
        }

        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }

        .message {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .message-success {
            background: #d4edda;
            color: #155724;
            border-left: 4px solid #28a745;
        }

        .message-error {
            background: #f8d7da;
            color: #721c24;
            border-left: 4px solid #dc3545;
        }

        .empty-message {
            text-align: center;
            padding: 40px;
            color: #999;
        }

        .empty-message i {
            font-size: 3rem;
            margin-bottom: 15px;
            color: #ccc;
        }

        .demandes-list {
            margin-top: 20px;
        }

        .demande-item {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 15px;
            border-left: 4px solid #ffc107;
        }

        .demande-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 10px;
        }

        .demande-title {
            font-size: 1.1rem;
            font-weight: bold;
            color: #1e3c72;
        }

        .demande-status {
            padding: 4px 12px;
            border-radius: 15px;
            font-size: 0.85rem;
            font-weight: 600;
        }

        .status-EN_ATTENTE {
            background: #ffc107;
            color: #000;
        }

        .status-ACCEPTEE {
            background: #28a745;
            color: white;
        }

        .status-REFUSEE {
            background: #dc3545;
            color: white;
        }

        .user-welcome {
            color: #666;
            font-size: 1rem;
        }

        .member-info {
            display: flex;
            flex-direction: column;
            gap: 5px;
            margin-bottom: 10px;
        }

        .member-info strong {
            color: #1e3c72;
        }

        .demande-integration-item {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 15px;
            border-left: 4px solid #4CAF50;
            display: flex;
            justify-content: space-between;
            align-items: start;
        }

        .demande-integration-info {
            flex: 1;
        }

        .demande-integration-actions {
            display: flex;
            gap: 10px;
        }

        .btn-accept {
            background: #4CAF50;
            color: white;
            padding: 8px 16px;
            border-radius: 6px;
            border: none;
            cursor: pointer;
            font-weight: 600;
            font-size: 0.9rem;
            transition: all 0.3s;
        }

        .btn-accept:hover {
            background: #45a049;
            transform: translateY(-2px);
            box-shadow: 0 3px 10px rgba(76, 175, 80, 0.3);
        }

        .btn-reject {
            background: #dc3545;
            color: white;
            padding: 8px 16px;
            border-radius: 6px;
            border: none;
            cursor: pointer;
            font-weight: 600;
            font-size: 0.9rem;
            transition: all 0.3s;
        }

        .btn-reject:hover {
            background: #c82333;
            transform: translateY(-2px);
            box-shadow: 0 3px 10px rgba(220, 53, 69, 0.3);
        }

        .club-badge {
            background: #4CAF50;
            color: white;
            padding: 8px 16px;
            border-radius: 8px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <div class="president-dashboard">
        <div class="dashboard-header">
            <div class="header-title">
                <i class="fas fa-crown"></i>
                <div>
                    <h1>Dashboard Président</h1>
                    <p class="user-welcome">Bienvenue, <%= currentUser.getPrenom() %> <%= currentUser.getNom() %></p>
                </div>
            </div>
            <div class="header-actions">
                <button class="btn btn-primary" onclick="openModal()">
                    <i class="fas fa-plus-circle"></i>
                    Créer un Club
                </button>
                <a href="<%= request.getContextPath() %>/jsp/auth/profile.jsp" class="btn btn-secondary">
                    <i class="fas fa-user"></i>
                    Mon Profil
                </a>
                <a href="<%= request.getContextPath() %>/logout" class="btn btn-danger">
                    <i class="fas fa-sign-out-alt"></i>
                    Déconnexion
                </a>
            </div>
        </div>

        <div class="dashboard-container">
            <!-- Messages -->
            <% if (session.getAttribute("successMessage") != null) { %>
                <div class="message message-success">
                    <i class="fas fa-check-circle"></i>
                    <%= session.getAttribute("successMessage") %>
                </div>
                <% session.removeAttribute("successMessage"); %>
            <% } %>
            
            <% if (session.getAttribute("errorMessage") != null) { %>
                <div class="message message-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <%= session.getAttribute("errorMessage") %>
                </div>
                <% session.removeAttribute("errorMessage"); %>
            <% } %>

            <!-- Section Événements -->
            <div class="section">
                <div class="section-header">
                    <h2 class="section-title">
                        <i class="fas fa-calendar-alt"></i>
                        Événements de la Fédération
                    </h2>
                </div>
                
                <% if (evenements != null && !evenements.isEmpty()) { %>
                    <div class="events-grid">
                        <% for (Evenement evt : evenements) { %>
                            <div class="event-card">
                                <div class="event-title"><%= evt.getTitre() %></div>
                                <div class="event-info">
                                    <div><i class="fas fa-map-marker-alt"></i> <%= evt.getLieu() != null ? evt.getLieu() : "Lieu non précisé" %></div>
                                    <div><i class="fas fa-calendar"></i> <%= evt.getDateDebut() %> au <%= evt.getDateFin() %></div>
                                    <% if (evt.getDescription() != null && !evt.getDescription().isEmpty()) { %>
                                        <div><i class="fas fa-info-circle"></i> <%= evt.getDescription() %></div>
                                    <% } %>
                                </div>
                                <span class="event-status <%= evt.getStatut() %>"><%= evt.getStatut() %></span>
                            </div>
                        <% } %>
                    </div>
                <% } else { %>
                    <div class="empty-message">
                        <i class="fas fa-calendar-times"></i>
                        <p>Aucun événement planifié pour le moment</p>
                    </div>
                <% } %>
            </div>

            <!-- Section Mes Demandes -->
            <div class="section">
                <div class="section-header">
                    <h2 class="section-title">
                        <i class="fas fa-folder-open"></i>
                        Mes Demandes de Création de Club
                    </h2>
                </div>
                
                <% if (demandes != null && !demandes.isEmpty()) { %>
                    <div class="demandes-list">
                        <% for (DemandeCreationClub demande : demandes) { %>
                            <div class="demande-item">
                                <div class="demande-header">
                                    <div class="demande-title"><%= demande.getNomClub() %></div>
                                    <span class="demande-status status-<%= demande.getStatut() %>"><%= demande.getStatut() %></span>
                                </div>
                                <p style="color: #666; margin: 10px 0;">
                                    <%= demande.getDescription() != null && !demande.getDescription().isEmpty() ? demande.getDescription() : "Aucune description" %>
                                </p>
                                <small style="color: #999;">
                                    <i class="fas fa-clock"></i> Demande envoyée le <%= demande.getDateDemande() %>
                                </small>
                            </div>
                        <% } %>
                    </div>
                <% } else { %>
                    <div class="empty-message">
                        <i class="fas fa-inbox"></i>
                        <p>Vous n'avez pas encore fait de demande de création de club</p>
                        <p style="font-size: 0.9rem; color: #bbb;">Cliquez sur "Créer un Club" pour commencer</p>
                    </div>
                <% } %>
            </div>

            <!-- Section Demandes d'Intégration -->
            <% if (presidentClub != null) { %>
            <div class="section">
                <div class="section-header">
                    <h2 class="section-title">
                        <i class="fas fa-users"></i>
                        Demandes d'Intégration au Club
                    </h2>
                </div>
                
                <div class="club-badge">
                    <i class="fas fa-chess-knight"></i>
                    <%= presidentClub.getNom() %>
                </div>
                
                <% if (demandesIntegration != null && !demandesIntegration.isEmpty()) { %>
                    <div class="demandes-list">
                        <% for (DemandeIntegration demandeInt : demandesIntegration) { %>
                            <div class="demande-integration-item">
                                <div class="demande-integration-info">
                                    <div class="member-info">
                                        <div><strong><i class="fas fa-user"></i> <%= demandeInt.getMembrePrenom() %> <%= demandeInt.getMembreNom() %></strong></div>
                                        <div style="color: #666;"><i class="fas fa-envelope"></i> <%= demandeInt.getMembreEmail() %></div>
                                        <div style="color: #999; font-size: 0.9rem;"><i class="fas fa-clock"></i> Demande envoyée le <%= demandeInt.getDateDemande() %></div>
                                    </div>
                                    <span class="demande-status status-<%= demandeInt.getStatut() %>"><%= demandeInt.getStatut() %></span>
                                </div>
                                
                                <% if ("EN_ATTENTE".equals(demandeInt.getStatut())) { %>
                                <div class="demande-integration-actions">
                                    <form action="<%= request.getContextPath() %>/president/accepter-demande" method="post" style="margin: 0;">
                                        <input type="hidden" name="demandeId" value="<%= demandeInt.getId() %>">
                                        <button type="submit" class="btn-accept">
                                            <i class="fas fa-check"></i> Accepter
                                        </button>
                                    </form>
                                    <form action="<%= request.getContextPath() %>/president/refuser-demande" method="post" style="margin: 0;">
                                        <input type="hidden" name="demandeId" value="<%= demandeInt.getId() %>">
                                        <button type="submit" class="btn-reject">
                                            <i class="fas fa-times"></i> Refuser
                                        </button>
                                    </form>
                                </div>
                                <% } %>
                            </div>
                        <% } %>
                    </div>
                <% } else { %>
                    <div class="empty-message">
                        <i class="fas fa-user-plus"></i>
                        <p>Aucune demande d'intégration pour le moment</p>
                        <p style="font-size: 0.9rem; color: #bbb;">Les membres intéressés pourront rejoindre votre club via le système de demandes</p>
                    </div>
                <% } %>
            </div>
            <% } %>
        </div>
    </div>

    <!-- Modal Créer un Club -->
    <div id="createClubModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2><i class="fas fa-plus-circle"></i> Créer un Nouveau Club</h2>
                <span class="close" onclick="closeModal()">&times;</span>
            </div>
            <form action="<%= request.getContextPath() %>/president/creer-club" method="post">
                <div class="form-group">
                    <label for="nomClub">
                        <i class="fas fa-chess-knight"></i> Nom du Club *
                    </label>
                    <input type="text" id="nomClub" name="nomClub" required 
                           placeholder="Exemple: Club d'Échecs Royal">
                </div>
                <div class="form-group">
                    <label for="description">
                        <i class="fas fa-align-left"></i> Description
                    </label>
                    <textarea id="description" name="description" 
                              placeholder="Décrivez brièvement votre club, ses objectifs, etc."></textarea>
                </div>
                <div style="display: flex; gap: 10px; justify-content: flex-end;">
                    <button type="button" class="btn btn-secondary" onclick="closeModal()">
                        <i class="fas fa-times"></i> Annuler
                    </button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-paper-plane"></i> Envoyer la Demande
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function openModal() {
            document.getElementById('createClubModal').style.display = 'block';
        }

        function closeModal() {
            document.getElementById('createClubModal').style.display = 'none';
        }

        // Fermer le modal si on clique en dehors
        window.onclick = function(event) {
            const modal = document.getElementById('createClubModal');
            if (event.target == modal) {
                closeModal();
            }
        }
    </script>
</body>
</html>

