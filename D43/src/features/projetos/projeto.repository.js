import { pool } from '../../db/pool.js'

export class ProjetoRepository {
  async salvar(projeto) {
    const resultado = await pool.query(
      `
        INSERT INTO projetos (nome)
        VALUES ($1)
        RETURNING id, nome, criado_em
      `,
      [projeto.nome]
    )

    return resultado.rows[0]
  }

  async buscarTodos() {
    const resultado = await pool.query(`
      SELECT id, nome, criado_em
      FROM projetos
      ORDER BY id
    `)

    return resultado.rows
  }

  async buscarPorId(id) {
    const resultado = await pool.query(
      `
        SELECT id, nome, criado_em
        FROM projetos
        WHERE id = $1
      `,
      [id]
    )

    return resultado.rows[0] ?? null
  }

  async atualizar(id, projeto) {
    const resultado = await pool.query(
      `
        UPDATE projetos
        SET nome = $1
        WHERE id = $2
        RETURNING id, nome, criado_em
      `,
      [projeto.nome, id]
    )

    return resultado.rows[0] ?? null
  }

  async remover(id) {
    const resultado = await pool.query(
      `DELETE FROM projetos WHERE id = $1 RETURNING id`,
      [id]
    )

    return resultado.rows[0] ?? null
  }
}
