<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    com.projet.jee.model.Utilisateur currentUser = (com.projet.jee.model.Utilisateur) session.getAttribute("currentUser");
    if (currentUser == null || !"PRESIDENT".equals(currentUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Créer une Activité - Planning</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .form-container {
            min-height: 100vh;
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            padding: 20px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .form-card {
            max-width: 700px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }

        .form-header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f0f0f0;
        }

        .form-header h1 {
            color: #1e3c72;
            font-size: 2rem;
            margin: 0;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #1e3c72;
            font-weight: 600;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 1rem;
            transition: border-color 0.3s;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #2a5298;
        }

        .form-actions {
            display: flex;
            gap: 15px;
            justify-content: flex-end;
            margin-top: 30px;
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
            background: #7f8c8d;
            color: white;
        }

        .btn-secondary:hover {
            background: #6c757d;
        }

        .error-message {
            background: rgba(231, 76, 60, 0.1);
            border: 2px solid rgba(231, 76, 60, 0.3);
            color: #e74c3c;
            padding: 15px 20px;
            border-radius: 12px;
            margin-bottom: 20px;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <div class="form-card">
            <div class="form-header">
                <h1><i class="fas fa-plus-circle"></i> Nouvelle Activité</h1>
                <p style="color: #7f8c8d;">Ajouter une activité au planning de ${club.nom}</p>
            </div>

            <c:if test="${not empty error}">
                <div class="error-message">
                    <i class="fas fa-exclamation-circle"></i> ${error}
                </div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/planning/activite">
                <input type="hidden" name="action" value="create">
                
                <div class="form-group">
                    <label for="titre"><i class="fas fa-heading"></i> Titre *</label>
                    <input type="text" id="titre" name="titre" required 
                           placeholder="Ex: Entraînement hebdomadaire" 
                           value="${param.titre}">
                </div>

                <div class="form-group">
                    <label for="type"><i class="fas fa-tag"></i> Type d'activité</label>
                    <select id="type" name="type">
                        <option value="">Sélectionner un type</option>
                        <option value="ENTRAINEMENT">Entraînement</option>
                        <option value="REUNION">Réunion</option>
                        <option value="TOURNOI_CLUB">Tournoi interne</option>
                        <option value="FORMATION">Formation</option>
                        <option value="AUTRE">Autre</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="dateDebut"><i class="fas fa-clock"></i> Date et heure de début *</label>
                    <input type="datetime-local" id="dateDebut" name="dateDebut" required 
                           value="${param.dateDebut}">
                </div>

                <div class="form-group">
                    <label for="dateFin"><i class="fas fa-stop-circle"></i> Date et heure de fin *</label>
                    <input type="datetime-local" id="dateFin" name="dateFin" required 
                           value="${param.dateFin}">
                </div>

                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/planning" class="btn btn-secondary">
                        <i class="fas fa-times"></i> Annuler
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i> Créer l'activité
                    </button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>


