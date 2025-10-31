# Sistema de Temperatura por CEP - Full Cycle

Sistema distribuído em Go que recebe um CEP, identifica a cidade e retorna o clima atual (temperatura em graus Celsius, Fahrenheit e Kelvin) com implementação completa de OpenTelemetry e Zipkin para tracing distribuído.

## 🌐 Acesso em Produção

- Endpoint principal (Service A): https://service-a-l4yml3h6pq-uc.a.run.app
- Endpoint interno (Service B): https://service-b-l4yml3h6pq-uc.a.run.app

O endpoint principal (`POST /`) já pode ser testado diretamente com ferramentas como `curl`, Postman ou Insomnia.

## 📋 Arquitetura

O sistema é composto por dois serviços principais:

### Serviço A (Input Service)

- **Porta**: 8080
- **Responsabilidade**: Receber requisições do cliente, validar CEP e encaminhar para o Serviço B
- **Endpoint**: `POST /`
- **Validações**:
  - CEP deve ser uma string de exatamente 8 dígitos numéricos
  - Retorna 422 se o formato for inválido

### Serviço B (Orchestration Service)

- **Porta**: 8081
- **Responsabilidade**: Buscar dados do CEP, consultar temperatura e realizar conversões
- **Endpoint**: `GET /:cep`
- **Integrações**:
  - ViaCEP: Busca informações da localidade
  - WeatherAPI: Consulta temperatura atual
- **Validações**:
  - Retorna 422 se o CEP for inválido
  - Retorna 404 se o CEP não for encontrado
  - Retorna 200 com os dados de temperatura em caso de sucesso

### Infraestrutura de Observabilidade

- **OpenTelemetry Collector**: Coleta traces dos serviços
- **Zipkin**: Interface web para visualização de traces distribuídos

## 🚀 Funcionalidades

- ✅ Validação de CEP (8 dígitos numéricos)
- ✅ Consulta de localidade via ViaCEP
- ✅ Consulta de temperatura via WeatherAPI
- ✅ Conversão automática de temperaturas (Celsius, Fahrenheit, Kelvin)
- ✅ Tracing distribuído com OpenTelemetry
- ✅ Visualização de traces com Zipkin
- ✅ Spans customizados para medir tempo de resposta das APIs externas

## 📦 Pré-requisitos

- Docker
- Docker Compose

## 🔧 Como Executar

### 1. Clone o repositório e navegue até o diretório do projeto

### 2. Inicie todos os serviços com Docker Compose

```bash
docker-compose up --build
```

Este comando irá:

- Construir as imagens dos Serviços A e B
- Iniciar o OpenTelemetry Collector
- Iniciar o Zipkin
- Configurar a rede entre todos os serviços

### 3. Aguarde todos os serviços estarem prontos

Você verá mensagens similares a:

```
service-a     | Service A running on port 8080
service-b     | Service B running on port 8081
zipkin        | ** Started **
```

### 4. Acesse as interfaces

- **Serviço A**: http://localhost:8080
- **Serviço B**: http://localhost:8081
- **Zipkin UI**: http://localhost:9411

## 📝 Como Testar

### Teste 1: Requisição com CEP válido

```bash
curl -X POST http://localhost:8080 -H "Content-Type: application/json" -d "{\"cep\": \"01310100\"}"
```

**Resposta esperada** (200 OK):

```json
{
  "city": "São Paulo",
  "temp_C": 25.0,
  "temp_F": 77.0,
  "temp_K": 298.0
}
```

### Teste 2: CEP com formato inválido

```bash
curl -X POST http://localhost:8080 -H "Content-Type: application/json" -d "{\"cep\": \"123\"}"
```

**Resposta esperada** (422 Unprocessable Entity):

```json
{
  "message": "invalid zipcode"
}
```

### Teste 3: CEP não encontrado

```bash
curl -X POST http://localhost:8080 -H "Content-Type: application/json" -d "{\"cep\": \"99999999\"}"
```

**Resposta esperada** (404 Not Found):

```json
{
  "message": "can not find zipcode"
}
```

