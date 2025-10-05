# Script de déploiement pour GestionClubsChess
# Assurez-vous d'avoir Tomcat 10+ installé et configuré

Write-Host "=== Déploiement de GestionClubsChess ===" -ForegroundColor Green

# 1. Construire le WAR
Write-Host "1. Construction du WAR..." -ForegroundColor Yellow
mvn clean package

if ($LASTEXITCODE -ne 0) {
    Write-Host "Erreur lors de la construction du WAR" -ForegroundColor Red
    exit 1
}

# 2. Vérifier que le WAR existe
$warFile = "target\GestionClubsChess-1.0-SNAPSHOT.war"
if (-not (Test-Path $warFile)) {
    Write-Host "Le fichier WAR n'existe pas: $warFile" -ForegroundColor Red
    exit 1
}

Write-Host "2. WAR construit avec succès: $warFile" -ForegroundColor Green

# 3. Instructions pour le déploiement manuel
Write-Host "`n=== Instructions de déploiement ===" -ForegroundColor Cyan
Write-Host "Pour déployer manuellement:" -ForegroundColor White
Write-Host "1. Copiez le fichier WAR vers le dossier webapps de Tomcat:" -ForegroundColor White
Write-Host "   copy $warFile C:\apache-tomcat-10.x.x\webapps\" -ForegroundColor Gray
Write-Host "`n2. Lancez Tomcat:" -ForegroundColor White
Write-Host "   C:\apache-tomcat-10.x.x\bin\startup.bat" -ForegroundColor Gray
Write-Host "`n3. Accédez à votre application:" -ForegroundColor White
Write-Host "   http://localhost:8080/GestionClubsChess-1.0-SNAPSHOT/" -ForegroundColor Gray
Write-Host "   http://localhost:8080/GestionClubsChess-1.0-SNAPSHOT/home" -ForegroundColor Gray

Write-Host "`n=== Alternative: Déploiement automatique ===" -ForegroundColor Cyan
Write-Host "Si vous avez Tomcat installé, décommentez les lignes ci-dessous:" -ForegroundColor White
Write-Host "# `$tomcatPath = 'C:\apache-tomcat-10.1.x\webapps'" -ForegroundColor Gray
Write-Host "# Copy-Item `$warFile `$tomcatPath -Force" -ForegroundColor Gray
Write-Host "# Write-Host 'Application déployée avec succès!' -ForegroundColor Green" -ForegroundColor Gray

