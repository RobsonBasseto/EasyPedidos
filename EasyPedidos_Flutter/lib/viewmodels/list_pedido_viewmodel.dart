import 'package:collection/collection.dart';
import 'package:easy_pedidos_flutter/models/enums/status_pedido_enum.dart';
import 'package:easy_pedidos_flutter/models/pedido_model.dart';
import 'package:easy_pedidos_flutter/services/pedido_service.dart';
import 'package:easy_pedidos_flutter/viewmodels/base_viewmodel.dart';

class ListPedidoViewModel extends BaseViewModel {
  final PedidoService _pedidoService;

  ListPedidoViewModel(this._pedidoService) {
    title = 'Pedidos';
    _filtroSelecionado = StatusPedidoEnum.emPreparo;
    carregarPedidos(silencioso: true);
  }

  List<PedidoModel> _pedidos = [];
  List<PedidoModel> get pedidos => _pedidos;

  List<PedidoModel> _todosPedidos = [];

  StatusPedidoEnum _filtroSelecionado = StatusPedidoEnum.emPreparo;
  StatusPedidoEnum get filtroSelecionado => _filtroSelecionado;

  set filtroSelecionado(StatusPedidoEnum value) {
    _filtroSelecionado = value;
    _aplicarFiltro();
    notifyListeners();
  }

  List<StatusPedidoEnum> get filtros => [
        StatusPedidoEnum.todos,
        StatusPedidoEnum.emPreparo,
        StatusPedidoEnum.pronto,
        StatusPedidoEnum.faturado,
      ];

  Future<void> carregarPedidos({bool silencioso = false}) async {
    if (!silencioso) isBusy = true;

    try {
      if (!silencioso) {
        // Pequeno delay para mostrar o feedback visual se não for silencioso
        await Future.delayed(const Duration(seconds: 1));
      }

      final result = await _pedidoService.getPedidos();
      _todosPedidos = result;
      _aplicarFiltro();
    } catch (e) {
      errorMessage = 'Não foi possível carregar os pedidos.';
    } finally {
      if (!silencioso) isBusy = false;
    }
  }

  void _aplicarFiltro() {
    Iterable<PedidoModel> filtrados;
    switch (_filtroSelecionado) {
      case StatusPedidoEnum.emPreparo:
        filtrados = _todosPedidos
            .where((p) => p.status == StatusPedidoEnum.emPreparo);
        break;
      case StatusPedidoEnum.pronto:
        filtrados =
            _todosPedidos.where((p) => p.status == StatusPedidoEnum.pronto);
        break;
      case StatusPedidoEnum.faturado:
        filtrados =
            _todosPedidos.where((p) => p.status == StatusPedidoEnum.faturado);
        break;
      case StatusPedidoEnum.todos:
      default:
        filtrados = _todosPedidos;
        break;
    }

    _pedidos = filtrados.sorted((a, b) => b.dataHora.compareTo(a.dataHora));
    title = 'Pedidos - ${_filtroSelecionado.description}';
    notifyListeners();
  }

  Future<void> finalizarPedido(PedidoModel pedido) async {
    if (pedido.status != StatusPedidoEnum.pronto) {
      return;
    }

    // Lógica para finalizar (iria para a página de finalização)
    // Para simplificar no ViewModel, vamos apenas expor a navegação no View
  }
}
