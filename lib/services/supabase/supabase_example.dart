import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'services_supabase.dart';

/// Example về cách sử dụng SupabaseService
class SupabaseExample {
  /// Example: Đăng nhập
  static Future<void> exampleSignIn() async {
    try {
      final response = await SupabaseService.signInWithEmailPassword(
        email: 'user@example.com',
        password: 'password123',
      );

      if (response.user != null) {
        debugPrint('Đăng nhập thành công: ${response.user!.email}');
      }
    } catch (e) {
      debugPrint('Lỗi đăng nhập: $e');
    }
  }

  /// Example: Đăng ký
  static Future<void> exampleSignUp() async {
    try {
      final response = await SupabaseService.signUpWithEmailPassword(
        email: 'newuser@example.com',
        password: 'password123',
        data: {
          'full_name': 'Nguyen Van A',
          'avatar_url': 'https://example.com/avatar.jpg',
        },
      );

      if (response.user != null) {
        debugPrint('Đăng ký thành công: ${response.user!.email}');
      }
    } catch (e) {
      debugPrint('Lỗi đăng ký: $e');
    }
  }

  /// Example: Lấy dữ liệu từ table
  static Future<void> exampleFetchData() async {
    try {
      final data = await SupabaseService.from('products')
          .select('id, name, price, description')
          .eq('status', 'active')
          .order('created_at', ascending: false)
          .limit(10);

      debugPrint('Dữ liệu sản phẩm: $data');
    } catch (e) {
      debugPrint('Lỗi lấy dữ liệu: $e');
    }
  }

  /// Example: Thêm dữ liệu mới
  static Future<void> exampleInsertData() async {
    try {
      final data = await SupabaseService.from('products').insert({
        'name': 'Coffee Latte',
        'price': 45000,
        'description': 'Cà phê latte thơm ngon',
        'status': 'active',
        'user_id': SupabaseService.currentUser?.id,
      }).select();

      debugPrint('Thêm sản phẩm thành công: $data');
    } catch (e) {
      debugPrint('Lỗi thêm dữ liệu: $e');
    }
  }

  /// Example: Cập nhật dữ liệu
  static Future<void> exampleUpdateData(String productId) async {
    try {
      final data = await SupabaseService.from('products')
          .update({
            'price': 50000,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', productId)
          .select();

      debugPrint('Cập nhật sản phẩm thành công: $data');
    } catch (e) {
      debugPrint('Lỗi cập nhật dữ liệu: $e');
    }
  }

  /// Example: Xóa dữ liệu
  static Future<void> exampleDeleteData(String productId) async {
    try {
      await SupabaseService.from('products').delete().eq('id', productId);

      debugPrint('Xóa sản phẩm thành công');
    } catch (e) {
      debugPrint('Lỗi xóa dữ liệu: $e');
    }
  }

  /// Example: Upload file
  static Future<void> exampleUploadFile(
      List<int> fileBytes, String fileName) async {
    try {
      final publicUrl = await SupabaseService.uploadFile(
        bucket: 'product-images',
        path: 'images/$fileName',
        fileBytes: Uint8List.fromList(fileBytes),
        metadata: {
          'content-type': 'image/jpeg',
        },
      );

      debugPrint('Upload file thành công: $publicUrl');
    } catch (e) {
      debugPrint('Lỗi upload file: $e');
    }
  }

  /// Example: Lắng nghe thay đổi auth state
  static void exampleListenAuthChanges() {
    SupabaseService.authStateChanges.listen((authState) {
      if (authState.session != null) {
        debugPrint('User đã đăng nhập: ${authState.session!.user.email}');
      } else {
        debugPrint('User đã đăng xuất');
      }
    });
  }

  /// Example: Gọi RPC function
  static Future<void> exampleCallRPC() async {
    try {
      final result =
          await SupabaseService.rpc('calculate_total_revenue', params: {
        'start_date': '2024-01-01',
        'end_date': '2024-12-31',
      });

      debugPrint('Tổng doanh thu: ${result.data}');
    } catch (e) {
      debugPrint('Lỗi gọi RPC: $e');
    }
  }

  /// Example: Realtime subscription
  static void exampleRealtimeSubscription() {
    SupabaseService.client
        .channel('products_channel')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'products',
          callback: (payload) {
            debugPrint('Dữ liệu thay đổi realtime: $payload');
          },
        )
        .subscribe();
  }
}

/// Widget example để demo trong UI
class SupabaseExampleWidget extends StatefulWidget {
  const SupabaseExampleWidget({super.key});

  @override
  State<SupabaseExampleWidget> createState() => _SupabaseExampleWidgetState();
}

class _SupabaseExampleWidgetState extends State<SupabaseExampleWidget> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
    _listenToAuthChanges();
  }

  void _checkAuthStatus() {
    setState(() {
      _isLoggedIn = SupabaseService.isLoggedIn;
    });
  }

  void _listenToAuthChanges() {
    SupabaseService.authStateChanges.listen((authState) {
      setState(() {
        _isLoggedIn = authState.session != null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supabase Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _isLoggedIn ? 'Đã đăng nhập' : 'Chưa đăng nhập',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (!_isLoggedIn) ...[
              ElevatedButton(
                onPressed: () => SupabaseExample.exampleSignIn(),
                child: const Text('Đăng nhập'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => SupabaseExample.exampleSignUp(),
                child: const Text('Đăng ký'),
              ),
            ] else ...[
              ElevatedButton(
                onPressed: () => SupabaseService.signOut(),
                child: const Text('Đăng xuất'),
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => SupabaseExample.exampleFetchData(),
              child: const Text('Lấy dữ liệu sản phẩm'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => SupabaseExample.exampleInsertData(),
              child: const Text('Thêm sản phẩm mới'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => SupabaseExample.exampleRealtimeSubscription(),
              child: const Text('Bật Realtime'),
            ),
          ],
        ),
      ),
    );
  }
}
