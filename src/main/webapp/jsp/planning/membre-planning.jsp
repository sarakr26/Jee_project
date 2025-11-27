<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    com.projet.jee.model.Utilisateur currentUser = (com.projet.jee.model.Utilisateur) session.getAttribute("currentUser");
    if (currentUser == null || !"MEMBRE".equals(currentUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Planning des Entraînements - ${club.nom}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .planning-container {
            min-height: 100vh;
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            padding: 20px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .planning-header {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
        }

        .header-title h1 {
            color: #1e3c72;
            font-size: 2rem;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .header-title i {
            font-size: 2.5rem;
            color: #8B4513;
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
            margin-top: 15px;
        }

        .btn-secondary {
            background: #2196F3;
            color: white;
        }

        .btn-secondary:hover {
            background: #0b7dda;
        }

        .activities-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
        }

        .activities-header {
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
        }

        .activities-header h2 {
            color: #1e3c72;
            margin: 0;
        }

        .activities-list {
            display: grid;
            gap: 15px;
        }

        .activity-item {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            border-left: 4px solid #4CAF50;
        }

        .activity-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 10px;
        }

        .activity-title {
            font-size: 1.2rem;
            font-weight: 600;
            color: #1e3c72;
            margin: 0;
        }

        .activity-type {
            background: #2196F3;
            color: white;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
        }

        .activity-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 15px;
            color: #555;
        }

        .activity-detail {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .activity-detail i {
            color: #8B4513;
        }

        .no-activities {
            text-align: center;
            padding: 40px;
            color: #7f8c8d;
        }

        .no-activities i {
            font-size: 4rem;
            margin-bottom: 15px;
            opacity: 0.5;
        }
    </style>
</head>
<body>
    <div class="planning-container">
        <div class="planning-header">
            <div class="header-title">
                <i class="fas fa-calendar-alt"></i>
                <div>
                    <h1>Planning des Entraînements</h1>
                    <p style="color: #7f8c8d; font-size: 1rem; margin: 5px 0 0 0;">${club.nom}</p>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/membre/dashboard" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> Retour au tableau de bord
            </a>
        </div>

        <c:if test="${not empty error}">
            <div style="background: rgba(231, 76, 60, 0.1); border: 2px solid rgba(231, 76, 60, 0.3); color: #e74c3c; padding: 15px 20px; border-radius: 12px; margin-bottom: 20px; text-align: center;">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>

        <div class="activities-card">
            <div class="activities-header">
                <h2><i class="fas fa-list"></i> Activités à venir</h2>
            </div>

            <c:choose>
                <c:when test="${empty activites || activites.size() == 0}">
                    <div class="no-activities">
                        <i class="fas fa-calendar-times"></i>
                        <h3>Aucune activité planifiée</h3>
                        <p>Votre club n'a pas encore d'activités planifiées.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="activities-list">
                        <c:forEach var="activite" items="${activites}">
                            <div class="activity-item">
                                <div class="activity-header">
                                    <h3 class="activity-title">${activite.titre}</h3>
                                    <c:if test="${not empty activite.type}">
                                        <span class="activity-type">${activite.type}</span>
                                    </c:if>
                                </div>
                                
                                <div class="activity-details">
                                    <div class="activity-detail">
                                        <i class="fas fa-clock"></i>
                                        <span>
                                            <strong>Début:</strong> 
                                            <fmt:formatDate value="${activite.dateDebut}" pattern="dd/MM/yyyy à HH:mm" />
                                        </span>
                                    </div>
                                    <div class="activity-detail">
                                        <i class="fas fa-stop-circle"></i>
                                        <span>
                                            <strong>Fin:</strong> 
                                            <fmt:formatDate value="${activite.dateFin}" pattern="dd/MM/yyyy à HH:mm" />
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>


