<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chess Club Manager - Inscription</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* copy of index styles (concise) */
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%); min-height: 100vh; display:flex; align-items:center; justify-content:center; }
        .register-card { background: rgba(255,255,255,0.95); border-radius:20px; padding:36px; max-width:700px; width:100%; box-shadow: 0 25px 50px rgba(0,0,0,0.2); }
        .form-col { gap:16px; display:flex; flex-direction:column; }
        .btn-primary { background: linear-gradient(135deg,#8B4513 0%, #D2691E 100%); border:none; }
    </style>
</head>
<body>
    <div class="register-card container">
        <div class="row">
            <div class="col-md-6 d-flex flex-column justify-content-center">
                <div class="text-center mb-4">
                    <i class="fas fa-chess-king" style="font-size:48px;color:#8B4513"></i>
                    <h2 class="mt-2">Créer un compte</h2>
                    <p class="text-muted">Rejoignez la communauté des clubs d'échecs</p>
                </div>
            </div>
            <div class="col-md-6">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>
                <form method="post" action="${pageContext.request.contextPath}/register" class="form-col">
                    <input name="nom" class="form-control" placeholder="Nom" required/>
                    <input name="prenom" class="form-control" placeholder="Prénom" required/>
                    <input name="email" type="email" class="form-control" placeholder="Email" required/>
                    <input name="cin" class="form-control" placeholder="CIN" required/>
                    <input name="motDePasse" type="password" class="form-control" placeholder="Mot de passe" required/>
                    <input name="motDePasse2" type="password" class="form-control" placeholder="Confirmer mot de passe" required/>
                    <select name="role" class="form-select">
                        <option value="MEMBRE">MEMBRE</option>
                        <option value="PRESIDENT">PRESIDENT</option>
                        <option value="FEDERATION">FEDERATION</option>
                    </select>
                    <div class="d-grid">
                        <button class="btn btn-primary" type="submit">S'inscrire</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
