# Script de teste para o sistema de temperatura por CEP
# Execute com: .\test.ps1

Write-Host "==================================" -ForegroundColor Cyan
Write-Host "Sistema de Temperatura por CEP" -ForegroundColor Cyan
Write-Host "Script de Testes Automatizados" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

function Test-CEP {
    param(
        [string]$CEP,
        [string]$Description,
        [int]$ExpectedStatus
    )
    
    Write-Host "Teste: $Description" -ForegroundColor Yellow
    Write-Host "CEP: $CEP" -ForegroundColor White
    
    $body = @{
        cep = $CEP
    } | ConvertTo-Json
    
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:8080" `
            -Method POST `
            -Body $body `
            -ContentType "application/json" `
            -UseBasicParsing `
            -ErrorAction SilentlyContinue
        
        $statusCode = $response.StatusCode
        $content = $response.Content | ConvertFrom-Json | ConvertTo-Json -Depth 10
        
        Write-Host "Status: $statusCode" -ForegroundColor $(if ($statusCode -eq $ExpectedStatus) { "Green" } else { "Red" })
        Write-Host "Resposta: $content" -ForegroundColor Gray
        
    } catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        $stream = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($stream)
        $content = $reader.ReadToEnd()
        
        Write-Host "Status: $statusCode" -ForegroundColor $(if ($statusCode -eq $ExpectedStatus) { "Green" } else { "Red" })
        Write-Host "Resposta: $content" -ForegroundColor Gray
    }
    
    Write-Host ""
}

# Verificar se os servicos estao rodando
Write-Host "Verificando se os servicos estao ativos..." -ForegroundColor Cyan
try {
    # Tenta fazer uma requisicao simples para verificar se o servico responde
    $testBody = '{"cep": "01310100"}'
    $null = Invoke-WebRequest -Uri "http://localhost:8080" -Method POST -Body $testBody -ContentType "application/json" -TimeoutSec 5 -ErrorAction Stop
    Write-Host "Servico A esta ativo" -ForegroundColor Green
} catch [System.Net.WebException] {
    # Se houve resposta do servidor (mesmo que erro), considera como ativo
    if ($_.Exception.Response) {
        Write-Host "Servico A esta ativo" -ForegroundColor Green
    } else {
        Write-Host "Servico A nao esta respondendo. Execute 'docker-compose up' primeiro." -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "Servico A nao esta respondendo. Execute 'docker-compose up' primeiro." -ForegroundColor Red
    exit 1
}
Write-Host ""

# Testes
Write-Host "Iniciando testes..." -ForegroundColor Cyan
Write-Host ""

# Teste 1: CEP Valido - Sao Paulo
Test-CEP -CEP "01310100" -Description "CEP valido - Sao Paulo" -ExpectedStatus 200

# Teste 2: CEP Valido - Rio de Janeiro
Test-CEP -CEP "20040020" -Description "CEP valido - Rio de Janeiro" -ExpectedStatus 200

# Teste 3: CEP Valido - Linhares/ES
Test-CEP -CEP "29902555" -Description "CEP valido - Linhares/ES" -ExpectedStatus 200

# Teste 4: CEP Invalido - Menos de 8 digitos
Test-CEP -CEP "123" -Description "CEP invalido - Menos de 8 digitos" -ExpectedStatus 422

# Teste 5: CEP Invalido - Mais de 8 digitos
Test-CEP -CEP "123456789" -Description "CEP invalido - Mais de 8 digitos" -ExpectedStatus 422

# Teste 6: CEP Invalido - Contem letras
Test-CEP -CEP "0131010a" -Description "CEP invalido - Contem letras" -ExpectedStatus 422

# Teste 7: CEP nao encontrado
Test-CEP -CEP "99999999" -Description "CEP nao encontrado" -ExpectedStatus 404

Write-Host "==================================" -ForegroundColor Cyan
Write-Host "Testes concluidos!" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Para visualizar os traces, acesse: http://localhost:9411" -ForegroundColor Yellow
Write-Host ""
