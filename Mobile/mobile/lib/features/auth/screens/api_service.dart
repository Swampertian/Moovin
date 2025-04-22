import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {

  final String baseUrl;

  ApiService({required this.baseUrl});


  Future<Map<String, dynamic>> registerUser(Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/users/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('name', userData['name']);
        await prefs.setString('email', userData['email']);
        await prefs.setString('password', userData['password']);
        await prefs.setString('userType', userData['user_type']);

        return data;
      } else {
        throw Exception('Falha ao registrar usuário: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro na requisição de registro: $e');
    }
  }


  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/users/token'), 
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
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

  Future<Map<String, dynamic>> updateUser(String userId, Map<String, dynamic> userData, String token) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/users/$userId'),  // Ajuste na URL (assumindo que a URL é /users/{id}/)
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
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

  Future<Map<String, dynamic>> getUser(String userId, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/users/$userId/'),
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

