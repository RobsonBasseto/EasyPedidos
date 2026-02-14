import 'package:easy_pedidos_flutter/models/enums/local_consumo_enum.dart';
import 'package:easy_pedidos_flutter/models/produto_model.dart';
import 'package:easy_pedidos_flutter/theme/app_theme.dart';
import 'package:easy_pedidos_flutter/viewmodels/editar_pedido_viewmodel.dart';
import 'package:easy_pedidos_flutter/widgets/loading_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class EditarPedidoPage extends StatefulWidget {
  final int pedidoId;

  const EditarPedidoPage({
    Key? key,
    required this.pedidoId,
  }) : super(key: key);

  @override
  State<EditarPedidoPage> createState() => _EditarPedidoPageState();
}

class _EditarPedidoPageState extends State<EditarPedidoPage> {
  final TextEditingController _qtdController = TextEditingController(text: '1');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EditarPedidoViewModel>().carregarPedido(widget.pedidoId);
    });
  }

  @override
  void dispose() {
    _qtdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Pedido'),
      ),
      backgroundColor: AppTheme.background,
      body: Consumer<EditarPedidoViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isBusy && viewModel.pedidoOriginal == null) {
            return const LoadingState();
          }

          if (!viewModel.podeEditar && viewModel.pedidoOriginal != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lock, size: 64, color: Colors.grey),
                    const SizedBox(height: 20),
                    Text(
                      'Este pedido não pode ser editado pois está ${viewModel.pedidoOriginal!.statusDescricao}.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => context.pop(),
                      child: const Text('Voltar'),
                    ),
                  ],
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // INFO BÁSICA
                _buildSectionCard(
                  title: 'Informações Básicas',
                  child: Column(
                    children: [
                      _buildInfoRow('Identificador:', viewModel.identificador),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<LocalConsumoEnum>(
                        value: viewModel.localConsumo,
                        decoration: const InputDecoration(
                          labelText: 'Local de Consumo',
                          border: OutlineInputBorder(),
                        ),
                        items: LocalConsumoEnum.values.map((loc) {
                          return DropdownMenuItem(
                            value: loc,
                            child: Text(loc.description),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) viewModel.localConsumo = value;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ADICIONAR ITEM
                _buildSectionCard(
                  title: 'Adicionar Item',
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: DropdownButtonFormField<ProdutoModel>(
                              value: viewModel.itemSelecionado,
                              decoration: const InputDecoration(
                                labelText: 'Produto',
                                border: OutlineInputBorder(),
                              ),
                              items: viewModel.cardapio.map((p) {
                                return DropdownMenuItem(
                                  value: p,
                                  child: Text(p.nome),
                                );
                              }).toList(),
                              onChanged: (value) => viewModel.itemSelecionado = value,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: TextField(
                              controller: _qtdController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Qtd',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) => viewModel.quantidade = int.tryParse(value) ?? 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: viewModel.itemSelecionado != null
                            ? () {
                                viewModel.adicionarItem(viewModel.itemSelecionado!, viewModel.quantidade, null);
                                viewModel.limparItem();
                                _qtdController.text = '1';
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        child: const Text('Adicionar Item'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // LISTA DE ITENS
                _buildSectionCard(
                  title: 'Itens do Pedido',
                  child: Column(
                    children: [
                      ...viewModel.itens.map((item) {
                        return ListTile(
                          title: Text(item.nome),
                          subtitle: Text('${item.quantidade}x • R\$ ${item.preco.toStringAsFixed(2)}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('R\$ ${item.subtotal.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => viewModel.removerItem(item),
                              ),
                            ],
                          ),
                        );
                      }),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(
                            'R\$ ${viewModel.subtotal.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryOrange,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // AÇÕES
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => context.pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          minimumSize: const Size(double.infinity, 54),
                        ),
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final success = await viewModel.salvarAlteracoes();
                          if (success && mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Alterações salvas com sucesso!')),
                            );
                            context.pop();
                          } else if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(viewModel.errorMessage ?? 'Erro ao salvar')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          minimumSize: const Size(double.infinity, 54),
                        ),
                        child: const Text('Salvar Alterações'),
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

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value),
      ],
    );
  }
}
