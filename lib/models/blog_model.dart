class BlogModel {
  final int? id;
  final String title;
  final String mainDetail;
  final String? subDetail;
  final String? linkImg;
  final DateTime? createdAt;

  BlogModel({
    this.id,
    required this.title,
    required this.mainDetail,
    this.subDetail,
    this.linkImg,
    this.createdAt,
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    return BlogModel(
      id: json['id'],
      title: json['title'],
      mainDetail: json['main_detail'],
      subDetail: json['sub_detail'],
      linkImg: json['link_img'],
      createdAt: json['created_at'] != null 
        ? DateTime.parse(json['created_at'])
        : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'main_detail': mainDetail,
      'sub_detail': subDetail,
      'link_img': linkImg,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  BlogModel copyWith({
    int? id,
    String? title,
    String? mainDetail,
    String? subDetail,
    String? linkImg,
    DateTime? createdAt,
  }) {
    return BlogModel(
      id: id ?? this.id,
      title: title ?? this.title,
      mainDetail: mainDetail ?? this.mainDetail,
      subDetail: subDetail ?? this.subDetail,
      linkImg: linkImg ?? this.linkImg,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}