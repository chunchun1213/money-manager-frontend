/// Supabase 認證服務
///
/// 初始化並提供 Supabase 客戶端實例
library;

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:money_manager/config/env.dart';

class SupabaseService {
  SupabaseService._();

  static SupabaseService? _instance;
  static SupabaseService get instance => _instance ??= SupabaseService._();

  SupabaseClient? _client;

  /// 取得 Supabase 客戶端
  SupabaseClient get client {
    if (_client == null) {
      throw StateError(
          'SupabaseService not initialized. Call initialize() first.',);
    }
    return _client!;
  }

  /// 初始化 Supabase
  Future<void> initialize() async {
    try {
      await Supabase.initialize(
        url: Env.supabaseUrl,
        anonKey: Env.supabaseAnonKey,
        authOptions: const FlutterAuthClientOptions(
          authFlowType: AuthFlowType.pkce,
        ),
        debug: Env.isDevelopment,
      );
      _client = Supabase.instance.client;

      if (kDebugMode) {
        print('✅ Supabase initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to initialize Supabase: $e');
      }
      rethrow;
    }
  }

  /// 檢查是否已初始化
  bool get isInitialized => _client != null;
}
