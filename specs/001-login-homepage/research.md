# 技術研究: 登入與主頁功能

**建立日期**: 2025-01-19  
**功能分支**: `001-login-homepage`  
**目的**: 研究 Flutter 實作社交登入、狀態管理、路由策略與後端 API 整合的最佳實踐

---

## 研究議題總覽

本文件解決以下技術選型和實作策略：

1. **OAuth2 整合**: Google 和 Facebook 社交登入的 Flutter 實作
2. **狀態管理**: 使用者認證狀態和 token 管理方案
3. **路由策略**: 登入/登出流程的導航處理
4. **API 整合**: 與後端 RESTful API 的通訊架構
5. **安全儲存**: Token 和敏感資料的本地儲存機制
6. **UI 元件**: Material 3 設計系統與 SVG 圖示整合

---

## 1. OAuth2 社交登入實作

### 決策: 使用 Supabase Flutter SDK 整合 OAuth

**選擇原因**:
- 後端使用 Supabase Auth，前端直接使用 Supabase Flutter SDK 可簡化整合
- 自動處理 OAuth 流程 (Authorization Code Flow with PKCE)
- 內建 token 管理和自動重新整理機制
- 支援深層連結 (Deep Linking) 處理 OAuth 回呼

**替代方案考量**:
- **google_sign_in** + **flutter_facebook_auth**: 需手動處理 token 交換和 PKCE
- **oauth2**: 低階函式庫，需自行實作完整流程
- **firebase_auth**: 與後端 Supabase 架構不一致

**實作策略**:

```yaml
# pubspec.yaml
dependencies:
  supabase_flutter: ^2.3.0  # Supabase 官方 Flutter SDK
```

```dart
// lib/core/auth/supabase_auth_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  
  /// Google OAuth 登入
  Future<AuthResponse> signInWithGoogle() async {
    return await _supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'com.example.moneymanager://login-callback',
    );
  }
  
  /// Facebook OAuth 登入
  Future<AuthResponse> signInWithFacebook() async {
    return await _supabase.auth.signInWithOAuth(
      OAuthProvider.facebook,
      redirectTo: 'com.example.moneymanager://login-callback',
    );
  }
  
  /// 登出
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
  
  /// 取得當前使用者
  User? get currentUser => _supabase.auth.currentUser;
  
  /// 監聽認證狀態變更
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
}
```

**深層連結設定**:

```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<intent-filter>
  <action android:name="android.intent.action.VIEW" />
  <category android:name="android.intent.category.DEFAULT" />
  <category android:name="android.intent.category.BROWSABLE" />
  <data
    android:scheme="com.example.moneymanager"
    android:host="login-callback" />
</intent-filter>
```

```xml
<!-- ios/Runner/Info.plist -->
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>com.example.moneymanager</string>
    </array>
  </dict>
</array>
```

---

## 2. 狀態管理方案

### 決策: 使用 Riverpod 2.x

**選擇原因**:
- **類型安全**: 編譯時檢查，減少執行時錯誤
- **可測試性**: Provider 可輕鬆模擬和測試
- **效能優化**: 自動處理依賴追蹤和快取
- **社群支援**: Flutter 官方推薦的狀態管理方案之一
- **DevTools 整合**: 良好的除錯工具支援

**替代方案考量**:
- **Provider**: 較舊的 API，Riverpod 是其改進版
- **Bloc**: 更重量級，適合大型複雜應用，本專案規模不需要
- **GetX**: 過度耦合，違反單一職責原則

**實作策略**:

```yaml
# pubspec.yaml
dependencies:
  flutter_riverpod: ^2.4.0
  riverpod_annotation: ^2.3.0

dev_dependencies:
  riverpod_generator: ^2.3.0
  build_runner: ^2.4.0
```

**認證狀態管理**:

```dart
// lib/features/auth/providers/auth_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_provider.g.dart';

/// 認證狀態 Provider
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    // 監聽 Supabase 認證狀態變更
    final authService = ref.watch(authServiceProvider);
    authService.authStateChanges.listen((state) {
      this.state = _mapAuthState(state);
    });
    
    // 初始化時檢查是否已登入
    final user = authService.currentUser;
    return user != null
        ? AuthState.authenticated(user)
        : const AuthState.unauthenticated();
  }
  
  /// Google 登入
  Future<void> signInWithGoogle() async {
    state = const AuthState.loading();
    try {
      final authService = ref.read(authServiceProvider);
      final response = await authService.signInWithGoogle();
      
      if (response.user != null) {
        state = AuthState.authenticated(response.user!);
      } else {
        state = const AuthState.error('登入失敗');
      }
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }
  
  /// Facebook 登入
  Future<void> signInWithFacebook() async {
    state = const AuthState.loading();
    try {
      final authService = ref.read(authServiceProvider);
      final response = await authService.signInWithFacebook();
      
      if (response.user != null) {
        state = AuthState.authenticated(response.user!);
      } else {
        state = const AuthState.error('登入失敗');
      }
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }
  
  /// 登出
  Future<void> signOut() async {
    state = const AuthState.loading();
    try {
      final authService = ref.read(authServiceProvider);
      await authService.signOut();
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }
}

/// 認證狀態模型
sealed class AuthState {
  const AuthState();
  
  const factory AuthState.unauthenticated() = Unauthenticated;
  const factory AuthState.loading() = Loading;
  const factory AuthState.authenticated(User user) = Authenticated;
  const factory AuthState.error(String message) = AuthError;
}
```

