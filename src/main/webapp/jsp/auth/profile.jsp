<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profil - Chess Club Manager</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%); min-height:100vh; display:flex; align-items:center; justify-content:center; }
        .profile-card { background: rgba(255,255,255,0.95); border-radius:18px; padding:28px; box-shadow:0 20px 40px rgba(0,0,0,0.18); width:100%; max-width:720px; }
    </style>
</head>
<body>
    <div class="profile-card container">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h2>Mon profil</h2>
            <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/logout">Se déconnecter</a>
        </div>
        <c:if test="${not empty sessionScope.currentUser}">
            <div class="row">
                <div class="col-md-6">
                    <p><strong>Nom:</strong> ${sessionScope.currentUser.nom}</p>
                    <p><strong>Prénom:</strong> ${sessionScope.currentUser.prenom}</p>
                    <p><strong>Email:</strong> ${sessionScope.currentUser.email}</p>
                    <p><strong>CIN:</strong> ${sessionScope.currentUser.cin}</p>
                </div>
                <div class="col-md-6">
                    <p><strong>Rôle:</strong> ${sessionScope.currentUser.role}</p>
                    <p><strong>Club ID:</strong> ${sessionScope.currentUser.clubId}</p>
                </div>
            </div>
        </c:if>
    </div>
</body>
</html>
