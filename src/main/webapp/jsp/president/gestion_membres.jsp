<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestion des Membres - Président</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .stats-container {
            display: flex;
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            flex: 1;
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
        }
        .stat-card h3 {
            margin: 0;
            color: #666;
            font-size: 14px;
            text-transform: uppercase;
        }
        .stat-card .number {
            font-size: 36px;
            font-weight: bold;
            color: #007bff;
            margin: 10px 0;
        }
        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            font-size: 14px;
        }
        .btn-success {
            background-color: #28a745;
            color: white;
        }
        .btn-danger {
            background-color: #dc3545;
            color: white;
        }
        .btn-warning {
            background-color: #ffc107;
            color: black;
        }
        .btn-primary {
            background-color: #007bff;
            color: white;
        }
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        .card {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .table {
            width: 100%;
            border-collapse: collapse;
        }
        .table th, .table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        .table th {
            background-color: #f8f9fa;
            font-weight: bold;
        }
        .dashboard-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
    </style>
</head>
<body>
    <div class="container">
        
        <div class="dashboard-header">
            <h1>Gestion des Membres</h1>
            <div>
                <a href="${pageContext.request.contextPath}/president/planning" class="btn btn-primary">Gérer le Planning</a>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger">Déconnexion</a>
            </div>
        </div>

        <!-- Statistics Cards -->
        <div class="stats-container">
            <div class="stat-card">
                <h3>Membres Actifs</h3>
                <div class="number">${membersCount}</div>
            </div>
            <div class="stat-card">
                <h3>Demandes en Attente</h3>
                <div class="number">${pendingCount}</div>
            </div>
        </div>

        <!-- Pending Requests Section -->
        <div class="card">
            <h2>Demandes d'adhésion en attente</h2>
            <table class="table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Date de demande</th>
                        <th>Membre ID</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="demande" items="${demandes}">
                        <tr>
                            <td>${demande.id}</td>
                            <td>${demande.dateDemande}</td>
                            <td>${demande.membreId}</td>
                            <td>
                                <form action="${pageContext.request.contextPath}/president/dashboard" method="post" style="display: inline;">
                                    <input type="hidden" name="action" value="accept">
                                    <input type="hidden" name="demandeId" value="${demande.id}">
                                    <button type="submit" class="btn btn-success" onclick="return confirm('Accepter cette demande ?')">Accepter</button>
                                </form>
                                <form action="${pageContext.request.contextPath}/president/dashboard" method="post" style="display: inline;">
                                    <input type="hidden" name="action" value="refuse">
                                    <input type="hidden" name="demandeId" value="${demande.id}">
                                    <button type="submit" class="btn btn-danger" onclick="return confirm('Refuser cette demande ?')">Refuser</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty demandes}">
                        <tr>
                            <td colspan="4" style="text-align: center; color: #999;">Aucune demande d'adhésion en attente.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <!-- Current Members Section -->
        <div class="card">
            <h2>Membres actuels du club</h2>
            <table class="table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nom</th>
                        <th>Prénom</th>
                        <th>Email</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="membre" items="${membres}">
                        <tr>
                            <td>${membre.id}</td>
                            <td><c:out value="${membre.nom}" /></td>
                            <td><c:out value="${membre.prenom}" /></td>
                            <td><c:out value="${membre.email}" /></td>
                            <td>
                                <form action="${pageContext.request.contextPath}/president/dashboard" method="post" style="display: inline;">
                                    <input type="hidden" name="action" value="remove">
                                    <input type="hidden" name="userId" value="${membre.id}">
                                    <button type="submit" class="btn btn-warning" onclick="return confirm('Retirer ce membre du club ?')">Retirer</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty membres}">
                        <tr>
                            <td colspan="5" style="text-align: center; color: #999;">Aucun membre n'est actuellement dans le club.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

    </div>
</body>
</html>