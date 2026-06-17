import { ProjetoRepository } from './projeto.repository.js'

export class ProjetoService {
  constructor() {
    this.repository = new ProjetoRepository()
  }

  async criar(dados) {
    if (!dados.nome || dados.nome.trim().length === 0) {
      throw new Error('Nome do projeto é obrigatório')
    }

    return this.repository.salvar({
      nome: dados.nome
    })
  }

  async listar() {
    return this.repository.buscarTodos()
  }

  async obter(id) {
    return this.repository.buscarPorId(id)
  }

  async atualizar(id, dados) {
    if (!dados.nome || dados.nome.trim().length === 0) {
      throw new Error('Nome do projeto é obrigatório')
    }

    const projetoExistente = await this.repository.buscarPorId(id)
    if (!projetoExistente) {
      throw new Error('Projeto não encontrado')
    }

    return this.repository.atualizar(id, {
      nome: dados.nome
    })
  }

  async remover(id) {
    const projeto = await this.repository.buscarPorId(id)
    if (!projeto) {
      throw new Error('Projeto não encontrado')
    }

    return this.repository.remover(id)
  }
}
