class FeedbackModel {
  final int? id;
  final String title;
  final String reviewer;
  final String date;
  final String comment;
  final double rating;

  FeedbackModel({
    this.id,
    required this.title,
    required this.reviewer,
    required this.date,
    required this.comment,
    required this.rating,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'],
      title: json['title'] ?? '',
      reviewer: json['reviewer'] ?? '',
      date: json['date'] ?? '',
      comment: json['comment'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'reviewer': reviewer,
      'date': date,
      'comment': comment,
      'rating': rating,
    };
  }
}
