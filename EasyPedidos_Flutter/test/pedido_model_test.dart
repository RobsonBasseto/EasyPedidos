import 'package:easy_pedidos_flutter/models/enums/status_pedido_enum.dart';
import 'package:easy_pedidos_flutter/models/item_pedido_model.dart';
import 'package:easy_pedidos_flutter/models/pedido_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PedidoModel', () {
    final now = DateTime.now();

    test('itensResumido should return formatted string', () {
      final pedido = PedidoModel(
        id: 1,
        dataHora: now,
        itens: const [
          ItemPedidoModel(id: 1, nome: 'Burger', preco: 10, quantidade: 2),
          ItemPedidoModel(id: 2, nome: 'Coke', preco: 5, quantidade: 1),
        ],
      );

      expect(pedido.itensResumido, equals('2x Burger, 1x Coke'));
    });

    test('podeFinalizar should be true only when status is pronto', () {
      var pedido = PedidoModel(id: 1, dataHora: now, status: StatusPedidoEnum.emPreparo);
      expect(pedido.podeFinalizar, isFalse);

      pedido = pedido.copyWith(status: StatusPedidoEnum.pronto);
      expect(pedido.podeFinalizar, isTrue);

      pedido = pedido.copyWith(status: StatusPedidoEnum.faturado);
      expect(pedido.podeFinalizar, isFalse);
    });
  });
}
