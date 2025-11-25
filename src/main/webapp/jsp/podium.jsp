<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.projet.jee.model.Evenement" %>
<%@ page import="com.projet.jee.model.Utilisateur" %>
<%@ page import="com.projet.jee.model.Club" %>
<%
    Utilisateur currentUser = (Utilisateur) session.getAttribute("currentUser");
    if (currentUser == null || ("PRESIDENT".equals(currentUser.getRole()) || "FEDERATION".equals(currentUser.getRole()))) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    Evenement evenement = (Evenement) request.getAttribute("evenement");
    Utilisateur premier = (Utilisateur) request.getAttribute("premier");
    Utilisateur deuxieme = (Utilisateur) request.getAttribute("deuxieme");
    Utilisateur troisieme = (Utilisateur) request.getAttribute("troisieme");
    
    // Get club objects from request attributes
    Club clubPremier = (Club) request.getAttribute("clubPremier");
    Club clubDeuxieme = (Club) request.getAttribute("clubDeuxieme");
    Club clubTroisieme = (Club) request.getAttribute("clubTroisieme");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Podium - <%= evenement.getTitre() %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            min-height: 100vh;
            margin: 0;
            padding: 20px;
            color: #333;
        }

        .podium-container {
            max-width: 1000px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }

        .header {
            text-align: center;
            margin-bottom: 40px;
        }

        .header h1 {
            color: #1e3c72;
            margin-bottom: 10px;
        }

        .event-info {
            color: #666;
            margin-bottom: 20px;
        }

        .podium {
            display: flex;
            justify-content: center;
            align-items: flex-end;
            margin: 50px 0;
            gap: 20px;
        }

        .podium-step {
            display: flex;
            flex-direction: column;
            align-items: center;
            position: relative;
        }

        .podium-step .position {
            width: 100px;
            text-align: center;
            font-size: 1.2rem;
            font-weight: bold;
            color: #fff;
            padding: 10px 0;
            border-radius: 8px 8px 0 0;
        }

        .podium-step .participant {
            background: #f8f9fa;
            border: 1px solid #e0e0e0;
            border-radius: 0 0 8px 8px;
            padding: 20px;
            width: 100%;
            text-align: center;
            min-height: 120px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .podium-step .name {
            font-weight: 600;
            margin: 5px 0;
        }

        .podium-step .club {
            color: #666;
            font-size: 0.9rem;
        }

        /* Second place */
        .podium-step:nth-child(1) .position {
            background: #c0c0c0;
            height: 120px;
            display: flex;
            align-items: flex-end;
            justify-content: center;
            padding-bottom: 20px;
        }

        .podium-step:nth-child(1) .participant {
            border-top: 3px solid #c0c0c0;
        }

        /* First place */
        .podium-step:nth-child(2) .position {
            background: #ffd700;
            height: 160px;
            display: flex;
            align-items: flex-end;
            justify-content: center;
            padding-bottom: 20px;
        }

        .podium-step:nth-child(2) .participant {
            border-top: 3px solid #ffd700;
        }

        /* Third place */
        .podium-step:nth-child(3) .position {
            background: #cd7f32;
            height: 100px;
            display: flex;
            align-items: flex-end;
            justify-content: center;
            padding-bottom: 20px;
        }

        .podium-step:nth-child(3) .participant {
            border-top: 3px solid #cd7f32;
        }

        .back-button {
            display: inline-block;
            margin-top: 30px;
            padding: 10px 20px;
            background: #1e3c72;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: all 0.3s;
        }

        .back-button:hover {
            background: #2a5298;
            transform: translateY(-2px);
        }

        .empty-podium {
            text-align: center;
            padding: 40px;
            color: #666;
        }

        .empty-podium i {
            font-size: 3rem;
            color: #ddd;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <div class="podium-container">
        <div class="header">
            <h1><i class="fas fa-trophy"></i> Podium du Tournoi</h1>
            <div class="event-info">
                <h2><%= evenement.getTitre() %></h2>
                <p><%= evenement.getLieu() %> • <%= evenement.getDateDebut() %></p>
            </div>
        </div>

        <% if (premier != null || deuxieme != null || troisieme != null) { %>
            <div class="podium">
                <!-- Second Place -->
                <div class="podium-step">
                    <div class="position">2<sup>ème</sup></div>
                    <div class="participant">
                        <% if (deuxieme != null) { %>
                            <div class="name"><%= deuxieme.getPrenom() %> <%= deuxieme.getNom() %></div>
                            <div class="club">
                                <% if (clubDeuxieme != null) { %>
                                    <%= clubDeuxieme.getNom() %>
                                <% } else { %>
                                    Club inconnu
                                <% } %>
                            </div>
                        <% } else { %>
                            <div class="empty">-</div>
                        <% } %>
                    </div>
                </div>

                <!-- First Place -->
                <div class="podium-step">
                    <div class="position">1<sup>er</sup></div>
                    <div class="participant">
                        <% if (premier != null) { %>
                            <div class="name"><i class="fas fa-crown" style="color: gold;"></i> <%= premier.getPrenom() %> <%= premier.getNom() %></div>
                            <div class="club">
                                <% if (clubPremier != null) { %>
                                    <%= clubPremier.getNom() %>
                                <% } else { %>
                                    Club inconnu
                                <% } %>
                            </div>
                        <% } else { %>
                            <div class="empty">-</div>
                        <% } %>
                    </div>
                </div>

                <!-- Third Place -->
                <div class="podium-step">
                    <div class="position">3<sup>ème</sup></div>
                    <div class="participant">
                        <% if (troisieme != null) { %>
                            <div class="name"><%= troisieme.getPrenom() %> <%= troisieme.getNom() %></div>
                            <div class="club">
                                <% if (clubTroisieme != null) { %>
                                    <%= clubTroisieme.getNom() %>
                                <% } else { %>
                                    Club inconnu
                                <% } %>
                            </div>
                        <% } else { %>
                            <div class="empty">-</div>
                        <% } %>
                    </div>
                </div>
            </div>
        <% } else { %>
            <div class="empty-podium">
                <i class="fas fa-trophy"></i>
                <h3>Podium non encore défini</h3>
                <p>Les résultats ne sont pas encore disponibles pour ce tournoi.</p>
            </div>
        <% } %>

        <div style="text-align: center;">
            <a href="<%= request.getContextPath() %>/president/dashboard" class="back-button">
                <i class="fas fa-arrow-left"></i> Retour au tableau de bord
            </a>
        </div>
    </div>
</body>
</html>
