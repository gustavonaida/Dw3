import { TarefaService } from './tarefa.service.js'

export class TarefaController {
  constructor() {
    this.service = new TarefaService()
  }

  async criar(request, response) {
    try {
      const { descricao, projetoId } = request.body

      const novaTarefa = await this.service.criar({
        descricao,
        projetoId
      })

      response.status(201).json(novaTarefa)
    } catch (erro) {
      response.status(400).json({ erro: erro.message })
    }
  }

  async listar(request, response) {
    try {
      const tarefas = await this.service.listar()
      response.json(tarefas)
    } catch (erro) {
      response.status(500).json({ erro: erro.message })
    }
  }

  async obter(request, response) {
    try {
      const { id } = request.params
      const tarefa = await this.service.obter(id)

      if (!tarefa) {
        return response.status(404).json({ erro: 'Tarefa não encontrada' })
      }

      response.json(tarefa)
    } catch (erro) {
      response.status(500).json({ erro: erro.message })
    }
  }

  async listarPorProjeto(request, response) {
    try {
      const { projetoId } = request.params
      const tarefas = await this.service.listarPorProjeto(projetoId)
      response.json(tarefas)
    } catch (erro) {
      response.status(500).json({ erro: erro.message })
    }
  }

  async atualizar(request, response) {
    try {
      const { id } = request.params
      const { descricao, concluido, projetoId } = request.body

      const tarefaAtualizada = await this.service.atualizar(id, {
        descricao,
        concluido,
        projetoId
      })

      response.json(tarefaAtualizada)
    } catch (erro) {
      response.status(400).json({ erro: erro.message })
    }
  }

  async remover(request, response) {
    try {
      const { id } = request.params
      await this.service.remover(id)
      response.status(204).send()
    } catch (erro) {
      response.status(400).json({ erro: erro.message })
    }
  }
}
