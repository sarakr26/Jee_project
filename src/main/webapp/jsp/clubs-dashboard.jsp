<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard des Clubs - Gestion Clubs d'Échecs</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/clubs-dashboard.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <div class="clubs-dashboard">
        <!-- Header -->
        <header class="dashboard-header">
            <div class="header-content">
                <div class="header-left">
                    <a href="${pageContext.request.contextPath}/federation/dashboard" class="back-btn">
                        <i class="fas fa-arrow-left"></i> Retour
                    </a>
                    <h1><i class="fas fa-chess-knight"></i> Dashboard des Clubs</h1>
                </div>
                <div class="user-info">
                    <span>Bienvenue, ${sessionScope.currentUser.prenom} ${sessionScope.currentUser.nom}</span>
                    <a href="${pageContext.request.contextPath}/logout" class="logout-btn">
                        <i class="fas fa-sign-out-alt"></i> Déconnexion
                    </a>
                </div>
            </div>
        </header>

        <!-- Main Content -->
        <main class="dashboard-main">
            <!-- Stats Summary -->
            <section class="stats-summary">
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-chess-pawn"></i>
                    </div>
                    <div class="stat-content">
                        <h3>${nombreClubs}</h3>
                        <p>Clubs Actifs</p>
                    </div>
                </div>
            </section>

            <!-- Clubs Grid -->
            <section class="clubs-section">
                <h2><i class="fas fa-list"></i> Liste des Clubs</h2>
                
                <c:choose>
                    <c:when test="${empty clubsInfo}">
                        <div class="no-data">
                            <i class="fas fa-chess-pawn"></i>
                            <p>Aucun club actif trouvé</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="clubs-grid">
                            <c:forEach var="clubInfo" items="${clubsInfo}">
                                <div class="club-card">
                                    <div class="club-header">
                                        <c:set var="club" value="${clubInfo.club}" />
                                        <c:if test="${not empty club.logo}">
                                            <div class="club-logo">
                                                <img src="${pageContext.request.contextPath}/${club.logo}" 
                                                     alt="Logo ${fn:escapeXml(club.nom)}" 
                                                     onerror="this.style.display='none'">
                                            </div>
                                        </c:if>
                                        <div class="club-title">
                                            <h3>${fn:escapeXml(club.nom)}</h3>
                                            <span class="status-badge active">
                                                <i class="fas fa-check-circle"></i> Actif
                                            </span>
                                        </div>
                                    </div>
                                    
                                    <div class="club-body">
                                        <c:if test="${not empty club.description}">
                                            <div class="club-info-item">
                                                <i class="fas fa-info-circle"></i>
                                                <p>${fn:escapeXml(club.description)}</p>
                                            </div>
                                        </c:if>
                                        
                                        <c:set var="president" value="${clubInfo.president}" />
                                        <c:if test="${not empty president}">
                                            <div class="club-info-item">
                                                <i class="fas fa-user-tie"></i>
                                                <p><strong>Président:</strong> ${fn:escapeXml(president.prenom)} ${fn:escapeXml(president.nom)}</p>
                                            </div>
                                            <div class="club-info-item">
                                                <i class="fas fa-envelope"></i>
                                                <p><strong>Email:</strong> ${fn:escapeXml(president.email)}</p>
                                            </div>
                                            <c:if test="${not empty president.cin}">
                                                <div class="club-info-item">
                                                    <i class="fas fa-id-card"></i>
                                                    <p><strong>CIN:</strong> ${fn:escapeXml(president.cin)}</p>
                                                </div>
                                            </c:if>
                                        </c:if>
                                        
                                        <div class="club-info-item">
                                            <i class="fas fa-users"></i>
                                            <p><strong>Membres:</strong> ${clubInfo.nombreMembres}</p>
                                        </div>
                                        
                                        <div class="club-info-item">
                                            <i class="fas fa-hashtag"></i>
                                            <p><strong>ID:</strong> ${club.id}</p>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </section>
        </main>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Animation des cartes au chargement
            const cards = document.querySelectorAll('.club-card');
            cards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';
                setTimeout(() => {
                    card.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 100);
            });
        });
    </script>
</body>
</html>

