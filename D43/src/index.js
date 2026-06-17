import express from 'express'
import tarefasRoutes from './routes/tarefas.routes.js'
import projetosRoutes from './routes/projetos.routes.js'

const app = express()
const PORT = process.env.PORT || 3000

app.use(express.json())

app.use('/tarefas', tarefasRoutes)
app.use('/projetos', projetosRoutes)

app.get('/', (req, res) => {
  res.json({
    mensagem: 'API de Tarefas e Projetos',
    versao: '1.0.0',
    endpoints: {
      tarefas: '/tarefas',
      projetos: '/projetos'
    }
  })
})

app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`)
})
