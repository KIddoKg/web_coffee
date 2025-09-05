import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../config/env.dart';
import '../../helper/di/di.dart';

/// Service để quản lý kết nối và các thao tác với Supabase
class SupabaseService {
  static SupabaseClient? _client;

  /// Khởi tạo kết nối Supabase
  static Future<void> initialize() async {
    final env = di<Env>();

    await Supabase.initialize(
      url: env.supabaseUrl,
      anonKey: env.supabaseAnonKey,
    );

    _client = Supabase.instance.client;
  }

  /// Lấy Supabase client instance
  static SupabaseClient get client {
    if (_client == null) {
      throw Exception(
          'SupabaseService chưa được khởi tạo. Hãy gọi SupabaseService.initialize() trước.');
    }
    return _client!;
  }

  /// Kiểm tra xem có kết nối không
  static bool get isInitialized => _client != null;

  /// Lấy user hiện tại
  static User? get currentUser => client.auth.currentUser;

  /// Kiểm tra trạng thái đăng nhập
  static bool get isLoggedIn => currentUser != null;

  /// Stream để lắng nghe thay đổi trạng thái authentication
  static Stream<AuthState> get authStateChanges =>
      client.auth.onAuthStateChange;

  /// Đăng nhập bằng email và password
  static Future<AuthResponse> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Đăng ký tài khoản mới
  static Future<AuthResponse> signUpWithEmailPassword({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    return await client.auth.signUp(
      email: email,
      password: password,
      data: data,
    );
  }

  /// Đăng xuất
  static Future<void> signOut() async {
    await client.auth.signOut();
  }

  /// Reset mật khẩu
  static Future<void> resetPassword({required String email}) async {
    await client.auth.resetPasswordForEmail(email);
  }

  /// Lấy dữ liệu từ table
  static SupabaseQueryBuilder from(String table) {
    return client.from(table);
  }

  /// Upload file lên storage
  static Future<String> uploadFile({
    required String bucket,
    required String path,
    required Uint8List fileBytes,
    Map<String, String>? metadata,
  }) async {
    await client.storage.from(bucket).uploadBinary(
          path,
          fileBytes,
          fileOptions: FileOptions(
            metadata: metadata,
          ),
        );

    return client.storage.from(bucket).getPublicUrl(path);
  }

  /// Xóa file từ storage
  static Future<void> deleteFile({
    required String bucket,
    required String path,
  }) async {
    await client.storage.from(bucket).remove([path]);
  }

  /// Lấy URL public của file
  static String getPublicUrl({
    required String bucket,
    required String path,
  }) {
    return client.storage.from(bucket).getPublicUrl(path);
  }

  /// Tạo signed URL cho file private
  static Future<String> createSignedUrl({
    required String bucket,
    required String path,
    int expiresIn = 3600, // 1 giờ
  }) async {
    return await client.storage.from(bucket).createSignedUrl(path, expiresIn);
  }

  /// Thực hiện RPC (Remote Procedure Call)
  static Future<PostgrestResponse> rpc(
    String functionName, {
    Map<String, dynamic>? params,
  }) async {
    return await client.rpc(functionName, params: params);
  }

  /// Dispose resources
  static void dispose() {
    _client = null;
  }
}