### Exemplos de CEPs válidos para teste:

- `01310100` - São Paulo/SP
- `20040020` - Rio de Janeiro/RJ
- `30130100` - Belo Horizonte/MG
- `40020000` - Salvador/BA
- `29902555` - Linhares/ES

## 🔍 Visualizando Traces no Zipkin

1. Acesse http://localhost:9411
2. Clique em "Run Query" para ver todos os traces
3. Clique em um trace específico para ver detalhes
4. Você verá:
   - **service-a**: Span principal da requisição
   - **service-b**: Span de processamento
   - **fetchCEP**: Span da chamada à API ViaCEP
   - **fetchTemperature**: Span da chamada à API WeatherAPI

### O que observar nos traces:

- **Latência total**: Tempo desde a requisição até a resposta
- **Tempo de cada span**: Identifica gargalos nas APIs externas
- **Propagação de contexto**: Como o trace ID é propagado entre os serviços
- **Hierarquia de spans**: Relação pai-filho entre as operações

## 🛠️ Tecnologias Utilizadas

- **Go 1.21**: Linguagem de programação
- **OpenTelemetry**: Instrumentação de observabilidade
- **Zipkin**: Visualização de traces distribuídos
- **Docker & Docker Compose**: Containerização e orquestração
- **ViaCEP API**: Consulta de CEPs brasileiros
- **WeatherAPI**: Consulta de temperatura

## 📊 Conversões de Temperatura

O sistema realiza as seguintes conversões automáticas:

- **Fahrenheit**: `F = C × 1.8 + 32`
- **Kelvin**: `K = C + 273`

## 🔐 API Keys

O projeto utiliza uma chave da WeatherAPI já configurada para testes. Se necessário, você pode criar sua própria chave em:

- https://www.weatherapi.com/signup.aspx

Para alterar a chave, edite a constante `weatherAPIKey` em `service-b/main.go`.

## 🛑 Parar os Serviços

Para parar todos os serviços:

```bash
docker-compose down
```

Para parar e remover volumes:

```bash
docker-compose down -v
```

## ☁️ Deploy na Nuvem (Google Cloud Run)

### URLs em Produção

🌐 **Sistema em funcionamento**:

- **Service A (Endpoint Principal)**: https://service-a-l4yml3h6pq-uc.a.run.app
- **Service B (Interno)**: https://service-b-l4yml3h6pq-uc.a.run.app

### Exemplo de uso em produção:

```bash
curl -X POST https://service-a-l4yml3h6pq-uc.a.run.app \
  -H "Content-Type: application/json" \
  -d '{"cep": "01310100"}'
```

### Como fazer deploy

1. **Instale o Google Cloud SDK**:

   ```bash
   # https://cloud.google.com/sdk/docs/install
   ```

2. **Faça login e configure o projeto**:

   ```bash
   gcloud auth login
   gcloud config set project SEU_PROJECT_ID
   ```

3. **Execute o script de deploy**:

   ```bash
   # Linux/Mac
   chmod +x deploy-to-gcp.sh
   ./deploy-to-gcp.sh

   # Windows PowerShell
   .\deploy-to-gcp.ps1
   ```

**Nota**: Edite os scripts `deploy-to-gcp.sh` ou `deploy-to-gcp.ps1` e substitua `your-project-id` pelo seu PROJECT_ID do Google Cloud.

## 📈 Monitoramento e Debugging

### Logs dos serviços (Local)

```bash
# Ver logs do Serviço A
docker logs service-a -f

# Ver logs do Serviço B
docker logs service-b -f

# Ver logs do OTEL Collector
docker logs otel-collector -f
```

### Logs na nuvem (Google Cloud)

```bash
# Ver logs do Service A na nuvem
gcloud logs read "resource.type=cloud_run_revision AND resource.labels.service_name=service-a" --limit 50

# Ver logs do Service B na nuvem
gcloud logs read "resource.type=cloud_run_revision AND resource.labels.service_name=service-b" --limit 50
```

### Verificar saúde dos containers

```bash
# Local
docker-compose ps

# Nuvem
gcloud run services list
```
