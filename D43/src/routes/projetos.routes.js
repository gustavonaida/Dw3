import { Router } from 'express'
import { ProjetoController } from '../features/projetos/projeto.controller.js'

const router = Router()
const controller = new ProjetoController()

router.post('/', (req, res) => controller.criar(req, res))
router.get('/', (req, res) => controller.listar(req, res))
router.get('/:id', (req, res) => controller.obter(req, res))
router.put('/:id', (req, res) => controller.atualizar(req, res))
router.delete('/:id', (req, res) => controller.remover(req, res))

export default router
