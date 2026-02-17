const express = require('express');
const cors = require('cors');
const { v4: uuidv4 } = require('uuid');

const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());

// Ingredientes pré-definidos
const INGREDIENTES_PADRAO = [
  "Pão",
  "Hambúrguer",
  "Queijo",
  "Alface",
  "Tomate",
  "Cebola",
  "Bacon",
  "Ovo",
  "Molho especial"
];

// In-memory storage
let lanches = [
  {
    id: uuidv4(),
    nome: "X-Burger",
    preco: 25.90,
    ingredientes: ["Pão", "Hambúrguer", "Queijo"],
    ingredientesDisponiveis: INGREDIENTES_PADRAO,
    disponivel: true,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  },
  {
    id: uuidv4(),
    nome: "X-Salada",
    preco: 28.90,
    ingredientes: ["Pão", "Hambúrguer", "Queijo", "Alface", "Tomate"],
    ingredientesDisponiveis: INGREDIENTES_PADRAO,
    disponivel: true,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  },
  {
    id: uuidv4(),
    nome: "X-Bacon",
    preco: 32.90,
    ingredientes: ["Pão", "Hambúrguer", "Queijo", "Bacon"],
    ingredientesDisponiveis: INGREDIENTES_PADRAO,
    disponivel: true,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  }
];

// GET /api/lanches - Listar todos
app.get('/api/lanches', (req, res) => {
  res.json(lanches);
});

// GET /api/lanches/:id - Buscar por ID
app.get('/api/lanches/:id', (req, res) => {
  const lanche = lanches.find(l => l.id === req.params.id);
  if (!lanche) {
    return res.status(404).json({ error: "Lanche não encontrado" });
  }
  res.json(lanche);
});

// POST /api/lanches - Criar novo
app.post('/api/lanches', (req, res) => {
  const { nome, preco, ingredientes, disponivel } = req.body;

  if (!nome || preco === undefined || !ingredientes) {
    return res.status(400).json({ error: "Campos obrigatórios: nome, preco, ingredientes" });
  }

  const novoLanche = {
    id: uuidv4(),
    nome,
    preco: parseFloat(preco),
    ingredientes,
    ingredientesDisponiveis: INGREDIENTES_PADRAO,
    disponivel: disponivel !== undefined ? disponivel : true,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  };

  lanches.push(novoLanche);
  res.status(201).json(novoLanche);
});

// PUT /api/lanches/:id - Atualizar
app.put('/api/lanches/:id', (req, res) => {
  const index = lanches.findIndex(l => l.id === req.params.id);
  if (index === -1) {
    return res.status(404).json({ error: "Lanche não encontrado" });
  }

  const { nome, preco, ingredientes, disponivel } = req.body;

  const lancheAtualizado = {
    ...lanches[index],
    nome: nome || lanches[index].nome,
    preco: preco !== undefined ? parseFloat(preco) : lanches[index].preco,
    ingredientes: ingredientes || lanches[index].ingredientes,
    disponivel: disponivel !== undefined ? disponivel : lanches[index].disponivel,
    updatedAt: new Date().toISOString()
  };

  lanches[index] = lancheAtualizado;
  res.json(lancheAtualizado);
});

// DELETE /api/lanches/:id - Remover
app.delete('/api/lanches/:id', (req, res) => {
  const initialLength = lanches.length;
  lanches = lanches.filter(l => l.id !== req.params.id);

  if (lanches.length === initialLength) {
    return res.status(404).json({ error: "Lanche não encontrado" });
  }

  res.status(204).send();
});

app.listen(port, () => {
  console.log(`API EasyPedidos rodando em http://localhost:${port}`);
});
