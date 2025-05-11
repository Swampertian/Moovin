import 'immobile.dart';

class Owner {
  final int id;
  final String name;
  final String phone;
  final String city;
  final String state;
  final String aboutMe;
  final double revenueGenerated;
  final int rentedProperties;
  final int ratedByTenants;
  final int recommendedByTenants;
  final bool fastResponder;
  final double rating;
  final List<Immobile> properties;

  Owner({
    required this.id,
    required this.name,
    required this.phone,
    required this.city,
    required this.state,
    required this.aboutMe,
    required this.revenueGenerated,
    required this.rentedProperties,
    required this.ratedByTenants,
    required this.recommendedByTenants,
    required this.fastResponder,
    required this.rating,
    required this.properties,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic v) {
      if (v is num) return v.toDouble();
      if (v is String) return double.tryParse(v) ?? 0.0;
      return 0.0;
    }
    int parseInt(dynamic v) {
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v) ?? 0;
      return 0;
    }
    return Owner(
      id: parseInt(json['id']),
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      aboutMe: json['about_me'] as String? ?? '',
      revenueGenerated: parseDouble(json['revenue_generated']),
      rentedProperties: parseInt(json['rented_properties']),
      ratedByTenants: parseInt(json['rated_by_tenants']),
      recommendedByTenants: parseInt(json['recommended_by_tenants']),
      fastResponder: json['fast_responder'] as bool? ?? false,
      rating: double.tryParse(json['rating'].toString()) ?? 0.0,
      properties: (json['properties'] as List<dynamic>? ?? [])
          .map((e) => Immobile.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

  }
}

