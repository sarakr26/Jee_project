<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Planning du Club</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            font-size: 14px;
            margin: 5px;
        }
        .btn-primary { background-color: #007bff; color: white; }
        .btn-secondary { background-color: #6c757d; color: white; }
        .btn-warning { background-color: #ffc107; color: black; }
        .btn-danger { background-color: #dc3545; color: white; }
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
        .form-group { margin-bottom: 15px; }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .form-group input, .form-group select {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
        }
        .modal-content {
            background-color: white;
            margin: 5% auto;
            padding: 20px;
            border-radius: 8px;
            width: 80%;
            max-width: 600px;
        }
        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }
        .close:hover { color: black; }
    </style>
</head>
<body>
    <div class="container">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
            <h1>Planning des Activités</h1>
            <div>
                <a href="${pageContext.request.contextPath}/president/dashboard" class="btn btn-secondary">Retour au Tableau de Bord</a>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger">Déconnexion</a>
            </div>
        </div>

        <button class="btn btn-primary" onclick="openCreateModal()">+ Ajouter une Activité</button>

        <div class="card">
            <h2>Liste des Activités</h2>
            <table class="table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Titre</th>
                        <th>Type</th>
                        <th>Date Début</th>
                        <th>Date Fin</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="activite" items="${activities}">
                        <tr>
                            <td>${activite.id}</td>
                            <td><c:out value="${activite.titre}" /></td>
                            <td><c:out value="${activite.type}" /></td>
                            <td><fmt:formatDate value="${activite.dateDebut}" pattern="dd/MM/yyyy HH:mm" /></td>
                            <td><fmt:formatDate value="${activite.dateFin}" pattern="dd/MM/yyyy HH:mm" /></td>
                            <td>
                                <button class="btn btn-warning" 
                                    data-id="${activite.id}"
                                    data-titre="<c:out value='${activite.titre}'/>"
                                    data-type="<c:out value='${activite.type}'/>"
                                    data-debut="${activite.dateDebut.time}"
                                    data-fin="${activite.dateFin.time}"
                                    onclick="openEditModalFromData(this)">Modifier</button>
                                <form action="${pageContext.request.contextPath}/president/planning" method="post" style="display: inline;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="${activite.id}">
                                    <button type="submit" class="btn btn-danger" onclick="return confirm('Supprimer cette activité ?')">Supprimer</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty activities}">
                        <tr>
                            <td colspan="6" style="text-align: center; color: #999;">Aucune activité planifiée.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Create Activity Modal -->
    <div id="createModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeCreateModal()">&times;</span>
            <h2>Créer une Activité</h2>
            <form action="${pageContext.request.contextPath}/president/planning" method="post">
                <input type="hidden" name="action" value="create">
                
                <div class="form-group">
                    <label for="titre">Titre:</label>
                    <input type="text" id="titre" name="titre" required>
                </div>
                
                <div class="form-group">
                    <label for="type">Type:</label>
                    <select id="type" name="type" required>
                        <option value="TRAINING">Entraînement</option>
                        <option value="MEETING">Réunion</option>
                        <option value="TOURNAMENT">Tournoi</option>
                        <option value="OTHER">Autre</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="dateDebut">Date Début:</label>
                    <input type="datetime-local" id="dateDebut" name="dateDebut" required>
                </div>
                
                <div class="form-group">
                    <label for="dateFin">Date Fin:</label>
                    <input type="datetime-local" id="dateFin" name="dateFin" required>
                </div>
                
                <button type="submit" class="btn btn-primary">Créer</button>
                <button type="button" class="btn btn-secondary" onclick="closeCreateModal()">Annuler</button>
            </form>
        </div>
    </div>

    <!-- Edit Activity Modal -->
    <div id="editModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeEditModal()">&times;</span>
            <h2>Modifier une Activité</h2>
            <form action="${pageContext.request.contextPath}/president/planning" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" id="editId" name="id">
                
                <div class="form-group">
                    <label for="editTitre">Titre:</label>
                    <input type="text" id="editTitre" name="titre" required>
                </div>
                
                <div class="form-group">
                    <label for="editType">Type:</label>
                    <select id="editType" name="type" required>
                        <option value="TRAINING">Entraînement</option>
                        <option value="MEETING">Réunion</option>
                        <option value="TOURNAMENT">Tournoi</option>
                        <option value="OTHER">Autre</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="editDateDebut">Date Début:</label>
                    <input type="datetime-local" id="editDateDebut" name="dateDebut" required>
                </div>
                
                <div class="form-group">
                    <label for="editDateFin">Date Fin:</label>
                    <input type="datetime-local" id="editDateFin" name="dateFin" required>
                </div>
                
                <button type="submit" class="btn btn-primary">Mettre à jour</button>
                <button type="button" class="btn btn-secondary" onclick="closeEditModal()">Annuler</button>
            </form>
        </div>
    </div>

    <script>
        function openCreateModal() {
            document.getElementById('createModal').style.display = 'block';
        }

        function closeCreateModal() {
            document.getElementById('createModal').style.display = 'none';
        }

        function openEditModalFromData(button) {
            var id = button.getAttribute('data-id');
            var titre = button.getAttribute('data-titre');
            var type = button.getAttribute('data-type');
            var dateDebut = parseInt(button.getAttribute('data-debut'));
            var dateFin = parseInt(button.getAttribute('data-fin'));
            
            document.getElementById('editId').value = id;
            document.getElementById('editTitre').value = titre;
            document.getElementById('editType').value = type;
            
            var debut = new Date(dateDebut);
            var fin = new Date(dateFin);
            document.getElementById('editDateDebut').value = formatDateTimeLocal(debut);
            document.getElementById('editDateFin').value = formatDateTimeLocal(fin);
            
            document.getElementById('editModal').style.display = 'block';
        }

        function closeEditModal() {
            document.getElementById('editModal').style.display = 'none';
        }

        function formatDateTimeLocal(date) {
            var year = date.getFullYear();
            var month = ('0' + (date.getMonth() + 1)).slice(-2);
            var day = ('0' + date.getDate()).slice(-2);
            var hours = ('0' + date.getHours()).slice(-2);
            var minutes = ('0' + date.getMinutes()).slice(-2);
            return year + '-' + month + '-' + day + 'T' + hours + ':' + minutes;
        }

        window.onclick = function(event) {
            var createModal = document.getElementById('createModal');
            var editModal = document.getElementById('editModal');
            if (event.target == createModal) closeCreateModal();
            if (event.target == editModal) closeEditModal();
        }
    </script>
</body>
</html>
