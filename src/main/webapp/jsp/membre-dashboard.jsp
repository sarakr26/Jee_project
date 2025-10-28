<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.projet.jee.model.Club" %>
<%@ page import="com.projet.jee.model.Evenement" %>
<%@ page import="com.projet.jee.model.Utilisateur" %>
<%
    Utilisateur currentUser = (Utilisateur) session.getAttribute("currentUser");
    if (currentUser == null || !"MEMBRE".equals(currentUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    List<Club> clubs = (List<Club>) request.getAttribute("clubs");
    List<Evenement> evenements = (List<Evenement>) request.getAttribute("evenements");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Membre - Clubs Disponibles</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .member-dashboard {
            min-height: 100vh;
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            padding: 20px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
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
            gap: 15px;
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
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(220, 53, 69, 0.3);
        }

        .clubs-container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .clubs-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 25px;
            margin-top: 20px;
        }

        .club-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            transition: all 0.3s;
        }

        .club-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }

        .club-header {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            padding: 20px;
            text-align: center;
            color: white;
        }

        .club-logo {
            width: 80px;
            height: 80px;
            background: white;
            border-radius: 50%;
            margin: 0 auto 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            color: #8B4513;
        }

        .club-name {
            font-size: 1.5rem;
            font-weight: bold;
            margin: 0;
        }

        .club-body {
            padding: 20px;
        }

        .club-description {
            color: #666;
            line-height: 1.6;
            margin-bottom: 20px;
            min-height: 60px;
        }

        .club-statut {
            display: inline-block;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            background: #4CAF50;
            color: white;
            margin-bottom: 15px;
        }

        .club-actions {
            display: flex;
            gap: 10px;
        }

        .btn-join {
            flex: 1;
            background: #4CAF50;
            color: white;
            padding: 12px 20px;
            border-radius: 8px;
            text-decoration: none;
            text-align: center;
            font-weight: 600;
            transition: all 0.3s;
            border: none;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-join:hover {
            background: #45a049;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(76, 175, 80, 0.3);
        }

        .empty-message {
            background: white;
            border-radius: 15px;
            padding: 60px;
            text-align: center;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
        }

        .empty-message i {
            font-size: 4rem;
            color: #ccc;
            margin-bottom: 20px;
        }

        .empty-message h2 {
            color: #666;
            margin-bottom: 10px;
        }

        .empty-message p {
            color: #999;
        }

        .error-message {
            background: #f44336;
            color: white;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            text-align: center;
        }

        .user-welcome {
            color: #666;
            font-size: 1rem;
        }

        /* Styles pour les événements */
        .events-container {
            max-width: 1200px;
            margin: 30px auto 0;
        }

        .events-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 25px;
            margin-top: 20px;
        }

        .event-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            transition: all 0.3s;
        }

        .event-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }

        .event-header {
            background: linear-gradient(135deg, #2196F3 0%, #1976D2 100%);
            padding: 20px;
            text-align: center;
            color: white;
        }

        .event-icon {
            width: 60px;
            height: 60px;
            background: white;
            border-radius: 50%;
            margin: 0 auto 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            color: #2196F3;
        }

        .event-title {
            font-size: 1.4rem;
            font-weight: bold;
            margin: 0;
        }

        .event-body {
            padding: 20px;
        }

        .event-info {
            margin-bottom: 15px;
        }

        .event-info-item {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 8px;
            color: #666;
        }

        .event-info-item i {
            color: #2196F3;
            width: 20px;
        }

        .event-description {
            color: #666;
            line-height: 1.6;
            margin-bottom: 15px;
            min-height: 60px;
        }

        .event-statut {
            display: inline-block;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            background: #2196F3;
            color: white;
            margin-bottom: 15px;
        }

        .section-title {
            color: white;
            font-size: 1.8rem;
            font-weight: bold;
            margin-bottom: 20px;
            text-align: center;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
        }

        .section-title i {
            font-size: 2rem;
        }

        /* Boutons de basculement */
        .toggle-buttons {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-bottom: 30px;
        }

        .toggle-btn {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border: 2px solid rgba(255, 255, 255, 0.3);
            padding: 12px 30px;
            border-radius: 25px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-weight: 600;
            font-size: 1rem;
        }

        .toggle-btn:hover {
            background: rgba(255, 255, 255, 0.3);
            border-color: rgba(255, 255, 255, 0.5);
        }

        .toggle-btn.active {
            background: white;
            color: #1e3c72;
            border-color: white;
        }

        .toggle-btn.active:hover {
            background: #f8f9fa;
        }

        /* Sections cachées */
        .section-hidden {
            display: none;
        }

        .section-visible {
            display: block;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .member-dashboard {
                padding: 15px;
            }

            .dashboard-header {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }

            .header-actions {
                flex-direction: column;
                width: 100%;
                max-width: 300px;
            }

            .btn-profile {
                width: 100%;
                justify-content: center;
            }

            .toggle-buttons {
                flex-direction: column;
                gap: 10px;
                margin-bottom: 20px;
            }

            .toggle-btn {
                width: 100%;
                max-width: 300px;
                margin: 0 auto;
            }

            .clubs-grid, .events-grid {
                grid-template-columns: 1fr;
                gap: 15px;
            }

            .section-title {
                font-size: 1.3rem;
                flex-direction: column;
                gap: 5px;
            }
        }
    </style>
</head>
<body>
    <div class="member-dashboard">
        <div class="dashboard-header">
                <div class="header-title">
                <i class="fas fa-chess-king"></i>
                <div>
                    <h1>Dashboard Membre</h1>
                    <p class="user-welcome">Bienvenue, <%= currentUser.getPrenom() %> <%= currentUser.getNom() %></p>
                </div>
            </div>
            <div class="header-actions">
                <a href="${pageContext.request.contextPath}/profile" class="btn btn-secondary">
                    <i class="fas fa-user"></i>
                    Mon Profil
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger">
                    <i class="fas fa-sign-out-alt"></i>
                    Déconnexion
                </a>
            </div>
        </div>

        <% if (session.getAttribute("successMessage") != null) { %>
            <div class="error-message" style="background: #4CAF50;">
                <i class="fas fa-check-circle"></i>
                <%= session.getAttribute("successMessage") %>
            </div>
            <% session.removeAttribute("successMessage"); %>
        <% } %>
        
        <% if (session.getAttribute("errorMessage") != null) { %>
            <div class="error-message">
                <i class="fas fa-exclamation-circle"></i>
                <%= session.getAttribute("errorMessage") %>
            </div>
            <% session.removeAttribute("errorMessage"); %>
        <% } %>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="error-message">
                <i class="fas fa-exclamation-circle"></i>
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <!-- Boutons de basculement -->
        <div class="toggle-buttons">
            <button class="toggle-btn active" onclick="showSection('clubs')">
                <i class="fas fa-chess-knight"></i>
                Clubs d'Échecs Disponibles
            </button>
            <button class="toggle-btn" onclick="showSection('events')">
                <i class="fas fa-calendar-alt"></i>
                Événements Planifiés
            </button>
        </div>

        <!-- Section Clubs -->
        <div id="clubs-section" class="clubs-container section-visible">
            <h2 class="section-title">
                <i class="fas fa-chess-knight"></i>
                Clubs d'Échecs Disponibles
            </h2>

            <% if (clubs != null && !clubs.isEmpty()) { %>
                <div class="clubs-grid">
                    <% for (Club club : clubs) { %>
                        <div class="club-card">
                            <div class="club-header">
                                <div class="club-logo">
                                    <% if (club.getLogo() != null && !club.getLogo().isEmpty()) { %>
                                        <img src="<%= club.getLogo() %>" alt="<%= club.getNom() %>" style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%;">
                                    <% } else { %>
                                        <i class="fas fa-chess-knight"></i>
                                    <% } %>
                                </div>
                                <h3 class="club-name"><%= club.getNom() %></h3>
                            </div>
                            <div class="club-body">
                                <span class="club-statut">
                                    <i class="fas fa-circle" style="font-size: 0.6rem;"></i>
                                    <%= club.getStatut() %>
                                </span>
                                <p class="club-description">
                                    <%= club.getDescription() != null ? club.getDescription() : "Aucune description disponible pour ce club." %>
                                </p>
                                <div class="club-actions">
                                    <form action="<%= request.getContextPath() %>/membre/integrer-club" method="post" style="flex: 1;">
                                        <input type="hidden" name="clubId" value="<%= club.getId() %>">
                                        <button type="submit" class="btn-join">
                                            <i class="fas fa-user-plus"></i>
                                            Intégrer le Club
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } else { %>
                <div class="empty-message">
                    <i class="fas fa-chess-board"></i>
                    <h2>Aucun club disponible</h2>
                    <p>Il n'y a actuellement aucun club actif. Revenez plus tard !</p>
                </div>
            <% } %>
        </div>

        <!-- Section Événements -->
        <div id="events-section" class="events-container section-hidden">
            <h2 class="section-title">
                <i class="fas fa-calendar-alt"></i>
                Événements Planifiés
            </h2>

            <% if (evenements != null && !evenements.isEmpty()) { %>
                <div class="events-grid">
                    <% for (Evenement evenement : evenements) { %>
                        <div class="event-card">
                            <div class="event-header">
                                <div class="event-icon">
                                    <i class="fas fa-trophy"></i>
                                </div>
                                <h3 class="event-title"><%= evenement.getTitre() %></h3>
                            </div>
                            <div class="event-body">
                                <span class="event-statut">
                                    <i class="fas fa-circle" style="font-size: 0.6rem;"></i>
                                    <%= evenement.getStatut() %>
                                </span>
                                
                                <div class="event-info">
                                    <% if (evenement.getLieu() != null && !evenement.getLieu().isEmpty()) { %>
                                        <div class="event-info-item">
                                            <i class="fas fa-map-marker-alt"></i>
                                            <span><%= evenement.getLieu() %></span>
                                        </div>
                                    <% } %>
                                    
                                    <% if (evenement.getDateDebut() != null) { %>
                                        <div class="event-info-item">
                                            <i class="fas fa-calendar"></i>
                                            <span>Début : <%= evenement.getDateDebut() %></span>
                                        </div>
                                    <% } %>
                                    
                                    <% if (evenement.getDateFin() != null) { %>
                                        <div class="event-info-item">
                                            <i class="fas fa-calendar-check"></i>
                                            <span>Fin : <%= evenement.getDateFin() %></span>
                                        </div>
                                    <% } %>
                                </div>
                                
                                <p class="event-description">
                                    <%= evenement.getDescription() != null ? evenement.getDescription() : "Aucune description disponible pour cet événement." %>
                                </p>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } else { %>
                <div class="empty-message">
                    <i class="fas fa-calendar-times"></i>
                    <h2>Aucun événement planifié</h2>
                    <p>Il n'y a actuellement aucun événement planifié. Revenez plus tard !</p>
                </div>
            <% } %>
        </div>
    </div>

    <script>
        function showSection(sectionName) {
            // Cacher toutes les sections
            document.getElementById('clubs-section').classList.remove('section-visible');
            document.getElementById('clubs-section').classList.add('section-hidden');
            document.getElementById('events-section').classList.remove('section-visible');
            document.getElementById('events-section').classList.add('section-hidden');
            
            // Retirer la classe active de tous les boutons
            document.querySelectorAll('.toggle-btn').forEach(btn => {
                btn.classList.remove('active');
            });
            
            // Afficher la section demandée
            if (sectionName === 'clubs') {
                document.getElementById('clubs-section').classList.remove('section-hidden');
                document.getElementById('clubs-section').classList.add('section-visible');
                document.querySelector('.toggle-btn[onclick="showSection(\'clubs\')"]').classList.add('active');
            } else if (sectionName === 'events') {
                document.getElementById('events-section').classList.remove('section-hidden');
                document.getElementById('events-section').classList.add('section-visible');
                document.querySelector('.toggle-btn[onclick="showSection(\'events\')"]').classList.add('active');
            }
        }
    </script>
</body>
</html>

