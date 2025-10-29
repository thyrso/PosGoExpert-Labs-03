# 🔧 Script para Instalar Google Cloud SDK corretamente

Write-Host "=== Instalação Google Cloud SDK ===" -ForegroundColor Green
Write-Host ""

# 1. Baixar o instalador
Write-Host "📥 Baixando Google Cloud SDK..." -ForegroundColor Cyan
$downloadUrl = "https://dl.google.com/dl/cloudsdk/channels/rapid/GoogleCloudSDKInstaller.exe"
$tempPath = "$env:TEMP\GoogleCloudSDKInstaller.exe"

try {
    Invoke-WebRequest -Uri $downloadUrl -OutFile $tempPath
    Write-Host "✅ Download concluído!" -ForegroundColor Green
} catch {
    Write-Host "❌ Erro no download. Faça download manual em:" -ForegroundColor Red
    Write-Host "   https://cloud.google.com/sdk/docs/install" -ForegroundColor Yellow
    exit 1
}

# 2. Executar instalador
Write-Host ""
Write-Host "🚀 Executando instalador..." -ForegroundColor Cyan
Write-Host "⚠️  IMPORTANTE: Durante a instalação:" -ForegroundColor Yellow
Write-Host "   - Marque 'Add gcloud to PATH'" -ForegroundColor Yellow
Write-Host "   - Marque 'Run gcloud init'" -ForegroundColor Yellow
Write-Host ""

Start-Process -FilePath $tempPath -Wait

Write-Host ""
Write-Host "✅ Instalação concluída!" -ForegroundColor Green
Write-Host "🔄 Feche e reabra o PowerShell, depois execute:" -ForegroundColor Cyan
Write-Host "   gcloud --version" -ForegroundColor White
Write-Host ""
Write-Host "📝 Se ainda não funcionar, execute manualmente:" -ForegroundColor Yellow
Write-Host "   gcloud init" -ForegroundColor White