---

## 3. 路由策略

### 決策: 使用 Go Router + 路由守衛

**選擇原因**:
- **宣告式路由**: 路由定義清晰，易於維護
- **深層連結支援**: 原生支援 deep linking 和 URL 導航
- **路由守衛**: 內建 redirect 機制實作認證檢查
- **型別安全**: 使用 go_router_builder 產生型別安全的路由
- **瀏覽器整合**: Web 平台支援 URL 歷史記錄

**替代方案考量**:
- **Navigator 1.0**: 舊版 API，不支援宣告式路由
- **AutoRoute**: 功能類似但社群支援較少
- **Beamer**: 學習曲線較陡峭

**實作策略**:

```yaml
# pubspec.yaml
dependencies:
  go_router: ^13.0.0
```

```dart
// lib/core/routing/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 路由定義 Provider
final routerProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.watch(authNotifierProvider.notifier);
  
  return GoRouter(
    initialLocation: '/login',
    refreshListenable: authNotifier, // 認證狀態變更時自動重新評估路由
    redirect: (context, state) {
      final authState = ref.read(authNotifierProvider);
      final isGoingToLogin = state.matchedLocation == '/login';
      
      // 路由守衛邏輯
      return authState.when(
        unauthenticated: () => isGoingToLogin ? null : '/login',
        loading: () => null,
        authenticated: (user) => isGoingToLogin ? '/home' : null,
        error: (message) => '/login',
      );
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/login-callback',
        name: 'login-callback',
        builder: (context, state) {
          // OAuth 回呼處理
          return const LoadingPage(); // 顯示載入畫面，Supabase SDK 會自動處理
        },
      ),
    ],
    errorBuilder: (context, state) => ErrorPage(error: state.error),
  );
});
```

**路由使用範例**:

```dart
// 導航到主頁
context.go('/home');

// 導航到登入頁
context.go('/login');

// 替換當前路由 (避免返回鍵返回登入頁)
context.goNamed('home');
```

---

## 4. 後端 API 整合

### 決策: 使用 Dio + Retrofit 風格封裝

**選擇原因**:
- **攔截器支援**: 自動添加 Authorization header 和錯誤處理
- **取消請求**: 支援請求取消和逾時管理
- **日誌記錄**: 內建請求/回應日誌，方便除錯
- **型別安全**: 結合 Retrofit 風格註解產生 API 客戶端
- **效能**: 支援連線池和請求快取

**替代方案考量**:
- **http**: 功能較陽春，需手動處理攔截器
- **Chopper**: 類似 Retrofit 但社群較小
- **GraphQL**: 後端使用 REST API，不適用

**實作策略**:

```yaml
# pubspec.yaml
dependencies:
  dio: ^5.4.0
  retrofit: ^4.0.0
  json_annotation: ^4.8.0

dev_dependencies:
  retrofit_generator: ^8.0.0
  json_serializable: ^6.7.0
```

**API 客戶端定義**:

```dart
// lib/core/api/api_client.dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: 'https://api-dev.money-manager.example.com/api/v1')
abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;
  
  /// Google OAuth 登入
  @POST('/auth/login/google')
  Future<LoginResponse> loginWithGoogle(@Body() GoogleLoginRequest request);
  
  /// Facebook OAuth 登入
  @POST('/auth/login/facebook')
  Future<LoginResponse> loginWithFacebook(@Body() FacebookLoginRequest request);
  
  /// 登出
  @POST('/auth/logout')
  Future<void> logout();
  
  /// 驗證 Token
  @GET('/auth/verify')
  Future<VerifyResponse> verifyToken();
  
  /// 更新 Token
  @POST('/auth/refresh')
  Future<LoginResponse> refreshToken(@Body() RefreshTokenRequest request);
  
  /// 取得主頁資料
  @GET('/homepage')
  Future<HomepageResponse> getHomepage();
  
  /// 刪除帳號
  @DELETE('/user/delete')
  Future<void> deleteAccount();
}
```

**Dio 設定與攔截器**:

