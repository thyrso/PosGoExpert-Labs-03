#!/bin/bash

# Script para deploy no Google Cloud Run
# Execute: chmod +x deploy-to-gcp.sh && ./deploy-to-gcp.sh

# Configurações
PROJECT_ID="your-project-id"  # Substitua pelo seu PROJECT_ID
REGION="us-central1"

echo "==================================="
echo "Deploy Sistema Temperatura CEP"
echo "==================================="
echo ""

# Verificar se gcloud está instalado
if ! command -v gcloud &> /dev/null; then
    echo "❌ gcloud CLI não está instalado."
    echo "   Instale em: https://cloud.google.com/sdk/docs/install"
    exit 1
fi

# Verificar se está logado
if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" | grep -q .; then
    echo "❌ Não está logado no gcloud."
    echo "   Execute: gcloud auth login"
    exit 1
fi

# Definir projeto
echo "📝 Configurando projeto: $PROJECT_ID"
gcloud config set project $PROJECT_ID

# Habilitar APIs necessárias
echo "🔧 Habilitando APIs necessárias..."
gcloud services enable cloudbuild.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable containerregistry.googleapis.com

echo ""
echo "🚀 Iniciando deploy..."

# Deploy Service B primeiro (pois Service A depende dele)
echo ""
echo "📦 Fazendo deploy do Service B..."
cd service-b
gcloud builds submit --tag gcr.io/$PROJECT_ID/service-b .
if [ $? -ne 0 ]; then
    echo "❌ Falha no build do Service B"
    exit 1
fi

gcloud run deploy service-b \
    --image gcr.io/$PROJECT_ID/service-b \
    --region $REGION \
    --platform managed \
    --allow-unauthenticated \
    --port 8081 \
    --memory 512Mi \
    --cpu 1 \
    --max-instances 10

if [ $? -ne 0 ]; then
    echo "❌ Falha no deploy do Service B"
    exit 1
fi

# Obter URL do Service B
SERVICE_B_URL=$(gcloud run services describe service-b --region=$REGION --format='value(status.url)')
echo "✅ Service B deployed: $SERVICE_B_URL"

cd ..

# Deploy Service A
echo ""
echo "📦 Fazendo deploy do Service A..."
cd service-a
gcloud builds submit --tag gcr.io/$PROJECT_ID/service-a .
if [ $? -ne 0 ]; then
    echo "❌ Falha no build do Service A"
    exit 1
fi

gcloud run deploy service-a \
    --image gcr.io/$PROJECT_ID/service-a \
    --region $REGION \
    --platform managed \
    --allow-unauthenticated \
    --port 8080 \
    --memory 512Mi \
    --cpu 1 \
    --max-instances 10 \
    --set-env-vars SERVICE_B_URL=$SERVICE_B_URL

if [ $? -ne 0 ]; then
    echo "❌ Falha no deploy do Service A"
    exit 1
fi

# Obter URL do Service A
SERVICE_A_URL=$(gcloud run services describe service-a --region=$REGION --format='value(status.url)')
echo "✅ Service A deployed: $SERVICE_A_URL"

cd ..

echo ""
echo "🎉 Deploy concluído com sucesso!"
echo ""
echo "🔗 URLs dos serviços:"
echo "   Service A (principal): $SERVICE_A_URL"
echo "   Service B (interno):   $SERVICE_B_URL"
echo ""
echo "🧪 Teste o sistema:"
echo "   curl -X POST $SERVICE_A_URL \\"
echo "     -H 'Content-Type: application/json' \\"
echo "     -d '{\"cep\": \"01310100\"}'"
echo ""
echo "📝 Adicione essas URLs ao README.md"