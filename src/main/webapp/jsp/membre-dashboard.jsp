<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.projet.jee.model.Club" %>
<%@ page import="com.projet.jee.model.Utilisateur" %>
<%
    Utilisateur currentUser = (Utilisateur) session.getAttribute("currentUser");
    if (currentUser == null || !"MEMBRE".equals(currentUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    List<Club> clubs = (List<Club>) request.getAttribute("clubs");
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

        .btn-profile {
            background: #8B4513;
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
        }

        .btn-profile:hover {
            background: #6d3410;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(139, 69, 19, 0.3);
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
            box-shadow: 0 5px 15px rgba(76, 175, 80, 0.3);
        }

        .empty-message {
            background: white;
            padding: 60px;
            border-radius: 15px;
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
    </style>
</head>
<body>
    <div class="member-dashboard">
        <div class="dashboard-header">
            <div class="header-title">
                <i class="fas fa-chess-king"></i>
                <div>
                    <h1>Clubs d'Échecs Disponibles</h1>
                    <p class="user-welcome">Bienvenue, <%= currentUser.getPrenom() %> <%= currentUser.getNom() %></p>
                </div>
            </div>
            <div class="header-actions">
                <a href="<%= request.getContextPath() %>/jsp/auth/profile.jsp" class="btn-profile">
                    <i class="fas fa-user"></i>
                    Mon Profil
                </a>
                <a href="<%= request.getContextPath() %>/logout" class="btn-profile" style="background: #dc3545;">
                    <i class="fas fa-sign-out-alt"></i>
                    Déconnexion
                </a>
            </div>
        </div>

        <div class="clubs-container">
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
    </div>
</body>
</html>

