import 'dart:async';
import 'package:easy_pedidos_flutter/models/enums/local_consumo_enum.dart';
import 'package:easy_pedidos_flutter/models/enums/status_pedido_enum.dart';
import 'package:easy_pedidos_flutter/models/item_pedido_model.dart';
import 'package:easy_pedidos_flutter/models/pedido_model.dart';

class PedidoService {
  final List<PedidoModel> _pedidos = [];

  // Stream to notify about updates
  final _updatesController = StreamController<int>.broadcast();
  Stream<int> get onPedidoUpdated => _updatesController.stream;

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
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_pedidos);
  }

  Future<PedidoModel?> getPedidoById(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _pedidos.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> savePedido(PedidoModel pedido) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Simple auto-increment for mock
    final newId = _pedidos.isEmpty ? 1 : _pedidos.map((p) => p.id).reduce((a, b) => a > b ? a : b) + 1;
    final newPedido = pedido.copyWith(id: newId, dataHora: DateTime.now());
    _pedidos.add(newPedido);
    _updatesController.add(newId);
  }

  Future<void> updatePedido(PedidoModel pedido) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _pedidos.indexWhere((p) => p.id == pedido.id);
    if (index != -1) {
      _pedidos[index] = pedido;
      _updatesController.add(pedido.id);
    }
  }

  void dispose() {
    _updatesController.close();
  }
}
