<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chess Club Manager - Liste des clubs</title>
    <link rel="stylesheet" href="../css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .clubs-container {
            max-width: 1200px;
            width: 100%;
            margin: 0 auto;
        }
        
        .clubs-header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid rgba(139, 69, 19, 0.1);
        }
        
        .clubs-header h1 {
            color: #2c3e50;
            font-size: 2.5rem;
            margin-bottom: 10px;
            font-weight: 700;
        }
        
        .clubs-header p {
            color: #7f8c8d;
            font-size: 1.1rem;
            margin: 0;
        }
        
        .clubs-actions {
            display: flex;
            justify-content: center;
            margin-bottom: 30px;
        }
        
        .btn-new-club {
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
        
        .btn-new-club:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(30, 60, 114, 0.4);
            background: linear-gradient(135deg, #2a5298 0%, #3b5998 100%);
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
        
        .clubs-table-container {
            background: rgba(255, 255, 255, 0.9);
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            overflow-x: auto;
        }
        
        .clubs-table {
            width: 100%;
            border-collapse: collapse;
            margin: 0;
        }
        
        .clubs-table th {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            color: white;
            padding: 15px 12px;
            text-align: left;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-size: 0.9rem;
        }
        
        .clubs-table th:first-child {
            border-top-left-radius: 10px;
        }
        
        .clubs-table th:last-child {
            border-top-right-radius: 10px;
        }
        
        .clubs-table td {
            padding: 15px 12px;
            border-bottom: 1px solid rgba(139, 69, 19, 0.1);
            color: #2c3e50;
            font-size: 0.95rem;
        }
        
        .clubs-table tr:hover {
            background: rgba(30, 60, 114, 0.05);
        }
        
        .clubs-table tr:last-child td:first-child {
            border-bottom-left-radius: 10px;
        }
        
        .clubs-table tr:last-child td:last-child {
            border-bottom-right-radius: 10px;
        }
        
        .action-links {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }
        
        .action-link {
            padding: 6px 12px;
            border-radius: 8px;
            text-decoration: none;
            font-size: 0.85rem;
            font-weight: 500;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }
        
        .action-link.details {
            background: rgba(52, 152, 219, 0.1);
            color: #3498db;
            border: 1px solid rgba(52, 152, 219, 0.3);
        }
        
        .action-link.details:hover {
            background: rgba(52, 152, 219, 0.2);
            transform: translateY(-1px);
        }
        
        .action-link.edit {
            background: rgba(241, 196, 15, 0.1);
            color: #f1c40f;
            border: 1px solid rgba(241, 196, 15, 0.3);
        }
        
        .action-link.edit:hover {
            background: rgba(241, 196, 15, 0.2);
            transform: translateY(-1px);
        }
        
        .action-link.delete {
            background: rgba(231, 76, 60, 0.1);
            color: #e74c3c;
            border: 1px solid rgba(231, 76, 60, 0.3);
        }
        
        .action-link.delete:hover {
            background: rgba(231, 76, 60, 0.2);
            transform: translateY(-1px);
        }
        
        .no-clubs {
            text-align: center;
            padding: 40px 20px;
            color: #7f8c8d;
            font-size: 1.1rem;
        }
        
        .no-clubs i {
            font-size: 3rem;
            margin-bottom: 15px;
            color: rgba(139, 69, 19, 0.3);
        }
        
        @media (max-width: 768px) {
            .clubs-container {
                margin: 10px;
            }
            
            .clubs-header h1 {
                font-size: 2rem;
            }
            
            .clubs-table-container {
                padding: 15px;
            }
            
            .clubs-table th,
            .clubs-table td {
                padding: 10px 8px;
                font-size: 0.85rem;
            }
            
            .action-links {
                flex-direction: column;
                gap: 4px;
            }
        }
    </style>
</head>
<body>
    <div class="chess-background">
        <div class="container">
            <div class="dashboard-card clubs-container">
                <!-- Header -->
                <div class="clubs-header">
                    <div class="chess-logo">
                        <i class="fas fa-chess-rook"></i>
                        <h1>Gestion des Clubs</h1>
                        <p>Liste de tous les clubs d'échecs</p>
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
                <div class="clubs-actions">
                    <a href="${pageContext.request.contextPath}/clubs?action=new" class="btn-new-club">
                        <i class="fas fa-plus"></i>
                        Nouveau club
                    </a>
                </div>
                
                <!-- Tableau des clubs -->
                <div class="clubs-table-container">
                    <c:choose>
                        <c:when test="${empty clubs}">
                            <div class="no-clubs">
                                <i class="fas fa-chess-board"></i>
                                <p>Aucun club trouvé. Créez votre premier club !</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <table class="clubs-table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Nom</th>
                                        <th>Logo</th>
                                        <th>Statut</th>
                                        <th>Président ID</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="c" items="${clubs}">
                                        <tr>
                                            <td>${c.id}</td>
                                            <td><strong>${c.nom}</strong></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty c.logo}">
                                                        <img src="${c.logo}" alt="Logo" style="max-width: 40px; max-height: 40px; border-radius: 5px;">
                                                    </c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${c.statut == 'ACTIF'}"><span style="color: #27ae60; font-weight: bold;">✓ Actif</span></c:when>
                                                    <c:when test="${c.statut == 'EN_ATTENTE'}"><span style="color: #f39c12;">⏳ En Attente</span></c:when>
                                                    <c:when test="${c.statut == 'SUSPENDU'}"><span style="color: #e74c3c;">⚠ Suspendu</span></c:when>
                                                    <c:when test="${c.statut == 'REFUSE'}"><span style="color: #c0392b;">✗ Refusé</span></c:when>
                                                    <c:when test="${c.statut == 'ARCHIVE'}"><span style="color: #95a5a6;">🗄 Archivé</span></c:when>
                                                    <c:otherwise>${c.statut}</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td><c:out value="${c.presidentId}" default="-"/></td>
                                            <td>
                                                <div class="action-links">
                                                    <a href="${pageContext.request.contextPath}/clubs?id=${c.id}" class="action-link details">
                                                        <i class="fas fa-eye"></i>
                                                        Détails
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/clubs?action=edit&id=${c.id}" class="action-link edit">
                                                        <i class="fas fa-edit"></i>
                                                        Modifier
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/clubs?action=delete&id=${c.id}" 
                                                       class="action-link delete" 
                                                       onclick="return confirm('Êtes-vous sûr de vouloir supprimer ce club ?')">
                                                        <i class="fas fa-trash"></i>
                                                        Supprimer
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
                <div style="text-align: center; margin-top: 30px;">
                    <a href="${pageContext.request.contextPath}/" class="nav-btn">
                        <i class="fas fa-home"></i>
                        Retour à l'accueil
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <script src="../js/app.js"></script>
</body>
</html>
