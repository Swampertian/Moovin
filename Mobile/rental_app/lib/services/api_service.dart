import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tenant.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api/tenants';

  Future<Tenant> fetchTenant(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/profile/$id/'));

    if (response.statusCode == 200) {
      return Tenant.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load tenant profile');
    }
  }
  
  Future<void> favoriteProperty(int tenantId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/profile/$tenantId/favorite_property/'),
    );
    
    if (response.statusCode != 200) {
      throw Exception('Failed to mark property as favorite');
    }
  }
}