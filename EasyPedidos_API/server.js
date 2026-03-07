const express = require('express');
const cors = require('cors');
const { v4: uuidv4 } = require('uuid');

const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());

// Ingredientes configuráveis
let ingredientes = [
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
    ingredientesDisponiveis: [...ingredientes],
    disponivel: true,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  },
  {
    id: uuidv4(),
    nome: "X-Salada",
    preco: 28.90,
    ingredientes: ["Pão", "Hambúrguer", "Queijo", "Alface", "Tomate"],
    ingredientesDisponiveis: [...ingredientes],
    disponivel: true,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  },
  {
    id: uuidv4(),
    nome: "X-Bacon",
    preco: 32.90,
    ingredientes: ["Pão", "Hambúrguer", "Queijo", "Bacon"],
    ingredientesDisponiveis: [...ingredientes],
    disponivel: true,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  }
];

let pedidos = [];
let nextPedidoId = 1;

const STATUS_PEDIDO_VALIDOS = ['emPreparo', 'pronto', 'faturado'];
const LOCAL_CONSUMO_VALIDOS = ['noLocal', 'retirada', 'entrega'];
const FORMAS_PAGAMENTO_VALIDAS = ['dinheiro', 'cartaoCredito', 'cartaoDebito', 'pix', 'outros'];

function isValidIsoDate(dateString) {
  if (!dateString || typeof dateString !== 'string') return false;
  const date = new Date(dateString);
  return !Number.isNaN(date.getTime()) && date.toISOString() === dateString;
}

function normalizePedidoItem(item) {
  const idNumber = Number.parseInt(item.id, 10);
  return {
    id: Number.isNaN(idNumber) ? item.id : idNumber,
    nome: item.nome,
    preco: Number.parseFloat(item.preco),
    quantidade: Number.parseInt(item.quantidade, 10),
    observacao: item.observacao || '',
    ingredientes: Array.isArray(item.ingredientes) ? item.ingredientes : []
  };
}

function validatePedidoItems(itens) {
  if (!Array.isArray(itens) || itens.length === 0) {
    return 'O pedido deve conter ao menos um item';
  }

  for (const item of itens) {
    if (!item || item.id === undefined || !item.nome || item.preco === undefined || item.quantidade === undefined) {
      return 'Cada item deve conter id, nome, preco e quantidade';
    }

    const preco = Number.parseFloat(item.preco);
    const quantidade = Number.parseInt(item.quantidade, 10);
    if (Number.isNaN(preco) || Number.isNaN(quantidade) || quantidade <= 0) {
      return 'Cada item deve ter preco numérico e quantidade maior que zero';
    }
  }

  return null;
}

// GET /api/ingredientes - Listar ingredientes padrão
app.get('/api/ingredientes', (req, res) => {
  res.json(ingredientes);
});

