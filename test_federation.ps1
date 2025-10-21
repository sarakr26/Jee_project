# Script de test pour le tableau de bord Federation
Write-Host "=== Test du Tableau de Bord Federation ===" -ForegroundColor Green

Write-Host "`n1. Verification de l'etat de l'application..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8083/GestionClubsChess-1.0-SNAPSHOT/" -TimeoutSec 5
    if ($response.StatusCode -eq 200) {
        Write-Host "✓ Application demarree et accessible" -ForegroundColor Green
    }
} catch {
    Write-Host "✗ Application non accessible. Verifiez que Tomcat est demarre." -ForegroundColor Red
    Write-Host "Demarrez l'application avec: mvn tomcat7:run" -ForegroundColor Yellow
    exit 1
}

Write-Host "`n2. Instructions de test:" -ForegroundColor Cyan
Write-Host "   - Ouvrez votre navigateur" -ForegroundColor White
Write-Host "   - Allez sur: http://localhost:8083/GestionClubsChess-1.0-SNAPSHOT/" -ForegroundColor White
Write-Host "   - Connectez-vous avec:" -ForegroundColor White
Write-Host "     • Email: federation@chess.ma" -ForegroundColor Gray
Write-Host "     • Mot de passe: test123" -ForegroundColor Gray
Write-Host "   - Vous devriez etre redirige vers le tableau de bord Federation" -ForegroundColor White

Write-Host "`n3. Fonctionnalites a tester:" -ForegroundColor Cyan
Write-Host "   ✓ Indicateurs cles (clubs actifs, demandes en attente)" -ForegroundColor White
Write-Host "   ✓ Actions rapides (creer evenement, rechercher club)" -ForegroundColor White
Write-Host "   ✓ Validation des demandes de creation de club" -ForegroundColor White
Write-Host "   ✓ Validation des demandes d'integration" -ForegroundColor White
Write-Host "   ✓ Affichage des evenements urgents et prochains" -ForegroundColor White

Write-Host "`n4. Si vous n'avez pas encore de donnees de test:" -ForegroundColor Yellow
Write-Host "   - Executez le script SQL: test_federation_data.sql" -ForegroundColor White
Write-Host "   - Cela creera un utilisateur FEDERATION et des donnees de test" -ForegroundColor White

Write-Host "`n=== Test termine ===" -ForegroundColor Green