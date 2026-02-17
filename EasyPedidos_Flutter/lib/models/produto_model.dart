class ProdutoModel {
  final String id;
  final String nome;
  final double preco;
  final String? categoria;
  final bool disponivel;
  final List<String> ingredientes;
  final List<String> ingredientesDisponiveis;

  ProdutoModel({
    required this.id,
    required this.nome,
    required this.preco,
    this.categoria,
    this.disponivel = true,
    this.ingredientes = const [],
    this.ingredientesDisponiveis = const [],
  });

  String get descricao => '$nome - R$ ${preco.toStringAsFixed(2)}';

  factory ProdutoModel.fromJson(Map<String, dynamic> json) {
    return ProdutoModel(
      id: json['id'],
      nome: json['nome'],
      preco: (json['preco'] as num).toDouble(),
      categoria: json['categoria'] ?? 'Lanches',
      disponivel: json['disponivel'] ?? true,
      ingredientes: List<String>.from(json['ingredientes'] ?? []),
      ingredientesDisponiveis: List<String>.from(json['ingredientesDisponiveis'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'preco': preco,
      'categoria': categoria,
      'disponivel': disponivel,
      'ingredientes': ingredientes,
      'ingredientesDisponiveis': ingredientesDisponiveis,
    };
  }
}
