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

class Immobile {
  final int idImmobile;
  final String propertyType;
  final String zipCode;
  final String state;
  final String city;
  final String street;
  final String? number;
  final bool noNumber;
  final int bedrooms;
  final int bathrooms;
  final double area;
  final double rent;
  final bool airConditioning;
  final bool garage;
  final bool pool;
  final bool furnished;
  final bool petFriendly;
  final bool nearbyMarket;
  final bool nearbyBus;
  final bool internet;
  final String description;
  final String? additionalRules;
  final String status;
  final String createdAt;
  final String? imageUrl;

  Immobile({
    required this.idImmobile,
    required this.propertyType,
    required this.zipCode,
    required this.state,
    required this.city,
    required this.street,
    this.number,
    required this.noNumber,
    required this.bedrooms,
    required this.bathrooms,
    required this.area,
    required this.rent,
    required this.airConditioning,
    required this.garage,
    required this.pool,
    required this.furnished,
    required this.petFriendly,
    required this.nearbyMarket,
    required this.nearbyBus,
    required this.internet,
    required this.description,
    this.additionalRules,
    required this.status,
    required this.createdAt,
    this.imageUrl,
  });

  factory Immobile.fromJson(Map<String, dynamic> json) {
    // Helper para converter num ou string em double
    double parseDouble(dynamic v) {
      if (v is num) return v.toDouble();
      if (v is String) return double.tryParse(v) ?? 0.0;
      return 0.0;
    }
    // Helper para converter num ou string em int
    int parseInt(dynamic v) {
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v) ?? 0;
      return 0;
    }

    return Immobile(
      idImmobile: parseInt(json['id_immobile']),
      propertyType: json['property_type'] as String,
      zipCode:json['zip_code'] as String ?? '',
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      street: json['street'] as String? ?? '',
      number: json['number'] as String?,
      noNumber: json['no_number'] as bool? ?? false,
      bedrooms: parseInt(json['bedrooms']),
      bathrooms: parseInt(json['bathrooms']),
      area: parseDouble(json['area']),
      rent: parseDouble(json['rent']),
      airConditioning: json['air_conditioning'],
      garage: json['garage'],
      pool: json['pool'],
      furnished: json['furnished'],
      petFriendly: json['pet_friendly'],
      nearbyMarket: json['nearby_market'],
      nearbyBus: json['nearby_bus'],
      internet: json['internet'],
      description: json['description'],
      additionalRules: json['additional_rules'],
      status: json['status'],
      createdAt: json['created_at'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_immobile': idImmobile,
      'property_type': propertyType,
      'zip_code': zipCode,
      'state': state,
      'city': city,
      'street': street,
      'number': number,
      'no_number': noNumber,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'area': area,
      'rent': rent,
      'air_conditioning': airConditioning,
      'garage': garage,
      'pool': pool,
      'furnished': furnished,
      'pet_friendly': petFriendly,
      'nearby_market': nearbyMarket,
      'nearby_bus': nearbyBus,
      'internet': internet,
      'description': description,
      'additional_rules': additionalRules,
      'status': status,
      'created_at': createdAt,
      'imageUrl': imageUrl,
    };
  }
}
