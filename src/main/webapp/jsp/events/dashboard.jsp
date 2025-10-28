<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard des Événements - Gestion Clubs d'Échecs</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/events-dashboard.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <div class="events-dashboard">
        <!-- Header -->
        <header class="dashboard-header">
            <div class="header-content">
                <div class="header-left">
                    <a href="${pageContext.request.contextPath}/federation/dashboard" class="back-btn">
                        <i class="fas fa-arrow-left"></i> Retour
                    </a>
                    <h1><i class="fas fa-calendar-alt"></i> Dashboard des Événements</h1>
                </div>
                <div class="header-actions">
                    <a href="${pageContext.request.contextPath}/events?action=new" class="btn-create">
                        <i class="fas fa-plus"></i> Créer un Événement
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
                        <i class="fas fa-calendar-check"></i>
                    </div>
                    <div class="stat-content">
                        <h3>${events.size()}</h3>
                        <p>Total Événements</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon planned">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div class="stat-content">
                        <h3 id="plannedCount">0</h3>
                        <p>Planifiés</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon finished">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="stat-content">
                        <h3 id="finishedCount">0</h3>
                        <p>Terminés</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon cancelled">
                        <i class="fas fa-times-circle"></i>
                    </div>
                    <div class="stat-content">
                        <h3 id="cancelledCount">0</h3>
                        <p>Annulés</p>
                    </div>
                </div>
            </section>

            <!-- Events Grid -->
            <section class="events-section">
                <h2><i class="fas fa-list"></i> Tous les Événements</h2>
                
                <c:choose>
                    <c:when test="${empty events}">
                        <div class="no-data">
                            <i class="fas fa-calendar-times"></i>
                            <p>Aucun événement trouvé. Créez votre premier événement !</p>
                            <a href="${pageContext.request.contextPath}/events?action=new" class="btn-primary">
                                <i class="fas fa-plus"></i> Créer un Événement
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="events-grid">
                            <c:forEach var="event" items="${events}">
                                <div class="event-card ${event.statut.toLowerCase()}">
                                    <div class="event-header">
                                        <div class="event-status-badge">
                                            <c:choose>
                                                <c:when test="${event.statut == 'PLANIFIE'}">
                                                    <span class="status planned"><i class="fas fa-clock"></i> Planifié</span>
                                                </c:when>
                                                <c:when test="${event.statut == 'ANNULE'}">
                                                    <span class="status cancelled"><i class="fas fa-times"></i> Annulé</span>
                                                </c:when>
                                                <c:when test="${event.statut == 'TERMINE'}">
                                                    <span class="status finished"><i class="fas fa-check"></i> Terminé</span>
                                                </c:when>
                                            </c:choose>
                                        </div>
                                        <span class="event-id">#${event.id}</span>
                                    </div>
                                    
                                    <div class="event-body">
                                        <h3>${fn:escapeXml(event.titre)}</h3>
                                        
                                        <div class="event-info-item">
                                            <i class="fas fa-map-marker-alt"></i>
                                            <p><strong>Lieu:</strong> ${fn:escapeXml(event.lieu)}</p>
                                        </div>
                                        
                                        <div class="event-info-item">
                                            <i class="fas fa-calendar"></i>
                                            <p><strong>Date:</strong> 
                                                <fmtি="parseDate" value="${event.dateDebut}" pattern="yyyy-MM-dd" var="dateDebutParsed"/>
                                                <fmt:formatDate value="${dateDebutParsed}" pattern="dd/MM/yyyy"/>
                                                <c:if test="${not empty event.dateFin}">
                                                    <fmt:parseDate value="${event.dateFin}" pattern="yyyy-MM-dd" var="dateFinParsed"/>
                                                    &nbsp;-&nbsp;<fmt:formatDate value="${dateFinParsed}" pattern="dd/MM/yyyy"/>
                                                </c:if>
                                            </p>
                                        </div>
                                        
                                        <c:if test="${not empty event.description}">
                                            <div class="event-info-item">
                                                <i class="fas fa-info-circle"></i>
                                                <p>${fn:escapeXml(event.description)}</p>
                                            </div>
                                        </c:if>
                                    </div>
                                    
                                    <div class="event-actions">
                                        <a href="${pageContext.request.contextPath}/events?action=inscriptions&id=${event.id}" 
                                           class="btn-action btn-participants" title="Voir les participants">
                                            <i class="fas fa-users"></i> Participants
                                        </a>
                                        <c:if test="${event.statut != 'TERMINE'}">
                                            <a href="${pageContext.request.contextPath}/events?action=edit&id=${event.id}" 
                                               class="btn-action btn-edit" title="Modifier">
                                                <i class="fas fa-edit"></i> Modifier
                                            </a>
                                        </c:if>
                                        <c:if test="${event.statut == 'PLANIFIE'}">
                                            <a href="${pageContext.request.contextPath}/events?action=delete&id=${event.id}" 
                                               class="btn-action btn-delete" 
                                               onclick="return confirm('Êtes-vous sûr de vouloir supprimer cet événement ?')"
                                               title="Supprimer">
                                                <i class="fas fa-trash"></i> Supprimer
                                            </a>
                                        </c:if>
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
        // Compter les événements par statut
        document.addEventListener('DOMContentLoaded', function() {
            const events = document.querySelectorAll('.event-card');
            let planned = 0, finished = 0, cancelled = 0;
            
            events.forEach(event => {
                if (event.classList.contains('planifie')) planned++;
                else if (event.classList.contains('termine')) finished++;
                else if (event.classList.contains('annule')) cancelled++;
            });
            
            document.getElementById('plannedCount').textContent = planned;
            document.getElementById('finishedCount').textContent = finished;
            document.getElementById('cancelledCount').textContent = cancelled;
            
            // Animation des cartes au chargement
            events.forEach((card, index) => {
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

