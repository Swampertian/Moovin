import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tenant.dart';
import '../config.dart';

class ApiService {
  final String _base = baseUrl;

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

  Future<void> favoriteProperty(int tenantId) async {
    final response = await http.post(
      Uri.parse('$_base/$tenantId/favorite_property/'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to mark property as favorite');
    }
  }
}
