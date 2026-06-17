import { TarefaRepository } from './tarefa.repository.js'

export class TarefaService {
  constructor() {
    this.repository = new TarefaRepository()
  }

  async criar(dados) {
    if (!dados.descricao || dados.descricao.trim().length === 0) {
      throw new Error('Descrição é obrigatória')
    }

    if (!dados.projetoId) {
      throw new Error('ProjetoId é obrigatório')
    }

    return this.repository.salvar({
      descricao: dados.descricao,
      concluido: false,
      projetoId: dados.projetoId
    })
  }

  async listar() {
    return this.repository.buscarTodos()
  }

  async obter(id) {
    return this.repository.buscarPorId(id)
  }

  async listarPorProjeto(projetoId) {
    return this.repository.buscarPorProjeto(projetoId)
  }

  async atualizar(id, dados) {
    if (!dados.descricao || dados.descricao.trim().length === 0) {
      throw new Error('Descrição é obrigatória')
    }

    const tarefaExistente = await this.repository.buscarPorId(id)
    if (!tarefaExistente) {
      throw new Error('Tarefa não encontrada')
    }

    return this.repository.atualizar(id, {
      descricao: dados.descricao,
      concluido: dados.concluido ?? tarefaExistente.concluido,
      projetoId: dados.projetoId ?? tarefaExistente.projeto_id
    })
  }

  async remover(id) {
    const tarefa = await this.repository.buscarPorId(id)
    if (!tarefa) {
      throw new Error('Tarefa não encontrada')
    }

    return this.repository.remover(id)
  }
}
