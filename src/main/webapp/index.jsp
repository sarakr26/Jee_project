<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chess Club Manager - Connexion</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            min-height: 100vh;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .chess-background {
            position: relative;
            width: 100vw;
            height: 100vh;
            background: 
                radial-gradient(circle at 20% 50%, rgba(255, 255, 255, 0.1) 0%, transparent 50%),
                radial-gradient(circle at 80% 20%, rgba(255, 255, 255, 0.1) 0%, transparent 50%),
                radial-gradient(circle at 40% 80%, rgba(255, 255, 255, 0.1) 0%, transparent 50%);
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .container {
            position: relative;
            z-index: 10;
            display: flex;
            align-items: center;
            justify-content: center;
            width: 100%;
            height: 100%;
            padding: 20px;
        }
        .login-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            padding: 40px;
            box-shadow: 
                0 25px 50px rgba(0, 0, 0, 0.25),
                0 0 0 1px rgba(255, 255, 255, 0.3);
            width: 100%;
            max-width: 420px;
            position: relative;
            overflow: hidden;
            animation: slideInUp 0.8s ease-out;
        }
        .login-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #8B4513, #D2691E, #CD853F, #D2691E, #8B4513);
        }
        .chess-logo {
            text-align: center;
            margin-bottom: 30px;
        }
        .chess-logo i {
            font-size: 4rem;
            color: #8B4513;
            margin-bottom: 15px;
            display: block;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
            animation: logoFloat 3s ease-in-out infinite;
        }
        @keyframes logoFloat {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-10px); }
        }
        .chess-logo h1 {
            color: #2c3e50;
            font-size: 2rem;
            font-weight: 700;
            margin: 0;
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.1);
        }
        .login-form {
            margin-bottom: 25px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .input-group {
            position: relative;
            display: flex;
            align-items: center;
            background: rgba(255, 255, 255, 0.8);
            border-radius: 12px;
            border: 2px solid rgba(139, 69, 19, 0.2);
            transition: all 0.3s ease;
            overflow: hidden;
        }
        .input-group:focus-within {
            border-color: #8B4513;
            box-shadow: 0 0 0 3px rgba(139, 69, 19, 0.1);
            transform: translateY(-2px);
        }
        .input-group i {
            color: #8B4513;
            font-size: 1.2rem;
            padding: 15px 15px 15px 20px;
            transition: all 0.3s ease;
        }
        .input-group:focus-within i {
            color: #D2691E;
            transform: scale(1.1);
        }
        .input-group input {
            flex: 1;
            border: none;
            background: transparent;
            padding: 15px 20px 15px 10px;
            font-size: 1rem;
            color: #2c3e50;
            outline: none;
        }
        .input-group input::placeholder {
            color: #7f8c8d;
            font-style: italic;
        }
        .login-btn {
            width: 100%;
            background: linear-gradient(135deg, #8B4513 0%, #D2691E 100%);
            color: white;
            border: none;
            border-radius: 12px;
            padding: 15px 20px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .login-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(139, 69, 19, 0.3);
            background: linear-gradient(135deg, #D2691E 0%, #CD853F 100%);
        }
        .login-footer {
            text-align: center;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .login-footer a {
            color: #8B4513;
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 500;
            transition: all 0.3s ease;
            padding: 5px 10px;
            border-radius: 8px;
        }
        .login-footer a:hover {
            color: #D2691E;
            background: rgba(139, 69, 19, 0.1);
            transform: translateY(-1px);
        }
        .chess-pieces {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            pointer-events: none;
            overflow: hidden;
            z-index: -1;
        }
        .piece {
            position: absolute;
            font-size: 2rem;
            color: rgba(139, 69, 19, 0.1);
            animation: pieceFloat 6s ease-in-out infinite;
        }
        .piece-1 { top: 10%; left: 10%; animation-delay: 0s; }
        .piece-2 { top: 20%; right: 15%; animation-delay: 1s; }
        .piece-3 { bottom: 30%; left: 20%; animation-delay: 2s; }
        .piece-4 { bottom: 20%; right: 10%; animation-delay: 3s; }
        .piece-5 { top: 50%; left: 5%; animation-delay: 4s; }
        @keyframes pieceFloat {
            0%, 100% { 
                transform: translateY(0px) rotate(0deg);
                opacity: 0.1;
            }
            50% { 
                transform: translateY(-20px) rotate(180deg);
                opacity: 0.3;
            }
        }
        @keyframes slideInUp {
            from {
                opacity: 0;
                transform: translateY(50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        @media (max-width: 480px) {
            .login-card {
                margin: 20px;
                padding: 30px 25px;
            }
            .chess-logo h1 { font-size: 1.5rem; }
            .chess-logo i { font-size: 3rem; }
            .login-footer {
                flex-direction: column;
                gap: 10px;
            }
        }
    </style>
</head>
<body>
    <div class="chess-background">
        <div class="container">
            <div class="login-card">
                <!-- Logo Chess -->
                <div class="chess-logo">
                    <i class="fas fa-chess-king"></i>
                    <h1>Chess Club Manager</h1>
                </div>
                
                <!-- Formulaire de connexion -->
                <c:if test="${not empty sessionScope.message}">
                    <div class="alert alert-success" style="margin-bottom:16px">${sessionScope.message}</div>
                    <c:remove var="message" scope="session" />
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger" style="margin-bottom:16px">${error}</div>
                </c:if>
                <form class="login-form" action="${pageContext.request.contextPath}/login" method="post">
                    <div class="form-group">
                        <div class="input-group">
                            <i class="fas fa-envelope"></i>
                            <input type="email" id="email" name="email" placeholder="Adresse email" required>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <div class="input-group">
                            <i class="fas fa-lock"></i>
                            <input type="password" id="motDePasse" name="motDePasse" placeholder="Mot de passe" required>
                        </div>
                    </div>
                    
                    <button type="submit" class="login-btn">
                        <i class="fas fa-sign-in-alt"></i>
                        Se connecter
                    </button>
                </form>
                
                <!-- Liens supplémentaires -->
                <div class="login-footer">
                    <a href="#" class="forgot-password">Mot de passe oublié ?</a>
                    <a href="${pageContext.request.contextPath}/register" class="register-link">Créer un compte</a>
                </div>
                
                <!-- Pièces d'échecs décoratives -->
                <div class="chess-pieces">
                    <i class="fas fa-chess-rook piece piece-1"></i>
                    <i class="fas fa-chess-knight piece piece-2"></i>
                    <i class="fas fa-chess-bishop piece piece-3"></i>
                    <i class="fas fa-chess-queen piece piece-4"></i>
                    <i class="fas fa-chess-pawn piece piece-5"></i>
                </div>
            </div>
        </div>
    </div>
    
    <script src="js/app.js"></script>
</body>
</html>


