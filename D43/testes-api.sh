#!/bin/bash

# =================================================================
# TESTES DE API - Roteiro 13
# =================================================================
#
# Este script contém exemplos de testes com curl para a API.
# Execute cada bloco conforme necessário.
#
# Requisitos:
# - API rodando em http://localhost:3000
# - curl instalado
# =================================================================

BASE_URL="http://localhost:3000"

echo "🧪 Testes da API de Tarefas e Projetos"
echo "======================================"
echo ""

# =================================================================
# 1. TESTE DE CONECTIVIDADE
# =================================================================

echo "1️⃣  Verificando se a API está respondendo..."
curl -s "$BASE_URL/" | jq . && echo "✓ API OK" || echo "❌ API não respondendo"
echo ""

# =================================================================
# 2. TESTES DE PROJETOS
# =================================================================

echo "2️⃣  Testando endpoints de PROJETOS"
echo ""

# Listar projetos
echo "▶️  GET /projetos"
curl -s "$BASE_URL/projetos" | jq .
echo ""
echo ""

# Obter projeto específico
echo "▶️  GET /projetos/1"
curl -s "$BASE_URL/projetos/1" | jq .
echo ""
echo ""

# Criar novo projeto
echo "▶️  POST /projetos (criar novo projeto)"
curl -X POST "$BASE_URL/projetos" \
  -H "Content-Type: application/json" \
  -d '{"nome": "Novo Projeto de Teste"}' | jq .
echo ""
echo ""

# =================================================================
# 3. TESTES DE TAREFAS - LISTAGEM
# =================================================================

echo "3️⃣  Testando endpoints de TAREFAS"
echo ""

# Listar todas as tarefas
echo "▶️  GET /tarefas (lista com JOIN)"
curl -s "$BASE_URL/tarefas" | jq .
echo ""
echo ""

# Obter tarefa específica
echo "▶️  GET /tarefas/1"
curl -s "$BASE_URL/tarefas/1" | jq .
echo ""
echo ""

# =================================================================
# 4. TESTES DE TAREFAS - CRIAÇÃO
# =================================================================

echo "4️⃣  Criando TAREFAS com projeto"
echo ""

# Criar tarefa vinculada ao projeto 1
echo "▶️  POST /tarefas (criar com projetoId: 1)"
curl -X POST "$BASE_URL/tarefas" \
  -H "Content-Type: application/json" \
  -d '{
    "descricao": "Implementar autenticação JWT",
    "projetoId": 1
  }' | jq .
echo ""
echo ""

# Criar tarefa vinculada ao projeto 2
echo "▶️  POST /tarefas (criar com projetoId: 2)"
curl -X POST "$BASE_URL/tarefas" \
  -H "Content-Type: application/json" \
  -d '{
    "descricao": "Otimizar queries SQL",
    "projetoId": 2
  }' | jq .
echo ""
echo ""

# Tentar criar tarefa SEM projeto (vai falhar - validação)
echo "▶️  POST /tarefas (SEM projetoId - deve falhar)"
curl -X POST "$BASE_URL/tarefas" \
  -H "Content-Type: application/json" \
  -d '{
    "descricao": "Tarefa sem projeto"
  }' | jq .
echo ""
echo ""

# =================================================================
# 5. TESTES DE TAREFAS - FILTRO POR PROJETO
# =================================================================

echo "5️⃣  Filtrando tarefas por PROJETO"
echo ""

# Listar tarefas apenas do projeto 1 (INNER JOIN)
echo "▶️  GET /tarefas/projeto/1 (tarefas do Projeto 1)"
curl -s "$BASE_URL/tarefas/projeto/1" | jq .
echo ""
echo ""

# Listar tarefas apenas do projeto 2
echo "▶️  GET /tarefas/projeto/2 (tarefas do Projeto 2)"
curl -s "$BASE_URL/tarefas/projeto/2" | jq .
echo ""
echo ""

# =================================================================
# 6. TESTES DE TAREFAS - ATUALIZAÇÃO
# =================================================================

echo "6️⃣  Atualizando TAREFAS"
echo ""

# Encontrar um ID válido first (pega a primeira tarefa)
TAREFA_ID=$(curl -s "$BASE_URL/tarefas" | jq -r '.[] | select(.projeto_id != null) | .id' | head -1)

if [ ! -z "$TAREFA_ID" ] && [ "$TAREFA_ID" != "null" ]; then
  echo "▶️  PUT /tarefas/$TAREFA_ID (marcar como concluída)"
  curl -X PUT "$BASE_URL/tarefas/$TAREFA_ID" \
    -H "Content-Type: application/json" \
    -d "{
      \"descricao\": \"Implementar autenticação JWT\",
      \"concluido\": true,
      \"projetoId\": 1
    }" | jq .
  echo ""
  echo ""

  # Mover tarefa para outro projeto
  echo "▶️  PUT /tarefas/$TAREFA_ID (mover para projeto 2)"
  curl -X PUT "$BASE_URL/tarefas/$TAREFA_ID" \
    -H "Content-Type: application/json" \
    -d "{
      \"descricao\": \"Implementar autenticação JWT\",
      \"concluido\": false,
      \"projetoId\": 2
    }" | jq .
  echo ""
  echo ""
else
  echo "⚠️  Nenhuma tarefa encontrada para atualizar"
  echo ""
fi

# =================================================================
# 7. TESTE DE ERRO - CHAVE ESTRANGEIRA
# =================================================================

echo "7️⃣  Testando INTEGRIDADE REFERENCIAL"
echo ""

# Criar tarefa com projetoId inválido (deve falhar no banco)
echo "▶️  POST /tarefas (com projetoId inválido - 9999)"
curl -X POST "$BASE_URL/tarefas" \
  -H "Content-Type: application/json" \
  -d '{
    "descricao": "Tarefa com projeto inexistente",
    "projetoId": 9999
  }' | jq .
echo ""
echo "^ Deve retornar erro de violação de chave estrangeira"
echo ""

# =================================================================
# RESUMO
# =================================================================

echo "======================================"
echo "✅ Testes concluídos!"
echo ""
echo "Conceitos testados:"
echo "  ✓ Relacionamento 1:N entre Projetos e Tarefas"
echo "  ✓ LEFT JOIN (listagem geral)"
echo "  ✓ INNER JOIN (filtro por projeto)"
echo "  ✓ Validação de projetoId obrigatório"
echo "  ✓ Integridade referencial (chave estrangeira)"
echo "  ✓ CRUD completo de ambas as entidades"
echo ""
echo "Próximos passos:"
echo "  1. Explore os dados no PostgreSQL diretamente"
echo "  2. Veja os scripts em scripts-sql.sql"
echo "  3. Consulte ROTEIRO_13.md para detalhes"
echo ""
