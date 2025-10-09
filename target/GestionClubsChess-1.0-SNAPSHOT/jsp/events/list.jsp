<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="fr">
<head>
    <meta charset="UTF-8" />
    <title>Liste des événements</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/events.css" />
</head>
<body>
<div class="page-wrapper">
    <div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h1 class="mb-0">Événements</h1>
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/jsp/events/create.jsp">Créer un événement</a>
    </div>

    <c:if test="${not empty sessionScope.message}">
        <div class="alert alert-success">${sessionScope.message}</div>
        <c:remove var="message" scope="session" />
    </c:if>

    <div class="table-responsive">
        <table class="table table-striped table-hover align-middle">
            <thead class="table-light">
                <tr><th>ID</th><th>Titre</th><th>Lieu</th><th>Date début</th><th>Date fin</th><th>Statut</th></tr>
            </thead>
            <tbody>
            <c:forEach var="e" items="${events}">
                <tr>
                    <td>${e.id}</td>
                    <td>${e.titre}</td>
                    <td>${e.lieu}</td>
                    <td>${e.dateDebut}</td>
                    <td>${e.dateFin}</td>
                    <td>${e.statut}</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/events.js"></script>
</body>
</html>
