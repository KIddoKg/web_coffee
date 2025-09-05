import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../services/supabase/blog_service.dart';
import '../../../models/blog_model.dart';

class AddBlogWidget extends StatefulWidget {
  final Function()? onBlogAdded;

  const AddBlogWidget({
    Key? key,
    this.onBlogAdded,
  }) : super(key: key);

  @override
  State<AddBlogWidget> createState() => _AddBlogWidgetState();
}

class _AddBlogWidgetState extends State<AddBlogWidget> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _mainDetailController = TextEditingController();
  final _subDetailController = TextEditingController();
  final BlogService _blogService = BlogService();
  final ImagePicker _imagePicker = ImagePicker();

  File? _selectedImage;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _mainDetailController.dispose();
    _subDetailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image: $e');
    }
  }

  Future<void> _addBlog() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _blogService.addBlog(
        title: _titleController.text.trim(),
        mainDetail: _mainDetailController.text.trim(),
        subDetail: _subDetailController.text.trim().isEmpty 
            ? null 
            : _subDetailController.text.trim(),
        imageFile: _selectedImage,
      );

      _showSuccessSnackBar('Blog added successfully!');
      _clearForm();
      
      if (widget.onBlogAdded != null) {
        widget.onBlogAdded!();
      }
    } catch (e) {
      _showErrorSnackBar('Failed to add blog: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearForm() {
    _titleController.clear();
    _mainDetailController.clear();
    _subDetailController.clear();
    setState(() {
      _selectedImage = null;
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add New Blog Post',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Title field
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Main detail field
              TextFormField(
                controller: _mainDetailController,
                decoration: const InputDecoration(
                  labelText: 'Main Detail *',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Main detail is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Sub detail field
              TextFormField(
                controller: _subDetailController,
                decoration: const InputDecoration(
                  labelText: 'Sub Detail (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              
              // Image upload section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Image',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  if (_selectedImage != null) ...[
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.image),
                        label: Text(_selectedImage == null ? 'Select Image' : 'Change Image'),
                      ),
                      if (_selectedImage != null) ...[
                        const SizedBox(width: 8),
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              _selectedImage = null;
                            });
                          },
                          icon: const Icon(Icons.delete),
                          label: const Text('Remove'),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Action buttons
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _isLoading ? null : _addBlog,
                    child: _isLoading
                        ? const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                              SizedBox(width: 8),
                              Text('Adding...'),
                            ],
                          )
                        : const Text('Add Blog'),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton(
                    onPressed: _isLoading ? null : _clearForm,
                    child: const Text('Clear'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}