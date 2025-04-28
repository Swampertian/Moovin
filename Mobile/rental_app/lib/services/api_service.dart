import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tenant.dart';
import '../models/owner.dart';
import '../config.dart';

class ApiService {
  final String _tenantBase = '$apiBase/tenants';
  final String _ownerBase = '$apiBase/owners/owners';
  final String _immobileBase = '$apiBase/immobile';

  // ========================= TENANT =========================

  Future<Tenant> fetchTenant(int id) async {
    final url = Uri.parse('$_tenantBase/profile/$id/');
    print('🔎 Fetching Tenant: $url');

    final response = await http.get(url);

    print('📡 STATUS: ${response.statusCode}');
    print('📦 BODY: ${response.body}');

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      return Tenant.fromJson(jsonDecode(decodedBody));
    } else {
      throw Exception('Failed to load tenant profile');
    }
  }

  Future<Tenant> updateTenant(int id, Map<String, dynamic> data) async {
    final url = Uri.parse('$_tenantBase/profile/$id/update-profile/');
    print('✏️ Updating Tenant: $url');

    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(data),
    );

    print('📡 STATUS: ${response.statusCode}');
    print('📦 BODY: ${response.body}');

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      return Tenant.fromJson(jsonDecode(decodedBody));
    } else {
      throw Exception('Failed to update tenant profile');
    }
  }

  Future<void> favoriteProperty(int tenantId) async {
    final url = Uri.parse('$_tenantBase/profile/$tenantId/favorite_property/');
    print('⭐ Favoriting property for Tenant: $url');

    final response = await http.post(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to mark property as favorite');
    }
  }

  // ========================= OWNER =========================

  Future<Owner> fetchOwner(int id) async {
    final url = Uri.parse('$_ownerBase/$id/');
    print('🔎 Fetching Owner: $url');

    final response = await http.get(url);

    print('📡 STATUS: ${response.statusCode}');
    print('📦 BODY: ${response.body}');

    if (response.statusCode == 200) {
      return Owner.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load owner profile');
    }
  }

  Future<Owner> updateOwner(int id, Map<String, dynamic> data) async {
    final url = Uri.parse('$_ownerBase/$id/');
    print('✏️ Updating Owner: $url');

    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(data),
    );

    print('📡 STATUS: ${response.statusCode}');
    print('📦 BODY: ${response.body}');

    if (response.statusCode == 200) {
      return Owner.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update owner profile');
    }
  }

  // ========================= IMMOBILE =========================

  Future<void> updateImmobile(int id, Map<String, dynamic> data) async {
    final url = Uri.parse('$_immobileBase/$id/');
    print('✏️ Updating Immobile: $url');

    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(data),
    );

    print('📡 STATUS: ${response.statusCode}');
    print('📦 BODY: ${response.body}');

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to update immobile');
    }
  }
}
