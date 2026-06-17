#!/bin/bash

# =================================================================
# Script de inicialização e teste do projeto
# =================================================================

echo "🚀 Inicializando API de Tarefas e Projetos..."
echo ""

# 1. Instalar dependências
if [ ! -d "node_modules" ]; then
  echo "📦 Instalando dependências..."
  npm install
  echo "✓ Dependências instaladas"
  echo ""
fi

# 2. Preparar arquivo .env
if [ ! -f ".env" ]; then
  echo "⚙️  Criando arquivo .env..."
  cp .env.example .env
  echo "✓ Arquivo .env criado (verifique as configurações)"
  echo ""
fi

# 3. Inicializar banco de dados
echo "🗄️  Inicializando banco de dados..."
node src/db/inicializar.js
if [ $? -eq 0 ]; then
  echo "✓ Banco de dados pronto"
  echo ""
else
  echo "❌ Erro ao inicializar banco"
  echo "Verifique:"
  echo "- PostgreSQL está rodando?"
  echo "- Credenciais em .env estão corretas?"
  echo "- Banco 'tarefas_db' existe?"
  exit 1
fi

# 4. Iniciar servidor
echo ""
echo "✅ Tudo pronto para começar!"
echo ""
echo "Para iniciar o servidor, execute:"
echo "  npm run dev  (modo desenvolvimento com auto-reload)"
echo "  npm start    (modo produção)"
echo ""
echo "API disponível em: http://localhost:3000"
echo ""