```dart
// lib/core/api/dio_provider.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );
  
  // 認證攔截器: 自動添加 Bearer Token
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final authService = ref.read(authServiceProvider);
        final user = authService.currentUser;
        
        if (user != null) {
          final session = authService._supabase.auth.currentSession;
          if (session != null) {
            options.headers['Authorization'] = 'Bearer ${session.accessToken}';
          }
        }
        
        return handler.next(options);
      },
      onError: (error, handler) async {
        // Token 過期自動重新整理
        if (error.response?.statusCode == 401) {
          try {
            final authService = ref.read(authServiceProvider);
            await authService._supabase.auth.refreshSession();
            
            // 重試原始請求
            final opts = error.requestOptions;
            final session = authService._supabase.auth.currentSession;
            opts.headers['Authorization'] = 'Bearer ${session!.accessToken}';
            
            final response = await dio.fetch(opts);
            return handler.resolve(response);
          } catch (e) {
            // 重新整理失敗，導向登入頁
            ref.read(authNotifierProvider.notifier).signOut();
          }
        }
        
        return handler.next(error);
      },
    ),
  );
  
  // 日誌攔截器 (僅 Debug 模式)
  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
  ));
  
  return dio;
});

/// API 客戶端 Provider
final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiClient(dio);
});
```

**資料模型範例**:

```dart
// lib/features/auth/models/login_response.dart
import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  @JsonKey(name: 'access_token')
  final String accessToken;
  
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  
  @JsonKey(name: 'token_type')
  final String tokenType;
  
  @JsonKey(name: 'expires_in')
  final int expiresIn;
  
  final UserProfile user;
  
  const LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
    required this.user,
  });
  
  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
  
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()
class UserProfile {
  final String id;
  final String email;
  final String name;
  
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  
  final String provider;
  
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  
  @JsonKey(name: 'last_sign_in_at')
  final DateTime? lastSignInAt;
  
  const UserProfile({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
    required this.provider,
    required this.createdAt,
    this.lastSignInAt,
  });
  
  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
  
  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}
```

---

## 5. 安全儲存機制

### 決策: 使用 flutter_secure_storage

**選擇原因**:
- **加密儲存**: iOS Keychain 和 Android Keystore 的跨平台封裝
- **自動加密**: 敏感資料自動加密儲存
- **簡單 API**: 類似 SharedPreferences 的鍵值對介面
- **平台整合**: 充分利用原生平台的安全機制

**替代方案考量**:
- **SharedPreferences**: 未加密，不適合儲存 token
- **Hive**: 需手動實作加密邏輯
- **Sqflite**: 過於複雜，本專案不需要關聯式資料庫

**實作策略**:

```yaml
# pubspec.yaml
dependencies:
  flutter_secure_storage: ^9.0.0
```

```dart
// lib/core/storage/secure_storage_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

class SecureStorageService {
  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );
  
  // Token 儲存鍵
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  
  /// 儲存認證 token
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _storage.write(key: _accessTokenKey, value: accessToken),
      _storage.write(key: _refreshTokenKey, value: refreshToken),
    ]);
  }
  
  /// 取得 access token
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }
  
  /// 取得 refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }
  
  /// 儲存使用者 ID
  Future<void> saveUserId(String userId) async {
    await _storage.write(key: _userIdKey, value: userId);
  }
  
  /// 取得使用者 ID
  Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }
  
  /// 清除所有認證資料
  Future<void> clearAuth() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
      _storage.delete(key: _userIdKey),
    ]);
  }
  
  /// 清除所有資料
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
```

**注意事項**:
- Supabase Flutter SDK 已內建 secure storage 支援，上述程式碼僅供參考
- 實際專案中建議直接使用 Supabase SDK 的認證狀態管理

---

## 6. UI 元件與設計系統

### 決策: Material 3 + flutter_svg

**Material 3 整合**:

```dart
// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  /// 主題色彩 (從 Figma 設計系統提取)
  static const Color primaryColor = Color(0xFF86EFCC);
  static const Color backgroundColor = Color(0xFFF9FAFB);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF0A0A0A);
  static const Color textSecondary = Color(0xFF354152);
  static const Color textTertiary = Color(0xFF495565);
  static const Color borderColor = Color(0xFFD0D5DB);
  
  // Google 品牌色
  static const Color googleBlue = Color(0xFF4285F4);
  static const Color googleGreen = Color(0xFF34A853);
  static const Color googleYellow = Color(0xFFFBBC05);
  static const Color googleRed = Color(0xFFEA4335);
  
  // Facebook 品牌色
  static const Color facebookBlue = Color(0xFF1877F2);
  
  /// Light Theme
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        surface: surfaceColor,
        background: backgroundColor,
        onPrimary: Colors.black,
        onSurface: textPrimary,
      ),
      
      // 文字主題 (從 Figma 設計系統)
      textTheme: const TextTheme(
        displaySmall: TextStyle(
          fontFamily: 'Inter',
          fontSize: 30,
          fontWeight: FontWeight.w500,
          height: 1.2, // 36px / 30px
          letterSpacing: 0.40,
          color: textPrimary,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Inter',
          fontSize: 24,
          fontWeight: FontWeight.w400,
          height: 1.33, // 32px / 24px
          letterSpacing: 0.07,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.5, // 24px / 16px
          letterSpacing: -0.31,
          color: textTertiary,
        ),
        labelLarge: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 1.43, // 20px / 14px
          letterSpacing: -0.15,
          color: textSecondary,
        ),
      ),
      
      // 按鈕主題
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(313, 56), // 從 Figma
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // 從 Figma
          ),
        ),
      ),
      
      // 卡片主題
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // 從 Figma
        ),
      ),
    );
  }
}
```

