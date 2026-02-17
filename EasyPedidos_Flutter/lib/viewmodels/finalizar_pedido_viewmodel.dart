import 'package:easy_pedidos_flutter/models/enums/forma_pagamento_enum.dart';
import 'package:easy_pedidos_flutter/models/enums/status_pedido_enum.dart';
import 'package:easy_pedidos_flutter/models/pedido_model.dart';
import 'package:easy_pedidos_flutter/services/pedido_service.dart';
import 'package:easy_pedidos_flutter/viewmodels/base_viewmodel.dart';

class FinalizarPedidoViewModel extends BaseViewModel {
  final PedidoService _pedidoService;
  PedidoModel? _pedido;
  FormaPagamentoEnum? _formaPagamento;
  String _valorRecebidoString = '';

  FinalizarPedidoViewModel(this._pedidoService);

  PedidoModel? get pedido => _pedido;
  FormaPagamentoEnum? get formaPagamento => _formaPagamento;
  String get valorRecebidoString => _valorRecebidoString;

  set formaPagamento(FormaPagamentoEnum? value) {
    _formaPagamento = value;
    notifyListeners();
  }

  set valorRecebidoString(String value) {
    _valorRecebidoString = value;
    notifyListeners();
  }

  bool get mostrarCampoDinheiro => _formaPagamento == FormaPagamentoEnum.dinheiro;

  double get valorRecebido => double.tryParse(_valorRecebidoString.replaceAll(',', '.')) ?? 0.0;

  double get troco => (pedido != null) ? (valorRecebido - pedido!.total) : 0.0;

  bool get temTroco => troco > 0;

  bool get podeFinalizar => _formaPagamento != null && (!mostrarCampoDinheiro || valorRecebido >= (_pedido?.total ?? 0));

  Future<void> carregarPedido(int pedidoId) async {
    isBusy = true;
    try {
      _pedido = await _pedidoService.getPedidoById(pedidoId);
    } finally {
      isBusy = false;
    }
  }

  Future<bool> finalizarPedido() async {
    if (_pedido == null || !podeFinalizar) return false;

    isBusy = true;
    try {
      final pedidoFinalizado = _pedido!.copyWith(
        status: StatusPedidoEnum.faturado,
        formaPagamento: _formaPagamento,
        dataFaturamento: DateTime.now(),
      );
      await _pedidoService.updatePedido(pedidoFinalizado);
      return true;
    } catch (e) {
      errorMessage = 'Erro ao finalizar pedido.';
      return false;
    } finally {
      isBusy = false;
    }
  }
}
