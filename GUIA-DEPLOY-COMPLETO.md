# 🚀 Guia Completo: Deploy no Google Cloud Run (Do Zero ao Deploy)

## 📋 Passo 1: Criar Conta e Projeto no Google Cloud

### 1.1 Criar conta Google Cloud

1. Acesse: https://cloud.google.com
2. Clique em **"Get started for free"**
3. Faça login com sua conta Google (ou crie uma)
4. **IMPORTANTE**: Você precisa adicionar um cartão de crédito, mas ganha $300 de créditos grátis
5. Complete o processo de cadastro

### 1.2 Criar um novo projeto

1. No console (https://console.cloud.google.com)
2. No topo da página, clique no seletor de projetos
3. Clique em **"NEW PROJECT"**
4. Dê um nome para seu projeto (ex: "sistema-temperatura-cep")
5. Anote o **PROJECT ID** (será gerado automaticamente, ex: "sistema-temperatura-cep-123456")

## 📥 Passo 2: Instalar Google Cloud SDK

### Windows (Recomendado)

1. Baixe o instalador: https://cloud.google.com/sdk/docs/install
2. Execute o arquivo `.msi` baixado
3. Siga o wizard de instalação (deixe todas as opções padrão marcadas)
4. **IMPORTANTE**: Marque a opção "Run 'gcloud init'" no final

### Verificar instalação

Abra um novo PowerShell e digite:

```powershell
gcloud --version
```

## 🔐 Passo 3: Configurar Autenticação

### 3.1 Fazer login

```powershell
gcloud auth login
```

- Isso abrirá seu navegador
- Faça login com a mesma conta do Google Cloud
- Autorize o acesso

### 3.2 Configurar projeto padrão

```powershell
# Listar projetos disponíveis
gcloud projects list

# Configurar seu projeto (substitua pelo SEU PROJECT_ID)
gcloud config set project SEU_PROJECT_ID_AQUI
```

### 3.3 Verificar configuração

```powershell
gcloud config list
```

## ⚙️ Passo 4: Preparar o Código

### 4.1 Editar script de deploy

1. Abra o arquivo `deploy-to-gcp.ps1`
2. Na linha 4, substitua:
   ```powershell
   $PROJECT_ID = "your-project-id"  # MUDE AQUI
   ```
   Por:
   ```powershell
   $PROJECT_ID = "SEU_PROJECT_ID_AQUI"  # Use o PROJECT_ID do passo 3.2
   ```

### 4.2 Verificar estrutura dos arquivos

Certifique-se de que você tem:

```
📁 07/
├── 📁 service-a/
│   ├── main.go
│   ├── go.mod
│   ├── go.sum
│   ├── Dockerfile
│   └── .gcloudignore
├── 📁 service-b/
│   ├── main.go
│   ├── go.mod
│   ├── go.sum
│   ├── Dockerfile
│   └── .gcloudignore
├── deploy-to-gcp.ps1
└── README.md
```

## 🚀 Passo 5: Executar o Deploy

### 5.1 Abrir PowerShell no diretório do projeto

```powershell
# Navegue até o diretório (ajuste o caminho)
cd "d:\Pessoal\cursos\pos-graduação\fullcycle\Go\projects\07"

# Verificar se está no diretório correto
ls
```

### 5.2 Executar o script de deploy

```powershell
.\deploy-to-gcp.ps1
```

### 5.3 O que o script faz automaticamente:

1. ✅ Verifica se gcloud está instalado
2. ✅ Verifica se você está logado
3. ✅ Habilita as APIs necessárias (Cloud Build, Cloud Run, Container Registry)
4. ✅ Faz build do Service B
5. ✅ Deploy do Service B no Cloud Run
6. ✅ Faz build do Service A
7. ✅ Deploy do Service A no Cloud Run (conectado ao Service B)
8. ✅ Mostra as URLs finais

## 🎯 Passo 6: Resultado do Deploy

Após alguns minutos, você verá algo assim:

```
🎉 Deploy concluído com sucesso!

🔗 URLs dos serviços:
   Service A (principal): https://service-a-abc123def-uc.a.run.app
   Service B (interno):   https://service-b-xyz789ghi-uc.a.run.app

🧪 Teste o sistema:
   curl -X POST https://service-a-abc123def-uc.a.run.app \
     -H 'Content-Type: application/json' \
     -d '{"cep": "01310100"}'
```

## ✅ Passo 7: Testar o Sistema

### 7.1 Teste básico (PowerShell)

```powershell
# Substitua pela sua URL do Service A
$serviceUrl = "https://service-a-ABC123-uc.a.run.app"

# Teste com CEP válido
Invoke-RestMethod -Uri $serviceUrl -Method POST -ContentType "application/json" -Body '{"cep": "01310100"}'

# Teste com CEP inválido
Invoke-RestMethod -Uri $serviceUrl -Method POST -ContentType "application/json" -Body '{"cep": "123"}'
```

### 7.2 Teste no navegador

1. Acesse: https://console.cloud.google.com/run
2. Clique no service-a
3. Copie a URL
4. Use um cliente REST (Postman, Insomnia) ou curl

## 📝 Passo 8: Atualizar o README

1. Abra o arquivo `README.md`
2. Encontre a seção "URLs em Produção"
3. Substitua as URLs de exemplo pelas URLs reais que o script mostrou

## 💰 Custos Estimados

Para este projeto de teste:

- **Primeiros testes**: GRÁTIS (dentro dos créditos de $300)
- **Uso normal**: ~$0.01 - $0.10 por mês
- **Cloud Run cobra apenas quando há requisições**

## 🔍 Monitoramento

### Ver logs no console web:

1. Acesse: https://console.cloud.google.com/run
2. Clique no serviço desejado
3. Aba "LOGS"

### Ver logs via linha de comando:

```powershell
# Logs do Service A
gcloud logs read "resource.type=cloud_run_revision AND resource.labels.service_name=service-a" --limit 50

# Logs do Service B
gcloud logs read "resource.type=cloud_run_revision AND resource.labels.service_name=service-b" --limit 50
```

## ❗ Problemas Comuns

### "Permission denied"

**Solução**: Verifique se selecionou o projeto correto:

```powershell
gcloud config set project SEU_PROJECT_ID
```

### "API not enabled"

**Solução**: Execute manualmente:

```powershell
gcloud services enable cloudbuild.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable containerregistry.googleapis.com
```

### "Build failed"

**Solução**: Verifique se os arquivos go.mod e go.sum existem:

```powershell
# No diretório service-a
cd service-a
go mod tidy
cd ..

# No diretório service-b
cd service-b
go mod tidy
cd ..
```

### Script PowerShell não executa

**Solução**: Liberar política de execução:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## 🗑️ Como Limpar (Evitar Custos)

Quando terminar os testes:

```powershell
# Deletar os serviços
gcloud run services delete service-a --region=us-central1 --quiet
gcloud run services delete service-b --region=us-central1 --quiet

# Deletar as imagens
gcloud container images delete gcr.io/SEU_PROJECT_ID/service-a --quiet
gcloud container images delete gcr.io/SEU_PROJECT_ID/service-b --quiet
```

---

## 📞 Precisa de Ajuda?

Se encontrar algum erro:

1. Copie a mensagem de erro completa
2. Verifique se seguiu todos os passos
3. Consulte os logs do Cloud Build: https://console.cloud.google.com/cloud-build
