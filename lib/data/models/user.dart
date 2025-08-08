class AppUser {
  final String id;
  final String email;
  final String? displayName;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? metadata;

  AppUser({
    required this.id,
    required this.email,
    this.displayName,
    this.avatarUrl,
    required this.createdAt,
    required this.updatedAt,
    this.metadata,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['display_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'display_name': displayName,
      'avatar_url': avatarUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  AppUser copyWith({
    String? id,
    String? email,
    String? displayName,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppUser && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class Rating {
  final String id;
  final String userId;
  final String toolId;
  final double rating;
  final String? review;
  final DateTime createdAt;
  final DateTime updatedAt;
  final AppUser? user;

  Rating({
    required this.id,
    required this.userId,
    required this.toolId,
    required this.rating,
    this.review,
    required this.createdAt,
    required this.updatedAt,
    this.user,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      toolId: json['tool_id'] as String,
      rating: (json['rating'] as num).toDouble(),
      review: json['review'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      user: json['users'] != null 
          ? AppUser.fromJson(json['users'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'tool_id': toolId,
      'rating': rating,
      'review': review,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Rating && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class Favorite {
  final String id;
  final String userId;
  final String toolId;
  final DateTime createdAt;

  Favorite({
    required this.id,
    required this.userId,
    required this.toolId,
    required this.createdAt,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      toolId: json['tool_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'tool_id': toolId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Favorite && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}