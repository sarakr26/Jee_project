<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chess Club Manager - Suivi des inscriptions</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .inscriptions-container {
            max-width: 1200px;
            width: 100%;
            margin: 0 auto;
        }
        
        .inscriptions-header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid rgba(30, 60, 114, 0.1);
        }
        
        .inscriptions-header h1 {
            color: #2c3e50;
            font-size: 2.5rem;
            margin-bottom: 10px;
            font-weight: 700;
        }
        
        .inscriptions-header p {
            color: #7f8c8d;
            font-size: 1.1rem;
            margin: 0;
        }
        
        .event-info-card {
            background: rgba(255, 255, 255, 0.9);
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            border-left: 5px solid #1e3c72;
        }
        
        .event-info-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #1e3c72;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .event-info-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 15px;
            margin-bottom: 15px;
        }
        
        .event-detail {
            display: flex;
            align-items: center;
            gap: 10px;
            color: #2c3e50;
        }
        
        .event-detail i {
            color: #1e3c72;
            width: 20px;
        }
        
        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: rgba(255, 255, 255, 0.9);
            border-radius: 15px;
            padding: 20px;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
        }
        
        .stat-number {
            font-size: 2.5rem;
            font-weight: 700;
            color: #1e3c72;
            margin-bottom: 10px;
        }
        
        .stat-label {
            color: #7f8c8d;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .participants-card {
            background: rgba(255, 255, 255, 0.9);
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }
        
        .participants-header {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 20px;
            color: #1e3c72;
            font-size: 1.3rem;
            font-weight: 700;
        }
        
        .participants-list {
            max-height: 400px;
            overflow-y: auto;
        }
        
        .participant-item {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 12px 15px;
            margin-bottom: 8px;
            background: rgba(30, 60, 114, 0.05);
            border-radius: 10px;
            border-left: 4px solid #1e3c72;
            transition: all 0.3s ease;
        }
        
        .participant-item:hover {
            background: rgba(30, 60, 114, 0.1);
            transform: translateX(5px);
        }
        
        .participant-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            font-size: 1.1rem;
        }
        
        .participant-info {
            flex: 1;
        }
        
        .participant-name {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 2px;
        }
        
        .participant-club {
            color: #7f8c8d;
            font-size: 0.9rem;
        }
        
        .no-participants {
            text-align: center;
            padding: 40px 20px;
            color: #7f8c8d;
            font-size: 1.1rem;
        }
        
        .no-participants i {
            font-size: 3rem;
            margin-bottom: 15px;
            color: rgba(30, 60, 114, 0.3);
        }
        
        .navigation {
            text-align: center;
            margin-top: 30px;
        }
        
        .nav-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 20px;
            background: rgba(52, 152, 219, 0.1);
            color: #3498db;
            text-decoration: none;
            border-radius: 12px;
            font-weight: 600;
            transition: all 0.3s ease;
            border: 2px solid rgba(52, 152, 219, 0.3);
            margin: 0 10px;
        }
        
        .nav-btn:hover {
            background: rgba(52, 152, 219, 0.2);
            transform: translateY(-2px);
        }
        
        .nav-btn.primary {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            color: white;
            border-color: transparent;
        }
        
        .nav-btn.primary:hover {
            background: linear-gradient(135deg, #2a5298 0%, #3b5998 100%);
            box-shadow: 0 8px 25px rgba(30, 60, 114, 0.4);
        }
        
        .status-badge {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .status-planifie {
            background: rgba(52, 152, 219, 0.1);
            color: #3498db;
            border: 1px solid rgba(52, 152, 219, 0.3);
        }
        
        .status-annule {
            background: rgba(231, 76, 60, 0.1);
            color: #e74c3c;
            border: 1px solid rgba(231, 76, 60, 0.3);
        }
        
        .status-termine {
            background: rgba(46, 204, 113, 0.1);
            color: #27ae60;
            border: 1px solid rgba(46, 204, 113, 0.3);
        }
        
        @media (max-width: 768px) {
            .inscriptions-container {
                margin: 10px;
            }
            
            .inscriptions-header h1 {
                font-size: 2rem;
            }
            
            .event-info-details {
                grid-template-columns: 1fr;
            }
            
            .stats-container {
                grid-template-columns: 1fr;
            }
            
            .navigation {
                display: flex;
                flex-direction: column;
                gap: 10px;
                align-items: center;
            }
            
            .nav-btn {
                margin: 0;
                width: 100%;
                max-width: 250px;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <div class="chess-background">
        <div class="container">
            <div class="dashboard-card inscriptions-container">
                <!-- Header -->
                <div class="inscriptions-header">
                    <div class="chess-logo">
                        <i class="fas fa-users"></i>
                        <h1>Suivi des Inscriptions</h1>
                        <p>Liste des participants à l'événement</p>
                    </div>
                </div>
                
                <!-- Informations sur l'événement -->
                <div class="event-info-card">
                    <div class="event-info-title">
                        <i class="fas fa-calendar-alt"></i>
                        ${evenement.titre}
                    </div>
                    
                    <div class="event-info-details">
                        <c:if test="${not empty evenement.lieu}">
                            <div class="event-detail">
                                <i class="fas fa-map-marker-alt"></i>
                                <span>${evenement.lieu}</span>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty evenement.dateDebut}">
                            <div class="event-detail">
                                <i class="fas fa-calendar"></i>
                                <span>Du ${evenement.dateDebut}</span>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty evenement.dateFin}">
                            <div class="event-detail">
                                <i class="fas fa-calendar-check"></i>
                                <span>Au ${evenement.dateFin}</span>
                            </div>
                        </c:if>
                        
                        <div class="event-detail">
                            <i class="fas fa-info-circle"></i>
                            <span class="status-badge status-${evenement.statut.toLowerCase()}">${evenement.statut}</span>
                        </div>
                    </div>
                    
                    <c:if test="${not empty evenement.description}">
                        <div class="event-detail">
                            <i class="fas fa-align-left"></i>
                            <span>${evenement.description}</span>
                        </div>
                    </c:if>
                </div>
                
                <!-- Statistiques -->
                <div class="stats-container">
                    <div class="stat-card">
                        <div class="stat-number">${nbParticipants}</div>
                        <div class="stat-label">Participants inscrits</div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-number">${participants.size()}</div>
                        <div class="stat-label">Joueurs confirmés</div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-number">
                            <c:choose>
                                <c:when test="${nbParticipants > 0}">
                                    ${Math.round((participants.size() * 100.0) / nbParticipants)}%
                                </c:when>
                                <c:otherwise>0%</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="stat-label">Taux de confirmation</div>
                    </div>
                </div>
                
                <!-- Liste des participants -->
                <div class="participants-card">
                    <div class="participants-header">
                        <i class="fas fa-list"></i>
                        Liste des Participants
                    </div>
                    
                    <div class="participants-list">
                        <c:choose>
                            <c:when test="${empty participants}">
                                <div class="no-participants">
                                    <i class="fas fa-user-times"></i>
                                    <p>Aucun participant inscrit pour le moment.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="participant" items="${participants}" varStatus="status">
                                    <div class="participant-item">
                                        <div class="participant-avatar">
                                            ${participant.substring(0, 1).toUpperCase()}
                                        </div>
                                        <div class="participant-info">
                                            <div class="participant-name">
                                                <c:choose>
                                                    <c:when test="${participant.contains('(')}">
                                                        ${participant.substring(0, participant.indexOf('(') - 1)}
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${participant}
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <c:if test="${participant.contains('(')}">
                                                <div class="participant-club">
                                                    ${participant.substring(participant.indexOf('(') + 1, participant.indexOf(')'))}
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                
                <!-- Navigation -->
                <div class="navigation">
                    <a href="${pageContext.request.contextPath}/events" class="nav-btn primary">
                        <i class="fas fa-arrow-left"></i>
                        Retour à la liste des événements
                    </a>
                    <a href="${pageContext.request.contextPath}/federation/dashboard" class="nav-btn">
                        <i class="fas fa-home"></i>
                        Dashboard
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
