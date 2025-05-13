import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tenant.dart';
import '../models/owner.dart';
import '../config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/immobile.dart';
import '../models/review.dart';
class ApiService {
  final String _tenantBase = '$apiBase/tenants';
  final String _ownerBase = '$apiBase/owners/owners';
  final String _immobileBase = '$apiBase/immobile';
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final String _photoBlobBase = '$apiBase/photo/blob'; 
  final String _reviewBase = '$apiBase/reviews';
  // ========================= TENANT =========================

  Future<Tenant> fetchTenant() async {
    final url = Uri.parse('$_tenantBase/profile/me/');
    print('🔎 Fetching Tenant: $url');

    final token = await _secureStorage.read(key: 'jwt_token');

    if (token == null) {
      throw Exception('Token JWT não encontrado.');
    }

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('📡 STATUS: ${response.statusCode}');
    print('📦 BODY: ${response.body}');

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      return Tenant.fromJson(jsonDecode(decodedBody));
    } else {
      throw Exception('Failed to load tenant profile');
    }
  }

  Future<Tenant> updateTenant(Map<String, dynamic> data) async {
    final url = Uri.parse('$_tenantBase/profile/me/update-profile/');
    print('✏️ Updating Tenant: $url');

    final token = await _secureStorage.read(key: 'jwt_token');

    if (token == null) {
      throw Exception('Token JWT não encontrado.');
    }

    final response = await http.patch(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
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
  Future<Immobile> fetchOneImmobile(int id_immobile) async {
    final url = Uri.parse('$_immobileBase/$id_immobile/'); //
    print('🔎 Fetching Immobile: $url');

    final response = await http.get(url);

    print('📡 STATUS: ${response.statusCode}');
    print('📦 IMMOBILE BODY: ${response.body}');

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      return Immobile.fromJson(jsonDecode(decodedBody));
    } else if (response.statusCode == 404) {
      throw Exception('Immobile not found');
    } else {
      throw Exception('Failed to load immobile details');
    }
  }

 Future<Map<String, dynamic>> fetchImageBlob(int photoId) async {
    final url = Uri.parse('$_photoBlobBase/$photoId/');
    print('🔎 Fetching Image Blob: $url');

    final response = await http.get(url);

    print('📡 STATUS: ${response.statusCode}');
    print('📦 IMAGE BLOB BODY: ${response.body}');

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      return jsonDecode(decodedBody);
    } else {
      throw Exception('Failed to load image blob for photo ID: $photoId');
    }
  }

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

  Future<List<Immobile>> fetchImmobile({
  String? type,
  int? bedrooms,
  int? bathrooms,
  int? garage,
  int? rentValue,
  int? areaSize,
  int? distance,
  DateTime? date,
  bool? wifi,
  bool? airConditioning,
  bool? petFriendly,
  bool? furnished,
  bool? pool,
  String? city,
}) async {
  final queryParams = <String, String>{
    if (type != null) 'type': type,
    if (bedrooms != null) 'bedrooms': bedrooms.toString(),
    if (bathrooms != null) 'bathrooms': bathrooms.toString(),
    if (garage != null) 'garage': garage.toString(),
    if (rentValue != null) 'rentValue': rentValue.toString(),
    if (areaSize != null) 'areaSize': areaSize.toString(),
    if (distance != null) 'distance': distance.toString(),
    if (date != null) 'date': date.toIso8601String(),
    if (wifi != null) 'wifi': wifi.toString(),
    if (airConditioning != null) 'airConditioning': airConditioning.toString(),
    if (petFriendly != null) 'petFriendly': petFriendly.toString(),
    if (furnished != null) 'furnished': furnished.toString(),
    if (pool != null) 'pool': pool.toString(),
    if (city!= null) 'city': city,
  };

  final uri = Uri.parse('$immobileBase').replace(queryParameters: queryParams);

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final String decodedBody = utf8.decode(response.bodyBytes); 
    final List<dynamic> data = jsonDecode(decodedBody);
    return data.map((item) => Immobile.fromJson(item)).toList();
  } else {
    throw Exception('Erro ao buscar imóveis');
  }

}
//====== reviews
Future<List<Review>> fetchReviews({required String type, required int targetId}) async {
  final url = Uri.parse('$_reviewBase/reviews/$targetId/');
  print('🔎 Fetching Reviews: $url');

  final response = await http.get(url);

  print('📡 STATUS: ${response.statusCode}');
  print('📦 BODY: ${response.body}');

  if (response.statusCode == 200) {
    final decodedBody = utf8.decode(response.bodyBytes);
    final Map<String, dynamic> jsonMap = jsonDecode(decodedBody) as Map<String, dynamic>;
    return [Review.fromJson(jsonMap)]; // Retorna uma lista sempre
  } else {
    throw Exception('Failed to load reviews');
  }
}

  Future<Review> submitReview({
    required int rating,
    String? comment,
    required String type,
    required int targetId,
    required int authorId,
  }) async {
    final url = Uri.parse('$_reviewBase/reviews/');
    print('📝 Submitting Review: $url');

    final Map<String, dynamic> body = {
      'rating': rating,
      'comment': comment,
      'type': type,
      'object_id': targetId,
      'author': authorId,
    };

    print('📤 Sending Body: ${jsonEncode(body)}');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    print('📡 STATUS: ${response.statusCode}');
    print('📦 BODY: ${response.body}');

    if (response.statusCode == 201) {
      final decodedBody = utf8.decode(response.bodyBytes);
      return Review.fromJson(jsonDecode(decodedBody));
    } else {
      throw Exception('Failed to submit review');
    }
  }
   Future<Map<String, dynamic>> fetchTargetDetails({required String type, required int id}) async {
    Uri? url;
    String baseUrl;

    if (type == 'TENANT') {
      baseUrl = '$apiBase/tenants';
      url = Uri.parse('$baseUrl/$id/');
    } else if (type == 'OWNER') {
      baseUrl = '$apiBase/owners'; // Ajuste se a URL base for diferente
      url = Uri.parse('$baseUrl/$id/');
    } else if (type == 'PROPERTY') {
      baseUrl = '$apiBase/immobile'; // Ajuste se a URL base for diferente
      url = Uri.parse('$baseUrl/$id/');
    }

    if (url == null) {
      print('Tipo de objeto inválido para buscar detalhes.');
      return {};
    }

    print('🔎 Fetching Target Details: $url');

    try {
      final response = await http.get(url);
      print('📡 Target Details STATUS: ${response.statusCode}');
      print('📦 Target Details BODY: ${response.body}');

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        return jsonDecode(decodedBody) as Map<String, dynamic>;
      } else {
        print('Falha ao carregar os detalhes do objeto: ${response.statusCode}');
        return {};
      }
    } catch (e) {
      print('Erro de conexão ao carregar os detalhes do objeto: $e');
      return {};
    }
  }

}
