import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // URL base da API
  final String baseUrl;

  ApiService({required this.baseUrl});

  // Função para registrar um usuário
  Future<Map<String, dynamic>> registerUser(Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Falha ao registrar usuário: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro na requisição de registro: $e');
    }
  }

  // Função para fazer login e obter o token JWT
  Future<Map<String, dynamic>> loginUser(Map<String, dynamic> loginData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/token/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(loginData),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Falha ao fazer login: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro na requisição de login: $e');
    }
  }

  // Função para atualizar um usuário
  Future<Map<String, dynamic>> updateUser(String userId, Map<String, dynamic> userData, String token) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/users/$userId/'),  // Ajuste na URL (assumindo que a URL é /users/{id}/)
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Inclui o token JWT
        },
        body: json.encode(userData),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Falha ao atualizar usuário: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro na requisição de atualização: $e');
    }
  }

  // Função para obter dados de um usuário
  Future<Map<String, dynamic>> getUser(String userId, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/$userId/'),  // Ajuste na URL (assumindo que a URL é /users/{id}/)
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Falha ao obter usuário: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro na requisição de obtenção: $e');
    }
  }
}

