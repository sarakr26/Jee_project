<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Connexion</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/events.css" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container py-4">
    <h1>Connexion</h1>
    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>
    <form method="post" action="${pageContext.request.contextPath}/login">
        <div class="mb-3"><label>Email</label><input name="email" type="email" class="form-control" required/></div>
        <div class="mb-3"><label>Mot de passe</label><input name="motDePasse" type="password" class="form-control" required/></div>
        <button class="btn btn-primary" type="submit">Se connecter</button>
    </form>
</div>
</body>
</html>
