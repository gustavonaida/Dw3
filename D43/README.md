# API de Tarefas e Projetos - Roteiro 13

Backend em Node.js + Express + PostgreSQL implementando relacionamentos 1:N.

## Sobre este projeto

Este projeto implementa o **Roteiro 13 - Modelando Relacionamentos 1:N no Backend**, onde:

- **Projetos** têm um relacionamento `1:N` com **Tarefas**
- Uma tarefa pertence a um único projeto
- Um projeto pode ter várias tarefas
- A modelagem relacional é persistida no PostgreSQL com chave estrangeira

## Arquitetura

```
src/
├── index.js                          # Arquivo principal da aplicação
├── db/
│   ├── pool.js                       # Configuração da conexão PostgreSQL
│   └── inicializar.js                # Script para criar tabelas
├── features/
│   ├── tarefas/
│   │   ├── tarefa.controller.js      # Controlador de requisições
│   │   ├── tarefa.service.js         # Lógica de negócio
│   │   └── tarefa.repository.js      # Acesso aos dados (queries)
│   └── projetos/
│       ├── projeto.controller.js
│       ├── projeto.service.js
│       └── projeto.repository.js
└── routes/
    ├── tarefas.routes.js            # Rotas da API de tarefas
    └── projetos.routes.js           # Rotas da API de projetos
```

## Padrões aplicados

### Repository Pattern
- Encapsula toda a lógica de acesso aos dados
- Isolamento de queries SQL em um único lugar
- Facilita testes e manutenção

### Service Layer
- Contém toda a lógica de negócio
- Validações de entrada
- Orquestração entre repositórios

### Controller
- Recebe requisições HTTP
- Valida entrada (se necessário)
- Chama o serviço
- Formata resposta

## Instalação

### Pré-requisitos

- Node.js 18+
- PostgreSQL 12+
- npm ou yarn

### Passos

1. Instale as dependências:

```bash
npm install
```

2. Configure as variáveis de ambiente (opcional, padrões incluídos):

```bash
# .env (ou variáveis de environment)
DB_HOST=localhost
DB_PORT=5432
DB_NAME=tarefas_db
DB_USER=postgres
DB_PASSWORD=postgres
PORT=3000
```

3. Inicialize o banco de dados:

```bash
node src/db/inicializar.js
```

Este comando:
- Cria a tabela `projetos`
- Cria a tabela `tarefas` com coluna `projeto_id`
- Adiciona a chave estrangeira
- Insere projetos iniciais de exemplo

## Executando a aplicação

### Modo desenvolvimento (com auto-reload):

```bash
npm run dev
```

### Modo produção:

```bash
npm start
```

O servidor estará disponível em `http://localhost:3000`

## API - Endpoints

### Projetos

| Método | URL | Descrição |
|--------|-----|-----------|
| `POST` | `/projetos` | Criar novo projeto |
| `GET` | `/projetos` | Listar todos os projetos |
| `GET` | `/projetos/:id` | Obter projeto por ID |
| `PUT` | `/projetos/:id` | Atualizar projeto |
| `DELETE` | `/projetos/:id` | Remover projeto |

### Tarefas

| Método | URL | Descrição |
|--------|-----|-----------|
| `POST` | `/tarefas` | Criar nova tarefa (requer `projetoId`) |
| `GET` | `/tarefas` | Listar todas as tarefas com seus projetos (LEFT JOIN) |
| `GET` | `/tarefas/:id` | Obter tarefa específica |
| `GET` | `/tarefas/projeto/:projetoId` | Listar tarefas de um projeto (INNER JOIN) |
| `PUT` | `/tarefas/:id` | Atualizar tarefa |
| `DELETE` | `/tarefas/:id` | Remover tarefa |

## Exemplos de uso

### 1. Listar projetos

```bash
curl http://localhost:3000/projetos
```

Resposta:
```json
[
  {
    "id": 1,
    "nome": "Projeto API DW3",
    "criado_em": "2026-06-17T10:00:00.000Z"
  },
  {
    "id": 2,
    "nome": "Projeto Banco Relacional",
    "criado_em": "2026-06-17T10:00:00.000Z"
  }
]
```

### 2. Criar tarefa

```bash
curl -X POST http://localhost:3000/tarefas \
  -H "Content-Type: application/json" \
  -d '{
    "descricao": "Implementar autenticação",
    "projetoId": 1
  }'
```

Resposta:
```json
{
  "id": 1,
  "descricao": "Implementar autenticação",
  "concluido": false,
  "criada_em": "2026-06-17T10:15:00.000Z",
  "projeto_id": 1
}
```

