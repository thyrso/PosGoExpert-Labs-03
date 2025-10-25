# 📚 Índice da Documentação

---

## Documentação Disponível

### [README.md](./README.md) - **START AQUI**

Documentação principal do projeto. Contém:

- Visão geral da arquitetura
- Requisitos e funcionalidades
- Instruções completas de execução
- Exemplos de uso
- Estrutura do projeto

### [QUICKSTART.md](./QUICKSTART.md) - **Início Rápido**

Guia resumido para iniciar rapidamente:

- 3 passos para rodar o projeto
- Tabela de endpoints
- Cenários de teste prontos
- Comandos úteis
- Métricas de sucesso

### [SUMMARY.md](./SUMMARY.md) - **Resumo Executivo**

Visão geral para apresentação:

- Status do projeto
- Requisitos atendidos
- Diferenciais implementados
- Métricas de qualidade
- Demo rápida

### [WARNINGS.md](./WARNINGS.md) - **⚠️ Avisos Importantes**

Explicação sobre erros esperados:

- Erros de import no VS Code (normal)
- Por que acontecem
- Como são resolvidos no Docker
- FAQ e checklist

---

## 📖 Documentação Técnica

### [ARCHITECTURE.md](./ARCHITECTURE.md) - **Arquitetura**

Diagramas e explicações detalhadas:

- Diagrama de componentes (ASCII art)
- Fluxo de dados entre serviços
- Estrutura de traces
- Topologia de rede
- Stack tecnológico

### [REQUIREMENTS.md](./REQUIREMENTS.md) - **Requisitos do Desafio**

Checklist completo do desafio:

- ✅ Todos os requisitos obrigatórios
- Implementações detalhadas
- Diferenciais do projeto
- Cenários de teste validados
- Melhorias futuras

---

## 🛠️ Guias Práticos

### [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) - **Resolução de Problemas**

Soluções para problemas comuns:

- 10+ problemas documentados
- Diagnósticos passo a passo
- Comandos de debug
- Checklist de verificação
- Logs de sucesso esperados

### [POWERSHELL-COMMANDS.md](./POWERSHELL-COMMANDS.md) - **Comandos PowerShell**

Referência completa de comandos:

- Comandos de início/parada
- Monitoramento e logs
- Testes e debug
- Manutenção e limpeza
- Atalhos e aliases

---

## 🧪 Testes

### [test.ps1](./test.ps1) - **Script de Testes Automatizados**

Script PowerShell para executar todos os testes:

```powershell
.\test.ps1
```

Executa 7 cenários de teste automaticamente.

### [test-requests.http](./test-requests.http) - **Requisições REST**

Arquivo para VS Code REST Client:

- 9 exemplos de requisições prontas
- Casos de sucesso e erro
- Comandos cURL equivalentes

---

## ⚙️ Configuração

### [docker-compose.yaml](./docker-compose.yaml) - **Orquestração**

Arquivo principal de configuração:

- 4 serviços configurados
- Network isolada
- Portas expostas
- Dependências entre serviços

### [.env.example](./.env.example) - **Variáveis de Ambiente**

Template de configuração:

- API keys
- Portas dos serviços
- Endpoints OTEL

### [Makefile](./Makefile) - **Comandos Make**

Atalhos para comandos comuns:

```bash
make up      # Iniciar serviços
make down    # Parar serviços
make test    # Executar testes
make logs    # Ver logs
```

---

## 📁 Estrutura do Projeto

```
07/
│
├── 📄 Documentação Geral
│   ├── README.md                    ⭐ Documentação principal
│   ├── QUICKSTART.md                🚀 Guia rápido
│   ├── INDEX.md                     📚 Este arquivo
│   ├── ARCHITECTURE.md              🏗️ Diagramas
│   ├── REQUIREMENTS.md              ✅ Checklist do desafio
│   ├── TROUBLESHOOTING.md           🔧 Resolução de problemas
│   └── POWERSHELL-COMMANDS.md       💻 Comandos úteis
│
├── 🧪 Testes
│   ├── test.ps1                     ⚡ Testes automatizados
│   └── test-requests.http           📮 Requisições REST
│
├── ⚙️ Configuração
│   ├── docker-compose.yaml          🐳 Orquestração
│   ├── .env.example                 🔐 Variáveis de ambiente
│   ├── Makefile                     📝 Comandos make
│   └── .gitignore                   🚫 Arquivos ignorados
│
├── 🔵 Serviço A (Input Service)
│   ├── main.go                      💻 Código principal
│   ├── go.mod                       📦 Dependências
│   └── Dockerfile                   🐳 Container
│
├── 🟢 Serviço B (Orchestration)
│   ├── main.go                      💻 Código principal
│   ├── go.mod                       📦 Dependências
│   └── Dockerfile                   🐳 Container
│
└── 📊 OTEL Collector
    └── otel-collector-config.yaml   ⚙️ Configuração OTEL
```

---

## 🎯 Guia de Uso por Cenário

### Cenário 1: "Quero rodar o projeto pela primeira vez"

