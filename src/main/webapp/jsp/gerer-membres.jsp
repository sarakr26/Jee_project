<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.projet.jee.model.Club" %>
<%@ page import="com.projet.jee.model.DemandeIntegration" %>
<%@ page import="com.projet.jee.model.Utilisateur" %>
<%
    Utilisateur currentUser = (Utilisateur) session.getAttribute("currentUser");
    if (currentUser == null || !"PRESIDENT".equals(currentUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    Club club = (Club) request.getAttribute("club");
    List<Utilisateur> members = (List<Utilisateur>) request.getAttribute("members");
    List<DemandeIntegration> pendingRequests = (List<DemandeIntegration>) request.getAttribute("pendingRequests");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gérer les Membres - <%= club != null ? club.getNom() : "Club" %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/federation-dashboard.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        /* Additional styles for gerer-membres */
        .club-info-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem;
            border-radius: 12px;
            margin-bottom: 1.5rem;
            text-align: center;
        }

        .club-info-card h3 {
            font-size: 2rem;
            margin-bottom: 0.5rem;
        }

        .club-info-card p {
            font-size: 1rem;
            opacity: 0.9;
        }

        .members-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 1rem;
            margin-top: 20px;
        }

        @media (max-width: 768px) {
            .members-grid {
                grid-template-columns: 1fr;
            }
        }

        .member-card {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 1.5rem;
            border-left: 4px solid #667eea;
            transition: all 0.3s ease;
        }

        .member-card:hover {
            background: #e9ecef;
            transform: translateX(5px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .member-card-header {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1rem;
        }

        .member-card-body {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .member-card-info {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: #666;
            font-size: 0.9rem;
        }

        .member-card-actions {
            margin-top: 1rem;
            padding-top: 1rem;
            border-top: 1px solid #dee2e6;
        }

        .member-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 1.2rem;
        }

        .pending-requests-section {
            background: #fff3cd;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 30px;
            border-left: 4px solid #ffc107;
        }

        .pending-requests-section h3 {
            color: #856404;
            margin-top: 0;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .requests-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(400px, 1fr));
            gap: 1rem;
        }

        @media (max-width: 768px) {
            .requests-grid {
                grid-template-columns: 1fr;
            }
        }

        .request-item {
            background: white;
            padding: 15px;
            border-radius: 8px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }

        .request-info {
            display: flex;
            align-items: center;
            gap: 15px;
            flex: 1;
        }

        .request-actions {
            display: flex;
            gap: 10px;
            flex-shrink: 0;
        }

        .btn-approve, .btn-reject {
            padding: 8px 16px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .btn-approve {
            background: #28a745;
            color: white;
        }

        .btn-approve:hover {
            background: #218838;
        }

        .btn-reject {
            background: #dc3545;
            color: white;
        }

        .btn-reject:hover {
            background: #c82333;
        }

        .btn-remove {
            padding: 6px 12px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            background: #dc3545;
            color: white;
            font-size: 0.9rem;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .btn-remove:hover {
            background: #c82333;
            transform: scale(1.05);
        }
    </style>
</head>
<body>
    <div class="federation-dashboard">
        <!-- Header -->
        <header class="dashboard-header">
            <div class="header-content">
                <h1><i class="fas fa-users"></i> Gestion des Membres</h1>
                <div class="user-info">
                    <span>Bienvenue, <%= currentUser.getPrenom() %> <%= currentUser.getNom() %></span>
                    <a href="<%= request.getContextPath() %>/president/dashboard" class="logout-btn">
                        <i class="fas fa-arrow-left"></i> Retour
                    </a>
                </div>
            </div>
        </header>

        <!-- Main Content -->
        <main class="dashboard-main">

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

            <% if (request.getAttribute("error") != null) { %>
                <div class="message message-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <!-- Club Info -->
            <section class="key-indicators">
                <div class="club-info-card">
                    <h3><i class="fas fa-chess-knight"></i> <%= club != null ? club.getNom() : "" %></h3>
                    <p><%= members != null ? members.size() : 0 %> membre(s) actif(s)</p>
                </div>
            </section>

            <!-- Statistics -->
            <section class="key-indicators">
                <h2><i class="fas fa-chart-bar"></i> Statistiques</h2>
                <div class="indicators-grid">
                    <div class="indicator-card">
                        <div class="indicator-icon">
                            <i class="fas fa-users"></i>
                        </div>
                        <div class="indicator-content">
                            <h3><%= members != null ? members.size() : 0 %></h3>
                            <p>Membres Total</p>
                        </div>
                    </div>
                    <div class="indicator-card">
                        <div class="indicator-icon">
                            <i class="fas fa-user-clock"></i>
                        </div>
                        <div class="indicator-content">
                            <h3><%= pendingRequests != null ? pendingRequests.size() : 0 %></h3>
                            <p>Demandes en Attente</p>
                        </div>
                    </div>
                    <div class="indicator-card">
                        <div class="indicator-icon">
                            <i class="fas fa-check-circle"></i>
                        </div>
                        <div class="indicator-content">
                            <h3>Actif</h3>
                            <p>Statut du Club</p>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Pending Integration Requests -->
            <% if (pendingRequests != null && !pendingRequests.isEmpty()) { %>
                <section class="pending-requests">
                    <h2><i class="fas fa-user-clock"></i> Demandes d'Intégration en Attente (<%= pendingRequests.size() %>)</h2>
                    <div class="pending-requests-section">
                        <div class="requests-grid">
                            <% for (DemandeIntegration demande : pendingRequests) { %>
                                <div class="request-item">
                                    <div class="request-info">
                                        <div class="member-avatar">
                                            <%= demande.getPrenomMembre().substring(0, 1).toUpperCase() %><%= demande.getNomMembre().substring(0, 1).toUpperCase() %>
                                        </div>
                                        <div>
                                            <strong><%= demande.getPrenomMembre() %> <%= demande.getNomMembre() %></strong><br>
                                            <small style="color: #666;"><%= demande.getEmailMembre() %></small><br>
                                            <small style="color: #999;"><i class="fas fa-clock"></i> <%= demande.getDateDemande() %></small>
                                        </div>
                                    </div>
                                    <div class="request-actions">
                                        <form method="post" action="<%= request.getContextPath() %>/president/valider-integration" style="display: inline;">
                                            <input type="hidden" name="demandeId" value="<%= demande.getId() %>">
                                            <input type="hidden" name="action" value="ACCEPTEE">
                                            <button type="submit" class="btn-approve" onclick="return confirm('Accepter cette demande d\'intégration ?')">
                                                <i class="fas fa-check"></i> Accepter
                                            </button>
                                        </form>
                                        <form method="post" action="<%= request.getContextPath() %>/president/valider-integration" style="display: inline;">
                                            <input type="hidden" name="demandeId" value="<%= demande.getId() %>">
                                            <input type="hidden" name="action" value="REFUSEE">
                                            <button type="submit" class="btn-reject" onclick="return confirm('Refuser cette demande d\'intégration ?')">
                                                <i class="fas fa-times"></i> Refuser
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            <% } %>
                        </div>
                    </div>
                </section>
            <% } %>

            <!-- Members List -->
            <section class="pending-requests">
                <h2><i class="fas fa-list"></i> Liste des Membres</h2>

                <% if (members != null && !members.isEmpty()) { %>
                    <div class="members-grid">
                        <% for (Utilisateur member : members) { %>
                            <div class="member-card">
                                <div class="member-card-header">
                                    <div class="member-avatar">
                                        <%= member.getPrenom().substring(0, 1).toUpperCase() %><%= member.getNom().substring(0, 1).toUpperCase() %>
                                    </div>
                                    <div style="flex: 1;">
                                        <strong style="font-size: 1.1rem; color: #1e3c72;"><%= member.getPrenom() %> <%= member.getNom() %></strong>
                                        <div>
                                            <span class="role-badge role-<%= member.getRole() %>">
                                                <%= member.getRole() %>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                                <div class="member-card-body">
                                    <div class="member-card-info">
                                        <i class="fas fa-envelope"></i>
                                        <span><%= member.getEmail() %></span>
                                    </div>
                                    <div class="member-card-info">
                                        <i class="fas fa-id-card"></i>
                                        <span>CIN: <%= member.getCin() != null ? member.getCin() : "N/A" %></span>
                                    </div>
                                </div>
                                <% if (!member.getId().equals(currentUser.getId())) { %>
                                    <div class="member-card-actions">
                                        <form method="post" action="<%= request.getContextPath() %>/president/retirer-membre" style="display: inline;">
                                            <input type="hidden" name="membreId" value="<%= member.getId() %>">
                                            <button type="submit" class="btn-remove" onclick="return confirm('Voulez-vous vraiment retirer <%= member.getPrenom() %> <%= member.getNom() %> du club ?')">
                                                <i class="fas fa-user-minus"></i> Retirer
                                            </button>
                                        </form>
                                    </div>
                                <% } else { %>
                                    <div class="member-card-actions">
                                        <span style="color: #999; font-size: 0.9rem;"><i class="fas fa-user"></i> Vous</span>
                                    </div>
                                <% } %>
                            </div>
                        <% } %>
                    </div>
                <% } else { %>
                    <div class="empty-state">
                        <i class="fas fa-users-slash"></i>
                        <h3>Aucun membre dans le club</h3>
                        <p>Les membres qui rejoindront votre club apparaîtront ici.</p>
                    </div>
                <% } %>
            </section>
        </main>
    </div>
</body>
</html>