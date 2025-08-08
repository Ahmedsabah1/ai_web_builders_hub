class Tool {
  final String id;
  final String name;
  final String description;
  final String url;
  final String? imageUrl;
  final String categoryId;
  final Category? category;
  final double? rating;
  final int? ratingCount;
  final String? pricing;
  final String? skillLevel;
  final List<String>? features;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isFavorite;

  Tool({
    required this.id,
    required this.name,
    required this.description,
    required this.url,
    this.imageUrl,
    required this.categoryId,
    this.category,
    this.rating,
    this.ratingCount,
    this.pricing,
    this.skillLevel,
    this.features,
    required this.createdAt,
    required this.updatedAt,
    this.isFavorite = false,
  });

  factory Tool.fromJson(Map<String, dynamic> json) {
    return Tool(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      url: json['url'] as String,
      imageUrl: json['image_url'] as String?,
      categoryId: json['category_id'] as String,
      category: json['categories'] != null 
          ? Category.fromJson(json['categories'] as Map<String, dynamic>)
          : null,
      rating: (json['rating'] as num?)?.toDouble(),
      ratingCount: json['rating_count'] as int?,
      pricing: json['pricing'] as String?,
      skillLevel: json['skill_level'] as String?,
      features: json['features'] != null 
          ? List<String>.from(json['features'] as List)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      isFavorite: json['is_favorite'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'url': url,
      'image_url': imageUrl,
      'category_id': categoryId,
      'rating': rating,
      'rating_count': ratingCount,
      'pricing': pricing,
      'skill_level': skillLevel,
      'features': features,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_favorite': isFavorite,
    };
  }

  Tool copyWith({
    String? id,
    String? name,
    String? description,
    String? url,
    String? imageUrl,
    String? categoryId,
    Category? category,
    double? rating,
    int? ratingCount,
    String? pricing,
    String? skillLevel,
    List<String>? features,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFavorite,
  }) {
    return Tool(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      url: url ?? this.url,
      imageUrl: imageUrl ?? this.imageUrl,
      categoryId: categoryId ?? this.categoryId,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      pricing: pricing ?? this.pricing,
      skillLevel: skillLevel ?? this.skillLevel,
      features: features ?? this.features,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Tool && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class Category {
  final String id;
  final String name;
  final String? description;
  final String? color;
  final String? iconUrl;
  final int toolCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({
    required this.id,
    required this.name,
    this.description,
    this.color,
    this.iconUrl,
    this.toolCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      color: json['color'] as String?,
      iconUrl: json['icon_url'] as String?,
      toolCount: json['tool_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'color': color,
      'icon_url': iconUrl,
      'tool_count': toolCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Category && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}