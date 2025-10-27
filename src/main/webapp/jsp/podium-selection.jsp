<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.projet.jee.model.Evenement" %>
<%@ page import="com.projet.jee.model.Utilisateur" %>
<%
    Utilisateur currentUser = (Utilisateur) session.getAttribute("currentUser");
    if (currentUser == null || !"FEDERATION".equals(currentUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    Evenement evenement = (Evenement) request.getAttribute("evenement");
    List<Utilisateur> participants = (List<Utilisateur>) request.getAttribute("participants");
    Utilisateur premier = (Utilisateur) request.getAttribute("premier");
    Utilisateur deuxieme = (Utilisateur) request.getAttribute("deuxieme");
    Utilisateur troisieme = (Utilisateur) request.getAttribute("troisieme");
    
    if (evenement == null) {
        response.sendRedirect(request.getContextPath() + "/federation/dashboard");
        return;
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sélection du Podium - <%= evenement.getTitre() %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/federation-dashboard.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .podium-container {
            max-width: 900px;
            margin: 0 auto;
        }

        .event-info-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem;
            border-radius: 12px;
            margin-bottom: 2rem;
            text-align: center;
        }

        .event-info-card h2 {
            margin: 0 0 0.5rem 0;
            font-size: 2rem;
        }

        .event-info-card p {
            margin: 0;
            opacity: 0.9;
        }

        .podium-form-card {
            background: white;
            border-radius: 12px;
            padding: 2rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .podium-positions {
            display: grid;
            gap: 2rem;
            margin-bottom: 2rem;
        }

        .position-selector {
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            padding: 1.5rem;
            transition: all 0.3s ease;
        }

        .position-selector:hover {
            border-color: #667eea;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.1);
        }

        .position-selector.first {
            border-color: #FFD700;
            background: linear-gradient(135deg, #fff9e6 0%, #fffef7 100%);
        }

        .position-selector.second {
            border-color: #C0C0C0;
            background: linear-gradient(135deg, #f5f5f5 0%, #fafafa 100%);
        }

        .position-selector.third {
            border-color: #CD7F32;
            background: linear-gradient(135deg, #fff4e6 0%, #fffbf5 100%);
        }

        .position-header {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1rem;
        }

        .position-icon {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            font-weight: bold;
        }

        .position-icon.first {
            background: linear-gradient(135deg, #FFD700 0%, #FFA500 100%);
            color: white;
        }

        .position-icon.second {
            background: linear-gradient(135deg, #C0C0C0 0%, #A9A9A9 100%);
            color: white;
        }

        .position-icon.third {
            background: linear-gradient(135deg, #CD7F32 0%, #B8860B 100%);
            color: white;
        }

        .position-header h3 {
            margin: 0;
            font-size: 1.3rem;
            color: #1e3c72;
        }

        .select-wrapper {
            position: relative;
        }

        .select-wrapper select {
            width: 100%;
            padding: 12px 40px 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 1rem;
            background: white;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .select-wrapper select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .select-wrapper::after {
            content: '\f078';
            font-family: 'Font Awesome 6 Free';
            font-weight: 900;
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            pointer-events: none;
            color: #666;
        }

        .current-selection {
            margin-top: 1rem;
            padding: 1rem;
            background: #f8f9fa;
            border-radius: 8px;
            display: none;
        }

        .current-selection.show {
            display: block;
        }

        .current-selection .player-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .player-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
        }

        .action-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            margin-top: 2rem;
        }

        .btn {
            padding: 12px 30px;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }

        .participants-note {
            background: #e7f3ff;
            border-left: 4px solid #2196F3;
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 2rem;
        }

        .participants-note i {
            color: #2196F3;
            margin-right: 0.5rem;
        }
    </style>
</head>
<body>
    <div class="federation-dashboard">
        <!-- Header -->
        <header class="dashboard-header">
            <div class="header-content">
                <h1><i class="fas fa-trophy"></i> Sélection du Podium</h1>
                <div class="user-info">
                    <span>Bienvenue, <%= currentUser.getPrenom() %> <%= currentUser.getNom() %></span>
                    <a href="<%= request.getContextPath() %>/federation/event-details?id=<%= evenement.getId() %>" class="logout-btn">
                        <i class="fas fa-arrow-left"></i> Retour
                    </a>
                </div>
            </div>
        </header>

        <!-- Main Content -->
        <main class="dashboard-main">
            <div class="podium-container">
                <!-- Event Info -->
                <div class="event-info-card">
                    <h2><i class="fas fa-chess"></i> <%= evenement.getTitre() %></h2>
                    <p><i class="fas fa-calendar"></i> <%= evenement.getDateDebut() %> - <%= evenement.getDateFin() %></p>
                    <p><i class="fas fa-map-marker-alt"></i> <%= evenement.getLieu() %></p>
                </div>

                <% if (session.getAttribute("errorMessage") != null) { %>
                    <div class="message message-error">
                        <i class="fas fa-exclamation-circle"></i>
                        <%= session.getAttribute("errorMessage") %>
                    </div>
                    <% session.removeAttribute("errorMessage"); %>
                <% } %>

                <!-- Podium Selection Form -->
                <div class="podium-form-card">
                    <div class="participants-note">
                        <i class="fas fa-info-circle"></i>
                        <strong>Note:</strong> Sélectionnez les 3 meilleurs joueurs du tournoi. 
                        <%= participants != null ? participants.size() : 0 %> participant(s) disponible(s).
                    </div>

                    <form method="post" action="<%= request.getContextPath() %>/federation/podium" onsubmit="return validatePodium()">
                        <input type="hidden" name="evenementId" value="<%= evenement.getId() %>">

                        <div class="podium-positions">
                            <!-- 1st Place -->
                            <div class="position-selector first">
                                <div class="position-header">
                                    <div class="position-icon first">
                                        <i class="fas fa-trophy"></i>
                                    </div>
                                    <h3>1ère Place - Médaille d'Or</h3>
                                </div>
                                <div class="select-wrapper">
                                    <select name="premierId" id="premier" onchange="updateSelection('premier')">
                                        <option value="">-- Sélectionner le gagnant --</option>
                                        <% if (participants != null) {
                                            for (Utilisateur p : participants) { %>
                                                <option value="<%= p.getId() %>" 
                                                    <%= (premier != null && premier.getId().equals(p.getId())) ? "selected" : "" %>>
                                                    <%= p.getPrenom() %> <%= p.getNom() %> 
                                                    <% if (p.getClubId() != null) { %>(Club ID: <%= p.getClubId() %>)<% } %>
                                                </option>
                                        <% }
                                        } %>
                                    </select>
                                </div>
                            </div>

                            <!-- 2nd Place -->
                            <div class="position-selector second">
                                <div class="position-header">
                                    <div class="position-icon second">
                                        <i class="fas fa-medal"></i>
                                    </div>
                                    <h3>2ème Place - Médaille d'Argent</h3>
                                </div>
                                <div class="select-wrapper">
                                    <select name="deuxiemeId" id="deuxieme" onchange="updateSelection('deuxieme')">
                                        <option value="">-- Sélectionner le 2ème --</option>
                                        <% if (participants != null) {
                                            for (Utilisateur p : participants) { %>
                                                <option value="<%= p.getId() %>"
                                                    <%= (deuxieme != null && deuxieme.getId().equals(p.getId())) ? "selected" : "" %>>
                                                    <%= p.getPrenom() %> <%= p.getNom() %>
                                                    <% if (p.getClubId() != null) { %>(Club ID: <%= p.getClubId() %>)<% } %>
                                                </option>
                                        <% }
                                        } %>
                                    </select>
                                </div>
                            </div>

                            <!-- 3rd Place -->
                            <div class="position-selector third">
                                <div class="position-header">
                                    <div class="position-icon third">
                                        <i class="fas fa-award"></i>
                                    </div>
                                    <h3>3ème Place - Médaille de Bronze</h3>
                                </div>
                                <div class="select-wrapper">
                                    <select name="troisiemeId" id="troisieme" onchange="updateSelection('troisieme')">
                                        <option value="">-- Sélectionner le 3ème --</option>
                                        <% if (participants != null) {
                                            for (Utilisateur p : participants) { %>
                                                <option value="<%= p.getId() %>"
                                                    <%= (troisieme != null && troisieme.getId().equals(p.getId())) ? "selected" : "" %>>
                                                    <%= p.getPrenom() %> <%= p.getNom() %>
                                                    <% if (p.getClubId() != null) { %>(Club ID: <%= p.getClubId() %>)<% } %>
                                                </option>
                                        <% }
                                        } %>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="action-buttons">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Enregistrer le Podium
                            </button>
                            <a href="<%= request.getContextPath() %>/federation/event-details?id=<%= evenement.getId() %>" 
                               class="btn btn-secondary">
                                <i class="fas fa-times"></i> Annuler
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>

    <script>
        function validatePodium() {
            const premier = document.getElementById('premier').value;
            const deuxieme = document.getElementById('deuxieme').value;
            const troisieme = document.getElementById('troisieme').value;

            // Check if same person selected multiple times
            if (premier && deuxieme && premier === deuxieme) {
                alert('Le 1er et 2ème place ne peuvent pas être la même personne!');
                return false;
            }
            if (premier && troisieme && premier === troisieme) {
                alert('Le 1er et 3ème place ne peuvent pas être la même personne!');
                return false;
            }
            if (deuxieme && troisieme && deuxieme === troisieme) {
                alert('Le 2ème et 3ème place ne peuvent pas être la même personne!');
                return false;
            }

            // At least one winner should be selected
            if (!premier && !deuxieme && !troisieme) {
                return confirm('Aucun gagnant sélectionné. Voulez-vous continuer?');
            }

            return true;
        }

        function updateSelection(position) {
            // Optional: Add visual feedback when selection changes
            const select = document.getElementById(position);
            if (select.value) {
                select.parentElement.parentElement.style.borderWidth = '3px';
            } else {
                select.parentElement.parentElement.style.borderWidth = '2px';
            }
        }
    </script>
</body>
</html>