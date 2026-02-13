import 'package:easy_pedidos_flutter/models/enums/local_consumo_enum.dart';
import 'package:easy_pedidos_flutter/models/enums/status_pedido_enum.dart';
import 'package:easy_pedidos_flutter/models/item_pedido_model.dart';
import 'package:easy_pedidos_flutter/models/pedido_model.dart';

class PedidoService {
  final List<PedidoModel> _pedidos = [];

  PedidoService() {
    _populateMockData();
  }

  void _populateMockData() {
    _pedidos.addAll([
      PedidoModel(
        id: 1,
        identificador: 'Mesa 1',
        dataHora: DateTime.now().subtract(const Duration(minutes: 30)),
        status: StatusPedidoEnum.emPreparo,
        localConsumo: LocalConsumoEnum.noLocal,
        itens: const [
          ItemPedidoModel(id: 1, nome: 'X-Burger', preco: 15.0, quantidade: 2),
          ItemPedidoModel(id: 5, nome: 'Refrigerante', preco: 6.0, quantidade: 2),
        ],
        total: 42.0,
      ),
      PedidoModel(
        id: 2,
        identificador: 'ABC-1234',
        dataHora: DateTime.now().subtract(const Duration(minutes: 20)),
        status: StatusPedidoEnum.pronto,
        isMesa: false,
        localConsumo: LocalConsumoEnum.retirada,
        itens: const [
          ItemPedidoModel(id: 2, nome: 'X-Bacon', preco: 18.0, quantidade: 1),
          ItemPedidoModel(id: 4, nome: 'Batata Frita', preco: 12.0, quantidade: 1),
        ],
        total: 30.0,
      ),
      PedidoModel(
        id: 3,
        identificador: 'Mesa 5',
        dataHora: DateTime.now().subtract(const Duration(minutes: 45)),
        status: StatusPedidoEnum.faturado,
        localConsumo: LocalConsumoEnum.noLocal,
        itens: const [
          ItemPedidoModel(id: 3, nome: 'X-Salada', preco: 16.0, quantidade: 1),
          ItemPedidoModel(id: 6, nome: 'Suco', preco: 8.0, quantidade: 1),
        ],
        total: 24.0,
      ),
      PedidoModel(
        id: 4,
        identificador: 'Mesa 3',
        dataHora: DateTime.now().subtract(const Duration(minutes: 10)),
        status: StatusPedidoEnum.emPreparo,
        localConsumo: LocalConsumoEnum.noLocal,
        itens: const [
          ItemPedidoModel(id: 1, nome: 'X-Burger', preco: 15.0, quantidade: 3),
        ],
        total: 45.0,
      ),
      PedidoModel(
        id: 5,
        identificador: 'XYZ-9876',
        dataHora: DateTime.now().subtract(const Duration(minutes: 5)),
        status: StatusPedidoEnum.pronto,
        isMesa: false,
        localConsumo: LocalConsumoEnum.entrega,
        itens: const [
          ItemPedidoModel(id: 2, nome: 'X-Bacon', preco: 18.0, quantidade: 2),
          ItemPedidoModel(id: 5, nome: 'Refrigerante', preco: 6.0, quantidade: 2),
        ],
        total: 48.0,
      ),
    ]);
  }

  Future<List<PedidoModel>> getPedidos() async {
    // Simulando delay de rede
    await Future.delayed(const Duration(milliseconds: 800));
    return List.from(_pedidos);
  }

  Future<void> updatePedido(PedidoModel pedido) async {
    final index = _pedidos.indexWhere((p) => p.id == pedido.id);
    if (index != -1) {
      _pedidos[index] = pedido;
    }
  }
}
