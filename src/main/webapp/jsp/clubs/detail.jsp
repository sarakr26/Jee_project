<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Club detail page --%>
<html>
<head>
    <title>Détails club</title>
</head>
<body>
<h1>Détails du club</h1>
<c:if test="${club == null}">
    <p>Club non trouvé.</p>
</c:if>
<c:if test="${not empty club}">
    <p>ID: ${club.id}</p>
    <p>Nom: ${club.nom}</p>
    <p>Adresse: ${club.adresse}</p>
    <p>Téléphone: ${club.telephone}</p>
    <p>Email: ${club.email}</p>
    <p>Description: ${club.description}</p>
    <p>Fédération: ${club.federationId}</p>
    <p><a href="${pageContext.request.contextPath}/clubs?action=edit&id=${club.id}">Modifier</a></p>
</c:if>
<p><a href="${pageContext.request.contextPath}/clubs">Retour à la liste</a></p>
</body>
</html>
