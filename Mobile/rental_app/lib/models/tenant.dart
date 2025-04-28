class Tenant {
  final int id;
  final String name;
  final int age;
  final String job;
  final String city;
  final String state;
  final String aboutMe;
  final bool prefersStudio;
  final bool prefersApartment;
  final bool prefersSharedRent;
  final bool acceptsPets;
  final double userRating;
  final int propertiesRented;
  final int ratedByLandlords;
  final int recommendedByLandlords;
  final int favoritedProperties;
  final bool fastResponder;
  final String memberSince;

  Tenant({
    required this.id,
    required this.name,
    required this.age,
    required this.job,
    required this.city,
    required this.state,
    required this.aboutMe,
    required this.prefersStudio,
    required this.prefersApartment,
    required this.prefersSharedRent,
    required this.acceptsPets,
    required this.userRating,
    required this.propertiesRented,
    required this.ratedByLandlords,
    required this.recommendedByLandlords,
    required this.favoritedProperties,
    required this.fastResponder,
    required this.memberSince,
  });

  factory Tenant.fromJson(Map<String, dynamic> json) {
    return Tenant(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      job: json['job'],
      city: json['city'],
      state: json['state'],
      aboutMe: json['about_me'],
      prefersStudio: json['prefers_studio'],
      prefersApartment: json['prefers_apartment'],
      prefersSharedRent: json['prefers_shared_rent'],
      acceptsPets: json['accepts_pets'],
      userRating: json['user_rating'].toDouble(),
      propertiesRented: json['properties_rented'] ?? 0,
      ratedByLandlords: json['rated_by_landlords'] ?? 0,
      recommendedByLandlords: json['recommended_by_landlords'] ?? 0,
      favoritedProperties: json['favorited_properties'] ?? 0,
      fastResponder: json['fast_responder'] ?? false,
      memberSince: json['member_since'] ?? '',
    );
  }
}