import { pool } from '../../db/pool.js'

export class TarefaRepository {
  async salvar(tarefa) {
    const resultado = await pool.query(
      `
        INSERT INTO tarefas (descricao, concluido, projeto_id)
        VALUES ($1, $2, $3)
        RETURNING id, descricao, concluido, criada_em, projeto_id
      `,
      [tarefa.descricao, tarefa.concluido, tarefa.projetoId]
    )

    return resultado.rows[0]
  }

  async buscarTodos() {
    const resultado = await pool.query(`
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
      ORDER BY t.id
    `)

    return resultado.rows
  }

  async buscarPorId(id) {
    const resultado = await pool.query(
      `
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
        WHERE t.id = $1
      `,
      [id]
    )

    return resultado.rows[0] ?? null
  }

  async buscarPorProjeto(projetoId) {
    const resultado = await pool.query(
      `
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
        WHERE p.id = $1
        ORDER BY t.id
      `,
      [projetoId]
    )

    return resultado.rows
  }

  async atualizar(id, tarefa) {
    const resultado = await pool.query(
      `
        UPDATE tarefas
        SET descricao = $1, concluido = $2, projeto_id = $3
        WHERE id = $4
        RETURNING id, descricao, concluido, criada_em, projeto_id
      `,
      [tarefa.descricao, tarefa.concluido, tarefa.projetoId, id]
    )

    return resultado.rows[0] ?? null
  }

  async remover(id) {
    const resultado = await pool.query(
      `DELETE FROM tarefas WHERE id = $1 RETURNING id`,
      [id]
    )

    return resultado.rows[0] ?? null
  }
}
