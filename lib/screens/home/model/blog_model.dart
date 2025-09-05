class BlogModel {
  final int? id;
  final String title;
  final String mainDetail;
  final String? subDetail;
  final String? linkImg;
  final int order;
  final String? titleEn;
  final String? mainDetailEn;
  final String? subDetailEn;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BlogModel({
    this.id,
    required this.title,
    required this.mainDetail,
    this.subDetail,
    this.linkImg,
    this.order = 0,
    this.titleEn,
    this.mainDetailEn,
    this.subDetailEn,
    this.createdAt,
    this.updatedAt,
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    return BlogModel(
      id: json['id'],
      title: json['title'] ?? '',
      mainDetail: json['main_detail'] ?? '',
      subDetail: json['sub_detail'],
      linkImg: json['link_img'],
      order: json['order'] ?? 0,
      titleEn: json['title_en'],
      mainDetailEn: json['main_detail_en'],
      subDetailEn: json['sub_detail_en'],
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
      'title': title,
      'main_detail': mainDetail,
      'sub_detail': subDetail,
      'link_img': linkImg,
      'order': order,
      'title_en': titleEn,
      'main_detail_en': mainDetailEn,
      'sub_detail_en': subDetailEn,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  /// Get localized title based on language
  String getTitle(String languageCode) {
    if (languageCode == 'en' && titleEn != null && titleEn!.isNotEmpty) {
      return titleEn!;
    }
    return title;
  }

  /// Get localized main detail based on language
  String getMainDetail(String languageCode) {
    if (languageCode == 'en' &&
        mainDetailEn != null &&
        mainDetailEn!.isNotEmpty) {
      return mainDetailEn!;
    }
    return mainDetail;
  }

  /// Get localized sub detail based on language
  String? getSubDetail(String languageCode) {
    if (languageCode == 'en' &&
        subDetailEn != null &&
        subDetailEn!.isNotEmpty) {
      return subDetailEn;
    }
    return subDetail;
  }
}
