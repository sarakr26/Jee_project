<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Formulaire club</title>
</head>
<body>
<h1><c:choose><c:when test="${not empty club}">Modifier un club</c:when><c:otherwise>Créer un club</c:otherwise></c:choose></h1>
<c:if test="${not empty error}"><div style="color:red">${error}</div></c:if>
<form method="post" action="${pageContext.request.contextPath}/clubs">
    <input type="hidden" name="id" value="${club.id}" />
    <p>Nom: <input type="text" name="nom" value="${club.nom}"/></p>
    <p>Adresse: <input type="text" name="adresse" value="${club.adresse}"/></p>
    <p>Téléphone: <input type="text" name="telephone" value="${club.telephone}"/></p>
    <p>Email: <input type="text" name="email" value="${club.email}"/></p>
    <p>Description: <textarea name="description">${club.description}</textarea></p>
    <p>Fédération:
        <select name="federationId">
            <option value="">-- Aucune --</option>
            <c:forEach var="f" items="${federations}">
                <option value="${f.id}" <c:if test="${club.federationId == f.id}">selected</c:if>>${f.nom}</option>
            </c:forEach>
        </select>
    </p>
    <p>
        <button type="submit" name="action" value="save">Enregistrer</button>
        <button type="submit" name="action" value="delete" onclick="return confirm('Supprimer ?')">Supprimer</button>
    </p>
</form>
<p><a href="${pageContext.request.contextPath}/clubs">Retour à la liste</a></p>
</body>
</html>
