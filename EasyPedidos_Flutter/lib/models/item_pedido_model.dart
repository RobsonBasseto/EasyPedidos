import 'package:equatable/equatable.dart';

class ItemPedidoModel extends Equatable {
  final String id; // Matches ProdutoModel.id (String)
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

  factory ItemPedidoModel.fromJson(Map<String, dynamic> json) {
    return ItemPedidoModel(
      id: json['id'].toString(),
      nome: json['nome'],
      preco: (json['preco'] as num).toDouble(),
      quantidade: json['quantidade'] ?? 1,
      observacao: json['observacao'] ?? '',
      ingredientes: List<String>.from(json['ingredientes'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'preco': preco,
      'quantidade': quantidade,
      'observacao': observacao,
      'ingredientes': ingredientes,
    };
  }

  @override
  List<Object?> get props => [id, nome, preco, quantidade, observacao, ingredientes];

  ItemPedidoModel copyWith({
    String? id,
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
