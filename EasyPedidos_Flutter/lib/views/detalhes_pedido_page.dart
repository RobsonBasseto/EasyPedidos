import 'package:easy_pedidos_flutter/models/pedido_model.dart';
import 'package:flutter/material.dart';

class DetalhesPedidoPage extends StatelessWidget {
  final PedidoModel pedido;

  const DetalhesPedidoPage({
    Key? key,
    required this.pedido,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Pedido #${pedido.id}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Identificador: ${pedido.identificador}'),
            Text('Status: ${pedido.statusDescricao}'),
            const SizedBox(height: 20),
            const Text('Página em desenvolvimento'),
          ],
        ),
      ),
    );
  }
}
