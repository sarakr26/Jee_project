<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Chess Club Manager - Dashboard</title>
    <link rel="stylesheet" href="../css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
    <div class="chess-background">
        <div class="container">
            <div class="dashboard-card">
                <!-- Header -->
                <div class="dashboard-header">
                    <div class="chess-logo">
                        <i class="fas fa-chess-king"></i>
                        <h1>Chess Club Manager</h1>
                        <p>Tableau de bord</p>
                    </div>
                </div>
                
                <!-- Navigation -->
                <div class="dashboard-nav">
                    <a href="${pageContext.request.contextPath}/" class="nav-btn">
                        <i class="fas fa-home"></i>
                        Accueil
                    </a>
                    <a href="#" class="nav-btn">
                        <i class="fas fa-chess"></i>
                        Parties
                    </a>
                    <a href="#" class="nav-btn">
                        <i class="fas fa-users"></i>
                        Membres
                    </a>
                    <a href="#" class="nav-btn">
                        <i class="fas fa-trophy"></i>
                        Tournois
                    </a>
                </div>
                
                <!-- Contenu principal -->
                <div class="dashboard-content">
                    <h2>Bienvenue dans votre club d'échecs !</h2>
                    <p>Cette page est servie via HomeServlet et affiche le tableau de bord principal.</p>
                    
                    <div class="stats-grid">
                        <div class="stat-card">
                            <i class="fas fa-chess-pawn"></i>
                            <h3>Membres actifs</h3>
                            <span class="stat-number">24</span>
                        </div>
                        <div class="stat-card">
                            <i class="fas fa-chess-board"></i>
                            <h3>Parties jouées</h3>
                            <span class="stat-number">156</span>
                        </div>
                        <div class="stat-card">
                            <i class="fas fa-trophy"></i>
                            <h3>Tournois</h3>
                            <span class="stat-number">8</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="../js/app.js"></script>
</body>
</html>



