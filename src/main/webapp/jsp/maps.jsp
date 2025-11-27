<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    com.projet.jee.model.Utilisateur currentUser = (com.projet.jee.model.Utilisateur) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    String viewType = (String) request.getAttribute("viewType");
    if (viewType == null) viewType = "clubs";
    
    String userRole = currentUser.getRole();
    String dashboardUrl = "";
    if ("FEDERATION".equals(userRole)) {
        dashboardUrl = request.getContextPath() + "/federation/dashboard";
    } else if ("PRESIDENT".equals(userRole)) {
        dashboardUrl = request.getContextPath() + "/president/dashboard";
    } else if ("MEMBRE".equals(userRole)) {
        dashboardUrl = request.getContextPath() + "/membre/dashboard";
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Carte des Clubs et Événements</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Leaflet CSS (OpenStreetMap) - aucune clé API requise -->
    <link
        rel="stylesheet"
        href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"
        integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY="
        crossorigin=""
    />
    <style>
        .maps-container {
            min-height: 100vh;
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            padding: 20px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .maps-header {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
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

        .view-toggle {
            display: flex;
            gap: 10px;
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
            border: none;
            cursor: pointer;
            font-size: 1rem;
        }

        .btn-primary {
            background: #4CAF50;
            color: white;
        }

        .btn-primary:hover {
            background: #45a049;
        }

        .btn-secondary {
            background: #2196F3;
            color: white;
        }

        .btn-secondary:hover {
            background: #0b7dda;
        }

        .btn-active {
            background: #1e3c72;
            color: white;
        }

        .maps-card {
            background: white;
            border-radius: 15px;
            padding: 0;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            overflow: hidden;
        }

        #map {
            width: 100%;
            height: 600px;
            border-radius: 15px;
        }

        .legend {
            background: white;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .legend-item {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 8px 0;
        }

        .legend-color {
            width: 20px;
            height: 20px;
            border-radius: 50%;
        }

        .legend-club {
            background: #4CAF50;
        }

        .legend-event {
            background: #2196F3;
        }
    </style>
</head>
<body>
    <div class="maps-container">
        <div class="maps-header">
            <div class="header-title">
                <i class="fas fa-map-marked-alt"></i>
                <h1>Carte des Clubs et Événements</h1>
            </div>
            <div style="display: flex; gap: 15px; align-items: center;">
                <div class="view-toggle">
                    <a href="${pageContext.request.contextPath}/maps?view=clubs" 
                       class="btn <%= "clubs".equals(viewType) ? "btn-active" : "btn-secondary" %>">
                        <i class="fas fa-chess-pawn"></i> Clubs
                    </a>
                    <a href="${pageContext.request.contextPath}/maps?view=events" 
                       class="btn <%= "events".equals(viewType) ? "btn-active" : "btn-secondary" %>">
                        <i class="fas fa-calendar-alt"></i> Événements
                    </a>
                </div>
                <a href="<%= dashboardUrl %>" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Retour
                </a>
            </div>
        </div>

        <div class="legend">
            <h3 style="margin: 0 0 10px 0; color: #1e3c72;">Légende</h3>
            <div class="legend-item">
                <div class="legend-color legend-club"></div>
                <span>Clubs d'Échecs</span>
            </div>
            <div class="legend-item">
                <div class="legend-color legend-event"></div>
                <span>Événements</span>
            </div>
        </div>

        <div class="maps-card">
            <div id="map"></div>
        </div>
    </div>

    <!-- Leaflet JS (OpenStreetMap) -->
    <script
        src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"
        integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo="
        crossorigin="">
    </script>

    <script>
        let map;
        let markers = [];

        function initLeafletMap() {
            // Centre du Maroc
            const defaultLocation = [31.7917, -7.0926];

            map = L.map('map').setView(defaultLocation, 6);

            // Tuiles OpenStreetMap (gratuit, sans clé)
            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                maxZoom: 19,
                attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
            }).addTo(map);

            <c:choose>
                <c:when test="${viewType == 'clubs' || viewType == 'singleClub'}">
                    // Afficher les clubs
                    <c:choose>
                        <c:when test="${viewType == 'singleClub' && club != null}">
                            addClubToMap({
                                nom: "${fn:escapeXml(club.nom)}",
                                description: "${fn:escapeXml(club.description)}"
                            });
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="club" items="${clubs}">
                                addClubToMap({
                                    nom: "${fn:escapeXml(club.nom)}",
                                    description: "${fn:escapeXml(club.description)}"
                                });
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </c:when>
                <c:when test="${viewType == 'events'}">
                    // Afficher les événements
                    <c:forEach var="event" items="${events}">
                        <c:if test="${event.lieu != null && !event.lieu.isEmpty()}">
                            addEventToMap({
                                titre: "${fn:escapeXml(event.titre)}",
                                lieu: "${fn:escapeXml(event.lieu)}",
                                dateDebut: "${fn:escapeXml(event.dateDebut)}",
                                description: "${fn:escapeXml(event.description)}"
                            });
                        </c:if>
                    </c:forEach>
                </c:when>
            </c:choose>

            // Ajuster la vue pour englober tous les marqueurs
            setTimeout(() => {
                if (markers.length > 0) {
                    const group = L.featureGroup(markers);
                    map.fitBounds(group.getBounds().pad(0.1));
                    if (markers.length === 1) {
                        map.setZoom(12);
                    }
                }
            }, 2000);
        }

        function geocodeWithNominatim(address, onSuccess) {
            if (!address || address.trim() === '') {
                return;
            }

            // Utilisation de Nominatim (service OpenStreetMap) sans clé API
            const url = 'https://nominatim.openstreetmap.org/search?format=json&limit=1&q='
                + encodeURIComponent(address);

            fetch(url, {
                headers: {
                    'Accept': 'application/json'
                }
            })
                .then(response => response.json())
                .then(data => {
                    if (data && data.length > 0) {
                        const lat = parseFloat(data[0].lat);
                        const lon = parseFloat(data[0].lon);
                        onSuccess([lat, lon]);
                    } else {
                        console.warn('Aucun résultat pour l\'adresse : ' + address);
                    }
                })
                .catch(err => {
                    console.error('Erreur Nominatim pour l\'adresse ' + address, err);
                });
        }

        function addClubToMap(club) {
            // On utilise le nom du club comme adresse approximative
            const address = club.nom + ', Maroc';

            geocodeWithNominatim(address, function (latlng) {
                const marker = L.marker(latlng, {
                    title: club.nom
                }).addTo(map);

                const popupHtml =
                    '<div style="max-width:250px;">' +
                    '<h3 style="margin:0 0 10px 0;color:#1e3c72;">' + club.nom + '</h3>' +
                    (club.description
                        ? '<p style="margin:0;color:#666;font-size:0.9rem;">' + club.description + '</p>'
                        : '') +
                    '</div>';

                marker.bindPopup(popupHtml);
                markers.push(marker);
            });
        }

        function addEventToMap(event) {
            let address = event.lieu;

            if (!address || address.trim() === '') {
                console.warn('Événement sans lieu : ' + event.titre);
                return;
            }

            geocodeWithNominatim(address, function (latlng) {
                const marker = L.marker(latlng, {
                    title: event.titre
                }).addTo(map);

                const popupHtml =
                    '<div style="max-width:250px;">' +
                    '<h3 style="margin:0 0 10px 0;color:#1e3c72;">' + event.titre + '</h3>' +
                    '<p style="margin:5px 0;color:#666;font-size:0.9rem;">' +
                    '<strong>Lieu :</strong> ' + event.lieu + '</p>' +
                    '<p style="margin:5px 0;color:#666;font-size:0.9rem;">' +
                    '<strong>Date :</strong> ' + event.dateDebut + '</p>' +
                    (event.description
                        ? '<p style="margin:5px 0;color:#666;font-size:0.9rem;">' + event.description + '</p>'
                        : '') +
                    '</div>';

                marker.bindPopup(popupHtml);
                markers.push(marker);
            });
        }

        document.addEventListener('DOMContentLoaded', initLeafletMap);
    </script>
</body>
</html>

