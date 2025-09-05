class QRCodeModel {
  final int? id;
  final String? color;
  final String? imageUrl;
  final String linkUrl;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  QRCodeModel({
    this.id,
    this.color,
    this.imageUrl,
    this.isActive,
    required this.linkUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory QRCodeModel.fromJson(Map<String, dynamic> json) {
    return QRCodeModel(
      id: json['id'],
      color: json['color'],
      imageUrl: json['image_url'],
      linkUrl: json['link_url'] ?? '',
      isActive: json['is_active'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'color': color,
      'image_url': imageUrl,
      'link_url': linkUrl,
      'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  /// Tạo bản sao với các giá trị mới
  QRCodeModel copyWith({
    int? id,
    String? color,
    String? imageUrl,
    String? linkUrl,
    DateTime? createdAt,
    bool? isActive,
    DateTime? updatedAt,
  }) {
    return QRCodeModel(
      id: id ?? this.id,
      color: color ?? this.color,
      imageUrl: imageUrl ?? this.imageUrl,
      linkUrl: linkUrl ?? this.linkUrl,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'QRCodeModel(id: $id, color: $color, linkUrl: $linkUrl, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QRCodeModel &&
        other.id == id &&
        other.color == color &&
        other.imageUrl == imageUrl &&
        other.linkUrl == linkUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^ color.hashCode ^ imageUrl.hashCode ^ linkUrl.hashCode;
  }
}
