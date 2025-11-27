<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chess Club Manager - Liste des événements</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .events-container {
            max-width: 1200px;
            width: 100%;
            margin: 0 auto;
        }
        
        .events-header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid rgba(30, 60, 114, 0.1);
        }
        
        .events-header h1 {
            color: #2c3e50;
            font-size: 2.5rem;
            margin-bottom: 10px;
            font-weight: 700;
        }
        
        .events-header p {
            color: #7f8c8d;
            font-size: 1.1rem;
            margin: 0;
        }
        
        .events-actions {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }
        
        .btn-new-event {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 12px 25px;
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            color: white;
            text-decoration: none;
            border-radius: 12px;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(30, 60, 114, 0.3);
        }
        
        .btn-new-event:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(30, 60, 114, 0.4);
            background: linear-gradient(135deg, #2a5298 0%, #3b5998 100%);
        }

        .btn-calendar {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 12px 25px;
            background: linear-gradient(135deg, #4CAF50 0%, #45a049 100%);
            color: white;
            text-decoration: none;
            border-radius: 12px;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(76, 175, 80, 0.3);
        }
        
        .btn-calendar:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(76, 175, 80, 0.4);
            background: linear-gradient(135deg, #45a049 0%, #3d8b40 100%);
        }
        
        .message {
            background: rgba(46, 204, 113, 0.1);
            border: 2px solid rgba(46, 204, 113, 0.3);
            color: #27ae60;
            padding: 15px 20px;
            border-radius: 12px;
            margin-bottom: 20px;
            text-align: center;
            font-weight: 500;
        }
        
        .events-table-container {
            background: rgba(255, 255, 255, 0.9);
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            overflow-x: auto;
        }
        
        .events-table {
            width: 100%;
            border-collapse: collapse;
            margin: 0;
        }
        
        .events-table th {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            color: white;
            padding: 15px 12px;
            text-align: left;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-size: 0.9rem;
        }
        
        .events-table th:first-child {
            border-top-left-radius: 10px;
        }
        
        .events-table th:last-child {
            border-top-right-radius: 10px;
        }
        
        .events-table td {
            padding: 15px 12px;
            border-bottom: 1px solid rgba(30, 60, 114, 0.1);
            color: #2c3e50;
            font-size: 0.95rem;
        }
        
        .events-table tr:hover {
            background: rgba(30, 60, 114, 0.05);
        }
        
        .events-table tr:last-child td:first-child {
            border-bottom-left-radius: 10px;
        }
        
        .events-table tr:last-child td:last-child {
            border-bottom-right-radius: 10px;
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
        
        .no-events {
            text-align: center;
            padding: 40px 20px;
            color: #7f8c8d;
            font-size: 1.1rem;
        }
        
        .no-events i {
            font-size: 3rem;
            margin-bottom: 15px;
            color: rgba(30, 60, 114, 0.3);
        }
        
        .action-buttons {
            display: flex;
            gap: 8px;
            justify-content: center;
            align-items: center;
        }
        
        .btn-action {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 35px;
            height: 35px;
            border-radius: 8px;
            text-decoration: none;
            font-size: 0.9rem;
            transition: all 0.3s ease;
            border: 2px solid transparent;
        }
        
        .btn-edit {
            background: rgba(52, 152, 219, 0.1);
            color: #3498db;
            border-color: rgba(52, 152, 219, 0.3);
        }
        
        .btn-edit:hover {
            background: rgba(52, 152, 219, 0.2);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(52, 152, 219, 0.3);
        }
        
        .btn-delete {
            background: rgba(231, 76, 60, 0.1);
            color: #e74c3c;
            border-color: rgba(231, 76, 60, 0.3);
        }
        
        .btn-delete:hover {
            background: rgba(231, 76, 60, 0.2);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(231, 76, 60, 0.3);
        }
        
        .btn-inscriptions {
            background: rgba(46, 204, 113, 0.1);
            color: #27ae60;
            border-color: rgba(46, 204, 113, 0.3);
        }
        
        .btn-inscriptions:hover {
            background: rgba(46, 204, 113, 0.2);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(46, 204, 113, 0.3);
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
        }
        
        .nav-btn:hover {
            background: rgba(52, 152, 219, 0.2);
            transform: translateY(-2px);
        }
        
        @media (max-width: 768px) {
            .events-container {
                margin: 10px;
            }
            
            .events-header h1 {
                font-size: 2rem;
            }
            
            .events-table-container {
                padding: 15px;
            }
            
            .events-table th,
            .events-table td {
                padding: 10px 8px;
                font-size: 0.85rem;
            }
        }
    </style>
</head>
<body>
    <div class="chess-background">
        <div class="container">
            <div class="dashboard-card events-container">
                <!-- Header -->
                <div class="events-header">
                    <div class="chess-logo">
                        <i class="fas fa-calendar-alt"></i>
                        <h1>Gestion des Événements</h1>
                        <p>Liste de tous les événements planifiés</p>
                    </div>
                </div>
                
                <!-- Message de succès -->
                <c:if test="${not empty sessionScope.message}">
                    <div class="message">
                        <i class="fas fa-check-circle"></i>
                        ${sessionScope.message}
                    </div>
                    <c:remove var="message" scope="session" />
                </c:if>
                
                <!-- Actions -->
                <div class="events-actions">
                    <a href="${pageContext.request.contextPath}/events?action=calendar" class="btn-calendar">
                        <i class="fas fa-calendar-alt"></i>
                        Vue Calendrier
                    </a>
                    <a href="${pageContext.request.contextPath}/events?action=new" class="btn-new-event">
                        <i class="fas fa-plus"></i>
                        Nouvel événement
                    </a>
                </div>
                
                <!-- Tableau des événements -->
                <div class="events-table-container">
                    <c:choose>
                        <c:when test="${empty events}">
                            <div class="no-events">
                                <i class="fas fa-calendar-times"></i>
                                <p>Aucun événement trouvé. Créez votre premier événement !</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <table class="events-table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Titre</th>
                                        <th>Lieu</th>
                                        <th>Date début</th>
                                        <th>Date fin</th>
                                        <th>Statut</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="e" items="${events}">
                                        <tr>
                                            <td>${e.id}</td>
                                            <td><strong>${e.titre}</strong></td>
                                            <td>${e.lieu}</td>
                                            <td>${e.dateDebut}</td>
                                            <td>${e.dateFin}</td>
                                            <td>
                                                <span class="status-badge status-${e.statut.toLowerCase()}">
                                                    ${e.statut}
                                                </span>
                                            </td>
                                            <td>
                                                <div class="action-buttons">
                                                    <!-- Bouton Modifier (seulement si événement pas encore terminé) -->
                                                    <c:if test="${e.statut != 'TERMINE'}">
                                                        <a href="${pageContext.request.contextPath}/events?action=edit&id=${e.id}" 
                                                           class="btn-action btn-edit" title="Modifier l'événement">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                    </c:if>
                                                    
                                                    <!-- Bouton Supprimer (seulement si événement pas encore démarré) -->
                                                    <c:if test="${e.statut == 'PLANIFIE'}">
                                                        <a href="${pageContext.request.contextPath}/events?action=delete&id=${e.id}" 
                                                           class="btn-action btn-delete" 
                                                           onclick="return confirm('Êtes-vous sûr de vouloir supprimer cet événement ?')"
                                                           title="Supprimer l'événement">
                                                            <i class="fas fa-trash"></i>
                                                        </a>
                                                    </c:if>
                                                    
                                                    <!-- Bouton Suivi des inscriptions -->
                                                    <a href="${pageContext.request.contextPath}/events?action=inscriptions&id=${e.id}" 
                                                       class="btn-action btn-inscriptions" title="Suivi des inscriptions">
                                                        <i class="fas fa-users"></i>
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <!-- Navigation de retour -->
                <div class="navigation">
                    <a href="${pageContext.request.contextPath}/federation/dashboard" class="nav-btn">
                        <i class="fas fa-home"></i>
                        Retour au dashboard
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
