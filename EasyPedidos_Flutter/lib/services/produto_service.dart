import 'package:easy_pedidos_flutter/models/produto_model.dart';

class ProdutoService {
  static final List<ProdutoModel> produtosMock = [
    ProdutoModel(id: '1', nome: 'Hambúrguer Simples', preco: 25.90, categoria: 'Lanches'),
    ProdutoModel(id: '2', nome: 'Hambúrguer Duplo', preco: 32.90, categoria: 'Lanches'),
    ProdutoModel(id: '3', nome: 'Batata Frita', preco: 15.90, categoria: 'Acompanhamentos'),
    ProdutoModel(id: '4', nome: 'Refrigerante Lata', preco: 6.90, categoria: 'Bebidas'),
    ProdutoModel(id: '5', nome: 'Suco Natural', preco: 8.90, categoria: 'Bebidas'),
    ProdutoModel(id: '6', nome: 'Sorvete', preco: 12.90, categoria: 'Sobremesas'),
  ];

  Future<List<ProdutoModel>> getProdutos() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return produtosMock;
  }
}
