import { pool } from '../db/pool.js'

async function inicializarBanco() {
  try {
    console.log('Criando tabelas...')

    // Criar tabela de projetos
    await pool.query(`
      CREATE TABLE IF NOT EXISTS projetos (
        id SERIAL PRIMARY KEY,
        nome TEXT NOT NULL,
        criado_em TIMESTAMP NOT NULL DEFAULT NOW()
      )
    `)

    console.log('✓ Tabela projetos criada')

    // Criar tabela de tarefas com chave estrangeira
    await pool.query(`
      CREATE TABLE IF NOT EXISTS tarefas (
        id SERIAL PRIMARY KEY,
        descricao TEXT NOT NULL,
        concluido BOOLEAN NOT NULL DEFAULT FALSE,
        criada_em TIMESTAMP NOT NULL DEFAULT NOW(),
        projeto_id INTEGER
      )
    `)

    console.log('✓ Tabela tarefas criada')

    // Adicionar chave estrangeira se não existir
    try {
      await pool.query(`
        ALTER TABLE tarefas
        ADD CONSTRAINT tarefas_projeto_id_fkey
        FOREIGN KEY (projeto_id)
        REFERENCES projetos(id)
      `)

      console.log('✓ Chave estrangeira adicionada')
    } catch (erro) {
      if (erro.code === '42710') {
        // Constraint já existe
        console.log('✓ Chave estrangeira já existe')
      } else {
        throw erro
      }
    }

    // Inserir projetos iniciais
    const projetosExistem = await pool.query('SELECT COUNT(*) FROM projetos')

    if (projetosExistem.rows[0].count === '0') {
      await pool.query(`
        INSERT INTO projetos (nome)
        VALUES
          ('Projeto API DW3'),
          ('Projeto Banco Relacional'),
          ('Projeto Integração Frontend')
      `)

      console.log('✓ Projetos iniciais inseridos')
    } else {
      console.log('✓ Projetos já existem')
    }

    console.log('\n✅ Banco de dados inicializado com sucesso!')
  } catch (erro) {
    console.error('❌ Erro ao inicializar banco:', erro.message)
    process.exit(1)
  } finally {
    await pool.end()
  }
}

inicializarBanco()
