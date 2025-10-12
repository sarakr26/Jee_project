<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chess Club Manager - <c:choose><c:when test="${not empty club}">Modifier un club</c:when><c:otherwise>Créer un club</c:otherwise></c:choose></title>
    <link rel="stylesheet" href="../css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .form-container {
            max-width: 700px;
            width: 100%;
            margin: 0 auto;
        }
        
        .form-header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid rgba(139, 69, 19, 0.1);
        }
        
        .form-header h1 {
            color: #2c3e50;
            font-size: 2.5rem;
            margin-bottom: 10px;
            font-weight: 700;
        }
        
        .form-header p {
            color: #7f8c8d;
            font-size: 1.1rem;
            margin: 0;
        }
        
        .club-form-card {
            background: rgba(255, 255, 255, 0.9);
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.1);
            position: relative;
            overflow: hidden;
        }
        
        .club-form-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #8B4513, #D2691E, #CD853F, #D2691E, #8B4513);
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
            margin-bottom: 25px;
        }
        
        .form-label {
            display: block;
            font-weight: 600;
            color: #8B4513;
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
            border: 2px solid rgba(139, 69, 19, 0.2);
            transition: all 0.3s ease;
            overflow: hidden;
        }
        
        .form-input-group:focus-within {
            border-color: #8B4513;
            box-shadow: 0 0 0 3px rgba(139, 69, 19, 0.1);
            transform: translateY(-2px);
        }
        
        .form-input-group i {
            color: #8B4513;
            font-size: 1.2rem;
            padding: 15px 15px 15px 20px;
            transition: all 0.3s ease;
        }
        
        .form-input-group:focus-within i {
            color: #D2691E;
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
            border: 2px solid rgba(139, 69, 19, 0.2);
            transition: all 0.3s ease;
            overflow: hidden;
        }
        
        .form-textarea-group:focus-within {
            border-color: #8B4513;
            box-shadow: 0 0 0 3px rgba(139, 69, 19, 0.1);
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
            border: 2px solid rgba(139, 69, 19, 0.2);
            transition: all 0.3s ease;
            overflow: hidden;
        }
        
        .form-select-group:focus-within {
            border-color: #8B4513;
            box-shadow: 0 0 0 3px rgba(139, 69, 19, 0.1);
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
            color: #8B4513;
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
        
        .btn-delete {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 15px 30px;
            background: rgba(231, 76, 60, 0.1);
            color: #e74c3c;
            border: 2px solid rgba(231, 76, 60, 0.3);
            border-radius: 12px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .btn-delete:hover {
            background: rgba(231, 76, 60, 0.2);
            transform: translateY(-2px);
            border-color: #e74c3c;
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
            text-align: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 2px solid rgba(139, 69, 19, 0.1);
        }
        
        @media (max-width: 768px) {
            .form-container {
                margin: 10px;
            }
            
            .form-header h1 {
                font-size: 2rem;
            }
            
            .club-form-card {
                padding: 20px;
            }
            
            .form-actions {
                flex-direction: column;
                align-items: center;
            }
            
            .btn-submit,
            .btn-delete {
                width: 100%;
                max-width: 250px;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <div class="chess-background">
        <div class="container">
            <div class="dashboard-card form-container">
                <!-- Header -->
                <div class="form-header">
                    <div class="chess-logo">
                        <i class="fas fa-chess-knight"></i>
                        <h1><c:choose><c:when test="${not empty club}">Modifier un club</c:when><c:otherwise>Créer un club</c:otherwise></c:choose></h1>
                        <p><c:choose><c:when test="${not empty club}">Modification des informations du club</c:when><c:otherwise>Ajout d'un nouveau club d'échecs</c:otherwise></c:choose></p>
                    </div>
                </div>
                
                <!-- Formulaire -->
                <div class="club-form-card">
                    <c:if test="${not empty error}">
                        <div class="error-message">
                            <i class="fas fa-exclamation-triangle"></i>
                            ${error}
                        </div>
                    </c:if>
                    
                    <form method="post" action="${pageContext.request.contextPath}/clubs">
                        <input type="hidden" name="id" value="${club.id}" />
                        
                        <div class="form-group">
                            <label class="form-label">Nom du club</label>
                            <div class="form-input-group">
                                <i class="fas fa-chess-rook"></i>
                                <input type="text" name="nom" value="${club.nom}" class="form-input" placeholder="Entrez le nom du club" required>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Adresse</label>
                            <div class="form-input-group">
                                <i class="fas fa-map-marker-alt"></i>
                                <input type="text" name="adresse" value="${club.adresse}" class="form-input" placeholder="Adresse complète du club">
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Téléphone</label>
                            <div class="form-input-group">
                                <i class="fas fa-phone"></i>
                                <input type="tel" name="telephone" value="${club.telephone}" class="form-input" placeholder="Numéro de téléphone">
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Email</label>
                            <div class="form-input-group">
                                <i class="fas fa-envelope"></i>
                                <input type="email" name="email" value="${club.email}" class="form-input" placeholder="Adresse email du club">
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Description</label>
                            <div class="form-textarea-group">
                                <textarea name="description" class="form-textarea" placeholder="Description du club, ses activités, horaires...">${club.description}</textarea>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Fédération</label>
                            <div class="form-select-group">
                                <select name="federationId" class="form-select">
                                    <option value="">-- Aucune fédération --</option>
                                    <c:forEach var="f" items="${federations}">
                                        <option value="${f.id}" <c:if test="${club.federationId == f.id}">selected</c:if>>${f.nom}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        
                        <div class="form-actions">
                            <button type="submit" name="action" value="save" class="btn-submit">
                                <i class="fas fa-save"></i>
                                <c:choose><c:when test="${not empty club}">Mettre à jour</c:when><c:otherwise>Créer le club</c:otherwise></c:choose>
                            </button>
                            <c:if test="${not empty club}">
                                <button type="submit" name="action" value="delete" class="btn-delete" onclick="return confirm('Êtes-vous sûr de vouloir supprimer ce club ? Cette action est irréversible.')">
                                    <i class="fas fa-trash"></i>
                                    Supprimer
                                </button>
                            </c:if>
                        </div>
                    </form>
                </div>
                
                <!-- Navigation -->
                <div class="form-navigation">
                    <a href="${pageContext.request.contextPath}/clubs" class="btn-back">
                        <i class="fas fa-arrow-left"></i>
                        Retour à la liste
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <script src="../js/app.js"></script>
</body>
</html>
