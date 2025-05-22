import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tenant.dart';
import '../models/owner.dart';
import '../config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/immobile.dart';
import 'package:dio/dio.dart';

class ApiService {
  final String _tenantBase = '$apiBase/tenants';
  final String _ownerBase = '$apiBase/owners/owners';
  final String _immobileBase = '$apiBase/immobile';
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final String _photoBlobBase = '$apiBase/photo/blob'; 
  late Dio dio;



  ApiService() {
    dio = Dio(BaseOptions(
      baseUrl: 'http://127.0.0.1:8000/api', 
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        String? accessToken = await _secureStorage.read(key: 'access_token');
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          final refreshed = await _refreshToken();

          if (refreshed) {
            final newToken = await _secureStorage.read(key: 'access_token');
            e.requestOptions.headers['Authorization'] = 'Bearer $newToken';

            try {
              final retryResponse = await dio.fetch(e.requestOptions);
              return handler.resolve(retryResponse);
            } catch (e) {
              return handler.reject(e as DioException);
            }
          }
        }

        return handler.next(e);
      },
    ));
  }

  Future<bool> _refreshToken() async {
    final refresh = await _secureStorage.read(key: 'refresh_token');
    if (refresh == null) return false;

    try {
      final response = await dio.post('/users/token/refresh/', data: {'refresh': refresh});
      if (response.statusCode == 200) {
        await _secureStorage.write(key: 'access_token', value: response.data['access']);
        return true;
      }
    } catch (e) {
      print('Erro ao renovar token: $e');
    }

    return false;
  }


  // ========================= TENANT =========================

  Future<Tenant> fetchTenant() async {
  final url = '$_tenantBase/profile/me/'; 

  print('🔎 Fetching Tenant: $url');

  try {
    final response = await dio.get(url); // token será adicionado pelo interceptor

    print('📡 STATUS: ${response.statusCode}');
    print('📦 BODY: ${response.data}');

    if (response.statusCode == 200) {
      return Tenant.fromJson(response.data); // Já vem decodificado em JSON
    } else {
      throw Exception('Erro ao carregar perfil do tenant');
    }
  } on DioException catch (e) {
    print('❌ Erro na requisição: ${e.response?.data}');
    throw Exception('Erro na requisição: ${e.message}');
  }
  }


  Future<Tenant> updateTenant(Map<String, dynamic> data) async {
  final url = '$_tenantBase/profile/me/update-profile/';
  print('✏️ Updating Tenant: $url');

  try {
    final response = await dio.patch(
      url,
      data: data, 
    );

    print('📡 STATUS: ${response.statusCode}');
    print('📦 BODY: ${response.data}');

    if (response.statusCode == 200) {
      return Tenant.fromJson(response.data); 
    } else {
      throw Exception('Erro ao atualizar o perfil do tenant');
    }
  } on DioException catch (e) {
    print('❌ Erro na requisição: ${e.response?.data}');
    throw Exception('Erro na requisição: ${e.message}');
  }
}


  Future<void> favoriteProperty(int tenantId) async {
  final url = '$_tenantBase/profile/$tenantId/favorite_property/';
  print('⭐ Favoriting property for Tenant: $url');

  try {
    final response = await dio.post(url); 

    print('📡 STATUS: ${response.statusCode}');
    print('📦 BODY: ${response.data}');

    if (response.statusCode != 200) {
      throw Exception('Erro ao favoritar o imóvel');
    }
  } on DioException catch (e) {
    print('❌ Erro na requisição: ${e.response?.data}');
    throw Exception('Erro ao favoritar o imóvel: ${e.message}');
  }
}


  // ========================= OWNER =========================

  Future<Owner> fetchOwner(int id) async {
    final url = '$_ownerBase/$id/';
    print('🔎 Fetching Owner: $url');

    final response = await dio.get(url);

    print('📡 STATUS: ${response.statusCode}');
    print('📦 BODY: ${response.data}');

    if (response.statusCode == 200) {
      return Owner.fromJson(response.data);
    } else {
      throw Exception('Failed to load owner profile');
    }
  }

  Future<Owner> updateOwner(int id, Map<String, dynamic> data) async {
    final url = '$_ownerBase/$id/';
    print('✏️ Updating Owner: $url');

    final response = await dio.patch(
      url,
      data: data,
    );

    print('📡 STATUS: ${response.statusCode}');
    print('📦 BODY: ${response.data}');

    if (response.statusCode == 200) {
      return Owner.fromJson(response.data);
    } else {
      throw Exception('Failed to update owner profile');
    }
  }

  // ========================= IMMOBILE =========================
 Future<Immobile> fetchOneImmobile(int idImmobile) async {
  final url = '$_immobileBase/$idImmobile/';
  print('🔎 Fetching Immobile: $url');

  try {
    final response = await dio.get(url);

    print('📡 STATUS: ${response.statusCode}');
    print('📦 IMMOBILE BODY: ${response.data}');

    if (response.statusCode == 200) {
      return Immobile.fromJson(response.data);
    } else if (response.statusCode == 404) {
      throw Exception('Imóvel não encontrado');
    } else {
      throw Exception('Erro ao carregar os detalhes do imóvel');
    }
  } on DioException catch (e) {
    print('❌ Erro na requisição: ${e.response?.data}');
    throw Exception('Erro na requisição: ${e.message}');
  }
}


Future<ImmobilePhoto> fetchImageBlob(int photoId) async {
  final url = '$_photoBlobBase/$photoId/';
  print('🔎 Fetching Image Blob: $url');

  try {
    final response = await dio.get(url);

    print('📡 STATUS: ${response.statusCode}');
    print('📦 IMAGE BLOB BODY: ${response.data}');

    if (response.statusCode == 200) {
      return ImmobilePhoto.fromJson(response.data);
    } else if (response.statusCode == 404) {
      throw Exception('Foto não encontrada');
    } else {
      throw Exception('Erro ao carregar blob da imagem com ID $photoId');
    }
  } on DioException catch (e) {
    print('❌ Erro na requisição: ${e.response?.data}');
    throw Exception('Erro na requisição: ${e.message}');
  }
}



  Future<void> updateImmobile(int id, Map<String, dynamic> data) async {
  final url = '$_immobileBase/$id/';
  print('✏️ Updating Immobile: $url');

  try {
    final response = await dio.patch(
      url,
      data: data, // Dio já serializa JSON automaticamente
      options: Options(
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      ),
    );

    print('📡 STATUS: ${response.statusCode}');
    print('📦 BODY: ${response.data}');

    if (response.statusCode == null || response.statusCode! < 200 || response.statusCode! >= 300) {
      throw Exception('Failed to update immobile');
    }
  } on DioException catch (e) {
    print('❌ Erro ao atualizar imóvel: ${e.response?.data}');
    throw Exception('Erro na requisição: ${e.message}');
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
  final queryParams = <String, dynamic>{
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
    if (city != null) 'city': city,
  };

  final uri = Uri.parse(_immobileBase).replace(queryParameters: queryParams);
  print('🔎 Fetching Immobiles: $uri');

  try {
    final response = await dio.getUri(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((item) => Immobile.fromJson(item)).toList();
    } else {
      throw Exception('Erro ao buscar imóveis');
    }
  } on DioException catch (e) {
    print('❌ Erro ao buscar imóveis: ${e.response?.data}');
    throw Exception('Erro na requisição: ${e.message}');
  }
}

}