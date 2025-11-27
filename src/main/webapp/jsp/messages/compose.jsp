<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
    <title>Nouveau Message</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
        }
        .messages-container {
            max-width: 700px;
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
        .btn-back {
            background: #8B4513;
            color: #fff;
        }
        .form-content {
            padding: 24px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }
        .form-group input[type="text"],
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-family: inherit;
            font-size: 0.95rem;
            box-sizing: border-box;
        }
        .form-group input[type="text"]:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #1e3c72;
            box-shadow: 0 0 0 3px rgba(30, 60, 114, 0.1);
        }
        .form-group textarea {
            resize: vertical;
            min-height: 200px;
        }
        .form-actions {
            display: flex;
            gap: 12px;
            padding-top: 12px;
        }
        .btn-submit {
            flex: 1;
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            background: #4CAF50;
            color: #fff;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        .btn-submit:hover {
            background: #45a049;
        }
        .info-text {
            color: #666;
            font-size: 0.9rem;
            margin: 0 0 20px 0;
        }
    </style>
</head>
<body>
    <div class="messages-container">
        <div class="messages-card">
            <div class="messages-header">
                <h1><i class="fas fa-pen"></i> Nouveau Message</h1>
                <a href="${pageContext.request.contextPath}/messages?action=inbox" class="btn-back">
                    <i class="fas fa-arrow-left"></i> Retour
                </a>
            </div>

            <div class="form-content">
                <form action="${pageContext.request.contextPath}/messages" method="post">
                    <input type="hidden" name="action" value="send" />

                    <c:choose>
                        <c:when test="${sessionScope.currentUser.role == 'PRESIDENT'}">
                            <p class="info-text">
                                <i class="fas fa-info-circle"></i> Destinataires : Tous les membres de mon club
                            </p>
                        </c:when>
                        <c:otherwise>
                            <div class="form-group">
                                <label for="clubId">
                                    <i class="fas fa-building"></i> Club destinataire
                                </label>
                                <select name="clubId" id="clubId" required>
                                    <option value="">-- Sélectionner un club --</option>
                                    <c:forEach var="club" items="${clubs}">
                                        <option value="${club.id}">${club.nom}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <div class="form-group">
                        <label for="sujet">
                            <i class="fas fa-heading"></i> Sujet
                        </label>
                        <input type="text" id="sujet" name="sujet" placeholder="Entrez le sujet du message..." required />
                    </div>

                    <div class="form-group">
                        <label for="contenu">
                            <i class="fas fa-align-left"></i> Message
                        </label>
                        <textarea id="contenu" name="contenu" placeholder="Écrivez votre message ici..." required></textarea>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn-submit">
                            <i class="fas fa-paper-plane"></i> Envoyer
                        </button>
                    </div>
                </form>
            </div>

            <div style="padding: 12px 24px; background: #f9f9f9; border-top: 1px solid #eee; display: flex; gap: 12px;">
                <a href="${pageContext.request.contextPath}/messages?action=inbox" class="btn-back" style="flex: 1; text-align: center;">
                    <i class="fas fa-inbox"></i> Retour aux messages
                </a>
                <a href="${pageContext.request.contextPath}/dashboard" class="btn-back" style="flex: 1; text-align: center;">
                    <i class="fas fa-home"></i> Retour au dashboard
                </a>
            </div>
        </div>
    </div>
</body>
</html>