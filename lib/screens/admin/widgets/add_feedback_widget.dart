import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xanh_coffee/share/app_imports.dart';
import 'package:xanh_coffee/share/size_configs.dart';
import '../../../services/supabase/feedback_service.dart';

class AddFeedbackWidget extends StatefulWidget {
  const AddFeedbackWidget({super.key});

  @override
  State<AddFeedbackWidget> createState() => _AddFeedbackWidgetState();
}

class _AddFeedbackWidgetState extends State<AddFeedbackWidget> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _reviewerController = TextEditingController();
  final _commentController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  double _rating = 5.0;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _titleController.dispose();
    _reviewerController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _showError(String message) {
    setState(() {
      _errorMessage = message;
    });

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

  Future<void> _saveFeedback() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await FeedbackService.addFeedback(
        title: _titleController.text.trim(),
        reviewer: _reviewerController.text.trim(),
        date: _selectedDate,
        comment: _commentController.text.trim().isEmpty
            ? null
            : _commentController.text.trim(),
        rating: _rating,
      );

      _showSuccess('Thêm feedback thành công!');
      _resetForm();
    } catch (e) {
      _showError('Lỗi thêm feedback: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _titleController.clear();
    _reviewerController.clear();
    _commentController.clear();
    setState(() {
      _selectedDate = DateTime.now();
      _rating = 5.0;
      _errorMessage = null;
    });
  }

  Widget _buildRatingStars() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Đánh giá: ${_rating.toStringAsFixed(1)}/5.0',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(5, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _rating = (index + 1).toDouble();
                });
              },
              child: Icon(
                index < _rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 32,
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Slider(
          value: _rating,
          min: 1.0,
          max: 5.0,
          divisions: 40, // Cho phép điều chỉnh với độ chính xác 0.1
          label: _rating.toStringAsFixed(1),
          onChanged: (value) {
            setState(() {
              _rating = value;
            });
          },
          activeColor: AppStyle.primaryGreen_0_81_49,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final width = SizeConfig.screenWidth!;
    final height = SizeConfig.screenHeight!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm Feedback'),
        backgroundColor: AppStyle.primaryGreen_0_81_49,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _resetForm,
            child: const Text(
              'Reset',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Padding(
          padding: AppStyle.padding_LR_16().copyWith(
              left: width < 1200 ? 0 : width * 0.15,
              right: width < 1200 ? 0 : width * 0.15),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Error message
                if (_errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
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
                      ],
                    ),
                  ),
          
                // Title
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Tiêu đề *',
                    hintText: 'Nhập tiêu đề feedback',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.title),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập tiêu đề';
                    }
                    if (value.trim().length < 3) {
                      return 'Tiêu đề phải có ít nhất 3 ký tự';
                    }
                    return null;
                  },
                ),
          
                const SizedBox(height: 16),
          
                // Reviewer
                TextFormField(
                  controller: _reviewerController,
                  decoration: const InputDecoration(
                    labelText: 'Người đánh giá *',
                    hintText: 'Nhập tên người đánh giá',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập tên người đánh giá';
                    }
                    if (value.trim().length < 2) {
                      return 'Tên phải có ít nhất 2 ký tự';
                    }
                    return null;
                  },
                ),
          
                const SizedBox(height: 16),
          
                // Date picker
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('Ngày đánh giá'),
                    subtitle: Text(
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _selectDate,
                  ),
                ),
          
                const SizedBox(height: 16),
          
                // Rating
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildRatingStars(),
                  ),
                ),
          
                const SizedBox(height: 16),
          
                // Comment
                TextFormField(
                  controller: _commentController,
                  decoration: const InputDecoration(
                    labelText: 'Nhận xét (Tùy chọn)',
                    hintText: 'Nhập nhận xét chi tiết...',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.comment),
                  ),
                  maxLines: 4,
                  maxLength: 500,
                ),
          
                const SizedBox(height: 24),
          
                // Save button
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveFeedback,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyle.primaryGreen_0_81_49,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: _isLoading
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            SizedBox(width: 12),
                            Text('Đang lưu...'),
                          ],
                        )
                      : const Text('Thêm Feedback'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
