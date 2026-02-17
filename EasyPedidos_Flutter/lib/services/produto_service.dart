import 'dart:convert';
import 'package:easy_pedidos_flutter/models/produto_model.dart';
import 'package:http/http.dart' as http;

class ProdutoService {
  final String apiUrl = 'http://localhost:3000/api/lanches';

  Future<List<ProdutoModel>> getProdutos() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => ProdutoModel.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar produtos');
      }
    } catch (e) {
      print('Erro ao buscar produtos da API: $e');
      // Fallback para mock se a API falhar (opcional, mas bom para robustez)
      return [
        ProdutoModel(
          id: '1',
          nome: 'X-Burger (Offline)',
          preco: 25.90,
          categoria: 'Lanches',
          ingredientes: ["Pão", "Hambúrguer", "Queijo"],
          ingredientesDisponiveis: ["Pão", "Hambúrguer", "Queijo", "Alface", "Tomate"]
        ),
      ];
    }
  }
}
