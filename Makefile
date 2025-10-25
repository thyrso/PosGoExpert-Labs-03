.PHONY: up down logs test clean help

help: ## Mostra esta ajuda
	@echo "Comandos disponíveis:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

up: ## Inicia todos os serviços
	docker-compose up --build -d

down: ## Para todos os serviços
	docker-compose down

logs: ## Mostra logs de todos os serviços
	docker-compose logs -f

logs-a: ## Mostra logs do Serviço A
	docker logs service-a -f

logs-b: ## Mostra logs do Serviço B
	docker logs service-b -f

logs-otel: ## Mostra logs do OTEL Collector
	docker logs otel-collector -f

ps: ## Lista status dos containers
	docker-compose ps

test-valid: ## Testa com CEP válido (São Paulo)
	curl -X POST http://localhost:8080 -H "Content-Type: application/json" -d '{"cep": "01310100"}'

test-invalid: ## Testa com CEP inválido
	curl -X POST http://localhost:8080 -H "Content-Type: application/json" -d '{"cep": "123"}'

test-notfound: ## Testa com CEP não encontrado
	curl -X POST http://localhost:8080 -H "Content-Type: application/json" -d '{"cep": "99999999"}'

zipkin: ## Abre Zipkin no navegador
	@echo "Abrindo Zipkin em http://localhost:9411"
	start http://localhost:9411

clean: ## Remove containers, volumes e imagens
	docker-compose down -v --rmi all

restart: down up ## Reinicia todos os serviços
