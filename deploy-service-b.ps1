# Deploy simples - Service B
# Configurações
$PROJECT_ID = "labsgo"
$REGION = "us-central1"

Write-Host "Fazendo deploy do Service B..." -ForegroundColor Cyan
Set-Location "service-b"

gcloud builds submit --tag "gcr.io/$PROJECT_ID/service-b" .
if ($LASTEXITCODE -ne 0) {
    Write-Host "Falha no build do Service B" -ForegroundColor Red
    exit 1
}

gcloud run deploy service-b `
    --image "gcr.io/$PROJECT_ID/service-b" `
    --region $REGION `
    --platform managed `
    --allow-unauthenticated `
    --port 8081 `
    --memory 512Mi `
    --cpu 1 `
    --max-instances 10

if ($LASTEXITCODE -ne 0) {
    Write-Host "Falha no deploy do Service B" -ForegroundColor Red
    exit 1
}

# Obter URLs
$SERVICE_B_URL = gcloud run services describe service-b --region=$REGION --format="value(status.url)"
$SERVICE_A_URL = gcloud run services describe service-a --region=$REGION --format="value(status.url)"

Set-Location ".."

Write-Host ""
Write-Host "Deploy concluido com sucesso!" -ForegroundColor Green
Write-Host ""
Write-Host "URLs dos servicos:" -ForegroundColor Cyan
Write-Host "  Service A (principal): $SERVICE_A_URL" -ForegroundColor White
Write-Host "  Service B (interno):   $SERVICE_B_URL" -ForegroundColor White
Write-Host ""
Write-Host "Teste o sistema:" -ForegroundColor Cyan
Write-Host "Invoke-RestMethod -Uri '$SERVICE_A_URL' -Method POST -ContentType 'application/json' -Body '{\"cep\": \"01310100\"}'" -ForegroundColor White