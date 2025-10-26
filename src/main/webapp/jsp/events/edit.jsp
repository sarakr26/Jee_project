<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chess Club Manager - Modifier un événement</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .form-container {
            max-width: 900px;
            width: 100%;
            margin: 0 auto;
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: auto;
            justify-content: flex-start;
            padding: 5px 0;
        }
        
        .form-header {
            text-align: center;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid rgba(139, 69, 19, 0.1);
        }
        
        .form-header h1 {
            color: #2c3e50;
            font-size: 2rem;
            margin-bottom: 8px;
            font-weight: 700;
        }
        
        .form-header p {
            color: #7f8c8d;
            font-size: 1.1rem;
            margin: 0;
        }
        
        .event-form-card {
            background: rgba(255, 255, 255, 0.9);
            border-radius: 20px;
            padding: 20px;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.1);
            position: relative;
            overflow: hidden;
            margin-bottom: 0;
        }
        
        .event-form-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #1e3c72, #2a5298, #3b5998, #2a5298, #1e3c72);
        }
        
        .error-message {
            background: rgba(231, 76, 60, 0.1);
            border: 2px solid rgba(231, 76, 60, 0.3);
            color: #e74c3c;
            padding: 15px 20px;
            border-radius: 12px;
            margin-bottom: 25px;
            text-align: center;
            font-weight: 500;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .form-group {
            margin-bottom: 12px;
        }
        
        .form-label {
            display: block;
            font-weight: 600;
            color: #1e3c72;
            font-size: 0.95rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 8px;
        }
        
        .form-input-group {
            position: relative;
            display: flex;
            align-items: center;
            background: rgba(255, 255, 255, 0.8);
            border-radius: 12px;
            border: 2px solid rgba(30, 60, 114, 0.2);
            transition: all 0.3s ease;
            overflow: hidden;
        }
        
        .form-input-group:focus-within {
            border-color: #1e3c72;
            box-shadow: 0 0 0 3px rgba(30, 60, 114, 0.1);
            transform: translateY(-2px);
        }
        
        .form-input-group i {
            color: #1e3c72;
            font-size: 1.2rem;
            padding: 15px 15px 15px 20px;
            transition: all 0.3s ease;
        }
        
        .form-input-group:focus-within i {
            color: #2a5298;
            transform: scale(1.1);
        }
        
        .form-input {
            flex: 1;
            border: none;
            background: transparent;
            padding: 15px 20px 15px 10px;
            font-size: 1rem;
            color: #2c3e50;
            outline: none;
        }
        
        .form-input::placeholder {
            color: #7f8c8d;
            font-style: italic;
        }
        
        .form-textarea-group {
            position: relative;
            background: rgba(255, 255, 255, 0.8);
            border-radius: 12px;
            border: 2px solid rgba(30, 60, 114, 0.2);
            transition: all 0.3s ease;
            overflow: hidden;
        }
        
        .form-textarea-group:focus-within {
            border-color: #1e3c72;
            box-shadow: 0 0 0 3px rgba(30, 60, 114, 0.1);
            transform: translateY(-2px);
        }
        
        .form-textarea {
            width: 100%;
            border: none;
            background: transparent;
            padding: 20px;
            font-size: 1rem;
            color: #2c3e50;
            outline: none;
            resize: vertical;
            min-height: 120px;
            font-family: inherit;
        }
        
        .form-textarea::placeholder {
            color: #7f8c8d;
            font-style: italic;
        }
        
        .form-select-group {
            position: relative;
            background: rgba(255, 255, 255, 0.8);
            border-radius: 12px;
            border: 2px solid rgba(30, 60, 114, 0.2);
            transition: all 0.3s ease;
            overflow: hidden;
        }
        
        .form-select-group:focus-within {
            border-color: #1e3c72;
            box-shadow: 0 0 0 3px rgba(30, 60, 114, 0.1);
            transform: translateY(-2px);
        }
        
        .form-select {
            width: 100%;
            border: none;
            background: transparent;
            padding: 15px 20px;
            font-size: 1rem;
            color: #2c3e50;
            outline: none;
            appearance: none;
            cursor: pointer;
        }
        
        .form-select-group::after {
            content: '\f078';
            font-family: 'Font Awesome 6 Free';
            font-weight: 900;
            position: absolute;
            right: 20px;
            top: 50%;
            transform: translateY(-50%);
            color: #1e3c72;
            pointer-events: none;
        }
        
        .form-actions {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-top: 30px;
            flex-wrap: wrap;
        }
        
        .btn-submit {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 15px 30px;
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            box-shadow: 0 4px 15px rgba(30, 60, 114, 0.3);
        }
        
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(30, 60, 114, 0.4);
            background: linear-gradient(135deg, #2a5298 0%, #3b5998 100%);
        }
        
        .btn-back {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 12px 25px;
            background: rgba(52, 152, 219, 0.1);
            color: #3498db;
            border: 2px solid rgba(52, 152, 219, 0.3);
            border-radius: 12px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-back:hover {
            background: rgba(52, 152, 219, 0.2);
            transform: translateY(-2px);
        }
        
        .form-navigation {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-top: 20px;
            padding-top: 15px;
            border-top: 2px solid rgba(30, 60, 114, 0.1);
            flex-wrap: wrap;
        }
        
        .form-layout {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin-bottom: 15px;
        }
        
        .form-layout-single {
            grid-column: 1 / -1;
        }
        
        @media (max-width: 768px) {
            .form-container {
                margin: 10px;
                max-width: 100%;
            }
            
            .form-header h1 {
                font-size: 1.8rem;
            }
            
            .event-form-card {
                padding: 15px;
            }
            
            .form-layout {
                grid-template-columns: 1fr;
                gap: 15px;
            }
            
            .form-actions {
                flex-direction: column;
                align-items: center;
            }
            
            .btn-submit,
            .btn-back {
                width: 100%;
                max-width: 250px;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <div class="chess-background" style="min-height: 100vh;">
        <div class="container" style="min-height: 100vh; display: flex; align-items: flex-start; padding-top: 20px;">
            <div class="dashboard-card form-container">
                <!-- Formulaire avec header intégré -->
                <div class="event-form-card">
                    <!-- Header intégré -->
                    <div class="form-header">
                        <div class="chess-logo">
                            <i class="fas fa-edit"></i>
                            <h1>Modifier l'événement</h1>
                            <p>Mettre à jour les informations de l'événement</p>
                        </div>
                    </div>
                    
                    <c:if test="${not empty error}">
                        <div class="error-message">
                            <i class="fas fa-exclamation-triangle"></i>
                            ${error}
                        </div>
                    </c:if>
                    
                    <form method="post" action="${pageContext.request.contextPath}/events">
                        <input type="hidden" name="action" value="edit">
                        <input type="hidden" name="id" value="${evenement.id}">
                        
                        <!-- Layout horizontal pour les champs principaux -->
                        <div class="form-layout">
                            <div class="form-group">
                                <label class="form-label">Titre de l'événement</label>
                                <div class="form-input-group">
                                    <i class="fas fa-heading"></i>
                                    <input type="text" name="titre" value="${evenement.titre}" class="form-input" placeholder="Entrez le titre de l'événement" required>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label">Lieu</label>
                                <div class="form-input-group">
                                    <i class="fas fa-map-marker-alt"></i>
                                    <input type="text" name="lieu" value="${evenement.lieu}" class="form-input" placeholder="Lieu de l'événement">
                                </div>
                            </div>
                        </div>
                        
                        <!-- Description sur toute la largeur -->
                        <div class="form-layout-single">
                            <div class="form-group">
                                <label class="form-label">Description</label>
                                <div class="form-textarea-group">
                                    <textarea name="description" class="form-textarea" placeholder="Description détaillée de l'événement...">${evenement.description}</textarea>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Dates et statut sur la même ligne -->
                        <div class="form-layout">
                            <div class="form-group">
                                <label class="form-label">Date de début</label>
                                <div class="form-input-group">
                                    <i class="fas fa-calendar"></i>
                                    <input type="date" name="dateDebut" value="${evenement.dateDebut}" class="form-input">
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label">Date de fin</label>
                                <div class="form-input-group">
                                    <i class="fas fa-calendar-check"></i>
                                    <input type="date" name="dateFin" value="${evenement.dateFin}" class="form-input">
                                </div>
                            </div>
                        </div>
                        
                        <!-- Statut sur une ligne séparée -->
                        <div class="form-layout-single">
                            <div class="form-group">
                                <label class="form-label">Statut</label>
                                <div class="form-select-group">
                                    <select name="statut" class="form-select">
                                        <option value="PLANIFIE" ${evenement.statut=='PLANIFIE' ? 'selected' : ''}>PLANIFIÉ</option>
                                        <option value="ANNULE" ${evenement.statut=='ANNULE' ? 'selected' : ''}>ANNULÉ</option>
                                        <option value="TERMINE" ${evenement.statut=='TERMINE' ? 'selected' : ''}>TERMINÉ</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        
                        <div class="form-actions">
                            <button type="submit" class="btn-submit">
                                <i class="fas fa-save"></i>
                                Sauvegarder les modifications
                            </button>
                        </div>
                        
                        <!-- Navigation intégrée dans le formulaire -->
                        <div class="form-navigation">
                            <a href="${pageContext.request.contextPath}/federation/dashboard" class="btn-back">
                                <i class="fas fa-home"></i>
                                Retour au dashboard
                            </a>
                            <a href="${pageContext.request.contextPath}/events" class="btn-back">
                                <i class="fas fa-arrow-left"></i>
                                Retour à la liste
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
