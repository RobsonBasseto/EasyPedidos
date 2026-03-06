const express = require('express');
const cors = require('cors');
const { v4: uuidv4 } = require('uuid');

const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());

// --- ENTIDADE: INGREDIENTES ---
let ingredientes = [
  "Pão", "Hambúrguer", "Queijo", "Alface", "Tomate", "Cebola", "Bacon", "Ovo", "Molho especial"
];

app.get('/api/ingredientes', (req, res) => {
  res.json(ingredientes);
});

app.post('/api/ingredientes', (req, res) => {
  const { nome } = req.body;
  if (!nome) return res.status(400).json({ error: "Nome do ingrediente é obrigatório" });
  if (ingredientes.includes(nome)) return res.status(400).json({ error: "Ingrediente já existe" });
  ingredientes.push(nome);
  res.status(201).json({ nome });
});

// --- ENTIDADE: LANCHES (PRODUTOS) ---
let lanches = [
  {
    id: uuidv4(),
    nome: "X-Burger",
    preco: 25.90,
    ingredientes: ["Pão", "Hambúrguer", "Queijo"],
    ingredientesDisponiveis: ingredientes,
    disponivel: true,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  },
  {
    id: uuidv4(),
    nome: "X-Salada",
    preco: 28.90,
    ingredientes: ["Pão", "Hambúrguer", "Queijo", "Alface", "Tomate"],
    ingredientesDisponiveis: ingredientes,
    disponivel: true,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  },
  {
    id: uuidv4(),
    nome: "X-Bacon",
    preco: 32.90,
    ingredientes: ["Pão", "Hambúrguer", "Queijo", "Bacon"],
    ingredientesDisponiveis: ingredientes,
    disponivel: true,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  }
];

app.get('/api/lanches', (req, res) => {
  res.json(lanches);
});

app.get('/api/lanches/:id', (req, res) => {
  const lanche = lanches.find(l => l.id === req.params.id);
  if (!lanche) return res.status(404).json({ error: "Lanche não encontrado" });
  res.json(lanche);
});

app.post('/api/lanches', (req, res) => {
  const { nome, preco, ingredientes: ings, ingredientesDisponiveis, disponivel } = req.body;
  if (!nome || preco === undefined || !ings) {
    return res.status(400).json({ error: "Campos obrigatórios: nome, preco, ingredientes" });
  }

  const novoLanche = {
    id: uuidv4(),
    nome,
    preco: parseFloat(preco),
    ingredientes: ings,
    ingredientesDisponiveis: ingredientesDisponiveis || ingredientes,
    disponivel: disponivel !== undefined ? disponivel : true,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  };

  lanches.push(novoLanche);
  res.status(201).json(novoLanche);
});

app.put('/api/lanches/:id', (req, res) => {
  const index = lanches.findIndex(l => l.id === req.params.id);
  if (index === -1) return res.status(404).json({ error: "Lanche não encontrado" });

  const { nome, preco, ingredientes: ings, ingredientesDisponiveis, disponivel } = req.body;

  lanches[index] = {
    ...lanches[index],
    nome: nome || lanches[index].nome,
    preco: preco !== undefined ? parseFloat(preco) : lanches[index].preco,
    ingredientes: ings || lanches[index].ingredientes,
    ingredientesDisponiveis: ingredientesDisponiveis || lanches[index].ingredientesDisponiveis,
    disponivel: disponivel !== undefined ? disponivel : lanches[index].disponivel,
    updatedAt: new Date().toISOString()
  };

  res.json(lanches[index]);
});

app.delete('/api/lanches/:id', (req, res) => {
  lanches = lanches.filter(l => l.id !== req.params.id);
  res.status(204).send();
});

// --- ENTIDADE: PEDIDOS ---
let pedidos = [];
let nextPedidoId = 1;

app.get('/api/pedidos', (req, res) => {
  const { status } = req.query;
  if (status) {
    return res.json(pedidos.filter(p => p.status === status));
  }
  res.json(pedidos);
});

app.post('/api/pedidos', (req, res) => {
  const { identificador, localConsumo, isMesa, itens, total } = req.body;

  if (!identificador || !localConsumo || !itens || total === undefined) {
    return res.status(400).json({ error: "Dados do pedido incompletos" });
  }

  const novoPedido = {
    id: nextPedidoId++,
    dataHora: new Date().toISOString(),
    status: 'emPreparo',
    itens,
    localConsumo,
    isMesa: isMesa !== undefined ? isMesa : true,
    identificador,
    total: parseFloat(total),
    formaPagamento: null,
    dataFaturamento: null
  };

  pedidos.push(novoPedido);
  res.status(201).json(novoPedido);
});

app.put('/api/pedidos/:id', (req, res) => {
  const id = parseInt(req.params.id);
  const index = pedidos.findIndex(p => p.id === id);
  if (index === -1) return res.status(404).json({ error: "Pedido não encontrado" });

  const { status, itens, total } = req.body;

  if (status) {
    pedidos[index].status = status;
  }

  // Só permite editar itens se estiver em preparo
  if (itens && pedidos[index].status === 'emPreparo') {
    pedidos[index].itens = itens;
    if (total !== undefined) pedidos[index].total = parseFloat(total);
  }

  res.json(pedidos[index]);
});

app.patch('/api/pedidos/:id/finalizar', (req, res) => {
  const id = parseInt(req.params.id);
  const index = pedidos.findIndex(p => p.id === id);
  if (index === -1) return res.status(404).json({ error: "Pedido não encontrado" });

  const { formaPagamento, dataFaturamento } = req.body;
  if (!formaPagamento) return res.status(400).json({ error: "Forma de pagamento é obrigatória" });

  pedidos[index].status = 'faturado';
  pedidos[index].formaPagamento = formaPagamento;
  pedidos[index].dataFaturamento = dataFaturamento || new Date().toISOString();

  res.json(pedidos[index]);
});

app.listen(port, () => {
  console.log(`API EasyPedidos rodando em http://localhost:${port}`);
});
