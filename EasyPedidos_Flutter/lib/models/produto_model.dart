class ProdutoModel {
  final String id;
  final String nome;
  final double preco;
  final String? categoria;
  final bool disponivel;

  ProdutoModel({
    required this.id,
    required this.nome,
    required this.preco,
    this.categoria,
    this.disponivel = true,
  });

  String get descricao => '$nome - R$ ${preco.toStringAsFixed(2)}';
}
