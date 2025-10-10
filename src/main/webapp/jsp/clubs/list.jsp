<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Simple list page for clubs --%>
<html>
<head>
    <title>Liste des clubs</title>
</head>
<body>
<h1>Liste des clubs</h1>
<c:if test="${not empty sessionScope.message}">
    <div class="message">${sessionScope.message}</div>
</c:if>
<table border="1">
    <tr><th>ID</th><th>Nom</th><th>Adresse</th><th>Téléphone</th><th>Email</th><th>Action</th></tr>
    <c:forEach var="c" items="${clubs}">
        <tr>
            <td>${c.id}</td>
            <td>${c.nom}</td>
            <td>${c.adresse}</td>
            <td>${c.telephone}</td>
            <td>${c.email}</td>
            <td><a href="${pageContext.request.contextPath}/clubs?id=${c.id}">Détails</a></td>
        </tr>
    </c:forEach>
</table>
</body>
</html>
