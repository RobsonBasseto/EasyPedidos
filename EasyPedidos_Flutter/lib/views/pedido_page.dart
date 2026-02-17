import 'package:easy_pedidos_flutter/models/enums/local_consumo_enum.dart';
import 'package:easy_pedidos_flutter/models/produto_model.dart';
import 'package:easy_pedidos_flutter/theme/app_theme.dart';
import 'package:easy_pedidos_flutter/viewmodels/pedido_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PedidoPage extends StatefulWidget {
  const PedidoPage({Key? key}) : super(key: key);

  @override
  State<PedidoPage> createState() => _PedidoPageState();
}

class _PedidoPageState extends State<PedidoPage> {
  final TextEditingController _identificadorController = TextEditingController();
  final TextEditingController _qtdController = TextEditingController(text: '1');
  final TextEditingController _obsItemController = TextEditingController();

  @override
  void dispose() {
    _identificadorController.dispose();
    _qtdController.dispose();
    _obsItemController.dispose();
    super.dispose();
  }

  void _showCustomizacaoModal(BuildContext context, PedidoViewModel viewModel, ProdutoModel produto) {
    List<String> ingredientesSelecionados = List.from(produto.ingredientes);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return AlertDialog(
              title: Text('Customizar ${produto.nome}'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: produto.ingredientesDisponiveis.map((ingrediente) {
                    final bool isOriginal = produto.ingredientes.contains(ingrediente);
                    return CheckboxListTile(
                      title: Text(ingrediente),
                      subtitle: isOriginal ? null : const Text('Adicional', style: TextStyle(fontSize: 12)),
                      value: ingredientesSelecionados.contains(ingrediente),
                      onChanged: (bool? value) {
                        setStateModal(() {
                          if (value == true) {
                            ingredientesSelecionados.add(ingrediente);
                          } else {
                            ingredientesSelecionados.remove(ingrediente);
                          }
                        });
                      },
                      activeColor: AppTheme.primaryOrange,
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    viewModel.adicionarItem(
                      produto,
                      viewModel.quantidade,
                      null,
                      ingredientesSelecionados,
                    );
                    viewModel.limparItem();
                    _qtdController.text = '1';
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryOrange),
                  child: const Text('Adicionar ao Pedido'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Pedido'),
      ),
      backgroundColor: AppTheme.background,
      body: Consumer<PedidoViewModel>(
        builder: (context, viewModel, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // 1. ITENS DO PEDIDO
                _buildSectionCard(
                  title: '1. Itens do Pedido',
                  child: Column(
                    children: [
                      // SELEÇÃO DE PRODUTO
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
                      ElevatedButton.icon(
                        onPressed: viewModel.itemSelecionado != null
                            ? () {
                                if (viewModel.itemSelecionado!.ingredientesDisponiveis.isNotEmpty) {
                                  _showCustomizacaoModal(context, viewModel, viewModel.itemSelecionado!);
                                } else {
                                  viewModel.adicionarItem(
                                    viewModel.itemSelecionado!,
                                    viewModel.quantidade,
                                    null,
                                  );
                                  viewModel.limparItem();
                                  _qtdController.text = '1';
                                }
                              }
                            : null,
                        icon: const Icon(Icons.add),
                        label: const Text('Adicionar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryOrange,
                          minimumSize: const Size(double.infinity, 48),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // LISTA DE ITENS
                      if (viewModel.itens.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text('Nenhum item adicionado ainda.'),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: viewModel.itens.length,
                          itemBuilder: (context, index) {
                            final item = viewModel.itens[index];
                            return ListTile(
                              title: Text(item.nome),
                              subtitle: Text(item.resumo),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'R\$ ${item.subtotal.toStringAsFixed(2)}',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close, color: Colors.red),
                                    onPressed: () => viewModel.removerItem(item),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
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
                const SizedBox(height: 20),

                // 2. ONDE VAI CONSUMIR
                _buildSectionCard(
                  title: '2. Onde vai consumir?',
                  child: Row(
                    children: LocalConsumoEnum.values.map((loc) {
                      return Expanded(
                        child: ChoiceChip(
                          label: Text(loc.description),
                          selected: viewModel.localConsumo == loc,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                viewModel.localConsumo = loc;
                              });
                            }
                          },
                          selectedColor: AppTheme.primaryOrange,
                          labelStyle: TextStyle(
                            color: viewModel.localConsumo == loc ? Colors.white : Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),

                // 3. MESA OU CARRO
                if (viewModel.localConsumo != LocalConsumoEnum.entrega)
                  _buildSectionCard(
                    title: '3. Mesa ou Carro?',
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile<bool>(
                                title: const Text('Mesa'),
                                value: true,
                                groupValue: viewModel.isMesa,
                                onChanged: (value) => setState(() => viewModel.isMesa = value!),
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<bool>(
                                title: const Text('Carro'),
                                value: false,
                                groupValue: viewModel.isMesa,
                                onChanged: (value) => setState(() => viewModel.isMesa = value!),
                              ),
                            ),
                          ],
                        ),
                        TextField(
                          controller: _identificadorController,
                          decoration: InputDecoration(
                            labelText: viewModel.isMesa ? 'Número da Mesa' : 'Placa do Veículo',
                            border: const OutlineInputBorder(),
                          ),
                          onChanged: (value) => viewModel.identificador = value,
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 30),

                // SALVAR
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
                          final success = await viewModel.salvarPedido();
                          if (success && mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Pedido criado com sucesso!')),
                            );
                            context.go('/');
                          } else if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(viewModel.errorMessage ?? 'Erro ao salvar')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryOrange,
                          minimumSize: const Size(double.infinity, 54),
                        ),
                        child: const Text('Salvar Pedido'),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
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
}
