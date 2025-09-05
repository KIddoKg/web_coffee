# Blog Management System

This module provides a complete blog management system for the Coffee Shop app with Supabase integration.

## Features

- ✅ Add new blog posts with image upload
- ✅ View all blog posts sorted by ID (newest first)
- ✅ Delete blog posts
- ✅ Image upload to Supabase storage (supports both `blog-images` and `product-images` buckets)
- ✅ Simple admin interface with tabbed navigation

## Database Schema

The blog table should have the following structure:

```sql
CREATE TABLE blog (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    main_detail TEXT NOT NULL,
    sub_detail TEXT,
    link_img TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);
```

**Note**: The `order` column has been removed to avoid PostgreSQL errors. Posts are sorted by `id` in descending order.

## Storage Setup

The system attempts to upload images to:
1. `blog-images` bucket (preferred)
2. `product-images` bucket (fallback)

Create at least one of these buckets in your Supabase storage.

## Usage

### 1. Initialize Supabase

```dart
import 'package:xanh_coffee/services/supabase/supabase_service.dart';

await SupabaseService.instance.initialize(
  url: 'YOUR_SUPABASE_URL',
  anonKey: 'YOUR_SUPABASE_ANON_KEY',
);
```

### 2. Use the Admin Screen

```dart
import 'package:xanh_coffee/screens/admin/admin_screen.dart';

// Navigate to admin screen
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const AdminScreen()),
);
```

### 3. Individual Widgets

You can also use the widgets separately:

```dart
// For adding blogs
import 'package:xanh_coffee/screens/admin/widgets/add_blog_widget.dart';

AddBlogWidget(
  onBlogAdded: () {
    // Handle blog added
  },
)

// For managing blogs
import 'package:xanh_coffee/screens/admin/widgets/blog_management_widget.dart';

const BlogManagementWidget()
```

### 4. Using the Service Directly

```dart
import 'package:xanh_coffee/services/supabase/blog_service.dart';

final blogService = BlogService();

// Get all blogs
final blogs = await blogService.getAllBlogs();

// Add a blog
final newBlog = await blogService.addBlog(
  title: 'My Blog Title',
  mainDetail: 'Main content here',
  subDetail: 'Optional sub content',
  imageFile: selectedImageFile,
);

// Delete a blog
await blogService.deleteBlog(blogId);
```

## Files Created

- `lib/models/blog_model.dart` - Blog data model
- `lib/services/supabase/blog_service.dart` - Blog CRUD operations
- `lib/services/supabase/supabase_service.dart` - Supabase initialization
- `lib/screens/admin/admin_screen.dart` - Main admin interface
- `lib/screens/admin/widgets/add_blog_widget.dart` - Add blog form
- `lib/screens/admin/widgets/blog_management_widget.dart` - Blog list management
- `test/blog_model_test.dart` - Unit tests for blog model

## Error Handling

The system handles common errors:
- Missing database columns (solved by removing `order` column dependency)
- Missing storage buckets (tries multiple bucket names)
- Image upload failures
- Network errors
- Invalid data validation

## Dependencies Added

- `supabase_flutter: ^2.6.0` - For Supabase integration

Existing dependencies used:
- `image_picker` - For selecting images
- `flutter/material.dart` - For UI components