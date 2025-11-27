<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    com.projet.jee.model.Utilisateur currentUser = (com.projet.jee.model.Utilisateur) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    Integer currentYear = (Integer) request.getAttribute("currentYear");
    Integer currentMonth = (Integer) request.getAttribute("currentMonth");
    
    if (currentYear == null || currentMonth == null) {
        java.util.Calendar cal = java.util.Calendar.getInstance();
        currentYear = cal.get(java.util.Calendar.YEAR);
        currentMonth = cal.get(java.util.Calendar.MONTH) + 1;
    }
    
    // Créer un calendrier pour le mois sélectionné
    java.util.Calendar cal = java.util.Calendar.getInstance();
    cal.set(currentYear, currentMonth - 1, 1);
    int firstDayOfWeek = cal.get(java.util.Calendar.DAY_OF_WEEK);
    int daysInMonth = cal.getActualMaximum(java.util.Calendar.DAY_OF_MONTH);
    
    // Ajuster pour que le lundi soit le premier jour (au lieu de dimanche)
    int firstDay = (firstDayOfWeek == java.util.Calendar.SUNDAY) ? 7 : firstDayOfWeek - 1;
    
    String[] monthNames = {"", "Janvier", "Février", "Mars", "Avril", "Mai", "Juin", 
                           "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"};
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Calendrier des Événements</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .calendar-container {
            min-height: 100vh;
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            padding: 20px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .calendar-header {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
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

        .month-navigation {
            display: flex;
            align-items: center;
            gap: 15px;
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

        .btn-nav {
            background: #2196F3;
            color: white;
        }

        .btn-nav:hover {
            background: #0b7dda;
            transform: translateY(-2px);
        }

        .btn-secondary {
            background: #7f8c8d;
            color: white;
        }

        .btn-secondary:hover {
            background: #6c757d;
        }

        .month-year {
            font-size: 1.5rem;
            font-weight: 600;
            color: #1e3c72;
            min-width: 250px;
            text-align: center;
        }

        .calendar-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }

        .calendar-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        .calendar-table th {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            color: white;
            padding: 15px;
            text-align: center;
            font-weight: 600;
            font-size: 0.9rem;
        }

        .calendar-table td {
            border: 1px solid #e0e0e0;
            padding: 10px;
            vertical-align: top;
            min-height: 100px;
            height: 120px;
            width: 14.28%;
        }

        .calendar-day {
            display: flex;
            flex-direction: column;
            height: 100%;
        }

        .day-number {
            font-weight: 600;
            color: #1e3c72;
            margin-bottom: 5px;
            font-size: 1.1rem;
        }

        .day-number.other-month {
            color: #ccc;
        }

        .day-number.today {
            background: #4CAF50;
            color: white;
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .events-list {
            flex: 1;
            overflow-y: auto;
            max-height: 80px;
        }

        .event-item {
            background: #4CAF50;
            color: white;
            padding: 3px 6px;
            margin: 2px 0;
            border-radius: 4px;
            font-size: 0.75rem;
            cursor: pointer;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .event-item:hover {
            background: #45a049;
            transform: scale(1.05);
        }

        .event-item.planifie {
            background: #2196F3;
        }

        .event-item.termine {
            background: #7f8c8d;
        }

        .event-item.annule {
            background: #f44336;
        }

        .empty-day {
            color: #ccc;
        }

        .event-modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
        }

        .modal-content {
            background-color: white;
            margin: 10% auto;
            padding: 30px;
            border-radius: 15px;
            width: 90%;
            max-width: 500px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3);
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
        }

        .modal-header h2 {
            color: #1e3c72;
            margin: 0;
        }

        .close-modal {
            background: none;
            border: none;
            font-size: 1.5rem;
            cursor: pointer;
            color: #7f8c8d;
        }

        .close-modal:hover {
            color: #f44336;
        }

        .event-details {
            color: #555;
        }

        .event-details p {
            margin: 10px 0;
        }

        .event-details strong {
            color: #1e3c72;
        }
    </style>
</head>
<body>
    <div class="calendar-container">
        <div class="calendar-header">
            <div class="header-title">
                <i class="fas fa-calendar-alt"></i>
                <h1>Calendrier des Événements</h1>
            </div>
            <div class="month-navigation">
                <% 
                    int prevMonth = currentMonth - 1;
                    int prevYear = currentYear;
                    if (prevMonth < 1) {
                        prevMonth = 12;
                        prevYear--;
                    }
                    int nextMonth = currentMonth + 1;
                    int nextYear = currentYear;
                    if (nextMonth > 12) {
                        nextMonth = 1;
                        nextYear++;
                    }
                %>
                <a href="${pageContext.request.contextPath}/events?action=calendar&year=<%= prevYear %>&month=<%= prevMonth %>" 
                   class="btn btn-nav">
                    <i class="fas fa-chevron-left"></i> Précédent
                </a>
                <div class="month-year">
                    <%= monthNames[currentMonth] %> <%= currentYear %>
                </div>
                <a href="${pageContext.request.contextPath}/events?action=calendar&year=<%= nextYear %>&month=<%= nextMonth %>" 
                   class="btn btn-nav">
                    Suivant <i class="fas fa-chevron-right"></i>
                </a>
            </div>
            <%
                String userRole = ((com.projet.jee.model.Utilisateur) session.getAttribute("currentUser")).getRole();
                if ("FEDERATION".equals(userRole)) {
            %>
                    <a href="${pageContext.request.contextPath}/events" class="btn btn-secondary">
                        <i class="fas fa-list"></i> Vue Liste
                    </a>
                    <a href="${pageContext.request.contextPath}/events?action=new" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Nouvel Événement
                    </a>
            <%
                } else if ("PRESIDENT".equals(userRole)) {
            %>
                    <a href="${pageContext.request.contextPath}/president/dashboard" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Retour au Dashboard
                    </a>
            <%
                } else if ("MEMBRE".equals(userRole)) {
            %>
                    <a href="${pageContext.request.contextPath}/membre/dashboard" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Retour au Dashboard
                    </a>
            <%
                }
            %>
        </div>

        <div class="calendar-card">
            <table class="calendar-table">
                <thead>
                    <tr>
                        <th>Lun</th>
                        <th>Mar</th>
                        <th>Mer</th>
                        <th>Jeu</th>
                        <th>Ven</th>
                        <th>Sam</th>
                        <th>Dim</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        java.util.Map<Integer, java.util.List<com.projet.jee.model.Evenement>> eventsByDay = new java.util.HashMap<Integer, java.util.List<com.projet.jee.model.Evenement>>();
                        if (request.getAttribute("events") != null) {
                            @SuppressWarnings("unchecked")
                            java.util.List<com.projet.jee.model.Evenement> events = (java.util.List<com.projet.jee.model.Evenement>) request.getAttribute("events");
                            for (com.projet.jee.model.Evenement event : events) {
                                if (event.getDateDebut() != null) {
                                    java.util.Calendar eventCal = java.util.Calendar.getInstance();
                                    eventCal.setTime(event.getDateDebut());
                                    int day = eventCal.get(java.util.Calendar.DAY_OF_MONTH);
                                    Integer dayKey = Integer.valueOf(day);
                                    if (!eventsByDay.containsKey(dayKey)) {
                                        eventsByDay.put(dayKey, new java.util.ArrayList<com.projet.jee.model.Evenement>());
                                    }
                                    eventsByDay.get(dayKey).add(event);
                                }
                            }
                        }
                        
                        int dayCounter = 1;
                        java.util.Calendar today = java.util.Calendar.getInstance();
                        boolean isCurrentMonth = (today.get(java.util.Calendar.YEAR) == currentYear && 
                                                 (today.get(java.util.Calendar.MONTH) + 1) == currentMonth);
                        int todayDay = today.get(java.util.Calendar.DAY_OF_MONTH);
                        
                        for (int row = 0; row < 6; row++) {
                            out.println("<tr>");
                            for (int col = 0; col < 7; col++) {
                                int cellDay = 0;
                                boolean isCurrentMonthDay = false;
                                
                                if (row == 0 && col < firstDay - 1) {
                                    // Jours du mois précédent
                                    java.util.Calendar prevCal = (java.util.Calendar) cal.clone();
                                    prevCal.add(java.util.Calendar.DAY_OF_MONTH, -1);
                                    int daysInPrevMonth = prevCal.getActualMaximum(java.util.Calendar.DAY_OF_MONTH);
                                    cellDay = daysInPrevMonth - (firstDay - 2 - col);
                                } else if (dayCounter <= daysInMonth) {
                                    cellDay = dayCounter;
                                    isCurrentMonthDay = true;
                                    dayCounter++;
                                } else {
                                    // Jours du mois suivant
                                    cellDay = dayCounter - daysInMonth;
                                }
                                
                                out.println("<td class=\"" + (isCurrentMonthDay ? "" : "empty-day") + "\">");
                                out.println("<div class=\"calendar-day\">");
                                out.println("<div class=\"day-number" + 
                                           (!isCurrentMonthDay ? " other-month" : "") +
                                           (isCurrentMonth && isCurrentMonthDay && cellDay == todayDay ? " today" : "") + 
                                           "\">" + cellDay + "</div>");
                                
                                if (isCurrentMonthDay && eventsByDay.containsKey(Integer.valueOf(cellDay))) {
                                    out.println("<div class=\"events-list\">");
                                    for (com.projet.jee.model.Evenement event : eventsByDay.get(Integer.valueOf(cellDay))) {
                                        String statusClass = event.getStatut() != null ? event.getStatut().toLowerCase() : "";
                                        out.println("<div class=\"event-item " + statusClass + 
                                                   "\" onclick=\"showEventDetails(" + event.getId() + ")\" title=\"" + 
                                                   (event.getTitre() != null ? event.getTitre().replace("\"", "&quot;") : "") + "\">");
                                        out.println((event.getTitre() != null && event.getTitre().length() > 15 ? 
                                                   event.getTitre().substring(0, 15) + "..." : 
                                                   (event.getTitre() != null ? event.getTitre() : "Événement")));
                                        out.println("</div>");
                                    }
                                    out.println("</div>");
                                }
                                
                                out.println("</div>");
                                out.println("</td>");
                            }
                            out.println("</tr>");
                            if (dayCounter > daysInMonth) break;
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Modal pour les détails d'événement -->
    <div id="eventModal" class="event-modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2 id="modalTitle">Détails de l'événement</h2>
                <button class="close-modal" onclick="closeEventModal()">&times;</button>
            </div>
            <div class="event-details" id="modalDetails">
                <!-- Contenu chargé dynamiquement -->
            </div>
        </div>
    </div>

    <script>
        <c:if test="${not empty allEvents}">
        const eventsData = {
            <c:forEach var="event" items="${allEvents}" varStatus="status">
            "${event.id}": {
                titre: "${event.titre}",
                description: "${event.description != null ? event.description : ''}",
                lieu: "${event.lieu != null ? event.lieu : ''}",
                dateDebut: "${event.dateDebut}",
                dateFin: "${event.dateFin}",
                statut: "${event.statut}"
            }<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        };

        function showEventDetails(eventId) {
            const event = eventsData[eventId];
            if (!event) return;

            document.getElementById('modalTitle').textContent = event.titre || 'Événement';
            const details = document.getElementById('modalDetails');
            details.innerHTML = `
                <p><strong>Titre:</strong> ${event.titre || 'N/A'}</p>
                <p><strong>Description:</strong> ${event.description || 'Aucune description'}</p>
                <p><strong>Lieu:</strong> ${event.lieu || 'Non spécifié'}</p>
                <p><strong>Date de début:</strong> ${event.dateDebut || 'N/A'}</p>
                <p><strong>Date de fin:</strong> ${event.dateFin || 'N/A'}</p>
                <p><strong>Statut:</strong> ${event.statut || 'N/A'}</p>
            `;
            document.getElementById('eventModal').style.display = 'block';
        }

        function closeEventModal() {
            document.getElementById('eventModal').style.display = 'none';
        }

        // Fermer le modal en cliquant en dehors
        window.onclick = function(event) {
            const modal = document.getElementById('eventModal');
            if (event.target == modal) {
                closeEventModal();
            }
        }
        </c:if>
    </script>
</body>
</html>

