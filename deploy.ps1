Write-Host "Deploying ChuperAmigos..." -ForegroundColor Cyan

# Copy latest game to public/
Copy-Item "$PSScriptRoot\Index.html" "$PSScriptRoot\public\index.html" -Force
Write-Host "OK: public/index.html updated" -ForegroundColor Green

# Deploy to Firebase
Set-Location $PSScriptRoot
firebase deploy --only hosting

Write-Host "Done! Live at https://chuperamigos-96679.web.app" -ForegroundColor Cyan
