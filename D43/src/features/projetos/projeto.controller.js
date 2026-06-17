import { ProjetoService } from './projeto.service.js'

export class ProjetoController {
  constructor() {
    this.service = new ProjetoService()
  }

  async criar(request, response) {
    try {
      const { nome } = request.body

      const novoProjeto = await this.service.criar({
        nome
      })

      response.status(201).json(novoProjeto)
    } catch (erro) {
      response.status(400).json({ erro: erro.message })
    }
  }

  async listar(request, response) {
    try {
      const projetos = await this.service.listar()
      response.json(projetos)
    } catch (erro) {
      response.status(500).json({ erro: erro.message })
    }
  }

  async obter(request, response) {
    try {
      const { id } = request.params
      const projeto = await this.service.obter(id)

      if (!projeto) {
        return response.status(404).json({ erro: 'Projeto não encontrado' })
      }

      response.json(projeto)
    } catch (erro) {
      response.status(500).json({ erro: erro.message })
    }
  }

  async atualizar(request, response) {
    try {
      const { id } = request.params
      const { nome } = request.body

      const projetoAtualizado = await this.service.atualizar(id, {
        nome
      })

      response.json(projetoAtualizado)
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
