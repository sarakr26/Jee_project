<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    com.projet.jee.model.Utilisateur currentUser =
        (com.projet.jee.model.Utilisateur) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Messages Envoyés</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
        }
        .messages-container {
            max-width: 1100px;
            margin: 30px auto;
        }
        .messages-card {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
            overflow: hidden;
        }
        .messages-header {
            padding: 20px 24px;
            border-bottom: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .messages-header h1 {
            margin: 0;
            font-size: 1.5rem;
            color: #1e3c72;
        }
        .messages-header a {
            text-decoration: none;
            padding: 8px 16px;
            border-radius: 6px;
            border: none;
            cursor: pointer;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .btn-compose {
            background: #4CAF50;
            color: #fff;
        }
        .messages-table {
            width: 100%;
            border-collapse: collapse;
        }
        .messages-table thead {
            background: #f5f7fb;
        }
        .messages-table th,
        .messages-table td {
            padding: 12px 16px;
            text-align: left;
            font-size: 0.95rem;
        }
        .messages-table th {
            color: #555;
            border-bottom: 1px solid #eee;
        }
        .messages-table tbody tr:nth-child(even) {
            background: #fafafa;
        }
        .messages-table tbody tr:hover {
            background: #eef5ff;
        }
        .sujet-col {
            font-weight: 600;
            color: #1e3c72;
        }
        .empty {
            padding: 24px;
            text-align: center;
            color: #777;
        }
        .tabs {
            display: flex;
            gap: 8px;
            padding: 0 24px 12px 24px;
            border-bottom: 1px solid #eee;
        }
        .tab-link {
            padding: 8px 16px;
            border-radius: 20px;
            text-decoration: none;
            font-size: 0.9rem;
            color: #1e3c72;
            background: #e3ecff;
        }
        .tab-link.active {
            background: #1e3c72;
            color: #fff;
        }
    </style>
</head>
<body>
    <div class="messages-container">
        <div class="messages-card">
            <div class="messages-header">
                <h1><i class="fas fa-paper-plane"></i> Messages Envoyés</h1>
                <div>
                    <a href="${pageContext.request.contextPath}/messages?action=compose" class="btn-compose">
                        <i class="fas fa-pen"></i> Nouveau message
                    </a>
                </div>
            </div>

            <div class="tabs">
                <a href="${pageContext.request.contextPath}/messages?action=inbox" class="tab-link">
                    <i class="fas fa-inbox"></i> Réception
                </a>
                <a href="${pageContext.request.contextPath}/messages?action=sent" class="tab-link active">
                    <i class="fas fa-paper-plane"></i> Envoyés
                </a>
            </div>

            <c:choose>
                <c:when test="${empty messages}">
                    <div class="empty">
                        <i class="fas fa-check-circle" style="font-size: 2rem; margin-bottom: 10px;"></i>
                        <p>Aucun message envoyé.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <table class="messages-table">
                        <thead>
                            <tr>
                                <th>Sujet</th>
                                <th>Club</th>
                                <th>Date d'envoi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="m" items="${messages}">
                                <tr>
                                    <td class="sujet-col">${m.sujet}</td>
                                    <td>${m.clubNom}</td>
                                    <td>
                                        <fmt:formatDate value="${m.dateEnvoi}" pattern="dd/MM/yyyy HH:mm" />
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>

            <div style="padding: 12px 24px; background: #f9f9f9; border-top: 1px solid #eee; display: flex; gap: 12px;">
                <a href="${pageContext.request.contextPath}/messages?action=compose" class="btn-compose" style="flex: 1; text-align: center;">
                    <i class="fas fa-pen"></i> Nouveau message
                </a>
                <a href="${pageContext.request.contextPath}/dashboard" style="flex: 1; text-align: center; background: #8B4513; color: #fff; text-decoration: none; padding: 8px 16px; border-radius: 6px; font-weight: 600; display: inline-flex; align-items: center; justify-content: center; gap: 8px;">
                    <i class="fas fa-home"></i> Retour au dashboard
                </a>
            </div>
        </div>
    </div>
</body>
</html>