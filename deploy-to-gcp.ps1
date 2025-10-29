# Script para deploy no Google Cloud Run (PowerShell)
# Execute: .\deploy-to-gcp.ps1

# Configurações
$PROJECT_ID = "labsgo"  # Substitua pelo seu PROJECT_ID
$REGION = "us-central1"

Write-Host "===================================" -ForegroundColor Green
Write-Host "Deploy Sistema Temperatura CEP" -ForegroundColor Green
Write-Host "===================================" -ForegroundColor Green
Write-Host ""

# Verificar se gcloud está instalado
if (-not (Get-Command gcloud -ErrorAction SilentlyContinue)) {
    Write-Host "❌ gcloud CLI não está instalado." -ForegroundColor Red
    Write-Host "   Instale em: https://cloud.google.com/sdk/docs/install" -ForegroundColor Yellow
    exit 1
}

# Verificar se está logado
$authAccount = gcloud auth list --filter=status:ACTIVE --format="value(account)" 2>$null
if (-not $authAccount) {
    Write-Host "❌ Não está logado no gcloud." -ForegroundColor Red
    Write-Host "   Execute: gcloud auth login" -ForegroundColor Yellow
    exit 1
}

# Definir projeto
Write-Host "📝 Configurando projeto: $PROJECT_ID" -ForegroundColor Cyan
gcloud config set project $PROJECT_ID

# Habilitar APIs necessárias
Write-Host "🔧 Habilitando APIs necessárias..." -ForegroundColor Cyan
gcloud services enable cloudbuild.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable containerregistry.googleapis.com

Write-Host ""
Write-Host "🚀 Iniciando deploy..." -ForegroundColor Yellow

# Deploy Service B primeiro (pois Service A depende dele)
Write-Host ""
Write-Host "📦 Fazendo deploy do Service B..." -ForegroundColor Cyan
Set-Location "service-b"

gcloud builds submit --tag "gcr.io/$PROJECT_ID/service-b" .
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Falha no build do Service B" -ForegroundColor Red
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
    Write-Host "❌ Falha no deploy do Service B" -ForegroundColor Red
    exit 1
}

# Obter URL do Service B
$SERVICE_B_URL = gcloud run services describe service-b --region=$REGION --format="value(status.url)"
Write-Host "Service B deployed: $SERVICE_B_URL" -ForegroundColor Green

Set-Location ".."

# Deploy Service A
Write-Host ""
Write-Host "📦 Fazendo deploy do Service A..." -ForegroundColor Cyan
Set-Location "service-a"

gcloud builds submit --tag "gcr.io/$PROJECT_ID/service-a" .
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Falha no build do Service A" -ForegroundColor Red
    exit 1
}

gcloud run deploy service-a `
    --image "gcr.io/$PROJECT_ID/service-a" `
    --region $REGION `
    --platform managed `
    --allow-unauthenticated `
    --port 8080 `
    --memory 512Mi `
    --cpu 1 `
    --max-instances 10 `
    --set-env-vars "SERVICE_B_URL=$SERVICE_B_URL"

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Falha no deploy do Service A" -ForegroundColor Red
    exit 1
}

# Obter URL do Service A
$SERVICE_A_URL = gcloud run services describe service-a --region=$REGION --format="value(status.url)"
Write-Host "Service A deployed: $SERVICE_A_URL" -ForegroundColor Green

Set-Location ".."

Write-Host ""
Write-Host "🎉 Deploy concluído com sucesso!" -ForegroundColor Green
Write-Host ""
Write-Host "🔗 URLs dos serviços:" -ForegroundColor Cyan
Write-Host "   Service A (principal): $SERVICE_A_URL" -ForegroundColor White
Write-Host "   Service B (interno):   $SERVICE_B_URL" -ForegroundColor White
Write-Host ""
Write-Host "🧪 Teste o sistema:" -ForegroundColor Cyan
Write-Host "   curl -X POST $SERVICE_A_URL \" -ForegroundColor White
Write-Host "     -H 'Content-Type: application/json' \" -ForegroundColor White
Write-Host "     -d '{`"cep`": `"01310100`"}'" -ForegroundColor White
Write-Host ""
Write-Host "📝 Adicione essas URLs ao README.md" -ForegroundColor Yellow