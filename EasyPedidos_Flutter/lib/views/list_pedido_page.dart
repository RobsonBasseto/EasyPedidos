import 'package:easy_pedidos_flutter/models/enums/status_pedido_enum.dart';
import 'package:easy_pedidos_flutter/theme/app_theme.dart';
import 'package:easy_pedidos_flutter/viewmodels/list_pedido_viewmodel.dart';
import 'package:easy_pedidos_flutter/widgets/empty_state.dart';
import 'package:easy_pedidos_flutter/widgets/filter_section.dart';
import 'package:easy_pedidos_flutter/widgets/loading_state.dart';
import 'package:easy_pedidos_flutter/widgets/pedido_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ListPedidoPage extends StatelessWidget {
  const ListPedidoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Consumer<ListPedidoViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              children: [
                // CABEÇALHO E FILTROS
                Padding(
                  padding: const EdgeInsets.only(top: 35),
                  child: Column(
                    children: [
                      const Text(
                        'Pedidos em Andamento',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryOrange,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 22),
                      FilterSection(
                        selectedFilter: viewModel.filtroSelecionado,
                        filters: viewModel.filtros,
                        onFilterChanged: (StatusPedidoEnum? newValue) {
                          if (newValue != null) {
                            viewModel.filtroSelecionado = newValue;
                          }
                        },
                        pedidoCount: viewModel.pedidos.length,
                      ),
                    ],
                  ),
                ),

                // LISTA DE PEDIDOS
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => viewModel.carregarPedidos(),
                    color: AppTheme.primaryOrange,
                    child: _buildListContent(context, viewModel),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/novo-pedido'),
        backgroundColor: AppTheme.primaryOrange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildListContent(BuildContext context, ListPedidoViewModel viewModel) {
    if (viewModel.isBusy && viewModel.pedidos.isEmpty) {
      return const LoadingState();
    }

    if (viewModel.pedidos.isEmpty) {
      return const EmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
      itemCount: viewModel.pedidos.length,
      itemBuilder: (context, index) {
        final pedido = viewModel.pedidos[index];
        return PedidoCard(
          pedido: pedido,
          onTap: () => context.push('/detalhes/${pedido.id}'),
          onFinalizar: () => context.push('/finalizar/${pedido.id}'),
        );
      },
    );
  }
}
