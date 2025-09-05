import 'package:flutter/material.dart';
import 'package:xanh_coffee/share/app_imports.dart';
import 'package:xanh_coffee/share/size_configs.dart';
import '../../../services/supabase/feedback_service.dart';
import 'add_feedback_widget.dart';

class FeedbackManagementWidget extends StatefulWidget {
  const FeedbackManagementWidget({super.key});

  @override
  State<FeedbackManagementWidget> createState() =>
      _FeedbackManagementWidgetState();
}

class _FeedbackManagementWidgetState extends State<FeedbackManagementWidget> {
  List<Map<String, dynamic>> _feedbacks = [];
  bool _isLoading = false;
  String? _errorMessage;
  double _averageRating = 0.0;
  String _selectedRatingFilter = 'Tất cả';

  final List<String> _ratingFilters = [
    'Tất cả',
    '5 sao',
    '4-5 sao',
    '3-4 sao',
    '1-3 sao',
  ];

  @override
  void initState() {
    super.initState();
    _loadFeedbacks();
    _loadAverageRating();
  }

  Future<void> _loadFeedbacks() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      List<Map<String, dynamic>> feedbacks;

      switch (_selectedRatingFilter) {
        case '5 sao':
          feedbacks = await FeedbackService.getFeedbackByRating(
            minRating: 5.0,
            maxRating: 5.0,
          );
          break;
        case '4-5 sao':
          feedbacks = await FeedbackService.getFeedbackByRating(
            minRating: 4.0,
            maxRating: 5.0,
          );
          break;
        case '3-4 sao':
          feedbacks = await FeedbackService.getFeedbackByRating(
            minRating: 3.0,
            maxRating: 3.99,
          );
          break;
        case '1-3 sao':
          feedbacks = await FeedbackService.getFeedbackByRating(
            minRating: 1.0,
            maxRating: 2.99,
          );
          break;
        default:
          feedbacks = await FeedbackService.getAllFeedback();
      }

      setState(() {
        _feedbacks = feedbacks;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi tải feedback: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadAverageRating() async {
    try {
      final average = await FeedbackService.getAverageRating();
      setState(() {
        _averageRating = average;
      });
    } catch (e) {
      debugPrint('Lỗi tải điểm trung bình: $e');
    }
  }

  Future<void> _deleteFeedback(int feedbackId, String title) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: Text(
              'Bạn có chắc chắn muốn xóa feedback "$title"?\n\nHành động này không thể hoàn tác!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        await FeedbackService.deleteFeedback(feedbackId);
        _showSuccess('Đã xóa feedback "$title"');
        _loadFeedbacks();
        _loadAverageRating();
      } catch (e) {
        _showError('Lỗi xóa feedback: $e');
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppStyle.primaryGreen_0_81_49,
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return const Icon(Icons.star, color: Colors.amber, size: 16);
        } else if (index < rating) {
          return const Icon(Icons.star_half, color: Colors.amber, size: 16);
        } else {
          return const Icon(Icons.star_border, color: Colors.amber, size: 16);
        }
      }),
    );
  }

  Color _getRatingColor(double rating) {
    if (rating >= 4.5) return Colors.green;
    if (rating >= 3.5) return Colors.orange;
    if (rating >= 2.5) return Colors.yellow[700]!;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final width = SizeConfig.screenWidth!;
    final height = SizeConfig.screenHeight!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý Feedback'),
        backgroundColor: AppStyle.primaryGreen_0_81_49,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _loadFeedbacks,
            icon: const Icon(Icons.refresh),
            tooltip: 'Tải lại',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push<bool>(
            MaterialPageRoute(
              builder: (context) => const AddFeedbackWidget(),
            ),
          );

          if (result == true) {
            _loadFeedbacks();
            _loadAverageRating();
          }
        },
        backgroundColor: AppStyle.primaryGreen_0_81_49,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: AppStyle.padding_LR_16().copyWith(
            left: width < 1200 ? 0 : width * 0.15,
            right: width < 1200 ? 0 : width * 0.15),
        child: Column(
          children: [
            // Statistics header
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey[50],
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            const Text(
                              'Điểm trung bình',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _averageRating.toStringAsFixed(1),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: _getRatingColor(_averageRating),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                _buildStarRating(_averageRating),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            const Text(
                              'Tổng feedback',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_feedbacks.length}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        
            // Filter
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text(
                    'Lọc theo đánh giá: ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButton<String>(
                      value: _selectedRatingFilter,
                      isExpanded: true,
                      items: _ratingFilters.map((filter) {
                        return DropdownMenuItem(
                          value: filter,
                          child: Text(filter),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedRatingFilter = value!;
                        });
                        _loadFeedbacks();
                      },
                    ),
                  ),
                ],
              ),
            ),
        
            // Error message
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  border: Border.all(color: Colors.red[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error, color: Colors.red[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red[800]),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _errorMessage = null;
                        });
                      },
                      icon: const Icon(Icons.close),
                      color: Colors.red[600],
                    ),
                  ],
                ),
              ),
        
            // Feedback list
            Expanded(
              child: _buildFeedbackList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackList() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Đang tải feedback...'),
          ],
        ),
      );
    }

    if (_feedbacks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.feedback_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _selectedRatingFilter == 'Tất cả'
                  ? 'Chưa có feedback nào'
                  : 'Chưa có feedback nào với mức đánh giá này',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(
                    builder: (context) => const AddFeedbackWidget(),
                  ),
                );

                if (result == true) {
                  _loadFeedbacks();
                  _loadAverageRating();
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Thêm feedback đầu tiên'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyle.primaryGreen_0_81_49,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _feedbacks.length,
      itemBuilder: (context, index) {
        final feedback = _feedbacks[index];
        return _buildFeedbackCard(feedback);
      },
    );
  }

  Widget _buildFeedbackCard(Map<String, dynamic> feedback) {
    final feedbackModel = FeedbackService.fromSupabaseData(feedback);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and rating
            Row(
              children: [
                Expanded(
                  child: Text(
                    feedbackModel.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                        _getRatingColor(feedbackModel.rating).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: _getRatingColor(feedbackModel.rating),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        feedbackModel.rating.toStringAsFixed(1),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _getRatingColor(feedbackModel.rating),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.star,
                        size: 16,
                        color: _getRatingColor(feedbackModel.rating),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Rating stars
            _buildStarRating(feedbackModel.rating),

            const SizedBox(height: 8),

            // Reviewer and date
            Row(
              children: [
                Icon(Icons.person, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  feedbackModel.reviewer,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${feedbackModel.date}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),

            // Comment
            if (feedbackModel.comment != null &&
                feedbackModel.comment!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Text(
                  feedbackModel.comment!,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],

            const SizedBox(height: 12),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'ID: ${feedbackModel.id}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => _deleteFeedback(
                    feedbackModel.id ?? 0,
                    feedbackModel.title,
                  ),
                  icon: const Icon(Icons.delete),
                  color: Colors.red[600],
                  tooltip: 'Xóa feedback',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
