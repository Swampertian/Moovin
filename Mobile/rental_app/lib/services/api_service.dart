import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tenant.dart';
import '../models/owner.dart';
import '../config.dart';

class ApiService {
  final String _base = apiBase;

  Future<Tenant> fetchTenant(int id) async {
    final url = Uri.parse('$_base/$id/');
    print('Chamando: $url');

    final response = await http.get(url);

    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode == 200) {
      return Tenant.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load tenant profile');
    }
  }
  Future<Owner> fetchOwner(int id) async {
    final url = Uri.parse('$ownerBase/$id/');
    print('Chamando: $url');

    final response = await http.get(url);

    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode == 200) {
      return Owner.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load owner profile');
    }
  }

  Future<void> favoriteProperty(int tenantId) async {
    final response = await http.post(
      Uri.parse('$_base/$tenantId/favorite_property/'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to mark property as favorite');
    }
  }
  Future<Owner> updateOwner(int id, Map<String, dynamic> data) async {
    final response = await http.patch(
      Uri.parse('$ownerBase/$id/'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return Owner.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update owner profile');
    }
  }
  Future<void> updateImmobile(int id, Map<String, dynamic> data) async {
    final url = Uri.parse('$immobileBase/$id/');  // << note o "s" e a barra final
    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(data),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      // DEBUG:
      print('=== ERRO UPDATE IMMOBILE ===');
      print('URL: $url');
      print('STATUS: ${response.statusCode}');
      print('BODY: ${response.body}');
      throw Exception('Falha ao atualizar imóvel');
    }
  }

}
