import 'package:easy_pedidos_flutter/models/enums/status_pedido_enum.dart';
import 'package:easy_pedidos_flutter/models/item_pedido_model.dart';
import 'package:easy_pedidos_flutter/theme/app_theme.dart';
import 'package:easy_pedidos_flutter/utils/date_formatter.dart';
import 'package:easy_pedidos_flutter/viewmodels/detalhes_pedido_viewmodel.dart';
import 'package:easy_pedidos_flutter/widgets/loading_state.dart';
import 'package:easy_pedidos_flutter/widgets/status_badge.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class DetalhesPedidoPage extends StatefulWidget {
  final int pedidoId;

  const DetalhesPedidoPage({
    Key? key,
    required this.pedidoId,
  }) : super(key: key);

  @override
  State<DetalhesPedidoPage> createState() => _DetalhesPedidoPageState();
}

class _DetalhesPedidoPageState extends State<DetalhesPedidoPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DetalhesPedidoViewModel>().carregarPedido(widget.pedidoId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Pedido'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      backgroundColor: AppTheme.background,
      body: Consumer<DetalhesPedidoViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isBusy) {
            return const LoadingState();
          }

          final pedido = viewModel.pedido;
          if (pedido == null) {
            return Center(
              child: Text(viewModel.errorMessage ?? 'Pedido não encontrado'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    pedido.identificador,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryOrange,
                    ),
                  ),
                ),
                const SizedBox(height: 22),

                // 1. INFORMAÇÕES DO PEDIDO
                _buildCard(
                  title: '1. Informações',
                  children: [
                    _buildInfoRow('Número:', '#${pedido.id}'),
                    _buildInfoRow(pedido.identificadorLabel, pedido.identificador),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Status:', style: TextStyle(fontWeight: FontWeight.bold)),
                        StatusBadge(status: pedido.status),
                      ],
                    ),
                    _buildInfoRow('Local de Consumo:', pedido.localConsumoDescription),
                    _buildInfoRow('Data/Hora:', DateFormatter.formatarDataHora(pedido.dataHora)),
                  ],
                ),
                const SizedBox(height: 22),

                // 2. ITENS DO PEDIDO
                _buildCard(
                  title: '2. Itens do Pedido',
                  children: [
                    ...pedido.itens.map((item) => _buildItemRow(item)),
                    const Divider(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'R\$ ${pedido.total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryOrange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // BOTÕES DE AÇÃO
                if (pedido.status != StatusPedidoEnum.faturado && pedido.status != StatusPedidoEnum.cancelado)
                  Row(
                    children: [
                      if (pedido.status == StatusPedidoEnum.emPreparo)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: ElevatedButton(
                              onPressed: () => context.push('/editar/${pedido.id}'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF4444),
                                minimumSize: const Size(double.infinity, 54),
                              ),
                              child: const Text('Editar Pedido'),
                            ),
                          ),
                        ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (pedido.status == StatusPedidoEnum.emPreparo) {
                              viewModel.avancarStatus();
                            } else if (pedido.status == StatusPedidoEnum.pronto) {
                              context.push('/finalizar/${pedido.id}');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryOrange,
                            minimumSize: const Size(double.infinity, 54),
                          ),
                          child: Text(
                            pedido.status == StatusPedidoEnum.emPreparo ? 'Marcar como Pronto' : 'Finalizar Pedido',
                          ),
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

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.border),
      ),
      padding: const EdgeInsets.all(18),
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
          const SizedBox(height: 14),
          ...children.expand((widget) => [widget, const SizedBox(height: 10)]).toList()..removeLast(),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        Text(value, style: const TextStyle(fontSize: 15, color: Color(0xFF555555))),
      ],
    );
  }

  Widget _buildItemRow(ItemPedidoModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.nome, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text('${item.quantidade}x • R\$ ${item.preco.toStringAsFixed(2)}',
                     style: const TextStyle(fontSize: 13, color: Color(0xFF777777))),
              ],
            ),
          ),
          Text(
            'R\$ ${item.subtotal.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppTheme.primaryOrange),
          ),
        ],
      ),
    );
  }
}
