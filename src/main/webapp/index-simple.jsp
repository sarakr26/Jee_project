<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chess Club Manager - Connexion</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/simple.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <div class="chess-background">
        <div class="chess-logo">
            <i class="fas fa-chess-king"></i>
            <h1>Chess Club Manager</h1>
        </div>
        
        <form class="login-form" action="login" method="post">
            <div class="form-group">
                <div class="input-group">
                    <i class="fas fa-envelope"></i>
                    <input type="email" id="email" name="email" placeholder="Adresse email" required>
                </div>
            </div>
            
            <div class="form-group">
                <div class="input-group">
                    <i class="fas fa-lock"></i>
                    <input type="password" id="password" name="password" placeholder="Mot de passe" required>
                </div>
            </div>
            
            <button type="submit" class="login-btn">
                <i class="fas fa-sign-in-alt"></i>
                Se connecter
            </button>
        </form>
        
        <div class="login-footer">
            <a href="#" class="forgot-password">Mot de passe oublié ?</a>
            <a href="#" class="register-link">Créer un compte</a>
        </div>
    </div>
    
    <script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
