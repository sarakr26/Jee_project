# Script PowerShell pour supprimer la colonne federation_id de la table Evenement
# Exécution automatique via XAMPP

Write-Host "Suppression de la colonne federation_id de la table Evenement..." -ForegroundColor Yellow

# Chemin vers MySQL dans XAMPP
$mysqlPath = "C:\xampp\mysql\bin\mysql.exe"

# Vérifier si MySQL existe
if (Test-Path $mysqlPath) {
    Write-Host "MySQL trouvé dans XAMPP" -ForegroundColor Green
    
    # Requête SQL pour supprimer la colonne
    $sqlQuery = @"
USE chess_club_db;
ALTER TABLE Evenement DROP FOREIGN KEY IF EXISTS evenement_ibfk_1;
ALTER TABLE Evenement DROP COLUMN IF EXISTS federation_id;
DESCRIBE Evenement;
"@
    
    try {
        # Exécuter la requête
        Write-Host "Exécution de la requête SQL..." -ForegroundColor Cyan
        & $mysqlPath -u root -e $sqlQuery
        
        Write-Host "✅ Colonne federation_id supprimée avec succès !" -ForegroundColor Green
        Write-Host "La table Evenement a été mise à jour." -ForegroundColor Green
        
    } catch {
        Write-Host "❌ Erreur lors de l'exécution : $($_.Exception.Message)" -ForegroundColor Red
    }
} else {
    Write-Host "❌ MySQL non trouvé dans XAMPP. Vérifiez que XAMPP est installé." -ForegroundColor Red
    Write-Host "Chemin attendu : $mysqlPath" -ForegroundColor Red
}

Write-Host "`nAppuyez sur une touche pour continuer..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
