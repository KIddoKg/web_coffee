import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/blog_model.dart';
import 'supabase_service.dart';

class BlogService {
  SupabaseClient get _supabase => SupabaseService.instance.client;

  // Get all blogs sorted by id (descending for newest first)
  Future<List<BlogModel>> getAllBlogs() async {
    try {
      final response = await _supabase
          .from('blog')
          .select()
          .order('id', ascending: false);

      return (response as List)
          .map((json) => BlogModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch blogs: $e');
    }
  }

  // Add a new blog post
  Future<BlogModel> addBlog({
    required String title,
    required String mainDetail,
    String? subDetail,
    File? imageFile,
  }) async {
    try {
      String? imageUrl;
      
      // Upload image if provided
      if (imageFile != null) {
        imageUrl = await _uploadImage(imageFile);
      }

      final blogData = {
        'title': title,
        'main_detail': mainDetail,
        'sub_detail': subDetail,
        'link_img': imageUrl,
      };

      final response = await _supabase
          .from('blog')
          .insert(blogData)
          .select()
          .single();

      return BlogModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to add blog: $e');
    }
  }

  // Delete a blog post
  Future<void> deleteBlog(int id) async {
    try {
      await _supabase
          .from('blog')
          .delete()
          .eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete blog: $e');
    }
  }

  // Upload image to storage
  Future<String> _uploadImage(File imageFile) async {
    try {
      final fileName = 'blog_${DateTime.now().millisecondsSinceEpoch}.${imageFile.path.split('.').last}';
      
      // Try to upload to blog-images bucket first, fallback to product-images
      String bucketName = 'blog-images';
      
      try {
        await _supabase.storage
            .from(bucketName)
            .upload(fileName, imageFile);
      } catch (e) {
        // If blog-images bucket doesn't exist, use product-images
        bucketName = 'product-images';
        await _supabase.storage
            .from(bucketName)
            .upload(fileName, imageFile);
      }

      // Get public URL
      final imageUrl = _supabase.storage
          .from(bucketName)
          .getPublicUrl(fileName);

      return imageUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  // Get a single blog by id
  Future<BlogModel?> getBlogById(int id) async {
    try {
      final response = await _supabase
          .from('blog')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;
      
      return BlogModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch blog: $e');
    }
  }
}