import 'package:equatable/equatable.dart';

class ItemPedidoModel extends Equatable {
  final int id;
  final String nome;
  final double preco;
  final int quantidade;
  final String observacao;

  const ItemPedidoModel({
    required this.id,
    required this.nome,
    required this.preco,
    this.quantidade = 1,
    this.observacao = '',
  });

  double get subtotal => preco * quantidade;

  String get resumo =>
      '${quantidade}x $nome ${observacao.isEmpty ? "" : "($observacao)"}';

  @override
  List<Object?> get props => [id, nome, preco, quantidade, observacao];

  ItemPedidoModel copyWith({
    int? id,
    String? nome,
    double? preco,
    int? quantidade,
    String? observacao,
  }) {
    return ItemPedidoModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      preco: preco ?? this.preco,
      quantidade: quantidade ?? this.quantidade,
      observacao: observacao ?? this.observacao,
    );
  }
}