### 3. Listar tarefas (com informação do projeto)

```bash
curl http://localhost:3000/tarefas
```

Resposta:
```json
[
  {
    "id": 1,
    "descricao": "Implementar autenticação",
    "concluido": false,
    "criada_em": "2026-06-17T10:15:00.000Z",
    "projeto_id": 1,
    "projeto_nome": "Projeto API DW3"
  },
  {
    "id": 2,
    "descricao": "Configurar CORS",
    "concluido": false,
    "criada_em": "2026-06-17T10:16:00.000Z",
    "projeto_id": 2,
    "projeto_nome": "Projeto Banco Relacional"
  }
]
```

### 4. Listar tarefas de um projeto

```bash
curl http://localhost:3000/tarefas/projeto/1
```

Resposta:
```json
[
  {
    "id": 1,
    "descricao": "Implementar autenticação",
    "concluido": false,
    "criada_em": "2026-06-17T10:15:00.000Z",
    "projeto_id": 1,
    "projeto_nome": "Projeto API DW3"
  }
]
```

### 5. Marcar tarefa como concluída

```bash
curl -X PUT http://localhost:3000/tarefas/1 \
  -H "Content-Type: application/json" \
  -d '{
    "descricao": "Implementar autenticação",
    "concluido": true,
    "projetoId": 1
  }'
```

## Conceitos principais abordados

### 1. Chave Estrangeira

```sql
ALTER TABLE tarefas
ADD CONSTRAINT tarefas_projeto_id_fkey
FOREIGN KEY (projeto_id)
REFERENCES projetos(id)
```

Garante integridade referencial: uma tarefa só pode apontar para um projeto existente.

### 2. LEFT JOIN (Listagem geral)

```sql
SELECT t.*, p.nome AS projeto_nome
FROM tarefas t
LEFT JOIN projetos p ON p.id = t.projeto_id
```

Retorna todas as tarefas, mesmo aquelas sem projeto vinculado.

### 3. INNER JOIN (Filtro por projeto)

```sql
SELECT t.*, p.nome AS projeto_nome
FROM tarefas t
INNER JOIN projetos p ON p.id = t.projeto_id
WHERE p.id = $1
```

Retorna apenas tarefas com projeto, adequado para filtro.

## Validações implementadas

- ✅ `projetoId` é obrigatório ao criar tarefa
- ✅ Descrição não pode estar vazia
- ✅ Namen do projeto não pode estar vazio
- ✅ Verificação de existência antes de atualizar/remover
- ✅ Integridade referencial no banco (chave estrangeira)

## Próximos passos

Para aprofundar o aprendizado:

### Exercício 1: Incluir usuários

Adione uma terceira entidade (`usuarios`) e crie um relacionamento 1:N onde:
- Um usuário pode ter várias tarefas
- Uma tarefa pertence a um usuário

### Exercício 2: N:N com tags

Crie uma tabela `tags` e uma tabela de junção `tarefa_tags` para:
- Uma tarefa ter múltiplas tags
- Uma tag estar em múltiplas tarefas

### Exercício 3: Estruturar resposta do formulário

Transforme a resposta para:
```json
{
  "id": 1,
  "descricao": "Tarefa exemplo",
  "concluido": false,
  "projeto": {
    "id": 1,
    "nome": "Projeto API DW3"
  }
}
```

## Referência de SQL

Consultas úteis no PostgreSQL:

```sql
-- Ver estrutura da tabela tarefas
\d tarefas

-- Ver estrutura da tabela projetos
\d projetos

-- Contar tarefas por projeto
SELECT p.nome, COUNT(t.id) as total_tarefas
FROM projetos p
LEFT JOIN tarefas t ON t.projeto_id = p.id
GROUP BY p.id, p.nome

-- Listar tarefas incompletas com nome do projeto
SELECT t.id, t.descricao, p.nome
FROM tarefas t
INNER JOIN projetos p ON p.id = t.projeto_id
WHERE t.concluido = false
```

## Troubleshooting

**Erro: "Chave estrangeira já existe"**
- Solução: É normal. O script detecta e continua.

**Erro: Não consigo conectar ao banco**
- Verifique as variáveis de ambiente `DB_HOST`, `DB_USER`, `DB_PASSWORD`
- Certifique-se que PostgreSQL está rodando

**Erro: "ProjetoId é obrigatório"**
- Ao criar tarefa, envie `projetoId` no body da requisição

## Licença

MIT
