
class Review {
  final int id; 
  final int authorId; 
  final int rating;
  final String comment;
  final String type; // 'TENANT', 'OWNER', 'PROPERTY'
  final DateTime createdAt;
  final int targetObjectId;
  final String targetContentType; // Para identificar o tipo do objeto alvo

  Review({
    required this.id,
    required this.authorId,
    required this.rating,
    required this.comment,
    required this.type,
    required this.createdAt,
    required this.targetObjectId,
    required this.targetContentType,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? 0, // Adicionando um fallback para null
      authorId: json['author'] ?? 0, 
      rating: json['rating'],
      comment: json['comment'] ?? '',
      type: json['type'],
      createdAt: DateTime.parse(json['created_at']),
      targetObjectId: json['object_id'],
      targetContentType: json['content_type_str'] ?? '', 
    );
  }

 
  Map<String, dynamic> toJson() {
    return {
      'author': authorId,
      'rating': rating,
      'comment': comment,
      'type': type,
      'object_id': targetObjectId,
      'content_type': targetContentType,
      // 'created_at': createdAt.toIso8601String(), // If you need to send this back
    };
  }
}