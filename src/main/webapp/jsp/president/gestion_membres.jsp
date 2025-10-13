
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestion des Membres</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="container">
        <h1>Gestion des Membres du Club</h1>

        <h2>Demandes d'adhésion en attente</h2>
        <table class="table">
            <thead>
                <tr>
                    <th>Nom du demandeur</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>Exemple Membre 1</td>
                    <td>
                        <button class="btn btn-success">Approuver</button>
                        <button class="btn btn-danger">Rejeter</button>
                    </td>
                </tr>
            </tbody>
        </table>
        <hr>
        <h2>Membres actuels</h2>
        <table class="table">
            <thead>
                <tr>
                    <th>Nom</th>
                    <th>Prénom</th>
                    <th>Email</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>Jean</td>
                    <td>Dupont</td>
                    <td>jean.dupont@email.com</td>
                </tr>
            </tbody>
        </table>
    </div>
</body>
</html>