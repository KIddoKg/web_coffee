import 'package:flutter_test/flutter_test.dart';
import 'package:xanh_coffee/models/blog_model.dart';

void main() {
  group('BlogModel', () {
    test('should create BlogModel from JSON correctly', () {
      // Arrange
      final json = {
        'id': 1,
        'title': 'Test Blog',
        'main_detail': 'This is a test blog',
        'sub_detail': 'Additional details',
        'link_img': 'https://example.com/image.jpg',
        'created_at': '2023-01-01T00:00:00.000Z',
      };

      // Act
      final blog = BlogModel.fromJson(json);

      // Assert
      expect(blog.id, equals(1));
      expect(blog.title, equals('Test Blog'));
      expect(blog.mainDetail, equals('This is a test blog'));
      expect(blog.subDetail, equals('Additional details'));
      expect(blog.linkImg, equals('https://example.com/image.jpg'));
      expect(blog.createdAt, isA<DateTime>());
    });

    test('should convert BlogModel to JSON correctly', () {
      // Arrange
      final blog = BlogModel(
        id: 1,
        title: 'Test Blog',
        mainDetail: 'This is a test blog',
        subDetail: 'Additional details',
        linkImg: 'https://example.com/image.jpg',
        createdAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
      );

      // Act
      final json = blog.toJson();

      // Assert
      expect(json['id'], equals(1));
      expect(json['title'], equals('Test Blog'));
      expect(json['main_detail'], equals('This is a test blog'));
      expect(json['sub_detail'], equals('Additional details'));
      expect(json['link_img'], equals('https://example.com/image.jpg'));
      expect(json['created_at'], equals('2023-01-01T00:00:00.000Z'));
    });

    test('should handle null values correctly', () {
      // Arrange
      final json = {
        'title': 'Test Blog',
        'main_detail': 'This is a test blog',
      };

      // Act
      final blog = BlogModel.fromJson(json);

      // Assert
      expect(blog.id, isNull);
      expect(blog.subDetail, isNull);
      expect(blog.linkImg, isNull);
      expect(blog.createdAt, isNull);
    });

    test('should create copy with modified values', () {
      // Arrange
      final originalBlog = BlogModel(
        id: 1,
        title: 'Original Title',
        mainDetail: 'Original Detail',
      );

      // Act
      final copiedBlog = originalBlog.copyWith(
        title: 'New Title',
      );

      // Assert
      expect(copiedBlog.id, equals(1));
      expect(copiedBlog.title, equals('New Title'));
      expect(copiedBlog.mainDetail, equals('Original Detail'));
    });
  });
}