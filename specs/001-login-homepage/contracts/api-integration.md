# API Contracts: 前端整合規格

**建立日期**: 2025-01-19  
**功能分支**: `001-login-homepage`  
**後端 API 規格**: [https://github.com/chunchun1213/money-manager-backend/blob/001-login-homepage/specs/001-login-homepage/contracts/openapi.yaml](https://github.com/chunchun1213/money-manager-backend/blob/001-login-homepage/specs/001-login-homepage/contracts/openapi.yaml)

---

## API 端點總覽

| 端點 | 方法 | 用途 | 認證 |
|------|------|------|------|
| `/auth/login/google` | POST | Google OAuth 登入 | ❌ |
| `/auth/login/facebook` | POST | Facebook OAuth 登入 | ❌ |
| `/auth/logout` | POST | 登出 | ✅ Bearer Token |
| `/auth/verify` | GET | 驗證 Token | ✅ Bearer Token |
| `/auth/refresh` | POST | 更新 Token | ❌ |
| `/homepage` | GET | 取得主頁資料 | ✅ Bearer Token |
| `/user/delete` | DELETE | 刪除帳號 | ✅ Bearer Token |

---

## 環境設定

### Base URLs

```dart
// lib/core/api/config/api_config.dart
class ApiConfig {
  /// 開發環境
  static const String devBaseUrl = 'https://api-dev.money-manager.example.com/api/v1';
  
  /// 正式環境
  static const String prodBaseUrl = 'https://api.money-manager.example.com/api/v1';
  
  /// 根據建構模式選擇環境
  static String get baseUrl {
    return const bool.fromEnvironment('dart.vm.product')
        ? prodBaseUrl
        : devBaseUrl;
  }
  
  /// 連線逾時設定
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
```

---

## 1. Google OAuth 登入

### POST `/auth/login/google`

**用途**: 使用 Google OAuth authorization code 進行登入

#### Request Headers
```
Content-Type: application/json
```

#### Request Body
```dart
{
  "code": "4/0AfJohXk...",  // Google OAuth authorization code
  "code_verifier": "dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk",  // PKCE verifier
  "device_info": {  // 選填
    "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X)",
    "platform": "iOS 17.0"
  }
}
```

#### Response (200 OK)
```dart
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "Bearer",
  "expires_in": 3600,  // 秒
  "user": {
    "id": "123e4567-e89b-12d3-a456-426614174000",
    "email": "user@example.com",
    "name": "王小明",
    "avatar_url": "https://lh3.googleusercontent.com/a/...",
    "provider": "google",
    "created_at": "2025-01-15T08:30:00Z",
    "last_sign_in_at": "2025-01-18T10:30:00Z"
  }
}
```

#### Error Responses

**400 Bad Request**
```dart
{
  "error": "MISSING_PARAMETER",
  "message": "缺少必填參數: code",
  "details": {
    "field": "code",
    "reason": "code 參數為必填"
  },
  "timestamp": "2025-01-18T10:30:00Z"
}
```

**401 Unauthorized**
```dart
{
  "error": "INVALID_OAUTH_TOKEN",
  "message": "Google OAuth token 無效,請重新登入",
  "timestamp": "2025-01-18T10:30:00Z"
}
```

#### Flutter 實作

```dart
// lib/core/api/api_client.dart
@POST('/auth/login/google')
Future<LoginResponse> loginWithGoogle(
  @Body() GoogleLoginRequest request,
);

// 使用範例
final request = GoogleLoginRequest(
  code: authorizationCode,
  codeVerifier: codeVerifier,
  deviceInfo: DeviceInfo(
    userAgent: userAgent,
    platform: Platform.operatingSystem,
  ),
);

try {
  final response = await apiClient.loginWithGoogle(request);
  // 儲存 token
  await secureStorage.saveTokens(
    accessToken: response.accessToken,
    refreshToken: response.refreshToken,
  );
  // 更新使用者狀態
  ref.read(authNotifierProvider.notifier).state = 
      AuthState.authenticated(response.user);
} on DioException catch (e) {
  if (e.response?.statusCode == 401) {
    // OAuth token 無效
    showError('Google 登入失敗,請重試');
  }
}
```

---

## 2. Facebook OAuth 登入

### POST `/auth/login/facebook`

**用途**: 使用 Facebook OAuth authorization code 進行登入

#### Request/Response 結構
與 Google 登入完全相同，僅 provider 欄位不同。

#### Flutter 實作

```dart
@POST('/auth/login/facebook')
Future<LoginResponse> loginWithFacebook(
  @Body() FacebookLoginRequest request,
);
```

---

## 3. 登出

### POST `/auth/logout`

**用途**: 撤銷當前 JWT token，清除會話

#### Request Headers
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json
```

#### Request Body
無

#### Response (200 OK)
```dart
{
  "message": "登出成功"
}
```

#### Error Responses

**401 Unauthorized**
```dart
{
  "error": "INVALID_TOKEN",
  "message": "Token 格式不正確或簽名無效",
  "timestamp": "2025-01-18T10:30:00Z"
}
```

#### Flutter 實作

```dart
@POST('/auth/logout')
Future<void> logout();

// 使用範例
try {
  await apiClient.logout();
  // 清除本地 token
  await secureStorage.clearAuth();
  // 更新狀態
  ref.read(authNotifierProvider.notifier).state = 
      const AuthState.unauthenticated();
} on DioException catch (e) {
  // 即使 API 呼叫失敗，仍清除本地資料
  await secureStorage.clearAuth();
}
```

---

## 4. 驗證 Token

### GET `/auth/verify`

**用途**: 驗證 JWT token 是否有效，取得使用者資訊

#### Request Headers
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

#### Response (200 OK)
```dart
{
  "user": {
    "id": "123e4567-e89b-12d3-a456-426614174000",
    "email": "user@example.com",
    "name": "王小明",
    "avatar_url": "https://lh3.googleusercontent.com/a/...",
    "provider": "google",
    "created_at": "2025-01-15T08:30:00Z",
    "last_sign_in_at": "2025-01-18T10:30:00Z"
  },
  "session": {
    "expires_at": "2025-02-17T10:30:00Z"
  }
}
```

#### Error Responses

**401 Unauthorized**
```dart
{
  "error": "EXPIRED_TOKEN",
  "message": "Token 已過期,請重新登入",
  "timestamp": "2025-01-18T10:30:00Z"
}
```

#### Flutter 實作

```dart
@GET('/auth/verify')
Future<VerifyResponse> verifyToken();

// 使用範例 (應用程式啟動時檢查)
try {
  final response = await apiClient.verifyToken();
  // Token 有效，自動登入
  ref.read(authNotifierProvider.notifier).state = 
      AuthState.authenticated(response.user);
} on DioException catch (e) {
  if (e.response?.statusCode == 401) {
    // Token 無效或過期，導向登入頁
    await secureStorage.clearAuth();
    ref.read(authNotifierProvider.notifier).state = 
        const AuthState.unauthenticated();
  }
}
```

---

## 5. 更新 Token

### POST `/auth/refresh`

**用途**: 使用 refresh token 取得新的 access token

#### Request Headers
```
Content-Type: application/json
```

#### Request Body
```dart
{
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

#### Response (200 OK)
```dart
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",  // 新的 token
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",  // 新的 refresh token (rotation)
  "token_type": "Bearer",
  "expires_in": 3600,
  "user": { /* 使用者資訊 */ }
}
```

#### Error Responses

**401 Unauthorized**
```dart
{
  "error": "INVALID_REFRESH_TOKEN",
  "message": "Refresh token 無效,請重新登入",
  "timestamp": "2025-01-18T10:30:00Z"
}
```

#### Flutter 實作

```dart
@POST('/auth/refresh')
Future<LoginResponse> refreshToken(
  @Body() RefreshTokenRequest request,
);

// 使用範例 (在 Dio 攔截器中自動處理)
onError: (error, handler) async {
  if (error.response?.statusCode == 401) {
    try {
      final refreshToken = await secureStorage.getRefreshToken();
      if (refreshToken != null) {
        final response = await apiClient.refreshToken(
          RefreshTokenRequest(refreshToken: refreshToken),
        );
        
        // 儲存新 token
        await secureStorage.saveTokens(
          accessToken: response.accessToken,
          refreshToken: response.refreshToken,
        );
        
        // 重試原始請求
        final opts = error.requestOptions;
        opts.headers['Authorization'] = 'Bearer ${response.accessToken}';
        final retryResponse = await dio.fetch(opts);
        return handler.resolve(retryResponse);
      }
    } catch (e) {
      // Refresh 失敗，清除認證並導向登入
      await secureStorage.clearAuth();
      ref.read(authNotifierProvider.notifier).signOut();
    }
  }
  return handler.next(error);
}
```

---

## 6. 取得主頁資料

### GET `/homepage`

**用途**: 取得記帳主頁資料 (目前為佔位資料)

#### Request Headers
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

#### Response (200 OK)
```dart
{
  "user": {
    "id": "123e4567-e89b-12d3-a456-426614174000",
    "email": "user@example.com",
    "name": "王小明",
    "avatar_url": "https://lh3.googleusercontent.com/a/...",
    "provider": "google",
    "created_at": "2025-01-15T08:30:00Z",
    "last_sign_in_at": "2025-01-18T10:30:00Z"
  },
  "content": {
    "message": "施工中...",
    "icon": "🚧"
  }
}
```

#### Flutter 實作

```dart
@GET('/homepage')
Future<HomepageData> getHomepage();

// 使用範例
final homepageProvider = FutureProvider<HomepageData>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  return await apiClient.getHomepage();
});
```

---

## 7. 刪除帳號

### DELETE `/user/delete`

**用途**: 永久刪除使用者帳號及所有關聯資料

**注意**: 此操作無法恢復

#### Request Headers
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

#### Response (200 OK)
```dart
{
  "message": "帳號已永久刪除"
}
```

#### Flutter 實作

```dart
@DELETE('/user/delete')
Future<void> deleteAccount();

// 使用範例
Future<void> deleteMyAccount(WidgetRef ref) async {
  final confirmed = await showConfirmDialog(
    title: '確認刪除帳號',
    message: '此操作無法恢復，您確定要永久刪除帳號嗎？',
  );
  
  if (confirmed) {
    try {
      final apiClient = ref.read(apiClientProvider);
      await apiClient.deleteAccount();
      
      // 清除本地資料
      await ref.read(secureStorageProvider).clearAll();
      
      // 導向登入頁
      ref.read(authNotifierProvider.notifier).state = 
          const AuthState.unauthenticated();
      
      showSuccess('帳號已成功刪除');
    } on DioException catch (e) {
      showError('刪除帳號失敗: ${e.message}');
    }
  }
}
```

---

## 錯誤處理策略

### 統一錯誤攔截器

```dart
// lib/core/api/interceptors/error_interceptor.dart
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.data != null) {
      try {
        final apiError = ApiError.fromJson(err.response!.data);
        
        // 根據錯誤碼處理
        switch (apiError.error) {
          case 'INVALID_OAUTH_TOKEN':
            // 顯示友善錯誤訊息
            showError('登入失敗，請重試');
            break;
          
          case 'EXPIRED_TOKEN':
          case 'REVOKED_TOKEN':
            // 自動登出
            _handleTokenExpired();
            break;
          
          case 'MISSING_PARAMETER':
          case 'INVALID_FORMAT':
            // 顯示欄位驗證錯誤
            showError(apiError.message);
            break;
          
          default:
            // 顯示通用錯誤
            showError(apiError.message);
        }
      } catch (e) {
        // JSON 解析失敗，顯示預設錯誤
        showError('系統錯誤，請稍後再試');
      }
    }
    
    super.onError(err, handler);
  }
  
  void _handleTokenExpired() {
    // 清除認證並導向登入
    // (由 RefreshTokenInterceptor 處理)
  }
}
```

### 錯誤訊息對應表

| HTTP 狀態碼 | 錯誤碼 | 前端處理 |
|------------|-------|----------|
| 400 | `MISSING_PARAMETER` | 顯示欄位錯誤 |
| 400 | `INVALID_FORMAT` | 顯示格式要求 |
| 401 | `INVALID_OAUTH_TOKEN` | 提示重新登入 |
| 401 | `INVALID_TOKEN` | 清除 session，導向登入 |
| 401 | `EXPIRED_TOKEN` | 嘗試 refresh token |
| 401 | `REVOKED_TOKEN` | 清除 session，導向登入 |
| 500 | `INTERNAL_SERVER_ERROR` | 顯示通用錯誤 |

---

## 測試策略

### API 模擬 (Mock)

```dart
// test/mocks/mock_api_client.dart
class MockApiClient extends Mock implements ApiClient {}

// 測試範例
void main() {
  late MockApiClient mockApiClient;
  
  setUp(() {
    mockApiClient = MockApiClient();
  });
  
  test('Google 登入成功', () async {
    // Arrange
    final request = GoogleLoginRequest(
      code: 'test_code',
      codeVerifier: 'test_verifier',
    );
    
    final mockResponse = LoginResponse(
      accessToken: 'mock_access_token',
      refreshToken: 'mock_refresh_token',
      tokenType: 'Bearer',
      expiresIn: 3600,
      user: User(
        id: 'test_user_id',
        email: 'test@example.com',
        name: 'Test User',
        provider: AuthProvider.google,
        createdAt: DateTime.now(),
      ),
    );
    
    when(() => mockApiClient.loginWithGoogle(request))
        .thenAnswer((_) async => mockResponse);
    
    // Act
    final response = await mockApiClient.loginWithGoogle(request);
    
    // Assert
    expect(response.accessToken, 'mock_access_token');
    expect(response.user.email, 'test@example.com');
    verify(() => mockApiClient.loginWithGoogle(request)).called(1);
  });
}
```

---

## 總結

### API 端點使用流程

```
1. 登入流程:
   使用者點擊登入 → OAuth 授權 → 呼叫 /auth/login/{provider} → 儲存 token → 導向主頁

2. 自動登入流程:
   應用程式啟動 → 呼叫 /auth/verify → Token 有效 → 自動進入主頁
                                    → Token 無效 → 導向登入頁

3. Token 更新流程:
   API 呼叫 → 401 錯誤 → 攔截器自動呼叫 /auth/refresh → 重試原始請求
                                                      → Refresh 失敗 → 導向登入頁

4. 登出流程:
   使用者點擊登出 → 呼叫 /auth/logout → 清除本地 token → 導向登入頁
```

### 安全考量

1. ✅ **HTTPS Only**: 所有 API 呼叫必須使用 HTTPS
2. ✅ **Token 儲存**: 使用 flutter_secure_storage 加密儲存
3. ✅ **自動 Token 更新**: Dio 攔截器自動處理 token 更新
4. ✅ **請求逾時**: 設定合理的連線逾時時間
5. ✅ **錯誤處理**: 統一錯誤攔截和使用者友善訊息

### 效能優化

1. ✅ **連線池**: Dio 自動管理 HTTP 連線池
2. ✅ **請求快取**: 考慮為 GET 請求加入快取策略
3. ✅ **並行請求**: 使用 `Future.wait` 並行執行獨立請求
4. ✅ **請求取消**: 頁面離開時取消未完成的請求
