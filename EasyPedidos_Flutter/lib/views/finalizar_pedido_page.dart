import 'package:easy_pedidos_flutter/models/pedido_model.dart';
import 'package:flutter/material.dart';

class FinalizarPedidoPage extends StatelessWidget {
  final PedidoModel pedido;

  const FinalizarPedidoPage({
    Key? key,
    required this.pedido,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finalizar Pedido'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Finalizando pedido #${pedido.id}'),
            Text('Total: R\$ ${pedido.total.toStringAsFixed(2)}'),
            const SizedBox(height: 20),
            const Text('Página em desenvolvimento'),
          ],
        ),
      ),
    );
  }
}
