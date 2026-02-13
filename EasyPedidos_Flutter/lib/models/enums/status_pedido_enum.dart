import 'package:easy_pedidos_flutter/theme/app_theme.dart';
import 'package:flutter/material.dart';

enum StatusPedidoEnum {
  todos,
  emPreparo,
  pronto,
  faturado,
  cancelado;

  String get description {
    switch (this) {
      case StatusPedidoEnum.todos:
        return 'Todos';
      case StatusPedidoEnum.emPreparo:
        return 'Em Preparo';
      case StatusPedidoEnum.pronto:
        return 'Pronto';
      case StatusPedidoEnum.faturado:
        return 'Faturado';
      case StatusPedidoEnum.cancelado:
        return 'Cancelado';
    }
  }

  Color get color {
    switch (this) {
      case StatusPedidoEnum.emPreparo:
        return AppTheme.statusEmPreparo;
      case StatusPedidoEnum.pronto:
        return AppTheme.statusPronto;
      case StatusPedidoEnum.faturado:
        return AppTheme.statusFaturado;
      case StatusPedidoEnum.cancelado:
        return const Color(0xFFFF5722);
      default:
        return AppTheme.statusDefault;
    }
  }
}