1. Leia [QUICKSTART.md](./QUICKSTART.md)
2. Execute: `docker-compose up --build`
3. Teste com: `.\test.ps1`

### Cenário 2: "Quero entender a arquitetura"

1. Leia [ARCHITECTURE.md](./ARCHITECTURE.md)
2. Consulte [README.md](./README.md) seção "Fluxo de Execução"

### Cenário 3: "Estou com um problema"

1. Consulte [TROUBLESHOOTING.md](./TROUBLESHOOTING.md)
2. Use comandos de [POWERSHELL-COMMANDS.md](./POWERSHELL-COMMANDS.md)
3. Verifique logs: `docker-compose logs`

### Cenário 4: "Preciso validar requisitos do desafio"

1. Leia [REQUIREMENTS.md](./REQUIREMENTS.md)
2. Execute testes: `.\test.ps1`
3. Visualize traces: http://localhost:9411

### Cenário 5: "Quero contribuir ou modificar"

1. Leia [README.md](./README.md) seção "Estrutura do Projeto"
2. Consulte [ARCHITECTURE.md](./ARCHITECTURE.md)
3. Veja exemplos em [test-requests.http](./test-requests.http)

---

## 📌 Links Rápidos

### Interfaces Web

- **Zipkin**: http://localhost:9411
- **OTEL Metrics**: http://localhost:8888/metrics

### Endpoints API

- **Serviço A**: http://localhost:8080
- **Serviço B**: http://localhost:8081

### APIs Externas Usadas

- **ViaCEP**: https://viacep.com.br/
- **WeatherAPI**: https://www.weatherapi.com/

### Documentação de Referência

- **OpenTelemetry Go**: https://opentelemetry.io/docs/instrumentation/go/
- **Zipkin**: https://zipkin.io/
- **Docker Compose**: https://docs.docker.com/compose/

---

## 🎓 Recursos de Aprendizado

### Para entender OpenTelemetry

1. Leia [README.md](./README.md) seção "OpenTelemetry + Zipkin"
2. Visualize traces no Zipkin após executar testes
3. Consulte código em `service-a/main.go` e `service-b/main.go`

### Para entender Docker Compose

1. Analise [docker-compose.yaml](./docker-compose.yaml)
2. Veja [ARCHITECTURE.md](./ARCHITECTURE.md) seção "Network"
3. Use comandos de [POWERSHELL-COMMANDS.md](./POWERSHELL-COMMANDS.md)

### Para entender Go

1. Leia código comentado em `service-a/main.go`
2. Leia código comentado em `service-b/main.go`
3. Consulte [go.mod](./service-a/go.mod) para dependências

---

## ❓ FAQ Rápido

**P: Como rodar o projeto?**  
R: `docker-compose up --build` - Veja [QUICKSTART.md](./QUICKSTART.md)

**P: Como testar?**  
R: `.\test.ps1` - Veja [test.ps1](./test.ps1)

**P: Onde ver os traces?**  
R: http://localhost:9411 - Veja [README.md](./README.md)

**P: Como debugar problemas?**  
R: Veja [TROUBLESHOOTING.md](./TROUBLESHOOTING.md)

**P: Quais os requisitos atendidos?**  
R: Veja [REQUIREMENTS.md](./REQUIREMENTS.md)

**P: Como funciona a arquitetura?**  
R: Veja [ARCHITECTURE.md](./ARCHITECTURE.md)

**P: Comandos PowerShell úteis?**  
R: Veja [POWERSHELL-COMMANDS.md](./POWERSHELL-COMMANDS.md)

---

## 🏆 Checklist de Validação

Antes de entregar/avaliar, verifique:

- [ ] Ler [README.md](./README.md) completo
- [ ] Executar `docker-compose up --build`
- [ ] Verificar todos os containers UP: `docker-compose ps`
- [ ] Executar testes: `.\test.ps1`
- [ ] Acessar Zipkin: http://localhost:9411
- [ ] Verificar traces aparecem
- [ ] Testar CEP válido: retorna 200
- [ ] Testar CEP inválido: retorna 422
- [ ] Testar CEP não encontrado: retorna 404
- [ ] Revisar [REQUIREMENTS.md](./REQUIREMENTS.md)

---

## 📞 Suporte

Para mais informações, consulte os arquivos de documentação ou:

1. Verifique [TROUBLESHOOTING.md](./TROUBLESHOOTING.md)
2. Revise logs: `docker-compose logs`
3. Consulte [POWERSHELL-COMMANDS.md](./POWERSHELL-COMMANDS.md)

---

## 🎯 Próximos Passos

Após ler este índice:

1. **Primeira vez?** → [QUICKSTART.md](./QUICKSTART.md)
2. **Quer detalhes?** → [README.md](./README.md)
3. **Problemas?** → [TROUBLESHOOTING.md](./TROUBLESHOOTING.md)
4. **Validar requisitos?** → [REQUIREMENTS.md](./REQUIREMENTS.md)

---

**Versão do Projeto**: 1.0  
**Última Atualização**: Outubro 2025  
**Curso**: Full Cycle - Pós-graduação
