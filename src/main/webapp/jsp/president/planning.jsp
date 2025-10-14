<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Planning du Club</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="container">
        <h1>Planning des Activités</h1>

        <a href="${pageContext.request.contextPath}/president/dashboard" class="btn btn-secondary mb-3">Retour au Tableau de Bord</a>
        <br>
        <button class="btn btn-primary">Ajouter une nouvelle activité</button>
        <br><br>
        <table class="table">
            <thead>
                <tr>
                    <th>Date</th>
                    <th>Activité</th>
                    <th>Description</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>20/10/2025</td>
                    <td>Cours débutants</td>
                    <td>Cours sur les ouvertures de base.</td>
                </tr>
            </tbody>
        </table>
    </div>
</body>
</html>