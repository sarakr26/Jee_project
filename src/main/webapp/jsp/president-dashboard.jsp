<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.projet.jee.model.Club" %>
<%@ page import="com.projet.jee.model.Evenement" %>
<%@ page import="com.projet.jee.model.DemandeCreationClub" %>
<%@ page import="com.projet.jee.model.Utilisateur" %>
<%
    Utilisateur currentUser = (Utilisateur) session.getAttribute("currentUser");
    if (currentUser == null || !"PRESIDENT".equals(currentUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    List<Evenement> evenements = (List<Evenement>) request.getAttribute("evenements");
    List<DemandeCreationClub> demandes = (List<DemandeCreationClub>) request.getAttribute("demandes");
    Club club = (Club) request.getAttribute("club");
    Integer memberCount = (Integer) request.getAttribute("memberCount");
    if (memberCount == null) memberCount = 0;
    Integer unreadCount = (Integer) request.getAttribute("unreadCount");
    if (unreadCount == null) unreadCount = 0;
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
            background: #4CAF50;
            color: white;
            margin-top: 10px;
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

        .demande-logo {
            width: 50px;
            height: 50px;
            border-radius: 6px;
            overflow: hidden;
            flex-shrink: 0;
            background: #f0f0f0;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 2px solid #e0e0e0;
        }

        .demande-logo img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .user-welcome {
            color: #666;
            font-size: 1rem;
        }

        .club-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 15px;
            padding: 30px;
            color: white;
            margin-bottom: 25px;
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.3);
        }

        .club-header {
            display: flex;
            align-items: center;
            gap: 20px;
            margin-bottom: 20px;
        }

        .club-logo-large {
            width: 100px;
            height: 100px;
            border-radius: 15px;
            overflow: hidden;
            background: white;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }

        .club-logo-large img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .club-info h2 {
            margin: 0 0 10px 0;
            font-size: 2rem;
        }

        .club-info p {
            margin: 0;
            opacity: 0.9;
        }

        .club-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 20px;
        }

        .stat-card {
            background: rgba(255, 255, 255, 0.2);
            padding: 15px;
            border-radius: 10px;
            text-align: center;
        }

        .stat-card i {
            font-size: 2rem;
            margin-bottom: 10px;
        }

        .stat-card .stat-value {
            font-size: 1.5rem;
            font-weight: bold;
            margin-bottom: 5px;
        }

        .stat-card .stat-label {
            font-size: 0.9rem;
            opacity: 0.9;
        }

        .club-actions {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }

        .btn-white {
            background: white;
            color: #667eea;
        }

        .btn-white:hover {
            background: #f0f0f0;
            color: #667eea;
        }

        /* Notification styles */
        .notification-btn {
            position: relative;
            background: #FF6B6B;
            color: white;
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

        .notification-btn:hover {
            background: #e55a5a;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 107, 107, 0.3);
        }

        .notification-badge {
            position: absolute;
            top: -8px;
            right: -8px;
            background: #FF4444;
            color: white;
            border-radius: 50%;
            width: 22px;
            height: 22px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.75rem;
            font-weight: bold;
        }

        .notification-modal {
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

        .notification-modal-content {
            background-color: white;
            margin: 10% auto;
            padding: 0;
            border-radius: 15px;
            width: 90%;
            max-width: 600px;
            max-height: 80vh;
            overflow: hidden;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3);
            animation: slideDown 0.3s;
        }

        .notification-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: white;
        }

        .notification-header h2 {
            margin: 0;
            font-size: 1.5rem;
        }

        .notification-body {
            padding: 20px;
            max-height: 500px;
            overflow-y: auto;
        }

        .notification-item {
            padding: 15px;
            border-bottom: 1px solid #eee;
            border-radius: 8px;
            margin-bottom: 10px;
            background: #f8f9fa;
            transition: all 0.3s;
        }

        .notification-item:hover {
            background: #e9ecef;
        }

        .notification-item.unread {
            background: #e3f2fd;
            border-left: 4px solid #2196F3;
        }

        .notification-item-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 5px;
        }

        .notification-item-type {
            font-size: 0.75rem;
            padding: 3px 10px;
            border-radius: 12px;
            background: #667eea;
            color: white;
            font-weight: 600;
        }

        .notification-item-date {
            font-size: 0.85rem;
            color: #999;
        }

        .notification-item-message {
            color: #333;
            line-height: 1.6;
        }

        .close-notification {
            background: transparent;
            border: none;
            color: white;
            font-size: 1.5rem;
            cursor: pointer;
            padding: 5px 15px;
            border-radius: 5px;
            transition: background 0.3s;
        }

        .close-notification:hover {
            background: rgba(255, 255, 255, 0.2);
        }

        .mark-all-read-btn {
            background: #4CAF50;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s;
        }

        .mark-all-read-btn:hover {
            background: #45a049;
        }

        .no-notifications {
            text-align: center;
            padding: 40px;
            color: #999;
        }

        .no-notifications i {
            font-size: 3rem;
            margin-bottom: 15px;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @keyframes slideDown {
            from { transform: translateY(-50px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
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
                <button class="notification-btn" onclick="openNotifications()">
                    <i class="fas fa-bell"></i>
                    Notifications
                    <% if (unreadCount > 0) { %>
                        <span class="notification-badge"><%= unreadCount %></span>
                    <% } %>
                </button>
                <% if (club == null) { %>
                    <button class="btn btn-primary" onclick="openModal()">
                        <i class="fas fa-plus-circle"></i>
                        Créer un Club
                    </button>
                <% } %>
                <a href="<%= request.getContextPath() %>/messages?action=inbox" class="btn btn-secondary">
                    <i class="fas fa-envelope"></i>
                    Messages
                </a>
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

        <!-- Notification Modal -->
        <div id="notificationModal" class="notification-modal">
            <div class="notification-modal-content">
                <div class="notification-header">
                    <h2><i class="fas fa-bell"></i> Mes Notifications</h2>
                    <div style="display: flex; gap: 10px; align-items: center;">
                        <button class="mark-all-read-btn" onclick="markAllAsRead()">
                            <i class="fas fa-check-double"></i> Tout marquer comme lu
                        </button>
                        <button class="close-notification" onclick="closeNotifications()">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                </div>
                <div class="notification-body" id="notificationList">
                    <div class="no-notifications">
                        <i class="fas fa-bell-slash"></i>
                        <p>Chargement des notifications...</p>
                    </div>
                </div>
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

            <!-- Section Mon Club -->
            <% if (club != null) { %>
                <div class="club-card">
                    <div class="club-header">
                        <% if (club.getLogo() != null && !club.getLogo().isEmpty()) { %>
                            <div class="club-logo-large">
                                <img src="<%= request.getContextPath() %>/uploads/logos/<%= club.getLogo() %>" 
                                     alt="Logo <%= club.getNom() %>"
                                     onerror="this.style.display='none'">
                            </div>
                        <% } else { %>
                            <div class="club-logo-large">
                                <i class="fas fa-chess-knight" style="font-size: 3rem; color: #667eea;"></i>
                            </div>
                        <% } %>
                        <div class="club-info">
                            <h2><i class="fas fa-crown"></i> <%= club.getNom() %></h2>
                            <p><%= club.getDescription() != null && !club.getDescription().isEmpty() ? club.getDescription() : "Votre club d'échecs" %></p>
                        </div>
                    </div>
                    
                    <div class="club-stats">
                        <div class="stat-card">
                            <i class="fas fa-users"></i>
                            <div class="stat-value"><%= memberCount %></div>
                            <div class="stat-label">Membres</div>
                        </div>
                        
                        <div class="stat-card">
                            <i class="fas fa-check-circle"></i>
                            <div class="stat-value"><%= club.getStatut() %></div>
                            <div class="stat-label">Statut</div>
                        </div>
                    </div>

                    <div class="club-actions">
                        <a href="<%= request.getContextPath() %>/president/gerer-membres" class="btn btn-white">
                            <i class="fas fa-users"></i>
                            Gérer les Membres
                        </a>
                        <a href="<%= request.getContextPath() %>/planning" class="btn btn-white">
                            <i class="fas fa-calendar-alt"></i>
                            Planning des Entraînements
                        </a>
                        <a href="<%= request.getContextPath() %>/maps" class="btn btn-white">
                            <i class="fas fa-map-marked-alt"></i>
                            Voir sur la Carte
                        </a>
                    </div>
                </div>
            <% } %>

            <!-- Section Événements -->
            <div class="section">
                <div class="section-header">
                    <h2 class="section-title">
                        <i class="fas fa-calendar-alt"></i>
                        Événements de la Fédération
                    </h2>
                    <div style="display: flex; gap: 10px;">
                        <a href="<%= request.getContextPath() %>/events?action=calendar" class="btn btn-secondary">
                            <i class="fas fa-calendar-alt"></i> Vue Calendrier
                        </a>
                        <a href="<%= request.getContextPath() %>/maps?view=events" class="btn btn-secondary">
                            <i class="fas fa-map-marked-alt"></i> Voir sur la Carte
                        </a>
                    </div>
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
                                <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 10px;">
                                    <span class="event-status"><%= evt.getStatut() %></span>
                                    <% if (club != null) { %>
                                        <a href="<%= request.getContextPath() %>/president/select-representatives?evenementId=<%= evt.getId() %>" 
                                           class="btn-select-rep">
                                            <i class="fas fa-users"></i> Sélectionner Représentants
                                        </a>
                                    <% } %>
                                </div>
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
                                <div style="display: flex; gap: 15px; align-items: start;">
                                    <% if (demande.getLogo() != null && !demande.getLogo().isEmpty()) { %>
                                        <div class="demande-logo">
                                            <img src="<%= request.getContextPath() %>/uploads/logos/<%= demande.getLogo() %>" 
                                                 alt="Logo <%= demande.getNomClub() %>"
                                                 onerror="this.style.display='none'">
                                        </div>
                                    <% } %>
                                    <div style="flex: 1;">
                                        <div class="demande-header">
                                            <div class="demande-title"><%= demande.getNomClub() %></div>
                                            <div style="display: flex; align-items: center; gap: 10px;">
                                                <span class="demande-status status-<%= demande.getStatut() %>"><%= demande.getStatut() %></span>
                                                <% if ("EN_ATTENTE".equals(demande.getStatut())) { %>
                                                    <button class="btn-delete"
                                                            data-id="<%= demande.getId() %>"
                                                            data-nom="<%= demande.getNomClub() %>"
                                                            onclick="confirmerSuppression(this)"
                                                            title="Supprimer cette demande">
                                                        <i class="fas fa-trash-alt"></i>
                                                    </button>
                                                <% } %>
                                            </div>
                                        </div>
                                        <p style="color: #666; margin: 10px 0;">
                                            <%= demande.getDescription() != null && !demande.getDescription().isEmpty() ? demande.getDescription() : "Aucune description" %>
                                        </p>
                                        <small style="color: #999;">
                                            <i class="fas fa-clock"></i> Demande envoyée le <%= demande.getDateDemande() %>
                                        </small>
                                    </div>
                                </div>
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
        </div>
    </div>

    <!-- Modal Créer un Club -->
    <div id="createClubModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2><i class="fas fa-plus-circle"></i> Créer un Nouveau Club</h2>
                <span class="close" onclick="closeModal()">&times;</span>
            </div>
            <form action="<%= request.getContextPath() %>/president/creer-club" method="post" enctype="multipart/form-data">
                <div class="form-group">
                    <label for="nomClub">
                        <i class="fas fa-chess-knight"></i> Nom du Club *
                    </label>
                    <input type="text" id="nomClub" name="nomClub" required placeholder="Exemple: Club d'Échecs Royal">
                </div>
                <div class="form-group">
                    <label for="description">
                        <i class="fas fa-align-left"></i> Description
                    </label>
                    <textarea id="description" name="description" placeholder="Décrivez brièvement votre club, ses objectifs, etc."></textarea>
                </div>
                <div class="form-group">
                    <label for="logo">
                        <i class="fas fa-image"></i> Logo du Club
                    </label>
                    <input type="file" id="logo" name="logo" accept="image/jpeg,image/png,image/gif,image/svg+xml"
                           onchange="previewLogo(event)">
                    <small style="color: #999; display: block; margin-top: 5px;">
                        Formats acceptés: JPG, PNG, GIF, SVG (Max: 10MB)
                    </small>
                    <div id="logoPreview" style="margin-top: 10px; display: none;">
                        <img id="logoPreviewImg" src="" alt="Aperçu du logo"
                             style="max-width: 150px; max-height: 150px; border-radius: 8px; border: 2px solid #ddd;">
                    </div>
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
            document.getElementById('logoPreview').style.display = 'none';
            document.getElementById('logoPreviewImg').src = '';
        }

        function previewLogo(event) {
            const file = event.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('logoPreviewImg').src = e.target.result;
                    document.getElementById('logoPreview').style.display = 'block';
                }
                reader.readAsDataURL(file);
            }
        }

        window.onclick = function(event) {
            const modal = document.getElementById('createClubModal');
            if (event.target == modal) {
                closeModal();
            }
            
            const notificationModal = document.getElementById('notificationModal');
            if (event.target == notificationModal) {
                closeNotifications();
            }
        }

        // Notification functions
        function openNotifications() {
            document.getElementById('notificationModal').style.display = 'block';
            loadNotifications();
        }

        function closeNotifications() {
            document.getElementById('notificationModal').style.display = 'none';
        }

        function loadNotifications() {
            var contextPath = '<%= request.getContextPath() %>';
            fetch(contextPath + '/president/notifications')
                .then(response => response.json())
                .then(data => {
                    const notificationList = document.getElementById('notificationList');
                    if (data.length === 0) {
                        notificationList.innerHTML = '<div class="no-notifications"><i class="fas fa-bell-slash"></i><p>Aucune notification pour le moment</p></div>';
                    } else {
                        let html = '';
                        data.forEach(notif => {
                            html += '<div class="notification-item ' + (notif.lu ? '' : 'unread') + '">' +
                                '<div class="notification-item-header">' +
                                '<span class="notification-item-type">' + getTypeLabel(notif.type) + '</span>' +
                                '<span class="notification-item-date">' + notif.dateCreation + '</span>' +
                                '</div>' +
                                '<div class="notification-item-message">' + notif.message + '</div>' +
                                '</div>';
                        });
                        notificationList.innerHTML = html;
                    }
                })
                .catch(error => {
                    console.error('Error loading notifications:', error);
                });
        }

        function getTypeLabel(type) {
            const labels = {
                'EVENT_ADDED': 'Nouvel Événement',
                'CLUB_APPROVED': 'Club Approuvé'
            };
            return labels[type] || type;
        }

        function markAllAsRead() {
            var contextPath = '<%= request.getContextPath() %>';
            fetch(contextPath + '/president/notifications?action=markAllRead', {
                method: 'GET'
            })
                .then(() => {
                    location.reload();
                })
                .catch(error => {
                    console.error('Error marking notifications as read:', error);
                });
        }

        function confirmerSuppression(button) {
            const id = button.dataset.id;
            const nomClub = button.dataset.nom;
            if (confirm('Êtes-vous sûr de vouloir supprimer la demande pour "' + nomClub + '" ?\n\nCette action est irréversible.')) {
                // Créer un formulaire pour envoyer la requête POST
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '<%= request.getContextPath() %>/president/supprimer-demande';
                
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'demandeId';
                input.value = id;
                
                form.appendChild(input);
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</body>

</html>

