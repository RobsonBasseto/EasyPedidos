import 'package:easy_pedidos_flutter/models/enums/status_pedido_enum.dart';
import 'package:easy_pedidos_flutter/models/pedido_model.dart';
import 'package:easy_pedidos_flutter/viewmodels/pedido_viewmodel.dart';

class EditarPedidoViewModel extends PedidoViewModel {
  EditarPedidoViewModel(super.pedidoService, super.produtoService);

  PedidoModel? _pedidoOriginal;
  PedidoModel? get pedidoOriginal => _pedidoOriginal;

  bool get podeEditar => _pedidoOriginal?.status == StatusPedidoEnum.emPreparo;

  Future<void> carregarPedido(int pedidoId) async {
    isBusy = true;
    try {
      final p = await pedidoService.getPedidoById(pedidoId);
      if (p != null) {
        _pedidoOriginal = p;
        identificador = p.identificador;
        localConsumo = p.localConsumo;
        isMesa = p.isMesa;
        itens.clear();
        itens.addAll(p.itens);
        notifyListeners();
      }
    } finally {
      isBusy = false;
    }
  }

  Future<bool> salvarAlteracoes() async {
    if (_pedidoOriginal == null || !podeEditar) return false;
    if (itens.isEmpty) {
      errorMessage = 'O pedido deve ter pelo menos um item.';
      return false;
    }

    isBusy = true;
    try {
      final pedidoAtualizado = _pedidoOriginal!.copyWith(
        identificador: identificador,
        localConsumo: localConsumo,
        isMesa: isMesa,
        itens: List.from(itens),
        total: subtotal,
      );
      await pedidoService.updatePedido(pedidoAtualizado);
      return true;
    } catch (e) {
      errorMessage = 'Erro ao salvar alterações.';
      return false;
    } finally {
      isBusy = false;
    }
  }
}
