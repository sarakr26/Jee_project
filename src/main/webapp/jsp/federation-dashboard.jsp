<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tableau de Bord Fédération - Gestion Clubs d'Échecs</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/federation-dashboard.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <div class="federation-dashboard">
        <!-- Header -->
        <header class="dashboard-header">
            <div class="header-content">
                <h1><i class="fas fa-chess-king"></i> Tableau de Bord Fédération</h1>
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
            <!-- Indicateurs Clés -->
            <section class="key-indicators">
                <h2><i class="fas fa-chart-line"></i> Indicateurs Clés</h2>
                <div class="indicators-grid">
                    <div class="indicator-card">
                        <div class="indicator-icon">
                            <i class="fas fa-chess-pawn"></i>
                        </div>
                        <div class="indicator-content">
                            <h3>${nombreClubsActifs}</h3>
                            <p>Clubs Actifs</p>
                        </div>
                    </div>
                    <div class="indicator-card">
                        <div class="indicator-icon">
                            <i class="fas fa-clock"></i>
                        </div>
                        <div class="indicator-content">
                            <h3>${demandesEnAttente}</h3>
                            <p>Demandes en Attente</p>
                        </div>
                    </div>
                    <div class="indicator-card">
                        <div class="indicator-icon">
                            <i class="fas fa-calendar-alt"></i>
                        </div>
                        <div class="indicator-content">
                            <h3>${evenementsProchains.size()}</h3>
                            <p>Événements Prochains</p>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Actions Rapides -->
            <section class="quick-actions">
                <h2><i class="fas fa-bolt"></i> Actions Rapides</h2>
                <div class="actions-grid">
                    <a href="${pageContext.request.contextPath}/events?action=new" class="action-btn">
                        <i class="fas fa-plus"></i>
                        <span>Créer un Événement</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/demandes/creation" class="action-btn">
                        <i class="fas fa-clipboard-check"></i>
                        <span>Valider Demandes</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/events" class="action-btn">
                        <i class="fas fa-list"></i>
                        <span>Gérer Événements</span>
                    </a>
                </div>
            </section>

            <!-- Contenu Principal -->
            <div class="dashboard-content">
                <!-- Demandes à Valider -->
                <section class="pending-requests">
                    <h2><i class="fas fa-clipboard-list"></i> Demandes à Valider</h2>
                    
                    <!-- Demandes de Création de Club -->
                    <div class="request-section">
                        <h3>Création de Clubs (${demandesCreationEnAttente})</h3>
                        <c:choose>
                            <c:when test="${empty demandesCreation}">
                                <p class="no-data">Aucune demande de création en attente</p>
                            </c:when>
                            <c:otherwise>
                                <div class="request-list">
                                    <c:forEach var="demande" items="${demandesCreation}" varStatus="status">
                                        <c:if test="${demande.statut == 'EN_ATTENTE'}">
                                            <div class="request-item">
                                                <div class="request-info">
                                                    <h4>${demande.nomClub}</h4>
                                                    <p><strong>Président:</strong> ${demande.nomPresident} ${demande.prenomPresident}</p>
                                                    <p><strong>Email:</strong> ${demande.emailPresident}</p>
                                                    <p><strong>Date:</strong> <fmt:formatDate value="${demande.dateDemande}" pattern="dd/MM/yyyy"/></p>
                                                </div>
                                                <div class="request-actions">
                                                    <button class="btn-approve" data-demande-id="${demande.id}" onclick="validerDemande(this.dataset.demandeId, 'APPROUVE')">
                                                        <i class="fas fa-check"></i> Valider
                                                    </button>
                                                    <button class="btn-reject" data-demande-id="${demande.id}" onclick="validerDemande(this.dataset.demandeId, 'REFUSE')">
                                                        <i class="fas fa-times"></i> Refuser
                                                    </button>
                                                </div>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                </section>

                <!-- Événements -->
                <section class="events-section">
                    <div class="events-grid">

                        <!-- Événements Prochains -->
                        <div class="events-upcoming">
                            <h3><i class="fas fa-calendar-alt"></i> Événements Prochains</h3>
                            <c:choose>
                                <c:when test="${empty evenementsProchains}">
                                    <p class="no-data">Aucun événement prochain</p>
                                </c:when>
                                <c:otherwise>
                                    <div class="event-list">
                                        <c:forEach var="event" items="${evenementsProchains}">
                                            <div class="event-item">
                                                <div class="event-info">
                                                    <h4>${fn:escapeXml(event.titre)}</h4>
                                                    <c:if test="${not empty event.lieu}">
                                                        <p><i class="fas fa-map-marker-alt"></i> ${fn:escapeXml(event.lieu)}</p>
                                                    </c:if>
                                                    <p><i class="fas fa-calendar"></i>
                                                        <fmt:formatDate value="${event.dateDebut}" pattern="dd/MM/yyyy"/>
                                                        <c:if test="${not empty event.dateFin}">
                                                            &nbsp;-&nbsp;<fmt:formatDate value="${event.dateFin}" pattern="dd/MM/yyyy"/>
                                                        </c:if>
                                                    </p>
                                                    <c:if test="${not empty event.description}">
                                                        <p class="event-desc">${fn:escapeXml(event.description)}</p>
                                                    </c:if>
                                                </div>
                                                <div class="event-status" title="${event.statut}">
                                                    <c:choose>
                                                        <c:when test="${event.statut == 'PLANIFIE'}">
                                                            <span class="status-badge planned"><i class="fas fa-clock"></i> Planifié</span>
                                                        </c:when>
                                                        <c:when test="${event.statut == 'ANNULE'}">
                                                            <span class="status-badge cancelled"><i class="fas fa-times"></i> Annulé</span>
                                                        </c:when>
                                                        <c:when test="${event.statut == 'TERMINE'}">
                                                            <span class="status-badge finished"><i class="fas fa-check"></i> Terminé</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-badge">${event.statut}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <a href="${pageContext.request.contextPath}/federation/event-details?id=${event.id}" 
                                                       class="btn-view-details" 
                                                       title="Voir les participants">
                                                        <i class="fas fa-eye"></i> Voir Détails
                                                    </a>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </section>
            </div>
        </main>
    </div>

    <script>
        // Améliorer la navigation et l'accessibilité
        document.addEventListener('DOMContentLoaded', function() {
            // S'assurer que tous les éléments sont accessibles
            const interactiveElements = document.querySelectorAll('button, .action-btn, .btn-approve, .btn-reject, a');
            interactiveElements.forEach(element => {
                element.style.pointerEvents = 'auto';
                element.style.cursor = 'pointer';
            });

            // Améliorer le scroll
            document.body.style.overflow = 'auto';
            document.documentElement.style.overflow = 'auto';

            // S'assurer que la page peut être scrollée
            window.addEventListener('scroll', function() {
                console.log('Page scrollable');
            });

            // Ajouter un indicateur de scroll si nécessaire
            const scrollIndicator = document.createElement('div');
            scrollIndicator.innerHTML = '↓ Faites défiler pour voir plus de contenu ↓';
            scrollIndicator.style.cssText = `
                position: fixed;
                bottom: 20px;
                left: 50%;
                transform: translateX(-50%);
                background: rgba(0,0,0,0.7);
                color: white;
                padding: 10px 20px;
                border-radius: 20px;
                z-index: 1000;
                font-size: 14px;
                animation: bounce 2s infinite;
            `;
            
            // Ajouter l'animation CSS
            const style = document.createElement('style');
            style.textContent = `
                @keyframes bounce {
                    0%, 20%, 50%, 80%, 100% { transform: translateX(-50%) translateY(0); }
                    40% { transform: translateX(-50%) translateY(-10px); }
                    60% { transform: translateX(-50%) translateY(-5px); }
                }
            `;
            document.head.appendChild(style);
            
            // Afficher l'indicateur seulement si le contenu dépasse la hauteur de l'écran
            setTimeout(() => {
                if (document.body.scrollHeight > window.innerHeight) {
                    document.body.appendChild(scrollIndicator);
                    // Masquer l'indicateur après 5 secondes
                    setTimeout(() => {
                        if (scrollIndicator.parentNode) {
                            scrollIndicator.parentNode.removeChild(scrollIndicator);
                        }
                    }, 5000);
                }
            }, 1000);
        });

        function validerDemande(demandeId, action) {
            if (confirm('Êtes-vous sûr de vouloir ' + (action === 'APPROUVE' ? 'valider' : 'refuser') + ' cette demande ?')) {
                fetch('${pageContext.request.contextPath}/valider/demande', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'type=creation&id=' + demandeId + '&action=' + action
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert(data.message);
                        location.reload(); // Recharger la page pour voir les changements
                    } else {
                        alert('Erreur: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Erreur:', error);
                    alert('Erreur lors de la validation');
                });
            }
        }

        function validerIntegration(demandeId, action) {
            if (confirm('Êtes-vous sûr de vouloir ' + (action === 'APPROUVE' ? 'valider' : 'refuser') + ' cette intégration ?')) {
                fetch('${pageContext.request.contextPath}/valider/demande', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'type=integration&id=' + demandeId + '&action=' + action
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert(data.message);
                        location.reload(); // Recharger la page pour voir les changements
                    } else {
                        alert('Erreur: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Erreur:', error);
                    alert('Erreur lors de la validation');
                });
            }
        }
    </script>
</body>
</html>
