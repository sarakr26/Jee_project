<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chess Club Manager - Détails du club</title>
    <link rel="stylesheet" href="../css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .detail-container {
            max-width: 800px;
            width: 100%;
            margin: 0 auto;
        }
        
        .detail-header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid rgba(139, 69, 19, 0.1);
        }
        
        .detail-header h1 {
            color: #2c3e50;
            font-size: 2.5rem;
            margin-bottom: 10px;
            font-weight: 700;
        }
        
        .detail-header p {
            color: #7f8c8d;
            font-size: 1.1rem;
            margin: 0;
        }
        
        .club-info-card {
            background: rgba(255, 255, 255, 0.9);
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
            position: relative;
            overflow: hidden;
        }
        
        .club-info-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #8B4513, #D2691E, #CD853F, #D2691E, #8B4513);
        }
        
        .club-title {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid rgba(139, 69, 19, 0.1);
        }
        
        .club-icon {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.8rem;
            box-shadow: 0 8px 20px rgba(139, 69, 19, 0.3);
        }
        
        .club-title-content h2 {
            color: #2c3e50;
            font-size: 1.8rem;
            margin: 0 0 5px 0;
            font-weight: 700;
        }
        
        .club-title-content p {
            color: #7f8c8d;
            margin: 0;
            font-size: 1rem;
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 25px;
        }
        
        .info-item {
            display: flex;
            align-items: flex-start;
            gap: 12px;
            padding: 15px;
            background: rgba(255, 255, 255, 0.6);
            border-radius: 12px;
            border: 1px solid rgba(139, 69, 19, 0.1);
            transition: all 0.3s ease;
        }
        
        .info-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(139, 69, 19, 0.1);
            border-color: #8B4513;
        }
        
        .info-icon {
            width: 40px;
            height: 40px;
            background: rgba(139, 69, 19, 0.1);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #8B4513;
            font-size: 1.2rem;
            flex-shrink: 0;
        }
        
        .info-content {
            flex: 1;
        }
        
        .info-label {
            font-weight: 600;
            color: #8B4513;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 5px;
        }
        
        .info-value {
            color: #2c3e50;
            font-size: 1rem;
            line-height: 1.4;
        }
        
        .description-section {
            margin-top: 25px;
            padding-top: 25px;
            border-top: 2px solid rgba(139, 69, 19, 0.1);
        }
        
        .description-content {
            background: rgba(139, 69, 19, 0.05);
            padding: 20px;
            border-radius: 12px;
            color: #2c3e50;
            line-height: 1.6;
            font-style: italic;
        }
        
        .actions-section {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-top: 30px;
            flex-wrap: wrap;
        }
        
        .btn-action {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 12px 25px;
            border-radius: 12px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            border: 2px solid transparent;
        }
        
        .btn-edit {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(30, 60, 114, 0.3);
        }
        
        .btn-edit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(30, 60, 114, 0.4);
            background: linear-gradient(135deg, #2a5298 0%, #3b5998 100%);
        }
        
        .btn-back {
            background: rgba(52, 152, 219, 0.1);
            color: #3498db;
            border-color: rgba(52, 152, 219, 0.3);
        }
        
        .btn-back:hover {
            background: rgba(52, 152, 219, 0.2);
            transform: translateY(-2px);
        }
        
        .not-found {
            text-align: center;
            padding: 60px 20px;
            background: rgba(255, 255, 255, 0.9);
            border-radius: 20px;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.1);
        }
        
        .not-found i {
            font-size: 4rem;
            color: rgba(231, 76, 60, 0.3);
            margin-bottom: 20px;
        }
        
        .not-found h2 {
            color: #2c3e50;
            font-size: 1.8rem;
            margin-bottom: 15px;
        }
        
        .not-found p {
            color: #7f8c8d;
            font-size: 1.1rem;
            margin-bottom: 25px;
        }
        
        @media (max-width: 768px) {
            .detail-container {
                margin: 10px;
            }
            
            .detail-header h1 {
                font-size: 2rem;
            }
            
            .club-info-card {
                padding: 20px;
            }
            
            .club-title {
                flex-direction: column;
                text-align: center;
                gap: 10px;
            }
            
            .info-grid {
                grid-template-columns: 1fr;
                gap: 15px;
            }
            
            .actions-section {
                flex-direction: column;
                align-items: center;
            }
            
            .btn-action {
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
            <div class="dashboard-card detail-container">
                <!-- Header -->
                <div class="detail-header">
                    <div class="chess-logo">
                        <i class="fas fa-chess-king"></i>
                        <h1>Détails du Club</h1>
                        <p>Informations complètes du club</p>
                    </div>
                </div>
                
                <c:choose>
                    <c:when test="${club == null}">
                        <div class="not-found">
                            <i class="fas fa-exclamation-triangle"></i>
                            <h2>Club non trouvé</h2>
                            <p>Le club que vous recherchez n'existe pas ou a été supprimé.</p>
                            <a href="${pageContext.request.contextPath}/clubs" class="btn-back">
                                <i class="fas fa-arrow-left"></i>
                                Retour à la liste
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- Informations du club -->
                        <div class="club-info-card">
                            <div class="club-title">
                                <div class="club-icon">
                                    <i class="fas fa-chess-rook"></i>
                                </div>
                                <div class="club-title-content">
                                    <h2>${club.nom}</h2>
                                    <p>Club d'échecs - ID: ${club.id}</p>
                                </div>
                            </div>
                            
                            <div class="info-grid">
                                <div class="info-item">
                                    <div class="info-icon">
                                        <i class="fas fa-image"></i>
                                    </div>
                                    <div class="info-content">
                                        <div class="info-label">Logo</div>
                                        <div class="info-value">
                                            <c:choose>
                                                <c:when test="${not empty club.logo}">
                                                    <img src="${club.logo}" alt="Logo du club" style="max-width: 100px; max-height: 100px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color: #7f8c8d; font-style: italic;">Aucun logo</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="info-item">
                                    <div class="info-icon">
                                        <i class="fas fa-info-circle"></i>
                                    </div>
                                    <div class="info-content">
                                        <div class="info-label">Statut</div>
                                        <div class="info-value">
                                            <c:choose>
                                                <c:when test="${club.statut == 'ACTIF'}">
                                                    <span style="color: #27ae60; font-weight: bold; font-size: 1.1rem;">✓ Actif</span>
                                                </c:when>
                                                <c:when test="${club.statut == 'EN_ATTENTE'}">
                                                    <span style="color: #f39c12; font-weight: bold;">⏳ En Attente</span>
                                                </c:when>
                                                <c:when test="${club.statut == 'SUSPENDU'}">
                                                    <span style="color: #e74c3c; font-weight: bold;">⚠ Suspendu</span>
                                                </c:when>
                                                <c:when test="${club.statut == 'REFUSE'}">
                                                    <span style="color: #c0392b; font-weight: bold;">✗ Refusé</span>
                                                </c:when>
                                                <c:when test="${club.statut == 'ARCHIVE'}">
                                                    <span style="color: #95a5a6; font-weight: bold;">🗄 Archivé</span>
                                                </c:when>
                                                <c:otherwise>${club.statut}</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="info-item">
                                    <div class="info-icon">
                                        <i class="fas fa-user-tie"></i>
                                    </div>
                                    <div class="info-content">
                                        <div class="info-label">Président</div>
                                        <div class="info-value">
                                            <c:choose>
                                                <c:when test="${not empty club.presidentId}">
                                                    ID: ${club.presidentId}
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color: #7f8c8d; font-style: italic;">Aucun président assigné</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <c:if test="${not empty club.description}">
                                <div class="description-section">
                                    <div class="info-item">
                                        <div class="info-icon">
                                            <i class="fas fa-align-left"></i>
                                        </div>
                                        <div class="info-content">
                                            <div class="info-label">Description</div>
                                            <div class="description-content">
                                                ${club.description}
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                        
                        <!-- Actions -->
                        <div class="actions-section">
                            <a href="${pageContext.request.contextPath}/clubs?action=edit&id=${club.id}" class="btn-action btn-edit">
                                <i class="fas fa-edit"></i>
                                Modifier le club
                            </a>
                            <a href="${pageContext.request.contextPath}/clubs" class="btn-action btn-back">
                                <i class="fas fa-list"></i>
                                Retour à la liste
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    
    <script src="../js/app.js"></script>
</body>
</html>
