import { Router } from 'express'
import { TarefaController } from '../features/tarefas/tarefa.controller.js'

const router = Router()
const controller = new TarefaController()

router.post('/', (req, res) => controller.criar(req, res))
router.get('/', (req, res) => controller.listar(req, res))
router.get('/:id', (req, res) => controller.obter(req, res))
router.get('/projeto/:projetoId', (req, res) => controller.listarPorProjeto(req, res))
router.put('/:id', (req, res) => controller.atualizar(req, res))
router.delete('/:id', (req, res) => controller.remover(req, res))

export default router
