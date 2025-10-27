<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
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
    Map<String, List<Utilisateur>> participantsByClub = (Map<String, List<Utilisateur>>) request.getAttribute("participantsByClub");
    Integer totalParticipants = (Integer) request.getAttribute("totalParticipants");
    Integer totalClubs = (Integer) request.getAttribute("totalClubs");
    
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
    <title>Détails Événement - <%= evenement.getTitre() %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/federation-dashboard.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        /* Additional styles for event details */
        .event-header-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem;
            border-radius: 12px;
            margin-bottom: 1.5rem;
        }

        .event-header-card h3 {
            font-size: 2rem;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .event-meta {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1rem;
            margin-top: 1rem;
        }

        .event-meta-item {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1rem;
        }

        .event-meta-item i {
            font-size: 1.2rem;
        }

        .club-group {
            margin-bottom: 2rem;
        }

        .club-group:last-child {
            margin-bottom: 0;
        }

        .club-header {
            background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 1rem 1.5rem;
            border-radius: 10px;
            margin-bottom: 1rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .club-header h4 {
            font-size: 1.2rem;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .club-badge {
            background: rgba(255, 255, 255, 0.3);
            padding: 0.3rem 0.8rem;
            border-radius: 20px;
            font-size: 0.9rem;
        }

        .participants-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 1rem;
        }

        .participant-card {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 1rem;
            display: flex;
            align-items: center;
            gap: 1rem;
            border-left: 4px solid #667eea;
            transition: all 0.3s ease;
        }

        .participant-card:hover {
            background: #e9ecef;
            transform: translateX(5px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .participant-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 1.2rem;
            flex-shrink: 0;
        }

        .participant-info h5 {
            margin: 0 0 0.3rem 0;
            color: #2c3e50;
            font-size: 1rem;
        }

        .participant-info p {
            margin: 0;
            color: #7f8c8d;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>
    <div class="federation-dashboard">
        <!-- Header -->
        <header class="dashboard-header">
            <div class="header-content">
                <h1><i class="fas fa-trophy"></i> Détails de l'Événement</h1>
                <div class="user-info">
                    <span>Bienvenue, <%= currentUser.getPrenom() %> <%= currentUser.getNom() %></span>
                    <a href="<%= request.getContextPath() %>/federation/dashboard" class="logout-btn">
                        <i class="fas fa-arrow-left"></i> Retour
                    </a>
                </div>
            </div>
        </header>

        <!-- Main Content -->
        <main class="dashboard-main">
            <!-- Event Information -->
            <section class="key-indicators">
                <div class="event-header-card">
                    <h3><i class="fas fa-calendar-alt"></i> <%= evenement.getTitre() %></h3>
                    <div class="event-meta">
                        <div class="event-meta-item">
                            <i class="fas fa-map-marker-alt"></i>
                            <span><strong>Lieu:</strong> <%= evenement.getLieu() != null ? evenement.getLieu() : "Non précisé" %></span>
                        </div>
                        <div class="event-meta-item">
                            <i class="fas fa-calendar"></i>
                            <span><strong>Date:</strong> <%= evenement.getDateDebut() %> au <%= evenement.getDateFin() %></span>
                        </div>
                        <div class="event-meta-item">
                            <i class="fas fa-info-circle"></i>
                            <span><strong>Statut:</strong> <span class="status-badge <%= evenement.getStatut() %>"><%= evenement.getStatut() %></span></span>
                        </div>
                    </div>
                    <% if (evenement.getDescription() != null && !evenement.getDescription().isEmpty()) { %>
                        <div style="margin-top: 1rem; padding-top: 1rem; border-top: 1px solid rgba(255,255,255,0.3);">
                            <p><%= evenement.getDescription() %></p>
                        </div>
                    <% } %>
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
                            <h3><%= totalParticipants != null ? totalParticipants : 0 %></h3>
                            <p>Participants Total</p>
                        </div>
                    </div>
                    <div class="indicator-card">
                        <div class="indicator-icon">
                            <i class="fas fa-chess-knight"></i>
                        </div>
                        <div class="indicator-content">
                            <h3><%= totalClubs != null ? totalClubs : 0 %></h3>
                            <p>Clubs Participants</p>
                        </div>
                    </div>
                    <div class="indicator-card">
                        <div class="indicator-icon">
                            <i class="fas fa-chart-line"></i>
                        </div>
                        <div class="indicator-content">
                            <h3><%= totalClubs != null && totalClubs > 0 ? String.format("%.1f", (double)totalParticipants / totalClubs) : "0" %></h3>
                            <p>Moyenne par Club</p>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Participants List -->
            <section class="pending-requests">
                <h2><i class="fas fa-list"></i> Liste des Participants par Club</h2>
                
                <% if (participantsByClub != null && !participantsByClub.isEmpty()) { %>
                    <% for (Map.Entry<String, List<Utilisateur>> entry : participantsByClub.entrySet()) { 
                        String clubName = entry.getKey();
                        List<Utilisateur> clubParticipants = entry.getValue();
                    %>
                        <div class="club-group">
                            <div class="club-header">
                                <h4><i class="fas fa-chess-knight"></i> <%= clubName %></h4>
                                <span class="club-badge"><%= clubParticipants.size() %> participant(s)</span>
                            </div>
                            
                            <div class="participants-grid">
                                <% for (Utilisateur participant : clubParticipants) { 
                                    String initials = (participant.getPrenom().substring(0, 1) + participant.getNom().substring(0, 1)).toUpperCase();
                                %>
                                    <div class="participant-card">
                                        <div class="participant-avatar"><%= initials %></div>
                                        <div class="participant-info">
                                            <h5><%= participant.getPrenom() %> <%= participant.getNom() %></h5>
                                            <p><i class="fas fa-envelope"></i> <%= participant.getEmail() %></p>
                                        </div>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                    <% } %>
                <% } else { %>
                    <p class="no-data">
                        <i class="fas fa-users-slash"></i><br>
                        Aucun club n'a encore sélectionné de représentants pour cet événement
                    </p>
                <% } %>
            </section>

            <!-- Podium Section -->
            <% if ("TERMINE".equals(evenement.getStatut())) { %>
                <section class="pending-requests">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
                        <h2><i class="fas fa-trophy"></i> Podium du Tournoi</h2>
                        <a href="<%= request.getContextPath() %>/federation/podium?evenementId=<%= evenement.getId() %>" 
                           class="btn btn-primary">
                            <i class="fas fa-edit"></i> 
                            <%= (evenement.getPremierId() != null || evenement.getDeuxiemeId() != null || evenement.getTroisiemeId() != null) ? "Modifier le Podium" : "Définir le Podium" %>
                        </a>
                    </div>

                    <% 
                        boolean hasPodium = evenement.getPremierId() != null || evenement.getDeuxiemeId() != null || evenement.getTroisiemeId() != null;
                        if (hasPodium) {
                            // Get podium winners from DAO
                            com.projet.jee.dao.UtilisateurDAO userDAO = new com.projet.jee.dao.UtilisateurDAO();
                            com.projet.jee.model.Utilisateur premier = null;
                            com.projet.jee.model.Utilisateur deuxieme = null;
                            com.projet.jee.model.Utilisateur troisieme = null;
                            
                            try {
                                if (evenement.getPremierId() != null) {
                                    premier = userDAO.findById(evenement.getPremierId());
                                }
                                if (evenement.getDeuxiemeId() != null) {
                                    deuxieme = userDAO.findById(evenement.getDeuxiemeId());
                                }
                                if (evenement.getTroisiemeId() != null) {
                                    troisieme = userDAO.findById(evenement.getTroisiemeId());
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                    %>
                        <div class="podium-display">
                            <style>
                                .podium-display {
                                    display: flex;
                                    justify-content: center;
                                    align-items: flex-end;
                                    gap: 2rem;
                                    padding: 2rem;
                                    background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                                    border-radius: 12px;
                                    min-height: 300px;
                                }

                                .podium-position {
                                    display: flex;
                                    flex-direction: column;
                                    align-items: center;
                                    text-align: center;
                                }

                                .podium-stand {
                                    background: white;
                                    border-radius: 12px 12px 0 0;
                                    padding: 1.5rem;
                                    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                                    min-width: 180px;
                                    position: relative;
                                }

                                .podium-stand.first {
                                    height: 200px;
                                    background: linear-gradient(135deg, #FFD700 0%, #FFA500 100%);
                                    order: 2;
                                }

                                .podium-stand.second {
                                    height: 160px;
                                    background: linear-gradient(135deg, #C0C0C0 0%, #A9A9A9 100%);
                                    order: 1;
                                }

                                .podium-stand.third {
                                    height: 120px;
                                    background: linear-gradient(135deg, #CD7F32 0%, #B8860B 100%);
                                    order: 3;
                                }

                                .podium-medal {
                                    width: 60px;
                                    height: 60px;
                                    border-radius: 50%;
                                    background: white;
                                    display: flex;
                                    align-items: center;
                                    justify-content: center;
                                    font-size: 2rem;
                                    margin: 0 auto 1rem;
                                    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
                                }

                                .podium-player-avatar {
                                    width: 70px;
                                    height: 70px;
                                    border-radius: 50%;
                                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                                    display: flex;
                                    align-items: center;
                                    justify-content: center;
                                    color: white;
                                    font-weight: bold;
                                    font-size: 1.8rem;
                                    margin: 0 auto 1rem;
                                    border: 4px solid white;
                                    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
                                }

                                .podium-player-name {
                                    font-weight: bold;
                                    font-size: 1.1rem;
                                    color: white;
                                    margin-bottom: 0.5rem;
                                }

                                .podium-rank {
                                    font-size: 2rem;
                                    font-weight: bold;
                                    color: white;
                                }

                                .empty-podium {
                                    text-align: center;
                                    padding: 3rem;
                                    color: #666;
                                }

                                .empty-podium i {
                                    font-size: 4rem;
                                    color: #ddd;
                                    margin-bottom: 1rem;
                                }

                                @media (max-width: 768px) {
                                    .podium-display {
                                        flex-direction: column;
                                        align-items: center;
                                    }

                                    .podium-stand.first,
                                    .podium-stand.second,
                                    .podium-stand.third {
                                        order: initial;
                                        width: 100%;
                                        max-width: 300px;
                                    }
                                }
                            </style>

                            <% if (deuxieme != null) { %>
                                <div class="podium-position">
                                    <div class="podium-stand second">
                                        <div class="podium-medal">🥈</div>
                                        <div class="podium-player-avatar">
                                            <%= deuxieme.getPrenom().substring(0, 1).toUpperCase() %><%= deuxieme.getNom().substring(0, 1).toUpperCase() %>
                                        </div>
                                        <div class="podium-player-name"><%= deuxieme.getPrenom() %> <%= deuxieme.getNom() %></div>
                                        <div class="podium-rank">2ème</div>
                                    </div>
                                </div>
                            <% } %>

                            <% if (premier != null) { %>
                                <div class="podium-position">
                                    <div class="podium-stand first">
                                        <div class="podium-medal">🏆</div>
                                        <div class="podium-player-avatar">
                                            <%= premier.getPrenom().substring(0, 1).toUpperCase() %><%= premier.getNom().substring(0, 1).toUpperCase() %>
                                        </div>
                                        <div class="podium-player-name"><%= premier.getPrenom() %> <%= premier.getNom() %></div>
                                        <div class="podium-rank">1er</div>
                                    </div>
                                </div>
                            <% } %>

                            <% if (troisieme != null) { %>
                                <div class="podium-position">
                                    <div class="podium-stand third">
                                        <div class="podium-medal">🥉</div>
                                        <div class="podium-player-avatar">
                                            <%= troisieme.getPrenom().substring(0, 1).toUpperCase() %><%= troisieme.getNom().substring(0, 1).toUpperCase() %>
                                        </div>
                                        <div class="podium-player-name"><%= troisieme.getPrenom() %> <%= troisieme.getNom() %></div>
                                        <div class="podium-rank">3ème</div>
                                    </div>
                                </div>
                            <% } %>
                        </div>
                    <% } else { %>
                        <div class="empty-podium">
                            <i class="fas fa-trophy"></i>
                            <h3>Podium non défini</h3>
                            <p>Cliquez sur "Définir le Podium" pour sélectionner les gagnants du tournoi</p>
                        </div>
                    <% } %>
                </section>
            <% } %>
        </main>
    </div>
</body>
</html>