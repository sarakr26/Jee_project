Write-Host "=== Test Federation Dashboard ===" -ForegroundColor Green

Write-Host "`n1. Checking application status..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8083/GestionClubsChess-1.0-SNAPSHOT/" -TimeoutSec 5
    if ($response.StatusCode -eq 200) {
        Write-Host "✓ Application is running and accessible" -ForegroundColor Green
    }
} catch {
    Write-Host "✗ Application not accessible. Check if Tomcat is started." -ForegroundColor Red
    Write-Host "Start application with: mvn tomcat7:run" -ForegroundColor Yellow
    exit 1
}

Write-Host "`n2. Test instructions:" -ForegroundColor Cyan
Write-Host "   - Open your browser" -ForegroundColor White
Write-Host "   - Go to: http://localhost:8083/GestionClubsChess-1.0-SNAPSHOT/" -ForegroundColor White
Write-Host "   - Login with:" -ForegroundColor White
Write-Host "     • Email: federation@chess.ma" -ForegroundColor Gray
Write-Host "     • Password: test123" -ForegroundColor Gray
Write-Host "   - You should be redirected to the Federation dashboard" -ForegroundColor White

Write-Host "`n3. Features to test:" -ForegroundColor Cyan
Write-Host "   ✓ Key indicators (active clubs, pending requests)" -ForegroundColor White
Write-Host "   ✓ Quick actions (create event, search club)" -ForegroundColor White
Write-Host "   ✓ Validate club creation requests" -ForegroundColor White
Write-Host "   ✓ Validate integration requests" -ForegroundColor White
Write-Host "   ✓ Display urgent and upcoming events" -ForegroundColor White

Write-Host "`n4. If you don't have test data yet:" -ForegroundColor Yellow
Write-Host "   - Run the SQL script: test_federation_data.sql" -ForegroundColor White
Write-Host "   - This will create a FEDERATION user and test data" -ForegroundColor White

Write-Host "`n=== Test completed ===" -ForegroundColor Green