**SVG 圖示整合**:

```yaml
# pubspec.yaml
dependencies:
  flutter_svg: ^2.0.0

flutter:
  assets:
    - assets/icons/google-icon-blue.svg
    - assets/icons/google-icon-green.svg
    - assets/icons/google-icon-yellow.svg
    - assets/icons/google-icon-red.svg
    - assets/icons/facebook-icon.svg
    - assets/icons/app-logo.svg
    - assets/icons/logout-icon-part-72.svg
    - assets/icons/logout-icon-part-73.svg
    - assets/icons/logout-icon-part-74.svg
    - assets/icons/construction-icon-part-86.svg
    - assets/icons/construction-icon-part-87.svg
    - assets/icons/construction-icon-part-88.svg
    - assets/icons/construction-icon-part-89.svg
    - assets/icons/construction-icon-part-90.svg
    - assets/icons/construction-icon-part-91.svg
    - assets/icons/construction-icon-part-92.svg
    - assets/icons/construction-icon-part-93.svg
```

```dart
// lib/core/widgets/google_logo.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Google Logo 元件 (組合四個顏色部分)
class GoogleLogo extends StatelessWidget {
  final double size;
  
  const GoogleLogo({super.key, this.size = 24});
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          SvgPicture.asset('assets/icons/google-icon-blue.svg'),
          SvgPicture.asset('assets/icons/google-icon-green.svg'),
          SvgPicture.asset('assets/icons/google-icon-yellow.svg'),
          SvgPicture.asset('assets/icons/google-icon-red.svg'),
        ],
      ),
    );
  }
}

/// Facebook Logo 元件
class FacebookLogo extends StatelessWidget {
  final double size;
  
  const FacebookLogo({super.key, this.size = 24});
  
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/facebook-icon.svg',
      width: size,
      height: size,
      colorFilter: const ColorFilter.mode(
        Colors.white,
        BlendMode.srcIn,
      ),
    );
  }
}
```

---

## 總結

### 核心技術堆疊

| 層級 | 技術選型 | 用途 |
|------|----------|------|
| **認證** | Supabase Flutter SDK | OAuth2 整合、Token 管理 |
| **狀態管理** | Riverpod 2.x | 全域狀態、認證狀態 |
| **路由** | Go Router | 宣告式路由、路由守衛 |
| **API 整合** | Dio + Retrofit | HTTP 客戶端、API 封裝 |
| **安全儲存** | flutter_secure_storage (Supabase 內建) | Token 加密儲存 |
| **UI 框架** | Material 3 | 設計系統、元件庫 |
| **圖示** | flutter_svg | SVG 圖示渲染 |

### 專案結構建議

```
lib/
├── core/
│   ├── auth/
│   │   └── supabase_auth_service.dart
│   ├── api/
│   │   ├── api_client.dart
│   │   └── dio_provider.dart
│   ├── routing/
│   │   └── app_router.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── widgets/
│       ├── google_logo.dart
│       └── facebook_logo.dart
├── features/
│   ├── auth/
│   │   ├── models/
│   │   ├── providers/
│   │   ├── screens/
│   │   └── widgets/
│   └── home/
│       ├── models/
│       ├── providers/
│       ├── screens/
│       └── widgets/
└── main.dart
```

### 關鍵決策摘要

1. ✅ **OAuth 整合**: Supabase SDK (簡化整合、自動處理 PKCE)
2. ✅ **狀態管理**: Riverpod 2.x (類型安全、可測試性)
3. ✅ **路由策略**: Go Router (宣告式、路由守衛)
4. ✅ **API 整合**: Dio + Retrofit (攔截器、型別安全)
5. ✅ **安全儲存**: Supabase 內建 (平台整合)
6. ✅ **UI 元件**: Material 3 + flutter_svg (設計一致性)

### 下一步行動

- ✅ 技術研究已完成，所有 NEEDS CLARIFICATION 已解決
- ➡️ 進入 Phase 1: 產生 data-model.md 和 API contracts
- ➡️ 更新 agent context 以包含新增的技術堆疊
