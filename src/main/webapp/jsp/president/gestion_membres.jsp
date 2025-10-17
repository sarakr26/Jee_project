<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tableau de Bord - Président</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="container">
        
        <div class="dashboard-header">
            <h1>Tableau de Bord</h1>
            <div>
                <a href="${pageContext.request.contextPath}/president/planning" class="btn btn-primary">Gérer le Planning</a>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger">Déconnexion</a>
            </div>
        </div>

        <div class="card">
            <h2>Demandes d'adhésion en attente</h2>
            <table class="table">
                <thead>
                    <tr>
                        <th>ID du demandeur</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody class="table-actions">
                    <c:forEach var="demande" items="${demandes}">
                        <tr>
                            <td>Utilisateur ID: ${demande.membreId}</td>
                            <td>
                                <a href="#" class="btn btn-success">Approuver</a>
                                <a href="#" class="btn btn-danger">Rejeter</a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty demandes}">
                        <tr>
                            <td colspan="2">Aucune demande d'adhésion en attente.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <div class="card">
            <h2>Membres actuels</h2>
            <table class="table">
                <thead>
                    <tr>
                        <th>Nom</th>
                        <th>Prénom</th>
                        <th>Email</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="membre" items="${membres}">
                        <tr>
                            <td><c:out value="${membre.nom}" /></td>
                            <td><c:out value="${membre.prenom}" /></td>
                            <td><c:out value="${membre.email}" /></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty membres}">
                        <tr>
                            <td colspan="3">Aucun membre n'est actuellement dans le club.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

    </div>
</body>
</html>