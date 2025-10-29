# Guia de Deploy para Google Cloud Run

Este guia explica como fazer o deploy do sistema de temperatura por CEP no Google Cloud Run.

## 📋 Pré-requisitos

### 1. Conta Google Cloud Platform

- Crie uma conta em https://cloud.google.com
- Ative a cobrança (necessário para usar Cloud Run)
- Crie um novo projeto ou use um existente

### 2. Instalar Google Cloud SDK

- **Windows**: Baixe de https://cloud.google.com/sdk/docs/install
- **Mac**: `brew install --cask google-cloud-sdk`
- **Linux**: Siga as instruções em https://cloud.google.com/sdk/docs/install

### 3. Configurar autenticação

```bash
# Fazer login
gcloud auth login

# Listar projetos disponíveis
gcloud projects list

# Configurar projeto padrão
gcloud config set project SEU_PROJECT_ID
```

## 🚀 Processo de Deploy

### Passo 1: Preparar o ambiente

1. **Clone/baixe o projeto** (se ainda não tiver)
2. **Edite o script de deploy**:
   - Abra `deploy-to-gcp.sh` (Linux/Mac) ou `deploy-to-gcp.ps1` (Windows)
   - Substitua `your-project-id` pelo seu PROJECT_ID do Google Cloud
   - Opcionalmente, altere a REGION se preferir outra região

### Passo 2: Executar o deploy

**Linux/Mac:**

```bash
chmod +x deploy-to-gcp.sh
./deploy-to-gcp.sh
```

**Windows PowerShell:**

```powershell
.\deploy-to-gcp.ps1
```

### Passo 3: Aguardar o processo

O script irá:

1. ✅ Verificar pré-requisitos (gcloud instalado e logado)
2. ✅ Habilitar APIs necessárias
3. ✅ Fazer build e deploy do Service B
4. ✅ Fazer build e deploy do Service A (com URL do Service B)
5. ✅ Mostrar as URLs finais dos serviços

## 🎯 Resultado Esperado

Após o deploy bem-sucedido, você verá:

```
🎉 Deploy concluído com sucesso!

🔗 URLs dos serviços:
   Service A (principal): https://service-a-abc123-uc.a.run.app
   Service B (interno):   https://service-b-def456-uc.a.run.app

🧪 Teste o sistema:
   curl -X POST https://service-a-abc123-uc.a.run.app \
     -H 'Content-Type: application/json' \
     -d '{"cep": "01310100"}'
```

## 🧪 Testando o Sistema

### Teste básico (CEP válido)

```bash
curl -X POST https://service-a-SEU-URL.run.app \
  -H "Content-Type: application/json" \
  -d '{"cep": "01310100"}'
```

### Teste de validação (CEP inválido)

```bash
curl -X POST https://service-a-SEU-URL.run.app \
  -H "Content-Type: application/json" \
  -d '{"cep": "123"}'
```

### Teste de CEP não encontrado

```bash
curl -X POST https://service-a-SEU-URL.run.app \
  -H "Content-Type: application/json" \
  -d '{"cep": "00000000"}'
```

## 🔍 Monitoramento

### Visualizar logs

```bash
# Logs do Service A
gcloud logs read "resource.type=cloud_run_revision AND resource.labels.service_name=service-a" --limit 50

# Logs do Service B
gcloud logs read "resource.type=cloud_run_revision AND resource.labels.service_name=service-b" --limit 50
```

### Status dos serviços

```bash
gcloud run services list
```

### Métricas no console

- Acesse https://console.cloud.google.com/run
- Clique em cada serviço para ver métricas de CPU, memória e requisições

## 💰 Custos

O Cloud Run cobra por:

- **CPU e Memória**: Apenas durante execução das requisições
- **Requisições**: $0.40 por milhão de requisições
- **Egress**: Tráfego de saída (APIs externas)

Para desenvolvimento/testes, os custos são mínimos (alguns centavos por mês).

## 🗑️ Limpeza

Para remover os serviços e evitar custos:

```bash
# Remover serviços
gcloud run services delete service-a --region=us-central1
gcloud run services delete service-b --region=us-central1

# Remover imagens do Container Registry
gcloud container images delete gcr.io/SEU_PROJECT_ID/service-a
gcloud container images delete gcr.io/SEU_PROJECT_ID/service-b
```

## ❗ Troubleshooting

### Problema: "Permission denied"

**Solução**: Verifique se tem permissões de Cloud Run Developer no projeto

### Problema: "API not enabled"

**Solução**: O script habilita as APIs automaticamente, mas você pode fazer manualmente:

```bash
gcloud services enable cloudbuild.googleapis.com
gcloud services enable run.googleapis.com
```

### Problema: "Build failed"

**Solução**: Verifique se os arquivos `go.mod` e `go.sum` estão presentes em cada serviço

### Problema: Service A não consegue conectar no Service B

**Solução**: Verifique se a variável de ambiente SERVICE_B_URL está configurada corretamente no deploy do Service A
