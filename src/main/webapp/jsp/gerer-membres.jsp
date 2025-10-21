<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            padding: 20px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .header {
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
            color: #667eea;
        }

        .header-title h1 {
            color: #1e3c72;
            font-size: 2rem;
            margin: 0;
        }

        .header-subtitle {
            color: #666;
            font-size: 1rem;
            margin-top: 5px;
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

        .btn-secondary {
            background: #8B4513;
            color: white;
        }

        .btn-secondary:hover {
            background: #6d3410;
            transform: translateY(-2px);
        }

        .content-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
        }

        .section-title {
            font-size: 1.5rem;
            color: #1e3c72;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .stats-bar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            display: flex;
            justify-content: space-around;
            align-items: center;
        }

        .stat-item {
            text-align: center;
        }

        .stat-value {
            font-size: 2rem;
            font-weight: bold;
        }

        .stat-label {
            font-size: 0.9rem;
            opacity: 0.9;
        }

        .members-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        .members-table thead {
            background: #f8f9fa;
        }

        .members-table th {
            padding: 15px;
            text-align: left;
            font-weight: 600;
            color: #1e3c72;
            border-bottom: 2px solid #e0e0e0;
        }

        .members-table td {
            padding: 15px;
            border-bottom: 1px solid #f0f0f0;
        }

        .members-table tbody tr:hover {
            background: #f8f9fa;
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

        .role-badge {
            padding: 4px 12px;
            border-radius: 15px;
            font-size: 0.85rem;
            font-weight: 600;
        }

        .role-MEMBRE {
            background: #e3f2fd;
            color: #1976d2;
        }

        .role-PRESIDENT {
            background: #fff3e0;
            color: #f57c00;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }

        .empty-state i {
            font-size: 4rem;
            margin-bottom: 20px;
            color: #ddd;
        }

        .message {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .message-error {
            background: #f8d7da;
            color: #721c24;
            border-left: 4px solid #dc3545;
        }

        .message-success {
            background: #d4edda;
            color: #155724;
            border-left: 4px solid #28a745;
        }

        .pending-requests {
            background: #fff3cd;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 30px;
            border-left: 4px solid #ffc107;
        }

        .pending-requests h3 {
            color: #856404;
            margin-top: 0;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .request-item {
            background: white;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 10px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }

        .request-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .request-actions {
            display: flex;
            gap: 10px;
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
    <div class="container">
        <div class="header">
            <div class="header-title">
                <i class="fas fa-users"></i>
                <div>
                    <h1>Gestion des Membres</h1>
                    <p class="header-subtitle"><%= club != null ? club.getNom() : "" %></p>
                </div>
            </div>
            <a href="<%= request.getContextPath() %>/president/dashboard" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i>
                Retour au Dashboard
            </a>
        </div>

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

        <div class="content-card">
            <div class="stats-bar">
                <div class="stat-item">
                    <div class="stat-value"><%= members != null ? members.size() : 0 %></div>
                    <div class="stat-label">Membres Total</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value"><i class="fas fa-chess-knight"></i></div>
                    <div class="stat-label"><%= club != null ? club.getNom() : "" %></div>
                </div>
                <div class="stat-item">
                    <div class="stat-value"><i class="fas fa-check-circle"></i></div>
                    <div class="stat-label">Actif</div>
                </div>
            </div>

            <!-- Pending Integration Requests -->
            <% if (pendingRequests != null && !pendingRequests.isEmpty()) { %>
                <div class="pending-requests">
                    <h3>
                        <i class="fas fa-user-clock"></i>
                        Demandes d'Intégration en Attente (<%= pendingRequests.size() %>)
                    </h3>
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
            <% } %>

            <h2 class="section-title">
                <i class="fas fa-list"></i>
                Liste des Membres
            </h2>

            <% if (members != null && !members.isEmpty()) { %>
                <table class="members-table">
                    <thead>
                        <tr>
                            <th>Membre</th>
                            <th>Email</th>
                            <th>CIN</th>
                            <th>Rôle</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Utilisateur member : members) { %>
                            <tr>
                                <td>
                                    <div style="display: flex; align-items: center; gap: 15px;">
                                        <div class="member-avatar">
                                            <%= member.getPrenom().substring(0, 1).toUpperCase() %><%= member.getNom().substring(0, 1).toUpperCase() %>
                                        </div>
                                        <div>
                                            <strong><%= member.getPrenom() %> <%= member.getNom() %></strong>
                                        </div>
                                    </div>
                                </td>
                                <td><%= member.getEmail() %></td>
                                <td><%= member.getCin() != null ? member.getCin() : "N/A" %></td>
                                <td>
                                    <span class="role-badge role-<%= member.getRole() %>">
                                        <%= member.getRole() %>
                                    </span>
                                </td>
                                <td>
                                    <% if (!member.getId().equals(currentUser.getId())) { %>
                                        <form method="post" action="<%= request.getContextPath() %>/president/retirer-membre" style="display: inline;">
                                            <input type="hidden" name="membreId" value="<%= member.getId() %>">
                                            <button type="submit" class="btn-remove" onclick="return confirm('Voulez-vous vraiment retirer <%= member.getPrenom() %> <%= member.getNom() %> du club ?')">
                                                <i class="fas fa-user-minus"></i> Retirer
                                            </button>
                                        </form>
                                    <% } else { %>
                                        <span style="color: #999; font-size: 0.9rem;">Vous</span>
                                    <% } %>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } else { %>
                <div class="empty-state">
                    <i class="fas fa-users-slash"></i>
                    <h3>Aucun membre dans le club</h3>
                    <p>Les membres qui rejoindront votre club apparaîtront ici.</p>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>