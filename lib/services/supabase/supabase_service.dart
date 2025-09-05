import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static SupabaseService? _instance;
  static SupabaseService get instance => _instance ??= SupabaseService._();
  
  SupabaseService._();
  
  bool _isInitialized = false;
  
  Future<void> initialize({
    required String url,
    required String anonKey,
  }) async {
    if (_isInitialized) return;
    
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
    
    _isInitialized = true;
  }
  
  SupabaseClient get client {
    if (!_isInitialized) {
      throw Exception('Supabase not initialized. Call initialize() first.');
    }
    return Supabase.instance.client;
  }
  
  bool get isInitialized => _isInitialized;
}