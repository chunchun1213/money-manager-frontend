/// 環境變數設定
///
/// 從 .env 檔案讀取環境變數
library;

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  Env._();

  /// Supabase URL
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';

  /// Supabase Anonymous Key
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  /// 後端 API Base URL
  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? '';

  /// OAuth Redirect Scheme
  static String get oauthRedirectScheme =>
      dotenv.env['OAUTH_REDIRECT_SCHEME'] ?? 'com.example.moneymanager';

  /// OAuth Redirect Host
  static String get oauthRedirectHost =>
      dotenv.env['OAUTH_REDIRECT_HOST'] ?? 'login-callback';

  /// 完整的 OAuth Redirect URI
  static String get oauthRedirectUri =>
      '$oauthRedirectScheme://$oauthRedirectHost';

  /// 環境名稱
  static String get environment => dotenv.env['ENV'] ?? 'development';

  /// 是否為開發環境
  static bool get isDevelopment => environment == 'development';

  /// 是否為正式環境
  static bool get isProduction => environment == 'production';
}