// POST /api/ingredientes - Cadastrar ingrediente padrão
app.post('/api/ingredientes', (req, res) => {
  const { nome } = req.body;

  if (!nome || typeof nome !== 'string' || !nome.trim()) {
    return res.status(400).json({ error: 'Campo obrigatório: nome' });
  }

  const ingredienteNormalizado = nome.trim();

  if (ingredientes.includes(ingredienteNormalizado)) {
    return res.status(409).json({ error: 'Ingrediente já cadastrado' });
  }

  ingredientes.push(ingredienteNormalizado);
  res.status(201).json({ nome: ingredienteNormalizado });
});

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
  const { nome, preco, ingredientes, ingredientesDisponiveis, disponivel } = req.body;

  if (!nome || preco === undefined || !ingredientes) {
    return res.status(400).json({ error: "Campos obrigatórios: nome, preco, ingredientes" });
  }

  const novoLanche = {
    id: uuidv4(),
    nome,
    preco: parseFloat(preco),
    ingredientes,
    ingredientesDisponiveis: Array.isArray(ingredientesDisponiveis)
      ? ingredientesDisponiveis
      : [...ingredientes],
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

  const { nome, preco, ingredientes, ingredientesDisponiveis, disponivel } = req.body;

  const lancheAtualizado = {
    ...lanches[index],
    nome: nome || lanches[index].nome,
    preco: preco !== undefined ? parseFloat(preco) : lanches[index].preco,
    ingredientes: ingredientes || lanches[index].ingredientes,
    ingredientesDisponiveis: ingredientesDisponiveis || lanches[index].ingredientesDisponiveis,
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

// POST /api/pedidos - Criar pedido
app.post('/api/pedidos', (req, res) => {
  const { identificador, localConsumo, itens, total } = req.body;

  if (!identificador || typeof identificador !== 'string') {
    return res.status(400).json({ error: 'Campo obrigatório: identificador' });
  }

  if (!LOCAL_CONSUMO_VALIDOS.includes(localConsumo)) {
    return res.status(400).json({ error: `localConsumo inválido. Valores aceitos: ${LOCAL_CONSUMO_VALIDOS.join(', ')}` });
  }

  const itensErro = validatePedidoItems(itens);
  if (itensErro) {
    return res.status(400).json({ error: itensErro });
  }

  const totalNumerico = Number.parseFloat(total);
  if (Number.isNaN(totalNumerico)) {
    return res.status(400).json({ error: 'Campo obrigatório: total (numérico)' });
  }

  const nowIso = new Date().toISOString();
  const novoPedido = {
    id: nextPedidoId++,
    dataHora: nowIso,
    status: 'emPreparo',
    itens: itens.map(normalizePedidoItem),
    formaPagamento: null,
    dataFaturamento: null,
    localConsumo,
    isMesa: /^mesa/i.test(identificador),
    identificador,
    total: totalNumerico
  };

  pedidos.push(novoPedido);
  res.status(201).json(novoPedido);
});

// GET /api/pedidos - Listar pedidos com filtro de status
app.get('/api/pedidos', (req, res) => {
  const { status } = req.query;

  if (!status) {
    return res.json(pedidos);
  }

  if (!STATUS_PEDIDO_VALIDOS.includes(status)) {
    return res.status(400).json({ error: `status inválido. Valores aceitos: ${STATUS_PEDIDO_VALIDOS.join(', ')}` });
  }

  const pedidosFiltrados = pedidos.filter(pedido => pedido.status === status);
  return res.json(pedidosFiltrados);
});

// PUT /api/pedidos/:id - Atualizar status e itens
app.put('/api/pedidos/:id', (req, res) => {
  const pedidoId = Number.parseInt(req.params.id, 10);
  const index = pedidos.findIndex(p => p.id === pedidoId);

  if (index === -1) {
    return res.status(404).json({ error: 'Pedido não encontrado' });
  }

  const pedidoAtual = pedidos[index];
  const { status, itens, total, localConsumo, identificador } = req.body;

  if (status !== undefined && !STATUS_PEDIDO_VALIDOS.includes(status)) {
    return res.status(400).json({ error: `status inválido. Valores aceitos: ${STATUS_PEDIDO_VALIDOS.join(', ')}` });
  }

  if (localConsumo !== undefined && !LOCAL_CONSUMO_VALIDOS.includes(localConsumo)) {
    return res.status(400).json({ error: `localConsumo inválido. Valores aceitos: ${LOCAL_CONSUMO_VALIDOS.join(', ')}` });
  }

  if (itens !== undefined && pedidoAtual.status !== 'emPreparo') {
    return res.status(400).json({ error: 'Itens só podem ser editados enquanto o pedido estiver emPreparo' });
  }

  if (itens !== undefined) {
    const itensErro = validatePedidoItems(itens);
    if (itensErro) {
      return res.status(400).json({ error: itensErro });
    }
  }

  const pedidoAtualizado = {
    ...pedidoAtual,
    status: status || pedidoAtual.status,
    itens: itens ? itens.map(normalizePedidoItem) : pedidoAtual.itens,
    total: total !== undefined ? Number.parseFloat(total) : pedidoAtual.total,
    localConsumo: localConsumo || pedidoAtual.localConsumo,
    identificador: identificador || pedidoAtual.identificador,
    isMesa: identificador ? /^mesa/i.test(identificador) : pedidoAtual.isMesa
  };

  pedidos[index] = pedidoAtualizado;
  res.json(pedidoAtualizado);
});

// PATCH /api/pedidos/:id/finalizar - Faturar pedido
app.patch('/api/pedidos/:id/finalizar', (req, res) => {
  const pedidoId = Number.parseInt(req.params.id, 10);
  const index = pedidos.findIndex(p => p.id === pedidoId);

  if (index === -1) {
    return res.status(404).json({ error: 'Pedido não encontrado' });
  }

  const { formaPagamento, dataFaturamento } = req.body;
  if (!FORMAS_PAGAMENTO_VALIDAS.includes(formaPagamento)) {
    return res.status(400).json({ error: `formaPagamento inválida. Valores aceitos: ${FORMAS_PAGAMENTO_VALIDAS.join(', ')}` });
  }

  const dataFaturamentoIso = dataFaturamento || new Date().toISOString();
  if (!isValidIsoDate(dataFaturamentoIso)) {
    return res.status(400).json({ error: 'dataFaturamento deve estar em formato ISO8601 (ex: 2024-01-01T12:00:00.000Z)' });
  }

  const pedidoAtualizado = {
    ...pedidos[index],
    status: 'faturado',
    formaPagamento,
    dataFaturamento: dataFaturamentoIso
  };

  pedidos[index] = pedidoAtualizado;
  res.json(pedidoAtualizado);
});

app.listen(port, () => {
  console.log(`API EasyPedidos rodando em http://localhost:${port}`);
});
