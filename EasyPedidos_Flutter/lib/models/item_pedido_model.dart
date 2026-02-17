import 'package:equatable/equatable.dart';

class ItemPedidoModel extends Equatable {
  final int id;
  final String nome;
  final double preco;
  final int quantidade;
  final String observacao;
  final List<String> ingredientes;

  const ItemPedidoModel({
    required this.id,
    required this.nome,
    required this.preco,
    this.quantidade = 1,
    this.observacao = '',
    this.ingredientes = const [],
  });

  double get subtotal => preco * quantidade;

  String get resumo {
    String res = '${quantidade}x $nome';
    if (ingredientes.isNotEmpty) {
      res += ' (Com: ${ingredientes.join(", ")})';
    }
    if (observacao.isNotEmpty) {
      res += ' [Obs: $observacao]';
    }
    return res;
  }

  @override
  List<Object?> get props => [id, nome, preco, quantidade, observacao, ingredientes];

  ItemPedidoModel copyWith({
    int? id,
    String? nome,
    double? preco,
    int? quantidade,
    String? observacao,
    List<String>? ingredientes,
  }) {
    return ItemPedidoModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      preco: preco ?? this.preco,
      quantidade: quantidade ?? this.quantidade,
      observacao: observacao ?? this.observacao,
      ingredientes: ingredientes ?? this.ingredientes,
    );
  }
}
