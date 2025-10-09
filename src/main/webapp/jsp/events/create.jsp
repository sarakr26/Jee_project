<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="fr">
<head>
    <meta charset="UTF-8" />
    <title>Créer un événement</title>
    <!-- Bootstrap CSS (CDN) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/events.css" />
</head>
<body>
</div>
<div class="page-wrapper">
    <div class="container py-4">
    <div class="card shadow-sm">
        <div class="card-body">
            <h1 class="card-title mb-3">Créer un événement</h1>
            <c:if test="${not empty error}">
                <div class="alert alert-danger" role="alert">${error}</div>
            </c:if>
            <form method="post" action="${pageContext.request.contextPath}/events">
                <div class="mb-3">
                    <label class="form-label">Titre</label>
                    <input type="text" name="titre" class="form-control" value="${param.titre}" required/>
                </div>
                <div class="mb-3">
                    <label class="form-label">Description</label>
                    <textarea name="description" class="form-control">${param.description}</textarea>
                </div>
                <div class="mb-3">
                    <label class="form-label">Lieu</label>
                    <input type="text" name="lieu" class="form-control" value="${param.lieu}"/>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Date début</label>
                        <input type="date" name="dateDebut" class="form-control" value="${param.dateDebut}"/>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Date fin</label>
                        <input type="date" name="dateFin" class="form-control" value="${param.dateFin}"/>
                    </div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Statut</label>
                    <select name="statut" class="form-select">
                        <option value="PLANIFIE" ${param.statut=='PLANIFIE' ? 'selected' : ''}>PLANIFIE</option>
                        <option value="ANNULE" ${param.statut=='ANNULE' ? 'selected' : ''}>ANNULE</option>
                        <option value="TERMINE" ${param.statut=='TERMINE' ? 'selected' : ''}>TERMINE</option>
                    </select>
                </div>
                <button type="submit" class="btn btn-primary">Créer</button>
            </form>
        </div>
    </div>
    </div>
</div>
<!-- Bootstrap bundle (includes Popper) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/events.js"></script>
</body>
</html>
