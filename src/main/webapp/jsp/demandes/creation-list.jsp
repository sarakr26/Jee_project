<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chess Club Manager - Demandes de création de club</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .demandes-container {
            max-width: 1400px;
            width: 100%;
            margin: 0 auto;
        }
        
        .demandes-header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid rgba(30, 60, 114, 0.1);
        }
        
        .demandes-header h1 {
            color: #2c3e50;
            font-size: 2.5rem;
            margin-bottom: 10px;
            font-weight: 700;
        }
        
        .demandes-header p {
            color: #7f8c8d;
            font-size: 1.1rem;
            margin: 0;
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
            border-left: 5px solid;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
        }
        
        .stat-card.pending {
            border-left-color: #f39c12;
        }
        
        .stat-card.accepted {
            border-left-color: #27ae60;
        }
        
        .stat-card.rejected {
            border-left-color: #e74c3c;
        }
        
        .stat-number {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 10px;
        }
        
        .stat-card.pending .stat-number {
            color: #f39c12;
        }
        
        .stat-card.accepted .stat-number {
            color: #27ae60;
        }
        
        .stat-card.rejected .stat-number {
            color: #e74c3c;
        }
        
        .stat-label {
            color: #7f8c8d;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
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
        
        .error {
            background: rgba(231, 76, 60, 0.1);
            border: 2px solid rgba(231, 76, 60, 0.3);
            color: #e74c3c;
        }
        
        .demandes-table-container {
            background: rgba(255, 255, 255, 0.9);
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            overflow-x: auto;
        }
        
        .demandes-table {
            width: 100%;
            border-collapse: collapse;
            margin: 0;
        }
        
        .demandes-table th {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            color: white;
            padding: 15px 12px;
            text-align: left;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-size: 0.9rem;
        }
        
        .demandes-table th:first-child {
            border-top-left-radius: 10px;
        }
        
        .demandes-table th:last-child {
            border-top-right-radius: 10px;
        }
        
        .demandes-table td {
            padding: 15px 12px;
            border-bottom: 1px solid rgba(30, 60, 114, 0.1);
            color: #2c3e50;
            font-size: 0.95rem;
            vertical-align: middle;
        }
        
        .demandes-table tr:hover {
            background: rgba(30, 60, 114, 0.05);
        }
        
        .demandes-table tr:last-child td:first-child {
            border-bottom-left-radius: 10px;
        }
        
        .demandes-table tr:last-child td:last-child {
            border-bottom-right-radius: 10px;
        }
        
        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        
        .status-en_attente {
            background: rgba(243, 156, 18, 0.1);
            color: #f39c12;
            border: 1px solid rgba(243, 156, 18, 0.3);
        }
        
        .status-acceptee {
            background: rgba(46, 204, 113, 0.1);
            color: #27ae60;
            border: 1px solid rgba(46, 204, 113, 0.3);
        }
        
        .status-refusee {
            background: rgba(231, 76, 60, 0.1);
            color: #e74c3c;
            border: 1px solid rgba(231, 76, 60, 0.3);
        }
        
        .president-info {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .president-avatar {
            width: 35px;
            height: 35px;
            border-radius: 50%;
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            font-size: 0.9rem;
        }
        
        .president-details {
            flex: 1;
        }
        
        .president-name {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 2px;
        }
        
        .president-email {
            color: #7f8c8d;
            font-size: 0.85rem;
        }
        
        .club-info {
            max-width: 250px;
        }
        
        .club-name {
            font-weight: 600;
            color: #1e3c72;
            margin-bottom: 5px;
        }
        
        .club-description {
            color: #7f8c8d;
            font-size: 0.85rem;
            line-height: 1.3;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
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
            cursor: pointer;
            background: none;
        }
        
        .btn-action:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none !important;
        }
        
        .btn-action.loading {
            opacity: 0.7;
        }
        
        .btn-action.loading i {
            animation: spin 1s linear infinite;
        }
        
        @keyframes spin {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }
        
        .btn-approve {
            background: rgba(46, 204, 113, 0.1);
            color: #27ae60;
            border-color: rgba(46, 204, 113, 0.3);
        }
        
        .btn-approve:hover {
            background: rgba(46, 204, 113, 0.2);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(46, 204, 113, 0.3);
        }
        
        .btn-reject {
            background: rgba(231, 76, 60, 0.1);
            color: #e74c3c;
            border-color: rgba(231, 76, 60, 0.3);
        }
        
        .btn-reject:hover {
            background: rgba(231, 76, 60, 0.2);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(231, 76, 60, 0.3);
        }
        
        .btn-view {
            background: rgba(52, 152, 219, 0.1);
            color: #3498db;
            border-color: rgba(52, 152, 219, 0.3);
        }
        
        .btn-view:hover {
            background: rgba(52, 152, 219, 0.2);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(52, 152, 219, 0.3);
        }
        
        .no-demandes {
            text-align: center;
            padding: 40px 20px;
            color: #7f8c8d;
            font-size: 1.1rem;
        }
        
        .no-demandes i {
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
        
        .logo-preview {
            width: 40px;
            height: 40px;
            border-radius: 8px;
            object-fit: cover;
            border: 2px solid rgba(30, 60, 114, 0.2);
        }
        
        .logo-placeholder {
            width: 40px;
            height: 40px;
            border-radius: 8px;
            background: rgba(30, 60, 114, 0.1);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #1e3c72;
            font-size: 1.2rem;
        }
        
        @media (max-width: 768px) {
            .demandes-container {
                margin: 10px;
            }
            
            .demandes-header h1 {
                font-size: 2rem;
            }
            
            .stats-container {
                grid-template-columns: 1fr;
            }
            
            .demandes-table-container {
                padding: 15px;
            }
            
            .demandes-table th,
            .demandes-table td {
                padding: 10px 8px;
                font-size: 0.85rem;
            }
            
            .club-info {
                max-width: 200px;
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
            <div class="dashboard-card demandes-container">
                <!-- Header -->
                <div class="demandes-header">
                    <div class="chess-logo">
                        <i class="fas fa-clipboard-list"></i>
                        <h1>Demandes de Création de Club</h1>
                        <p>Gestion des demandes de création de nouveaux clubs d'échecs</p>
                    </div>
                </div>
                
                <!-- Statistiques -->
                <div class="stats-container">
                    <div class="stat-card pending">
                        <div class="stat-number">${demandesEnAttente}</div>
                        <div class="stat-label">En attente</div>
                    </div>
                    
                    <div class="stat-card accepted">
                        <div class="stat-number">${demandesAcceptees}</div>
                        <div class="stat-label">Acceptées</div>
                    </div>
                    
                    <div class="stat-card rejected">
                        <div class="stat-number">${demandesRefusees}</div>
                        <div class="stat-label">Refusées</div>
                    </div>
                </div>
                
                <!-- Messages -->
                <c:if test="${not empty sessionScope.message}">
                    <div class="message">
                        <i class="fas fa-check-circle"></i>
                        ${sessionScope.message}
                    </div>
                    <c:remove var="message" scope="session" />
                </c:if>
                
                <c:if test="${not empty error}">
                    <div class="message error">
                        <i class="fas fa-exclamation-triangle"></i>
                        ${error}
                    </div>
                </c:if>
                
                <!-- Tableau des demandes -->
                <div class="demandes-table-container">
                    <c:choose>
                        <c:when test="${empty demandes}">
                            <div class="no-demandes">
                                <i class="fas fa-inbox"></i>
                                <p>Aucune demande de création de club trouvée.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <table class="demandes-table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Logo</th>
                                        <th>Club</th>
                                        <th>Président</th>
                                        <th>Date demande</th>
                                        <th>Statut</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="demande" items="${demandes}">
                                        <tr>
                                            <td>${demande.id}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty demande.logo}">
                                                        <img src="${pageContext.request.contextPath}/uploads/logos/${demande.logo}" 
                                                             alt="Logo ${demande.nomClub}" class="logo-preview">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="logo-placeholder">
                                                            <i class="fas fa-chess-knight"></i>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="club-info">
                                                    <div class="club-name">${demande.nomClub}</div>
                                                    <c:if test="${not empty demande.description}">
                                                        <div class="club-description">${demande.description}</div>
                                                    </c:if>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="president-info">
                                                    <div class="president-avatar">
                                                        ${demande.nomPresident.substring(0, 1).toUpperCase()}
                                                    </div>
                                                    <div class="president-details">
                                                        <div class="president-name">
                                                            ${demande.nomPresident} ${demande.prenomPresident}
                                                        </div>
                                                        <div class="president-email">${demande.emailPresident}</div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>${demande.dateDemande}</td>
                                            <td>
                                                <span class="status-badge status-${demande.statut.toLowerCase()}">
                                                    <c:choose>
                                                        <c:when test="${demande.statut == 'EN_ATTENTE'}">
                                                            <i class="fas fa-clock"></i> En attente
                                                        </c:when>
                                                        <c:when test="${demande.statut == 'ACCEPTEE'}">
                                                            <i class="fas fa-check"></i> Acceptée
                                                        </c:when>
                                                        <c:when test="${demande.statut == 'REFUSEE'}">
                                                            <i class="fas fa-times"></i> Refusée
                                                        </c:when>
                                                    </c:choose>
                                                </span>
                                            </td>
                                            <td>
                                                <div class="action-buttons">
                                                    <!-- Actions seulement pour les demandes en attente -->
                                                    <c:if test="${demande.statut == 'EN_ATTENTE'}">
                                                        <button class="btn-action btn-approve" 
                                                           onclick="handleDemandeAction(${demande.id}, 'APPROUVE', this)"
                                                           title="Approuver la demande"
                                                           data-demande-id="${demande.id}"
                                                           data-action="APPROUVE">
                                                            <i class="fas fa-check"></i>
                                                        </button>
                                                        
                                                        <button class="btn-action btn-reject" 
                                                           onclick="handleDemandeAction(${demande.id}, 'REFUSE', this)"
                                                           title="Refuser la demande"
                                                           data-demande-id="${demande.id}"
                                                           data-action="REFUSE">
                                                            <i class="fas fa-times"></i>
                                                        </button>
                                                    </c:if>
                                                    
                                                    <!-- Bouton voir détails (toujours disponible) -->
                                                    <a href="#" class="btn-action btn-view" 
                                                       onclick="showDemandeDetails(${demande.id})" 
                                                       title="Voir les détails">
                                                        <i class="fas fa-eye"></i>
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
                

                <!-- Navigation -->
                <div class="navigation">
                    <a href="${pageContext.request.contextPath}/federation/dashboard" class="nav-btn primary">
                        <i class="fas fa-arrow-left"></i>
                        Retour au dashboard
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <script src="${pageContext.request.contextPath}/js/app.js"></script>
    <script>
        function showDemandeDetails(demandeId) {
            // Fonction pour afficher les détails d'une demande
            // Peut être implémentée plus tard avec une modal ou une page dédiée
            alert('Détails de la demande #' + demandeId + ' - Fonctionnalité à implémenter');
        }


        function handleDemandeAction(demandeId, action, buttonElement) {
            const actionText = action === 'APPROUVE' ? 'approuver' : 'refuser';
            const confirmMessage = 'Êtes-vous sûr de vouloir ' + actionText + ' cette demande ?';
            
            if (!confirm(confirmMessage)) {
                return;
            }
            
            // Désactiver le bouton cliqué
            buttonElement.disabled = true;
            buttonElement.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';

            // Faire la requête AJAX
            const contextPath = '${pageContext.request.contextPath}';
            const url = contextPath + '/valider/demande?type=creation&action=' + action + '&id=' + demandeId;
            
            fetch(url, {
                method: 'GET'
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('HTTP error! status: ' + response.status);
                }
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    // Recharger la page pour voir les changements
                    location.reload();
                } else {
                    alert('Erreur: ' + data.message);
                    // Réactiver le bouton
                    buttonElement.disabled = false;
                    buttonElement.innerHTML = action === 'APPROUVE' ? '<i class="fas fa-check"></i>' : '<i class="fas fa-times"></i>';
                }
            })
            .catch(error => {
                alert('Erreur de communication avec le serveur');
                // Réactiver le bouton
                buttonElement.disabled = false;
                buttonElement.innerHTML = action === 'APPROUVE' ? '<i class="fas fa-check"></i>' : '<i class="fas fa-times"></i>';
            });
        }

        function updateDemandeStatus(row, action) {
            const statusCell = row.querySelector('td:nth-child(6)'); // Colonne statut
            const actionsCell = row.querySelector('td:nth-child(7)'); // Colonne actions
            
            let newStatus, newIcon, newClass;
            
            if (action === 'APPROUVE') {
                newStatus = 'ACCEPTEE';
                newIcon = 'fas fa-check';
                newClass = 'status-acceptee';
            } else {
                newStatus = 'REFUSEE';
                newIcon = 'fas fa-times';
                newClass = 'status-refusee';
            }
            
            // Mettre à jour le badge de statut
            const statusText = newStatus === 'ACCEPTEE' ? 'Acceptée' : 'Refusée';
            statusCell.innerHTML = '<span class="status-badge ' + newClass + '">' +
                '<i class="' + newIcon + '"></i> ' + statusText +
                '</span>';
            
            // Remplacer les boutons d'action par seulement le bouton voir détails
            const demandeId = row.querySelector('td:first-child').textContent;
            actionsCell.innerHTML = '<div class="action-buttons">' +
                '<a href="#" class="btn-action btn-view" ' +
                'onclick="showDemandeDetails(' + demandeId + ')" ' +
                'title="Voir les détails">' +
                '<i class="fas fa-eye"></i>' +
                '</a>' +
                '</div>';
        }

        function updateStatistics(action) {
            const enAttenteElement = document.querySelector('.stat-card.pending .stat-number');
            const accepteesElement = document.querySelector('.stat-card.accepted .stat-number');
            const refuseesElement = document.querySelector('.stat-card.rejected .stat-number');
            
            // Décrémenter les demandes en attente
            let enAttente = parseInt(enAttenteElement.textContent);
            enAttenteElement.textContent = Math.max(0, enAttente - 1);
            
            // Incrémenter selon l'action
            if (action === 'APPROUVE') {
                let acceptees = parseInt(accepteesElement.textContent);
                accepteesElement.textContent = acceptees + 1;
            } else {
                let refusees = parseInt(refuseesElement.textContent);
                refuseesElement.textContent = refusees + 1;
            }
        }

        function showMessage(message, type) {
            // Supprimer les anciens messages
            const existingMessages = document.querySelectorAll('.message');
            existingMessages.forEach(msg => msg.remove());
            
            // Créer le nouveau message
            const messageDiv = document.createElement('div');
            messageDiv.className = 'message ' + (type === 'error' ? 'error' : '');
            const iconClass = type === 'error' ? 'exclamation-triangle' : 'check-circle';
            messageDiv.innerHTML = '<i class="fas fa-' + iconClass + '"></i> ' + message;
            
            // Insérer le message après les statistiques
            const statsContainer = document.querySelector('.stats-container');
            statsContainer.insertAdjacentElement('afterend', messageDiv);
            
            // Faire disparaître le message après 5 secondes
            setTimeout(() => {
                messageDiv.style.opacity = '0';
                setTimeout(() => messageDiv.remove(), 300);
            }, 5000);
        }
    </script>
</body>
</html>
