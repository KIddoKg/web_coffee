import 'package:flutter/foundation.dart';
import '../../screens/home/model/feedback_model.dart';
import 'services_supabase.dart';

class FeedbackService {
  static const String _tableName = 'feedback';

  /// Lấy tất cả feedback (với fallback cho is_active)
  static Future<List<FeedbackModel>> getAllFeedbacks(
      {bool isActive = true}) async {
    try {
      // Try with is_active first
      try {
        var query = SupabaseService.from(_tableName).select();

        if (isActive) {
          query = query.eq('is_active', true);
        }

        final response = await query.order('id', ascending: false);

        return response
            .map<FeedbackModel>((json) => FeedbackModel.fromJson(json))
            .toList();
      } catch (e) {
        debugPrint('Fallback: trying without is_active filter');
        // Fallback without is_active
        final response = await SupabaseService.from(_tableName)
            .select()
            .order('id', ascending: false);

        return response
            .map<FeedbackModel>((json) => FeedbackModel.fromJson(json))
            .toList();
      }
    } catch (e) {
      debugPrint('Lỗi lấy danh sách feedbacks: $e');
      rethrow;
    }
  }

  /// Lấy top feedbacks (rating cao)
  static Future<List<FeedbackModel>> getTopFeedbacks({int limit = 10}) async {
    try {
      final response = await SupabaseService.from(_tableName)
          .select()
          .order('id', ascending: false) // lấy feedback mới nhất
          .limit(limit);

      return response
          .map<FeedbackModel>((json) => FeedbackModel.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Lỗi lấy top feedbacks: $e');
      rethrow;
    }
  }


  /// Thêm feedback mới
  static Future<Map<String, dynamic>> addFeedback({
    required String title,
    required String reviewer,
    required DateTime date,
    String? comment,
    required double rating,
  }) async {
    try {
      final response = await SupabaseService.from(_tableName)
          .insert({
            'title': title,
            'reviewer': reviewer,
            'date': date.toIso8601String(),
            'comment': comment,
            'rating': rating,
          })
          .select()
          .single();

      debugPrint('Thêm feedback thành công: $title');
      return response;
    } catch (e) {
      debugPrint('Lỗi thêm feedback: $e');
      rethrow;
    }
  }

  /// Lấy tất cả feedback
  static Future<List<Map<String, dynamic>>> getAllFeedback() async {
    try {
      final response = await SupabaseService.from(_tableName)
          .select('*')
          .order('date', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Lỗi lấy danh sách feedback: $e');
      rethrow;
    }
  }

  /// Xóa feedback theo ID
  static Future<void> deleteFeedback(int feedbackId) async {
    try {
      await SupabaseService.from(_tableName).delete().eq('id', feedbackId);

      debugPrint('Xóa feedback thành công: ID $feedbackId');
    } catch (e) {
      debugPrint('Lỗi xóa feedback ID $feedbackId: $e');
      rethrow;
    }
  }

  /// Lấy feedback theo ID
  static Future<Map<String, dynamic>?> getFeedbackById(int feedbackId) async {
    try {
      final response = await SupabaseService.from(_tableName)
          .select('*')
          .eq('id', feedbackId)
          .maybeSingle();

      return response;
    } catch (e) {
      debugPrint('Lỗi lấy feedback theo ID $feedbackId: $e');
      rethrow;
    }
  }

  /// Lấy feedback theo rating (lọc theo điểm đánh giá)
  static Future<List<Map<String, dynamic>>> getFeedbackByRating({
    double? minRating,
    double? maxRating,
  }) async {
    try {
      var query = SupabaseService.from(_tableName).select('*');

      if (minRating != null) {
        query = query.gte('rating', minRating);
      }

      if (maxRating != null) {
        query = query.lte('rating', maxRating);
      }

      final response = await query.order('date', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Lỗi lấy feedback theo rating: $e');
      rethrow;
    }
  }

  /// Tính điểm trung bình của tất cả feedback
  static Future<double> getAverageRating() async {
    try {
      final feedbacks = await getAllFeedback();
      if (feedbacks.isEmpty) return 0.0;

      double totalRating = 0.0;
      for (final feedback in feedbacks) {
        totalRating += (feedback['rating'] as num?)?.toDouble() ?? 0.0;
      }

      return totalRating / feedbacks.length;
    } catch (e) {
      debugPrint('Lỗi tính điểm trung bình: $e');
      return 0.0;
    }
  }

  /// Convert từ Supabase data sang FeedbackModel
  static FeedbackModel fromSupabaseData(Map<String, dynamic> data) {
    return FeedbackModel(
      id: data['id'] ?? 0,
      title: data['title'] ?? '',
      reviewer: data['reviewer'] ?? '',
      date: data['date'] ?? '',
      comment: data['comment'] ?? '',
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Xóa tất cả feedback (dùng để reset database)
  static Future<void> clearAllFeedback() async {
    try {
      await SupabaseService.from(_tableName).delete().neq('id', 0);
      debugPrint('Đã xóa tất cả feedback');
    } catch (e) {
      debugPrint('Lỗi xóa tất cả feedback: $e');
      rethrow;
    }
  }
}
