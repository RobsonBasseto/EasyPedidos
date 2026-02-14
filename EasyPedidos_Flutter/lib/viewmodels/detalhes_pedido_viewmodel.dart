import 'package:easy_pedidos_flutter/models/enums/status_pedido_enum.dart';
import 'package:easy_pedidos_flutter/models/pedido_model.dart';
import 'package:easy_pedidos_flutter/services/pedido_service.dart';
import 'package:easy_pedidos_flutter/viewmodels/base_viewmodel.dart';

class DetalhesPedidoViewModel extends BaseViewModel {
  final PedidoService _pedidoService;
  PedidoModel? _pedido;

  DetalhesPedidoViewModel(this._pedidoService);

  PedidoModel? get pedido => _pedido;

  Future<void> carregarPedido(int pedidoId) async {
    isBusy = true;
    errorMessage = null;
    try {
      _pedido = await _pedidoService.getPedidoById(pedidoId);
      if (_pedido == null) {
        errorMessage = 'Pedido não encontrado.';
      }
    } catch (e) {
      errorMessage = 'Erro ao carregar pedido.';
    } finally {
      isBusy = false;
    }
  }

  Future<void> avancarStatus() async {
    if (_pedido == null) return;

    StatusPedidoEnum? novoStatus;
    if (_pedido!.status == StatusPedidoEnum.emPreparo) {
      novoStatus = StatusPedidoEnum.pronto;
    }

    if (novoStatus != null) {
      isBusy = true;
      try {
        final pedidoAtualizado = _pedido!.copyWith(status: novoStatus);
        await _pedidoService.updatePedido(pedidoAtualizado);
        _pedido = pedidoAtualizado;
        notifyListeners();
      } catch (e) {
        errorMessage = 'Erro ao atualizar status.';
      } finally {
        isBusy = false;
      }
    }
  }
}
