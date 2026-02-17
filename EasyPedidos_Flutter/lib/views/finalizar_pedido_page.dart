import 'package:easy_pedidos_flutter/models/enums/forma_pagamento_enum.dart';
import 'package:easy_pedidos_flutter/theme/app_theme.dart';
import 'package:easy_pedidos_flutter/viewmodels/finalizar_pedido_viewmodel.dart';
import 'package:easy_pedidos_flutter/widgets/loading_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class FinalizarPedidoPage extends StatefulWidget {
  final int pedidoId;

  const FinalizarPedidoPage({
    Key? key,
    required this.pedidoId,
  }) : super(key: key);

  @override
  State<FinalizarPedidoPage> createState() => _FinalizarPedidoPageState();
}

class _FinalizarPedidoPageState extends State<FinalizarPedidoPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FinalizarPedidoViewModel>().carregarPedido(widget.pedidoId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finalizar Pedido'),
      ),
      backgroundColor: AppTheme.background,
      body: Consumer<FinalizarPedidoViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isBusy && viewModel.pedido == null) {
            return const LoadingState();
          }

          final pedido = viewModel.pedido;
          if (pedido == null) {
            return const Center(child: Text('Pedido não encontrado.'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // RESUMO
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF708090), // SlateGray equivalent
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      _buildSummaryRow(pedido.identificadorLabel, pedido.identificador),
                      const SizedBox(height: 10),
                      _buildSummaryRow('Número:', '#${pedido.id}'),
                      const SizedBox(height: 10),
                      _buildSummaryRow('Total:', 'R\$ ${pedido.total.toStringAsFixed(2)}', isBold: true),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // FORMA DE PAGAMENTO
                _buildSectionCard(
                  title: 'Forma de Pagamento',
                  child: Column(
                    children: FormaPagamentoEnum.values.map((forma) {
                      return RadioListTile<FormaPagamentoEnum>(
                        title: Text(forma.description),
                        value: forma,
                        groupValue: viewModel.formaPagamento,
                        onChanged: (value) => viewModel.formaPagamento = value,
                        activeColor: AppTheme.primaryOrange,
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),

                // CAMPO DINHEIRO
                if (viewModel.mostrarCampoDinheiro)
                  _buildSectionCard(
                    title: 'Informações Adicionais',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Valor Recebido:', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        TextField(
                          onChanged: (value) => viewModel.valorRecebidoString = value,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            hintText: '0,00',
                            border: OutlineInputBorder(),
                            prefixText: 'R\$ ',
                          ),
                        ),
                        if (viewModel.temTroco)
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Text(
                              'Troco: R\$ ${viewModel.troco.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),

                const SizedBox(height: 30),

                // BOTÕES
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => context.pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          minimumSize: const Size(double.infinity, 54),
                        ),
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: viewModel.podeFinalizar
                            ? () async {
                                final success = await viewModel.finalizarPedido();
                                if (success && mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Pedido finalizado com sucesso!')),
                                  );
                                  context.go('/');
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: const Size(double.infinity, 54),
                        ),
                        child: const Text('Confirmar Finalização'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: isBold ? 18 : 16,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: isBold ? 18 : 16,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryOrange,
            ),
          ),
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }
}
