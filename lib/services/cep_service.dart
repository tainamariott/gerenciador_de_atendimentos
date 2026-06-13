import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/cep.dart';

class CepService {
  static const _baseUrl = 'https://viacep.com.br/ws';

  Future<Cep> buscarCep(String cep) async {
    final cepLimpo = cep.replaceAll(RegExp(r'[^0-9]'), '');
    if (cepLimpo.length != 8) {
      throw Exception('CEP deve ter 8 dígitos');
    }

    final response = await http.get(Uri.parse('$_baseUrl/$cepLimpo/json/'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data.containsKey('erro')) {
        throw Exception('CEP não encontrado');
      }
      return Cep.fromMap(data);
    } else {
      throw Exception('Erro ao buscar CEP: ${response.statusCode}');
    }
  }
}
