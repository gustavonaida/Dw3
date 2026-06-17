-- =================================================================
-- ROTEIRO 13: Scripts SQL para Teste e Debugging
-- =================================================================

-- 1. VER ESTRUTURA DAS TABELAS
-- =================================================================

-- Estrutura da tabela projetos
\d projetos

-- Estrutura da tabela tarefas
\d tarefas

-- Ver todas as constraints de tarefas
SELECT constraint_name, constraint_type
FROM information_schema.table_constraints
WHERE table_name = 'tarefas';


-- 2. OPERAÇÕES BÁSICAS DE DADOS
-- =================================================================

-- Listar todos os projetos
SELECT * FROM projetos ORDER BY id;

-- Listar todas as tarefas
SELECT * FROM tarefas ORDER BY id;

-- Contar registros
SELECT 'Projetos' as tabela, COUNT(*) as total FROM projetos
UNION
SELECT 'Tarefas', COUNT(*) FROM tarefas;


-- 3. LISTANDO COM JOIN (ponto central do Roteiro 13)
-- =================================================================

-- Listagem geral com LEFT JOIN (tolerante a tarefas sem projeto)
SELECT
  t.id,
  t.descricao,
  t.concluido,
  t.criada_em,
  t.projeto_id,
  p.nome AS projeto_nome
FROM tarefas t
LEFT JOIN projetos p
  ON p.id = t.projeto_id
ORDER BY t.id;


-- Listagem por projeto específico com INNER JOIN
-- (substitua 1 pelo ID desejado)
SELECT
  t.id,
  t.descricao,
  t.concluido,
  t.criada_em,
  t.projeto_id,
  p.nome AS projeto_nome
FROM tarefas t
INNER JOIN projetos p
  ON p.id = t.projeto_id
WHERE p.id = 1
ORDER BY t.id;


-- 4. CONSULTANDO COM AGREGAÇÃO
-- =================================================================

-- Contar tarefas por projeto
SELECT
  p.id,
  p.nome,
  COUNT(t.id) as total_tarefas,
  SUM(CASE WHEN t.concluido THEN 1 ELSE 0 END) as tarefas_concluidas
FROM projetos p
LEFT JOIN tarefas t
  ON t.projeto_id = p.id
GROUP BY p.id, p.nome
ORDER BY p.id;


-- Listar tarefas incompletas por projeto
SELECT
  p.nome as projeto,
  t.descricao,
  t.criada_em
FROM tarefas t
INNER JOIN projetos p
  ON p.id = t.projeto_id
WHERE t.concluido = false
ORDER BY p.nome, t.criada_em;


-- 5. TESTANDO CHAVE ESTRANGEIRA
-- =================================================================

-- Tentar inserir tarefa com projeto INEXISTENTE (vai falhar)
-- Descomente para testar a integridade referencial:
-- INSERT INTO tarefas (descricao, concluido, projeto_id)
-- VALUES ('Tarefa com projeto inválido', false, 9999);
-- → Erro: violação de chave estrangeira


-- 6. LIMPEZA E MANUTENÇÃO
-- =================================================================

-- Deletar TODAS as tarefas (cuidado!)
-- DELETE FROM tarefas;

-- Deletar tarefas de um projeto específico
-- DELETE FROM tarefas WHERE projeto_id = 1;

-- Deletar um projeto (funciona apenas se não há tarefas)
-- DELETE FROM projetos WHERE id = 1;

-- Se tentar deletar projeto com tarefas, o banco NÃO permite
-- (constraint impede por referência de chave estrangeira)


-- 7. INSERINDO DADOS DE TESTE
-- =================================================================

-- Inserir novo projeto
INSERT INTO projetos (nome)
VALUES ('Novo Projeto Teste')
RETURNING id, nome, criado_em;


-- Inserir nova tarefa (substitua 1 pelo ID real de um projeto)
INSERT INTO tarefas (descricao, concluido, projeto_id)
VALUES ('Tarefa de teste', false, 1)
RETURNING id, descricao, concluido, criada_em, projeto_id;


-- Inserir múltiplas tarefas de uma vez
INSERT INTO tarefas (descricao, concluido, projeto_id)
VALUES
  ('Tarefa 1 do Projeto 1', false, 1),
  ('Tarefa 2 do Projeto 1', false, 1),
  ('Tarefa 1 do Projeto 2', true, 2),
  ('Tarefa 2 do Projeto 2', false, 2)
RETURNING id, descricao, concluido, projeto_id;


-- 8. ATUALIZANDO DADOS
-- =================================================================

-- Marcar tarefa como concluída
UPDATE tarefas
SET concluido = true
WHERE id = 1
RETURNING id, descricao, concluido;


-- Mover tarefa para outro projeto
UPDATE tarefas
SET projeto_id = 2
WHERE id = 1
RETURNING id, projeto_id;


-- 9. QUERIES AVANÇADAS
-- =================================================================

-- Tarefas criadas nos últimos 7 dias
SELECT * FROM tarefas
WHERE criada_em >= NOW() - INTERVAL '7 days'
ORDER BY criada_em DESC;


-- Projetos com mais de 2 tarefas
SELECT
  p.id,
  p.nome,
  COUNT(t.id) as total_tarefas
FROM projetos p
LEFT JOIN tarefas t ON t.projeto_id = p.id
GROUP BY p.id, p.nome
HAVING COUNT(t.id) > 2;


-- Tarefa mais recente de cada projeto
SELECT DISTINCT ON (p.id)
  p.nome as projeto,
  t.descricao as ultima_tarefa_criada,
  t.criada_em
FROM projetos p
LEFT JOIN tarefas t ON t.projeto_id = p.id
ORDER BY p.id, t.criada_em DESC;


-- 10. RESETANDO O BANCO PARA TESTE
-- =================================================================

-- ⚠️ CUIDADO: Limpar tudo e recriar
-- Descomente apenas se souber o que está fazendo:

-- -- Remover constraints e tabelas
-- ALTER TABLE tarefas DROP CONSTRAINT IF EXISTS tarefas_projeto_id_fkey;
-- DROP TABLE IF EXISTS tarefas;
-- DROP TABLE IF EXISTS projetos;

-- -- Recriar tabelas
-- CREATE TABLE projetos (
--   id SERIAL PRIMARY KEY,
--   nome TEXT NOT NULL,
--   criado_em TIMESTAMP NOT NULL DEFAULT NOW()
-- );

-- CREATE TABLE tarefas (
--   id SERIAL PRIMARY KEY,
--   descricao TEXT NOT NULL,
--   concluido BOOLEAN NOT NULL DEFAULT FALSE,
--   criada_em TIMESTAMP NOT NULL DEFAULT NOW(),
--   projeto_id INTEGER,
--   FOREIGN KEY (projeto_id) REFERENCES projetos(id)
-- );

-- -- Reinsert dados iniciais
-- INSERT INTO projetos (nome) VALUES
--   ('Projeto API DW3'),
--   ('Projeto Banco Relacional'),
--   ('Projeto Integração Frontend');


-- =================================================================
-- FIM DOS SCRIPTS
-- =================================================================

-- Para utilizar estes scripts:
-- 1. Abra um terminal PostgreSQL: psql -U postgres -d tarefas_db
-- 2. Copie e execute cada bloco conforme necessário
-- 3. Sempre leia o código antes de executar deletions/updates
