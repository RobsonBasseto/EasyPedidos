import 'package:easy_pedidos_flutter/models/enums/local_consumo_enum.dart';
import 'package:easy_pedidos_flutter/models/enums/status_pedido_enum.dart';
import 'package:easy_pedidos_flutter/models/item_pedido_model.dart';
import 'package:easy_pedidos_flutter/models/pedido_model.dart';
import 'package:easy_pedidos_flutter/models/produto_model.dart';
import 'package:easy_pedidos_flutter/services/pedido_service.dart';
import 'package:easy_pedidos_flutter/services/produto_service.dart';
import 'package:easy_pedidos_flutter/viewmodels/base_viewmodel.dart';

class PedidoViewModel extends BaseViewModel {
  final PedidoService pedidoService;
  final ProdutoService produtoService;

  PedidoViewModel(this.pedidoService, this.produtoService) {
    title = 'Novo Pedido';
    carregarProdutos();
  }

  List<ProdutoModel> _cardapio = [];
  List<ProdutoModel> get cardapio => _cardapio;

  List<ItemPedidoModel> _itens = [];
  List<ItemPedidoModel> get itens => _itens;

  String? observacoes;
  LocalConsumoEnum localConsumo = LocalConsumoEnum.noLocal;
  bool isMesa = true;
  String identificador = '';

  ProdutoModel? _itemSelecionado;
  ProdutoModel? get itemSelecionado => _itemSelecionado;
  set itemSelecionado(ProdutoModel? value) {
    _itemSelecionado = value;
    notifyListeners();
  }

  int quantidade = 1;

  double get subtotal => _itens.fold(0, (sum, item) => sum + item.subtotal);

  Future<void> carregarProdutos() async {
    _cardapio = await produtoService.getProdutos();
    notifyListeners();
  }

  void adicionarItem(ProdutoModel produto, int qtd, String? obs, [List<String>? ingredientes]) {
    final novoItem = ItemPedidoModel(
      id: int.tryParse(produto.id) ?? DateTime.now().millisecondsSinceEpoch,
      nome: produto.nome,
      preco: produto.preco,
      quantidade: qtd,
      observacao: obs ?? '',
      ingredientes: ingredientes ?? produto.ingredientes,
    );
    _itens.add(novoItem);
    notifyListeners();
  }

  void removerItem(ItemPedidoModel item) {
    _itens.remove(item);
    notifyListeners();
  }

  void limparItem() {
    _itemSelecionado = null;
    quantidade = 1;
    notifyListeners();
  }

  Future<bool> salvarPedido() async {
    if (identificador.isEmpty) {
      errorMessage = 'Informe o identificador (Mesa/Placa).';
      return false;
    }
    if (_itens.isEmpty) {
      errorMessage = 'Adicione pelo menos um item.';
      return false;
    }

    isBusy = true;
    try {
      final novoPedido = PedidoModel(
        id: 0, // Service handles ID
        dataHora: DateTime.now(),
        status: StatusPedidoEnum.emPreparo,
        itens: _itens,
        localConsumo: localConsumo,
        isMesa: isMesa,
        identificador: identificador,
        total: subtotal,
      );
      await pedidoService.savePedido(novoPedido);
      return true;
    } catch (e) {
      errorMessage = 'Erro ao salvar pedido.';
      return false;
    } finally {
      isBusy = false;
    }
  }
}
